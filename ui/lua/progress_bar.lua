--- @section Local Functions

--- Show progress bar with options
--- @param options table: Contains header, icon, and duration of the progress bar.
function show_progressbar(options)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'show_progressbar',
        header = options.header or 'Loading...',
        icon = options.icon or 'fa-solid fa-circle-notch',
        duration = options.duration or 5000
    })
end

exports('show_progressbar', progressbar)

--- Hide progress bar
function hide_progressbar()
    SendNUIMessage({ action = 'hide_progressbar' })
end

exports('hide_progressbar', hide_progressbar)

-- Register NUI Callback for progress completion
RegisterNUICallback('progressbar_end', function(data)
    if data.success then
        print('Progress completed successfully')
    else
        print('Progress failed or was cancelled')
    end
end)
