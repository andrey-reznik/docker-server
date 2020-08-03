#!/usr/bin/env bash

TPL_DIR="/app/templates"

docker-gen "$TPL_DIR/makecerts.tmpl" "$TPL_DIR/makecerts.sh"
chmod u+x "$TPL_DIR/makecerts.sh"
chown 1000 "$TPL_DIR/makecerts.sh"

"$TPL_DIR/makecerts.sh"
forego start -r