/*********************************************************************************************************************************************
						- NYOGames [publicfunctions.pwn file]
*********************************************************************************************************************************************/
function:OnLoadATMS(fromstart)
{
	if(fromstart == 1)
	{
	    ATMLoop(i)
	    {
			ATMInfo[i][atmActive] = false;
	    }
	}
	new fields, rows;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
	    for(new row; row < rows; row++)
	    {
	    	new iGet[128];
	    	cache_get_field_content(row, "ID", iGet, MySQLPipeline); new atmid = strval(iGet);
	    	cache_get_field_content(row, "X", iGet, MySQLPipeline); ATMInfo[atmid][atmX] = floatstr(iGet);
	    	cache_get_field_content(row, "Y", iGet, MySQLPipeline); ATMInfo[atmid][atmY] = floatstr(iGet);
	    	cache_get_field_content(row, "Z", iGet, MySQLPipeline); ATMInfo[atmid][atmZ] = floatstr(iGet);
	    	cache_get_field_content(row, "rotX", iGet, MySQLPipeline); ATMInfo[atmid][atmrotX] = floatstr(iGet);
	    	cache_get_field_content(row, "rotY", iGet, MySQLPipeline); ATMInfo[atmid][atmrotY] = floatstr(iGet);
	    	cache_get_field_content(row, "rotZ", iGet, MySQLPipeline); ATMInfo[atmid][atmrotZ] = floatstr(iGet);
	    	cache_get_field_content(row, "Interior", iGet, MySQLPipeline); ATMInfo[atmid][atmInterior] = strval(iGet);
	    	cache_get_field_content(row, "VirtualWorld", iGet, MySQLPipeline); ATMInfo[atmid][atmVirtualWorld] = strval(iGet);
	        ATMInfo[atmid][atmActive] = true;
			DestroyDynamicObject(ATMInfo[atmid][atmObject]);
    		DestroyDynamic3DTextLabel(ATMInfo[atmid][atmLabel]);
	        ATMInfo[atmid][atmObject] = CreateDynamicObject(2942, ATMInfo[atmid][atmX], ATMInfo[atmid][atmY], ATMInfo[atmid][atmZ], ATMInfo[atmid][atmrotX], ATMInfo[atmid][atmrotY], ATMInfo[atmid][atmrotZ], ATMInfo[atmid][atmVirtualWorld], ATMInfo[atmid][atmInterior]);
	        ATMInfo[atmid][atmLabel] = CreateDynamic3DTextLabel("{ffffff}[ {c5cc02}ATM Machine {ffffff}]\n{c5cc02}Commands: {ffffff}/deposit /withdraw /balance", COLOR_WHITE, ATMInfo[atmid][atmX], ATMInfo[atmid][atmY], ATMInfo[atmid][atmZ]+0.2, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATMInfo[atmid][atmVirtualWorld], ATMInfo[atmid][atmInterior]);
	    }
	}
}

function:OnLoadGates(fromstart)
{
	if(fromstart == 1)
	{
		LOOP:g(0, MAX_GATES)
		{
			GateInfo[g][gateActive] = false;
		}
	}
	new fields, rows;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		LOOP:row(0, rows)
		{
			new iGet[128];
			cache_get_field_content(row, "ID", iGet, MySQLPipeline); new gateid = strval(iGet);
			cache_get_field_content(row, "Model", iGet, MySQLPipeline); GateInfo[gateid][gateModel] = strval(iGet);
			cache_get_field_content(row, "Name", iGet, MySQLPipeline); myStrcpy(GateInfo[gateid][gateName], iGet);
			cache_get_field_content(row, "X", iGet, MySQLPipeline); GateInfo[gateid][gateX] = floatstr(iGet);
			cache_get_field_content(row, "Y", iGet, MySQLPipeline); GateInfo[gateid][gateY] = floatstr(iGet);
			cache_get_field_content(row, "Z", iGet, MySQLPipeline); GateInfo[gateid][gateZ] = floatstr(iGet);
			cache_get_field_content(row, "rX", iGet, MySQLPipeline); GateInfo[gateid][gateRX] = floatstr(iGet);
			cache_get_field_content(row, "rY", iGet, MySQLPipeline); GateInfo[gateid][gateRY] = floatstr(iGet);
			cache_get_field_content(row, "rZ", iGet, MySQLPipeline); GateInfo[gateid][gateRZ] = floatstr(iGet);
			cache_get_field_content(row, "mX", iGet, MySQLPipeline); GateInfo[gateid][gateMX] = floatstr(iGet);
			cache_get_field_content(row, "mY", iGet, MySQLPipeline); GateInfo[gateid][gateMY] = floatstr(iGet);
			cache_get_field_content(row, "mZ", iGet, MySQLPipeline); GateInfo[gateid][gateMZ] = floatstr(iGet);
			cache_get_field_content(row, "mrX", iGet, MySQLPipeline); GateInfo[gateid][gateMRX] = floatstr(iGet);
			cache_get_field_content(row, "mrY", iGet, MySQLPipeline); GateInfo[gateid][gateMRY] = floatstr(iGet);
			cache_get_field_content(row, "mrZ", iGet, MySQLPipeline); GateInfo[gateid][gateMRZ] = floatstr(iGet);
			cache_get_field_content(row, "Interior", iGet, MySQLPipeline); GateInfo[gateid][gateInterior] = strval(iGet);
			cache_get_field_content(row, "VirtualWorld", iGet, MySQLPipeline); GateInfo[gateid][gateVirtualWorld] = strval(iGet);
			cache_get_field_content(row, "House", iGet, MySQLPipeline); GateInfo[gateid][gateHouse] = strval(iGet);
			cache_get_field_content(row, "Business", iGet, MySQLPipeline); GateInfo[gateid][gateBusiness] = strval(iGet);
			cache_get_field_content(row, "Faction", iGet, MySQLPipeline); GateInfo[gateid][gateFaction] = strval(iGet);
			cache_get_field_content(row, "Owner", iGet, MySQLPipeline); myStrcpy(GateInfo[gateid][gateOwner], iGet);
			GateInfo[gateid][gateActive] = true;
			DestroyDynamicObject(GateInfo[gateid][gateObject]);
			GateInfo[gateid][gateObject] = CreateDynamicObject(GateInfo[gateid][gateModel], GateInfo[gateid][gateX], GateInfo[gateid][gateY], GateInfo[gateid][gateZ], GateInfo[gateid][gateRX], GateInfo[gateid][gateRY], GateInfo[gateid][gateRZ], GateInfo[gateid][gateVirtualWorld], GateInfo[gateid][gateInterior]);
		}
	}
}

function:OnReloadATM(atmid)
{
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `ATMInfo` WHERE `ID` = %d LIMIT 1", atmid);
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadATMS", "d", 0);
	return 1;
}

function:OnReloadGate(gateid)
{
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `GateInfo` WHERE `ID` = %d LIMIT 1", gateid);
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadGates", "d", 0);
	return 1;
}

function:OnReloadBusiness(businessid)
{
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `BusinessInfo` WHERE `ID` = %d LIMIT 1", businessid);
    mysql_tquery(MySQLPipeline, iQuery, "OnLoadBusinesses", "d", 0);
	return 1;
}

function:OnReloadFaction(factionid)
{
	new iQuery[248];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `FactionInfo` WHERE `ID` = %d", factionid);
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadFactions", "d", 0);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `HQInfo` WHERE `ID` = %d", factionid);
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadHQs", "d", 0);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `WHInfo` WHERE `ID` = %d", factionid);
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadWHs", "d", 0);
	return 1;
}

function:OnReloadHouse(houseid)
{
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `HouseInfo` WHERE `ID` = %d LIMIT 1", houseid);
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadHouses", "d", 0);
	return 1;
}

function:OnReloadFurniture(houseid, slotid)
{
	new iQuery[128];
	if(slotid == -1)
	{
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `FurnitureInfo` WHERE `House` = %d", houseid);
		mysql_tquery(MySQLPipeline, iQuery, "OnLoadFurniture", "d", 0);
	}
	else
	{
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `FurnitureInfo` WHERE `House` = %d AND `Slot` = %d LIMIT 1", houseid, slotid);
		mysql_tquery(MySQLPipeline, iQuery, "OnLoadFurniture", "d", 0);
	}
	return 1;
}

function:OnReloadVehicle(vehicleid)
{
	new iQuery[168];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `VehicleInfo` WHERE `ID` = %d LIMIT 1", vehicleid);
    mysql_tquery(MySQLPipeline, iQuery, "OnLoadVehicles", "d", 0);
	return 1;
}

function:OnReloadTeleport(teleportid)
{
	new iQuery[168];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `TeleportInfo` WHERE `ID` = %d LIMIT 1", teleportid);
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadTeleports", "d", 0);
	return 1;
}

function:OnLoadHouses(fromstart)
{
	if(fromstart == 1)
	{
		HouseLoop(h)
		{
			HouseInfo[h][hActive] = false;
		}
	}
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
	    for(new c = 0; c < rows; c++)
	    {
	        new iGet[128];
			cache_get_field_content(c, "ID", iGet, MySQLPipeline); new houseid = strval(iGet);
	        cache_get_field_content(c, "Owner", iGet, MySQLPipeline); myStrcpy(HouseInfo[houseid][hOwner], iGet);
	        cache_get_field_content(c, "Weapons", iGet, MySQLPipeline);
			sscanf(iGet, "p<,>iiiiiiiiiiiii", 	HouseInfo[houseid][hWeapon][0],
												HouseInfo[houseid][hWeapon][1],
												HouseInfo[houseid][hWeapon][2],
												HouseInfo[houseid][hWeapon][3],
												HouseInfo[houseid][hWeapon][4],
												HouseInfo[houseid][hWeapon][5],
												HouseInfo[houseid][hWeapon][6],
												HouseInfo[houseid][hWeapon][7],
												HouseInfo[houseid][hWeapon][8],
												HouseInfo[houseid][hWeapon][9],
												HouseInfo[houseid][hWeapon][10],
												HouseInfo[houseid][hWeapon][11],
												HouseInfo[houseid][hWeapon][12]);
												
	        cache_get_field_content(c, "Ammo", iGet, MySQLPipeline);
			sscanf(iGet, "p<,>iiiiiiiiiiiii", 	HouseInfo[houseid][hAmmo][0],
												HouseInfo[houseid][hAmmo][1],
												HouseInfo[houseid][hAmmo][2],
												HouseInfo[houseid][hAmmo][3],
												HouseInfo[houseid][hAmmo][4],
												HouseInfo[houseid][hAmmo][5],
												HouseInfo[houseid][hAmmo][6],
												HouseInfo[houseid][hAmmo][7],
												HouseInfo[houseid][hAmmo][8],
												HouseInfo[houseid][hAmmo][9],
												HouseInfo[houseid][hAmmo][10],
												HouseInfo[houseid][hAmmo][11],
												HouseInfo[houseid][hAmmo][12]);
												
			cache_get_field_content(c, "Buyable", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hBuyable] = true; else HouseInfo[houseid][hBuyable] = false;
			cache_get_field_content(c, "Rentable", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hRentable] = true; else HouseInfo[houseid][hRentable] = false;
			cache_get_field_content(c, "Closed", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hClosed] = true; else HouseInfo[houseid][hClosed] = false;
			cache_get_field_content(c, "HouseLocker", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hLocker] = true; else HouseInfo[houseid][hLocker] = false;
			
			cache_get_field_content(c, "Sellprice", iGet, MySQLPipeline); HouseInfo[houseid][hSellprice] = strval(iGet);
			cache_get_field_content(c, "Rentprice", iGet, MySQLPipeline); HouseInfo[houseid][hRentprice] = strval(iGet);
			cache_get_field_content(c, "Level", iGet, MySQLPipeline); HouseInfo[houseid][hLevel] = strval(iGet);
			cache_get_field_content(c, "Cash", iGet, MySQLPipeline); HouseInfo[houseid][hCash] = strval(iGet);
			cache_get_field_content(c, "Till", iGet, MySQLPipeline); HouseInfo[houseid][hTill] = strval(iGet);
			cache_get_field_content(c, "SGuns", iGet, MySQLPipeline); HouseInfo[houseid][hSGuns] = strval(iGet);
			cache_get_field_content(c, "SDrugs", iGet, MySQLPipeline); HouseInfo[houseid][hSDrugs] = strval(iGet);
			cache_get_field_content(c, "InteriorPack", iGet, MySQLPipeline); HouseInfo[houseid][hInteriorPack] = strval(iGet);
			cache_get_field_content(c, "Alarm", iGet, MySQLPipeline); HouseInfo[houseid][hAlarm] = strval(iGet);
			cache_get_field_content(c, "Wardrobe", iGet, MySQLPipeline); HouseInfo[houseid][hWardrobe] = strval(iGet);
			cache_get_field_content(c, "Armour", iGet, MySQLPipeline); HouseInfo[houseid][hArmour] = strval(iGet);
			cache_get_field_content(c, "X", iGet, MySQLPipeline); HouseInfo[houseid][hX] = floatstr(iGet);
			cache_get_field_content(c, "Y", iGet, MySQLPipeline); HouseInfo[houseid][hY] = floatstr(iGet);
			cache_get_field_content(c, "Z", iGet, MySQLPipeline); HouseInfo[houseid][hZ] = floatstr(iGet);
			cache_get_field_content(c, "Interior", iGet, MySQLPipeline); HouseInfo[houseid][hInterior] = strval(iGet);
			cache_get_field_content(c, "VirtualWorld", iGet, MySQLPipeline); HouseInfo[houseid][hVirtualWorld] = strval(iGet);
			for(new hiss = 0; hiss < 5; hiss++)
			{
				new iStrrrr[30];
				format(iStrrrr, sizeof(iStrrrr), "Skin-Slot-%d", hiss);
				cache_get_field_content(c, iStrrrr, iGet, MySQLPipeline); HouseInfo[houseid][hSkins][hiss] = strval(iGet);
			}
			cache_get_field_content(c, "GarageX", iGet, MySQLPipeline); HouseInfo[houseid][hGarageX] = floatstr(iGet);
			cache_get_field_content(c, "GarageY", iGet, MySQLPipeline); HouseInfo[houseid][hGarageY] = floatstr(iGet);
			cache_get_field_content(c, "GarageZ", iGet, MySQLPipeline); HouseInfo[houseid][hGarageZ] = floatstr(iGet);
			cache_get_field_content(c, "GarageA", iGet, MySQLPipeline); HouseInfo[houseid][hGarageA] = floatstr(iGet);
			cache_get_field_content(c, "GarageInterior", iGet, MySQLPipeline); HouseInfo[houseid][hGarageInt] = strval(iGet);
			cache_get_field_content(c, "GarageVirtualWorld", iGet, MySQLPipeline); HouseInfo[houseid][hGarageVW] = strval(iGet);
			cache_get_field_content(c, "GInteriorPack", iGet, MySQLPipeline); HouseInfo[houseid][hGarageInteriorPack] = strval(iGet);
			cache_get_field_content(c, "GarageOpen", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hGarageOpen] = true; else HouseInfo[houseid][hGarageOpen] = false;
	        HouseInfo[houseid][hActive] = true;
			if(!dini_Exists(HouseTextureDirectory(houseid)))
				dini_Create(HouseTextureDirectory(houseid));
	        UpdateHouse(houseid);
		}
	}
	HouseLoop(h)
	{
		if(HouseInfo[h][hActive] != true && dini_Exists(HouseTextureDirectory(h))) // isn't created, so let's remove the house base textures
			dini_Remove(HouseTextureDirectory(h));
	}
}

