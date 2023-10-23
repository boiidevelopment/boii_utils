----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

-- Function to request a model and wait until it's loaded.
-- Usage: utils.requests.model(GetHashKey("a_m_m_bevhills_01"))
local function model(model)
    if HasModelLoaded(model) then return end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

-- Function to request loading of an interior and wait until it's ready.
-- Usage: utils.requests.interior(271617)
local function interior(interior)
    if IsInteriorReady(interior) then return end
    if IsValidInterior(interior) then
        LoadInterior(interior)
        while not IsInteriorReady(interior) do
            Wait(0)
        end
    end
end

-- Function to request a texture dictionary and optionally wait until it's loaded.
-- Usage: utils.requests.texture("myTextureDict", true)
local function texture(texture, boolean)
    if HasStreamedTextureDictLoaded(texture) then return end
    RequestStreamedTextureDict(texture, boolean)
    if boolean and not HasStreamedTextureDictLoaded(texture) then
        Wait(150)
    end
end

-- Function to request collision at a given location and wait until it's loaded.
-- Usage: utils.requests.collision(120.0, 130.0, 140.0)
local function collision(x, y, z)
    if HasCollisionLoadedAroundEntity(PlayerPedId()) then return end
    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        Wait(0)
    end
end

-- Function to request an animation dictionary and wait until it's loaded.
-- Usage: utils.requests.anim("amb@world_human_stand_mobile@male@text@base")
local function anim(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

-- Function to request an animation clip set and wait until it's loaded.
-- Usage: utils.requests.clip_set("MOVE_M@DRUNK@VERYDRUNK")
local function clip_set(clip)
    if HasClipSetLoaded(clip) then return end
    RequestClipSet(clip)
    while not HasClipSetLoaded(clip) do
        Wait(0)
    end
end

-- Function to request a script audio bank.
-- Usage: utils.requests.audio_bank("DLC_HEIST_FLEECA_SOUNDSET")
local function audio_bank(audio)
    if HasScriptAudioBankLoaded(audio) then return end
    RequestScriptAudioBank(audio, false)
    while not HasScriptAudioBankLoaded(audio) do
        Wait(0)
    end
end

-- Function to request a scaleform movie.
-- Usage: local scaleform = utils.requests.scaleform_movie("MP_BIG_MESSAGE_FREEMODE")
local function scaleform_movie(scaleform)
    if HasScaleformMovieLoaded(scaleform) then return end
    local handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(handle) do
        Wait(0)
    end
    return handle
end

-- Function to request a cutscene.
-- Usage: utils.requests.cutscene("example_cutscene_name")
local function cutscene(scene)
    if HasCutsceneLoaded() then return end
    RequestCutscene(scene, 8)
    while not HasCutsceneLoaded() do
        Wait(0)
    end
end

-- Function to request a ipl
-- Usage: utils.requests.ipl("TrevorsTrailerTrash")
local function ipl(str)
    if IsIplActive(str) then return end
    RequestIpl(str)
    while not IsIplActive(str) do
        Wait(0)
    end
end

--[[
    ASSIGN LOCALS
]]

utils.requests = utils.requests or {}

utils.requests.model = model
utils.requests.interior = interior
utils.requests.texture = texture
utils.requests.collision = collision
utils.requests.anim = anim
utils.requests.clip_set = clip_set
utils.requests.audio_bank = audio_bank
utils.requests.scaleform_movie = scaleform_movie
utils.requests.cutscene = cutscene
utils.requests.ipl = ipl
