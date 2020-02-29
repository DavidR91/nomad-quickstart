FROM frolvlad/alpine-glibc

ARG DATACENTER_NAME=eu-west-2
ENV DATACENTER_NAME_ENV="${DATACENTER_NAME}"

ARG REGION_NAME=europe
ENV REGION_NAME_ENV="${REGION_NAME}"

RUN apk add wget curl unzip \
&& wget https://releases.hashicorp.com/nomad/0.10.4/nomad_0.10.4_linux_amd64.zip -O nomad.zip \
&& unzip nomad.zip -d /bin \
&& chmod +x /bin/nomad

RUN mkdir --parents /opt/nomad \
&& mkdir --parents /etc/nomad.d \
&& chmod 700 /etc/nomad.d \
&& touch /etc/nomad.d/nomad.hcl \
&& echo "datacenter=\"${DATACENTER_NAME_ENV}\"" >> /etc/nomad.d/nomad.hcl \
&& echo "region=\"${REGION_NAME_ENV}\"" >> /etc/nomad.d/nomad.hcl \
&& echo 'data_dir = "/opt/nomad"' >> /etc/nomad.d/nomad.hcl

ADD client.hcl /etc/nomad.d/client.hcl

RUN mkdir --parents /var/tls
ADD ca-key.pem /var/tls/ca-key.pem
ADD client-key.pem /var/tls/client-key.pem
ADD client.pem /var/tls/client.pem

RUN cat /var/tls/ca-key.pem >> /etc/ssl/certs/ca-certificates.crt \
&& update-ca-certificates

VOLUME /opt/nomad
VOLUME /var/tls

CMD nomad agent -config /etc/nomad.d