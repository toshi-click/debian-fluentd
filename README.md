# debian-fluentd-root
Extension of Debian based Fluentd.

Introduced several plugins.  

I changed the executing user to root.  

## How To
```
FROM toshiclick/debian-fluentd-root:latest

# Please COPY your fluent.conf
COPY fluent.conf /fluentd/etc/
# Explicitly attach execute privilege to entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
```
