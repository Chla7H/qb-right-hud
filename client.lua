local QBCore = exports['qb-core']:GetCoreObject()
local visible = true
local lastHealth, lastArmor, lastPause = -1, -1, nil
local lastWeaponHash, lastClipAmmo, lastReserveAmmo = nil, -1, -1
local killCount, killTimerToken = 0, 0
local lastKilledEntity, lastKillAt = 0, 0

local WeaponImageKeys = {
    [joaat('WEAPON_ACIDPACKAGE')] = 'weapon_acidpackage',
    [joaat('WEAPON_ADVANCEDRIFLE')] = 'weapon_advancedrifle',
    [joaat('WEAPON_APPISTOL')] = 'weapon_appistol',
    [joaat('WEAPON_ASSAULTRIFLE')] = 'weapon_assaultrifle',
    [joaat('WEAPON_ASSAULTRIFLE_MK2')] = 'weapon_assaultrifle_mk2',
    [joaat('WEAPON_ASSAULTSHOTGUN')] = 'weapon_assaultshotgun',
    [joaat('WEAPON_ASSAULTSMG')] = 'weapon_assaultsmg',
    [joaat('WEAPON_AUTOSHOTGUN')] = 'weapon_autoshotgun',
    [joaat('WEAPON_BALL')] = 'weapon_ball',
    [joaat('WEAPON_BAT')] = 'weapon_bat',
    [joaat('WEAPON_BATTLEAXE')] = 'weapon_battleaxe',
    [joaat('WEAPON_BATTLERIFLE')] = 'weapon_battlerifle',
    [joaat('WEAPON_BOTTLE')] = 'weapon_bottle',
    [joaat('WEAPON_BROWNING')] = 'weapon_browning',
    [joaat('WEAPON_BULLPUPRIFLE')] = 'weapon_bullpuprifle',
    [joaat('WEAPON_BULLPUPRIFLE_MK2')] = 'weapon_bullpuprifle_mk2',
    [joaat('WEAPON_BULLPUPSHOTGUN')] = 'weapon_bullpupshotgun',
    [joaat('WEAPON_BZGAS')] = 'weapon_bzgas',
    [joaat('WEAPON_CANDYCANE')] = 'weapon_candycane',
    [joaat('WEAPON_CARBINERIFLE')] = 'weapon_carbinerifle',
    [joaat('WEAPON_CARBINERIFLE_MK2')] = 'weapon_carbinerifle_mk2',
    [joaat('WEAPON_CERAMICPISTOL')] = 'weapon_ceramicpistol',
    [joaat('WEAPON_COMBATMG')] = 'weapon_combatmg',
    [joaat('WEAPON_COMBATMG_MK2')] = 'weapon_combatmg_mk2',
    [joaat('WEAPON_COMBATPDW')] = 'weapon_combatpdw',
    [joaat('WEAPON_COMBATPISTOL')] = 'weapon_combatpistol',
    [joaat('WEAPON_COMBATSHOTGUN')] = 'weapon_combatshotgun',
    [joaat('WEAPON_COMPACTLAUNCHER')] = 'weapon_compactlauncher',
    [joaat('WEAPON_COMPACTRIFLE')] = 'weapon_compactrifle',
    [joaat('WEAPON_CROWBAR')] = 'weapon_crowbar',
    [joaat('WEAPON_CUSTOMADVANCEDRIFLE')] = 'weapon_customadvancedrifle',
    [joaat('WEAPON_CUSTOMASSAULTRIFLE')] = 'weapon_customassaultrifle',
    [joaat('WEAPON_CUSTOMASSAULTRIFLE_MK2')] = 'weapon_customassaultrifle_mk2',
    [joaat('WEAPON_CUSTOMBULLPUPRIFLE')] = 'weapon_custombullpuprifle',
    [joaat('WEAPON_CUSTOMBULLPUPRIFLE_MK2')] = 'weapon_custombullpuprifle_mk2',
    [joaat('WEAPON_CUSTOMCARBINERIFLE')] = 'weapon_customcarbinerifle',
    [joaat('WEAPON_CUSTOMCARBINERIFLE_MK2')] = 'weapon_customcarbinerifle_mk2',
    [joaat('WEAPON_CUSTOMCOMBATMG')] = 'weapon_customcombatmg',
    [joaat('WEAPON_CUSTOMCOMBATMG_MK2')] = 'weapon_customcombatmg_mk2',
    [joaat('WEAPON_CUSTOMCOMBATPDW')] = 'weapon_customcombatpdw',
    [joaat('WEAPON_CUSTOMCOMBATPISTOL')] = 'weapon_customcombatpistol',
    [joaat('WEAPON_CUSTOMCOMPACTRIFLE')] = 'weapon_customcompactrifle',
    [joaat('WEAPON_CUSTOMGUSENBERG')] = 'weapon_customgusenberg',
    [joaat('WEAPON_CUSTOMHEAVYPISTOL')] = 'weapon_customheavypistol',
    [joaat('WEAPON_CUSTOMHEAVYRIFLE')] = 'weapon_customheavyrifle',
    [joaat('WEAPON_CUSTOMMACHINEPISTOL')] = 'weapon_custommachinepistol',
    [joaat('WEAPON_CUSTOMMG')] = 'weapon_custommg',
    [joaat('WEAPON_CUSTOMMICROSMG')] = 'weapon_custommicrosmg',
    [joaat('WEAPON_CUSTOMMILITARYRIFLE')] = 'weapon_custommilitaryrifle',
    [joaat('WEAPON_CUSTOMPISTOL')] = 'weapon_custompistol',
    [joaat('WEAPON_CUSTOMPISTOL50')] = 'weapon_custompistol50',
    [joaat('WEAPON_CUSTOMPISTOL_MK2')] = 'weapon_custompistol_mk2',
    [joaat('WEAPON_CUSTOMSMG')] = 'weapon_customsmg',
    [joaat('WEAPON_CUSTOMSMG_MK2')] = 'weapon_customsmg_mk2',
    [joaat('WEAPON_CUSTOMSPECIALCARBINE')] = 'weapon_customspecialcarbine',
    [joaat('WEAPON_CUSTOMSPECIALCARBINE_MK2')] = 'weapon_customspecialcarbine_mk2',
    [joaat('WEAPON_CUSTOMVINTAGEPISTOL')] = 'weapon_customvintagepistol',
    [joaat('WEAPON_DAGGER')] = 'weapon_dagger',
    [joaat('WEAPON_DBSHOTGUN')] = 'weapon_dbshotgun',
    [joaat('WEAPON_DOUBLEACTION')] = 'weapon_doubleaction',
    [joaat('WEAPON_EMPLAUNCHER')] = 'weapon_emplauncher',
    [joaat('WEAPON_FERTILIZERCAN')] = 'weapon_fertilizercan',
    [joaat('WEAPON_FIREWORK')] = 'weapon_firework',
    [joaat('WEAPON_FLARE')] = 'weapon_flare',
    [joaat('WEAPON_FLAREGUN')] = 'weapon_flaregun',
    [joaat('WEAPON_FLASHLIGHT')] = 'weapon_flashlight',
    [joaat('WEAPON_G17')] = 'weapon_g17',
    [joaat('WEAPON_G19')] = 'weapon_g19',
    [joaat('WEAPON_GADGETPISTOL')] = 'weapon_gadgetpistol',
    [joaat('WEAPON_GOLFCLUB')] = 'weapon_golfclub',
    [joaat('WEAPON_GRENADE')] = 'weapon_grenade',
    [joaat('WEAPON_GRENADELAUNCHER')] = 'weapon_grenadelauncher',
    [joaat('WEAPON_GRENADELAUNCHER_SMOKE')] = 'weapon_grenadelauncher_smoke',
    [joaat('WEAPON_GUSENBERG')] = 'weapon_gusenberg',
    [joaat('WEAPON_HACKINGDEVICE')] = 'weapon_hackingdevice',
    [joaat('WEAPON_HAMMER')] = 'weapon_hammer',
    [joaat('WEAPON_HATCHET')] = 'weapon_hatchet',
    [joaat('WEAPON_HAZARDCAN')] = 'weapon_hazardcan',
    [joaat('WEAPON_HEAVYPISTOL')] = 'weapon_heavypistol',
    [joaat('WEAPON_HEAVYRIFLE')] = 'weapon_heavyrifle',
    [joaat('WEAPON_HEAVYSHOTGUN')] = 'weapon_heavyshotgun',
    [joaat('WEAPON_HEAVYSNIPER')] = 'weapon_heavysniper',
    [joaat('WEAPON_HEAVYSNIPER_MK2')] = 'weapon_heavysniper_mk2',
    [joaat('WEAPON_HOMINGLAUNCHER')] = 'weapon_hominglauncher',
    [joaat('WEAPON_KNIFE')] = 'weapon_knife',
    [joaat('WEAPON_KNUCKLE')] = 'weapon_knuckle',
    [joaat('WEAPON_MACHETE')] = 'weapon_machete',
    [joaat('WEAPON_MACHINEPISTOL')] = 'weapon_machinepistol',
    [joaat('WEAPON_MARKSMANPISTOL')] = 'weapon_marksmanpistol',
    [joaat('WEAPON_MARKSMANRIFLE')] = 'weapon_marksmanrifle',
    [joaat('WEAPON_MARKSMANRIFLE_MK2')] = 'weapon_marksmanrifle_mk2',
    [joaat('WEAPON_MG')] = 'weapon_mg',
    [joaat('WEAPON_MICROSMG')] = 'weapon_microsmg',
    [joaat('WEAPON_MILITARYRIFLE')] = 'weapon_militaryrifle',
    [joaat('WEAPON_MINIGUN')] = 'weapon_minigun',
    [joaat('WEAPON_MINISMG')] = 'weapon_minismg',
    [joaat('WEAPON_MOLOTOV')] = 'weapon_molotov',
    [joaat('WEAPON_MUSKET')] = 'weapon_musket',
    [joaat('WEAPON_NAVYREVOLVER')] = 'weapon_navyrevolver',
    [joaat('WEAPON_NIGHTSTICK')] = 'weapon_nightstick',
    [joaat('WEAPON_PETROLCAN')] = 'weapon_petrolcan',
    [joaat('WEAPON_PIPEBOMB')] = 'weapon_pipebomb',
    [joaat('WEAPON_PISTOL')] = 'weapon_pistol',
    [joaat('WEAPON_PISTOL50')] = 'weapon_pistol50',
    [joaat('WEAPON_PISTOL_MK2')] = 'weapon_pistol_mk2',
    [joaat('WEAPON_PISTOLXM3')] = 'weapon_pistolxm3',
    [joaat('WEAPON_POOLCUE')] = 'weapon_poolcue',
    [joaat('WEAPON_PRECISIONRIFLE')] = 'weapon_precisionrifle',
    [joaat('WEAPON_PROXMINE')] = 'weapon_proxmine',
    [joaat('WEAPON_PUMPSHOTGUN')] = 'weapon_pumpshotgun',
    [joaat('WEAPON_PUMPSHOTGUN_MK2')] = 'weapon_pumpshotgun_mk2',
    [joaat('WEAPON_RAILGUN')] = 'weapon_railgun',
    [joaat('WEAPON_RAILGUNXM3')] = 'weapon_railgunxm3',
    [joaat('WEAPON_RAYCARBINE')] = 'weapon_raycarbine',
    [joaat('WEAPON_RAYMINIGUN')] = 'weapon_rayminigun',
    [joaat('WEAPON_RAYPISTOL')] = 'weapon_raypistol',
    [joaat('WEAPON_REVOLVER')] = 'weapon_revolver',
    [joaat('WEAPON_REVOLVER_MK2')] = 'weapon_revolver_mk2',
    [joaat('WEAPON_RPG')] = 'weapon_rpg',
    [joaat('WEAPON_SAWNOFFSHOTGUN')] = 'weapon_sawnoffshotgun',
    [joaat('WEAPON_SMG')] = 'weapon_smg',
    [joaat('WEAPON_SMG_MK2')] = 'weapon_smg_mk2',
    [joaat('WEAPON_SMOKEGRENADE')] = 'weapon_smokegrenade',
    [joaat('WEAPON_SNIPERRIFLE')] = 'weapon_sniperrifle',
    [joaat('WEAPON_SNOWBALL')] = 'weapon_snowball',
    [joaat('WEAPON_SNOWLAUNCHER')] = 'weapon_snowlauncher',
    [joaat('WEAPON_SNSPISTOL')] = 'weapon_snspistol',
    [joaat('WEAPON_SNSPISTOL_MK2')] = 'weapon_snspistol_mk2',
    [joaat('WEAPON_SPECIALCARBINE')] = 'weapon_specialcarbine',
    [joaat('WEAPON_SPECIALCARBINE_MK2')] = 'weapon_specialcarbine_mk2',
    [joaat('WEAPON_STICKYBOMB')] = 'weapon_stickybomb',
    [joaat('WEAPON_STONE_HATCHET')] = 'weapon_stone_hatchet',
    [joaat('WEAPON_STUNGUN')] = 'weapon_stungun',
    [joaat('WEAPON_STUNGUN_MP')] = 'weapon_stungun_mp',
    [joaat('WEAPON_STUNROD')] = 'weapon_stunrod',
    [joaat('WEAPON_SWITCHBLADE')] = 'weapon_switchblade',
    [joaat('WEAPON_TACTICALRIFLE')] = 'weapon_tacticalrifle',
    [joaat('WEAPON_TECPISTOL')] = 'weapon_tecpistol',
    [joaat('WEAPON_TOLVECTOR')] = 'weapon_tolvector',
    [joaat('WEAPON_UNARMED')] = 'weapon_unarmed',
    [joaat('WEAPON_VINTAGEPISTOL')] = 'weapon_vintagepistol',
    [joaat('WEAPON_WRENCH')] = 'weapon_wrench',
}


