SSDart = SSDart or {};

local function transporterInit()
	local transporter = {
		_regPoints = {},
		_returnPoint = {}
	}

	function transporter.AddPoint( id, x, y, z )
		if not id then
			error("There was no ID given", 2 );
		end
		if type(id) ~= "string" then
			error("The given ID is not a string", 2 );
		end
		transporter._regPoints[ id ] = {
			X = x,
			Y = y,
			Z = z or 0
		}
	end

	function transporter.MoveTo( player, id )
		print("=======================> Moving player '" .. tostring(player) .. "' to point '" .. id .. "'");
		player = player.player;
		print("=======================> Moving player '" .. tostring(player) .. "' to point '" .. id .. "'");
		local lastPos = {
			X = player:getX(),
			Y = player:getY(),
			Z = player:getZ()
		}
		local newPoint = transporter.GetPoint( id );
		
		player:setX( newPoint.X );
		player:setY( newPoint.Y );
		player:setZ( newPoint.Z );
		player:setLx( newPoint.X );
		player:setLy( newPoint.Y );
		player:setLz( newPoint.Z );
		transporter._returnPoint.Last = lastPos;
	end

	function transporter.GetAvailablePoints()
		local points = {};
		for pointName, _ in pairs(transporter._regPoints) do
			table.insert(points, pointName);
		end
		return points;
	end

	function transporter.GetPoint( id )
		for pointName, point in pairs(transporter._regPoints) do
			if pointName == id then
				return point;
			end
		end
		error("There is no point with ID of '" .. id .. "'", 2 );
	end

	function transporter.CanReturn()
		if not transporter._returnPoint.Last then
			return false;
		else
			return true;
		end
	end

	function transporter.Return( player )
		player = player.player;
		local returnPoint = transporter._returnPoint.Last;
		player:setX( returnPoint.X );
		player:setY( returnPoint.Y );
		player:setZ( returnPoint.Z );
		player:setLx( returnPoint.X );
		player:setLy( returnPoint.Y );
		player:setLz( returnPoint.Z );
		transporter._returnPoint.Last = nil;
	end

	return {
		AddPoint = transporter.AddPoint,
		MoveTo = transporter.MoveTo,
		GetAvailablePoints = transporter.GetAvailablePoints,
		CanReturn = transporter.CanReturn,
		Return = transporter.Return
	}
	
end

SSDart.Transporter = transporterInit();

SSDart.Transporter.AddPoint(
	"IGUI_Louisville",
	12697,
	2347
);

SSDart.Transporter.AddPoint(
	"IGUI_Rosewood",
	8093,
	11658
);

SSDart.Transporter.AddPoint(
	"IGUI_WestPoint",
	11927,
	6886
);

SSDart.Transporter.AddPoint(
	"IGUI_Muldraugh",
	10604,
	9934
);

SSDart.Transporter.AddPoint(
	"IGUI_Riverside",
	6538,
	5309
);

SSDart.Transporter.AddPoint(
	"IGUI_MarchRidge",
	10009,
	12706
);