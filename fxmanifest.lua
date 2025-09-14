fx_version 'cerulean'
game 'gta5'

author 'alpy'
description 'Five Hotwire - Modern vehicle hotwiring script with ox_lib integration'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

files {
    'locales/*.json'
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/*.lua'
}

dependencies {
    'qb-core',
    'qb-vehiclekeys',
    'ox_lib',
    'ox_inventory'
}


lua54 'yes'
