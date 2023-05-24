require "Moveables/ISMoveableDefinitions"
Events.OnGameBoot.Add(function()
      local defs = ISMoveableDefinitions:getInstance()
      defs.addScrapDefinition("BaseTeleporter",  {"Base.Screwdriver"}, {}, Perks.Electricity,  2000, "Dismantle", true, 10)
      defs.addScrapItem("BaseTeleporter", "Radio.ElectricWire", 3, 80, true )
      defs.addScrapItem("BaseTeleporter", "Base.MetalBar", 4, 70, true )
      defs.addScrapItem("BaseTeleporter", "Base.SheetMetal", 5, 70, true )
end)
