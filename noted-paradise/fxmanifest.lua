fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Noted'
description 'Allows players to open a camera to a set location'
version '1.0'

shared_script {
    'config.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_script 'client/main.lua'

server_scripts {
    'server/main.lua'
}
