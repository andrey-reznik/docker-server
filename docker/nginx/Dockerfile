FROM jwilder/nginx-proxy

ADD ./docker/nginx/scripts/create-certificate.sh /usr/local/bin/mkcert
ADD ./docker/nginx/scripts/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod u+x /usr/local/bin/mkcert
RUN chmod u+x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