local function clamp(value, minimum, maximum)
    return math.min(math.max(value, minimum), maximum)
end

local function isPlayerDead(ped)
    if IsEntityDead(ped) or IsPedDeadOrDying(ped, true) then
        return true
    end

    local playerData = QBCore.Functions.GetPlayerData()
    local metadata = playerData and playerData.metadata

    return metadata and (metadata.isdead == true or metadata.inlaststand == true) or false
end

local function getHealthPercent(ped)
    -- Force the health bar to zero during death/last stand.
    if isPlayerDead(ped) then
        return 0
    end

    local maxHealth = GetEntityMaxHealth(ped)
    local currentHealth = GetEntityHealth(ped)

    -- GTA peds normally use 100 as the non-playable health baseline.
    if maxHealth > 100 then
        return clamp(math.floor(((currentHealth - 100) / (maxHealth - 100)) * 100 + 0.5), 0, 100)
    end

    return clamp(math.floor((currentHealth / math.max(maxHealth, 1)) * 100 + 0.5), 0, 100)
end

local function getWeaponInfo(ped)
    local weaponHash = GetSelectedPedWeapon(ped)

    if weaponHash == joaat('WEAPON_UNARMED') then
        return false, weaponHash, '', '', 0, 0
    end

    local sharedWeapon = QBCore.Shared.Weapons and QBCore.Shared.Weapons[weaponHash]
    local imageKey = sharedWeapon and sharedWeapon.name and string.lower(sharedWeapon.name) or WeaponImageKeys[weaponHash] or ''
    local label = sharedWeapon and sharedWeapon.label or nil

    if not label then
        local displayKey = GetWeaponDisplayNameFromHash(weaponHash)
        local translated = displayKey and GetLabelText(displayKey) or nil
        label = translated and translated ~= 'NULL' and translated or 'WEAPON'
    end

    local totalAmmo = GetAmmoInPedWeapon(ped, weaponHash)
    local hasClip, clipAmmo = GetAmmoInClip(ped, weaponHash)
    clipAmmo = hasClip and clipAmmo or totalAmmo
    local reserveAmmo = math.max(totalAmmo - clipAmmo, 0)

    return true, weaponHash, imageKey, label, clipAmmo, reserveAmmo
