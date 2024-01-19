# NFDI4Health LDH Deployment

Deployment instructions and resources for an NFDI4Health Local Data Hub.


## Disclaimer

This project and it's components are subject to heavy development. 
However, if you wish to participate in the development of the software, you are strongly encouraged to do so. Feel free to submit bug reports and suggestions 
in the [issue tracker][project-issues]. 


## Prerequisites

### Docker

* Docker must be installed on the system (Windows/Linux/MacOS). Please follow the [official installation instructions][docker-install]
* `docker-compose` is used instead of `docker compose` for compatibility with older installations
* You need a compose version v2 - test with `docker-compose version`
* Consider allowing your non-root Linux user to use docker by adding to the docker group
  (see [docker docs][docker-ugroup]) otherwise only a root user will be able to execute docker


## Usage

For a first and simple glimpse of what an LDH will look like follow the steps below.

* Clone this repository

```bash
git clone https://github.com/nfdi4health/ldh-deployment.git
cd ldh-deployment

```

## Configuration
* Basic configuration is done in `.env`. You have to change nothing now. 
    * COMPOSE_PROJECT_NAME is a prefix for all container names; useful if you have multiple instances of LDH on your host
    * SEEK_PORT is the port you will reach LDH on this host, standard would be localhost:3000
    * DB_PORT is the port of underlying mysql database; this is optional

* Database configuration is specified in `docker-compose.env`. This is created by copying `docker-compose.env.tpl` to `docker-compose.env` and replace `<some-password>` with a password-  either manually or using the openssl command, e.g.

```bash
cat docker-compose.env.tpl \
  | sed "s|<db-password>|$(openssl rand -base64 21)|" \
  | sed "s|<root-password>|$(openssl rand -base64 21)|" \
  > docker-compose.env

```

* Create Volumes (internal Volumes are created automatically). The prefix should match the value of `COMPOSE_PROJECT_NAME` in `.env`

```bash
docker volume create n4h_filestore
docker volume create n4h_db

```

* Startup the LDH

```
docker-compose up -d

```
Wait a minute and direct browser to http://localhost:3000 to reach signup page.
If you get a "502 Bad Gateway" wait a litte longer.

## Destroy all

* If you like to completely destroy your testing installation including data and password

```bash
docker-compose down -v
docker volume rm n4h-filestore n4h-db
rm docker-compose.env

```
  
[project-issues]: https://github.com/nfdi4health/ldh-deployment/issues
[docker-install]: https://docs.docker.com/get-docker/
[docker-ugroup]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
