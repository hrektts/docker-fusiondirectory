FROM hrektts/ubuntu:16.04.20160525
MAINTAINER mps299792458@gmail.com

ENV NGINX_VERSION 1.10.0-0ubuntu0.16.04.2
ENV FUSIONDIRECTORY_VERSION 1.0.8.8-3ubuntu2
ENV LDAP_ROOT admin

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 \
    --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
 && echo "deb http://nginx.org/packages/ubuntu xenial main" \
    > /etc/apt/sources.list.d/nginx-stable-xenial.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      nginx=${NGINX_VERSION} \
      fusiondirectory=${FUSIONDIRECTORY_VERSION} \
      fusiondirectory-plugin-autofs \
      fusiondirectory-plugin-certificates \
      fusiondirectory-plugin-gpg \
      fusiondirectory-plugin-ldapdump \
      fusiondirectory-plugin-ldapmanager \
      fusiondirectory-plugin-mail \
      fusiondirectory-plugin-personal \
      fusiondirectory-plugin-ssh \
      fusiondirectory-plugin-sudo \
      fusiondirectory-plugin-systems \
      fusiondirectory-plugin-weblink \
      fusiondirectory-plugin-webservice \
      fusiondirectory-webservice-shell \
      php-mdb2 \
      php7.0-mbstring \
 && rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

RUN export TARGET=/etc/php/7.0/fpm/php.ini \
 && sed -i -e "s:^;\(opcache.enable\) *=.*$:\1=1:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.enable_cli\) *=.*$:\1=0:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.memory_consumption\) *=.*$:\1=1024:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.max_accelerated_files\) *=.*$:\1=65407:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.validate_timestamps\) *=.*$:\1=0:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.revalidate_path\) *=.*$:\1=1:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.error_log\) *=.*$:\1=/dev/null:" ${TARGET} \
 && sed -i -e "s:^;\(opcache.log_verbosity_level\) *=.*$:\1=1:" ${TARGET} \
 && mkdir -p /run/php \
 && unset TARGET

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
COPY cmd.sh /sbin/cmd.sh
RUN chmod 755 /sbin/cmd.sh
COPY default /etc/nginx/sites-available/

EXPOSE 80 443
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/sbin/cmd.sh"]
