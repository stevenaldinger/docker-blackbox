# ======= [START] create BlackBox deb for ubuntu installation with apt ======= #
FROM cdrx/fpm-ubuntu:18.04 as deb_builder

ARG HOME="/root"
ARG BLACKBOX_GIT_CLONE_URL="https://github.com/StackExchange/blackbox.git"
ARG BLACKBOX_GIT_CLONE_DIR="/tmp/blackbox"
ARG APT_GET_BUILD_DEPENDENCIES="\
 git \
"

ENV \
 GPG="gpg2" \
 HOME="${HOME}"

RUN apt-get update \
 && apt-get install -y ${APT_GET_BUILD_DEPENDENCIES} \
 && git clone "${BLACKBOX_GIT_CLONE_URL}" "${BLACKBOX_GIT_CLONE_DIR}" \
 && make -C "${BLACKBOX_GIT_CLONE_DIR}" packages-deb \
 && rm -rf "${BLACKBOX_GIT_CLONE_DIR}" \
 && apt-get remove --purge -y ${APT_GET_BUILD_DEPENDENCIES} \
 && apt-get clean \
 && rm -rf "/var/lib/apt/lists/*" "/tmp/*" "/var/tmp/*"
# ======== [END] create BlackBox deb for ubuntu installation with apt ======== #

# ======================== [START] main BlackBox image ======================= #
FROM ubuntu:18.04

ARG HOME="/root"
ARG BLACKBOX_DEB_FILE_NAME="stack-blackbox_*_all.deb"
ARG BLACKBOX_BUILDER_FILE_PATH="${HOME}/debbuild-stack_blackbox/${BLACKBOX_DEB_FILE_NAME}"
ARG BLACKBOX_IMAGE_DEB_PATH="/tmp/${BLACKBOX_DEB_FILE_NAME}"
ARG APT_GET_DEPENDENCIES="\
 git \
 gnupg-agent \
 gnupg2 \
 vim \
 ${BLACKBOX_IMAGE_DEB_PATH} \
"

ENV \
 GPG="gpg2" \
 HOME="${HOME}"

COPY --from=deb_builder \
 "${BLACKBOX_BUILDER_FILE_PATH}" \
 "${BLACKBOX_IMAGE_DEB_PATH}"

RUN apt-get update \
 && apt-get install -y ${APT_GET_DEPENDENCIES} \
 && apt-get clean \
 && rm -rf "/var/lib/apt/lists/*" "/tmp/*" "/var/tmp/*"

WORKDIR /repo

COPY bashrc /root/.bashrc

COPY scripts/container_init.sh /usr/local/bin/container_init.sh

ENTRYPOINT ["/usr/local/bin/container_init.sh"]

CMD []
# ========================= [END] main BlackBox image ======================== #
