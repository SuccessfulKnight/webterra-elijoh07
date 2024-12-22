Terraform-prosjekt for webserver og Postgres-database på Azure
Dette prosjektet bruker Terraform for å sette opp en webserver og en Postgres-database. Webserveren kjører Gunicorn som kobler seg til Postgres-loadbalanseren. 

Prosjektstruktur
main.tf: Hovedkonfigurasjonsfil for Terraform.
web og db: konfigurasjon av webserveren og oppsett av databasen
variables.tf: Definisjon av variabler for Terraform.
outputs.tf: 

Infrastrukturkomponenter
Azure Virtual Machines:
Webserver-VM: Kjører Gunicorn og Flask.
Databaseserver-VM-er: Kjører PostgreSQL og er konfigurert i en backend-pool.

Azure Load Balancer:
Distribuerer trafikk til databaseserverne på port 5234.

Nettverk:
Virtual Network og Subnets: Separate subnets for web- og databaseservere.
Network Security Groups: Kontrollerer trafikk inn og ut.
Oppsettinstruksjoner

Forutsetninger
Installert Terraform.
En Azure-konto med nødvendige rettigheter.
Installert og autentisert Azure CLI (az login).
Steg-for-steg

Gjør de endringene du vil i terraform.tfvars
TERRAFORM

az logout ; az login --scope https://management.core.windows.net//.default
terraform init
terraform plan -out main.tfplan
terraform apply
Kopier public ipen du blir foret med i terminalen.
TESTING

Bruk ipen i nettleseren 