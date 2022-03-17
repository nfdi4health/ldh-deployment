# NFDI4Health LAP Deployment

Deployment instructions and resources for an NFDI4Health Local Access Point.

## Prerequisites

### Docker

* Docker must be installed on the system. Please follow the [official installation instructions][docker-install]
* Also consider allowing your non-root Linux user to use docker by adding it to the docker group
  (see [docker docs][docker-ugroup]) otherwise only a root user will be able to execute docker
* Login to GitHub Container Registry [using your GitHub Account][ghcr-auth] 

## Usage

For a first and simple glimpse of what an lap will look like follow the steps below.

* Clone this repository

```bash
git clone https://github.com/knoppiks/n4h-lap-deployment.git
cd n4h-lap-deployment
```

* Copy `docker-compose.env.tpl` to `docker-compose.env` and replace `<some-password>` with a password

```bash
cat docker-compose.env.tpl \
  | sed "s|<db-password>|$(openssl rand -base64 21)|" \
  | sed "s|<root-password>|$(openssl rand -base64 21)|" \
  > docker-compose.env
```

* Use compose to startup the LAP

```
docker compose up -d
```

[docker-install]: https://docs.docker.com/get-docker/
[docker-ugroup]: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
[ghcr-auth]: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry