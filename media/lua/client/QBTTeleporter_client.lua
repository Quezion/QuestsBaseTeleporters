require "Map/CGlobalObject"

-- local qbt = require "QBTUtilities"
local CTeleporter = CGlobalObject:derive("CTeleporter")

function CTeleporter:new(luaSystem, globalObject)
   return CGlobalObject.new(self, luaSystem, globalObject)
end

function CTeleporter:fromModData(modData)
   self.id = modData["id"]
   self.name = modData["name"]
   self.on = modData["on"]
end

return CTeleporter