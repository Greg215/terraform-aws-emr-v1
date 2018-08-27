#------emr main-------

resource "aws_emr_cluster" "emr-cluster" {
  count         = 1
  name          = "${element(var.names, count.index)}"
  release_label = "${var.release}"
  applications  = "${concat(var.applications)}"

  ec2_attributes {
    subnet_id                         = "${element(var.subnet_ids, count.index)}"
    key_name                          = "${element(var.ssh_key_ids, count.index)}"
    emr_managed_master_security_group = "${aws_security_group.master.id}"
    emr_managed_slave_security_group  = "${aws_security_group.slave.id}"

    # additional_master_security_groups = "${aws_security_group.allow_ssh.id}"
    instance_profile = "${aws_iam_instance_profile.test_greg_ec2_profile.arn}"
  }

  master_instance_type = "${var.master_type}"
  core_instance_type   = "${var.worker_type}"
  core_instance_count  = "${var.worker_count}"

  tags {
    Name = "emr-gregTest-${count.index+1}"
  }

  # configurations = "test-fixtures/emr_configurations.json"

  service_role = "${aws_iam_role.test_greg_emr_role.arn}"
  depends_on = ["aws_security_group.master", "aws_security_group.slave"]
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --private-key ~/.ssh/id_rsa -i ${self.master_public_dns}, -u ec2-user ansible.yml"
  }
}
