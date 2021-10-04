fx_version 'cerulean'
game 'gta5'
author 'JericoFX'

description 'QB-impound'

version '1.0.0'

ui_page 'html/index.html'

client_script 'client/client.lua'


shared_script {'@qb-garages/config.lua','config.lua'}

server_script 'server/server.lua'

files { 
    'html/index.html', 'html/main.js', 'html/style.css'
}

