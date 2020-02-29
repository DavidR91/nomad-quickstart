job "example" {
  region = "europe"
  datacenters = ["eu-west-2"]
  type = "batch"

  update {
    stagger      = "30s"
    max_parallel = 2
  }

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