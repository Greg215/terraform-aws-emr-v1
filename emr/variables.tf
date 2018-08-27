#----------variable for emr------

variable "names" {
  default = ["emr-cluster"]
}

variable "worker_count" {
  default = 4
}

variable "worker_type" {
  default = "m4.xlarge"
}

variable "master_type" {
  default = "m4.xlarge"
}

variable "release" {
  default = "emr-5.16.0"
}

variable "applications" {
  default = ["Spark", "Hadoop", "Hue", "Hive", "HCatalog", "Presto", "Tez", "ZooKeeper"]
}

variable "vpc_id" {}

variable "subnet_ids" {
  default = []
}

variable "ssh_key_ids" {
  default = []
}

variable "tags" {
  type = "map"

  default = {}
}
