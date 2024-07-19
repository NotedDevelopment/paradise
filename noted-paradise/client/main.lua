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
    AddTextComponentScaleform("Lang:t('info.close_camera')" .. "InstructionButtonMessage")
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
        print("loop enetered\n")
        while createdCamera ~= 0 do
            print("loop running")
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
                SendNUIMessage({
                    type = 'disablecam',
                })
                DoScreenFadeIn(250)
            end

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

            -- CHANGE THIS TO A VARIABLE LATER
            Wait(5)
        end
    end)
end

local function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', 1)
    SetCamCoord(cam, x, y, z)
    -- SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Wait(250)
    createdCamera = cam
    RunLoop()
end

RegisterNetEvent('noted-paradise:client:ActiveCamera', function(id)
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


