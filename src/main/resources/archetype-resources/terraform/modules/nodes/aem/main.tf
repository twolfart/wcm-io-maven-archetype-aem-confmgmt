#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
resource "aws_instance" "aem" {
  count = "${var.instance_count}"
  ami = "${var.centos7_ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  iam_instance_profile = "${var.instance_profile_name}"
  key_name = "${var.key_name}"
  user_data = "${var.user_data}"
  root_block_device {
    volume_size = "${var.volume_size}"
  }

  tags {
    Name = "${var.environment}_${var.instance_name}"
    Project = "${var.project}"
    Role = "aem"
    conga_roles = "${symbol_dollar}{join(",",var.conga_roles)}"
    # join the conga_nodes array with , and replace . by ___ otherwise the ec2 will convert it to one single dash
    conga_nodes = "${symbol_dollar}{join(",",var.conga_nodes)}"
    conga_variants = "${symbol_dollar}{join(",",var.conga_variants)}"
    conga_tenants = "${symbol_dollar}{join(",",var.conga_tenants)}"
    conga_variant_node_mapping = "${symbol_dollar}{join(",",var.conga_variant_node_mapping)}"
    Env = "${var.environment}"
  }

  volume_tags {
    Project = "${var.project}"
    Name = "${var.environment}_${var.instance_name}"
  }

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}
