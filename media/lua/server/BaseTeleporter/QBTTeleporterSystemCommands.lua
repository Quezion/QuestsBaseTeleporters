if isClient() then return end

local TpSystem = require "BaseTeleporter/QBTTeleporterSystem_server"

local Commands = {}

local function noise(message) return PbSystem.instance:noise(message) end

local function getTeleporter(args)
   return TpSystem.instance:getLuaObjectAt(args.x, args.y, args.z)
end

-- TODO: run this command from the Client and see if it works
--       copy however ISA is doing this
function Commands.setName(player,args)
   local tp = getTeleporter(args.teleporter)
   if tp then
      tp.name = args.name
      tp:saveData(true)
   end
end

TpSystem.Commands = Commands