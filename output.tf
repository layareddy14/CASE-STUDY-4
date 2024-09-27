output "s3_bucket_name" {
  value = aws_s3_bucket.shared_storage.id
}

output "ec2_instance_a_public_ip" {
  value = aws_instance.ec2_instance_a.public_ip
}

output "ec2_instance_b_public_ip" {
  value = aws_instance.ec2_instance_b.public_ip
}

output "ec2_instance_c_public_ip" {
  value = aws_instance.ec2_instance_c.public_ip
}
