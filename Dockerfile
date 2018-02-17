FROM fluent/fluentd:debian

# 作成者情報
MAINTAINER toshi <toshi@toshi.click>

# Debian set Locale
RUN apt-get update && \
    apt-get -y install locales task-japanese && \
    locale-gen ja_JP.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
ENV LC_ALL=ja_JP.UTF-8 \
    LC_CTYPE=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:jp
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

# Debian set TimeZone
ENV TZ=Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone && \
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# プラグイン導入
RUN gem install fluent-plugin-rewrite-tag-filter && \
    gem install fluent-plugin-secure-forward --no-rdoc --no-ri && \
    gem install fluent-plugin-elasticsearch --no-rdoc --no-ri && \
    gem install fluent-plugin-record-reformer --no-rdoc --no-ri && \
    gem install fluent-plugin-cloudwatch-logs --no-rdoc --no-ri && \
    gem install fluent-plugin-slack --no-rdoc --no-ri && \
    gem install fluent-plugin-rewrite --no-rdoc --no-ri && \
    gem install fluent-plugin-tail-ex --no-rdoc --no-ri

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/
