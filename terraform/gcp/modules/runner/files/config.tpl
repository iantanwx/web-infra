concurrent = ${concurrency}
check_interval = 0

[[runners]]
  url = "${url}"
  token = "${token}"
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "${runner_image}"
    privileged = ${privileged}
    disable_cache = false
    volumes = ["/cache", "/etc/creds:/etc/creds:rw"]
