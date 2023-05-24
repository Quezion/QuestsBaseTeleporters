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
   -- Disabled b/c current architecture relies on hourly command being sent from server
   -- if isClient() then
   --    Events.EveryTenMinutes.Add(TpSystem.updateTeleportersForClient)
   -- end
end

function TpSystem:newLuaObject(globalObject)
   return Teleporter:new(self, globalObject)
end

--called by java receiveNewLuaObjectAt
function TpSystem:newLuaObjectAt(x, y, z)
   -- print("TpSystem:newLuaObjectAt adding luaObject "..x..','..y..','..z)
   local globalObject = self.system:newObject(x, y, z)
   local luaObject = self:newLuaObject(globalObject)
   -- Assumedly can't add Telepoint here because modData is not yet been received,
   -- but this could use testing
   return luaObject
end

function TpSystem:OnServerCommand(name, args)
   local command = self.Commands[name]
   -- print("QBTTeleporterSystem_client received server command = " .. tostring(name))
   if command ~= nil then
      command(args)
   else
      print("QBTTeleporterSystem_client couldn't find matching command to run")
   end
end

function TpSystem:isValidIsoObject(isoObject)
   return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "baseteleporters_tileset_01_0"
end

-- Disabled b/c current architecture relies on hourly command being sent from server
-- Client variation of the server "updateTeleporters", might run before new data is received
-- function TpSystem.updateTeleportersForClient()
--    print("qbt.TpSystem.updateTeleportersForClient() called")
--    local numTeleporters = TpSystem.instance:getLuaObjectCount()
--    print(string.format("qbt.updateTeleportersForClient running on %d teleporters", numTeleporters))
--    for i=1,TpSystem.instance:getLuaObjectCount() do
--       local tp = TpSystem.instance:getLuaObjectByIndex(i)
--       local isotp = tp:getIsoObject()
--       if isotp then
--          tp:fromModData(isotp:getModData())
--          if tp.id then
--             -- print(string.format("qbt.updateTeleportersForClient/telepoints[%d]: Adding %s %s at: %d, %d, %d",
--             --                     i,tp.id,tp.name,tp.x,tp.y,tp.z))
--             qbt.Telepoints.Add(tp.id,tp.name,isotp:getX(),isotp:getY(),isotp:getZ())
--          end
--       end
--    end
-- end

CGlobalObjectSystem.RegisterSystemClass(TpSystem)

return TpSystem