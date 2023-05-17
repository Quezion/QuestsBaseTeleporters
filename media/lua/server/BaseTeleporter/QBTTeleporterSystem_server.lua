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

function TpSystem:isValidIsoObject(isoObject)
   return instanceof(isoObject, "IsoThumpable") and isoObject:getTextureName() == "baseteleporters_tileset_01_0"
end

function TpSystem:checkTeleporters()
   print "TpSystem.checkTeleporters called"
end

--called in C/SGlobalObjectSystem:new(name)
TpSystem.savedObjectModData = { 'on' }
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
      -- Commented out below, it's some separate process spaghetti
      -- that allows for special logic on item add/remove
      -- might need to enable this at some point, but delaying that evil
      -- self.processRemoveObj:addItem(isoObject)
   end
end

function TpSystem:OnClientCommand(command, playerObj, args)
   local command = self.Commands[command]
   if command ~= nil then
      command(playerObj, args)
   end
end

-- TODO: possible to use a custom .processRemoveObj function here
--       to maintain a table of all Teleporters

SGlobalObjectSystem.RegisterSystemClass(TpSystem)

return TpSystem