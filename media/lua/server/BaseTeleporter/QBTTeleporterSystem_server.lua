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

function TpSystem:updateTeleporters()
   local self = TpSystem.instance
   if self then
      local numTeleporters = self.system:getObjectCount()
      self:noise(string.format("updateTeleporters running on %d teleporters", numTeleporters))
      -- TODO: implement 'registerTeleporters' and only send single command
      for i=0,numTeleporters - 1 do
         local teleporter = self.system:getObjectByIndex(i):getModData()
         self:noise(string.format("/updateTeleporters[%d]: Adding %s %s at: %d, %d, %d",
                                  i,teleporter.id,teleporter.name,teleporter.x,teleporter.y,teleporter.z))
         -- Send command to all players to register given teleporter
         self:sendCommand("registerTeleporter",
                          {id = teleporter.id, name = teleporter.name,
                           x = teleporter.x, y=teleporter.y, z=teleporter.z})
      end
   end
end

--called in C/SGlobalObjectSystem:new(name)
TpSystem.savedObjectModData = { 'on', 'name', 'id', 'x', 'y', 'x' }
function TpSystem:initSystem()
   --set saved fields
   self.system:setObjectModDataKeys(self.savedObjectModData)
   Events.EveryHours.Add(TpSystem.updateTeleporters)
end

function TpSystem:newLuaObject(globalObject)
   local teleporter = BaseTeleporter:new(self, globalObject)
   -- qbt.Telepoints.Add(modData.id, x, y, z)
   return teleporter
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
      -- TODO: not sure if below actually works?
      -- local x,y,z = isoObject:getX(), isoObject:getY(), isoObject:getZ()
      -- qbt.Telepoints.Add(modData.id, x, y, z)
   end
end

---triggered by: Events.OnObjectAboutToBeRemoved, Events.OnDestroyIsoThumpable  (SGlobalObjectSystem)
---v41.78 object data has already been copied to InventoryItem on pickup
function TpSystem:OnObjectAboutToBeRemoved(isoObject)
   local qbtType = qbt.getType(isoObject)
   if not qbtType then return end
   if qbtType == "BaseTeleporter" and self:isValidIsoObject(isoObject) then
      local modData = isoObject:getModData()
      if modData then
         qbt.Telepoints.Remove(modData.id)
      end
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