resource "aws_instance" "lms-web-server" {
  ami           = "ami-010b74bc1a8b29122"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.lms-web-subnet.id
  key_name = "sunnystockholm"
  vpc_security_group_ids = [aws_security_group.lms-web-sg.id]
  user_data = file("setup.sh")
  tags = {
    Name = "lms-web-server"
  }
}