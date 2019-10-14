output "runner_disk_size" {
  value = var.runner_disk_size
}

output "runner_image" {
  value = var.runner_image
}

output "runner_host" {
  value = data.template_file.runner_host.rendered
}
