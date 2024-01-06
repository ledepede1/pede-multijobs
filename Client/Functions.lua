function IndexOf(array, value)
    for i, v in ipairs(array) do
        if v.name == value then
            return i
        end
    end
    return nil
end

-- Creating function to handle when the player removes one of his jobs
function RemoveJob(joblist, jobLabel)
    ESX.TriggerServerCallback("delete:job", function(cb)
        if cb == false then
            lib.notify({
                title = Locales[Lang].Notifications.removeJob.error.title,
                description = Locales[Lang].Notifications.removeJob.error.description,
                type = Locales[Lang].Notifications.removeJob.error.type
            })
        return end

        lib.notify({
            title = Locales[Lang].Notifications.removeJob.success.title,
            description = (Locales[Lang].Notifications.removeJob.success.description):format(jobLabel),
            type = Locales[Lang].Notifications.removeJob.success.type
        })
    end, json.encode(joblist))
end

-- Creating function to handle when player change his current job
function SetJob(job, grade)
    local player = ESX.PlayerData

    if player.job.name == job then
        lib.notify({
            title = Locales[Lang].Notifications.setActiveJob.jobalreadyactive.title,
            description = Locales[Lang].Notifications.setActiveJob.jobalreadyactive.description,
            type = Locales[Lang].Notifications.setActiveJob.jobalreadyactive.type
        })
    return end

    ESX.TriggerServerCallback("set:job", function(cb)
        if cb == true then
            lib.notify({
                title = Locales[Lang].Notifications.setActiveJob.success.title,
                description = Locales[Lang].Notifications.setActiveJob.success.description,
                type = Locales[Lang].Notifications.setActiveJob.success.type
            })
        else
            lib.notify({
                title = Locales[Lang].Notifications.setActiveJob.error.title,
                description = Locales[Lang].Notifications.setActiveJob.error.description,
                type = Locales[Lang].Notifications.setActiveJob.error.type
            })
        end
    end, job, grade)
end