# dev public ip
output "dev_public_ip" {
	value 	=	aws_instance.dev_test_1.public_ip
}


# dev private ip
output "dev_private_ip" {
        value   =       aws_instance.dev_test_1.private_ip
}



# qa public ip
output "qa_public_ip" {
        value   =       aws_instance.qa_test_1.public_ip
}



# qa private ip
output "qa_private_ip" {
        value   =       aws_instance.qa_test_1.private_ip
}



# uat public ip
output "uat_public_ip" {
        value   =       aws_instance.uat_test_1.public_ip
}



# uat private ip
output "uat_private_ip" {
        value   =       aws_instance.uat_test_1.private_ip
}

