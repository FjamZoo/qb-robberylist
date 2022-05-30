local QBCore = exports['qb-core']:GetCoreObject()
local CurrentCops = 0


local BankRobberyCD = false

RegisterNetEvent('qb-robberylist:client:AvailableRobberies', function()
    local header = {
        {
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
            header = "Available Robberies",
        }
    }
    for k, v in pairs(Config.RobberyList) do
        if CurrentCops >= v.minCops then
            if not v.bank or (v.bank and not BankRobberyCD) then
                header[#header+1] = {
                    header = v.Header,
                    txt = "Available",
                    icon = v.icon,
                    isMenuHeader = true,
                }
            else
                header[#header+1] = {
                    header = v.Header,
                    txt = "Not Available",
                    icon = v.icon,
                    isMenuHeader = true,
                }
            end
        else
            header[#header+1] = {
                header = v.Header,
                txt = "Not Available",
                icon = v.icon,
                isMenuHeader = true,
            }
        end
    end
    header[#header+1] = {
        header = "Go Back",
        icon = "fa-solid fa-angle-left",
        params = {
            event = "qb-robberylist:client:MainMenu",
        }
    }

    exports['qb-menu']:openMenu(header)
end)

RegisterNetEvent('qb-robberylist:client:OpenShop', function()
    local header = {
        {
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
            header = "Welcome to my little shop"
        }
    }
    for k, v in pairs(Config.Shop) do
        if QBCore.Shared.Items[v.item].label then
            header[#header+1] = {
                header = QBCore.Shared.Items[v.item].label,
                txt = "Price: "..v.price,
                icon = v.icon,
                params = {
                    isServer = true,
                    event = "qb-robberylist:server:buyshit",
                    args = k
                }
            }
        end
    end
    header[#header+1] = {
        header = "Go Back",
        icon = "fa-solid fa-angle-left",
        params = {
            event = "qb-robberylist:client:MainMenu",
        }
    }

    exports['qb-menu']:openMenu(header)
end)

RegisterNetEvent('qb-robberylist:client:MainMenu', function()
    local header = {
        {
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
            header = "I heard you seek information"
        },
        {
            icon = "fa-solid fa-circle-info",
            header = "Available Robberies",
            params = {
                event = "qb-robberylist:client:AvailableRobberies",
            }
        },
        {
            icon = "fa-solid fa-circle-info",
            header = "View Shop",
            params = {
                event = "qb-robberylist:client:OpenShop",
            }
        },
    }

    exports['qb-menu']:openMenu(header)
end)

--RegisterCommand("loltest", function() -- Uncomment this if you just wanna test
--    TriggerEvent('qb-robberylist:client:MainMenu')
--end, false)

for i = 1, #Config.Peds do
    exports['qb-target']:SpawnPed({
        model = Config.Peds[i].model,
        coords = Config.Peds[i].coords,
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        scenario = 'WORLD_HUMAN_AA_COFFEE',
        target = {
            options = {
            {
                type = "client",
                icon = 'fa-solid fa-question',
                label = 'Talk to Wade',

                action = function()
                    TriggerEvent('qb-robberylist:client:MainMenu')
                end,
            }
            },
            distance = 2.5,
        },
    })
end

-- do something like when a TriggerClientEvent('qb-robberylist:client:SetBankCD', -1, true) when a bank is being robbed
-- do something like TriggerClientEvent('qb-robberylist:client:SetBankCD', -1, false) when a bank can be hit again

RegisterNetEvent('qb-robberylist:client:SetBankCD', function(bool)
    BankRobberyCD = bool
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)