SVConfig = {}

SVConfig.webhookURL = ""
SVConfig.MultiCharESX = true
SVConfig.Debug = true

Debug = function(...)
  if SVConfig.Debug then
    print("[DEBUG] " .. ...)
  end
end