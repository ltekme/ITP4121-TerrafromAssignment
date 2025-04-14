output "subnets" {
  value = {
    private-AZ_A = aws_subnet.private-AZ_A
    private-AZ_B = aws_subnet.private-AZ_B
    public-AZ_A  = aws_subnet.public-AZ_A
    public-AZ_A  = aws_subnet.public-AZ_B
    isolate-AZ_A = aws_subnet.isolate-AZ_A
    isolate-AZ_B = aws_subnet.isolate-AZ_B
  }
}
output "vpc" {
  value = aws_vpc.Main-VPC
}