function:OnLoadFurniture(FromStart)
{
	if(FromStart == 1)
	{
		HouseLoop(h)
		{
			FurnitureLoop(f)
			{
				FurnitureInfo[h][f][furActive] = false;
			}
		}
	}
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new row = 0; row < rows; row++)
		{
			new iGet[50], houseid, slotid;
			cache_get_field_content(row, "House", iGet, MySQLPipeline); houseid = strval(iGet);
			cache_get_field_content(row, "Slot", iGet, MySQLPipeline); slotid = strval(iGet);
			cache_get_field_content(row, "Name", iGet, MySQLPipeline); myStrcpy(FurnitureInfo[houseid][slotid][furName], iGet);
			cache_get_field_content(row, "Model", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furModel] = strval(iGet);
			cache_get_field_content(row, "X", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furX] = floatstr(iGet);
			cache_get_field_content(row, "Y", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furY] = floatstr(iGet);
			cache_get_field_content(row, "Z", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furZ] = floatstr(iGet);
			cache_get_field_content(row, "rX", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrX] = floatstr(iGet);
			cache_get_field_content(row, "rY", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrY] = floatstr(iGet);
			cache_get_field_content(row, "rZ", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrZ] = floatstr(iGet);
			cache_get_field_content(row, "rZ", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrZ] = floatstr(iGet);
			cache_get_field_content(row, "MaterialSlot1", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][0] = strval(iGet);
			cache_get_field_content(row, "MaterialSlot2", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][1] = strval(iGet);
			cache_get_field_content(row, "MaterialSlot3", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][2] = strval(iGet);
			cache_get_field_content(row, "MaterialSlot4", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][3] = strval(iGet);
			cache_get_field_content(row, "MaterialSlot5", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][4] = strval(iGet);
			cache_get_field_content(row, "ColourMaterial1", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][0] = strval(iGet);
			cache_get_field_content(row, "ColourMaterial2", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][1] = strval(iGet);
			cache_get_field_content(row, "ColourMaterial3", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][2] = strval(iGet);
			cache_get_field_content(row, "ColourMaterial4", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][3] = strval(iGet);
			cache_get_field_content(row, "ColourMaterial5", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][4] = strval(iGet);
			FurnitureInfo[houseid][slotid][furActive] = true;
			FurnitureInfo[houseid][slotid][furStatus] = false;
			DestroyDynamicObject(FurnitureInfo[houseid][slotid][furObject]);
			FurnitureInfo[houseid][slotid][furObject] = CreateDynamicObject(FurnitureInfo[houseid][slotid][furModel], FurnitureInfo[houseid][slotid][furX], FurnitureInfo[houseid][slotid][furY], FurnitureInfo[houseid][slotid][furZ], FurnitureInfo[houseid][slotid][furrX], FurnitureInfo[houseid][slotid][furrY], FurnitureInfo[houseid][slotid][furrZ], houseid+1, houseid+1);
			for(new c = 0; c < 5; c++)
			{
				new materialID = FurnitureInfo[houseid][slotid][furMaterial][c];
				new iColourID = FurnitureInfo[houseid][slotid][furMaterialColour][c];
				if(materialID == -1) continue;
				if(iColourID != -1)
					SetDynamicObjectMaterial(FurnitureInfo[houseid][slotid][furObject], c, FurnitureMaterial[materialID][modelID], FurnitureMaterial[materialID][txdName], FurnitureMaterial[materialID][textureName], RGBAToARGB(FurnitureMaterial[iColourID][materialColour]));
				else
					SetDynamicObjectMaterial(FurnitureInfo[houseid][slotid][furObject], c, FurnitureMaterial[materialID][modelID], FurnitureMaterial[materialID][txdName], FurnitureMaterial[materialID][textureName], RGBAToARGB(FurnitureMaterial[materialID][materialColour]));
			}
		}
	}
}

function:OnLoadBusinesses(FromStart)
{
	if(FromStart == 1)
	{
		BusinessLoop(b) BusinessInfo[b][bActive] = false;
	}
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new c = 0; c < rows; c++)
		{
			new iGet[150];
			cache_get_field_content(c, "ID", iGet, MySQLPipeline); new bizID = strval(iGet);
			cache_get_field_content(c, "Type", iGet, MySQLPipeline); BusinessInfo[bizID][bType] = strval(iGet);
			cache_get_field_content(c, "X", iGet, MySQLPipeline); BusinessInfo[bizID][bX] = floatstr(iGet);
			cache_get_field_content(c, "Y", iGet, MySQLPipeline); BusinessInfo[bizID][bY] = floatstr(iGet);
			cache_get_field_content(c, "Z", iGet, MySQLPipeline); BusinessInfo[bizID][bZ] = floatstr(iGet);
			cache_get_field_content(c, "VirtualWorld", iGet, MySQLPipeline); BusinessInfo[bizID][bVirtualWorld] = strval(iGet);
			cache_get_field_content(c, "Interior", iGet, MySQLPipeline); BusinessInfo[bizID][bInterior] = strval(iGet);
			cache_get_field_content(c, "InteriorPack", iGet, MySQLPipeline); BusinessInfo[bizID][bInteriorPack] = strval(iGet);
			cache_get_field_content(c, "CompsFlag", iGet, MySQLPipeline); BusinessInfo[bizID][bCompsFlag] = strval(iGet);
			cache_get_field_content(c, "Tax", iGet, MySQLPipeline); BusinessInfo[bizID][bTax] = strval(iGet);
			cache_get_field_content(c, "LastRob", iGet, MySQLPipeline); BusinessInfo[bizID][bLastRob] = strval(iGet);
			cache_get_field_content(c, "Level", iGet, MySQLPipeline); BusinessInfo[bizID][bLevel] = strval(iGet);
			cache_get_field_content(c, "Sellprice", iGet, MySQLPipeline); BusinessInfo[bizID][bSellprice] = strval(iGet);
			cache_get_field_content(c, "Restock", iGet, MySQLPipeline); BusinessInfo[bizID][bRestock] = strval(iGet);
			cache_get_field_content(c, "RentPrice", iGet, MySQLPipeline); BusinessInfo[bizID][bRentPrice] = strval(iGet);
			cache_get_field_content(c, "Till", iGet, MySQLPipeline); BusinessInfo[bizID][bTill] = strval(iGet);
			cache_get_field_content(c, "Locked", iGet, MySQLPipeline); if(strval(iGet) == 1) BusinessInfo[bizID][bLocked] = true; else BusinessInfo[bizID][bLocked] = false;
			cache_get_field_content(c, "Comps", iGet, MySQLPipeline); BusinessInfo[bizID][bComps] = strval(iGet);
			cache_get_field_content(c, "Fee", iGet, MySQLPipeline); BusinessInfo[bizID][bFee] = strval(iGet);
			cache_get_field_content(c, "Deagle", iGet, MySQLPipeline); BusinessInfo[bizID][bDeagle] = strval(iGet);
			cache_get_field_content(c, "MP5", iGet, MySQLPipeline); BusinessInfo[bizID][bMP5] = strval(iGet);
			cache_get_field_content(c, "M4", iGet, MySQLPipeline); BusinessInfo[bizID][bM4] = strval(iGet);
			cache_get_field_content(c, "Shotgun", iGet, MySQLPipeline); BusinessInfo[bizID][bShotgun] = strval(iGet);
			cache_get_field_content(c, "Rifle", iGet, MySQLPipeline); BusinessInfo[bizID][bRifle] = strval(iGet);
			cache_get_field_content(c, "Sniper", iGet, MySQLPipeline); BusinessInfo[bizID][bSniper] = strval(iGet);
			cache_get_field_content(c, "Armour", iGet, MySQLPipeline); BusinessInfo[bizID][bArmour] = strval(iGet);
			cache_get_field_content(c, "AskComps", iGet, MySQLPipeline); BusinessInfo[bizID][bAskComps] = strval(iGet);
			cache_get_field_content(c, "Buyable", iGet, MySQLPipeline); BusinessInfo[bizID][bBuyable] = strval(iGet);
		    cache_get_field_content(c, "Owner", iGet, MySQLPipeline); myStrcpy(BusinessInfo[bizID][bOwner], iGet);
		    cache_get_field_content(c, "Dupekey", iGet, MySQLPipeline); myStrcpy(BusinessInfo[bizID][bDupekey], iGet);
		    cache_get_field_content(c, "Name", iGet, MySQLPipeline); myStrcpy(BusinessInfo[bizID][bName], iGet);
		    BusinessInfo[bizID][bActive] = true;
			UpdateBiz(bizID, 0);
		}
	}
	return 1;
}

function:OnLoadFactions(fromstart)
{
	if(fromstart == 1)
	{
		FactionLoop(f) FactionInfo[f][fActive] = false;
	}
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new c = 0; c < rows; c++)
		{
			new iGet[128];
			cache_get_field_content(c, "ID", iGet, MySQLPipeline); new fid = strval(iGet);
			cache_get_field_content(c, "FactionName", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fName], iGet);
			cache_get_field_content(c, "Colour", iGet, MySQLPipeline); FactionInfo[fid][fColour] = strval(iGet);
			cache_get_field_content(c, "GangZoneColour", iGet, MySQLPipeline); FactionInfo[fid][fGangZoneColour] = strval(iGet);
			cache_get_field_content(c, "Startrank", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fStartrank], iGet);
			cache_get_field_content(c, "Leader", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fLeader], iGet);
			cache_get_field_content(c, "MOTD", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fMOTD], iGet);
			cache_get_field_content(c, "Points", iGet, MySQLPipeline); FactionInfo[fid][fPoints] = strval(iGet);
			cache_get_field_content(c, "TogChat", iGet, MySQLPipeline); if(strval(iGet) == 1) FactionInfo[fid][fTogChat] = true; else FactionInfo[fid][fTogChat] = false;
			cache_get_field_content(c, "TogColour", iGet, MySQLPipeline); if(strval(iGet) == 1) FactionInfo[fid][fTogColour] = true; else FactionInfo[fid][fTogColour] = false;
			cache_get_field_content(c, "MaxVehicles", iGet, MySQLPipeline); FactionInfo[fid][fMaxVehicles] = strval(iGet);
			cache_get_field_content(c, "MaxMembers", iGet, MySQLPipeline); FactionInfo[fid][fMaxMemberSlots] = strval(iGet);
			cache_get_field_content(c, "Startpayment", iGet, MySQLPipeline); FactionInfo[fid][fStartpayment] = strval(iGet);
			cache_get_field_content(c, "Bank", iGet, MySQLPipeline); FactionInfo[fid][fBank] = strval(iGet);
			cache_get_field_content(c, "Type", iGet, MySQLPipeline); FactionInfo[fid][fType] = strval(iGet);
			cache_get_field_content(c, "StockLevel", iGet, MySQLPipeline); FactionInfo[fid][fStockLevel] = strval(iGet);
			cache_get_field_content(c, "Freq", iGet, MySQLPipeline); FactionInfo[fid][fFreq] = strval(iGet);
			cache_get_field_content(c, "SDCWarehouse", iGet, MySQLPipeline); FactionInfo[fid][fSDCWarehouse] = strval(iGet);
			cache_get_field_content(c, "SDCCompsprice", iGet, MySQLPipeline); FactionInfo[fid][fSDCCompsPrice] = strval(iGet);
			FactionInfo[fid][fActive] = true;
			PlayerLoop(p)
			{
				if(PlayerTemp[p][loggedIn] != true) continue;
				if(PlayerInfo[p][playerteam] == fid) SetPlayerTeamEx(p, fid); // just to reset colour!
			}
		}
	}
	return 1;
}

