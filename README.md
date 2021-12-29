# sre
# Rizky Nurachmad
# DevOps
1. Tolong tuliskan Terraform HCL config untuk menghasilkan AWS infra berupa 
a. 1 VPC
b. 1 subnet public
c. 1 subnet private yg terhubung dengan 1 NAT Gateway
d. 1 autoscaling group dengan config :
minimum 2 instance EC2 T2.medium dan max 5 instance, dimana scaling policy
adalah CPU >= 45%. Instance harus ditempatkan di 1 subnet Private yang dibuat dipoin 3 diatas.

