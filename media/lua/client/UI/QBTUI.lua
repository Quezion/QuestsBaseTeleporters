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

function UI.setNameCallback(player,square)
   print("UI.setNameCallback invoked")
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
      context:addOption("Set Name", player, UI.setNameCallback, square)
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