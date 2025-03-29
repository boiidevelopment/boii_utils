--- @section Module

local requests = {}

if not ENV.IS_SERVER then

    --- Requests a model and waits until it's loaded.
    --- @param model hash: The hash of the model to load.
    local function request_model(model)
        if HasModelLoaded(model) then return end
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    end

    --- Requests an interior and waits until it's ready.
    --- @param interior number: The ID of the interior to load.
    local function request_interior(interior)
        if IsInteriorReady(interior) then return end
        if IsValidInterior(interior) then
            LoadInterior(interior)
            while not IsInteriorReady(interior) do
                Wait(0)
            end
        end
    end

    --- Requests a texture dictionary and optionally waits until it's loaded.
    --- @param texture string: The name of the texture dictionary to load.
    --- @param boolean boolean: Whether to wait for the texture dictionary to load.
    local function request_texture(texture, boolean)
        if HasStreamedTextureDictLoaded(texture) then return end
        RequestStreamedTextureDict(texture, boolean)
        if boolean and not HasStreamedTextureDictLoaded(texture) then
            Wait(150)
        end
    end

    --- Requests collision at a given location and waits until it's loaded.
    --- @param x number: The X coordinate.
    --- @param y number: The Y coordinate.
    --- @param z number: The Z coordinate.
    local function request_collision(x, y, z)
        if HasCollisionLoadedAroundEntity(PlayerPedId()) then return end
        RequestCollisionAtCoord(x, y, z)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Wait(0)
        end
    end

    --- Requests an animation dictionary and waits until it's loaded.
    --- @param dict string: The name of the animation dictionary to load.
    local function request_anim(dict)
        if HasAnimDictLoaded(dict) then return end
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end

    --- Requests a animation set and waits until loaded.
    --- @param set string: The name of the animation set to load
    local function request_anim_set(set)
        RequestAnimSet(set)
        while not HasAnimSetLoaded(set) do
            Wait(100)
        end
    end

    --- Requests an animation clip set and waits until it's loaded.
    --- @param clip string: The name of the clip set to load.
    local function request_clip_set(clip)
        if HasClipSetLoaded(clip) then return end
        RequestClipSet(clip)
        while not HasClipSetLoaded(clip) do
            Wait(0)
        end
    end

    --- Requests a script audio bank and waits until it's loaded.
    --- @param audio string: The name of the audio bank to load.
    local function request_audio_bank(audio)
        if HasScriptAudioBankLoaded(audio) then return end
        RequestScriptAudioBank(audio, false)
        while not HasScriptAudioBankLoaded(audio) do
            Wait(0)
        end
    end

    --- Requests a scaleform movie and waits until it's loaded.
    --- @param scaleform string: The name of the scaleform movie to load.
    --- @return handle number: The handle of the loaded scaleform movie.
    local function request_scaleform_movie(scaleform)
        if HasScaleformMovieLoaded(scaleform) then return end
        local handle = RequestScaleformMovie(scaleform)
        while not HasScaleformMovieLoaded(handle) do
            Wait(0)
        end
        return handle
    end

    --- Requests a cutscene and waits until it's loaded.
    --- @function cutscene
    --- @param scene string: The name of the cutscene to load.
    --- @usage requests.cutscene('example_cutscene_name')
    local function request_cutscene(scene)
        if HasCutsceneLoaded() then return end
        RequestCutscene(scene, 8)
        while not HasCutsceneLoaded() do
            Wait(0)
        end
    end

    --- Requests an ipl and waits until it's active.
    --- @param str string: The name of the ipl to load.
    local function request_ipl(str)
        if IsIplActive(str) then return end
        RequestIpl(str)
        while not IsIplActive(str) do
            Wait(0)
        end
    end

    --- @section Function Assignments

    requests.model = request_model
    requests.interior = request_interior
    requests.texture = request_texture
    requests.collision = request_collision
    requests.anim = request_anim
    requests.anim_set = request_anim_set
    requests.clip_set = request_clip_set
    requests.audio_bank = request_audio_bank
    requests.scaleform_movie = request_scaleform_movie
    requests.cutscene = request_cutscene
    requests.ipl = request_ipl

    --- @section Exports

    exports('request_model', request_model)
    exports('request_interior', request_interior)
    exports('request_texture', request_texture)
    exports('request_collision', request_collision)
    exports('request_anim', request_anim)
    exports('request_anim_set', request_anim_set)
    exports('request_clip_set', request_clip_set)
    exports('request_audio_bank', request_audio_bank)
    exports('request_scaleform_movie', request_scaleform_movie)
    exports('request_cutscene', request_cutscene)
    exports('request_ipl', request_ipl)

end

return requests