end

local function sendSetup()
    SendNUIMessage({
        action = 'setup',
        accent = Config.AccentColor,
        armorColor = Config.ArmorColor,
        position = Config.Position,
        offsetX = Config.OffsetX,
        offsetY = Config.OffsetY,
        speed = Config.AnimationSpeed,
        alwaysShowArmor = Config.AlwaysShowArmor
    })
end

local function setHudVisible(state)
    if visible == state then return end
    visible = state
    SendNUIMessage({ action = 'visible', visible = state })
end

local function registerKill()
    killCount = killCount + 1
    killTimerToken = killTimerToken + 1
    local currentToken = killTimerToken

    SendNUIMessage({
        action = 'kill',
        visible = true,
        count = killCount
    })

    SetTimeout(Config.KillDisplayTime or 10000, function()
        if currentToken ~= killTimerToken then return end

        killCount = 0
        SendNUIMessage({ action = 'kill', visible = false, count = 0 })
    end)
end

RegisterNetEvent('qb-right-hud:client:RegisterKill', registerKill)

AddEventHandler('gameEventTriggered', function(eventName, eventData)
    if eventName ~= 'CEventNetworkEntityDamage' then return end

    local victim = eventData[1]
    local attacker = eventData[2]
    local playerPed = PlayerPedId()
    local localPlayerAttacked = attacker == playerPed

    if DoesEntityExist(attacker) and IsEntityAVehicle(attacker) then
        localPlayerAttacked = GetPedInVehicleSeat(attacker, -1) == playerPed
    end

    if not localPlayerAttacked or victim == playerPed then return end
    if not DoesEntityExist(victim) or not IsEntityAPed(victim) or not IsPedAPlayer(victim) then return end
    if not IsEntityDead(victim) and GetEntityHealth(victim) > 0 then return end

    local now = GetGameTimer()
    if victim == lastKilledEntity and (now - lastKillAt) < 1500 then return end

    lastKilledEntity = victim
    lastKillAt = now
    registerKill()
end)

