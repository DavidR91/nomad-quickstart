FROM frolvlad/alpine-glibc

EXPOSE 4646 4647

ARG DATACENTER_NAME=eu-west-2
ENV DATACENTER_NAME_ENV="${DATACENTER_NAME}"

ARG REGION_NAME=europe
ENV REGION_NAME_ENV="${REGION_NAME}"

ARG BOOTSTRAP_EXPECT=1
ENV BOOTSTRAP_EXPECT_ENV="${BOOTSTRAP_EXPECT}"

RUN apk add wget curl unzip \
&& wget https://releases.hashicorp.com/nomad/0.10.4/nomad_0.10.4_linux_amd64.zip -O nomad.zip \
&& unzip nomad.zip -d /bin \
&& chmod +x /bin/nomad

RUN curl -s -L -o /bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
&& curl -s -L -o /bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 \
&& chmod +x /bin/cfssl*

RUN mkdir --parents /opt/nomad \
&& mkdir --parents /etc/nomad.d \
&& chmod 700 /etc/nomad.d \
&& touch /etc/nomad.d/nomad.hcl \
&& echo "datacenter=\"${DATACENTER_NAME_ENV}\"" >> /etc/nomad.d/nomad.hcl \
&& echo "region=\"${REGION_NAME_ENV}\"" >> /etc/nomad.d/nomad.hcl \
&& echo 'data_dir = "/opt/nomad"' >> /etc/nomad.d/nomad.hcl

RUN echo -e "server {\nenabled = true\nbootstrap_expect = ${BOOTSTRAP_EXPECT_ENV}\nauthoritative_region=\"${REGION_NAME_ENV}\"}\nacl {\nenabled = true\n}" > /etc/nomad.d/server.hcl

RUN mkdir --parents /var/tls \
&& mkdir --parents /var/acl

ADD acl.sh /var/acl/acl.sh
ADD mTLS.sh /var/tls/mTLS.sh
ADD cfssl.json /var/tls/cfssl.json

RUN chmod +x /var/tls/mTLS.sh \
&& chmod +x /var/acl/acl.sh

VOLUME /opt/nomad
VOLUME /var/tls
VOLUME /var/acl

CMD ./var/tls/mTLS.sh ;  (./var/acl/acl.sh) & nomad agent -config /etc/nomad.d