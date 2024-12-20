resource "random_id" "rnd" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

locals {
  # Create a unique namspace name
  namespace = "${var.project}-${random_id.rnd.dec}"
}

resource "rafay_namespace" "namespace" {
  metadata {
    name    = local.namespace
    project = var.project
  }
  spec {
    drift {
      enabled = true
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.target_cluster_name
      }
    }
    resource_quotas {
      config_maps              = "10"
      cpu_limits               = "4000m"
      memory_limits            = "4096Mi"
      cpu_requests             = "2000m"
      memory_requests          = "2048Mi"
      persistent_volume_claims = "2"
      pods                     = "30"
      replication_controllers  = "5"
      services                 = "10"
      services_load_balancers  = "10"
      services_node_ports      = "10"
      storage_requests         = "1Gi"
    }
  }
}
