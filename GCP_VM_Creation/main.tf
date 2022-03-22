resource "google_service_account" "default" {
  account_id   = "compute-terraform"
  display_name = "Terraform Compute service account"
}

resource "google_compute_instance" "terraform-vm" {
  name         = "terraform-vm"
  machine_type = "f1.micro"
  zone         = "europe-west1"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}