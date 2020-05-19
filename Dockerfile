FROM fluent/fluentd:edge-debian

USER root

# Debian set Locale
# tzdataのapt-get時にtimezoneの選択で止まってしまう対策でDEBIAN_FRONTENDを定義する
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
  apt -y install task-japanese locales-all locales && \
  locale-gen ja_JP.UTF-8 && \
  rm -rf /var/lib/apt/lists/*
ENV LC_ALL=ja_JP.UTF-8 \
  LC_CTYPE=ja_JP.UTF-8 \
  LANGUAGE=ja_JP:jp
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

# Debian set TimeZone
ENV TZ=Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

# プラグインで必要となるソフトウェアの導入
RUN apt-get update \
    && apt-get -y install net-tools iproute2 iputils-ping gcc \
    && rm -rf /var/lib/apt/lists/*

# プラグイン導入
RUN gem install fluent-plugin-rewrite-tag-filter \
    && gem install fluent-plugin-google-cloud --no-rdoc --no-ri \
    && gem install fluent-plugin-prometheus --no-rdoc --no-ri \
    && gem install fluent-plugin-elasticsearch --no-rdoc --no-ri \
    && gem install fluent-plugin-cloudwatch-logs --no-rdoc --no-ri \
    && gem install fluent-plugin-slack --no-rdoc --no-ri \
    && gem install fluent-plugin-tail-ex --no-rdoc --no-ri \
    && gem install fluent-plugin-mail --no-rdoc --no-ri \
    && gem install fluent-plugin-forest --no-rdoc --no-ri

COPY fluent.conf /fluentd/etc/
USER fluent
