if not Locales then
    Locales = {}
end

Locales["dk"] = {
    MainMenu = {
        title = "Administrér jobs",
        jobList = {
            title = "Dine jobs",
            description = "Tryk for at se dine nuværende jobs",
            icon = "fa-solid fa-clipboard-list",
        },
        currentJob = {
            title = "Nuværende job",
            description = "%s | %s",
        },
    },

    JobListMenu = {
        title = "Administrér jobs",
        label = "%s | %s",
        description = "Tryk for at administrere",
    },

    EditJobMenu = {
        title = "Handlinger for %s",
        
        setAsActive = {
            title = "Sæt som aktivt job",
            description = "Tryk for at gøre dette job som dit aktive job",
            icon = "fa-solid fa-square-check"
        },
        deleteJob = {
            title = "Fjern job",
            description = "Tryk for at sige op og fjerne dette job",
            icon = "fa-solid fa-trash-can",
            dialog = {
                header = "Fjern job",
                content = "Accepter for at fjerne %s",
            }
        }
    },

    Notifications = {
        removeJob = {
            success = {
                title = "Multijobs",
                description = "Fjernede %s",
                type = "success",
            },
            error = {
                title = "Multijobs",
                description = "Der opstod en fejl",
                type = "error",
            }
        },
        setActiveJob = {
            success = {
                title = "Multijobs",
                description = "Du ændrede dit aktive job",
                type = "success",
            },
            jobalreadyactive = {
                title = "Multijobs",
                description = "Job allerede aktivt",
                type = "inform",
            },
            error = {
                title = "Multijobs",
                description = "Der opstod en fejl",
                type = "error",
            }
        }
    }
}