function:OnLoadWHs(fromstart)
{
	if(fromstart == 1) FactionLoop(f) WareHouseInfo[f][whActive] = false;
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new row = 0; row < rows; row++)
		{
			new factionID = cache_get_field_content_int(row, "ID");
			new iGet[75];
			cache_get_field_content(row, "X", iGet, MySQLPipeline); WareHouseInfo[factionID][whX] = floatstr(iGet);
			cache_get_field_content(row, "Y", iGet, MySQLPipeline); WareHouseInfo[factionID][whY] = floatstr(iGet);
			cache_get_field_content(row, "Z", iGet, MySQLPipeline); WareHouseInfo[factionID][whZ] = floatstr(iGet);
			cache_get_field_content(row, "Interior", iGet, MySQLPipeline); WareHouseInfo[factionID][whInterior] = strval(iGet);
			cache_get_field_content(row, "VirtualWorld", iGet, MySQLPipeline); WareHouseInfo[factionID][whVirtualWorld] = strval(iGet);
			cache_get_field_content(row, "Open", iGet, MySQLPipeline); if(strval(iGet) == 0) WareHouseInfo[factionID][whOpen] = false; else WareHouseInfo[factionID][whOpen] = true;
			cache_get_field_content(row, "Level", iGet, MySQLPipeline); WareHouseInfo[factionID][whLevel] = strval(iGet);
			cache_get_field_content(row, "Materials", iGet, MySQLPipeline); WareHouseInfo[factionID][whMaterials] = strval(iGet);
			cache_get_field_content(row, "Lead", iGet, MySQLPipeline); WareHouseInfo[factionID][whLead] = strval(iGet);
			cache_get_field_content(row, "Metal", iGet, MySQLPipeline); WareHouseInfo[factionID][whMetal] = strval(iGet);
			cache_get_field_content(row, "Security", iGet, MySQLPipeline); WareHouseInfo[factionID][whSecurity] = strval(iGet);
			WareHouseInfo[factionID][whActive] = true;
			DestroyDynamic3DTextLabel(WareHouseInfo[factionID][whLabel]);
			KillTimer(WareHouseInfo[factionID][whTimer]);
			new iMessage[256], iFormat[128];
			format(iFormat, sizeof(iFormat), "{63b2f7}*** %s Warehouse ***\n", FactionInfo[factionID][fName]); strcat(iMessage, iFormat);
			format(iFormat, sizeof(iFormat), "{add7f7}Level: %d | Security: %d\n", WareHouseInfo[factionID][whLevel], WareHouseInfo[factionID][whSecurity]); strcat(iMessage, iFormat);
			format(iFormat, sizeof(iFormat), "{add7f7}Lead: %s | Metal: %s\n", number_format(WareHouseInfo[factionID][whLead]), number_format(WareHouseInfo[factionID][whMetal])); strcat(iMessage, iFormat);
			format(iFormat, sizeof(iFormat), "{add7f7}Materials: %s\n", number_format(WareHouseInfo[factionID][whMaterials])); strcat(iMessage, iFormat);
			format(iFormat, sizeof(iFormat), "{add7f7}Items: 15 | Alcohol: 15"); strcat(iMessage, iFormat);

			WareHouseInfo[factionID][whLabel] = CreateDynamic3DTextLabel(iMessage, 0x63b2f7FF, WareHouseInfo[factionID][whX], WareHouseInfo[factionID][whY], WareHouseInfo[factionID][whZ]+0.25, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, WareHouseInfo[factionID][whVirtualWorld], WareHouseInfo[factionID][whInterior]); 
			if(WareHouseInfo[factionID][whLead] >= 25 && WareHouseInfo[factionID][whMetal] >= 25)
			{
				if(WareHouseInfo[factionID][whLevel] == 1)
					WareHouseInfo[factionID][whTimer] = SetTimerEx("AddToWarehouse", 20000, false, "d", factionID); // every 20 seconds
			}
		}
	}
	return 1;
}

function:AddToWarehouse(factionid)
{
	if(WareHouseInfo[factionid][whLead] >= 25 && WareHouseInfo[factionid][whMetal] >= 25)
	{
		if(WareHouseInfo[factionid][whLevel] == 1)
		{
			WareHouseInfo[factionid][whLead] -= 25;
			WareHouseInfo[factionid][whMetal] -= 25;
			WareHouseInfo[factionid][whMaterials] += 25;
		}
		ReloadFaction(factionid);
	}
	return 1;
}

function:OnLoadHQs(fromstart)
{
	if(fromstart == 1) FactionLoop(f) HQInfo[f][hqActive] = false;
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new c = 0; c < rows; c++)
		{
			new factionID = cache_get_field_content_int(c, "ID", MySQLPipeline);
			new iGet[75];
			
			cache_get_field_content(c, "Open", iGet, MySQLPipeline); if(strval(iGet) == 1) HQInfo[factionID][hqOpen] = true; else HQInfo[factionID][hqOpen] = false;
			cache_get_field_content(c, "StockTog", iGet, MySQLPipeline); if(strval(iGet) == 1) HQInfo[factionID][fHQStockTog] = true; else HQInfo[factionID][fHQStockTog] = false;
			cache_get_field_content(c, "Stock", iGet, MySQLPipeline); HQInfo[factionID][fHQStock] = strval(iGet);
			cache_get_field_content(c, "X", iGet, MySQLPipeline); HQInfo[factionID][fHQX] = floatstr(iGet);
			cache_get_field_content(c, "Y", iGet, MySQLPipeline); HQInfo[factionID][fHQY] = floatstr(iGet);
			cache_get_field_content(c, "Z", iGet, MySQLPipeline); HQInfo[factionID][fHQZ] = floatstr(iGet);
			cache_get_field_content(c, "A", iGet, MySQLPipeline); HQInfo[factionID][fHQA] = floatstr(iGet);
			cache_get_field_content(c, "Interior", iGet, MySQLPipeline); HQInfo[factionID][fHQInt] = strval(iGet);
			cache_get_field_content(c, "VirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][fHQVW] = strval(iGet);
			cache_get_field_content(c, "LeaderX", iGet, MySQLPipeline); HQInfo[factionID][flSpawnX] = floatstr(iGet);
			cache_get_field_content(c, "LeaderY", iGet, MySQLPipeline); HQInfo[factionID][flSpawnY] = floatstr(iGet);
			cache_get_field_content(c, "LeaderZ", iGet, MySQLPipeline); HQInfo[factionID][flSpawnZ] = floatstr(iGet);
			cache_get_field_content(c, "LeaderA", iGet, MySQLPipeline); HQInfo[factionID][flSpawnA] = floatstr(iGet);
			cache_get_field_content(c, "LeaderInterior", iGet, MySQLPipeline); HQInfo[factionID][flSpawnInt] = strval(iGet);
			cache_get_field_content(c, "LeaderVirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][flSpawnVW] = strval(iGet);
			cache_get_field_content(c, "SpawnX", iGet, MySQLPipeline); HQInfo[factionID][fSpawnX] = floatstr(iGet);
			cache_get_field_content(c, "SpawnY", iGet, MySQLPipeline); HQInfo[factionID][fSpawnY] = floatstr(iGet);
			cache_get_field_content(c, "SpawnZ", iGet, MySQLPipeline); HQInfo[factionID][fSpawnZ] = floatstr(iGet);
			cache_get_field_content(c, "SpawnA", iGet, MySQLPipeline); HQInfo[factionID][fSpawnA] = floatstr(iGet);
			cache_get_field_content(c, "SpawnInterior", iGet, MySQLPipeline); HQInfo[factionID][fSpawnInt] = strval(iGet);
			cache_get_field_content(c, "SpawnVirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][fSpawnVW] = strval(iGet);
			cache_get_field_content(c, "RoofX", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofX] = floatstr(iGet);
			cache_get_field_content(c, "RoofY", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofY] = floatstr(iGet);
			cache_get_field_content(c, "RoofZ", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofZ] = floatstr(iGet);
			cache_get_field_content(c, "RoofA", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofA] = floatstr(iGet);
			cache_get_field_content(c, "RoofInterior", iGet, MySQLPipeline); HQInfo[factionID][fHQInt] = strval(iGet);
			cache_get_field_content(c, "RoofVirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][fHQVW] = strval(iGet);
			HQInfo[factionID][hqActive] = true;
			
			DestroyDynamicPickup(HQInfo[factionID][hqPickup]);
			DestroyDynamic3DTextLabel(HQInfo[factionID][hqLabel]);
			HQInfo[factionID][hqPickup] = CreateDynamicPickup(1239, 1, HQInfo[factionID][fHQX], HQInfo[factionID][fHQY], HQInfo[factionID][fHQZ], HQInfo[factionID][fHQVW], HQInfo[factionID][fHQInt]);
			new iFormat[256];
			format(iFormat, sizeof(iFormat), "{808080}Headquaters\n{FFFFFF}%s", FactionInfo[factionID][fName]);
			HQInfo[factionID][hqLabel] = CreateDynamic3DTextLabel(iFormat, COLOR_WHITE, HQInfo[factionID][fHQX], HQInfo[factionID][fHQY], HQInfo[factionID][fHQZ]+0.6, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HQInfo[factionID][fHQVW], HQInfo[factionID][fHQInt]); 
			
		}
	}
	return 1;
}

function:OnLoadVehicles(fromstart)
{
	if(fromstart == 1)
	{
		VehicleLoop(v)
		{
			VehicleInfo[v][vActive] = false;
//			VehicleInfo[v][vSpawned] = false;
		}
	}
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new c = 0; c < rows; c++)
		{
			new iGet[50];
		    new vid = cache_get_field_content_int(c, "ID", MySQLPipeline);
			cache_get_field_content(c, "Model", iGet, MySQLPipeline); VehicleInfo[vid][vModel] = strval(iGet);
			cache_get_field_content(c, "X", iGet, MySQLPipeline); VehicleInfo[vid][vX] = floatstr(iGet);
			cache_get_field_content(c, "Y", iGet, MySQLPipeline); VehicleInfo[vid][vY] = floatstr(iGet);
			cache_get_field_content(c, "Z", iGet, MySQLPipeline); VehicleInfo[vid][vZ] = floatstr(iGet);
			cache_get_field_content(c, "A", iGet, MySQLPipeline); VehicleInfo[vid][vA] = floatstr(iGet);
			cache_get_field_content(c, "VirtualWorld", iGet, MySQLPipeline); VehicleInfo[vid][vVirtualWorld] = strval(iGet);
			cache_get_field_content(c, "Colour1", iGet, MySQLPipeline); VehicleInfo[vid][vColour1] = strval(iGet);
			cache_get_field_content(c, "Colour2", iGet, MySQLPipeline); VehicleInfo[vid][vColour2] = strval(iGet);
			cache_get_field_content(c, "Paintjob", iGet, MySQLPipeline); VehicleInfo[vid][vPaintJob] = strval(iGet);
			cache_get_field_content(c, "FactionID", iGet, MySQLPipeline); VehicleInfo[vid][vFaction] = strval(iGet);
			cache_get_field_content(c, "Reserved", iGet, MySQLPipeline); VehicleInfo[vid][vReserved] = strval(iGet);
			cache_get_field_content(c, "Business", iGet, MySQLPipeline); VehicleInfo[vid][vBusiness] = strval(iGet);
			cache_get_field_content(c, "Sellprice", iGet, MySQLPipeline); VehicleInfo[vid][vSellPrice] = strval(iGet);
			if(VehicleInfo[vid][vSellPrice] < 0) VehicleInfo[vid][vSellPrice] = 0;
			cache_get_field_content(c, "Fuel", iGet, MySQLPipeline); VehicleInfo[vid][vFuel] = strval(iGet);
			cache_get_field_content(c, "Impounded", iGet, MySQLPipeline); VehicleInfo[vid][vImpounded] = strval(iGet);
			cache_get_field_content(c, "ImpoundFee", iGet, MySQLPipeline); VehicleInfo[vid][vImpoundFee] = strval(iGet);
			cache_get_field_content(c, "Mileage", iGet, MySQLPipeline); VehicleInfo[vid][vMileage] = floatstr(iGet);
			cache_get_field_content(c, "Alarm", iGet, MySQLPipeline); VehicleInfo[vid][vAlarm] = strval(iGet);
			cache_get_field_content(c, "Registered", iGet, MySQLPipeline); if(strval(iGet) == 1) VehicleInfo[vid][vRegistered] = true; else VehicleInfo[vid][vRegistered] = false;
			cache_get_field_content(c, "Job", iGet, MySQLPipeline, MySQLPipeline); myStrcpy(VehicleInfo[vid][vJob], iGet);
			cache_get_field_content(c, "ImpoundReason", iGet, MySQLPipeline); myStrcpy(VehicleInfo[vid][vImpoundReason], iGet);
			cache_get_field_content(c, "Plate", iGet, MySQLPipeline); myStrcpy(VehicleInfo[vid][vPlate], iGet);
			cache_get_field_content(c, "Owner", iGet, MySQLPipeline);myStrcpy(VehicleInfo[vid][vOwner], iGet);
			cache_get_field_content(c, "Dupekey", iGet, MySQLPipeline);myStrcpy(VehicleInfo[vid][vDupekey], iGet);
			cache_get_field_content(c, "Components", iGet, MySQLPipeline);
			sscanf(iGet, "p<,>iiiiiiiiiiiiii", 	VehicleInfo[vid][vComponents][0],
												VehicleInfo[vid][vComponents][1],
												VehicleInfo[vid][vComponents][2],
												VehicleInfo[vid][vComponents][3],
												VehicleInfo[vid][vComponents][4],
												VehicleInfo[vid][vComponents][5],
												VehicleInfo[vid][vComponents][6],
												VehicleInfo[vid][vComponents][7],
												VehicleInfo[vid][vComponents][8],
												VehicleInfo[vid][vComponents][9],
												VehicleInfo[vid][vComponents][10],
												VehicleInfo[vid][vComponents][11],
												VehicleInfo[vid][vComponents][12],
												VehicleInfo[vid][vComponents][13]);
												
			cache_get_field_content(c, "Weapon", iGet, MySQLPipeline);
			sscanf(iGet, "p<,>iiiiiiiiiiiii", 	VehicleInfo[vid][vWeapon][0],
												VehicleInfo[vid][vWeapon][1],
												VehicleInfo[vid][vWeapon][2],
												VehicleInfo[vid][vWeapon][3],
												VehicleInfo[vid][vWeapon][4],
												VehicleInfo[vid][vWeapon][5],
												VehicleInfo[vid][vWeapon][6],
												VehicleInfo[vid][vWeapon][7],
												VehicleInfo[vid][vWeapon][8],
												VehicleInfo[vid][vWeapon][9],
												VehicleInfo[vid][vWeapon][10],
												VehicleInfo[vid][vWeapon][11],
												VehicleInfo[vid][vWeapon][12]);
												
			cache_get_field_content(c, "Ammo", iGet, MySQLPipeline);
			sscanf(iGet, "p<,>iiiiiiiiiiiii", 	VehicleInfo[vid][vAmmo][0],
												VehicleInfo[vid][vAmmo][1],
												VehicleInfo[vid][vAmmo][2],
											 	VehicleInfo[vid][vAmmo][3],
											 	VehicleInfo[vid][vAmmo][4],
											 	VehicleInfo[vid][vAmmo][5],
											 	VehicleInfo[vid][vAmmo][6],
											 	VehicleInfo[vid][vAmmo][7],
											 	VehicleInfo[vid][vAmmo][8],
											 	VehicleInfo[vid][vAmmo][9],
											 	VehicleInfo[vid][vAmmo][10],
											 	VehicleInfo[vid][vAmmo][11],
											 	VehicleInfo[vid][vAmmo][12]);
			VehicleInfo[vid][vActive] = true;
			if(fromstart == 1)
			{
//				VehicleInfo[vid][vSpawned] = false;
				VehicleInfo[vid][vRID] = INVALID_VEHICLE_ID;
				VehicleInfo[vid][vID] = INVALID_VEHICLE_ID;
				if(!strcmp(VehicleInfo[vid][vOwner], "NoBodY", false))
				{	
					new respawnTick = -1;
					if(VehicleInfo[vid][vReserved] == VEH_RES_NOOBIE || VehicleInfo[vid][vReserved] == VEH_RES_OCCUPA || VehicleInfo[vid][vReserved] == VEH_RES_RENT) respawnTick = 300;
					VehicleInfo[vid][vRID] = GetNextCreatedVehicleID();
					VehicleInfo[vid][vID] = CreateVehicle(VehicleInfo[vid][vModel], VehicleInfo[vid][vX], VehicleInfo[vid][vY], VehicleInfo[vid][vZ], VehicleInfo[vid][vA], VehicleInfo[vid][vColour1], VehicleInfo[vid][vColour2], respawnTick);
//					VehicleInfo[vid][vSpawned] = true;
					SetVehicleVirtualWorld(VehicleInfo[vid][vRID], VehicleInfo[vid][vVirtualWorld]);
					SetVehicleNumberPlate(VehicleInfo[vid][vRID], VehicleInfo[vid][vPlate]);
					SetVehicleToRespawn(VehicleInfo[vid][vRID]);
					SetVehicleEngineOff(VehicleInfo[vid][vRID]);
					UnlockVehicle(VehicleInfo[vid][vRID]);
					SetTimerEx("ModCar", 2000, 0, "d", VehicleInfo[vid][vRID]);
				}	
			}
			else // reloaded vehicle
			{
				if(IsValidVehicle(GetCarID(vid)))
				{
					DestroyVehicle(GetCarID(vid));
					//VehicleInfo[vid][vSpawned] = false;
					VehicleInfo[vid][vRID] = INVALID_VEHICLE_ID;
					VehicleInfo[vid][vID] = INVALID_VEHICLE_ID;
				}
				if(!strcmp(VehicleInfo[vid][vOwner], "NoBodY", false))
				{
					new respawnTick = -1;
					if(VehicleInfo[vid][vReserved] == VEH_RES_NOOBIE || VehicleInfo[vid][vReserved] == VEH_RES_OCCUPA || VehicleInfo[vid][vReserved] == VEH_RES_RENT) respawnTick = 300;
					VehicleInfo[vid][vRID] = GetNextCreatedVehicleID();
					VehicleInfo[vid][vID] = CreateVehicle(VehicleInfo[vid][vModel], VehicleInfo[vid][vX], VehicleInfo[vid][vY], VehicleInfo[vid][vZ], VehicleInfo[vid][vA], VehicleInfo[vid][vColour1], VehicleInfo[vid][vColour2], respawnTick);
					//VehicleInfo[vid][vSpawned] = true;
					SetVehicleVirtualWorld(VehicleInfo[vid][vRID], VehicleInfo[vid][vVirtualWorld]);
					SetVehicleNumberPlate(VehicleInfo[vid][vRID], VehicleInfo[vid][vPlate]);
					SetVehicleToRespawn(VehicleInfo[vid][vRID]);
					SetVehicleEngineOff(VehicleInfo[vid][vRID]);
					UnlockVehicle(VehicleInfo[vid][vRID]);
					SetTimerEx("ModCar", 2000, 0, "d", VehicleInfo[vid][vRID]);
				}
			}
		}
	}
	return 1;
}

