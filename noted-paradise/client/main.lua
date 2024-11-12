local QBCore = exports['qb-core']:GetCoreObject()
local createdCamera = 0

local function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0

    -- MAKES THE SCREEN
    ClearTimecycleModifier('scanline_cam_cheap')
    SetFocusEntity(GetPlayerPed(PlayerId()))
    -- SHOWS THE RADAR/MINIMAP ON CLOSE
    -- ONLY INCLUDE IF HIDING RADAR/MINIMAP
    DisplayRadar(true)

    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end


local function CreateInstuctionScaleform(scaleform)
    scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, 'CLEAR_ALL')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_CLEAR_SPACE')
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_DATA_SLOT')
    PushScaleformMovieFunctionParameterInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 194, true))
    BeginTextCommandScaleformString('STRING')
    --AddTextComponentScaleform(Lang:t('info.close_camera'))
    AddTextComponentScaleform('Snap Back To Reality')
    EndTextCommandScaleformString()
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, 'SET_BACKGROUND_COLOUR')
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end


local function RunLoop()
    CreateThread(function()
        local countdown = Config.TimeAllowedInParadise
        -- Config.CreateThreadWaitTimer 
        --print("Config.TimeAllowedInParadise/Config.CreateThreadWaitTimer = " .. Config.TimeAllowedInParadise/Config.CreateThreadWaitTimer)
        --print("countdown = " .. countdown)
        local getCameraRot = GetCamRot(createdCamera, 2)
        SetCamRot(createdCamera, Config.Paradise.r.x, 0.0, getCameraRot.z, 2)
        while createdCamera ~= 0 and countdown > 0 do
            local instructions = CreateInstuctionScaleform('instructional_buttons')
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifier('scanline_cam_cheap')
            SetTimecycleModifierStrength(1.0)


            -- HIDES RADAR/MINIMAP WHILE CAMERA IS OPEN
            DisplayRadar(false)


            -- CLOSE CAMERAS
            if IsControlJustPressed(1, 177) then
                DoScreenFadeOut(250)
                while not IsScreenFadedOut() do
                    Wait(0)
                end
                CloseSecurityCamera()
                DoScreenFadeIn(250)
            end


            --- DISABLE MOVEMENT STUFF:


            DisableControlAction(0, 30, true)   -- Disable move left/right
            DisableControlAction(0, 31, true)   -- Disable move up/down
            DisableControlAction(0, 21, true)   -- Disable sprint
            DisableControlAction(0, 22, true)   -- Disable jump
            DisableControlAction(0, 23, true)   -- Disable enter vehicle
            DisableControlAction(0, 75, true)   -- Disable exit vehicle
            DisableControlAction(0, 24, true)   -- Disable attack
            DisableControlAction(0, 25, true)   -- Disable aim
            DisableControlAction(0, 45, true)   -- Disable reload
            DisableControlAction(0, 140, true)  -- Disable melee attack light
            DisableControlAction(0, 141, true)  -- Disable melee attack heavy
            DisableControlAction(0, 142, true)  -- Disable melee attack alternate
            DisableControlAction(0, 143, true)  -- Disable melee attack knockout
            DisableControlAction(0, 257, true)  -- Disable attack 2
            DisableControlAction(0, 263, true)  -- Disable melee attack 1
            DisableControlAction(0, 264, true)  -- Disable melee attack 2

            ---------------------------------------------------------


            ---------------------------------------------------------------------------
            -- CAMERA ROTATION CONTROLS
            ---------------------------------------------------------------------------
            -- if true then
            --     local getCameraRot = GetCamRot(createdCamera, 2)

            --     -- ROTATE UP
            --     if IsControlPressed(0, 32) then
            --         if getCameraRot.x <= 0.0 then
            --             SetCamRot(createdCamera, getCameraRot.x + 0.7, 0.0, getCameraRot.z, 2)
            --         end
            --     end

            --     -- ROTATE DOWN
            --     if IsControlPressed(0, 8) then
            --         if getCameraRot.x >= -50.0 then
            --             SetCamRot(createdCamera, getCameraRot.x - 0.7, 0.0, getCameraRot.z, 2)
            --         end
            --         print("camera rot.x = " .. getCameraRot.x)
            --     end

            --     -- ROTATE LEFT
            --     if IsControlPressed(0, 34) then
            --         SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z + 0.7, 2)
            --     end

            --     -- ROTATE RIGHT
            --     if IsControlPressed(0, 9) then
            --         SetCamRot(createdCamera, getCameraRot.x, 0.0, getCameraRot.z - 0.7, 2)
            --     end
            -- end
            --print("countdown = " .. countdown)
            countdown = countdown - 1
            Wait(Config.CreateThreadWaitTimer)
        end

        if createdCamera ~= 0 then
            DoScreenFadeOut(250)
            while not IsScreenFadedOut() do
                Wait(0)
            end
            CloseSecurityCamera()
            DoScreenFadeIn(250)
        end
        
    end)
end

local function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
    -- print("r.x = " .. r.x)
    -- print("r.y = " .. r.y)
    -- print("r.z = " .. r.z)
    
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x,r.y,r.z, 2)
    local temp = GetCamRot(cam, 2)
    
    
    -- print("camera rotation x = " .. temp.x)
    RenderScriptCams(1, 0, 0, 1, 1)
    Wait(250)
    createdCamera = cam
    RunLoop()
end

RegisterNetEvent('noted-paradise:client:ActiveCamera', function(id)
    if createdCamera ~= 0 then
        CloseSecurityCamera()
        return
    end
        
    if id == 1 then
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        
        local x = Config.Paradise.coords.x
        local y = Config.Paradise.coords.y
        local z = Config.Paradise.coords.z
        local r = Config.Paradise.r

        SetFocusArea(x, y, z, x, y, z)

        ChangeSecurityCamera(x,y,z,r)
        DoScreenFadeIn(250)
    elseif id == 2 then
        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        CloseSecurityCamera()
    end
end)