RegisterCommand('t123', function()
    registerKill()
end, false)

-- Native HUD elements must be hidden every frame.
CreateThread(function()
    while true do
        if Config.HideDefaultAmmo then
            DisplayAmmoThisFrame(false)
            HideHudComponentThisFrame(2) -- WEAPON_ICON / native ammo display
        end
        Wait(0)
    end
end)

CreateThread(function()
    Wait(700)
    sendSetup()

    while true do
        local ped = PlayerPedId()
        local pauseActive = IsPauseMenuActive()
        local shouldShow = not (Config.HideOnPause and pauseActive)

        if pauseActive ~= lastPause then
            lastPause = pauseActive
            setHudVisible(shouldShow)
        end

        if shouldShow and DoesEntityExist(ped) then
            local health = getHealthPercent(ped)
            local armor = clamp(GetPedArmour(ped), 0, 100)

            if health ~= lastHealth or armor ~= lastArmor then
                lastHealth = health
                lastArmor = armor
                SendNUIMessage({
                    action = 'update',
                    health = health,
                    armor = armor
                })
            end

            local weaponVisible, weaponHash, weaponImageKey, weaponLabel, clipAmmo, reserveAmmo = getWeaponInfo(ped)
            if weaponHash ~= lastWeaponHash or clipAmmo ~= lastClipAmmo or reserveAmmo ~= lastReserveAmmo then
                lastWeaponHash = weaponHash
                lastClipAmmo = clipAmmo
                lastReserveAmmo = reserveAmmo

                SendNUIMessage({
                    action = 'weapon',
                    visible = weaponVisible,
                    key = weaponImageKey,
                    name = weaponLabel,
                    clip = clipAmmo,
                    reserve = reserveAmmo
                })
            end
        end

        Wait(Config.UpdateInterval)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(500)
    sendSetup()
    setHudVisible(true)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    setHudVisible(false)
end)

RegisterCommand('togglehud', function()
    setHudVisible(not visible)
end, false)

exports('SetHudVisible', setHudVisible)
