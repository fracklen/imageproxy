FROM ubuntu:latest
MAINTAINER Martin Neiiendam mn@lokalebasen.dk
ENV REFRESHED_AT 2014-02-27

RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list

RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-add-repository ppa:brightbox/ruby-ng

RUN apt-get update
RUN apt-get install -y ruby1.9.3 build-essential libpq-dev curl postgresql-client varnish libxml2-dev libxslt-dev
RUN apt-get install -y imagemagick
RUN gem install bundler --no-rdoc --no-ri

RUN curl -L -o /bin/etcdenv "https://gist.github.com/fracklen/56cd1440ed3785aadfdf/raw/92d168d931fe5c4132e7bbbd774177cdce0d9ad9/with_etcd_environment"
RUN chmod +x /bin/etcdenv

ADD Gemfile /var/www/imageproxy/release/Gemfile
ADD Gemfile.lock /var/www/imageproxy/release/Gemfile.lock
RUN cd /var/www/imageproxy/release && bundle install --deployment
RUN mkdir -p /var/www/imageproxy/shared/pids
RUN mkdir -p /var/www/imageproxy/shared/log

ENV BUNDLE_GEMFILE /var/www/imageproxy/release/Gemfile
ADD build.tar /var/www/imageproxy/release

ENV ETCD_URL http://192.168.3.8:5001
ENV ETCD_ENV imageproxy
ENV RAILS_ENV production
ENV PORT 8080

WORKDIR /var/www/imageproxy/release
RUN bundle install --deployment --quiet

EXPOSE 8080

# ENTRYPOINT ["etcdenv"]

CMD ["sh", "script/start.sh"]
