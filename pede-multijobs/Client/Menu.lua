-- Main job menu
function OpenMenu()
    local player = ESX.GetPlayerData()
    local playerJob = player.job.label
    local playerGrade = player.job.grade_label

    lib.registerContext({
        id = 'job:menu_main',
        title = Locales[Lang].MainMenu.title,
        options = {
          {
            title = Locales[Lang].MainMenu.jobList.title,
            description = Locales[Lang].MainMenu.jobList.description,
            icon = Locales[Lang].MainMenu.jobList.icon,
            onSelect = function ()
                GetJobs()
            end,
          },
          {
            title = Locales[Lang].MainMenu.currentJob.title,
            description = string.format(Locales[Lang].MainMenu.currentJob.description, playerJob, playerGrade),
          }
        }
      })
     
      lib.showContext('job:menu_main')
end

-- When the player has opened the job list menu
function GetJobs()
    local options = {}

    ESX.TriggerServerCallback("get:all:playerjobs", function(list, jobnames)
            for k, v in pairs(list) do
                local icon = "fa-solid fa-user"
                if Config.JobIcons[v.name] ~= nil then
                    icon = Config.JobIcons[v.name]
                end

                table.insert(options, {
                    title = string.format(Locales[Lang].JobListMenu.label, v.label, v.gradelabel),
                    icon = icon,
                    description = Locales[Lang].JobListMenu.description,
                    onSelect = function ()
                        EditJob(v.name, v.label, jobnames)
                    end,
                })
            end
            
            lib.registerContext({
                id = 'job:menu_joblist',
                title = Locales[Lang].JobListMenu.title,
                menu = "job:menu_main",
                options = options
            })
        
            lib.showContext('job:menu_joblist')
    end)
end

-- edit player job select it delete it
function EditJob(job, label, joblist)
    lib.registerContext({
        id = 'job:menu_editjob:'..job.name,
        title = (Locales[Lang].EditJobMenu.title):format(label),
        menu = "job:menu_joblist",
        options = {
            {
                icon = Locales[Lang].EditJobMenu.setAsActive.icon,
                title = Locales[Lang].EditJobMenu.setAsActive.title,
                description = Locales[Lang].EditJobMenu.setAsActive.description,
                onSelect = function ()
                    SetJob(job.name, job.grade)
                end,
            },
            {
                icon = Locales[Lang].EditJobMenu.deleteJob.icon,
                title = Locales[Lang].EditJobMenu.deleteJob.title,
                description = Locales[Lang].EditJobMenu.deleteJob.description,
                onSelect = function ()
                    local confirmDialog = lib.alertDialog({
                        header = Locales[Lang].EditJobMenu.deleteJob.dialog.header,
                        content = (Locales[Lang].EditJobMenu.deleteJob.dialog.content):format(label),
                        centered = true,
                        cancel = true
                    })

                    if confirmDialog == "confirm" then
                        local index = IndexOf(joblist, job.name)

                        if index == nil then
                            print("Fejl")
                        return end

                        table.remove(joblist, index)
                        RemoveJob(joblist, label)
                    end
                end
            }
        }
    })

    lib.showContext('job:menu_editjob:'..job.name)
end