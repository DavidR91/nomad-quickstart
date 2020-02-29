if [ -f /var/acl/key ]; then
    echo "ACL already configured, skipping"
    exit
fi

nomad acl bootstrap -ca-cert=/var/tls/nomad-ca.pem -client-cert=/var/tls/cli.pem -client-key=/var/tls/cli-key.pem -address=https://127.0.0.1:4646 > /var/acl/key
less /var/acl/key