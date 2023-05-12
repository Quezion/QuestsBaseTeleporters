ISInventoryMenuElements = ISInventoryMenuElements or {};

function ISInventoryMenuElements.ContextTeleporter()
    local self = ISMenuElement.new();
    self.invMenu = ISContextManager.getInstance().getInventoryMenu();

    function self.init()
    end

    function self.createMenu( _item )
		if _item:getFullType() == "Base.BusTicket" then
			local teleMenu = self.invMenu.context:addOption( "Travel", self.invMenu, nil );
			local telePoints = SSDart.Transporter.GetAvailablePoints();
			local submenu = self.invMenu.context:getNew( self.invMenu.context );
			self.invMenu.context:addSubMenu( teleMenu, submenu );
			print("======================> Processing '" .. #telePoints .. "' traveling points" );
			for _, pointName in ipairs(telePoints) do
				submenu:addOption( "Travel to '" .. pointName .."'", self.invMenu, self.TeleportTo, pointName );
			end
			if SSDart.Transporter.CanReturn() then
				submenu:addOption( "Return", self.invMenu, self.Return );
			end
		end
    end

	function self.TeleportTo( items, player, pointName )
		SSDart.Transporter.MoveTo( items, player );
	end

	function self.Return( player )
		SSDart.Transporter.Return( player );
	end

    function self.openMovableCursor( _p, _item )	
		local tpx = 12697;
		local tpy = 2347;
		local tpz = 0;
		
		local player = _p.player;
		player:setX(tpx);
		player:setY(tpy);
		player:setZ(tpz);
		player:setLx(player:getX());
		player:setLy(player:getY());
		player:setLz(player:getZ());
    end

    return self;
end