function:ShowOfflineMembers(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	SendClientMSG(playerid, 0x93B8B8FF, "[%s]{C9DCDC} - Offline members: ", GetPlayerFactionName(playerid));
	if(rows)
	{
		for(new row = 0; row < rows; row++) //magic is happening!
		{
			new iMessage[128], iFormat[45], iGet[75], pName[MAX_PLAYER_NAME];
			cache_get_field_content(row, "PlayerName", pName, MySQLPipeline);
			if(IsPlayerConnected(GetPlayerId(pName))) continue; // player is connected, skip it!
			cache_get_field_content(row, "RankName", iGet, MySQLPipeline);
			format(iFormat, sizeof(iFormat), " - %s %s", iGet, pName); strcat(iMessage, iFormat);
			cache_get_field_content(row, "Tier", iGet, MySQLPipeline);
			format(iFormat, sizeof(iFormat), " [Tier: %d]", strval(iGet)); strcat(iMessage, iFormat);
			cache_get_field_content(row, "FactionPay", iGet, MySQLPipeline);
			format(iFormat, sizeof(iFormat), " [Payment: $%s]", number_format(strval(iGet))); strcat(iMessage, iFormat);
			cache_get_field_content(row, "LastOnline", iGet, MySQLPipeline);
			format(iFormat, sizeof(iFormat), " [Last Online: %s]", iGet); strcat(iMessage, iFormat);
			SendClientMessage(playerid, COLOR_GREY, iMessage);
		}
	}
	return 1;
}

function:OnHospitalHeal(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    new Float:health;
		GetPlayerHealth(playerid,health);
		if(health >= 65)
		{
			PlayerTemp[playerid][gettingTreatmentFromHospital] = false;
			DefaultSpawn(playerid);
			return 1;
		}
		TogglePlayerControllable(playerid, false);
		SetPlayerHealth(playerid, health+1);
	    SetTimerEx("OnHospitalHeal", 250, 0, "i", playerid);
		return 1;
	}
	return 1;
}

function:PutPlayerInVehicleEx(playerid, vehicleid)
{
	PutPlayerInVehicle(playerid, GetCarID(vehicleid), 0);
}

function:ModCar(carid)
{
	new vehicleid = FindVehicleID(carid);
    for(new c = 0; c < CAR_COMPONENTS; c++)
    {
        if(VehicleInfo[vehicleid][vComponents][c] > 0)
		{
			AddVehicleComponent(carid, VehicleInfo[vehicleid][vComponents][c]);
		}
    }
	ChangeVehiclePaintjob(carid, VehicleInfo[vehicleid][vPaintJob]);
}

function:BreakIntoNearestCar(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 1;
	new carid = GetPlayerNearestVehicle(playerid);
	new vehicleid = FindVehicleID(carid);
	if(type == 0)
	{
		if(GetDistanceFromPlayerToVehicle(playerid, carid) > 5.0)
			return SendClientError(playerid, "There is no vehicle around you!");
		if(VehicleInfo[vehicleid][vLocked] != true)
			return SendClientError(playerid, "This vehicle is not even locked!");
		SetPVarInt(playerid, "BreakingIntoCar", carid);
		SetPVarInt(playerid, "BreakingIntoCarTimer", 1);
		SetPVarInt(playerid, "BreakingIntoCarNeeded", minrand(120,180));
		format(iStr, sizeof(iStr), "attempts to picklock the %s.", GetVehicleName(carid));
		Action(playerid, iStr);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 1000, 1); // bomb plant
		SetTimerEx("BreakIntoNearestCar", 1000, false, "dd", playerid, 1);
	}
	else
	{
		if(GetDistanceFromPlayerToVehicle(playerid, carid) > 8.0)
		{
			SendClientError(playerid, " The vehicle went too far away!");
			format(iStr, sizeof(iStr), "** [%s CAR ALARM] *** [%s CAR ALARM] *** [%s CAR ALARM] **", GetVehicleName(carid), GetVehicleName(carid), GetVehicleName(carid));
			NearMessage(playerid, iStr, COLOR_ME2, 80.0);
			format(iStr, sizeof(iStr), "has failed picklocking the %s.", GetVehicleName(carid));
			Action(playerid, iStr);
			DeletePVar(playerid, "BreakingIntoCar");
			DeletePVar(playerid, "BreakingIntoCarTimer");
			DeletePVar(playerid, "BreakingIntoCarNeeded");
			TogglePlayerControllable(playerid, true);
			return 1;
		}
		if(GetPVarInt(playerid, "BreakingIntoCarTimer") >= GetPVarInt(playerid, "BreakingIntoCarNeeded"))
		{
			UnlockVehicle(carid);
			format(iStr, sizeof(iStr), "** [%s CAR ALARM] *** [%s CAR ALARM] *** [%s CAR ALARM] **", GetVehicleName(carid), GetVehicleName(carid), GetVehicleName(carid));
			NearMessage(playerid, iStr, COLOR_ME2, 80.0);
			format(iStr, sizeof(iStr), "has picklocked the nearby %s.", GetVehicleName(carid));
			Action(playerid, iStr);
			DeletePVar(playerid, "BreakingIntoCar");
			DeletePVar(playerid, "BreakingIntoCarTimer");
			DeletePVar(playerid, "BreakingIntoCarNeeded");
			TogglePlayerControllable(playerid, true);
			TDWarning(playerid, "you broke the lock of this vehicle!", 2000);
			return 1;
		}
		format(iStr, sizeof(iStr), "~r~breaking into vehicle~n~~w~%dsec left", GetPVarInt(playerid, "BreakingIntoCarNeeded")-GetPVarInt(playerid, "BreakingIntoCarTimer"));
		GameTextForPlayer(playerid, iStr, 1200, 4);
		SetPVarInt(playerid, "BreakingIntoCarTimer", GetPVarInt(playerid, "BreakingIntoCarTimer") + 1);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 1000, 1); // bomb plant
		SetTimerEx("BreakIntoNearestCar", 1000, false, "dd", playerid, 1);
	}
	return 1;
}

function:VehicleToPlayer(playerid, carid, putin)
{
	if(GetPlayerVirtualWorld(playerid))
		return SendClientError(playerid, "Could not get vehicle. Possible reason: Interior");
	new Float:pZZ[4];
	GetPlayerFacingAngle(playerid, pZZ[3]);
	GetPlayerPos(playerid, pZZ[0], pZZ[1], pZZ[2]);
	SetVehiclePos(carid, pZZ[0], pZZ[1], pZZ[2]);
	SetVehicleZAngle(carid, pZZ[3]);
	SetVehicleVirtualWorld(carid, 0);
	if(putin) PutPlayerInVehicle(playerid, carid, 0);
	return 1;
}

function:OpenCars(carid)
{
	UnlockVehicle(carid);
	return 1;
}

function:WelcomeMessage(playerid)
{
	if(!IsARolePlayName(PlayerName(playerid)))
	{
		format(iStr, sizeof(iStr), "%s has been kicked. @INVALID_RP_NAME!", PlayerName(playerid));
	    AdminNotice(iStr);
		SendClientWarning(playerid, "You need a Roleplay name to play here! \"First_Last\"");
		SetTimerEx("ToKick",500,0,"i",playerid);
		return 1;
	}
	PlayAudioStreamForPlayer(playerid, "http://k003.kiwi6.com/hotlink/n4zx516ikd/the_godfather_title_song_1.mp3");
	Misc::ClearWindow(playerid);
	new iQuery[275];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `Password` FROM `PlayerInfo` WHERE `PlayerName` = '%e' LIMIT 1", PlayerName(playerid));
	mysql_tquery(MySQLPipeline, iQuery, "OnCheckPlayerAccount", "i", playerid);
	SetTimerEx("RespawnEx", 300, 0, "i", playerid);
	return 1;
}

function:OnCheckPlayerAccount(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
	    new pPassword[129];
		cache_get_field_content(0, "Password", pPassword, MySQLPipeline);
	    myStrcpy(PlayerTemp[playerid][ppassword], pPassword);
		ShowDialog(playerid, DIALOG_LOGIN);
	}
	else ShowDialog(playerid, DIALOG_REGISTER);
}

function:ShortCutLoadEx(playerid)
{
	new iQuery[275];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `PlayerInfo` WHERE `PlayerName` = '%e' LIMIT 1", PlayerName(playerid));
	mysql_tquery(MySQLPipeline, iQuery, "LoadPlayerAccount", "i", playerid);
	return 1;
}

