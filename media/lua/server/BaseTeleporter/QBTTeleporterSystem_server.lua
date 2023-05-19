--[[
"qbt_teleporter" server system, registers new teleporters
--]]

if isClient() then return end

require "Map/SGlobalObjectSystem"
local qbt = require "QBTUtilities"
local BaseTeleporter = require "BaseTeleporter/QBTBaseTeleporter_server"

local TpSystem = SGlobalObjectSystem:derive("QBTBaseTeleporterSystem_client")

-- Called when making the instance, triggered by: Events.OnSGlobalObjectSystemInit
function TpSystem:new()
   local o = SGlobalObjectSystem.new(self, "qbt_teleporter")
   qbt.TpSystem_server = o
   return o
end

-- TODO: share this in Utilities instead of copying to client
--       need to use special lua new() magic for 'multi inheritance' per ISA
function TpSystem:isValidIsoObject(isoObject)
   return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "baseteleporters_tileset_01_0"
end

function TpSystem:checkTeleporters()
   local self = TpSystem.instance
   local numTeleporters = self.system:getObjectCount()
   self:noise(string.format("checkTeleporters running on %d teleporters", numTeleporters))
   for i=0,numTeleporters - 1 do
        local tp = self.system:getObjectByIndex(i):getModData()
        local isotp = tp:getIsoObject()
        local x = isotp:getX()
        local y = isotp:getY()
        local z = isotp:getZ()
        self:noise(string.format("/telepoints: (%d) Teleporter %s at: %d, %d, %d",i,tp.id,x,y,z))
        qbt.Telepoints.Add(tp.id,x,y,z)
    end
end

--called in C/SGlobalObjectSystem:new(name)
TpSystem.savedObjectModData = { 'on', 'name', 'id' }
function TpSystem:initSystem()
   --set saved fields
   self.system:setObjectModDataKeys(self.savedObjectModData)
   Events.EveryHours.Add(TpSystem.checkTeleporters)
end

function TpSystem:newLuaObject(globalObject)
   return BaseTeleporter:new(self, globalObject)
end

---triggered by: Events.OnObjectAdded (SGlobalObjectSystem)
function TpSystem:OnObjectAdded(isoObject)
   local qbtType = qbt.getType(isoObject)
   if not qbtType then return end
   if qbtType == "BaseTeleporter" and self:isValidIsoObject(isoObject) then
      print ("TpSystem OnObjectAdded BaseTeleporter")
      self:loadIsoObject(isoObject)
      local modData = isoObject:getModData()
      isoObject:transmitModData()
   end
end

---triggered by: Events.OnObjectAboutToBeRemoved, Events.OnDestroyIsoThumpable  (SGlobalObjectSystem)
---v41.78 object data has already been copied to InventoryItem on pickup
function TpSystem:OnObjectAboutToBeRemoved(isoObject)
   local qbtType = qbt.getType(isoObject)
   if not qbtType then return end
   if qbtType == "BaseTeleporter" and self:isValidIsoObject(isoObject) then
      local luaObject = self:getLuaObjectOnSquare(isoObject:getSquare())
      if not luaObject then return end
      self:removeLuaObject(luaObject)
   end
end

function TpSystem:OnClientCommand(command, playerObj, args)
   local command = self.Commands[command]
   if command ~= nil then
      command(playerObj, args)
   end
end

SGlobalObjectSystem.RegisterSystemClass(TpSystem)

return TpSystem