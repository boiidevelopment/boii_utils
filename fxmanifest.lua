--[[
---------------------------
  ____   ____ _____ _____ 
 |  _ \ / __ \_   _|_   _|
 | |_) | |  | || |   | |  
 |  _ <| |  | || |   | |  
 | |_) | |__| || |_ _| |_ 
 |____/ \____/_____|_____|
                                                    
---------------------------                                              
      Utility Library
          V2.1.0              
---------------------------
]]

fx_version "cerulean"
games { "gta5", "rdr3" }

name "boii_utils"
version "2.1.0"
description "Developer Utility Library."
author "boiidevelopment"
repository "https://github.com/boiidevelopment/boii_utils"
lua54 "yes"

fx_version "cerulean"
game "gta5"

ui_page 'ui/index.html'
nui_callback_strict_mode 'true'

files {
    'ui/**'
}

server_script "@oxmysql/lib/MySQL.lua" -- OxMySQL

shared_script "env.lua"
shared_script "init.lua"
server_script "users.lua" -- Required! user accounts handle permissions for commands etc.. dont remove.

shared_scripts {
    "lib/data/*.lua",
    "lib/modules/**/*.lua",
    "lib/bridges/**/*.lua",
    "lib/events/*.lua",
    "lib/threads/*.lua"
}

client_scripts {
    'ui/lua/*'
}
