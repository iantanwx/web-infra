concurrent = ${runners_concurrent}
check_interval = 0

[[runners]]
  name = "${runners_name}"
  url = "${gitlab_url}"
  token = "${runners_token}"
  executor = "${runners_executor}"
  environment = ${runners_environment_vars}
  pre_build_script = "${runners_pre_build_script}"
  post_build_script = "${runners_post_build_script}"
  pre_clone_script = "${runners_pre_clone_script}"
  request_concurrency = ${runners_request_concurrency}
  output_limit = ${runners_output_limit}
  limit = ${runners_limit}
  [runners.docker]
    tls_verify = false
    image = "${runners_image}"
    privileged = ${runners_privileged}
    disable_cache = false
    volumes = ["/cache"${runners_additional_volumes}]
    shm_size = ${runners_shm_size}
    pull_policy = "${runners_pull_policy}"
  [runners.docker.tmpfs]
    ${runners_volumes_tmpfs}
  [runners.docker.services_tmpfs]
    ${runners_services_volumes_tmpfs}
