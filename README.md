# BlackBox Docker Image

This allows you to mount a git repo as a volume in the container and manage it with [BlackBox](https://github.com/StackExchange/blackbox/) and your host machine's `~/.ssh` and `~/.gnupg` directories.

## Building docker image

In the [Makefile](Makefile) there are commands for both building and pushing the image to [DockerHub](https://hub.docker.com/).

```sh
# Builds an image named 'stevenaldinger/docker-blackbox:latest'
make build \
  dockerhub_user='stevenaldinger' \
  version="latest"
```

```sh
# Pushes an image to 'stevenaldinger/docker-blackbox:latest'
make push \
  dockerhub_user='stevenaldinger' \
  version="latest"
```

## Usage

In general, when you run this docker image it will set your git user name/email, make sure the gpg agent is running, and create a directory named `.blackbox` if it doesn't already exist in the directory mounted at `/repo` to store your [BlackBox config](https://github.com/StackExchange/blackbox#enabling-blackbox-for-a-repo) in. Then it will run any command you pass in.

### Example Docker Run

1. `cd` into the git repo you want to manage with the image.

Then run the container as a daemon:

```sh
docker run --rm --name blackbox \
  -e GIT_USER_NAME="$(git config --get user.name)" \
  -e GIT_USER_EMAIL="$(git config --get user.email)" \
  -v $(pwd)/:/repo/ \
  -v "$HOME/.ssh":/root/.ssh \
  -v "$HOME/.gnupg":/root/.gnupg \
  -d stevenaldinger/docker-blackbox:latest \
  tail -f /dev/null
```

2. `cd` into [docker-blackbox/examples/](docker-blackbox/examples/)
3. Run [./01.initialize-repo.sh](examples/01.initialize-repo.sh) script
4. Export your gpg key email address:
```sh
export GPG_KEY_EMAIL_ADDRESS='me@stevenaldinger.com'
```
5. Run [./02.add-admin.sh](examples/02.add-admin.sh) to add yourself as a `BlackBox` admin.
6. Run [./03.create-sensitive-file.sh](examples/03.create-sensitive-file.sh) to create a `.env` file.
7. Run [./04.cat-sensitive-file.sh](examples/04.cat-sensitive-file.sh) to view the encrypted `.env` file.
8. Run [./05.edit-sensitive-file.sh](examples/05.edit-sensitive-file.sh) to edit the encrypted `.env` file.
9. Run `docker kill blackbox` to finish up.

### Example Usage

The [docker-compose.yml](docker-compose.yml) configuration runs `tail -f /dev/null` inside the container to keep it running and then the example files can be used to execute `BlackBox` commands inside the container.

For an example of how this [image](https://hub.docker.com/r/stevenaldinger/docker-blackbox/tags/) works:

1. Set some important environment variables:

```sh
# used in the docker-compose.yml file
export GIT_USER_EMAIL="stevenaldinger@gmail.com"
export GIT_USER_NAME="Steven Aldinger"
# used in some of the example scripts
export GPG_KEY_EMAIL_ADDRESS='me@stevenaldinger.com'
```

2. Run `docker-compose up -d`
  * runs a `stevenaldinger/docker-blackbox:latest` container named `blackbox`
  * creates a new directory `./example-repo` on the host machine for usage the example scripts

3. Run through each script in order in the [examples/](examples/) directory.

#### Example Scripts

A directory of example scripts can be found at [examples/](examples/) and include:

1. [Initializing a new repo with BlackBox](examples/01.initialize-repo.sh)
2. [Adding a BlackBox admin](examples/02.add-admin.sh)
3. [Creating a sensitive .env file and encrypting it](examples/03.create-sensitive-file.sh)
4. [Viewing the encrypted .env file](examples/04.cat-sensitive-file.sh)
5. [Editing the encrypted .env file](examples/05.edit-sensitive-file.sh)
6. [Leaving the .env file temporarily decrypted](examples/06.edit-sensitive-file-leave-decrypted.sh)
7. [Re-encrypt the .env file](examples/07.edit-sensitive-file-reencrypt.sh)
8. [Removing sensitive file from BlackBox](examples/08.deregister-sensitive-file.sh)
