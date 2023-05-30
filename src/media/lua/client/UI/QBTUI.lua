local string, math, getText = string, math, getText

local qbt = require "QBTUtilities"
local TpSystem = require "QBTTeleporterSystem_client"

local UI = {}

local _teleporter -- dynamically set to right-clicked teleporter on contextmenu prefill

function UI.OnPreFillWorldObjectContextMenu(player, context, worldobjects, test)
   -- if generator then
   --    -- TODO: enable below finding logic? but need to port find type functions
   --    _teleporter = qbt.WorldUtil.findTypeOnSquare(generator:getSquare(),"BaseTeleporter")
   --    if _teleporter then generator = nil end
   -- end
end

function UI.teleportCallback(player,square,pointId)
   qbt.Telepoints.MoveTo(player,pointId)
end

function UI.setNameCallback(player,teleporter)
   local modal = ISTextBox:new(0, 0, 280, 180, "Set Teleporter Name", "", nil, UI.setNameClick, player, player, teleporter)
   modal:initialise()
   modal:addToUIManager()
end

function UI.setNameClick(_textbox, button, player, teleporter)
   local modData = teleporter:getModData()
   local pointId = modData["id"]
   if not pointId then return end -- guard against modData not yet being synchronized

   if button.internal == "OK" then
      local newName = button.parent.entry:getText()
      if newName and newName ~= "" then
         -- print("setNameClick callback with captured name = " .. button.parent.entry:getText())
         local square = teleporter:getSquare()
         if oldName then
            qbt.Telepoints.Remove(pointId)
         end
         print("/telepoints: Adding " .. tostring(newName) .. " with ID " .. pointId)
         local x = square:getX()
         local y = square:getY()
         local z = square:getZ()
         qbt.Telepoints.Add(pointId, newName, x, y, z);

         TpSystem.instance:sendCommand(getSpecificPlayer(player),
                                       "setName",
                                       { teleporter = { x=x,y=y,z=z },
                                         name = newName })
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
      end
   end
end

Events.OnPreFillWorldObjectContextMenu.Add(UI.OnPreFillWorldObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(UI.OnFillWorldObjectContextMenu)

qbt.UI = UI