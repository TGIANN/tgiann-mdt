fx_version 'bodacious'
game 'gta5'

client_script 'client/client.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'server/server.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/css/*.css',
	'html/js/*.js',
	'html/images/*.png',
}
