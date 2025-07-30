return {
    Core = {
        Cash = 999999999,
        Wins = 0,
        Bubbles = 0,
        bubbleSize = 0.5,
        chestRedeem = 0,
        equippedLimit = 3,
        inventoryLimit = 50,

        equippedBubble = "bubblegum",

        Pets = {},
        Worlds = {},
        Islands = {},
        Flavors = {},
        goldenPets = {},
        equippedPets = {},
        Potions = {
            ["50bubbles"] = {timer = 0, active = false, amount = 0},
            ["50cash"] = {timer = 0, active = false, amount = 0},
            ["50luck"] = {timer = 0, active = false, amount = 0},
            ["speedHatch"] = {timer = 0, active = false, amount = 0},
        },
        dailyRewards = {
            streak = 1,
            lastClaim = os.time(),
            rewardsClaimed = {},
        },
        playRewards = {
            startTime = nil,
            redeemedRewards = {},
        },
        Settings = {
            music = 50,
            sfx = 50,
            showPets = true,
            popups = false,
        }
    },

    Analytics = {
        avgPlaytime = 0,
        allTime = 0,
        biggestBubble = 0,
        
    },

    Purchases = {
        Gamepasses = {},
        DevProducts = {},
    },

    Admin = {
        IsNewPlayer = true,
        IsInGroup = false,

        Codes = {},
        Badges = {},
        Warnings = {},
        Banned = false,
    },
}