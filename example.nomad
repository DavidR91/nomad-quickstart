job "example" {
  region = "europe"
  datacenters = ["eu-west-2"]
  type = "batch"

  group "example" {
    count = 1

    task "test" {
      driver = "exec"

      config {
        command = "echo"
        args    = ["'Hello world'"]
      }
    }
  }
}