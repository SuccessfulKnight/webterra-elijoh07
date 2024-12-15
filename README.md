# webterra-elijoh07
Dette prosjektet setter opp en infrastruktur i Azure ved hjelp av Terraform. Oppsettet inkluderer:

Web-VM: Kjører en Flask-applikasjon som viser data fra databasen.
Databaser (DB1 og DB2): PostgreSQL-databaser med et eksempeloppsett.
Lastbalanserer: Fordeler trafikk mellom databasene

standard bruker: azureadmin
standard passord: CiAdm@1234

steg for å kjøre terraformen:

    1.åpne opp powershell:
    åpne opp powershell

    2.Logg inn i Azure:
    az login

    3.Konfigurer Terraform:
    Åpne variables.tf i root mappen og sett inn verdier for det du ønsker

    4.Initier Terraform:
    terraform init -upgrade

    5.Planlegg Terraform:
    terraform plan -out main.tfplan

    6.Opprett Terraform:
    terraform apply

    7.Finn Web-VM sin offentlige IP:
    etter programmet er kjørt skal den dukke opp

    8.Besøk nettsiden:
    <web-vm-ip:80>
    husk port 80 etter ip addressen til web vm

    9.ødelegg terraform:
    når du er ferdig
    terraform destroy


Dette prosjektet oppretter en tjenester i Azure som inkluderer:

En Flask som viser data fra en PostgreSQL-database.
En lastbalanserer.
To databaser.