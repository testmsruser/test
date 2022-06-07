#Define Variables for Platform
vsphere_user        = "Sakamoto@vsphere.local" #vsphereのユーザー名
vsphere_password    = "MSRkiji1"                  #vsphereのパスワード
vcenter_server      = "192.168.11.160"          	#vCenterのFQDN/IPアドレス
vsphere_datacenter  = "Datacenter"                  #vsphereのデータセンター
vsphere_datastore   = "11.152 datastore 1.82TB"     #vsphereのデータストア
vsphere_cluster     = "Cluster"                     #vsphereのクラスター
vsphere_network     = "VM Network"                  #vsphereのネットワーク
#vsphere_network     = "DPortGroup(VMGuest-Net1)"

#Define Variables for Virtual Machines
#vsphere_template_name = "Ubuntu22.04_template"     #プロビジョニングするテンプレート
vsphere_template_name = "WinSrvAD01"
prov_vm_num         = 1                             #プロビジョニングする仮想マシンの数
prov_vmname_prefix  = "WinSrvEFI2"                   #プロビジョニングする仮想マシンの接頭語
prov_cpu_num        = 2                             #プロビジョニングする仮想マシンのCPUの数
prov_mem_num        = 4096                          #プロビジョニングする仮想マシンのメモリのMB
