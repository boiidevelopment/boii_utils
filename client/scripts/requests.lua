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

--- Request functions.
--- @script client/requests.lua

--- @section Local functions

--- Requests a model and waits until it's loaded.
--- @function model
--- @param model hash: The hash of the model to load.
--- @usage utils.requests.model(GetHashKey('a_m_m_bevhills_01'))
local function model(model)
    if HasModelLoaded(model) then return end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

exports('requests_model', model)
utils.requests.model = model

--- Requests an interior and waits until it's ready.
--- @function interior
--- @param interior number: The ID of the interior to load.
--- @usage utils.requests.interior(271617)
local function interior(interior)
    if IsInteriorReady(interior) then return end
    if IsValidInterior(interior) then
        LoadInterior(interior)
        while not IsInteriorReady(interior) do
            Wait(0)
        end
    end
end

exports('requests_interior', interior)
utils.requests.interior = interior

--- Requests a texture dictionary and optionally waits until it's loaded.
--- @function texture
--- @param texture string: The name of the texture dictionary to load.
--- @param boolean boolean: Whether to wait for the texture dictionary to load.
--- @usage utils.requests.texture('myTextureDict', true)
local function texture(texture, boolean)
    if HasStreamedTextureDictLoaded(texture) then return end
    RequestStreamedTextureDict(texture, boolean)
    if boolean and not HasStreamedTextureDictLoaded(texture) then
        Wait(150)
    end
end

exports('requests_texture', texture)
utils.requests.texture = texture

--- Requests collision at a given location and waits until it's loaded.
--- @function collision
--- @param x number: The X coordinate.
--- @param y number: The Y coordinate.
--- @param z number: The Z coordinate.
--- @usage utils.requests.collision(120.0, 130.0, 140.0)
local function collision(x, y, z)
    if HasCollisionLoadedAroundEntity(PlayerPedId()) then return end
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        Wait(0)
    end
end

exports('requests_collision', collision)
utils.requests.collision = collision

--- Requests an animation dictionary and waits until it's loaded.
--- @function anim
--- @param dict string: The name of the animation dictionary to load.
--- @usage utils.requests.anim('amb@world_human_stand_mobile@male@text@base')
local function anim(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

exports('requests_anim', anim)
utils.requests.anim = anim

--- Requests a animation set and waits until loaded.
--- @function anim_set
--- @param set string: The name of the animation set to load
--- @usage utils.requests.anim_set('MOVE_M@DRUNK@VERYDRUNK')
local function anim_set(set)
    RequestAnimSet(set)
    while not HasAnimSetLoaded(set) do
        Wait(100)
    end
end

exports('requests_anim_set', anim_set)
utils.requests.anim_set = anim_set

--- Requests an animation clip set and waits until it's loaded.
--- @function clip_set
--- @param clip string: The name of the clip set to load.
--- @usage utils.requests.clip_set('MOVE_M@DRUNK@VERYDRUNK')
local function clip_set(clip)
    if HasClipSetLoaded(clip) then return end
    RequestClipSet(clip)
    while not HasClipSetLoaded(clip) do
        Wait(0)
    end
end

exports('requests_clip_set', clip_set)
utils.requests.clip_set = clip_set

--- Requests a script audio bank and waits until it's loaded.
--- @function audio_bank
--- @param audio string: The name of the audio bank to load.
--- @usage utils.requests.audio_bank('DLC_HEIST_FLEECA_SOUNDSET')
local function audio_bank(audio)
    if HasScriptAudioBankLoaded(audio) then return end
    RequestScriptAudioBank(audio, false)
    while not HasScriptAudioBankLoaded(audio) do
        Wait(0)
    end
end

exports('requests_audio_bank', audio_bank)
utils.requests.audio_bank = audio_bank

--- Requests a scaleform movie and waits until it's loaded.
--- @function scaleform_movie
--- @param scaleform string: The name of the scaleform movie to load.
--- @return handle number: The handle of the loaded scaleform movie.
--- @usage local scaleform = utils.requests.scaleform_movie('MP_BIG_MESSAGE_FREEMODE')
local function scaleform_movie(scaleform)
    if HasScaleformMovieLoaded(scaleform) then return end
    local handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(handle) do
        Wait(0)
    end
    return handle
end

exports('requests_scaleform_movie', scaleform_movie)
utils.requests.scaleform_movie = scaleform_movie

--- Requests a cutscene and waits until it's loaded.
--- @function cutscene
--- @param scene string: The name of the cutscene to load.
--- @usage utils.requests.cutscene('example_cutscene_name')
local function cutscene(scene)
    if HasCutsceneLoaded() then return end
    RequestCutscene(scene, 8)
    while not HasCutsceneLoaded() do
        Wait(0)
    end
end

exports('requests_cutscene', cutscene)
utils.requests.cutscene = cutscene

--- Requests an ipl and waits until it's active.
--- @function ipl
--- @param str string: The name of the ipl to load.
--- @usage utils.requests.ipl('TrevorsTrailerTrash')
local function ipl(str)
    if IsIplActive(str) then return end
    RequestIpl(str)
    while not IsIplActive(str) do
        Wait(0)
    end
end

exports('requests_ipl', ipl)
utils.requests.ipl = ipl