function:LoadPlayerAccount(playerid)
{
	new iGet[128];
	cache_get_field_content(0, "Money", iGet, MySQLPipeline); PlayerTemp[playerid][sm] = strval(iGet);
	cache_get_field_content(0, "Bank", iGet, MySQLPipeline); PlayerInfo[playerid][bank] = strval(iGet);
	cache_get_field_content(0, "level", iGet, MySQLPipeline); PlayerInfo[playerid][playerlvl] = strval(iGet);
	cache_get_field_content(0, "RPoints", iGet, MySQLPipeline); PlayerInfo[playerid][rpoints] = strval(iGet);
	cache_get_field_content(0, "PlayerTime", iGet, MySQLPipeline); PlayerInfo[playerid][playertime] = strval(iGet);
	cache_get_field_content(0, "Tier", iGet, MySQLPipeline); PlayerInfo[playerid][ranklvl] = strval(iGet);
	cache_get_field_content(0, "Jail", iGet, MySQLPipeline); PlayerInfo[playerid][jail] = strval(iGet);
	cache_get_field_content(0, "Warns", iGet, MySQLPipeline); PlayerInfo[playerid][warns] = strval(iGet);
	cache_get_field_content(0, "JailTime", iGet, MySQLPipeline); PlayerInfo[playerid][jailtime] = strval(iGet);
	cache_get_field_content(0, "Banned", iGet, MySQLPipeline); PlayerInfo[playerid][banned] = strval(iGet);
	cache_get_field_content(0, "RentPrice", iGet, MySQLPipeline); PlayerInfo[playerid][rentprice] = strval(iGet);
	cache_get_field_content(0, "DriverLicense", iGet, MySQLPipeline); PlayerInfo[playerid][driverlic] = strval(iGet);
	cache_get_field_content(0, "WeaponLicense", iGet, MySQLPipeline); PlayerInfo[playerid][weaplic] = strval(iGet);
	cache_get_field_content(0, "JobSkill", iGet, MySQLPipeline); PlayerInfo[playerid][jobskill] = strval(iGet);
	cache_get_field_content(0, "TotalPayTime", iGet, MySQLPipeline); PlayerInfo[playerid][totalpayt] = strval(iGet);
	cache_get_field_content(0, "Kills", iGet, MySQLPipeline); PlayerInfo[playerid][kills] = strval(iGet);
	cache_get_field_content(0, "deaths", iGet, MySQLPipeline); PlayerInfo[playerid][deaths] = strval(iGet);
	cache_get_field_content(0, "SellableDrugs", iGet, MySQLPipeline); PlayerInfo[playerid][sdrugs] = strval(iGet);
	cache_get_field_content(0, "RentHouse", iGet, MySQLPipeline); PlayerInfo[playerid][housenum] = strval(iGet);
	cache_get_field_content(0, "AdminLevel", iGet, MySQLPipeline); PlayerInfo[playerid][power] = strval(iGet);
	cache_get_field_content(0, "Skin", iGet, MySQLPipeline); PlayerInfo[playerid][Skin] = strval(iGet);
	cache_get_field_content(0, "Guns", iGet, MySQLPipeline); PlayerInfo[playerid][guns] = strval(iGet);
	cache_get_field_content(0, "SGuns", iGet, MySQLPipeline); PlayerInfo[playerid][sMaterials] = strval(iGet);
	cache_get_field_content(0, "PilotLicense", iGet, MySQLPipeline); PlayerInfo[playerid][flylic] = strval(iGet);
	cache_get_field_content(0, "SailingLicense", iGet, MySQLPipeline); PlayerInfo[playerid][boatlic] = strval(iGet);
	cache_get_field_content(0, "Bail", iGet, MySQLPipeline); PlayerInfo[playerid][bail] = strval(iGet);
	cache_get_field_content(0, "PremiumLevel", iGet, MySQLPipeline); PlayerInfo[playerid][premium] = strval(iGet);
	cache_get_field_content(0, "PhoneNumber", iGet, MySQLPipeline); PlayerInfo[playerid][phonenumber] = strval(iGet);
	cache_get_field_content(0, "GotPhone", iGet, MySQLPipeline); PlayerInfo[playerid][gotphone] = strval(iGet);
	cache_get_field_content(0, "PhoneChanges", iGet, MySQLPipeline); PlayerInfo[playerid][phonechanges] = strval(iGet);
	cache_get_field_content(0, "NameChanges", iGet, MySQLPipeline); PlayerInfo[playerid][namechanges] = strval(iGet);
	cache_get_field_content(0, "PhoneBook", iGet, MySQLPipeline); PlayerInfo[playerid][phonebook] = strval(iGet);
	cache_get_field_content(0, "Laptop", iGet, MySQLPipeline); PlayerInfo[playerid][laptop] = strval(iGet);
	cache_get_field_content(0, "Age", iGet, MySQLPipeline); PlayerInfo[playerid][age] = strval(iGet);
	cache_get_field_content(0, "Radio", iGet, MySQLPipeline); PlayerInfo[playerid][radio] = strval(iGet);
	cache_get_field_content(0, "Freq1", iGet, MySQLPipeline); PlayerInfo[playerid][freq1] = strval(iGet);
	cache_get_field_content(0, "Freq2", iGet, MySQLPipeline); PlayerInfo[playerid][freq2] = strval(iGet);
	cache_get_field_content(0, "Freq3", iGet, MySQLPipeline); PlayerInfo[playerid][freq3] = strval(iGet);
	cache_get_field_content(0, "CurrentFequency", iGet, MySQLPipeline); PlayerInfo[playerid][curfreq] = strval(iGet);
	cache_get_field_content(0, "FactionID", iGet, MySQLPipeline); PlayerInfo[playerid][playerteam] = strval(iGet);
	cache_get_field_content(0, "TotalRuns", iGet, MySQLPipeline); PlayerInfo[playerid][totalruns] = strval(iGet);
	cache_get_field_content(0, "FactionPay", iGet, MySQLPipeline); PlayerInfo[playerid][fpay] = strval(iGet);
	cache_get_field_content(0, "TBanned", iGet, MySQLPipeline); PlayerInfo[playerid][tbanned] = strval(iGet);
	cache_get_field_content(0, "Helper", iGet, MySQLPipeline); PlayerInfo[playerid][helper] = strval(iGet);
	cache_get_field_content(0, "PremiumExpire", iGet, MySQLPipeline); PlayerInfo[playerid][premiumexpire] = strval(iGet);
	cache_get_field_content(0, "Loan", iGet, MySQLPipeline); PlayerInfo[playerid][loan] = strval(iGet);
	cache_get_field_content(0, "vMax", iGet, MySQLPipeline); PlayerInfo[playerid][vMax] = strval(iGet);
	cache_get_field_content(0, "vSMax", iGet, MySQLPipeline); PlayerInfo[playerid][vSpawnMax] = strval(iGet);
	cache_get_field_content(0, "pbdeaths", iGet, MySQLPipeline); PlayerInfo[playerid][pbdeaths] = strval(iGet);
	cache_get_field_content(0, "pbkills", iGet, MySQLPipeline); PlayerInfo[playerid][pbkills] = strval(iGet);
	cache_get_field_content(0, "Gender", iGet, MySQLPipeline); PlayerInfo[playerid][pGender] = strval(iGet);
	cache_get_field_content(0, "Ethnicity", iGet, MySQLPipeline); PlayerInfo[playerid][pEthnicity] = strval(iGet);
	cache_get_field_content(0, "Boombox", iGet, MySQLPipeline); PlayerInfo[playerid][pBoomBox] = strval(iGet);
	cache_get_field_content(0, "Seeds", iGet, MySQLPipeline); PlayerTemp[playerid][seeds] = strval(iGet);
	cache_get_field_content(0, "TotalFish", iGet, MySQLPipeline); PlayerTemp[playerid][totalfish] = strval(iGet);
	cache_get_field_content(0, "TotalRob", iGet, MySQLPipeline); PlayerTemp[playerid][totalrob] = strval(iGet);
	cache_get_field_content(0, "TotalLogin", iGet, MySQLPipeline); PlayerTemp[playerid][totallogin] = strval(iGet);
	cache_get_field_content(0, "Key_Enter", iGet, MySQLPipeline); PlayerTemp[playerid][key_enter] = strval(iGet);
	cache_get_field_content(0, "Fightstyleleft", iGet, MySQLPipeline); PlayerTemp[playerid][fightstyleleft] = strval(iGet);
	cache_get_field_content(0, "PhoneOFF", iGet, MySQLPipeline); PlayerTemp[playerid][phoneoff] = strval(iGet);
	cache_get_field_content(0, "OOCOff", iGet, MySQLPipeline); PlayerTemp[playerid][oocoff] = strval(iGet);
	cache_get_field_content(0, "WhisperLock", iGet, MySQLPipeline); PlayerTemp[playerid][wlock] = strval(iGet);
	cache_get_field_content(0, "jqmessage", iGet, MySQLPipeline); PlayerTemp[playerid][jqmessage] = strval(iGet);
	cache_get_field_content(0, "NameOFF", iGet, MySQLPipeline); PlayerTemp[playerid][hname] = strval(iGet);
	cache_get_field_content(0, "FishAmount", iGet, MySQLPipeline); PlayerTemp[playerid][fishamount] = strval(iGet);
	cache_get_field_content(0, "totalguns", iGet, MySQLPipeline); PlayerTemp[playerid][totalguns] = strval(iGet);
	cache_get_field_content(0, "imprisoned", iGet, MySQLPipeline); PlayerTemp[playerid][imprisoned] = strval(iGet);
	cache_get_field_content(0, "OOCMode", iGet, MySQLPipeline); PlayerTemp[playerid][oocmode] = strval(iGet);
	cache_get_field_content(0, "AllowCBug", iGet, MySQLPipeline); PlayerInfo[playerid][allowCBug] = strval(iGet);
	cache_get_field_content(0, "ChatAnim", iGet, MySQLPipeline); if(strval(iGet) == 1) PlayerTemp[playerid][chatAnim] = true; else PlayerTemp[playerid][chatAnim] = false;
	cache_get_field_content(0, "Wanted", iGet, MySQLPipeline); PlayerInfo[playerid][wantedLvl] = strval(iGet);
	cache_get_field_content(0, "JailReason", iGet, MySQLPipeline); myStrcpy(PlayerInfo[playerid][jailreason], iGet);
 	cache_get_field_content(0, "Job", iGet, MySQLPipeline); myStrcpy(PlayerInfo[playerid][job], iGet);
 	cache_get_field_content(0, "RankName", iGet, MySQLPipeline); myStrcpy(PlayerInfo[playerid][rankname], iGet);
 	cache_get_field_content(0, "WhenIGotBanned", iGet, MySQLPipeline); myStrcpy(PlayerInfo[playerid][whenigotbanned], iGet);
 	cache_get_field_content(0, "WhoBannedMe", iGet, MySQLPipeline); myStrcpy(PlayerInfo[playerid][whobannedme], iGet);
 	cache_get_field_content(0, "BanReason", iGet, MySQLPipeline); myStrcpy(PlayerInfo[playerid][banreason], iGet);
 	cache_get_field_content(0, "WantedReason", iGet, MySQLPipeline); myStrcpy(PlayerInfo[playerid][wantedReason], iGet);
	cache_get_field_content(0, "DrugInfo", iGet, MySQLPipeline);
	new iP[35];
	strcat(iP, "p<,>");
	LOOP:drugsID(0, sizeof(drugtypes)) strcat(iP, "i");
  	sscanf(iGet, iP, PlayerInfo[playerid][hasdrugs][0], PlayerInfo[playerid][hasdrugs][1], PlayerInfo[playerid][hasdrugs][2], PlayerInfo[playerid][hasdrugs][3], PlayerInfo[playerid][hasdrugs][4], PlayerInfo[playerid][hasdrugs][5], PlayerInfo[playerid][hasdrugs][6], PlayerInfo[playerid][hasdrugs][7]);

  	if(PlayerInfo[playerid][freq1] < 100000 || PlayerInfo[playerid][freq1] > 999999 || PlayerInfo[playerid][freq1] == 0) PlayerInfo[playerid][freq1] = INVALID_RADIO_FREQ;
  	if(PlayerInfo[playerid][freq2] < 100000 || PlayerInfo[playerid][freq2] > 999999 || PlayerInfo[playerid][freq2] == 0) PlayerInfo[playerid][freq2] = INVALID_RADIO_FREQ;
  	if(PlayerInfo[playerid][freq3] < 100000 || PlayerInfo[playerid][freq3] > 999999 || PlayerInfo[playerid][freq3] == 0) PlayerInfo[playerid][freq3] = INVALID_RADIO_FREQ;
  	if(PlayerInfo[playerid][curfreq] < 100000 || PlayerInfo[playerid][curfreq] > 999999 || PlayerInfo[playerid][curfreq] == 0) PlayerInfo[playerid][curfreq] = INVALID_RADIO_FREQ;

	SetPlayerScore(playerid, PlayerInfo[playerid][playerlvl]);
	SetPlayerColor(playerid, COLOR_WHITE);
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, PlayerTemp[playerid][sm]);
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	SetPlayerWantedLevel(playerid, PlayerInfo[playerid][wantedLvl]);

	PlayerTemp[playerid][totallogin]++;
	PlayerTemp[playerid][loggedIn] = true;
	// ======================= [ Checks ] ======================================
	if(PlayerTemp[playerid][key_enter] == 0) PlayerTemp[playerid][key_enter] = 2;
	if(PlayerInfo[playerid][playerteam] == CIV) PlayerInfo[playerid][ranklvl] = -1;
	if(PlayerInfo[playerid][playerteam] != CIV) SetPlayerTeamEx(playerid, PlayerInfo[playerid][playerteam]);
	if(PlayerInfo[playerid][ranklvl] > 2) PlayerInfo[playerid][ranklvl] = 2;
	if(PlayerInfo[playerid][banned])
	{
		KickReas("SERVER",playerid,"Account BANNED ");
		SendClientMessage(playerid, COLOR_RED, "==============================================");
		SendClientMessage(playerid, COLOR_RED, "    You have been banned from "SERVER_GM"! ");
		SendClientMessage(playerid, COLOR_RED, " ");
		SendClientMSG(playerid, COLOR_GREY, "Your IP: %s", PlayerTemp[playerid][IP]);
		SendClientMSG(playerid, COLOR_GREY, "Reason: %s", PlayerInfo[playerid][banreason]);
		SendClientMSG(playerid, COLOR_GREY, "Banned by: %s", PlayerInfo[playerid][whobannedme]);
		SendClientMSG(playerid, COLOR_GREY, "Time&Date: %s", PlayerInfo[playerid][whenigotbanned]);
		SendClientMessage(playerid, COLOR_RED, "==============================================");
		return 1;
	}
	if(PlayerInfo[playerid][tbanned] > now())
	{
 		new bmsg[MAX_STRING];
   		format(bmsg,sizeof(bmsg),"Your account is currently banned, come back when you're unbanned!",PlayerInfo[playerid][tbanned],gettime());
		SendClientMessage(playerid,COLOR_RED,bmsg);
		KickReas("ADMIN",playerid,"Account T. BANNED ");
		return 1;
	}
	if(strcmp(PlayerInfo[playerid][job],"Medic",true)==0)
	{
		SetPlayerColor(playerid,COLOR_SYSTEM_GM);
		PlayerInfo[playerid][Skin]=276;
	}
	if(strcmp(PlayerInfo[playerid][job],"CarJacker",true)==0)
	{
	   	PlayerTemp[playerid][DropTimer] = SetTimerEx("Dropper",180000,0,"d",playerid);
	  	PlayerTemp[playerid][candrop] = 0;
	}
	if(strcmp(PlayerInfo[playerid][job],"Thief",true)==0)
	{
	    PlayerTemp[playerid][RobTimer] = SetTimerEx("Robber",240000,0,"d",playerid);
 		PlayerTemp[playerid][canrob] = 0;
	}
	if(PlayerInfo[playerid][premium])
	{
		if(gettime() > PlayerInfo[playerid][premiumexpire])
		{
			SendClientMessage(playerid,COLOR_SYSTEM_GM,"Your premium account has expired, thank you for your donation. "SERVER_GM" Team");
			PlayerInfo[playerid][premium] = 0;
			new iQuery[228];
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `PremiumLevel` = 0 WHERE `PlayerName` = '%e'", PlayerName(playerid));
            mysql_tquery(MySQLPipeline, iQuery);
		}
	}
	new string[ 168 ];
	if(PlayerInfo[playerid][playerteam] != CIV)
	{
	    format(string, sizeof(string), "# [%s] %s %s has logged in!",  GetPlayerFactionName(playerid),PlayerInfo[playerid][rankname], RPName(playerid));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam], string, COLOR_PLAYER_VLIGHTBLUE);
		SendClientMSG(playerid, COLOR_PLAYER_VLIGHTBLUE, "# [F-MOTD] %s", FactionInfo[PlayerInfo[playerid][playerteam]][fMOTD]);
	}
	format(string, sizeof(string), "3[ LOGIN ] %s[%d] has logged in.", PlayerName(playerid), playerid);
	iEcho(string);

	new ip[30], iQuery[528];
	GetPlayerIp(playerid, ip, 30);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `IP` = '%e', `LastOnline` = '%e', `Online` = 1 WHERE `PlayerName` = '%e' LIMIT 1", ip, TimeDateEx(), PlayerName(playerid));
	mysql_tquery(MySQLPipeline, iQuery);

	SetTimerEx("RespawnEx", 500, false, "d", playerid);

	if(PlayerTemp[playerid][hname] == 1) GenerateStrangerID(playerid);
	
	if(PlayerInfo[playerid][power] || PlayerInfo[playerid][helper])
	{
		if(PlayerInfo[playerid][power] != 31337)
		{	
			new iFormat[128];
			format(iFormat, sizeof(iFormat), "%s %s(%d) has logged in!", AdminLevelName(playerid), RPName(playerid), playerid);
			AdminNotice(iFormat);
		}
		new iReason[128];
		if(PlayerInfo[playerid][power]) format(iReason, sizeof(iReason), "Logged in with level %d admin powers. (%s)", PlayerInfo[playerid][power], AdminLevelName(playerid));
		else format(iReason, sizeof(iReason), "Logged in with helper powers.");
		SecurityLog(playerid, iReason);
	}
	if(PlayerInfo[playerid][pGender] == -1 || PlayerInfo[playerid][pEthnicity] == -1) ShowDialog(playerid, DIALOG_CHOOSE_ETHNICITY);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `From`, `Message` FROM `OPMs` WHERE `To` = '%e' AND `Active` = 0", PlayerName(playerid));
	mysql_tquery(MySQLPipeline, iQuery, "OnLoadOfflinePMs", "d", playerid);
	LoginDB(playerid, 1);
	return 1;
}

