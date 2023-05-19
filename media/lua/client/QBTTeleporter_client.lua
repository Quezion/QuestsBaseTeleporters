require "Map/CGlobalObject"

-- local qbt = require "QBTUtilities"
local CTeleporter = CGlobalObject:derive("CTeleporter")

function CTeleporter:new(luaSystem, globalObject)
   return CGlobalObject.new(self, luaSystem, globalObject)
end

-- TODO: register with Telepoints somewhere in here? or somewhere higher up?
function CTeleporter:fromModData(modData)
   self.on = modData["on"]
   self.id = modData["id"]
   self.name = modData["name"]
end

return CTeleporter