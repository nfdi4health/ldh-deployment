# NFDI4Health LDH Deployment

Deployment instructions and resources for an NFDI4Health Local Data Hup.


## Disclaimer

This project and it's components are subject to heavy development and are therefor considered *[alpha][wiki-alpha]*. 
Don't use this deployment method for production purposes **yet** as you might be force to do a fresh installation in 
the future which might result in the loss of uploaded data. If you however want to try and participate in the 
development of the software you are hereby highly encouraged to do so. Feel free to create bug reports and suggestions 
in the [issue tracker][project-issues]. 


## Prerequisites

### Docker

* Docker must be installed on the system. Please follow the [official installation instructions][docker-install]
* Also consider allowing your non-root Linux user to use docker by adding it to the docker group
  (see [docker docs][docker-ugroup]) otherwise only a root user will be able to execute docker


## Usage

For a first and simple glimpse of what an ldh will look like follow the steps below.

* Clone this repository

```bash
git clone https://github.com/nfdi4health/ldh-deployment.git
cd ldh-deployment
```

* Copy `docker-compose.env.tpl` to `docker-compose.env` and replace `<some-password>` with a password

```bash
cat docker-compose.env.tpl \
  | sed "s|<db-password>|$(openssl rand -base64 21)|" \
  | sed "s|<root-password>|$(openssl rand -base64 21)|" \
  > docker-compose.env
```

* Use compose to startup the LDH

```
docker compose up -d
```

[wiki-alpha]: https://en.wikipedia.org/wiki/Software_release_life_cycle#Alpha
[project-issues]: https://github.com/nfdi4health/ldh-deployment/issues
[docker-install]: https://docs.docker.com/get-docker/
[docker-ugroup]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
