[supervisord]
nodaemon=true
loglevel=debug

[program:rsync-client]
command=/usr/local/bin/rsync-client.sh {{RSYNC_WORDPRESS_MASTER}}
autostart=true
autorestart=true
redirect_stderr=true
startsecs=10
startretries=17280