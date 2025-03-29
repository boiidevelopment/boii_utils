--- @section Variables

local script_cam

--- @section Local functions

--- Creates a camera at the given position.
--- @param pos vector3: The position to create the camera at.
--- @param rot vector3: The rotation of the camera.
--- @param fov number: The field of view for the camera.
--- @return cam: The created camera.
local function create_cam(pos, rot, fov)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, fov or GetGameplayCamFov(), false, 0)
    SetCamCoord(cam, pos.x, pos.y, pos.z)
    SetCamRot(cam, rot.x, rot.y, rot.z, 2)
    return cam
end

--- Resets the camera back to the player's perspective.
--- Destroys the scripted camera and reverts to the gameplay camera.
local function reset_cam()
    RenderScriptCams(false, false)
    DestroyCam(script_cam)
    script_cam = nil
end

--- Sets the player's view towards a specific point and orients them facing that direction.
--- @param npc Entity: The NPC entity to orient.
--- @param coords vector3: The coordinates to face towards.
local function set_view(npc, coords)
    if not coords then return end
    local npc_pos = GetEntityCoords(npc) + (GetEntityForwardVector(npc) * 1) + vector3(0, 0, 0.65)
    local npc_rot = GetEntityRotation(npc, 2)
    npc_rot = vector3(npc_rot.x, npc_rot.y, npc_rot.z + 180.0)
    local temp_cam = create_cam(GetGameplayCamCoord(), GetGameplayCamRot(2))
    script_cam = create_cam(npc_pos, npc_rot)
    SetCamActive(temp_cam, true)
    RenderScriptCams(true, false, 1, true, true)
    SetCamActiveWithInterp(script_cam, temp_cam, 1500, true, true)
    DestroyCam(temp_cam)
    local player_ped = PlayerPedId()
    local player_coords = GetEntityCoords(player_ped)
    local dx = coords.x - player_coords.x
    local dy = coords.y - player_coords.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    TaskTurnPedToFaceCoord(player_ped, coords.x, coords.y, coords.z, -1)
    SetEntityHeading(player_ped, heading)
end

--- Opens a dialogue interface with the given parameters.
--- @param dialogue table: Dialogue content to display.
--- @param npc Entity: The NPC entity initiating the dialogue.
--- @param coords vector3: The coordinates for orienting the player's view.
local function open_dialogue(dialogue, npc, coords)
    SetNuiFocus(true, true)
    set_view(npc, coords)
    SendNUIMessage({
        action = 'create_dialogue',
        dialogue = dialogue
    })
end

--- @section NUI callbacks

--- Closes the dialogue menu from ui actions.
RegisterNUICallback('close_dialogue', function()
    SetNuiFocus(false, false)
    active = false
    reset_cam()
    ClearPedTasks(PlayerPedId())
end)

---- @section Exports 

--- Export to open dialogue system.
exports('dialogue', open_dialogue)
