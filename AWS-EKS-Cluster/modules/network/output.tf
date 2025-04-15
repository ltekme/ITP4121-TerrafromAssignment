output "private-subnet-1" {
  value = aws_subnet.private-AZ_A
}
output "private-subnet-2" {
  value = aws_subnet.private-AZ_B
}
output "public-subnet-1" {
  value = aws_subnet.public-AZ_A
}
output "public-subnet-2" {
  value = aws_subnet.public-AZ_B
}
output "isolated-subnet-1" {
  value = aws_subnet.isolate-AZ_A
}
output "isolated-subnet-2" {
  value = aws_subnet.isolate-AZ_B
}
output "vpc" {
  value = aws_vpc.Main-VPC
}
