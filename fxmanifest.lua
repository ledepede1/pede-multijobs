fx_version 'adamant'

game 'gta5'

author 'ledepede1'
description 'Pede Multijobs'

version '1.0'

lua54 'yes'

shared_scripts {
  '@ox_lib/init.lua',
}

shared_scripts {
  '@es_extended/imports.lua',
  'Locales/*'
}

client_scripts {
  'Configs/Config.lua',
  'Client/Main.lua',
  'Client/Functions.lua',
  'Client/Menu.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'Configs/Config.lua',
  'Server/Server.lua',
  'Configs/SV_Config.lua',
}

dependencies {
	'es_extended',
}