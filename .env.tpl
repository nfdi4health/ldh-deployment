COMPOSE_PROJECT_NAME=n4h

# SEEK port, visible to Docker-Host / localhost:$SEEK_PORT
SEEK_PORT=3000

# Translation of basic SEEK ressource terms
DHO_TERMS=standard

# Might be changed to a fixed version in productive enviromnent, e.g
# LDH_RELEASE=v0.2.3
LDH_RELEASE=latest

# Change to nginx.conf.https if called via https
NGINX_CONF=nginx.conf.http
