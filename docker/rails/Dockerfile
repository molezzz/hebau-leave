FROM ruby:2.5.5-alpine

LABEL maintainer="molezz <molezzz@gmail.com>" \
      version="1.0"

ENV INSTALL_PATH /var/leave
RUN set -ex \
	\
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
	&& apk add --no-cache --virtual .ruby-builddeps \
    build-base \
		autoconf \
		bison \
		bzip2 \
		bzip2-dev \
		ca-certificates \
		coreutils \
		dpkg-dev dpkg \
		gcc \
		gdbm-dev \
		glib-dev \
		libc-dev \
		libffi-dev \
		libxml2-dev \
		libxslt-dev \
		linux-headers \
		make \
		ncurses-dev \
		openssl \
		openssl-dev \
		procps \
		readline-dev \
		ruby \
		tar \
		xz \
		yaml-dev \
		zlib-dev \
		python \
	\
  && apk add --no-cache bash nodejs mariadb-dev npm yarn git\
  && mkdir -p $INSTALL_PATH \
  && gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
  && gem update --system \
  && gem uninstall bundler \
  && gem install bundler

WORKDIR $INSTALL_PATH

COPY Gemfile  ${INSTALL_PATH}/Gemfile
COPY Gemfile.lock ${INSTALL_PATH}/Gemfile.lock

ENV BUNDLE_GEMFILE=${INSTALL_PATH}/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle
RUN RAILS_ENV=production bundle install

COPY package.json ${INSTALL_PATH}/package.json
COPY yarn.lock ${INSTALL_PATH}/yarn.lock
RUN npm install -g webpack-cli --registry='https://registry.npm.taobao.org'
RUN yarn config set registry 'https://registry.npm.taobao.org' \
  && yarn add -D webpack-cli \
	&& yarn install

# COPY . ${INSTALL_PATH}
# COPY . .

RUN apk del --no-network .ruby-builddeps
# Expose a volume so that nginx will be able to read in assets in production.
# VOLUME ["$INSTALL_PATH/public"]
# VOLUME ["$INSTALL_PATH/node_modules"]

EXPOSE 3000
