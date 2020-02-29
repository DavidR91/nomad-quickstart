if [ -f /var/acl/configured ]; then
    echo "ACL already configured, skipping"
    exit
fi


until nomad acl bootstrap -ca-cert=/var/tls/nomad-ca.pem -client-cert=/var/tls/cli.pem -client-key=/var/tls/cli-key.pem -address=https://127.0.0.1:4646
do
	echo "Can't configure ACL yet, waiting..."
	sleep 1
done

touch /var/acl/configured