require "Map/CGlobalObjectSystem"

local qbt = require "QBTUtilities"
local Teleporter = require "QBTTeleporter_client"
local TpSystem = CGlobalObjectSystem:derive("QBTTeleporterSystem_client")

function TpSystem:new()
   local o = CGlobalObjectSystem.new(self, "qbt_teleporter")
   qbt.TpSystem_client = o
   return o
end

function TpSystem:initSystem()
   if isClient() then
      Events.EveryTenMinutes.Add(TpSystem.updateTeleportersForClient)
   end
end

function TpSystem:newLuaObject(globalObject)
   return Teleporter:new(self, globalObject)
end

--called by java receiveNewLuaObjectAt
function TpSystem:newLuaObjectAt(x, y, z)
   self:noise("adding luaObject "..x..','..y..','..z)
   local globalObject = self.system:newObject(x, y, z)
   return self:newLuaObject(globalObject)
end

--this might run before new data is received
function TpSystem.updateTeleportersForClient()
   for i=1,TpSystem.instance:getLuaObjectCount() do
      local tp = TpSystem.instance:getLuaObjectByIndex(i)
      local isotp = tp:getIsoObject()
      if isotp then
         tp:fromModData(isotp:getModData())
      end
   end
end

function TpSystem:isValidIsoObject(isoObject)
   return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "baseteleporters_tileset_01_0"
end

CGlobalObjectSystem.RegisterSystemClass(TpSystem)

return TpSystem