Lang = Config.Language

-- Making command to open the jobs menu
RegisterCommand(Config.MenuCommand , function ()
    OpenMenu()
end, false)

-- Making keybind to open the job menu
RegisterKeyMapping("jobs", Config.KeybindDescription, "keyboard", Config.Keybind)