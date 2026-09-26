fx_version 'cerulean'
game 'gta5'

name 'qb-right-hud'
author 'Chla7'
description 'Compact right-side QBCore health and armor HUD'
version '1.9.4'

lua54 'yes'

shared_script 'config.lua'
client_script 'client.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/weapon-images.js',
    'html/icons/*.svg',
    'html/fonts/*.ttf'
}

dependency 'qb-core'
