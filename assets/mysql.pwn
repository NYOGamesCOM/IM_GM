/*********************************************************************************************************************************************
						- NYOGames [mysql.pwn file]
*********************************************************************************************************************************************/
function:OnDatabaseQuery(dataThreadType, dataThreadID, extra[])
{
	new handleid = mysql_current_handle(), MySQLThreadName[25], ErrorDetails[25], ThreadDetails[128];
	if(mysql_errno(handleid) != 0) myStrcpy(ErrorDetails, "Failed Query");
	else myStrcpy(ErrorDetails, "Success");
	if(handleid == MySQLPipeline)
	{
		new fields, rows;
		cache_get_data(rows, fields, MySQLPipeline);
		switch(dataThreadType)
		{
			case DATA_THREAD_SENDDATA:
			{
				switch(dataThreadID)
				{

				}
			}
			case DATA_THREAD_RETRIEVEDATA:
			{
				switch(dataThreadID)
				{
					case THREAD_LOAD_ATMS:
					{
						new fromstart = strval(extra);
						if(fromstart == 1)
						{
						    ATMLoop(i) ATMInfo[i][atmActive] = false;
						}
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[50];
						    	cache_get_field_content(row2, "ID", iGet, MySQLPipeline); new atmid = strval(iGet);
						    	cache_get_field_content(row2, "X", iGet, MySQLPipeline); ATMInfo[atmid][atmX] = floatstr(iGet);
						    	cache_get_field_content(row2, "Y", iGet, MySQLPipeline); ATMInfo[atmid][atmY] = floatstr(iGet);
						    	cache_get_field_content(row2, "Z", iGet, MySQLPipeline); ATMInfo[atmid][atmZ] = floatstr(iGet);
						    	cache_get_field_content(row2, "rotX", iGet, MySQLPipeline); ATMInfo[atmid][atmrotX] = floatstr(iGet);
						    	cache_get_field_content(row2, "rotY", iGet, MySQLPipeline); ATMInfo[atmid][atmrotY] = floatstr(iGet);
						    	cache_get_field_content(row2, "rotZ", iGet, MySQLPipeline); ATMInfo[atmid][atmrotZ] = floatstr(iGet);
						    	cache_get_field_content(row2, "Interior", iGet, MySQLPipeline); ATMInfo[atmid][atmInterior] = strval(iGet);
						    	cache_get_field_content(row2, "VirtualWorld", iGet, MySQLPipeline); ATMInfo[atmid][atmVirtualWorld] = strval(iGet);
							   	ATMInfo[atmid][atmActive] = true;
								DestroyDynamicObject(ATMInfo[atmid][atmObject]);
					    		DestroyDynamic3DTextLabel(ATMInfo[atmid][atmLabel]);
						        ATMInfo[atmid][atmObject] = CreateDynamicObject(2942, ATMInfo[atmid][atmX], ATMInfo[atmid][atmY], ATMInfo[atmid][atmZ], ATMInfo[atmid][atmrotX], ATMInfo[atmid][atmrotY], ATMInfo[atmid][atmrotZ], ATMInfo[atmid][atmVirtualWorld], ATMInfo[atmid][atmInterior]);
						        ATMInfo[atmid][atmLabel] = CreateDynamic3DTextLabel("{ffffff}[ {c5cc02}ATM Machine {ffffff}]\n{c5cc02}Commands: {ffffff}/deposit /withdraw /balance", COLOR_WHITE, ATMInfo[atmid][atmX], ATMInfo[atmid][atmY], ATMInfo[atmid][atmZ]+0.2, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATMInfo[atmid][atmVirtualWorld], ATMInfo[atmid][atmInterior]);
							}
						}
						myStrcpy(MySQLThreadName, "OnLoadATMS");
					}
					case THREAD_LOAD_HOUSES:
					{
						new fromstart = strval(extra);
						if(fromstart == 1)
						{
							HouseLoop(i) HouseInfo[i][hActive] = false;
						}
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[75];
								cache_get_field_content(row2, "ID", iGet, MySQLPipeline); new houseid = strval(iGet);
						        cache_get_field_content(row2, "Owner", iGet, MySQLPipeline); myStrcpy(HouseInfo[houseid][hOwner], iGet);
						        cache_get_field_content(row2, "Weapons", iGet, MySQLPipeline);
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
																	
						        cache_get_field_content(row2, "Ammo", iGet, MySQLPipeline);
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
																	
								cache_get_field_content(row2, "Buyable", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hBuyable] = true; else HouseInfo[houseid][hBuyable] = false;
								cache_get_field_content(row2, "Rentable", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hRentable] = true; else HouseInfo[houseid][hRentable] = false;
								cache_get_field_content(row2, "Closed", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hClosed] = true; else HouseInfo[houseid][hClosed] = false;
								cache_get_field_content(row2, "HouseLocker", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hLocker] = true; else HouseInfo[houseid][hLocker] = false;
								
								cache_get_field_content(row2, "Sellprice", iGet, MySQLPipeline); HouseInfo[houseid][hSellprice] = strval(iGet);
								cache_get_field_content(row2, "Rentprice", iGet, MySQLPipeline); HouseInfo[houseid][hRentprice] = strval(iGet);
								cache_get_field_content(row2, "Level", iGet, MySQLPipeline); HouseInfo[houseid][hLevel] = strval(iGet);
								cache_get_field_content(row2, "Cash", iGet, MySQLPipeline); HouseInfo[houseid][hCash] = strval(iGet);
								cache_get_field_content(row2, "Till", iGet, MySQLPipeline); HouseInfo[houseid][hTill] = strval(iGet);
								cache_get_field_content(row2, "SGuns", iGet, MySQLPipeline); HouseInfo[houseid][hSGuns] = strval(iGet);
								cache_get_field_content(row2, "SDrugs", iGet, MySQLPipeline); HouseInfo[houseid][hSDrugs] = strval(iGet);
								cache_get_field_content(row2, "InteriorPack", iGet, MySQLPipeline); HouseInfo[houseid][hInteriorPack] = strval(iGet);
								cache_get_field_content(row2, "Alarm", iGet, MySQLPipeline); HouseInfo[houseid][hAlarm] = strval(iGet);
								cache_get_field_content(row2, "Wardrobe", iGet, MySQLPipeline); HouseInfo[houseid][hWardrobe] = strval(iGet);
								cache_get_field_content(row2, "Armour", iGet, MySQLPipeline); HouseInfo[houseid][hArmour] = strval(iGet);
								cache_get_field_content(row2, "X", iGet, MySQLPipeline); HouseInfo[houseid][hX] = floatstr(iGet);
								cache_get_field_content(row2, "Y", iGet, MySQLPipeline); HouseInfo[houseid][hY] = floatstr(iGet);
								cache_get_field_content(row2, "Z", iGet, MySQLPipeline); HouseInfo[houseid][hZ] = floatstr(iGet);
								cache_get_field_content(row2, "Interior", iGet, MySQLPipeline); HouseInfo[houseid][hInterior] = strval(iGet);
								cache_get_field_content(row2, "VirtualWorld", iGet, MySQLPipeline); HouseInfo[houseid][hVirtualWorld] = strval(iGet);
								for(new hiss = 0; hiss < 5; hiss++)
								{
									new iStrrrr[13];
									format(iStrrrr, sizeof(iStrrrr), "Skin-Slot-%d", hiss);
									cache_get_field_content(row2, iStrrrr, iGet, MySQLPipeline); HouseInfo[houseid][hSkins][hiss] = strval(iGet);
								}
								cache_get_field_content(row2, "GarageX", iGet, MySQLPipeline); HouseInfo[houseid][hGarageX] = floatstr(iGet);
								cache_get_field_content(row2, "GarageY", iGet, MySQLPipeline); HouseInfo[houseid][hGarageY] = floatstr(iGet);
								cache_get_field_content(row2, "GarageZ", iGet, MySQLPipeline); HouseInfo[houseid][hGarageZ] = floatstr(iGet);
								cache_get_field_content(row2, "GarageA", iGet, MySQLPipeline); HouseInfo[houseid][hGarageA] = floatstr(iGet);
								cache_get_field_content(row2, "GarageInterior", iGet, MySQLPipeline); HouseInfo[houseid][hGarageInt] = strval(iGet);
								cache_get_field_content(row2, "GarageVirtualWorld", iGet, MySQLPipeline); HouseInfo[houseid][hGarageVW] = strval(iGet);
								cache_get_field_content(row2, "GInteriorPack", iGet, MySQLPipeline); HouseInfo[houseid][hGarageInteriorPack] = strval(iGet);
								cache_get_field_content(row2, "GarageOpen", iGet, MySQLPipeline); if(strval(iGet) == 1) HouseInfo[houseid][hGarageOpen] = true; else HouseInfo[houseid][hGarageOpen] = false;
						        HouseInfo[houseid][hActive] = true;
								if(!dini_Exists(HouseTextureDirectory(houseid))) dini_Create(HouseTextureDirectory(houseid));
						        UpdateHouse(houseid);

							}
						}
						HouseLoop(h)
						{
							if(HouseInfo[h][hActive] != true && dini_Exists(HouseTextureDirectory(h))) // isn't created, so let's remove the house base textures
								dini_Remove(HouseTextureDirectory(h));
						}
						myStrcpy(MySQLThreadName, "OnLoadHouses");
					}
					case THREAD_LOAD_FURNITURE:
					{
						new fromstart = strval(extra);
						if(fromstart == 1)
						{
							HouseLoop(h)
							{
								FurnitureLoop(f)
								{
									FurnitureInfo[h][f][furActive] = false;
								}
							}
						}
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[50], houseid, slotid;
								cache_get_field_content(row2, "House", iGet, MySQLPipeline); houseid = strval(iGet);
								cache_get_field_content(row2, "Slot", iGet, MySQLPipeline); slotid = strval(iGet);
								cache_get_field_content(row2, "Name", iGet, MySQLPipeline); myStrcpy(FurnitureInfo[houseid][slotid][furName], iGet);
								cache_get_field_content(row2, "Model", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furModel] = strval(iGet);
								cache_get_field_content(row2, "X", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furX] = floatstr(iGet);
								cache_get_field_content(row2, "Y", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furY] = floatstr(iGet);
								cache_get_field_content(row2, "Z", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furZ] = floatstr(iGet);
								cache_get_field_content(row2, "rX", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrX] = floatstr(iGet);
								cache_get_field_content(row2, "rY", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrY] = floatstr(iGet);
								cache_get_field_content(row2, "rZ", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrZ] = floatstr(iGet);
								cache_get_field_content(row2, "rZ", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furrZ] = floatstr(iGet);
								cache_get_field_content(row2, "MaterialSlot1", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][0] = strval(iGet);
								cache_get_field_content(row2, "MaterialSlot2", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][1] = strval(iGet);
								cache_get_field_content(row2, "MaterialSlot3", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][2] = strval(iGet);
								cache_get_field_content(row2, "MaterialSlot4", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][3] = strval(iGet);
								cache_get_field_content(row2, "MaterialSlot5", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterial][4] = strval(iGet);
								cache_get_field_content(row2, "ColourMaterial1", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][0] = strval(iGet);
								cache_get_field_content(row2, "ColourMaterial2", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][1] = strval(iGet);
								cache_get_field_content(row2, "ColourMaterial3", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][2] = strval(iGet);
								cache_get_field_content(row2, "ColourMaterial4", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][3] = strval(iGet);
								cache_get_field_content(row2, "ColourMaterial5", iGet, MySQLPipeline); FurnitureInfo[houseid][slotid][furMaterialColour][4] = strval(iGet);
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
						myStrcpy(MySQLThreadName, "OnLoadFurniture");
					}
					case THREAD_LOAD_BUSINESSES:
					{
						new fromstart = strval(extra);
						if(fromsrart == 1)
						{
							BusinessLoop(b) BusinessInfo[b][bActive] = false;
						}
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[150];
								cache_get_field_content(row2, "ID", iGet, MySQLPipeline); new bizID = strval(iGet);
								cache_get_field_content(row2, "Type", iGet, MySQLPipeline); BusinessInfo[bizID][bType] = strval(iGet);
								cache_get_field_content(row2, "X", iGet, MySQLPipeline); BusinessInfo[bizID][bX] = floatstr(iGet);
								cache_get_field_content(row2, "Y", iGet, MySQLPipeline); BusinessInfo[bizID][bY] = floatstr(iGet);
								cache_get_field_content(row2, "Z", iGet, MySQLPipeline); BusinessInfo[bizID][bZ] = floatstr(iGet);
								cache_get_field_content(row2, "VirtualWorld", iGet, MySQLPipeline); BusinessInfo[bizID][bVirtualWorld] = strval(iGet);
								cache_get_field_content(row2, "Interior", iGet, MySQLPipeline); BusinessInfo[bizID][bInterior] = strval(iGet);
								cache_get_field_content(row2, "InteriorPack", iGet, MySQLPipeline); BusinessInfo[bizID][bInteriorPack] = strval(iGet);
								cache_get_field_content(row2, "CompsFlag", iGet, MySQLPipeline); BusinessInfo[bizID][bCompsFlag] = strval(iGet);
								cache_get_field_content(row2, "Tax", iGet, MySQLPipeline); BusinessInfo[bizID][bTax] = strval(iGet);
								cache_get_field_content(row2, "LastRob", iGet, MySQLPipeline); BusinessInfo[bizID][bLastRob] = strval(iGet);
								cache_get_field_content(row2, "Level", iGet, MySQLPipeline); BusinessInfo[bizID][bLevel] = strval(iGet);
								cache_get_field_content(row2, "Sellprice", iGet, MySQLPipeline); BusinessInfo[bizID][bSellprice] = strval(iGet);
								cache_get_field_content(row2, "Restock", iGet, MySQLPipeline); BusinessInfo[bizID][bRestock] = strval(iGet);
								cache_get_field_content(row2, "RentPrice", iGet, MySQLPipeline); BusinessInfo[bizID][bRentPrice] = strval(iGet);
								cache_get_field_content(row2, "Till", iGet, MySQLPipeline); BusinessInfo[bizID][bTill] = strval(iGet);
								cache_get_field_content(row2, "Locked", iGet, MySQLPipeline); if(strval(iGet) == 1) BusinessInfo[bizID][bLocked] = true; else BusinessInfo[bizID][bLocked] = false;
								cache_get_field_content(row2, "Comps", iGet, MySQLPipeline); BusinessInfo[bizID][bComps] = strval(iGet);
								cache_get_field_content(row2, "Fee", iGet, MySQLPipeline); BusinessInfo[bizID][bFee] = strval(iGet);
								cache_get_field_content(row2, "Deagle", iGet, MySQLPipeline); BusinessInfo[bizID][bDeagle] = strval(iGet);
								cache_get_field_content(row2, "MP5", iGet, MySQLPipeline); BusinessInfo[bizID][bMP5] = strval(iGet);
								cache_get_field_content(row2, "M4", iGet, MySQLPipeline); BusinessInfo[bizID][bM4] = strval(iGet);
								cache_get_field_content(row2, "Shotgun", iGet, MySQLPipeline); BusinessInfo[bizID][bShotgun] = strval(iGet);
								cache_get_field_content(row2, "Rifle", iGet, MySQLPipeline); BusinessInfo[bizID][bRifle] = strval(iGet);
								cache_get_field_content(row2, "Sniper", iGet, MySQLPipeline); BusinessInfo[bizID][bSniper] = strval(iGet);
								cache_get_field_content(row2, "Armour", iGet, MySQLPipeline); BusinessInfo[bizID][bArmour] = strval(iGet);
								cache_get_field_content(row2, "AskComps", iGet, MySQLPipeline); BusinessInfo[bizID][bAskComps] = strval(iGet);
								cache_get_field_content(row2, "Buyable", iGet, MySQLPipeline); BusinessInfo[bizID][bBuyable] = strval(iGet);
							    cache_get_field_content(row2, "Owner", iGet, MySQLPipeline); myStrcpy(BusinessInfo[bizID][bOwner], iGet);
							    cache_get_field_content(row2, "Dupekey", iGet, MySQLPipeline); myStrcpy(BusinessInfo[bizID][bDupekey], iGet);
							    cache_get_field_content(row2, "Name", iGet, MySQLPipeline); myStrcpy(BusinessInfo[bizID][bName], iGet);
							    BusinessInfo[bizID][bActive] = true;
								UpdateBiz(bizID, 0);
							}
						}
						myStrcpy(MySQLThreadName, "OnLoadBusinesses");
					}
					case THREAD_LOAD_FACTIONS:
					{
						new fromstart = strval(extra);
						if(fromstart == 1)
						{
							FactionLoop(f) FactionInfo[f][fActive] = false;
						}
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[128];
								cache_get_field_content(row2, "ID", iGet, MySQLPipeline); new fid = strval(iGet);
								cache_get_field_content(row2, "FactionName", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fName], iGet);
								cache_get_field_content(row2, "Colour", iGet, MySQLPipeline); FactionInfo[fid][fColour] = strval(iGet);
								cache_get_field_content(row2, "GangZoneColour", iGet, MySQLPipeline); FactionInfo[fid][fGangZoneColour] = strval(iGet);
								cache_get_field_content(row2, "Startrank", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fStartrank], iGet);
								cache_get_field_content(row2, "Leader", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fLeader], iGet);
								cache_get_field_content(row2, "MOTD", iGet, MySQLPipeline); myStrcpy(FactionInfo[fid][fMOTD], iGet);
								cache_get_field_content(row2, "Points", iGet, MySQLPipeline); FactionInfo[fid][fPoints] = strval(iGet);
								cache_get_field_content(row2, "TogChat", iGet, MySQLPipeline); if(strval(iGet) == 1) FactionInfo[fid][fTogChat] = true; else FactionInfo[fid][fTogChat] = false;
								cache_get_field_content(row2, "TogColour", iGet, MySQLPipeline); if(strval(iGet) == 1) FactionInfo[fid][fTogColour] = true; else FactionInfo[fid][fTogColour] = false;
								cache_get_field_content(row2, "MaxVehicles", iGet, MySQLPipeline); FactionInfo[fid][fMaxVehicles] = strval(iGet);
								cache_get_field_content(row2, "MaxMembers", iGet, MySQLPipeline); FactionInfo[fid][fMaxMemberSlots] = strval(iGet);
								cache_get_field_content(row2, "Startpayment", iGet, MySQLPipeline); FactionInfo[fid][fStartpayment] = strval(iGet);
								cache_get_field_content(row2, "Bank", iGet, MySQLPipeline); FactionInfo[fid][fBank] = strval(iGet);
								cache_get_field_content(row2, "Type", iGet, MySQLPipeline); FactionInfo[fid][fType] = strval(iGet);
								cache_get_field_content(row2, "StockLevel", iGet, MySQLPipeline); FactionInfo[fid][fStockLevel] = strval(iGet);
								cache_get_field_content(row2, "Freq", iGet, MySQLPipeline); FactionInfo[fid][fFreq] = strval(iGet);
								cache_get_field_content(row2, "SDCWarehouse", iGet, MySQLPipeline); FactionInfo[fid][fSDCWarehouse] = strval(iGet);
								cache_get_field_content(row2, "SDCCompsprice", iGet, MySQLPipeline); FactionInfo[fid][fSDCCompsPrice] = strval(iGet);
								FactionInfo[fid][fActive] = true;
								PlayerLoop(p)
								{
									if(PlayerTemp[p][loggedIn] != true) continue;
									if(PlayerInfo[p][playerteam] == fid) SetPlayerTeamEx(p, fid); // just to reset colour!
								}
							}
						}
						myStrcpy(MySQLThreadName, "OnLoadFactions");
					}
					case THREAD_LOAD_WAREHOUSES:
					{
						new fromstart = strval(extra);
						if(fromstart == 1) FactionLoop(f) WareHouseInfo[f][whActive] = false;
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[75];
								cache_get_field_content(row2, "ID", iGet, MySQLPipeline); new factionID = strval(iGet);
								cache_get_field_content(row2, "X", iGet, MySQLPipeline); WareHouseInfo[factionID][whX] = floatstr(iGet);
								cache_get_field_content(row2, "Y", iGet, MySQLPipeline); WareHouseInfo[factionID][whY] = floatstr(iGet);
								cache_get_field_content(row2, "Z", iGet, MySQLPipeline); WareHouseInfo[factionID][whZ] = floatstr(iGet);
								cache_get_field_content(row2, "Interior", iGet, MySQLPipeline); WareHouseInfo[factionID][whInterior] = strval(iGet);
								cache_get_field_content(row2, "VirtualWorld", iGet, MySQLPipeline); WareHouseInfo[factionID][whVirtualWorld] = strval(iGet);
								cache_get_field_content(row2, "Open", iGet, MySQLPipeline); if(strval(iGet) == 0) WareHouseInfo[factionID][whOpen] = false; else WareHouseInfo[factionID][whOpen] = true;
								cache_get_field_content(row2, "Level", iGet, MySQLPipeline); WareHouseInfo[factionID][whLevel] = strval(iGet);
								cache_get_field_content(row2, "Materials", iGet, MySQLPipeline); WareHouseInfo[factionID][whMaterials] = strval(iGet);
								cache_get_field_content(row2, "Lead", iGet, MySQLPipeline); WareHouseInfo[factionID][whLead] = strval(iGet);
								cache_get_field_content(row2, "Metal", iGet, MySQLPipeline); WareHouseInfo[factionID][whMetal] = strval(iGet);
								cache_get_field_content(row2, "Security", iGet, MySQLPipeline); WareHouseInfo[factionID][whSecurity] = strval(iGet);
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
						myStrcpy(MySQLThreadName, "OnLoadWarehouses");
					}
					case THREAD_LOAD_HEADQUATERS:
					{
						new fromstart = strval(extra);
						if(fromstart == 1) FactionLoop(f) HQInfo[f][hqActive] = false;
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[75];
								cache_get_field_content(row2, "ID", iGet, MySQLPipeline); new factionID = strval(iGet);
								cache_get_field_content(row2, "Open", iGet, MySQLPipeline); if(strval(iGet) == 1) HQInfo[factionID][hqOpen] = true; else HQInfo[factionID][hqOpen] = false;
								cache_get_field_content(row2, "StockTog", iGet, MySQLPipeline); if(strval(iGet) == 1) HQInfo[factionID][fHQStockTog] = true; else HQInfo[factionID][fHQStockTog] = false;
								cache_get_field_content(row2, "Stock", iGet, MySQLPipeline); HQInfo[factionID][fHQStock] = strval(iGet);
								cache_get_field_content(row2, "X", iGet, MySQLPipeline); HQInfo[factionID][fHQX] = floatstr(iGet);
								cache_get_field_content(row2, "Y", iGet, MySQLPipeline); HQInfo[factionID][fHQY] = floatstr(iGet);
								cache_get_field_content(row2, "Z", iGet, MySQLPipeline); HQInfo[factionID][fHQZ] = floatstr(iGet);
								cache_get_field_content(row2, "A", iGet, MySQLPipeline); HQInfo[factionID][fHQA] = floatstr(iGet);
								cache_get_field_content(row2, "Interior", iGet, MySQLPipeline); HQInfo[factionID][fHQInt] = strval(iGet);
								cache_get_field_content(row2, "VirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][fHQVW] = strval(iGet);
								cache_get_field_content(row2, "LeaderX", iGet, MySQLPipeline); HQInfo[factionID][flSpawnX] = floatstr(iGet);
								cache_get_field_content(row2, "LeaderY", iGet, MySQLPipeline); HQInfo[factionID][flSpawnY] = floatstr(iGet);
								cache_get_field_content(row2, "LeaderZ", iGet, MySQLPipeline); HQInfo[factionID][flSpawnZ] = floatstr(iGet);
								cache_get_field_content(row2, "LeaderA", iGet, MySQLPipeline); HQInfo[factionID][flSpawnA] = floatstr(iGet);
								cache_get_field_content(row2, "LeaderInterior", iGet, MySQLPipeline); HQInfo[factionID][flSpawnInt] = strval(iGet);
								cache_get_field_content(row2, "LeaderVirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][flSpawnVW] = strval(iGet);
								cache_get_field_content(row2, "SpawnX", iGet, MySQLPipeline); HQInfo[factionID][fSpawnX] = floatstr(iGet);
								cache_get_field_content(row2, "SpawnY", iGet, MySQLPipeline); HQInfo[factionID][fSpawnY] = floatstr(iGet);
								cache_get_field_content(row2, "SpawnZ", iGet, MySQLPipeline); HQInfo[factionID][fSpawnZ] = floatstr(iGet);
								cache_get_field_content(row2, "SpawnA", iGet, MySQLPipeline); HQInfo[factionID][fSpawnA] = floatstr(iGet);
								cache_get_field_content(row2, "SpawnInterior", iGet, MySQLPipeline); HQInfo[factionID][fSpawnInt] = strval(iGet);
								cache_get_field_content(row2, "SpawnVirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][fSpawnVW] = strval(iGet);
								cache_get_field_content(row2, "RoofX", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofX] = floatstr(iGet);
								cache_get_field_content(row2, "RoofY", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofY] = floatstr(iGet);
								cache_get_field_content(row2, "RoofZ", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofZ] = floatstr(iGet);
								cache_get_field_content(row2, "RoofA", iGet, MySQLPipeline); HQInfo[factionID][fHQRoofA] = floatstr(iGet);
								cache_get_field_content(row2, "RoofInterior", iGet, MySQLPipeline); HQInfo[factionID][fHQInt] = strval(iGet);
								cache_get_field_content(row2, "RoofVirtualWorld", iGet, MySQLPipeline); HQInfo[factionID][fHQVW] = strval(iGet);
								HQInfo[factionID][hqActive] = true;
								DestroyDynamicPickup(HQInfo[factionID][hqPickup]);
								DestroyDynamic3DTextLabel(HQInfo[factionID][hqLabel]);
								HQInfo[factionID][hqPickup] = CreateDynamicPickup(1239, 1, HQInfo[factionID][fHQX], HQInfo[factionID][fHQY], HQInfo[factionID][fHQZ], HQInfo[factionID][fHQVW], HQInfo[factionID][fHQInt]);
								new iFormat[256];
								format(iFormat, sizeof(iFormat), "{808080}Headquaters\n{FFFFFF}%s", FactionInfo[factionID][fName]);
								HQInfo[factionID][hqLabel] = CreateDynamic3DTextLabel(iFormat, COLOR_WHITE, HQInfo[factionID][fHQX], HQInfo[factionID][fHQY], HQInfo[factionID][fHQZ]+0.6, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HQInfo[factionID][fHQVW], HQInfo[factionID][fHQInt]);
							}
						}
						myStrcpy(MySQLThreadName, "OnLoadHeadQuaters");
					}
					case THREAD_LOAD_VEHICLES:
					{
						new fromstart = strval(extra);
						if(fromstart == 1)
						{
							VehicleLoop(v)
							{
								VehicleInfo[v][vActive] = false;
								VehicleInfo[v][vSpawned] = false;
							}
						}
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iGet[50];
							    cache_get_field_content(row2, "ID", iGet, MySQLPipeline); new vid = strval(iGet);
								cache_get_field_content(row2, "Model", iGet, MySQLPipeline); VehicleInfo[vid][vModel] = strval(iGet);
								cache_get_field_content(row2, "X", iGet, MySQLPipeline); VehicleInfo[vid][vX] = floatstr(iGet);
								cache_get_field_content(row2, "Y", iGet, MySQLPipeline); VehicleInfo[vid][vY] = floatstr(iGet);
								cache_get_field_content(row2, "Z", iGet, MySQLPipeline); VehicleInfo[vid][vZ] = floatstr(iGet);
								cache_get_field_content(row2, "A", iGet, MySQLPipeline); VehicleInfo[vid][vA] = floatstr(iGet);
								cache_get_field_content(row2, "VirtualWorld", iGet, MySQLPipeline); VehicleInfo[vid][vVirtualWorld] = strval(iGet);
								cache_get_field_content(row2, "Colour1", iGet, MySQLPipeline); VehicleInfo[vid][vColour1] = strval(iGet);
								cache_get_field_content(row2, "Colour2", iGet, MySQLPipeline); VehicleInfo[vid][vColour2] = strval(iGet);
								cache_get_field_content(row2, "Paintjob", iGet, MySQLPipeline); VehicleInfo[vid][vPaintJob] = strval(iGet);
								cache_get_field_content(row2, "FactionID", iGet, MySQLPipeline); VehicleInfo[vid][vFaction] = strval(iGet);
								cache_get_field_content(row2, "Reserved", iGet, MySQLPipeline); VehicleInfo[vid][vReserved] = strval(iGet);
								cache_get_field_content(row2, "Business", iGet, MySQLPipeline); VehicleInfo[vid][vBusiness] = strval(iGet);
								cache_get_field_content(row2, "Sellprice", iGet, MySQLPipeline); VehicleInfo[vid][vSellPrice] = strval(iGet);
								if(VehicleInfo[vid][vSellPrice] < 0) VehicleInfo[vid][vSellPrice] = 0;
								cache_get_field_content(row2, "Fuel", iGet, MySQLPipeline); VehicleInfo[vid][vFuel] = strval(iGet);
								cache_get_field_content(row2, "Impounded", iGet, MySQLPipeline); VehicleInfo[vid][vImpounded] = strval(iGet);
								cache_get_field_content(row2, "ImpoundFee", iGet, MySQLPipeline); VehicleInfo[vid][vImpoundFee] = strval(iGet);
								cache_get_field_content(row2, "Mileage", iGet, MySQLPipeline); VehicleInfo[vid][vMileage] = floatstr(iGet);
								cache_get_field_content(row2, "Alarm", iGet, MySQLPipeline); VehicleInfo[vid][vAlarm] = strval(iGet);
								cache_get_field_content(row2, "Registered", iGet, MySQLPipeline); if(strval(iGet) == 1) VehicleInfo[vid][vRegistered] = true; else VehicleInfo[vid][vRegistered] = false;
								cache_get_field_content(row2, "Job", iGet, MySQLPipeline, MySQLPipeline); myStrcpy(VehicleInfo[vid][vJob], iGet);
								cache_get_field_content(row2, "ImpoundReason", iGet, MySQLPipeline); myStrcpy(VehicleInfo[vid][vImpoundReason], iGet);
								cache_get_field_content(row2, "Plate", iGet, MySQLPipeline); myStrcpy(VehicleInfo[vid][vPlate], iGet);
								cache_get_field_content(row2, "Owner", iGet, MySQLPipeline);myStrcpy(VehicleInfo[vid][vOwner], iGet);
								cache_get_field_content(row2, "Dupekey", iGet, MySQLPipeline);myStrcpy(VehicleInfo[vid][vDupekey], iGet);
								cache_get_field_content(row2, "Components", iGet, MySQLPipeline);
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
																	
								cache_get_field_content(row2, "Weapon", iGet, MySQLPipeline);
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
																	
								cache_get_field_content(row2, "Ammo", iGet, MySQLPipeline);
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
									VehicleInfo[vid][vSpawned] = false;
									VehicleInfo[vid][vRID] = INVALID_VEHICLE_ID;
									VehicleInfo[vid][vID] = INVALID_VEHICLE_ID;
									if(!strcmp(VehicleInfo[vid][vOwner], "NoBodY", false))
									{	
										new respawnTick = -1;
										if(VehicleInfo[vid][vReserved] == VEH_RES_NOOBIE || VehicleInfo[vid][vReserved] == VEH_RES_OCCUPA || VehicleInfo[vid][vReserved] == VEH_RES_RENT) respawnTick = 300;
										VehicleInfo[vid][vRID] = GetNextCreatedVehicleID();
										VehicleInfo[vid][vID] = CreateVehicle(VehicleInfo[vid][vModel], VehicleInfo[vid][vX], VehicleInfo[vid][vY], VehicleInfo[vid][vZ], VehicleInfo[vid][vA], VehicleInfo[vid][vColour1], VehicleInfo[vid][vColour2], respawnTick);
										VehicleInfo[vid][vSpawned] = true;
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
										VehicleInfo[vid][vSpawned] = false;
										VehicleInfo[vid][vRID] = INVALID_VEHICLE_ID;
										VehicleInfo[vid][vID] = INVALID_VEHICLE_ID;
									}
									if(!strcmp(VehicleInfo[vid][vOwner], "NoBodY", false))
									{
										new respawnTick = -1;
										if(VehicleInfo[vid][vReserved] == VEH_RES_NOOBIE || VehicleInfo[vid][vReserved] == VEH_RES_OCCUPA || VehicleInfo[vid][vReserved] == VEH_RES_RENT) respawnTick = 300;
										VehicleInfo[vid][vRID] = GetNextCreatedVehicleID();
										VehicleInfo[vid][vID] = CreateVehicle(VehicleInfo[vid][vModel], VehicleInfo[vid][vX], VehicleInfo[vid][vY], VehicleInfo[vid][vZ], VehicleInfo[vid][vA], VehicleInfo[vid][vColour1], VehicleInfo[vid][vColour2], respawnTick);
										VehicleInfo[vid][vSpawned] = true;
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
						myStrcpy(MySQLThreadName, "OnLoadVehicles");
					}
					case THREAD_LOAD_FAC_OFFLINE:
					{
						new playerid = strval(extra);
						SendClientMSG(playerid, 0x93B8B8FF, "[%s]{C9DCDC} - Offline members: ", GetPlayerFactionName(playerid));
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iMessage[128], iFormat[45], iGet[75], pName[MAX_PLAYER_NAME];
								cache_get_field_content(row2, "PlayerName", pName, MySQLPipeline);
								if(IsPlayerConnected(GetPlayerId(pName))) continue; // player is connected, skip it!

								cache_get_field_content(row2, "RankName", iGet, MySQLPipeline);
								format(iFormat, sizeof(iFormat), " - %s %s", iGet, pName); strcat(iMessage, iFormat);

								cache_get_field_content(row2, "Tier", iGet, MySQLPipeline);
								format(iFormat, sizeof(iFormat), " [Tier: %d]", strval(iGet)); strcat(iMessage, iFormat);

								cache_get_field_content(row2, "FactionPay", iGet, MySQLPipeline);
								format(iFormat, sizeof(iFormat), " [Payment: $%s]", number_format(strval(iGet))); strcat(iMessage, iFormat);

								cache_get_field_content(row2, "LastOnline", iGet, MySQLPipeline);
								format(iFormat, sizeof(iFormat), " [Last Online: %s]", iGet); strcat(iMessage, iFormat);

								SendClientMessage(playerid, COLOR_GREY, iMessage);
							}
						}
						myStrcpy(MySQLThreadName, "ShowOfflineMembers");
					}
					case THREAD_LOAD_PLAYERS_ACCOUNT:
					{
						new playerid = strval(extra);
						if(rows)
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
							LOOP:drugID(0, sizeof(drugtypes)) strcat(iP, "i");
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
						}
						else myStrcpy(ErrorDetails, "No rows found in the Database.");
						myStrcpy(MySQLThreadName, "LoadPlayerAccount");
					}
					case THREAD_OFFLINE_PERSONALMESSAGES:
					{
						if(rows)
						{
							LOOP:row2(0, rows)
							{
								new iFrom[MAX_PLAYER_NAME], iMessage[128];
								cache_get_field_content(row2, "From", iFrom, MySQLPipeline);
								cache_get_field_content(row2, "Message", iMessage, MySQLPipeline);
								SendClientMSG(playerid, 0xE65CE6FF, "(( OPM from %s: %s ))", iFrom, iMessage);
							}
							new iQuery[128];
							mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `OPMs` SET `Active` = 1 WHERE `To` = '%e' AND `Active` = 0", PlayerName(playerid));
							mysql_tquery(MySQLPipeline, iQuery);
						}
						myStrcpy(MySQLThreadName, "OnLoadOfflinePMs");
					}
					case THREAD_EVICT_FROM_HOUSE:
					{
						
					}
					default: myStrcpy(ThreadDetails, "Unknown Retrieve Data Thread.");
				}
				new commandFile[156], d, m, y; getdate(y, m, d);
				new sec, min, hour; gettime(hour, min, sec);
				format(commandFile, sizeof(commandFile), "PipelineLogs/Thread-logs-%02d-%02d-%d.log", d, m, y);
				new File:cmdlog = fopen(commandFile, io_append);
				format(commandFile, sizeof(commandFile), "[%02d:%02d:%02d] - Thread: %s - Rows: %d - Fields: %d - Error: %s - Message: %s\r\n", sec, min, hour, MySQLThreadName, rows, fields, ErrorDetails, ThreadDetails)
				fwrite(cmdlog, commandFile);
				fclose(cmdlog);	
				return 1;
			}
			case DATA_THREAD_INSERTDATA:
			{
				switch(dataThreadID)
				{
					
				}
			}
		}
		return 1;
	}
	else return 0;
}