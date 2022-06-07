#Define Variables for Platform
variable "vsphere_user" {}           #vsphereのユーザー名
variable "vsphere_password" {}       #vsphereのパスワード
variable "vcenter_server" {}         #vCenterのFQDN/IPアドレス
variable "vsphere_datacenter" {}     #vsphereのデータセンター
variable "vsphere_datastore" {}      #vsphereのデータストア
variable "vsphere_cluster" {}        #vsphereのクラスター
variable "vsphere_network" {}        #vsphereのネットワーク

#Define Variables for Virtual Machines
variable "vsphere_template_name" {}  #プロビジョニングするテンプレート
variable "prov_vm_num" {}            #プロビジョニングする仮想マシンの数
variable "prov_vmname_prefix" {}     #プロビジョニングする仮想マシンの接頭語
variable "prov_cpu_num" {}           #プロビジョニングする仮想マシンのCPUの数
variable "prov_mem_num" {}           #プロビジョニングする仮想マシンのメモリのMB


#Provider
provider "vsphere" {
  user                   = var.vsphere_user
  password               = var.vsphere_password
  vsphere_server         = var.vcenter_server
  allow_unverified_ssl   = true
}

#Data
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Resource
resource "vsphere_virtual_machine" "vm" {
  count            = var.prov_vm_num
#   name            = "${var.prov_vmname_prefix}${format("%03d",count.index+1)}"
   name            = "${var.prov_vmname_prefix}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

#Resource for VM Specs
  num_cpus = var.prov_cpu_num
  memory   = var.prov_mem_num
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  firmware = "efi"

#  firmware = var.vsphere_vm_firmware #3行追加
#  variable "vsphere_vm_firmware" {}
#  vsphere_vm_firmware = "efi"
  
#  efi_secure_boot_enabled = "true"  #追加
  
  network_interface {
    network_id   = data.vsphere_network.network.id
#    adapter_type = "VM Network"
	adapter_type = "e1000"
  }

#Resource for Disks
  disk {
    label            = "disk1"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
      customize{
#		windows_sysprep_text = file("${path.module}/sysprep.xml")
        windows_options {
#          computer_name = "${var.prov_vmname_prefix}${format("%03d",count.index+1)}"
		    computer_name = "${var.prov_vmname_prefix}"
		}
#		linux_options {
#        host_name = "msruser-virtual-machine"
#        domain    = ""
#      }
        network_interface{
			ipv4_address = "192.168.11.192"
			ipv4_netmask = "24"
		} #テンプレートと同一のNIC枚数
	  }
  }
}