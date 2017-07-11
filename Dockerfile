FROM rodrigozc/consul-filebeat-agents:latest
MAINTAINER Rodrigo Zampieri Castilho <rodrigo.zampieri@gmail.com>

ENV NODEJS_VERSION "8"
ENV KONG_VERSION "0.10.3"
ENV KONG_DASHBOARD_VERSION "v2"

ENV APPLICATION_DEFAULT_NAME "kong-api-gateway"

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl libpcre3 procps perl wget netcat-openbsd \
    && wget --no-check-certificate https://github.com/Mashape/kong/releases/download/${KONG_VERSION}/kong-${KONG_VERSION}.jessie_all.deb \
    && dpkg -i kong-${KONG_VERSION}.jessie_all.deb \
    && rm kong-${KONG_VERSION}.jessie_all.deb \
    && wget --no-check-certificate -O nodesource_setup.sh https://deb.nodesource.com/setup_${NODEJS_VERSION}.x \
    && chmod +x nodesource_setup.sh \
    && ./nodesource_setup.sh \
    && rm nodesource_setup.sh \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g kong-dashboard@${KONG_DASHBOARD_VERSION} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*

ADD consul-template/1-consul-template.list /etc/consul-template/
ADD consul/service.ctmpl /etc/consul/
ADD consul/service.json /etc/consul/
ADD run/kong.sh /docker/run/
ADD run/kong-dashboard.sh /docker/run/
