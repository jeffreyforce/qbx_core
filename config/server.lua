return {
    updateInterval = 5, -- how often to update player data in minutes

    money = {
        ---@alias MoneyType 'cash' | 'bank' | 'crypto'
        ---@alias Money {cash: number, bank: number, crypto: number}
        ---@type Money
        moneyTypes = { cash = 500, bank = 5000, crypto = 0 }, -- type = startamount - Add or remove money types for your server (for ex. blackmoney = 0), remember once added it will not be removed from the database!
        dontAllowMinus = { 'cash', 'crypto' }, -- Money that is not allowed going in minus
        paycheckTimeout = 10, -- The time in minutes that it will give the paycheck
        paycheckSociety = false -- If true paycheck will come from the society account that the player is employed at, requires qb-management
    },

    player = {
        hungerRate = 4.2, -- Rate at which hunger goes down.
        thirstRate = 3.8, -- Rate at which thirst goes down.

        ---@enum BloodType
        bloodTypes = {
            "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
        },

        ---@alias UniqueIdType 'citizenid' | 'AccountNumber' | 'PhoneNumber' | 'FingerId' | 'WalletId' | 'SerialNumber'
        ---@type table<UniqueIdType, {valueFunction: function}>
        identifierTypes = {
            citizenid = {
                valueFunction = function()
                    return tostring(RandomLetter(3) .. RandomNumber(5)):upper()
                end,
            },
            AccountNumber = {
                valueFunction = function()
                    return 'US0' .. math.random(1, 9) .. 'QBX' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
                end,
            },
            PhoneNumber = {
                valueFunction = function()
                    return math.random(100,999) .. math.random(1000000,9999999)
                end,
            },
            FingerId = {
                valueFunction = function()
                    return tostring(RandomLetter(2) .. RandomNumber(3) .. RandomLetter(1) .. RandomNumber(2) .. RandomLetter(3) .. RandomNumber(4))
                end,
            },
            WalletId = {
                valueFunction = function()
                    return 'QB-' .. math.random(11111111, 99999999)
                end,
            },
            SerialNumber = {
                valueFunction = function()
                    return math.random(11111111, 99999999)
                end,
            },
        }
    },


    ---@alias TableName string
    ---@alias ColumnName string
    ---@type table<TableName, ColumnName>
    characterDataTables = {
        players = 'citizenid',
        apartments = 'citizenid',
        bank_accounts_new = 'id',
        crypto_transactions = 'citizenid',
        phone_invoices = 'citizenid',
        phone_messages = 'citizenid',
        playerskins = 'citizenid',
        player_contacts = 'citizenid',
        player_houses = 'citizenid',
        player_mails = 'citizenid',
        player_outfits = 'citizenid',
        player_vehicles = 'citizenid',
    }, -- Rows to be deleted when the character is deleted


    server = {
        pvp = true, -- Enable or disable pvp on the server (Ability to shoot other players)
        closed = false, -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
        closedReason = 'Server Closed', -- Reason message to display when people can't join the server
        whitelist = false, -- Enable or disable whitelist on the server
        whitelistPermission = 'admin', -- Permission that's able to enter the server when the whitelist is on
        discord = '', -- Discord invite link
        checkDuplicateLicense = false, -- Check for duplicate rockstar license on join
        permissions = { 'god', 'admin', 'mod' }, -- Add as many groups as you want here after creating them in your server.cfg
    },

    characters = {
        playersNumberOfCharacters = { -- Define maximum amount of player characters by rockstar license (you can find this license in your server's database in the player table)
            ['license2:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = 5,
        },

        defaultNumberOfCharacters = 3, -- Define maximum amount of default characters (maximum 3 characters defined by default)
    },

    ---@type { name: string, amount: integer, metadata: fun(source: number): table }[]
    starterItems = { -- Character starting items
        { name = 'phone', amount = 1 },
        { name = 'id_card', amount = 1, metadata = function(source)
                if GetResourceState('qbx_idcard') ~= 'started' then
                    error('qbx_idcard resource not found. Required to give an id_card as a starting item')
                end
                return exports.qbx_idcard:GetMetaLicense(source, {'id_card'})
            end
        },
        { name = 'driver_license', amount = 1, metadata = function(source)
                if GetResourceState('qbx_idcard') ~= 'started' then
                    error('qbx_idcard resource not found. Required to give an id_card as a starting item')
                end
                return exports.qbx_idcard:GetMetaLicense(source, {'driver_license'})
            end
        },
    },

    -- this configuration is for core events only. putting other webhooks here will have no effect
    logging = {
        webhook = {
            ['default'] = nil, -- default
            ['joinleave'] = nil, -- default
            ['ooc'] = nil, -- default
            ['anticheat'] = nil, -- default
            ['playermoney'] = nil, -- default
        },
        role = {} -- Role to tag for high priority logs. Roles use <@%roleid> and users/channels are <@userid/channelid>
    },

    giveVehicleKeys = function(src, plate)
        return exports.qbx_vehiclekeys:GiveKeys(src, plate)
    end,

    getSocietyAccount = function(accountName)
        return exports.qbx_management:GetAccount(accountName)
    end,
    
    removeSocietyMoney = function(accountName, payment)
        return exports.qbx_management:RemoveMoney(accountName, payment)
    end
}