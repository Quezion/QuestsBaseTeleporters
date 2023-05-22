local string, math, getText = string, math, getText

local qbt = require "QBTUtilities"

local UI = {}

local _teleporter -- dynamically set to right-clicked teleporter on contextmenu prefill

function UI.OnPreFillWorldObjectContextMenu(player, context, worldobjects, test)
   if generator then
      -- TODO: enable below finding logic, but need to port find type functions
      --_powerbank = qbt.WorldUtil.findTypeOnSquare(generator:getSquare(),"BaseTeleporter")
      if _teleporter then generator = nil end
   end
end

function UI.teleportCallback(player,square,pointId)
   print("UI.teleportCallback invoked with pointId = " .. pointId)
   -- print "UI.teleporterCallback invoked"
   qbt.Telepoints.MoveTo(player,pointId)
end

function UI.setNameCallback(player,teleporter)
   print("UI.setNameCallback invoked")
   local modal = ISTextBox:new(0, 0, 280, 180, "Set Teleporter Name", "", nil, UI.setNameClick, player, teleporter)
   modal:initialise()
   modal:addToUIManager()
end

function UI.setNameClick(_textbox, button, teleporter)
   local modData = teleporter:getModData()
   local pointId = modData["id"]
   if not pointId then return end -- guard against modData not yet being synchronized

   -- print("UI.setNameClick called")
   if button.internal == "OK" then
      local newName = button.parent.entry:getText()
      if newName and newName ~= "" then
         -- print("setNameClick callback with captured name = " .. button.parent.entry:getText())
         local square = teleporter:getSquare()
         if oldName then
            qbt.Telepoints.Remove(pointId)
         end
         modData["name"] = newName
         teleporter:transmitModData()
         print("/telepoints: Adding " .. tostring(newName) .. " with ID " .. pointId)
         -- self:noise(string.format("/telepoints: Adding %s %s at: %d, %d, %d",
         --                          pointId,newName,x,y,z))
         qbt.Telepoints.Add(pointId, newName, square:getX(), square:getY(), square:getZ())

         -- PbSystem.instance:sendCommand(self.character,"setName", { pb = { x = pb.x, y = pb.y, z = pb.z }, name = newName })
      end
   end
end


function UI.OnFillWorldObjectContextMenu(player, context, worldobjects, test)
   if test and ISWorldObjectContextMenu.Test then return true end
   local teleporter = _teleporter

   for _,obj in ipairs(worldobjects) do
      local sprite = obj:getTextureName()
      local type = qbt.Types[sprite]
      if type == "BaseTeleporter" then
         teleporter = obj
      end
   end

   if teleporter then
      _teleporter = nil
      local square = teleporter:getSquare()

      if test then return ISWorldObjectContextMenu.setTest() end
      -- Create static option to Set Name on the teleporter under cursor
      context:addOption("Set Name", player, UI.setNameCallback, teleporter)
      -- Add Teleport To SubMenu and populate with teleportable points
      local QBTTelepointsSubMenu = context:getNew(context)
      context:addSubMenu(context:addOption("Teleport to"), QBTTelepointsSubMenu)
      local availablePoints = qbt.Telepoints.GetAvailablePoints()
      for _, point in pairs(availablePoints) do
         QBTTelepointsSubMenu:addOption(point.Name, player, UI.teleportCallback, square, point.Id)
         --print("pointName " .. tostring(pointName))
      end
      -- local name = teleporter:getModData()["name"]
   end
end

Events.OnPreFillWorldObjectContextMenu.Add(UI.OnPreFillWorldObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(UI.OnFillWorldObjectContextMenu)

qbt.UI = UI