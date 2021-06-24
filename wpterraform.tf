provider "google" {
project = "qwiklabs-gcp-02-0ddd0adb63cc"
region = "us-central1"
zone = "us-central1-a"
}
//VPC
resource "google_compute_network" "wpvpc"{
name="wpvpc"
auto_create_subnetworks = false
}
//SUBNET
resource "google_compute_subnetwork" "wpsub"{
name = "wpsub"
ip_cidr_range ="10.2.0.0/24"
region="us-central1"
network=google_compute_network.wpvpc.name
}
//FIREWALL
resource "google_compute_firewall" "wpfirewall" {
name = "wpfirewall"
network = google_compute_network.wpvpc.name
allow {
protocol = "icmp"
}
allow {
protocol = "tcp"
ports = ["80", "8080", "1000-2000"]
}
source_tags = ["wordpress-db-ssh"]
source_ranges = ["0.0.0.0/0"]
}
//STATIC IP
resource "google_compute_address" "staticip"{
name = "staticip"
address_type = "EXTERNAL"
}
//DB_INSTANCE
resource "google_compute_instance" "wordpress"{
name="wordpress-db"
machine_type="f1-micro"
depends_on = [google_compute_address.staticip]
tags= ["http-server","ssh","wordpress-db-ssh","http"]
boot_disk {
initialize_params {
image = "ubuntu-os-cloud/ubuntu-1804-lts"
}
}
network_interface {
network = google_compute_network.wpvpc.name
subnetwork = google_compute_subnetwork.wpsub.name
access_config {
nat_ip = google_compute_address.staticip.address 
}
}
metadata_startup_script = "$(install.sh)"
}
//RANDOM USER
resource "random_string" "random" {
  length           = 16}
//RANDOM PASSWORD
resource "random_password" "password" {
  length           = 16
  special          = true
  min_numeric=1
  min_upper=1
}
//DATABASE
resource "google_sql_database_instance" "mysql" {
name = "mysqldb"
username   = random_string.random.result
password   =  random_password.password.result
database_version = "MYSQL_5_7"
settings {
tier = "db-f1-micro"
}
}
resource "google_sql_database" "database" {
name = "vaishu-database"
instance = google_sql_database_instance.mysql.name
}