function:OnLoadOfflinePMs(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new c = 0; c < rows; c++)
		{
			new iFrom[MAX_PLAYER_NAME], iMessage[128];
			cache_get_field_content(c, "From", iFrom, MySQLPipeline);
			cache_get_field_content(c, "Message", iMessage, MySQLPipeline);
			SendClientMSG(playerid, 0xE65CE6FF, "(( OPM from %s: %s ))", iFrom, iMessage);
		}
		new iQuery[128];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `OPMs` SET `Active` = 1 WHERE `To` = '%e' AND `Active` = 0", PlayerName(playerid));
		mysql_tquery(MySQLPipeline, iQuery);
	}
	return 1;
}

function:EvictCommandResponse(playerid, iPlayer[], houseID)
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
	    new hisHouse;
	    hisHouse = cache_get_field_content_int(0, "RentHouse", MySQLPipeline);
	    if(hisHouse != houseID) return SendClientError(playerid, "He doesn't rent here!");
	    new iQuery[128];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `RentHouse` = -1 WHERE `PlayerName` = '%e'", iPlayer);
		mysql_tquery(MySQLPipeline, iQuery);
		format(iStr, sizeof(iStr),"10[EVICT] %s has offline-evicted %s.", PlayerName(playerid), iPlayer);
		iEcho(iStr);
		SendClientMSG(playerid, COLOR_PINK, "You have evicted %s. He/she will nolonger spawn or rent at your house!", NoUnderscore(iPlayer));
	}
	else return SendClientError(playerid, "Account not found!");
	return 1;
}

