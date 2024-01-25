if SVConfig.MultiCharESX then
  ESX = exports["es_extended"]:getSharedObject()
end

-- Log to webhook
function Log(msg)
    local embeds = {
          {
              ["title"] = "Pede Multijobs",
              ["description"] = msg,
          }
    }
    PerformHttpRequest(SVConfig.webhookURL, function(err, text, headers) end, 'POST', json.encode({username = 'Pede-Multijobs', embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

-- Function to get players license
function GetPlayerCFXID(player)
    local value = -1

    if SVConfig.MultiCharESX then
        return ESX.GetPlayerFromId(player).identifier or "DIDNT FIND IDENTIFIER"
    else
        for _,v in pairs(GetPlayerIdentifiers(player)) do
            if string.sub(v, 1, string.len("license:")) == "license:" then
                value = v
                return value
            end
        end
        return value
    end
end

-- Get all of the needed information and get into one table
function HandleJob(jobNames)
    local jobss = {}

    for _, jobs in pairs(ESX.GetJobs()) do
        for _, v in pairs(jobNames) do
            if jobs.name == v.name then
                local grade = "None"

                if jobs.grades then
                    for _, gradeInfo in pairs(jobs.grades) do
                        if gradeInfo.grade == v.grade then
                            grade = gradeInfo.label
                            break
                        end
                    end
                end

                table.insert(jobss, {
                    name = v,
                    grade = v.grade,
                    label = jobs.label,
                    gradelabel = grade,
                })
                break
            end 
        end
    end
    return jobss
end

-- Check if the given value is inside the given table
function CheckTable(tab, val)
    for _, v in pairs(tab) do
        if v.name == val then
            return true
        end   
    end
    return false
end

-- Check what index the given value is inside an array
function IndexOf(array, value)
    for i, v in ipairs(array) do
        if v.name == value then
            return i
        end
    end
    return nil
end

-- Admin command to delete people from there jobs
ESX.RegisterCommand({Config.AdminCommand}, 'admin', function(xPlayer, args, showError)
    if args.id and args.job == nil then return end
    TriggerEvent("delete:player:job", GetPlayerCFXID(args.id), args.job, xPlayer)
  end, false, {help = "Fyr en spiller fra et job", arguments = {
    {name = 'id', help = "Spillerens id", type = 'number'},
    {name = 'job', help = "Job navn som spilleren skal fyres fra", type = 'any'}
    }   
  })

-- Event to remove player from the specified job should be used in things like esx_society or other boss menus
RegisterNetEvent("delete:player:job")
AddEventHandler("delete:player:job", function (id, job, xplayer)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then
        xPlayer = xplayer
    end

    local license = id

    if xPlayer.job.grade_name == Config.BossName or xPlayer.getGroup() == "admin" then
        -- For dem som bruger eventet med esx society
        if GetResourceState("esx_society") == "started" and not SVConfig.MultiCharESX then
            if string.find(id, "char1:") then
                license = string.gsub(id, "char1:", "license:")
            end
        end

        local currentJobs = MySQL.query.await('SELECT `jobs` FROM `pede-multijobs` WHERE `cfxlicense` = ?', {
            license
        })
        local jobsTable = {}
        jobsTable = json.decode(currentJobs[1].jobs)

        if CheckTable(jobsTable, job) then 
            local index = IndexOf(jobsTable, job)
            table.remove(jobsTable, index)

            MySQL.query.await('UPDATE `pede-multijobs` SET `jobs` = ? WHERE `cfxlicense` = ?', {
                json.encode(jobsTable), license
            })
        else
            print("Personen har ikke dette job")
        end
    else
        Debug("Fejl ved linje 95 - 132 (Print ved linje 130)")
    end
end)

-- This gets triggered every time the player get new job
RegisterNetEvent('esx:setJob', function(player, job, _)
    local license = GetPlayerCFXID(player)
    local currentJobs = MySQL.query.await('SELECT `jobs` FROM `pede-multijobs` WHERE `cfxlicense` = ?', {
        license
    })
    local jobsTable = {}
    local doesntHaveAny = false

    if job.name ~= Config.DefaultJob then
    if currentJobs[1].jobs == "[]" or currentJobs[1].jobs == nil or currentJobs[1].jobs == "" then
        doesntHaveAny = true
    else
        jobsTable = json.decode(currentJobs[1].jobs)
    end

    if not CheckTable(jobsTable, job.name) or doesntHaveAny == true then
        table.insert(jobsTable, {
            name = job.name,
            grade = job.grade,
        }) 

        MySQL.query.await('UPDATE `pede-multijobs` SET `jobs` = ? WHERE `cfxlicense` = ?', {
            json.encode(jobsTable), license
        })
        end
    end
end)

-- When player is loaded check if they are in the database and if not add them
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(player, xPlayer, _)
    local license = GetPlayerCFXID(player)

    local response = MySQL.query.await('SELECT `cfxlicense` FROM `pede-multijobs` WHERE `cfxlicense` = ?', {
        license
    })

    if response[1].cfxlicense ~= license then
        local jobTable = {}

        local currentJob = xPlayer.job.name

        table.insert(jobTable, currentJob)
        local jsonJob = json.encode(jobTable)

        MySQL.insert('INSERT INTO `pede-multijobs` (cfxlicense, jobs) VALUES (?, ?)', {
            license, jsonJob
        })
    end
end)

-- When player change his active job
ESX.RegisterServerCallback("set:job", function (src, cb, job, grade)
    local xPlayer = ESX.GetPlayerFromId(src)
    local license = GetPlayerCFXID(src)

    local jobs = {}
    local isAllowed = false

    local playerJobs = MySQL.query.await('SELECT `jobs` FROM `pede-multijobs` WHERE `cfxlicense` = ?', {
        license
    })
    jobs = json.decode(playerJobs[1].jobs)

    for _, v in pairs(jobs) do
        if v.name == job then
            isAllowed = true
            break
        end
    end

    if isAllowed then
        if ESX.DoesJobExist(job, grade) then
            xPlayer.setJob(job, grade)
            cb(true)
            Log(string.format("ID: %s\n Har ændret sit aktive job til %s\nGRADE: %s", src, job, grade))
        else
            Log(string.format("ID: %s\n Prøvede at ændre sit aktive job", src))
            cb(false)
        end
    else
        Log(string.format("ID: %s\n Prøvede at ens aktive job", src))
        cb(false)
    end
end)

-- When player delete one of his jobs
ESX.RegisterServerCallback("delete:job", function (src, cb, joblist)
    local license = GetPlayerCFXID(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    local getLicense = MySQL.query.await('SELECT `cfxlicense` FROM `pede-multijobs` WHERE `cfxlicense`=?', {
        license
    })

    if license == getLicense[1].cfxlicense then
        MySQL.query.await('UPDATE `pede-multijobs` SET `jobs` = ? WHERE `cfxlicense` = ?', {
            joblist, license
        })
        xPlayer.setJob(Config.DefaultJob, 0)
        cb(true)

        Log(("ID: %s\n Har fjernet et job fra sig selv"):format(src))
    else
        cb(false)
    end
end)

-- Get list of alle players jobs with grades and so on
ESX.RegisterServerCallback("get:all:playerjobs", function (src, cb)
    local license = GetPlayerCFXID(src)

    local response = MySQL.query.await('SELECT `jobs` FROM `pede-multijobs` WHERE `cfxlicense` = ?', {
        license
    })

    if response and response[1] and response[1].jobs then
        local jobsString = response[1].jobs

        local jobsTable = json.decode(jobsString)
        local jobsTableMerged = HandleJob(jobsTable)

        cb(jobsTableMerged, jobsTable)
    else
        Debug("Fejl ved linje 244 - 262 (Print ved linje 259)")
        cb(nil)
    end
end)

