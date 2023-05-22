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
   print("TpSystem:newLuaObjectAt adding luaObject "..x..','..y..','..z)
   local globalObject = self.system:newObject(x, y, z)
   local luaObject = self:newLuaObject(globalObject)
   -- local luaObjectId = luaObject.id
   -- if luaObjectId then
   --    self:noise("Lua Object ID = " .. luaObjectId)
   -- end
   --qbt.Telepoints.Add(,x,y,z) -- can't run here because modData might not have been received?
   return luaObject
end

function TpSystem:receiveServerCommand(name, args)
   local command = self.Commands[command]
   if command ~= nil then
      command(args)
   end
end

function TpSystem:isValidIsoObject(isoObject)
   return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "baseteleporters_tileset_01_0"
end

--Client variation of the server "updateTeleporters", might run before new data is received
function TpSystem.updateTeleportersForClient()
   print("qbt.TpSystem.updateTeleportersForClient() called")
   local numTeleporters = TpSystem.instance:getLuaObjectCount()
   print(string.format("qbt.updateTeleportersForClient running on %d teleporters", numTeleporters))
   -- for i=0,numTeleporters - 1 do
   --    local teleporter = TpSystem.instance.system:getObjectByIndex(i):getModData()
   --    qbt.Telepoints.Add(teleporter.id,teleporter.name,teleporter.x,teleporter.y,teleporter.z)
   -- end
   for i=1,TpSystem.instance:getLuaObjectCount() do
      local tp = TpSystem.instance:getLuaObjectByIndex(i)
      local isotp = tp:getIsoObject()
      if isotp then
         tp:fromModData(isotp:getModData())
         if tp.id then
            print(string.format("qbt.updateTeleportersForClient/telepoints[%d]: Adding %s %s at: %d, %d, %d",
                                i,tp.id,tp.name,tp.x,tp.y,tp.z))
            qbt.Telepoints.Add(tp.id,tp.name,isotp:getX(),isotp:getY(),isotp:getZ())
         end
      end
   end
end

CGlobalObjectSystem.RegisterSystemClass(TpSystem)

return TpSystem