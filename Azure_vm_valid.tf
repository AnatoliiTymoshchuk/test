

    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = "${var.default_environment_tag}"
    }
}

# Create a random generator for VM names
resource "random_id" "serverName" {
  byte_length = 6
  prefix = "i-"
}

# Create a random generator for VM names
resource "random_id" "osDiskname" {
  byte_length = 6
  prefix = "disk-"
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "${random_id.serverName.hex}"
    location              = "East US"
    resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${random_id.osDiskname.hex}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvm"
        admin_username = "azureuser"
		admin_password = "SuperChocoPass&*SaghJ123!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags {
	    Name        = "${var.vm_name}" 
        environment = "${var.default_environment_tag}"
    }
}

variable "resourcename" {
  default = "terraformResourceGroup"
  description = "Name for resource group to create VM in"
}

variable "vm_name" {
  default = "vmFromTf"
  description = "Name for VM to be created"
}

variable "default_environment_tag" {
  default = "Terraform Demo"
  description = "Default environment tag for the resources of stack"
}
