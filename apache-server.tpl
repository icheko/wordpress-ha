[supervisord]
nodaemon=true
loglevel=error

[program:apache-server]
command=apache2-foreground
autostart=true
autorestart=true
redirect_stderr=true