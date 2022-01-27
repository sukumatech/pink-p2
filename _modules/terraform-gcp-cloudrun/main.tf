resource google_cloud_run_service default {
  name = var.name
  location = var.location
  project = var.project

  template {
    spec {
      container_concurrency = var.concurrency
      timeout_seconds = var.timeout

      containers {
        image = var.image

        ports {
          container_port = var.port
        }

        resources {
          limits = {
            cpu = "${var.cpus * 1000}m"
            memory = "${var.memory}Mi"
          }
        }                
      }    
    }

    metadata {
      labels = var.labels
      annotations = merge(
        {
          "run.googleapis.com/cpu-throttling" = var.cpu_throttling
          "autoscaling.knative.dev/maxScale" = var.max_instances
          "autoscaling.knative.dev/minScale" = var.min_instances
        }    
      )
    }
  }

  traffic {
    percent = 100
    latest_revision = var.revision == null
    revision_name = var.revision != null ? "${var.name}-${var.revision}" : null
  }
}