--[[
 DataSystem.lua
 Author: Nuubzzz (based on EnDarke's structure)
 Description: Handles player data loading, saving, and mutation using loleris's ProfileStore
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local events = game.ReplicatedStorage.events
local updateData = events.client.updateData

-- Config and dependencies
local ProfileStore = require(script.Parent.ProfileStore)
local DATA_SETTINGS = require(script.Parent.DATA_SETTINGS)
local PLAYER_DATA_FORMAT = require(script.Parent.PLAYER_DATA_FORMAT)

local STORE_KEY = DATA_SETTINGS.DATA_VERSION
local PlayerStore = ProfileStore.New(STORE_KEY, PLAYER_DATA_FORMAT)

if DATA_SETTINGS.FORCE_MOCK or (RunService:IsStudio() and not DATA_SETTINGS.FORCE_SAVE_DATA) then
    PlayerStore = PlayerStore.Mock
end

local Profiles = {}

local DataSystem = {}

-- Utility: Waits for DataLoaded or times out
local function waitForDataLoaded(player)
    if player:GetAttribute("DataLoaded") then return true end

    local success = false
    local conn
    conn = player:GetAttributeChangedSignal("DataLoaded"):Connect(function()
        if player:GetAttribute("DataLoaded") then
            success = true
            conn:Disconnect()
        end
    end)

    task.wait(2)
    if conn.Connected then conn:Disconnect() end
    return success
end

-- Called when a player joins
function DataSystem.PlayerAdded(player)
    local userId = player.UserId
    local profile = PlayerStore:StartSessionAsync(tostring(userId), {
        Cancel = function()
            return not player:IsDescendantOf(Players)
        end
    })

    if not profile then
        player:Kick("Data failed to load. Please rejoin.")
        return
    end

    profile:AddUserId(userId)
    profile:Reconcile()

    profile.OnSessionEnd:Connect(function()
        Profiles[player] = nil
        player:Kick("Your data session expired. Please rejoin.")
    end)

    if not player:IsDescendantOf(Players) then
        profile:EndSession()
        return
    end

    Profiles[player] = profile
    player:SetAttribute("DataLoaded", true)
end

-- Called when a player leaves
function DataSystem.PlayerRemoving(player)
    local profile = Profiles[player]
    if profile then
        profile:EndSession()
        Profiles[player] = nil
    end
end

-- Access data
function DataSystem:Get(player, from, key)
    if not player:IsDescendantOf(Players) then return end
    if not player:GetAttribute("DataLoaded") then
        waitForDataLoaded(player)
    end

    local profile = Profiles[player]
    local data = profile and profile.Data
    if not data then return end

    if from then
        if key then
            return data[from][key]
        else
            return data[from]
        end
    end

    return data
end

-- Set data
function DataSystem:Set(player, from, key, value)
    if not player:GetAttribute("DataLoaded") then
        waitForDataLoaded(player)
    end

    local data = DataSystem:Get(player)
    if not data or not from then return end

    if key then
        data[from][key] = value
    else
        data[from] = value
    end

    -- Optional: Mirror into leaderstats
    local leader = player:FindFirstChild("leaderstats")
    if leader and key then
        local stat = leader:FindFirstChild(key)
        if stat then stat.Value = value end
    end

    return true
end

-- Update data using a callback
function DataSystem:Update(player, from, key, callback)
    if not player:GetAttribute("DataLoaded") then
        waitForDataLoaded(player)
    end

    local current = self:Get(player, from, key)
    if current == nil then return end

    local updated = callback(current)
    if updated ~= nil then
        updateData:FireClient(player, {from = from, key = key, value = updated, updateUI = true})

        return self:Set(player, from, key, updated)
    end
    
    return false
end

-- Optional: Manual save (can be hooked to buttons or checkpoints)
function DataSystem:Save(player)
    local profile = Profiles[player]
    if profile then
        profile:SaveAsync()
        print("saved")
    end
end

-- Startup hook (optional)
function DataSystem:Init() end

function DataSystem:Start() end

return DataSystem
