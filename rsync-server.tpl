[supervisord]
nodaemon=true

[program:rsync-server]
command=rsync --daemon --no-detach
autostart=true
autorestart=true
stderr_logfile=/var/log/rsync.err.log
stdout_logfile=/var/log/rsync.out.log