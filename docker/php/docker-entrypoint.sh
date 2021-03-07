#!/bin/bash
set -e

# Change uid and gid of node user so it matches ownership of current dir
if [ "$MAP_NODE_UID" != "no" ]; then
    if [ ! -d "$MAP_NODE_UID" ]; then
        MAP_NODE_UID=$PWD
    fi

    uid=$(stat -c '%u' "$MAP_NODE_UID")
    gid=$(stat -c '%g' "$MAP_NODE_UID")

    echo "docker ---> UID = $uid / GID = $gid"

    export USER=docker

    usermod -u $uid docker 2> /dev/null && {
      groupmod -g $gid docker 2> /dev/null || usermod -a -G $gid docker
    }
fi

echo "**** GOSU docker $@ ..."

exec gosu docker "$@"


if [[ "$originalArgOne" == docker* ]] && [ "$(id -u)" = '0' ]; then
    if [ "$originalArgOne" = 'docker' ];
        then chown -R docker /var/www
    fi
    # make sure we can write to stdout and stderr as "docker"
    # (for our "initdb" code later; see " — logpath" below)
    chown --dereference docker "/proc/$$/fd/1" "/proc/$$/fd/2" || :
    exec gosu docker "$BASH_SOURCE" "$@"
fi
