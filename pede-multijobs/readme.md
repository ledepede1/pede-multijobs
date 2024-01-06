# Pede Multijobs

Dependencies:
oxmysql
esx
ox_lib

Setup:
Importer databasen
Genstart serveren
Og hav det fedt


Events:
TriggerServerEvent("delete:player:job", employee.identifier, ESX.PlayerData.job.name) for at slette personens job via esx_society (kun: admin, boss kan bruge den)
(Skriv på min discord hvis du har brug for hjælp)
