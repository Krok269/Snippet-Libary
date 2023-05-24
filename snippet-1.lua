-- Break cuff snippet for qbcore - qb-policejob
RegisterNetEvent('police:client:GetCuffed', function(playerId, isSoftcuff)
    local ped = PlayerPedId()
    if not isHandcuffed then
        local seconds = math.random(5,7)
        exports['ps-ui']:Circle(function(success)
            if success then
                isHandcuffed = false
                isEscorted = false
                GetCuffedAnimation(playerId)
                TriggerEvent('hospital:client:isEscorted', isEscorted)
                DetachEntity(ped, true, false)
                TriggerServerEvent("police:server:SetHandcuffStatus", false)
                ClearPedTasksImmediately(ped)
                TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
                TriggerServerEvent('hud:server:GainStress', math.random(2, 3)) -- Gives the player stress from breaking free.
                QBCore.Functions.Notify("Du klarte å slippe løs!", "success")
            else
                isHandcuffed = true
                TriggerServerEvent("police:server:SetHandcuffStatus", true)
                ClearPedTasksImmediately(PlayerPedId())
                if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_UNARMED') then
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
                end
                if not isSoftcuff then
                    cuffType = 16
                    GetCuffedAnimation(playerId)
                    QBCore.Functions.Notify(Lang:t("info.cuff"), 'primary')
                else
                    cuffType = 49
                    GetCuffedAnimation(playerId)
                    QBCore.Functions.Notify(Lang:t("info.cuffed_walk"), 'primary')
                end    
                QBCore.Functions.Notify("Du feilet å slippe deg løs!", "error")
            end
        end, 1, seconds) -- NumberOfCircles, MS        
    else
        isHandcuffed = false
        isEscorted = false
        TriggerEvent('hospital:client:isEscorted', isEscorted)
        DetachEntity(ped, true, false)
        TriggerServerEvent("police:server:SetHandcuffStatus", false)
        ClearPedTasksImmediately(ped)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "Uncuff", 0.2)
        QBCore.Functions.Notify(Lang:t("success.uncuffed"),"success")
    end
end)
