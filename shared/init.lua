--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|             DEVELOPER UTILS
]]

--- Shared initialization.
--- @script shared/init.lua

--- @field testing: Toggle testing mode. 
TESTING = true

--- @field utils: Main utils object to export entire library.
utils = utils or {}

--- @field shared: Stores all shared functions and shared data for use externally.
utils.shared = utils.shared or {}

--- @field debug: Stores all debug functions for use externally.
utils.debug = utils.debug or {}

--- @field general: Stores all general functions for use externally.
utils.general = utils.general or {}

--- @field geometry: Stores all geometry functions for use externally.
utils.geometry = utils.geometry or {}

--- @field keys: Stores all keys functions for use externally.
utils.keys = utils.keys or {}

--- @field maths: Stores all maths functions for use externally.
utils.maths = utils.maths or {}

--- @field serialization: Stores all serialization functions for use externally.
utils.serialization = utils.serialization or {}

--- @field strings: Stores all strings functions for use externally.
utils.strings = utils.strings or {}

--- @field tables: Stores all tables functions for use externally.
utils.tables = utils.tables or {}

--- @field validation: Stores all validation functions for use externally.
utils.validation = utils.validation or {}