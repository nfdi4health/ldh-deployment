# NFDI4Health LDH Deployment

Deployment instructions and resources for an NFDI4Health Local Data Hub.


## Disclaimer

This project and it's components are subject to heavy development. 
However, if you wish to participate in the development of the software, you are strongly encouraged to do so. Feel free to submit bug reports and suggestions 
in the [issue tracker][project-issues]. 


## Prerequisites

### Docker

* Docker must be installed on the system (Windows/Linux/MacOS). Please follow the [official installation instructions][docker-install]
* `docker-compose` is deprecated; please ensure that you can use `docker compose` (compose beeing option for docker)
* You need a compose version v2 - test with `docker compose version`
* LDH works perfectly even with root-less docker; there is no need to have root right on the host
* Consider allowing your non-root Linux user to use docker by adding to the docker group
  (see [docker docs][docker-ugroup]) otherwise only a root user will be able to execute docker


## Download and Install

For a first and simple glimpse of what an LDH will look like follow the steps below.

* Clone this repository

```bash
git clone https://github.com/nfdi4health/ldh-deployment.git
cd ldh-deployment

```

## Configuration
* Basic configuration is done in `.env`. Copy .env.tpl to .env and change variables in .env as you like
```bash
cp .env.tpl .env

```
    * COMPOSE_PROJECT_NAME is a prefix for all container names; useful if you have multiple instances of LDH on your host; e.g. N4H. Default is the name of th
    * SEEK_PORT is the port you will reach LDH on this host. Default is 3000; e.g http://localhost:3000
    * DHO_TERMS is the basename of an file overriding the standard term in the user interface - useful e.g. if you prefer "Sponsor" over "Programme" oder "Trial Project" instead of "Project" as in included "clinical-trials.en.yml"
    * LDH_RELEASE is the relase to load, e.g. v0.2.2. Default is latest.

* Database configuration is specified in `docker-compose.env`. This is created by copying `docker-compose.env.tpl` to `docker-compose.env` and replace `<some-password>` with a password-  either manually or using the openssl command, e.g.

```bash
cat docker-compose.env.tpl \
  | sed "s|<db-password>|$(openssl rand -base64 21)|" \
  | sed "s|<root-password>|$(openssl rand -base64 21)|" \
  > docker-compose.env

```

* Create Volumes (internal Volumes are created automatically) using prefix in `COMPOSE_PROJECT_NAME` in `.env`

```bash
source .env
docker volume create ${COMPOSE_PROJECT_NAME}_filestore
docker volume create ${COMPOSE_PROJECT_NAME}_db

```

## Startup the LDH

```
docker compose up -d

```
Wait a minute and direct browser to http://localhost:3000 to reach signup page.
If you get a "502 Bad Gateway" wait a litte longer.
You can watch the logs with

```
docker compose logs -f seek
```


## Backup & Restore
There is a simple backup script `backup.sh` include which will dump your database and filestore to a backup directory. 
You can configure the number of copies to be held in backup.

```
bash backup.sh

```

You may destroy all data, including passwords. The only thing you need is to keep a valid copy of filestore and database.
To restore all, startup the LDH and type 

```
bash restore.sh <your database.sql.gz from backup> <your filestore.tar.gz from backup>
```

## Update image

Follow "Upgrading between versions" in https://docs.seek4science.org/tech/docker/docker-compose.html
But use LDH image name "ghcr.io/nfdi4health/ldh:latest" (or release like ghcr.io/nfdi4health/ldh:v0.2.1, see https://github.com/nfdi4health/ldh/releases) instead of "fairdom/seek:1.14".

## Destroy all

* If you like to completely destroy your testing installation including data and password

```bash
source .env
docker compose down -v
docker volume rm ${COMPOSE_PROJECT_NAME}_filestore ${COMPOSE_PROJECT_NAME}_db
rm docker-compose.env

```

## Go further
The above working setting can be altered in many ways:
* like to use an undockered, external mysql database? (configure `docker-compose.env`; remove db from `docker-compose.yml`)
* like to put the filestore on external undockered file space? (use bind mounts)
* like to use Container-Orchestration like Kubernetes?
* want to expose your LDH to the internet - ask you local sysadmin!
* Backup/Restore can be based on volumes too
* see https://docs.docker.com/ from more



[project-issues]: https://github.com/nfdi4health/ldh-deployment/issues
[docker-install]: https://docs.docker.com/get-docker/
[docker-ugroup]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
