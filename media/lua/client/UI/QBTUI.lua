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
   local oldName = teleporter:getName()
   if oldName == nil then oldName = "" end
   print("UI.setNameCallback invoked")
   local modal = ISTextBox:new(0, 0, 280, 180, "Set Teleporter Name", oldName, nil, UI.setNameClick, player, teleporter)
   modal:initialise()
   modal:addToUIManager()
end

function UI.setNameClick(_textbox, button, teleporter)
   print("UI.setNameClick called")
   if button.internal == "OK" then
      if button.parent.entry:getText() and button.parent.entry:getText() ~= "" then
         --print("setNameClick callback with captured name = " .. button.parent.entry:getText())
         local oldName = teleporter:getName()
         local newName = button.parent.entry:getText()
         local square = teleporter:getSquare()
         if oldName then
            qbt.Telepoints.Remove(oldName)
         end
         teleporter:setName(newName)
         qbt.Telepoints.Add(newName, square:getX(), square:getY(), square:getZ())
      end
   end
end


function UI.OnFillWorldObjectContextMenu(player, context, worldobjects, test)
   print "UI.OnFillWorldObjectContextMenu invoked"
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

      -- TODO: something about below block is failing, figure out what
      if test then return ISWorldObjectContextMenu.setTest() end
      -- Create static option to Set Name on the teleporter under cursor
      context:addOption("Set Name", player, UI.setNameCallback, teleporter)
      -- Add Teleport To SubMenu and populate with teleportable points
      local QBTTelepointsSubMenu = context:getNew(context)
      context:addSubMenu(context:addOption("Teleport to"), QBTTelepointsSubMenu)
      local availablePoints = Telepoints.GetAvailablePoints()
      for _, pointName in pairs(availablePoints) do
         QBTTelepointsSubMenu:addOption(pointName, player, UI.teleportCallback, square, pointName)
         --print("pointName " .. tostring(pointName))
      end
      -- local name = teleporter:getModData()["name"]
   end
end

Events.OnPreFillWorldObjectContextMenu.Add(UI.OnPreFillWorldObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(UI.OnFillWorldObjectContextMenu)

qbt.UI = UI