function:OfflineUninviteResponse(playerid, iPlayer)
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(!rows) return SendClientError(playerid, "Player not found in the database!");
	else
	{
		new iQuery[228], playerFaction;
		playerFaction = cache_get_field_content_int(0, "FactionID", MySQLPipeline);
		if(playerFaction != PlayerInfo[playerid][playerteam]) return SendClientError(playerid, "That player is not in your faction!");
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Tier` = -1, `RankName` = 'CIV', `FactionID` = 255, `FactionPay` = 0 WHERE `PlayerName` = '%e'", iPlayer);
		mysql_tquery(MySQLPipeline, iQuery);
	 	format(iStr, sizeof(iStr), "# [%s] %s has offline-uninvited %s.", GetPlayerFactionName(playerid), RPName(playerid), iPlayer);
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
		format(iStr, sizeof(iStr),"10[O-UNINVITE] %s has been offline-kicked from %s.", iPlayer, GetPlayerFactionName(playerid));
		iEcho(iStr);
	}
	return 1;
}

function:ToSuspend(time)
{
	new iField[12], iQuery[150];
	if(time == 1) myStrcpy(iField, "Banned");
	else myStrcpy(iField, "TBanned");
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `%s` = %d WHERE `PlayerName` = '%e'", iField, time, glob_toban);
	mysql_tquery(MySQLPipeline, iQuery);
	myStrcpy(glob_toban, "NoBodY");
}

function:AntiSpam(playerid)
{
	PlayerTemp[playerid][RecentlyShot] = 0;
	return 1;
}

function:StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	PlayerTemp[playerid][spectatingID] = INVALID_PLAYER_ID;
	PlayerTemp[playerid][specType] = ADMIN_SPEC_TYPE_NONE;
	return 1;
}

function:RespawnEx(i)
{
	SpawnPlayer(i);
}

function:okwheels(playerid)
{
    OnPlayerCommandText(playerid, "/car wheels");
}

function:RobbingTimer(playerid, playerid2,  Float:robx, Float:roby, Float:robz)
{
	if(GetPVarInt(playerid, "isrobbing") >= 1)
	{
	    new businessid = GetPVarInt(playerid, "isrobbingbiz");
	    new message[ 128 ], string[ 164 ];
	    if(!IsPlayerInRangeOfPoint(playerid, 30.0, robx, roby, robz) || !IsPlayerInRangeOfPoint(playerid2, 30.0, robx, roby, robz))
	    {
	        new Float:iPos[4];
	        GetPlayerPos(playerid, iPos[0], iPos[1], iPos[2]);
	        NearMessage(playerid,"========================================================",COLOR_RED);
			NearMessage(playerid," The robbery has failed! Cops have been alerted.",COLOR_WHITE);
			NearMessage(playerid,"========================================================",COLOR_RED);
			PlayerLoop(p)
			{
				if(IsPlayerENF(p))
				{
					SendClientMessage( p, COLOR_RED, "======== [ FAILED ROBBERY ] ========");
					SendClientMSG(p, COLOR_WHITE, " People tried to rob %s but failed!", BusinessInfo[businessid][bName]);
					SendClientMessage( p, COLOR_RED, "======================================");
				}
			}
			format(message, sizeof(message), "13[BIZ ROB] %s has failed the robbery!", PlayerName(playerid));
			iEcho(message);
			BusinessInfo[businessid][bRobbed] = false;
			SetPVarFloat(playerid, "x", 0.0);
			SetPVarFloat(playerid, "y", 1.1);
			SetPVarFloat(playerid, "z", 2.2);
			DeletePVar(playerid, "robbingtime");
			DeletePVar(playerid, "isrobbingbiz");
			DeletePVar(playerid, "isrobbing");
			KillTimer(PlayerTemp[playerid][RobBizTimer]);
			return 1;
	    }
	    else
	    {
	        SetPVarInt(playerid, "robbingtime", GetPVarInt(playerid, "robbingtime") + 1 );
			new str[164];
			format(str, 164, "~r~do not move:~n~~n~~w~%02d sec", 120-GetPVarInt(playerid, "robbingtime"));
			GameTextForPlayer(playerid, str, 5000, 4);
	        if(GetPVarInt(playerid, "robbingtime") == 40)
	        {
				format(message, sizeof(message), "13[BIZ ROB] Cops alerted on the robbery of %s!", PlayerName(playerid));
				iEcho(message);
				format(message, sizeof(message), "the business %s has been robbed by unknown men! check your gps for the exact location and arrest them.", BusinessInfo[businessid][bName]);
				gBackupMarker = -1;
				PlayerLoop(p)
				{
					if(IsPlayerENF(p))
					{
						SendClientMessage( p, COLOR_RED, "======== [ ROBBING EMERGENCY ] ========");
						SendClientMSG(p, COLOR_WHITE, " Unknown men have robbed the %s! Head over there immediately! ", BusinessInfo[businessid][bName]);
						SendClientMessage( p, COLOR_RED, "=======================================");
						ShowInfoBox(p, "Emergency", message);
						DisablePlayerCheckpoint(p);
						SetPlayerCheckpoint(p, BusinessInfo[businessid][bX], BusinessInfo[businessid][bY], BusinessInfo[businessid][bZ], 5.0);
					}
				}
            }

			new ownerteam = GetPlayerOfflineFaction(BusinessInfo[businessid][bOwner]);

			BusinessInfo[businessid][bLastRob] = 10;
            if(GetPVarInt(playerid, "robbingtime") == 60 && ownerteam != CIV)
            {
                SendClientMessageToTeam( ownerteam, "======== [ ROBBING EMERGENCY ] ========", COLOR_RED);
			    format(string, sizeof(string), " Unknown men have robbed the %s! Head over there immediately! ", BusinessInfo[businessid][bName]);
			    SendClientMessageToTeam( ownerteam, string, COLOR_WHITE);
			    SendClientMessageToTeam( ownerteam, "======================================", COLOR_RED);
			    format(message, sizeof(message), "13[BIZ ROB] Faction alerted on the robbery of %s!", PlayerName(playerid));
				iEcho(message);
            }
            if(GetPVarInt(playerid, "robbingtime") >= 120)
            {
                BusinessInfo[businessid][bTill] -= GetPVarInt(playerid, "isrobbing");
                NearMessage(playerid,"========================================================",COLOR_RED);
                format(message, sizeof(message), "Robbery succeeded, %s has stolen the moneybag! NOW RUN TO THE CHECKPOINT!", PlayerName(playerid), number_format(GetPVarInt(playerid, "isrobbing")));
				NearMessage(playerid,message,COLOR_WHITE);
				NearMessage(playerid,"========================================================",COLOR_RED);
				format(message, sizeof(message), "13[BIZ ROB] %s has gotten $%s moneybag !", PlayerName(playerid), number_format(GetPVarInt(playerid, "isrobbing")));
				iEcho(message);
				new zone[40];
				GetZone(BusinessInfo[businessid][bX], BusinessInfo[businessid][bY], BusinessInfo[businessid][bZ], zone);
				format( string, sizeof(string), "NEWS: The %s at %s has been robbed!", BusinessInfo[businessid][bName], zone);
	    		TextDrawSetString(TextDraw__News, string);
				SetPVarInt(playerid, "RobBagAmount", GetPVarInt(playerid, "isrobbing"));
				BusinessInfo[businessid][bRobbed] = false;
				SetPVarFloat(playerid, "x", 0.0);
				SetPVarFloat(playerid, "y", 1.1);
				SetPVarFloat(playerid, "z", 2.2);
				DeletePVar(playerid, "robbingtime");
				DeletePVar(playerid, "isrobbingbiz");
				DeletePVar(playerid, "isrobbing");
				new cpid = random(sizeof(robbingplaces));
				if(cpid == 0) cpid += 1;
				SetPlayerHoldingObject(playerid, 1550, 15,0.0,0.2,-0.2, 0.0, 0.0, 0.0);
				PlayerTemp[playerid][CPTimer] = SetTimerEx("SetCP", 2000, true, "dffff", playerid, robbingplaces[cpid][0],robbingplaces[cpid][1],robbingplaces[cpid][2], 2.0);
				PlayerTemp[playerid2][CPTimer] = SetTimerEx("SetCP", 2000, true, "dffff", playerid2, robbingplaces[cpid][0],robbingplaces[cpid][1],robbingplaces[cpid][2], 2.0);
				KillTimer(PlayerTemp[playerid][RobBizTimer]);
            }
            return 1;
	    }
	}
	return 1;
}

function:RobbingHouseTimer(playerid, Float:robx, Float:roby, Float:robz)
{
	if(GetPVarInt(playerid, "isrobbing") >= 1)
	{
	    new message[ 128 ];
	    if(!IsPlayerInRangeOfPoint(playerid, 10.0, robx, roby, robz))
	    {
	        new Float:iPos[4];
	        GetPlayerPos(playerid, iPos[0], iPos[1], iPos[2]);
	        NearMessage(playerid,"========================================================",COLOR_RED);
			NearMessage(playerid," The robbery has failed!",COLOR_WHITE);
			NearMessage(playerid,"========================================================",COLOR_RED);
			format(message, sizeof(message), "13[HOUSE ROB] %s has failed the robbery!", PlayerName(playerid));
			iEcho(message);
			SetPVarFloat(playerid, "x", 0.0);
			SetPVarFloat(playerid, "y", 1.1);
			SetPVarFloat(playerid, "z", 2.2);
			PlayerTemp[playerid][RobbingHouse] = -1;
			DeletePVar(playerid, "robbingtime");
			DeletePVar(playerid, "isrobbinghouse");
			DeletePVar(playerid, "isrobbing");
			KillTimer(PlayerTemp[playerid][RobBizTimer]);
			return 1;
	    }
	    else
	    {
	        SetPVarInt(playerid, "robbingtime", GetPVarInt(playerid, "robbingtime") + 1 );
			new str[164];
			format(str, 164, "~n~~n~~n~~n~~n~~n~~r~do not move:~n~~n~~w~%02d sec left", 60-GetPVarInt(playerid, "robbingtime"));
			GameTextForPlayer(playerid, str, 5000, 4);
			if(GetPVarInt(playerid, "robbingtime") >= 60)
            {
				HouseInfo[PlayerTemp[playerid][RobbingHouse]][hTill] = 0;
				SaveHouse(PlayerTemp[playerid][RobbingHouse]);
                NearMessage(playerid,"========================================================",COLOR_RED);
                format(message, sizeof(message), "House robbed! %s has the moneybag! RUN TO THE CHECKPOINT!", PlayerName(playerid), number_format(GetPVarInt(playerid, "isrobbing")));
				NearMessage(playerid,message,COLOR_WHITE);
				NearMessage(playerid,"========================================================",COLOR_RED);
				format(message, sizeof(message), "13[HOUSE ROB] %s has gotten $%s moneybag !", PlayerName(playerid), number_format(GetPVarInt(playerid, "isrobbing")));
				iEcho(message);
				SetPVarInt(playerid, "RobBagAmount", GetPVarInt(playerid, "isrobbing"));
				SetPVarFloat(playerid, "x", 0.0);
				SetPVarFloat(playerid, "y", 1.1);
				SetPVarFloat(playerid, "z", 2.2);
				DeletePVar(playerid, "robbingtime");
				DeletePVar(playerid, "isrobbinghouse");
				DeletePVar(playerid, "isrobbing");
				PlayerTemp[playerid][RobbingHouse] = -1;
				new cpid = random(sizeof(robbingplaces));
				if(cpid == 0) cpid += 1;
				SetPlayerHoldingObject(playerid, 1550, 15,0.0,0.2,-0.2, 0.0, 0.0, 0.0);
				SetPlayerCheckpoint(playerid, robbingplaces[cpid][0],robbingplaces[cpid][1],robbingplaces[cpid][2], 2.0);
				KillTimer(PlayerTemp[playerid][RobBizTimer]);
            }
            return 1;
	    }
	}
	return 1;
}

function:AdminDutyFunction(iPlayer)
{
	SetPlayerColor(iPlayer, COLOR_ADMIN_SPYREPORT);
}

function:ResetHelp(iPlayer)
{
    PlayerTemp[iPlayer][hashadhelp] = 0;
}

function:SetCP(playerid, Float:sXqq, Float: sYqq, Float: sZqq, Float:sSqq)
{
	if(GetPVarInt(playerid, "DeliveringCargo") == 1 || GetPVarInt(playerid, "HarvestCP") != 0 || GetPVarInt(playerid, "BriefCaseTill") != 0 || GetPVarInt(playerid, "RobBagAmount") != 0) SetPlayerCheckpoint(playerid, sXqq,sYqq,sZqq,sSqq);
}

function:Robber(playerid)
{
	PlayerTemp[playerid][canrob]=1;
	return 1;
}

function:GetIPResponse(iPlayer[])
{
	new tmp[ 64 ], theIPAddress[16];
	cache_get_field_content(0, "IP", theIPAddress, MySQLPipeline);
	format(tmp, sizeof(tmp), "7{ INFO } IP of %s: %s", iPlayer, theIPAddress);
	iEcho(tmp);
	return 1;
}

function:CheckInv(playerid)
{
	new
		Float:tmpH, string [ 128 ];
	GetPlayerHealth(playerid, tmpH);
	if(tmpH >= 100)
	{
	    format(string, sizeof(string), "Invulnerability check on %s (%d) was POSITIVE! (Health: %0.0f%%)", PlayerName(playerid), playerid, tmpH);
	    AdminNotice(string);
	    if(IsPlayerInAnyVehicle(playerid)) AdminNotice("Player is/was in a vehicle!");
	    return 1;
	}
	else
	{
	    format(string, sizeof(string), "Invulnerability check on %s (%d) was NEGATIVE! (Health: %0.0f%%)", PlayerName(playerid), playerid, tmpH);
	    AdminNotice(string);
	    SetPlayerHealth(playerid, 100);
	    return 1;
	}
}

function:SendMSG()
{
	for(new k; k < sizeof(Seeds); k++)
	{
	    if(Seeds[k][sGrams] >= 12)
	    {
	        SendClientMessage(PlayerID(Seeds[k][sOwner]), COLOR_RED, "One of your seeds has died!");
	        ResetSeed(k);
	        return 1;
	    }
	    if(strcmp(Seeds[k][sOwner], "NoBodY")) Seeds[k][sGrams] += minrand(1,3);
	}
	return 1;
}

function:AdvertisementCenter()
{
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `Advertisements` WHERE `Active` = 1 ORDER BY `ID` ASC LIMIT 1");
	mysql_tquery(MySQLPipeline, iQuery, "RecieveAdvertisement", "d", 1);
	return 1;
}

function:CancelAdvertisement(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		new iGet[25], iQuery[228], iPrice, sqlID;
		cache_get_field_content(0, "ID", iGet, MySQLPipeline); sqlID = strval(iGet);
		cache_get_field_content(0, "Price", iGet, MySQLPipeline); iPrice = strval(iGet);
		
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `Advertisements` SET `Active` = 0 WHERE `ID` = %d", sqlID);
		mysql_tquery(MySQLPipeline, iQuery);
		
		new iTakeOff = minrand(1,10);
		iPrice = (iPrice / 100) * iTakeOff;
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "Your advertisement has been pulled from the que. You've been charged: {D13F3F}-$%s (%d%%) {CCCCCC}for time wasting.", number_format(iPrice), iTakeOff);
		SendClientMessage(playerid, COLOR_LIGHTGREY, iFormat);
		GivePlayerMoneyEx(playerid, -iPrice);
	}
	else return SendClientError(playerid, "You don't have an active advertisement at the minute.");
	return 1;
}

function:RecieveAdvertisement(printit)
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		new iQuery[228], iGet[128],  pName[MAX_PLAYER_NAME], pNumber, pMessage[96], pPrice, adType;
		new sqlID;
		cache_get_field_content(0, "ID", iGet, MySQLPipeline); sqlID = strval(iGet);
		cache_get_field_content(0, "PlayerName", iGet, MySQLPipeline); myStrcpy(pName, iGet);
		cache_get_field_content(0, "Message", iGet, MySQLPipeline); myStrcpy(pMessage, iGet);
		cache_get_field_content(0, "Price", iGet, MySQLPipeline); pPrice = strval(iGet);
		cache_get_field_content(0, "PhoneNumber", iGet, MySQLPipeline); pNumber = strval(iGet);
		cache_get_field_content(0, "Type", iGet, MySQLPipeline); adType = strval(iGet);
		new playerid = GetPlayerId(pName);
		new iCount;
		BusinessLoop(b)
		{
			if(BusinessInfo[b][bActive] != true) continue;
			if(BusinessInfo[b][bType] == BUSINESS_TYPE_ADTOWER) iCount++;
		}
		BusinessLoop(b)
		{
			if(BusinessInfo[b][bActive] != true) continue;
			if(BusinessInfo[b][bType] == BUSINESS_TYPE_ADTOWER)
			{
				BusinessInfo[b][bTill] += pPrice / iCount; // every ad tower get's a taste :P
			}
		}
		new adstr[148];
		if(adType == 1)
		{
			format(adstr, sizeof(adstr), "[Advertisement] %s - Contact: %s - Phone: %d", pMessage, NoUnderscore(pName), pNumber);
			SendClientMessageToAll(COLOR_PLAYER_GREEN, adstr);
			
			format( adstr, sizeof(adstr), "~g~%s (%d): %s", NoUnderscore(pName), pNumber, pMessage);
			TextDrawSetString(TextDraw__News, adstr);
		}
		else
		{
			format(adstr, sizeof(adstr), "[Company Advertisement] %s", pMessage);
			SendClientMessageToAll(COLOR_PLAYER_GREEN, adstr);
			
			format( adstr, sizeof(adstr), "~g~Company Advertisement: %s", pMessage);
			TextDrawSetString(TextDraw__News, adstr);
		}
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `Advertisements` SET `Active` = 0 WHERE `ID` = %d LIMIT 1", sqlID);
		mysql_tquery(MySQLPipeline, iQuery);
		if(IsPlayerConnected(playerid))
		{
			PlayerTemp[playerid][sm] -= pPrice;
			SendClientMSG(playerid, COLOR_LIGHTGREY, " Advertisement displayed. {D13F3F}Price: -$%s!", number_format(pPrice));
		}
		else
		{
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Money` = `Money` - %d WHERE `PlayerName` = '%e' LIMIT 1", pPrice, pName);
			mysql_pquery(MySQLPipeline, iQuery);
		}
	}
	return 1;
}

function:Unfreeze(plr)
{
	TogglePlayerControllable(plr, true);
}

function:TeleportCheckEx(playerid)
{
	PlayerTemp[playerid][tp] = 0;
}

function:GMX()
{
	gTick__GMX = now();
	GameTextForAll("~r~"SERVER_GM"~n~~w~Restarting", 7000, 0);
	PlayerLoop(i)
	{
		SaveAccount(i);
		TogglePlayerControllable(i, false);
		SetPlayerCameraPos(i,-1246.8982,596.8187,-86.3465);
		SetPlayerCameraLookAt(i,-1246.8982,596.8187,-92.1075);
	}
	return 1;
}

function:RespawnAll()
{
    VehicleLoop(v)
	{
	    if(VehicleInfo[v][vActive] != true) continue;
//	    if(VehicleInfo[v][vSpawned] != true) continue;
		if(IsVehicleOccupied(GetCarID(v))) continue;
		if(GetVehicleModel(GetCarID(v)) == 435 && !CanTrailerBeRespawned(GetCarID(v))) continue;
		SetVehicleToRespawn(GetCarID(v));
	}
    SendClientMessageToAll(COLOR_HELPEROOC, "(( INFO: All unoccupied vehicles have been respawned. ))");
}

function:KillTellTD()
{
    TextDrawHideForAll(TellTD);
    TellTDActive = 0;
}

function:_driverlic(playerid)
{
	SetPlayerPos(playerid, 1093.3793,1468.8783,5.8481);
	SetPlayerFacingAngle(playerid, 268.6938);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, false);
	ApplyAnimation(playerid,"ped","SEAT_idle", 4.1, 1, 0, 0, 1, 1); // Seat
	ApplyAnimation(playerid,"ped","SEAT_idle", 4.1, 1, 0, 0, 1, 1); // Seat
	ApplyAnimation(playerid,"ped","SEAT_idle", 4.1, 1, 0, 0, 1, 1); // Seat
	SetPVarInt(playerid, "DriverLic", GetPVarInt(playerid, "DriverLic") +1);
	new str[164];
	format(str, 164, "~g~please wait 60 seconds:~n~~n~~w~%02d seconds", GetPVarInt(playerid, "DriverLic"));
	GameTextForPlayer(playerid, str, 5000, 4);
	ShowInfoBox(playerid, "Drivers License", "you are now taking the 1minute test for the driving license. please remain seated and have some patience.");
	if(GetPVarInt(playerid, "DriverLic") >= 60)
	{
		SendClientMSG(playerid, COLOR_HELPEROOC, "[License] {BEBABA}%s you have successfully recieved your drivers license, land vehicles are now ownable.");
	    GivePlayerMoneyEx(playerid,-7500);
	    TogglePlayerControllable(playerid, true);
		DeletePVar(playerid, "IsMakingDriverLic");
		PlayerInfo[playerid][driverlic] = 1;
 		GameTextForPlayer(playerid, "~g~license received", 5000, 4);
	    KillTimer(PlayerTemp[playerid][lictimer]);
	}
	return 1;
}

