log_level = "DEBUG"
data_dir = "/opt/nomad"

client {
  enabled = true
  servers = ["127.0.0.1:32800"]
}

tls {
  http = true
  rpc  = true

  ca_file   = "/var/tls/ca-key.pem"
  cert_file = "/var/tls/client.pem"
  key_file  = "/var/tls/client-key.pem"

  # For testing/experimentation it's unlikely your hostname is going to be valid
  verify_server_hostname = false

  verify_https_client    = true
}