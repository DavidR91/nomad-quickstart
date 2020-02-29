if [ -f /var/tls/nomad-ca.pem ]; then
    echo "TLS already configured, skipping"
    exit
fi

echo "Configuring mTLS"
cd /var/tls
cfssl print-defaults csr | cfssl gencert -initca - | cfssljson -bare nomad-ca

echo '{}' | cfssl gencert -ca=nomad-ca.pem -ca-key=nomad-ca-key.pem -config=cfssl.json \
    -hostname="server.${REGION_NAME_ENV}.nomad,localhost,127.0.0.1" - | cfssljson -bare server

echo '{}' | cfssl gencert -ca=nomad-ca.pem -ca-key=nomad-ca-key.pem -config=cfssl.json \
    -hostname="client.${REGION_NAME_ENV}.nomad,localhost,127.0.0.1" - | cfssljson -bare client

echo '{}' | cfssl gencert -ca=nomad-ca.pem -ca-key=nomad-ca-key.pem -profile=client \
    - | cfssljson -bare cli

echo -e 'tls {\n  http = true\n  rpc  = true\n\n  ca_file   = "/var/tls/nomad-ca.pem"\n  cert_file = "/var/tls/server.pem"\n  key_file  = "/var/tls/server-key.pem"\n\n  verify_server_hostname = true\n  verify_https_client    = false\n}' >> /etc/nomad.d/nomad.hcl

echo "**** CERTIFICATE AUTHORITY: ****"
less /var/tls/nomad-ca.pem

echo "**** CLIENT CERTIFICATE: ****"
less /var/tls/client.pem

echo "**** CLIENT KEY: ****"
less /var/tls/client-key.pem

echo "**** CLI CERTIFICATE: ****"
less /var/tls/cli.pem

echo "**** CLI KEY: ****"
less /var/tls/cli-key.pem