function:ResetMolotov(iPlayer)
{
	DeletePVar(iPlayer, "MolotovMessage");
}

function:Explosion(Float:x, Float:y, Float:z, type, Float:radiuz)
{
    CreateExplosion(x,y,z,type,radiuz);
}

function:HideInfoBox(playerid)
{
	TextDrawHideForPlayer(playerid,PlayerTemp[playerid][InfoBox]);
	TextDrawHideForPlayer(playerid,PlayerTemp[playerid][InfoBoxTitle]);
}

function:AddToStock(n1,n2,n3,n4)
{
	dini_IntSet(compsfile,"whguns",dini_Int(compsfile, "whguns")+n1);
	dini_IntSet(compsfile,"whcars",dini_Int(compsfile, "whcars")+n2);
	dini_IntSet(compsfile,"whstuffs",dini_Int(compsfile, "whalchool")+n3);
	dini_IntSet(compsfile,"whalchool",dini_Int(compsfile, "whstuffs")+n4);
}

function:RemoveFromQuarry(_amount,_wat)
{
	new lolwat[10];
	if(_wat == 0) myStrcpy(lolwat,"stuffs");
	if(_wat == 1) myStrcpy(lolwat,"guns");
	if(_wat == 3) myStrcpy(lolwat,"cars");
	if(_wat == 2) myStrcpy(lolwat,"alchool");
	dini_IntSet(compsfile, lolwat, dini_Int(compsfile, lolwat)-_amount);
}

function:BugTimeOut(playerid)
{
	PlayerTemp[playerid][PlayerUsingBug] = 0;
}

function:KillTDWarning(playerid)
{
	TextDrawHideForPlayer(playerid, PlayerTemp[playerid][plrwarning]);
}

function:SafeWarDrobeLimit(playerid)
{
	DeletePVar(playerid, "WarDrobeDialog");
}

function:HideRedScreen(playerid)
{
	TextDrawHideForPlayer(playerid, InjuredTD);
	PlayerTemp[playerid][HasRedScreen] = 0;
}

function:TakeOverTurf( turfID, playerid, factionID )
{
	if(	!IsPlayerInTurf(playerid, turfID) || PlayersAroundSameFaction(playerid) < 7)
	{
		SendClientMessageToTeam(factionID,"# [Info] Turf Take Over failed. One or more members are too far away.",COLOR_PLAYER_VLIGHTBLUE);
		KillTimer(TurfTakeOver[ turfID ][ TIMER ]);
		GangZoneStopFlashForAll(Gangzones[turfID][gID]), Gangzones[turfID][gBLINK] = 0;
		return 1;
	}
    if(TurfTakeOver[ turfID ][ TIME ] == 0)
	{
		if(Gangzones[turfID][gFACTION] != -1)
			SendClientMessageToTeam(Gangzones[turfID][gFACTION], "# [Turf] A faction is attempting to takeover one of your turfs!", COLOR_PLAYER_VLIGHTBLUE);
		SendClientMessageToTeam(factionID,"# [Turf] Attempting to take over a turf. Do not leave the area for 4 minutes.",COLOR_PLAYER_VLIGHTBLUE);
	}
    TurfTakeOver[ turfID ][ TIME ] += 10;
    if(TurfTakeOver[ turfID ][ TIME ] == 60) SendClientMessageToTeam(factionID,"# [Turf] 3 minutes left until you have full control over the new turf.",COLOR_PLAYER_VLIGHTBLUE);
    if(TurfTakeOver[ turfID ][ TIME ] == 120) SendClientMessageToTeam(factionID,"# [Turf] 2 minutes left until you have full control over the new turf.",COLOR_PLAYER_VLIGHTBLUE);
    if(TurfTakeOver[ turfID ][ TIME ] == 180) SendClientMessageToTeam(factionID,"# [Turf] 1 minute left until you have full control over the new turf.",COLOR_PLAYER_VLIGHTBLUE);
	if(TurfTakeOver[ turfID ][ TIME ] >= 240)
    {
        SendClientMessageToTeam(factionID,"# [Info] Your faction has acquired control over a new turf!",COLOR_PLAYER_VLIGHTBLUE);
		KillTimer(TurfTakeOver[ turfID ][ TIMER ]);
		TurfTakeOver[ turfID ][ TIME ] = 0;
		GangZoneStopFlashForAll(Gangzones[turfID][gID]), Gangzones[turfID][gBLINK] = 0;
		new iQuery[228];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `Gangzones` SET `Faction` = '%d' WHERE `ID` = '%d' LIMIT 1", factionID, turfID);
		mysql_tquery(MySQLPipeline, iQuery);
		DestroyGangZones(turfID);
		LoadGangZones(turfID);
		GiveFPoints(playerid, 15);
		return 1;
    }
    return 1;
}

/*******************************************************************************************************************************
	[Teleport System]
*******************************************************************************************************************************/
function:OnLoadTeleports(fromstart)
{
	if(fromstart == 1) TeleportLoop(t) TeleportInfo[t][tpActive] = false;
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		for(new row = 0; row < rows; row++)
		{
			new iGet[128];
			new teleportid = cache_get_field_content_int(row, "ID", MySQLPipeline);
			cache_get_field_content(row, "Name", iGet, MySQLPipeline); myStrcpy(TeleportInfo[teleportid][tpName], iGet);
			cache_get_field_content(row, "X", iGet, MySQLPipeline); TeleportInfo[teleportid][tpX] = floatstr(iGet);
			cache_get_field_content(row, "Y", iGet, MySQLPipeline); TeleportInfo[teleportid][tpY] = floatstr(iGet);
			cache_get_field_content(row, "Z", iGet, MySQLPipeline); TeleportInfo[teleportid][tpZ] = floatstr(iGet);
			cache_get_field_content(row, "A", iGet, MySQLPipeline); TeleportInfo[teleportid][tpA] = floatstr(iGet);
			cache_get_field_content(row, "Interior", iGet, MySQLPipeline); TeleportInfo[teleportid][tpInt] = strval(iGet);
			cache_get_field_content(row, "VirtualWorld", iGet, MySQLPipeline); TeleportInfo[teleportid][tpVW] = strval(iGet);
			cache_get_field_content(row, "intX", iGet, MySQLPipeline); TeleportInfo[teleportid][tpiX] = floatstr(iGet);
			cache_get_field_content(row, "intY", iGet, MySQLPipeline); TeleportInfo[teleportid][tpiY] = floatstr(iGet);
			cache_get_field_content(row, "intZ", iGet, MySQLPipeline); TeleportInfo[teleportid][tpiZ] = floatstr(iGet);
			cache_get_field_content(row, "intA", iGet, MySQLPipeline); TeleportInfo[teleportid][tpiA] = floatstr(iGet);
			cache_get_field_content(row, "intInterior", iGet, MySQLPipeline); TeleportInfo[teleportid][tpiInt] = strval(iGet);
			cache_get_field_content(row, "intVirtualWorld", iGet, MySQLPipeline); TeleportInfo[teleportid][tpiVW] = strval(iGet);
			cache_get_field_content(row, "HouseID", iGet, MySQLPipeline); TeleportInfo[teleportid][tpHouseID] = strval(iGet);
			cache_get_field_content(row, "intHouseID", iGet, MySQLPipeline); TeleportInfo[teleportid][tpHouseIID] = strval(iGet);
			TeleportInfo[teleportid][tpActive] = true;
			DestroyDynamic3DTextLabel(TeleportInfo[teleportid][tpLabel]);
			new iFormat[256];
			format(iFormat, sizeof(iFormat), "{808080}%s\n{FFFFFF}TeleportID: %d", TeleportInfo[teleportid][tpName], teleportid);
			TeleportInfo[teleportid][tpLabel] = CreateDynamic3DTextLabel(iFormat, COLOR_WHITE, TeleportInfo[teleportid][tpX], TeleportInfo[teleportid][tpY], TeleportInfo[teleportid][tpZ]+0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, TeleportInfo[teleportid][tpVW], TeleportInfo[teleportid][tpInt]); 
		}
	}
}

function:OnLoadGangZones()
{
	new rows, fields;
	cache_get_data(rows, fields, MySQLPipeline);
	if(rows)
	{
		LOOP:row(0, rows)
		{
			new iGet[132];
			new gangzoneid = cache_get_field_content_int(row, "ID", MySQLPipeline);
			cache_get_field_content(row, "Faction", iGet, MySQLPipeline); Gangzones[gangzoneid][gFACTION] = strval(iGet);
			cache_get_field_content(row, "Colour", iGet, MySQLPipeline); Gangzones[gangzoneid][gCOLOUR] = strval(iGet);
			cache_get_field_content(row, "minX", iGet, MySQLPipeline); Gangzones[gangzoneid][minX] = floatstr(iGet);
			cache_get_field_content(row, "minY", iGet, MySQLPipeline); Gangzones[gangzoneid][minY] = floatstr(iGet);
			cache_get_field_content(row, "maxX", iGet, MySQLPipeline); Gangzones[gangzoneid][maxX] = floatstr(iGet);
			cache_get_field_content(row, "maxY", iGet, MySQLPipeline); Gangzones[gangzoneid][maxY] = floatstr(iGet);
			
			Gangzones[gangzoneid][gID] = GangZoneCreate(Gangzones[gangzoneid][minX], Gangzones[gangzoneid][minY], Gangzones[gangzoneid][maxX], Gangzones[gangzoneid][maxY]);
			new tmp[ 128 ];
			if(Gangzones[gangzoneid][gFACTION] == -1) format(tmp, sizeof(tmp),"", Gangzones[gangzoneid][gID]);
			else format(tmp, sizeof(tmp),"%s Turf", FactionInfo[Gangzones[gangzoneid][gFACTION]][fName]);

			Gangzones[gangzoneid][gDRAW] = TextDrawCreate(500.000000, 9.000000, tmp);
			TextDrawAlignment(Gangzones[gangzoneid][gDRAW], 1);
			TextDrawBackgroundColor(Gangzones[gangzoneid][gDRAW], 255);
			TextDrawFont(Gangzones[gangzoneid][gDRAW], 1);
			TextDrawLetterSize(Gangzones[gangzoneid][gDRAW], 0.180000, 1.000000);
			TextDrawColor(Gangzones[gangzoneid][gDRAW],-1);
			TextDrawSetOutline(Gangzones[gangzoneid][gDRAW],1);
			TextDrawSetProportional(Gangzones[gangzoneid][gDRAW],1);
		}
	}
}

function:RemoveUP(playerid)
{
	DeletePVar(playerid, "CurrentUP");
}

function:RouletteTimer(playerid)
{
	new rouletteID = minrand(0, sizeof(RouletteHands));
	new iFormat[128];
	if(!strcmp(RouletteHands[rouletteID][RCard], "Black"))
	{
		format(iFormat, sizeof(iFormat), "** The wheel lands on %d (%s) ** (( %s ))", RouletteHands[rouletteID][RNumber], RouletteHands[rouletteID][RCard], MaskedName(playerid));
		NearMessage(playerid, iFormat, 0x282828FF);
	}
	else if(!strcmp(RouletteHands[rouletteID][RCard], "Red"))
	{
		format(iFormat, sizeof(iFormat), "** The wheel lands on %d (%s) ** (( %s ))", RouletteHands[rouletteID][RNumber], RouletteHands[rouletteID][RCard], MaskedName(playerid));
		NearMessage(playerid, iFormat, 0xFF1A1AFF);
	}
	else
	{
		format(iFormat, sizeof(iFormat), "** The wheel lands on %d (%s) ** (( %s ))", RouletteHands[rouletteID][RNumber], RouletteHands[rouletteID][RCard], MaskedName(playerid));
		NearMessage(playerid, iFormat, COLOR_GREEN);
	}
}
function:TracingNumber(playerid, targetID)
{
	if(IsPlayerInAnyInterior(targetID) || PlayerTemp[targetID][phoneoff] != 0 || IsPlayerConnected(targetID))
	{
		SendClientWarning(playerid, "Tracing failed.");
		return 1;
	}
	new Float:xx,Float:yy,Float:zz;
	GetPlayerPos(targetID,xx,yy,zz);
	SetPlayerCheckpoint(playerid, xx+minrand(1,10),yy+minrand(1,10),zz,3.0);
	SetTimerEx("TracingNumber", 1000, false, "dd", playerid, targetID);
	return 1;
}
function:TruckerCancelCargo(playerid) {
	if(GetPVarInt(playerid, "DeliveringCargo") != 1) {
		DeletePVar(playerid, "CargoLoad");
		DeletePVar(playerid, "PCargo");
		DeletePVar(playerid, "DeliveringCargo");
		DisablePlayerCheckpoint(playerid);
		SendClientError(playerid, "You failed to load the cargo in time, the job has been cancelled.");
	}
	return 1;
}
function:SetTruckingTrailerToVehicle(carid, trailerid) {
	AttachTrailerToVehicle(carid, GetCarID(trailerid));
	myStrcpy(VehicleInfo[trailerid][vJob], "TruckingTrailer");
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `VehicleInfo` SET `Job` = '%e' WHERE `ID` = %d", VehicleInfo[trailerid][vJob], trailerid);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}