stock ShowDialog(playerid, dialogid, extra = -1, extraEx = -1)
{
	new iMainContent[2500], iFormat[228]; 
	if(dialogid == DIALOG_REGISTER)
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{3196ef} - "SERVER_GM"{adc7e7}", "  {FFFFFF}Please enter your password to register.", "Register", "");
	if(dialogid == DIALOG_LOGIN)
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{3196ef} - "SERVER_GM"{adc7e7}", "  {FFFFFF}Please enter your password.", "Login", "");
	if(dialogid == DIALOG_SMS)
		ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "{3196ef} - Mobile Phone:{adc7e7} Short Message Service (SMS)", "Please enter the text you want to send!", "Send", "Cancel");
	if(dialogid == DIALOG_AD)
		ShowPlayerDialog(playerid, DIALOG_AD, DIALOG_STYLE_INPUT, "{3196ef} - Mobile Phone: {adc7e7}Advertisement", "Welcome to the LV Advertisement Agency.\n\nPlease input your ad below:", "Send", "Cancel");
	if(dialogid == DIALOG_CAD)
		ShowPlayerDialog(playerid, DIALOG_CAD, DIALOG_STYLE_INPUT, "{3196ef} - Mobile Phone: {adc7e7}Company Advertisement", "Welcome to the LV Advertisement Agency.\n\nPlease input your ad below:", "Send", "Cancel");
	if(dialogid == DIALOG_GIVEGUN)
		ShowPlayerDialog(playerid, DIALOG_GIVEGUN, DIALOG_STYLE_LIST, "{3196ef} - Law Enforcement Locker: {adc7e7}Armory", "Quick Equip\nNightstick\nPepperspray\nDeagle\nShotgun\nMP5\nM4A1\nSniper\nParachute\nCamera", "Select", "Cancel");
	if(dialogid == DIALOG_CHOOSE_ETHNICITY)
		ShowPlayerDialog(playerid, DIALOG_CHOOSE_ETHNICITY, DIALOG_STYLE_LIST, "{3196ef} - Character Setup: {adc7e7}Gender & Ethnicity", " - Asian Male\n - Asian Female\n - Black Male\n - Black Female\n - Hispanic Male\n - Hispanic Female\n - White Male\n - White Female", "Select", "");
	if(dialogid == DIALOG_UPGRADE_H)
		ShowPlayerDialog(playerid, DIALOG_UPGRADE_H, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Upgrades", " - Interior\n - Alarm\n - Garage\n - Wardrobe\n - Armour", "Select", "Exit");
	if(dialogid == DIALOG_911)
		ShowPlayerDialog(playerid, DIALOG_911, DIALOG_STYLE_INPUT, "{3196ef} - Mobile Phone: {adc7e7}Emergency Call", "Please explain the situation within\ndeep detail. Include your location too.", "Send", "Cancel");
	if(dialogid == DIALOG_WHEELS_BUY)
		ShowPlayerDialog(playerid, DIALOG_WHEELS_BUY, DIALOG_STYLE_MSGBOX, "{3196ef} - Business: {adc7e7}Wheel Mod Shop", "Do you want to buy the wheels or continue browsing?", "Buy", "Cancel");
	if(dialogid == DIALOG_H_SET_RENT)
		ShowPlayerDialog(playerid, DIALOG_H_SET_RENT, DIALOG_STYLE_INPUT, "{3196ef} - House: {adc7e7}Rent Price", "Enter the amount you want to set your rent price to.", "Set", "Back");
//******* [ Dialogs ] ********
	if(dialogid == DIALOG_INVENTORY)
	{
		strcat(iMainContent, " - My Houses\n");
		strcat(iMainContent, " - My Businesses\n");
		strcat(iMainContent, " - My Vehicles\n");
		strcat(iMainContent, " - My Drugs\n");
		strcat(iMainContent, " - My Seeds\n");
		strcat(iMainContent, " - My Weapons\n");
		strcat(iMainContent, " - My Items");
		ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_LIST, "{3196ef} - Character: {adc7e7}Inventory", iMainContent, "Select", "");
	}
	if(dialogid == INVE_MY_HOUSES)
	{
		strcat(iMainContent, "HouseID\tRent\tTill\tLocation\n");
		new iCount;
		HouseLoop(h)
		{
			if(HouseInfo[h][hActive] != true) continue;
			if(!strcmp(HouseInfo[h][hOwner], PlayerName(playerid), false))
			{
			 	new zone[ 32 ];
			   	GetZone(HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ], zone);	
			   	format(iFormat, sizeof(iFormat), "%d\t$%s\t$%s\t%s\n", h, number_format(HouseInfo[h][hRentprice]), number_format(HouseInfo[h][hTill]), zone); strcat(iMainContent, iFormat);
			   	iCount++;
			}
		}
		if(iCount == 0) return SendClientError(playerid, "You don't own any houses."), 1;
		ShowPlayerDialog(playerid, INVE_MY_HOUSES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Inventory: {adc7e7}My houses", iMainContent, "Back", "");
	}
	if(dialogid == INVE_MY_BUSINESSES)
	{
		strcat(iMainContent, "BusinessID\tTill\tComponents\tLocation\n");
		new iCount;
		BusinessLoop(b)
		{
			if(BusinessInfo[b][bActive] != true) continue;
			if(!strcmp(BusinessInfo[b][bOwner], PlayerName(playerid), false))
			{
			 	new zone[ 32 ];
			   	GetZone(BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ], zone);	
			   	format(iFormat, sizeof(iFormat), "%d\t$%s\t%s\t%s\n", b, number_format(BusinessInfo[b][bTill]), number_format(BusinessInfo[b][bComps]), zone); strcat(iMainContent, iFormat);
			   	iCount++;
			}
		}
		if(iCount == 0) return SendClientError(playerid, "You don't own any businesses."), 1;
		ShowPlayerDialog(playerid, INVE_MY_BUSINESSES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Inventory: {adc7e7}My Businesses", iMainContent, "Back", "");
	}
	if(dialogid == INVE_MY_VEHICLES)
	{
		strcat(iMainContent, "VehicleID\tMileage\tPlate\tLocation\n");
		new iCount;
		VehicleLoop(v)
		{
		    if(VehicleInfo[v][vActive] != true/*  || VehicleInfo[v][vSpawned] != true */) continue;
			if(!strcmp(VehicleInfo[v][vOwner], PlayerName(playerid), false))
			{
			 	new zone[ 32 ], Float:viX, Float:viY, Float:viZ;
			 	GetVehiclePos(GetCarID(v), viX, viY, viZ);
			   	GetZone(viX, viY, viZ, zone);	
			   	format(iFormat, sizeof(iFormat), "%d\t%s/km\t%s\t%s\n", v, number_format(floatround(VehicleInfo[v][vMileage])), VehicleInfo[v][vPlate], zone); strcat(iMainContent, iFormat);
			   	iCount++;
			}
		}
		if(iCount == 0) return SendClientError(playerid, "You don't have any spawned vehicles."), 1;
		ShowPlayerDialog(playerid, INVE_MY_VEHICLES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Inventory: {adc7e7}My Vehicles", iMainContent, "Back", "");
	}
	if(dialogid == INVE_MY_DRUGS)
	{
		strcat(iMainContent, "Drug\tGrams\tAddiction\n");
		new iCount;
		LOOP:i(0, sizeof(drugtypes))
		{
			if(PlayerInfo[playerid][hasdrugs][i] == 0) continue;
			else
			{
				format(iFormat, sizeof(iFormat), "%s\t%s\t%d\n", drugtypes[i][drugname], PlayerInfo[playerid][hasdrugs][i], drugtypes[i][drughp]); strcat(iMainContent, iFormat);
				iCount++;
			}
		}
		if(iCount == 0) return SendClientError(playerid, "You don't have any drugs in your inventory.");
		ShowPlayerDialog(playerid, INVE_MY_DRUGS, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Inventory: {adc7e7}My Drugs", iMainContent, "Back", "");
	}
	if(dialogid == INVE_MY_SEEDS)
	{
		strcat(iMainContent, "SeedID\tGrams Produced\tLocation\n");
		new iCount;
		LOOP:i(0, sizeof(Seeds))
		{
		    if(!strcmp(Seeds[i][sOwner], PlayerName(playerid), false))
			{
			 	new zone[ 32 ];
			   	GetZone(Seeds[i][seedX], Seeds[i][seedY], Seeds[i][seedZ], zone);
			   	format(iFormat, sizeof(iFormat), "%d\t%s\t%s\n", i, number_format(Seeds[i][sGrams]), zone); strcat(iMainContent, iFormat);
			   	iCount++;
			}
		}
		if(iCount == 0) return SendClientError(playerid, "You don't own any seeds currently growing."), 1;
		ShowPlayerDialog(playerid, INVE_MY_HOUSES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Inventory: {adc7e7}My Seeds", iMainContent, "Back", "");
	}
	if(dialogid == INVE_MY_WEAPONS)
	{
		strcat(iMainContent, "Weapon\tAmmo\tSlot\n");
		new iCount;
		LOOP:i(0, 13)
		{
			new weaponS, ammoS;
			GetPlayerWeaponData(playerid, i, weaponS, ammoS);
			if(weaponS == 0) continue;
			format(iFormat, sizeof(iFormat), "%s\t%s\t%d\n", aWeaponNames[weaponS], number_format(ammoS), i); strcat(iMainContent, iFormat);
			iCount++;
		}
		if(iCount == 0) return SendClientError(playerid, "You don't have any weeapons inside your inventory.");
		ShowPlayerDialog(playerid, INVE_MY_WEAPONS, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Inventory: {adc7e7}My Weapons", iMainContent, "Back", "");
	}
	if(dialogid == SRV_CREDITS)
	{
		strcat(iMainContent, "Name\tRole\n");
		strcat(iMainContent, "Red-Zero\tScript Founder\n");
		strcat(iMainContent, "Algren\tScript Co-Founder\n");
		strcat(iMainContent, "ryder\tIRC coder\n");
		strcat(iMainContent, "CrashOver\tBig Helper\n");
		strcat(iMainContent, "Zen_Afterlife\tBig Helper\n");
		strcat(iMainContent, "Ellis\tBig Helper\n");
		strcat(iMainContent, "Hoodstar\tBig Helper\n");
		strcat(iMainContent, "Laurentt\t Ex-Owner/Coder\n");
		strcat(iMainContent, "Crazy\t Ex-Coder/Big Helper\n");
		strcat(iMainContent, "w00t\tEx-Coder/Big Helper\n");
		strcat(iMainContent, "AlanDaSexY\tEx-Coder/Big Helper\n");
		strcat(iMainContent, "Skatim\tDeveloper/Owner\n");
		strcat(iMainContent, "Lucas\tEx-Coder/Big Helper\n");
		strcat(iMainContent, "Tomaz\tEx-Coder/Big Helper\n");
		strcat(iMainContent, "Scott\tBig Helper\n");
		strcat(iMainContent, "Cube\tEx-Coder/Big Helper\n");
		strcat(iMainContent, "Slash\tEx-Owner/Big Helper\n");
		strcat(iMainContent, "Benedikt\tEx-Coder/Big Helper\n");
		strcat(iMainContent, "GiGi\tEx-Coder/Big Helper\n");
		strcat(iMainContent, "Special thanks to everyone that contributed to development!\n");
		
		ShowPlayerDialog(playerid, SRV_CREDITS, DIALOG_STYLE_TABLIST_HEADERS,"{3196ef}Script Credits: {adc7e7}2007-2016", iMainContent, "Awesome", "");
	}
	if(dialogid == INVE_MY_ITEMS)
	{
		strcat(iMainContent, "Item\tEquipped\n");
		strcat(iMainContent, " Mobile Phone\t"); if(PlayerInfo[playerid][gotphone] != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");
		strcat(iMainContent, " Portable Radio\t"); if(PlayerInfo[playerid][radio] != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");
		strcat(iMainContent, " Laptop\t"); if(PlayerInfo[playerid][laptop] != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");
		/* if(GetPVarInt(playerid, "Toolkit") == 0)
		return SendClientError(playerid, "You don't have a toolkit!"); */
		strcat(iMainContent, " Tool Kit\t"); if(GetPVarInt(playerid, "Toolkit") != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");		
		strcat(iMainContent, " Rope\t"); if(GetPVarInt(playerid, "HasRope") != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");		
		strcat(iMainContent, " Rag\t"); if(GetPVarInt(playerid, "HasRag") != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");		
		strcat(iMainContent, " Petrol Canister\t"); if(GetPVarInt(playerid, "PetrolCan") != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");		
//		strcat(iMainContent, " Tool Kit\t"); if(GetPVarInt(playerid, "Toolkit") != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");		
		strcat(iMainContent, " Phonebook\t"); if(PlayerInfo[playerid][phonebook] != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");
		strcat(iMainContent, " BoomBox\t"); if(PlayerInfo[playerid][pBoomBox] != 0) strcat(iMainContent, "Yes\n"); else strcat(iMainContent, "No\n");
		ShowPlayerDialog(playerid, INVE_MY_ITEMS, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Inventory: {adc7e7}My Items", iMainContent, "Back", "");
	}
	if(dialogid == DIALOG_V_FIND)
	{
		new iCount;
		strcat(iMainContent, "VehicleID\tLocation\tStatus\n");
		VehicleLoop(v)
		{
			if(VehicleInfo[v][vActive] != true) continue;
			//if(VehicleInfo[v][vSpawned] != true) continue;
			if(!strcmp(VehicleInfo[v][vOwner], PlayerName(playerid), false))
			{
				new iStatus[12], iZone[75], Float:vPosX, Float:vPosY, Float:vPosZ;
				GetVehiclePos(GetCarID(v), vPosX, vPosY, vPosZ);
				GetZone(vPosX, vPosY, vPosZ, iZone);
				if(IsVehicleOccupied(GetCarID(v))) myStrcpy(iStatus, "Occupied");
				else myStrcpy(iStatus, "Unoccupied");
				format(iFormat, sizeof(iFormat), "%d\t%s\t%s\n",v,iZone,iStatus);
				strcat(iMainContent, iFormat);
				iCount++;
			}
			else continue;
			if(iCount >= 1)
			{
				ShowPlayerDialog(playerid, DIALOG_V_FIND, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Vehicle: {adc7e7}Select a vehicle to find.", iMainContent, "Find", "Close");
			}
			else SendClientError(playerid, "No player owned vehicles are spawned.");
		}
	}
	if(dialogid == DIALOG_WIRETRANSFER_NAME)
	{
		format(iFormat, sizeof(iFormat), "{adff2f}Bank Account: {FFFFFF}%s\n", RPName(playerid)); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{adff2f}Balance: {FFFFFF}$%s\n\n", number_format(PlayerInfo[playerid][bank])); strcat(iMainContent, iFormat);
		strcat(iMainContent, "Enter the players name you want to {adff2f}transfer{FFFFFF} to:");
		ShowPlayerDialog(playerid, DIALOG_WIRETRANSFER_NAME, DIALOG_STYLE_INPUT, "{3196ef} - Laptop: {adc7e7}Wiretransfer", iMainContent, "Done", "Back");
	}
	if(dialogid == DIALOG_WIRETRANSFER_AMOUNT)
	{
		format(iFormat, sizeof(iFormat), "{adff2f}Bank Account: {FFFFFF}%s\n", RPName(playerid)); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{adff2f}Balance: {FFFFFF}$%s\n\n", number_format(PlayerInfo[playerid][bank])); strcat(iMainContent, iFormat);
		new playername[MAX_PLAYER_NAME];
		GetPVarString(playerid, "WireTransfer", playername, sizeof(playername));
		format(iFormat, sizeof(iFormat), "Enter the amount you want to transfer to {adff2f}%s", NoUnderscore(playername)); strcat(iMainContent, iFormat);
		ShowPlayerDialog(playerid, DIALOG_WIRETRANSFER_AMOUNT, DIALOG_STYLE_INPUT, "{3196ef} - Laptop: {adc7e7}Wiretransfer", iMainContent, "Done", "Back");
	}
	if(dialogid == DIALOG_TOY_BUY_CATE)
	{
		strcat(iMainContent, "Masks");
		ShowPlayerDialog(playerid, DIALOG_TOY_BUY_CATE, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Accessory Purchase", iMainContent, "Select", "Exit");
	}
	if(dialogid == DIALOG_CLOSEST_BUSINESSES)
	{
		strcat(iMainContent, "Type\tLocation\tDistance\n");
		new iZone[75], dist, bizID = -1;
		bizID = GetClosestBiz(playerid, BUSINESS_TYPE_BANK);
		if(bizID != -1)
		{
			dist = GetPlayerDistanceToPointEx(playerid, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]);
			GetZone(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ], iZone);
			format(iFormat, sizeof(iFormat), "Bank\t%s\t%s meters\n", iZone, number_format(dist)); strcat(iMainContent, iFormat);
		}
		bizID = GetClosestBiz(playerid, BUSINESS_TYPE_247);
		if(bizID != -1)
		{
			dist = GetPlayerDistanceToPointEx(playerid, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]);
			GetZone(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ], iZone);
			format(iFormat, sizeof(iFormat), "Grocery store\t%s\t%s meters\n", iZone, number_format(dist)); strcat(iMainContent, iFormat);
		}
		bizID = GetClosestBiz(playerid, BUSINESS_TYPE_HARDWARE);
		if(bizID != -1)
		{
			dist = GetPlayerDistanceToPointEx(playerid, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]);
			GetZone(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ], iZone);
			format(iFormat, sizeof(iFormat), "Hardware Store\t%s\t%s meters\n", iZone, number_format(dist)); strcat(iMainContent, iFormat);
		}
		bizID = GetClosestBiz(playerid, BUSINESS_TYPE_CLOTHES);
		if(bizID != -1)
		{
			dist = GetPlayerDistanceToPointEx(playerid, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]);
			GetZone(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ], iZone);
			format(iFormat, sizeof(iFormat), "Clothes Store\t%s\t%s meters\n", iZone, number_format(dist)); strcat(iMainContent, iFormat);
		}
		bizID = GetClosestBiz(playerid, BUSINESS_TYPE_PAYNSPRAY);
		if(bizID != -1)
		{
			dist = GetPlayerDistanceToPointEx(playerid, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]);
			GetZone(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ], iZone);
			format(iFormat, sizeof(iFormat), "Pay N Spray\t%s\t%s meters\n", iZone, number_format(dist)); strcat(iMainContent, iFormat);
		}
		new atmID = GetClosestATM( playerid );
		if(atmID != -1)
		{
			dist = GetPlayerDistanceToPointEx(playerid, ATMInfo[atmID][atmX], ATMInfo[atmID][atmY], ATMInfo[atmID][atmZ]);
			GetZone(ATMInfo[atmID][atmX], ATMInfo[atmID][atmY], ATMInfo[atmID][atmZ], iZone);
			format(iFormat, sizeof(iFormat), "ATM\t%s\t%s meters\n", iZone, number_format(dist)); strcat(iMainContent, iFormat);
		}
		bizID = GetClosestBiz(playerid, BUSINESS_TYPE_GAS);
		if(bizID != -1)
		{
			dist = GetPlayerDistanceToPointEx(playerid, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]);
			GetZone(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ], iZone);
			format(iFormat, sizeof(iFormat), "Gas Station\t%s\t%s meters", iZone, number_format(dist)); strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_CLOSEST_BUSINESSES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Navigation: {adc7e7}Closest businesses!", iMainContent, "Locate", "Cancel");
	}
	if(dialogid == DIALOG_HELPME)
	{
		strcat(iMainContent, "{3169a5}[Legal Jobs]{c6dbff} City Hall\n");
		strcat(iMainContent, "{3169a5}[Legal Jobs]{c6dbff} Trucker Depot\n");
		strcat(iMainContent, "{3169a5}[Legal Jobs]{c6dbff} Mechanic Depot\n");
		strcat(iMainContent, "{3169a5}[Legal Jobs]{c6dbff} Farm\n");
		strcat(iMainContent, "{3169a5}[Illegal Job]{c6dbff} Car Jacker\n");
		strcat(iMainContent, "{3169a5}[Illegal Jobs]{c6dbff} Thief\n");
		strcat(iMainContent, "{3169a5}[Illegal]{c6dbff} Quarry\n");
		strcat(iMainContent, "{3169a5}[License]{c6dbff} Licensing Department\n");
		strcat(iMainContent, "{3169a5}[Vehicle]{c6dbff} Vehicle Registration\n");
		strcat(iMainContent, "{3169a5}[Vehicle]{c6dbff} Vehicle Carlot\n");
		strcat(iMainContent, "{3169a5}[Vehicle]{c6dbff} Dealership Carlot\n");
		strcat(iMainContent, "{3169a5}[Hotel]{c6dbff} Get the closest Hotel\n");
		strcat(iMainContent, "{3169a5}[Appartment]{c6dbff} Get the closest Appartment complex\n");
		strcat(iMainContent, "{3169a5}[Legal]{c6dbff} LS Police Department\n");
		strcat(iMainContent, "{3169a5}[Legal]{c6dbff} SA Sheriff Department\n");
		strcat(iMainContent, "{3169a5}[General]{c6dbff} Los Santos GYM");
		ShowPlayerDialog(playerid, DIALOG_HELPME, DIALOG_STYLE_LIST, "{3196ef} - Navigation: {adc7e7}General Locations", iMainContent, "Go", "Cancel");
	}
	if(dialogid == DIALOG_GUNSTORE)
	{
		strcat(iMainContent, "Weapon\tPrice\tAmmo\n");
		for(new c = 0; c < sizeof(GunStoreInfo); c++)
		{
			new iPrice;
			if(GunStoreInfo[c][gsweapID] == WEAPON_DEAGLE) iPrice = BusinessInfo[extra][bDeagle];
			else if(GunStoreInfo[c][gsweapID] == WEAPON_MP5) iPrice = BusinessInfo[extra][bMP5];
			else if(GunStoreInfo[c][gsweapID] == WEAPON_M4) iPrice = BusinessInfo[extra][bM4];
			else if(GunStoreInfo[c][gsweapID] == WEAPON_SHOTGUN) iPrice = BusinessInfo[extra][bM4];
			else if(GunStoreInfo[c][gsweapID] == WEAPON_SNIPER) iPrice = BusinessInfo[extra][bSniper];
			else if(GunStoreInfo[c][gsweapID] == WEAPON_RIFLE) iPrice = BusinessInfo[extra][bRifle];
			else iPrice = BusinessInfo[extra][bArmour];
			if(GunStoreInfo[c][gsweapID] == -1)
			{
				format(iFormat, sizeof(iFormat), "%s\t$%s\t\n", GunStoreInfo[c][gsweapName], number_format(iPrice));
				strcat(iMainContent, iFormat);
			}
			else
			{
				format(iFormat, sizeof(iFormat), "%s\t$%s\t%d\n", GunStoreInfo[c][gsweapName], number_format(iPrice), GunStoreInfo[c][gsweapAmmo]);
				strcat(iMainContent, iFormat);
			}
		}
		ShowPlayerDialog(playerid, DIALOG_GUNSTORE, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Business: {adc7e7}Gun Store", iMainContent, "Buy", "Exit");
	}
	if(dialogid == DIALOG_DRUGSTORE)
	{
		for(new c; c < sizeof(drugtypes); c++)
		{
			format(iFormat, sizeof(iFormat), "{FFFFFF}%s ({248716}$%d{FFFFFF}/gram)\n", drugtypes[c][drugname], drugtypes[c][drugprice]);
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_DRUGSTORE, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Drug Store", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_FOODSTORE)
	{
		for(new c; c < sizeof(foodtypes); c++)
		{
			format(iFormat,sizeof(iFormat),"{FFFFFF}%s\t{248716}($%s)\n",foodtypes[c][foodname], number_format(foodtypes[c][foodprice]));
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_FOODSTORE, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Food Store", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_247)
	{
		myStrcpy(iMainContent, "{FFFFFF}Camera {41c72e}($2.000)\n");
		strcat(iMainContent, "{FFFFFF}Laptop {41c72e}($5.000)\n");
		strcat(iMainContent, "{FFFFFF}Golfclub {41c72e}($500)\n");
		strcat(iMainContent, "{FFFFFF}PoolStick {41c72e}($200)\n");
		strcat(iMainContent, "{FFFFFF}Cane {41c72e}($80)\n");
		strcat(iMainContent, "{FFFFFF}Fire Extinguisher {41c72e}($1.000)\n");
		strcat(iMainContent, "{FFFFFF}Dildo {41c72e}($100)\n");
		strcat(iMainContent, "{FFFFFF}Katana {41c72e}($1.000)\n");
		strcat(iMainContent, "{FFFFFF}Flowers {41c72e}($50)\n");
		strcat(iMainContent, "{FFFFFF}Parachute {41c72e}($1000)\n");
		strcat(iMainContent, "{FFFFFF}Cellphone {41c72e}($1.000)\n");
		strcat(iMainContent, "{FFFFFF}Radio {41c72e}($3.000)\n");
		strcat(iMainContent, "{FFFFFF}PhoneBook {41c72e}($5.000)\n");
		strcat(iMainContent, "{FFFFFF}Petrol Canister {41c72e}($2.000)\n");
		strcat(iMainContent, "{FFFFFF}Bat {41c72e}($550)\n");
		strcat(iMainContent, "{FFFFFF}Bombox {41c72e}($450,000)");
		ShowPlayerDialog(playerid, DIALOG_247, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Grocery Store", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_HARDWARE)
	{
		myStrcpy(iMainContent, "{FFFFFF}Rope {41c72e}($5.000)\n");
		strcat(iMainContent, "{FFFFFF}Rag {41c72e}($3.000)\n");
		strcat(iMainContent, "{FFFFFF}Toolkit {41c72e}($2.000)\n");
		strcat(iMainContent, "{FFFFFF}Shovel {41c72e}($200)\n");
		strcat(iMainContent, "{FFFFFF}Chainsaw {41c72e}($5.000)\n");
		strcat(iMainContent, "{FFFFFF}Spraycan {41c72e}($1.000)\n");
		strcat(iMainContent, "{FFFFFF}Fake License {41c72e(10.000)");
		ShowPlayerDialog(playerid, DIALOG_HARDWARE, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Hardware Store", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_LIST_ACTIVE_BIZES)
	{
		strcat(iMainContent, "BizID\tTax\tName\tOwner\tLocation\n");
		BusinessLoop(b)
		{
			if(BusinessInfo[b][bActive] != true) continue;
			if(BusinessInfo[b][bType] == BUSINESS_TYPE_BANK) continue;
			new iZone[65];
			GetZone(BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ], iZone);
			format(iFormat,sizeof(iFormat),"%d\t%d%%\t%s\t%s\t%s\n", b, BusinessInfo[b][bTax], BusinessInfo[b][bName], NoUnderscore(BusinessInfo[b][bOwner]), iZone);
			strcat(iMainContent, iFormat);
		}
	  	ShowPlayerDialog(playerid, DIALOG_LIST_ACTIVE_BIZES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - "SERVER_GM": {adc7e7}Business List", iMainContent, "Ok", "");
	}
	if(dialogid == DIALOG_HEAVY_DEALERSHIP)
	{
		strcat(iMainContent, "Vehicle\tPrice\n");
		for(new c; c < sizeof(heavycars); c++)
		{
			format(iFormat, sizeof(iFormat), "{FFFFFF}%s\t{248716}$%s\n",heavycars[c][hname], number_format(heavycars[c][hprice]));
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_HEAVY_DEALERSHIP, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Business: {adc7e7}Heavy Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_JOB_DEALERSHIP)
	{
		strcat(iMainContent, "Vehicle\tPrice\n");
		for(new c; c < sizeof(jobcars); c++)
		{
			format(iFormat, sizeof(iFormat),"{FFFFFF}%s \t{248716}$%s\n",jobcars[c][jcname], number_format(jobcars[c][jcprice]));
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_JOB_DEALERSHIP, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Business: {adc7e7}Job Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_BIKE_DEALERSHIP)
	{
		for(new c; c < sizeof(bikes); c++)
		{
			format(iFormat,sizeof(iFormat),"{FFFFFF}%s {248716}($%s) \n",bikes[c][bikename], number_format(bikes[c][bikeprice]));
			strcat(iMainContent,iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_BIKE_DEALERSHIP, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Bike Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_NOOB_DEALERSHIP)
	{
		for(new c; c < sizeof(noobcars); c++)
		{
			format(iFormat,sizeof(iFormat),"{FFFFFF}%s {248716}($%s) \n",noobcars[c][noobcname], number_format(noobcars[c][noobcprice]));
			strcat(iMainContent,iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_NOOB_DEALERSHIP, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Noobie Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_AIR_DEALERSHIP)
	{
		for(new c; c < sizeof(aircars); c++)
		{
			format(iFormat,sizeof(iFormat),"{FFFFFF}%s {248716}($%s) \n",aircars[c][airname], number_format(aircars[c][airprice]));
			strcat(iMainContent,iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_AIR_DEALERSHIP, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Aircraft Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_BOAT_DEALERSHIP)
	{
		for(new c; c < sizeof(watercars); c++)
		{
			format(iFormat,sizeof(iFormat),"{FFFFFF}%s {248716}($%s) \n",watercars[c][boatname], number_format(watercars[c][boatprice]));
			strcat(iMainContent,iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_BOAT_DEALERSHIP, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Boat Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_CAR_DEALERSHIP)
	{
		for(new c; c < sizeof(cars_normal); c++)
		{
			format(iFormat,sizeof(iFormat),"{FFFFFF}%s {248716}($%s)\n",cars_normal[c][cccarname], number_format(cars_normal[c][cccarprice]));
			strcat(iMainContent,iFormat);

		}
		ShowPlayerDialog(playerid, DIALOG_CAR_DEALERSHIP, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Car Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_LUXUS_DEALERSHIP)
	{
		for(new c; c < sizeof(cars_luxus); c++)
		{
			format(iFormat,sizeof(iFormat),"{FFFFFF}%s {248716}($%s) \n",cars_luxus[c][cccarname], number_format(cars_luxus[c][cccarprice]));
			strcat(iMainContent,iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_LUXUS_DEALERSHIP, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Luxus Dealership", iMainContent, "Buy", "Cancel");
	}
	if(dialogid == DIALOG_CMD_CMDS)
	{
		myStrcpy(iMainContent, "{FFFFFF} - Account Commands\n");
		strcat(iMainContent, " - Roleplay Commands\n");
		strcat(iMainContent, " - License Commands\n");
		strcat(iMainContent, " - Faction Commands\n");
		strcat(iMainContent, " - Donator Commands\n");
		strcat(iMainContent, " - Phone Commands\n");
		strcat(iMainContent, " - Radio Commands\n");
		strcat(iMainContent, " - Drug Commands\n");
		strcat(iMainContent, " - Chat Commands\n");
		strcat(iMainContent, " - Job Commands\n");
		strcat(iMainContent, " - Bank Commands\n");
		strcat(iMainContent, " - Miscellaneous Commands");
		ShowPlayerDialog(playerid, DIALOG_CMD_CMDS, DIALOG_STYLE_LIST, "{3196ef} "SERVER_GM": {adc7e7}Command Categories", iMainContent, "Select", "Close");
	}
	if(dialogid == DIALOG_MY_B_DUPELICATES)
	{
		new iCount;
		strcat(iMainContent, "Name\tOwner\tMoney\tStatus\n"); // headers
		BusinessLoop(b)
		{
			if(BusinessInfo[b][bActive] != true) continue;
			if(!strcmp(BusinessInfo[b][bDupekey], PlayerName(playerid), false)) iCount++;
		}
		if(iCount >= 1)
		{
			BusinessLoop(b)
			{
				if(BusinessInfo[b][bActive] != true) continue;
				if(!strcmp(BusinessInfo[b][bDupekey], PlayerName(playerid), false))
				{
					new bStatus[15];
					if(BusinessInfo[b][bLocked] == true) myStrcpy(bStatus, "Closed"); else myStrcpy(bStatus, "Open");
					format(iFormat, sizeof(iFormat), "%s\t%s\t$%s\t%s\n", BusinessInfo[b][bName], NoUnderscore(BusinessInfo[b][bOwner]), number_format(BusinessInfo[b][bTill]), bStatus);
					strcat(iMainContent, iFormat);
				}
			}
		}
		else strcat(iMainContent, "You don't have any duplicated keys!");
		ShowPlayerDialog(playerid, DIALOG_MY_B_DUPELICATES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Business: {adc7e7}My dupekeys", iMainContent, "Ok", "Back");
	}	
	if(dialogid == DIALOG_MYBUSINESSES)
	{
		strcat(iMainContent, "{B8E6E6}Name\tMoney\tStatus{FFFFFF}\n"); // headers
		if(GetPlayerBusinesses(playerid) >= 1) // has businesses
		{
			BusinessLoop(b)
			{
				if(BusinessInfo[b][bActive] != true) continue;
				if(!strcmp(BusinessInfo[b][bOwner], PlayerName(playerid), false))
				{
					new bStatus[15];
					if(BusinessInfo[b][bLocked] == true) myStrcpy(bStatus, "Closed"); else myStrcpy(bStatus, "Open");
					format(iFormat, sizeof(iFormat), "%s\t{66FF66}${FFFFFF}%s\t%s\n", BusinessInfo[b][bName], number_format(BusinessInfo[b][bTill]), bStatus);
					strcat(iMainContent, iFormat);
				}
			}
			strcat(iMainContent, "{B8E6E6}View my duplicate keys");
		}
		else
		{
			strcat(iMainContent, "You don't own any businesses!\n");
			strcat(iMainContent, "{B8E6E6}View my duplicate keys.");
		}
		ShowPlayerDialog(playerid, DIALOG_MYBUSINESSES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Business: {adc7e7}My Businesses", iMainContent, "Ok", "");
		return 1;
	}
	if(dialogid == DIALOG_SHOW_B_OWN_INFO)
	{
		new iTaxTakeAway, iTax = BusinessInfo[extra][bTax];
		iTaxTakeAway = (BusinessInfo[extra][bTill] * iTax / 100);
		strcat(iMainContent, "{B8E6E6}--------------------------------------------------------------------\n\n");
		format(iFormat, sizeof(iFormat), "{B8E6E6}Business ID: {FFFFFF}%d\n", extra); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8E6E6}Type: {FFFFFF}%d\n", BusinessInfo[extra][bType]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8E6E6}Name: {FFFFFF}%s\n", BusinessInfo[extra][bName]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8E6E6}Owner: {FFFFFF}%s\n", NoUnderscore(BusinessInfo[extra][bOwner])); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8E6E6}Components: {FFFFFF}%s/10,000\n", number_format(BusinessInfo[extra][bComps])); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8E6E6}Money: {FFFFFF}$%s\n", number_format(BusinessInfo[extra][bTill])); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8E6E6}Government tax rate: {FFFFFF}%d%% {FF0000}(-$%s)\n\n", BusinessInfo[extra][bTax], number_format(iTaxTakeAway)); strcat(iMainContent, iFormat);
		strcat(iMainContent, "{B8E6E6}--------------------------------------------------------------------");
		ShowPlayerDialog(playerid, DIALOG_SHOW_B_OWN_INFO, DIALOG_STYLE_MSGBOX, "{3196ef} - Business: {adc7e7}Information", iMainContent, "Ok", "");
	}
	if(dialogid == DIALOG_LAPTOP)
	{
		Action(playerid, "is using his laptop.");
		strcat(iMainContent, "News\n");
		strcat(iMainContent, "Members\n");
		strcat(iMainContent, "Backup\n");
		strcat(iMainContent, "Quarry Stocks\n");
		strcat(iMainContent, "Faction Info\n");
		strcat(iMainContent, "War Info\n");
		strcat(iMainContent, "Transfer\n");
		strcat(iMainContent, "Latest Advertisements");
		ShowPlayerDialog(playerid, DIALOG_LAPTOP, DIALOG_STYLE_LIST, "{3196ef} - Laptop: {adc7e7}Categories", iMainContent, "Select", "Logout");
	}
	if(dialogid == DIALOG_JOB_SELECTION)
	{
	    ShowPlayerDialog(playerid, DIALOG_JOB_SELECTION, DIALOG_STYLE_LIST, "{3196ef} - City Hall: {adc7e7}Job Agency", "1 - \tFarmer\n\
	    2 - \tDetective\n\
	    3 - \tTrucker\n\
	    4 - \tMedic\n\
	    5 - \tTaxi Driver\n\
		6 - \tLawyer\n\
		7 - \tMechanic\n", "Select", "Cancel");
	}
	if(dialogid == DIALOG_GYM)
	{
	    ShowPlayerDialog(playerid, DIALOG_GYM, DIALOG_STYLE_LIST, "{3196ef} - Los Santos GYM: {adc7e7}Martial Arts", "\
		Boxing\n\
		Kung Fu\n\
		Grabkick\n\
		Elbow", "Select", "Cancel");
	}
	if(dialogid == DIALOG_CCTV)
	{
		ShowPlayerDialog(playerid, DIALOG_CCTV, DIALOG_STYLE_LIST, "{3196ef} - Law Enforcement: {adc7e7}Close Circus Television", "\
			> Four Dragons Casino\n\
			> City Hall\n\
			> LV 2nd Bank\n\
			> LV Bank\n\
			> Police Department\n\
			> LV Court Room", "Select", " ");
	}
	if(dialogid == DIALOG_BANK_WITHDRAW)
	{
	    format(iStr, sizeof(iStr), "{adff2f}Bank Account: {FFFFFF}%s\n{adff2f}Balance: {FFFFFF}$%s\n\nEnter the amount you would like to {adff2f}withdraw:", RPName(playerid), number_format(PlayerInfo[playerid][bank]));
	    ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "{3196ef} - Business: {adc7e7}Bank / Withdrawal", iStr, "Withdraw", "Cancel");
	}
	if(dialogid == DIALOG_BANK_DEPOSIT)
	{
		format(iStr, sizeof(iStr), "{adff2f}Bank Account: {FFFFFF}%s\n{adff2f}Balance: {FFFFFF}$%s\n\nEnter the amount you would like to {adff2f}deposit:", RPName(playerid), number_format(PlayerInfo[playerid][bank]));
	    ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "{3196ef} - Business: {adc7e7}Bank / Deposit", iStr, "Deposit", "Cancel");
	}
	if(dialogid == DIALOG_WHEELS)
	{
		new iStrr[ 512 ], tmpzz[ 24 ];
		for(new i; i < sizeof(CarWheels); i++)
		{
		    format(tmpzz, 24, "%s\n", CarWheels[i][whName]);
		    strcat(iStrr, tmpzz);
		}
		ShowPlayerDialog(playerid, DIALOG_WHEELS, DIALOG_STYLE_LIST, "{3196ef} - Business: {adc7e7}Wheel Mod Shop", iStrr, "Preview", "Cancel");
	}
/* 	if(dialogid == DIALOG_V_SPAWN)
	{
		new iBigStr[1575], iCount, iSmllStr[128];
		strcat(iBigStr, "VehicleID\tModel\tLocation\n");
		VehicleLoop(v)
		{
		    if(VehicleInfo[v][vActive] != true) continue;
		    if(strcmp(PlayerName(playerid), VehicleInfo[v][vOwner], false)) continue;
		    iCount++;
		    new iZone[45], Float:x, Float:y, Float:z;
			if(VehicleInfo[v][vSpawned] == true)
			{
				GetVehiclePos(GetCarID(v), x, y, z);
				GetZone(x, y, z, iZone);
		    	format(iSmllStr, sizeof(iSmllStr), "%d\t%s\t%s\n", v, GetVehicleName(GetCarID(v)), iZone);
			}
			else
			{
			    x = VehicleInfo[v][vX], y = VehicleInfo[v][vY], z = VehicleInfo[v][vZ];
				GetZone(x, y, z, iZone);
		    	format(iSmllStr, sizeof(iSmllStr), "%d\t%s\t%s\n", v, GetVehicleNameFromModel(VehicleInfo[v][vModel]), iZone);
			}
		    strcat(iBigStr, iSmllStr);
		}
		if(!iCount) return SendClientError(playerid, "You don't own any vehicles!");
		ShowPlayerDialog(playerid, DIALOG_V_SPAWN, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Vehicles: {adc7e7}Select a vehicle to (de)spawn.", iBigStr, "Select", "Exit");
	} */
	if(dialogid == DIALOG_MNG_CATE_IN)
	{
		new houseid = PlayerTemp[playerid][tmphouse], iZone[75], isLocked[35], isHouseLocker[35], isRentRoom[75], gLocked[35];
		GetZone(HouseInfo[houseid][hX], HouseInfo[houseid][hY], HouseInfo[houseid][hZ], iZone);
		if(HouseInfo[houseid][hClosed] == true) myStrcpy(isLocked, "{FF0000}Locked{FFFFFF}"); else myStrcpy(isLocked, "{33CC33}Unlocked{FFFFFF}");
		if(HouseInfo[houseid][hGarageOpen] == true) myStrcpy(gLocked, "{33CC33}Unlocked{FFFFFF}"); else myStrcpy(gLocked, "{FF0000}Locked{FFFFFF}");
		if(HouseInfo[houseid][hLocker] == true) myStrcpy(isHouseLocker, "{FF0000}Locked{FFFFFF}"); else myStrcpy(isHouseLocker, "{33CC33}Unlocked{FFFFFF}");
		if(HouseInfo[houseid][hRentable] == true) format(isRentRoom, sizeof(isRentRoom), "{FFFFFF}Price: {47B247}${A3FFA3}%s{FFFFFF}", number_format(HouseInfo[houseid][hRentprice])); else myStrcpy(isRentRoom, "{FF0000}Unavailable{FFFFFF}");
		format(iMainContent, sizeof(iMainContent), "View Information\t\nDoor\t%s\nGarage\t%s\nHouselocker\t%s\nRent room\t%s\nRob house\t\nSettings\t", isLocked, gLocked, isHouseLocker, isRentRoom);
		ShowPlayerDialog(playerid, DIALOG_MNG_CATE_IN, DIALOG_STYLE_TABLIST, "{3196ef} - House: {adc7e7}Main Management", iMainContent, "Select", "Cancel");
	}
	if(dialogid == DIALOG_H_SETTINGS)
	{
		new houseid = PlayerTemp[playerid][tmphouse], hasArmour[35], hasAlarm[35], iZone[75];
		GetZone(HouseInfo[houseid][hX], HouseInfo[houseid][hY], HouseInfo[houseid][hZ], iZone);
		if(HouseInfo[houseid][hArmour] == 1) myStrcpy(hasArmour, "{33CC33}Yes{FFFFFF}"); else myStrcpy(hasArmour, "{FF0000}Nope{FFFFFF}");
		if(HouseInfo[houseid][hAlarm] == 1) myStrcpy(hasAlarm, "{33CC33}Active{FFFFFF}"); else myStrcpy(hasAlarm, "{FF0000}In-Active{FFFFFF}");
		format(iFormat, sizeof(iFormat), "Rent price\tCurrent: $%s\n", number_format(HouseInfo[houseid][hRentprice])); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "Tenants\t \n"); 					strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "House Interior\tCurrent: %d\n", HouseInfo[houseid][hInteriorPack]);strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "Alarm Status\tCurrent: %s\n", hasAlarm);strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "Sell house\t \n"); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "Armour:\tInstalled: %s", hasArmour);strcat(iMainContent, iFormat);
		ShowPlayerDialog(playerid, DIALOG_H_SETTINGS, DIALOG_STYLE_TABLIST, "{3196ef} - House: {adc7e7}Settings", iMainContent, "Select", "Exit");
	}
	if(dialogid == DIALOG_H_VIEW_INFO)
	{
		new houseid = PlayerTemp[playerid][tmphouse], iZone[75];
		new isLocked[35], isHouseLocker[35];
		GetZone(HouseInfo[houseid][hX], HouseInfo[houseid][hY], HouseInfo[houseid][hZ], iZone);
		if(HouseInfo[houseid][hClosed] == true) myStrcpy(isLocked, "{FF0000}Locked{FFFFFF}"); else myStrcpy(isLocked, "{33CC33}Unlocked{FFFFFF}");
		if(HouseInfo[houseid][hLocker] == true) myStrcpy(isHouseLocker, "{FF0000}Locked{FFFFFF}"); else myStrcpy(isHouseLocker, "{33CC33}Unlocked{FFFFFF}");
		strcat(iMainContent, "{B8DBFF}----------------------------------------------------------------------------------\n\n");
		format(iFormat, sizeof(iFormat), "{B8DBFF}House ID:{FFFFFF} %d\n", houseid); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8DBFF}Location:{FFFFFF} %s\n", iZone); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8DBFF}Owner:{FFFFFF} %s\n", NoUnderscore(HouseInfo[houseid][hOwner])); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8DBFF}Doors: %s\n", isLocked); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{B8DBFF}Houselocker: %s\n\n", isHouseLocker); strcat(iMainContent, iFormat);
		strcat(iMainContent, "{B8DBFF}Items inside the houselocker:\n"); new bool:AreThereItemsInHouse = false;
		if(HouseInfo[houseid][hSDrugs] >= 1 && HouseInfo[houseid][hClosed] == false) format(iFormat, sizeof(iFormat), "{B8DBFF}Sellable Drugs:{FFFFFF} %s\n", number_format(HouseInfo[houseid][hSDrugs])), strcat(iMainContent, iFormat), AreThereItemsInHouse = true;
		if(HouseInfo[houseid][hSGuns] >= 1 && HouseInfo[houseid][hClosed] == false) format(iFormat, sizeof(iFormat), "{B8DBFF}Sellable Guns:{FFFFFF} %s\n", number_format(HouseInfo[houseid][hSGuns])), strcat(iMainContent, iFormat), AreThereItemsInHouse = true;
		if(HouseInfo[houseid][hCash] >= 1 && HouseInfo[houseid][hClosed] == false) format(iFormat, sizeof(iFormat), "{B8DBFF}Money:{FFFFFF} %s\n\n", number_format(HouseInfo[houseid][hCash])), strcat(iMainContent, iFormat), AreThereItemsInHouse = true;
		if(AreThereItemsInHouse == false) strcat(iMainContent, "{FFFFFF}Nothing worth showing!\n\n");
		strcat(iMainContent, "{B8DBFF}----------------------------------------------------------------------------------");
		ShowPlayerDialog(playerid, DIALOG_H_VIEW_INFO, DIALOG_STYLE_MSGBOX, "{3196ef} - House: {adc7e7}View Information", iMainContent, "Ok", "");
	}
	if(dialogid == DIALOG_NO_RESPONSE)
	{
		switch(extra)
		{
			case 0: ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef} - Los Santos GYM: {adc7e7}Martial Arts", "Congratulations,\n\nyou have learned a new fighting style.\n\nMake sure to train regularly.", "Ok", "");
			case 1: // player stats - onclickplayer
			{
				new stats[650+1];
				GetPlayerNetworkStats(extraEx, stats, sizeof(stats));
				strcat(iMainContent, "{adc7e7}----------------------------------------------------------------------------------{FFFFFF}\n\n");
				strcat(iMainContent, stats);
				strcat(iMainContent, "\n{adc7e7}----------------------------------------------------------------------------------");
				new iTitle[128];
				format(iTitle, sizeof(iTitle), "{3196ef} - Network Statistics: {adc7e7}%s(%d)", RPName(extraEx), extraEx);
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, iTitle, iMainContent, "Close", "");
			}
			case 2: ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef} - Los Santos GYM: {adc7e7}Martial Arts", "The threadmill is currently occupied. Come back later!", "Ok", "");
			case 3: // friskcar
			{
				new car = GetPlayerNearestVehicle(playerid);
				new vehicleid = FindVehicleID(car);
				strcat(iMainContent, "{B8DBFF}----------------------------------------------------------------------------------\n\n");
				format(iFormat, sizeof(iFormat), "{B8DBFF}Guns:{FFFFFF} \t\t%s\n", number_format(VehicleInfo[vehicleid][vGuns])); strcat(iMainContent, iFormat);
				format(iFormat, sizeof(iFormat), "{B8DBFF}Drugs:{FFFFFF} \t\t%s\n", number_format(VehicleInfo[vehicleid][vDrugs])); strcat(iMainContent, iFormat);
				format(iFormat, sizeof(iFormat), "{B8DBFF}Alcohol:{FFFFFF} \t%s\n", number_format(VehicleInfo[vehicleid][vAlchool])); strcat(iMainContent, iFormat);
				format(iFormat, sizeof(iFormat), "{B8DBFF}Car Parts:{FFFFFF} \t%s\n", number_format(VehicleInfo[vehicleid][vCars])); strcat(iMainContent, iFormat);
				format(iFormat, sizeof(iFormat), "{B8DBFF}Money:{FFFFFF} \t$%s\n", number_format(VehicleInfo[vehicleid][vMoney])); strcat(iMainContent, iFormat);
				format(iFormat, sizeof(iFormat), "{B8DBFF}Stuffs:{FFFFFF} \t\t%s\n", number_format(VehicleInfo[vehicleid][vStuffs])); strcat(iMainContent, iFormat);
				format(iFormat, sizeof(iFormat), "{B8DBFF}Lead:{FFFFFF} \t\t%s\n", number_format(VehicleInfo[vehicleid][vWHLead])); strcat(iMainContent, iFormat);
				format(iFormat, sizeof(iFormat), "{B8DBFF}Metal:{FFFFFF} \t\t%s\n", number_format(VehicleInfo[vehicleid][vWHMetal])); strcat(iMainContent, iFormat);
				for(new i; i < 13; i++)
				{
					if(VehicleInfo[FindVehicleID(car)][vWeapon][i]) format(iFormat, sizeof(iFormat), "{B8DBFF}Slot %d: {FFFFFF}%s (%s ammo)\n\n", i, aWeaponNames[VehicleInfo[vehicleid][vWeapon][i]], number_format(VehicleInfo[vehicleid][vAmmo][i]));
				}
				strcat(iMainContent, "{B8DBFF}----------------------------------------------------------------------------------");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef} - Vehicle: {adc7e7}Inventory", iMainContent, "Okay", "");
			}
			case 4:
			{
				strcat(iMainContent, "Business Type\tType Name\n");
				for(new c = 0; c < sizeof(BizTypeList); c++)
				{
					format(iFormat, sizeof(iFormat), "%d\t%s\n", BizTypeList[c][biz_T], BizTypeList[c][biz_N]);
					strcat(iMainContent, iFormat);
				}
				new iTitle[128];
				format(iTitle, sizeof(iTitle), "{3196ef} - Business: {adc7e7}Types (%d):", sizeof(BizTypeList)+1); // +1 to avoid the 0...
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_TABLIST_HEADERS, iTitle, iMainContent, "Awesome", "Exit");
			}
		}
	}
/********************************************************************************************
	[FURNITURE DIALOGS ]
********************************************************************************************/
	if(dialogid == DIALOG_FURNITURE)
	{
		PlayerTemp[playerid][pFurnitureSelectID] = -1;
		PlayerTemp[playerid][pMaterialSlotEdit] = -1;
		PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = -1;
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = -1;
		// ^^^^ precausion
		new furCount, tmpid = PlayerTemp[playerid][tmphouse];
		FurnitureLoop(f)
		{
			if(FurnitureInfo[tmpid][f][furActive] != false) furCount++; 
		}
		if(furCount >= MAX_FURNITURE_SLOTS) strcat(iMainContent, "{FF9999} - Buy a new furniture object!{FFFFFF} - Unavailable (MAX_SLOTS reached!)\n");
		else strcat(iMainContent, "{FFFFFF} - Buy a new furniture object!{FFFFFF}\n");
		
		if(furCount == 0) strcat(iMainContent, "{FF9999} - List all active furniture slots!{FFFFFF} - Unavailable (No slots used!)\n");
		else strcat(iMainContent, "{FFFFFF} - List all active furniture slots!{FFFFFF}\n");
		
		strcat(iMainContent, " - Edit base house textures. - {FF0000}Managent / Helpers Only.");
		ShowPlayerDialog(playerid, DIALOG_FURNITURE, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Furniture Management", iMainContent, "Select", "Exit");
	}
	if(dialogid == DIALOG_FURNITURE_CATEGORY)
	{
		strcat(iMainContent, "{FFFFFF}Appliances\n");
		strcat(iMainContent, "Comfort\n");
		strcat(iMainContent, "Decorations\n");
		strcat(iMainContent, "Entertainment\n");
		strcat(iMainContent, "Lighting\n");
		strcat(iMainContent, "Plumbing\n");
		strcat(iMainContent, "Storage\n");
		strcat(iMainContent, "Surfaces\n");
		strcat(iMainContent, "Miscellenaous");
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_CATEGORY, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Furniture Categories", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_FURNITURE_LIST)
	{
		new houseid = extra;
		FurnitureLoop(f)
		{
			if(FurnitureInfo[houseid][f][furActive] != true) continue;
			format(iFormat, sizeof(iFormat), "{FFFFFF}Slot {BAFFFF}%d{FFFFFF}: %s\n", f, FurnitureInfo[houseid][f][furName]);
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_LIST, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Furniture List", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_APPLIANCE)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_APPLIANCES;
		strcat(iMainContent, "{FFFFFF}Refrigerators\n");
		strcat(iMainContent, "Stoves\n");
		strcat(iMainContent, "Trash Cans\n");
		strcat(iMainContent, "Small Appliances\n");
		strcat(iMainContent, "Dumpsters");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_APPLIANCE, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Appliances", iMainContent, "Select", "Back"); 
	}
	if(dialogid == DIALOG_CATE_SLCT_COMFORT)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_COMFORT;
		strcat(iMainContent, "{FFFFFF}Beds\n");
		strcat(iMainContent, "Chairs\n");
		strcat(iMainContent, "Couches\n");
		strcat(iMainContent, "Arm chairs\n");
		strcat(iMainContent, "Stools");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_COMFORT, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Comfort", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_DECO)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_DECORATIONS;
		strcat(iMainContent, "{FFFFFF}Curtains\n");
		strcat(iMainContent, "Flags\n");
		strcat(iMainContent, "Rugs\n");
		strcat(iMainContent, "Statues\n");
		strcat(iMainContent, "Towels\n");
		strcat(iMainContent, "Paintings\n");
		strcat(iMainContent, "Plants\n");
		strcat(iMainContent, "Posters");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_DECO, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Decorations", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_ENTERTAIN)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_ENTERTAINMENT;
		strcat(iMainContent, "{FFFFFF}Sporting Equpitment\n");
		strcat(iMainContent, "Televisions\n");
		strcat(iMainContent, "Video Gaming\n");
		strcat(iMainContent, "Media Players\n");
		strcat(iMainContent, "Stereos\n");
		strcat(iMainContent, "Speakers");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_ENTERTAIN, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Entertainment", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_LIGHTING)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_LIGHTING;
		strcat(iMainContent, "{FFFFFF}Lamps\n");
		strcat(iMainContent, "Wall mounted lighting\n");
		strcat(iMainContent, "Ceiling Lights\n");
		strcat(iMainContent, "Neon lights");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_LIGHTING, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Lighting", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_PLUMBING)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_PLUMBING;
		strcat(iMainContent, "{FFFFFF}Toilets\n");
		strcat(iMainContent, "Sinks\n");
		strcat(iMainContent, "Showers\n");
		strcat(iMainContent, "Bath Tubs");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_PLUMBING, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Plumbing", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_STORAGE)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_STORAGE;
		strcat(iMainContent, "{FFFFFF}Safes\n");
		strcat(iMainContent, "Book shelves\n");
		strcat(iMainContent, "Dressers\n");
		strcat(iMainContent, "Filling Cabinets\n");
		strcat(iMainContent, "Pantries");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_STORAGE, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Storage", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_SURFACE)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_SURFACES;
		strcat(iMainContent, "{FFFFFF}Dinning Tables\n");
		strcat(iMainContent, "Coffee Tables\n");
		strcat(iMainContent, "Counters\n");
		strcat(iMainContent, "Display Cabinets\n");
		strcat(iMainContent, "Display Shelves\n");
		strcat(iMainContent, "TV Stands");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_SURFACE, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Surfaces", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_CATE_SLCT_MISC)
	{
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = CATEGORY_MISCELLANEOUS;
		strcat(iMainContent, "{FFFFFF}Clothes\n");
		strcat(iMainContent, "Consumables\n");
		strcat(iMainContent, "Doors\n");
		strcat(iMainContent, "Mess\n");
		strcat(iMainContent, "Miscellaneous\n");
		strcat(iMainContent, "Pillars\n");
		strcat(iMainContent, "Security\n");
		strcat(iMainContent, "Office\n");
		strcat(iMainContent, "Toys");
		ShowPlayerDialog(playerid, DIALOG_CATE_SLCT_MISC, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Miscellaneous", iMainContent, "Select", "Back"); // send back to /house furniture
	}
	if(dialogid == DIALOG_FURNITURE_BUY)
	{
		new MainCate = PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT],
			SubCate = PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT];
		new cateSelect[40], subCateSelect[40];
		for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
		{
			if(FurnitureObjects[furSearch][furCategory] == MainCate && FurnitureObjects[furSearch][furSubCategory] == SubCate)
			{
				myStrcpy(cateSelect, FurnitureObjects[furSearch][furCategoryEx]);
				myStrcpy(subCateSelect, FurnitureObjects[furSearch][furSubCategoryEx]);
				break;
			}
		}
		strcat(iMainContent, "Name\tPrice\n");
		for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
		{
			if(FurnitureObjects[furSearch][furCategory] != MainCate) continue;
			if(FurnitureObjects[furSearch][furSubCategory] != SubCate) continue;
			format(iFormat, sizeof(iFormat), "{FFFFFF}%s\t{7ACC52}${FFFFFF}%s\n", FurnitureObjects[furSearch][furName], number_format(FurnitureObjects[furSearch][furPrice]));
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_BUY, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - House: {adc7e7}Furniture buy", iMainContent, "Buy", "Back");
	}
	if(dialogid == DIALOG_FURNITURE_LIST_OPTIONS)
	{
		strcat(iMainContent, "{FFFFFF} - Position\n");
		strcat(iMainContent, " - Rename\n");
		strcat(iMainContent, " - Sell\n");
		strcat(iMainContent, " - Materials{FFFF66} - Premium Only{FFFFFF}\n");
		strcat(iMainContent, " - Information");
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_LIST_OPTIONS, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Furniture Settings", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_FURNITURE_RENAME)
	{
		strcat(iMainContent, "In order for your furniture name change to be successful:\n");
		strcat(iMainContent, "\t\tKeep the character length below or at 40.\n");
		strcat(iMainContent, "\t\tDo not use less than 3 characters.");
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_RENAME, DIALOG_STYLE_INPUT, "{3196ef} - House: {adc7e7}Furniture Rename", iMainContent, "Rename", "Back");
	}
	if(dialogid == DIALOG_FURNITURE_POSITION)
	{
		strcat(iMainContent, "{FFFFFF} - Rotate X Angle - {FF9999}90{FFFFFF}\n");
		strcat(iMainContent, " - Rotate Y Angle - {FF9999}90{FFFFFF}\n");
		strcat(iMainContent, " - Rotate Z Angle - {FF9999}90{FFFFFF}\n");
		strcat(iMainContent, " - Custom movement ({FF9999}GUI{FFFFFF})");
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_POSITION, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Position Settings", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_FURNITURE_SELL)
	{
		new iID, currentObject = PlayerTemp[playerid][pFurnitureSelectID], houseid = extra;
		for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
		{
			if(FurnitureObjects[furSearch][furID] == FurnitureInfo[houseid][currentObject][furModel])
			{
				iID = furSearch;
				break;
			}
		}
		format(iFormat, sizeof(iFormat), "{FFFFFF}Category: {CCFFFF}%s\n", FurnitureObjects[iID][furCategoryEx]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{FFFFFF}Sub-Category: {CCFFFF}%s\n", FurnitureObjects[iID][furSubCategoryEx]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{FFFFFF}Item: {CCFFFF}%s\n", FurnitureObjects[iID][furName]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{FFFFFF}Price: {00FF00}${CCFFFF}%s\n", number_format(FurnitureObjects[iID][furPrice])); strcat(iMainContent, iFormat);
		new getback = (FurnitureObjects[iID][furPrice] / 4);
		format(iFormat, sizeof(iFormat), "{FFFFFF}Get back: {00FF00}${CCFFFF}%s", number_format(getback)); strcat(iMainContent, iFormat);
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_SELL, DIALOG_STYLE_MSGBOX, "{3196ef} - House: {adc7e7}Sell a furniture piece", iMainContent, "Sell", "Back");
	}
	if(dialogid == DIALOG_FURNITURE_MATERIAL)
	{
		if(PlayerInfo[playerid][premium] < 2) return SendClientError(playerid, "This is only available for level 2 donators and above.");
		strcat(iMainContent, "{FFFFFF} - Material Slot 1\n");
		strcat(iMainContent, " - Material Slot 2\n");
		strcat(iMainContent, " - Material Slot 3\n");
		strcat(iMainContent, " - Material Slot 4\n");
		strcat(iMainContent, " - Material Slot 5\n");
		strcat(iMainContent, " - Remove all materials");
		ShowPlayerDialog(playerid, DIALOG_FURNITURE_MATERIAL, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Furniture Material Management", iMainContent, "Select", "Exit");
	}
	if(dialogid == DIALOG_FURNIUTRE_INFO)
	{
		new currentObject = PlayerTemp[playerid][pFurnitureSelectID];
		new iID, houseid = extra;
		for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
		{
			if(FurnitureObjects[furSearch][furID] == FurnitureInfo[houseid][currentObject][furModel])
			{
				iID = furSearch;
				break;
			}
		}
		strcat(iMainContent, "{A3CCCC}----------------------------------------------------------------------------------\n\n");
		format(iFormat, sizeof(iFormat), "{CCFFFF}HouseID: \t\t{FFFFFF}%d\n", houseid); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{CCFFFF}SlotID: \t\t\t{FFFFFF}%d\n", currentObject); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{CCFFFF}ModelID: \t\t{FFFFFF}%d\n", FurnitureObjects[iID][furID]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{CCFFFF}Custom Name: \t{FFFFFF}%s\n", FurnitureInfo[houseid][currentObject][furName]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{CCFFFF}Dealer name: \t\t{FFFFFF}%s\n", FurnitureObjects[iID][furName]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{CCFFFF}Category: \t\t{FFFFFF}%s\n", FurnitureObjects[iID][furCategoryEx]); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{CCFFFF}Sub-Category: \t{FFFFFF}%s\n\n", FurnitureObjects[iID][furSubCategoryEx]); strcat(iMainContent, iFormat);
		strcat(iMainContent, "{A3CCCC}----------------------------------------------------------------------------------");
		ShowPlayerDialog(playerid, DIALOG_FURNIUTRE_INFO, DIALOG_STYLE_MSGBOX, "{3196ef} - House: {adc7e7}Furniture Information", iMainContent, "Back", "");
	}
	if(dialogid == DIALOG_MATERIAL_SELECTION)
	{
		strcat(iMainContent, "{FFFFFF} - Edit Colour\n");
		strcat(iMainContent, " - Edit Texture\n");
		strcat(iMainContent, " - Remove Material\n");
		strcat(iMainContent, " - Material Information");
		ShowPlayerDialog(playerid, DIALOG_MATERIAL_SELECTION, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Material Settings", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_GET_MATERIAL)
	{
		new lookingFor;
		if(GetPVarInt(playerid, "EditingWhat") == 1) lookingFor = MATERIAL_CATEGORY_COLOURS;
		else lookingFor = MATERIAL_CATEGORY_TEXTURE;
		for(new c = 0; c < sizeof(FurnitureMaterial); c++)
		{
			if(FurnitureMaterial[c][materialCategory] != lookingFor) continue;
			format(iFormat, sizeof(iFormat), "{FFFFFF} - %s\n", FurnitureMaterial[c][materialName]);
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_GET_MATERIAL, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Apply Material", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_WARDROBE)
	{
		new iZone[75], houseid = PlayerTemp[playerid][tmphouse];
		SetPVarInt(playerid, "WardrobeDialog", 1);
		GetZone(HouseInfo[houseid][hX],HouseInfo[houseid][hY],HouseInfo[houseid][hZ],iZone);
		strcat(iMainContent, "Slot\tStatus\n");
		for(new c = 0; c < 5; c++)
		{
			new iStatus[25];
			if(HouseInfo[houseid][hSkins][c] != -1) myStrcpy(iStatus, "{00B200}Active");
			else myStrcpy(iStatus, "{CC5252}Inactive");
			format(iFormat, sizeof(iFormat), "{FFFFFF} - Slot {D6D6C2}%d\t{FFFFFF}Current: %s\n", c+1, iStatus); strcat(iMainContent, iFormat);
		}
		format(iFormat, sizeof(iFormat), "{85A3FF} - Wardrobe Information\t\n"); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{85A3FF} - Remove skins from all slots!\t"); strcat(iMainContent, iFormat);
		ShowPlayerDialog(playerid, DIALOG_WARDROBE, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - House: {adc7e7}Wardrobe Management", iMainContent, "Select", "Exit");
	}
	if(dialogid == DIALOG_WARDROBE_OPTIONS)
	{
		new houseid = PlayerTemp[playerid][tmphouse], slotid = GetPVarInt(playerid, "WardrobeSlotSelect");
		slotid = slotid - 1;
		strcat(iMainContent, "Name\tStatus\n");
		new iStatus[15];
		if(HouseInfo[houseid][hSkins][slotid] != -1) myStrcpy(iStatus, "Not available"); else myStrcpy(iStatus, "Available");
		format(iFormat, sizeof(iFormat), "{FFFFFF} - Replace Skin\t%s\n", iStatus); strcat(iMainContent, iFormat);
		if(HouseInfo[houseid][hSkins][slotid] != -1) myStrcpy(iStatus, "Available"); else myStrcpy(iStatus, "Not available");
		format(iFormat, sizeof(iFormat), "{FFFFFF} - Switch Skin\t%s\n", iStatus); strcat(iMainContent, iFormat);
		format(iFormat, sizeof(iFormat), "{FFFFFF} - Remove Skin\t%s", iStatus); strcat(iMainContent, iFormat);
		ShowPlayerDialog(playerid, DIALOG_WARDROBE_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - House: {adc7e7}Wardrobe Categories", iMainContent, "Select", "Back");
	}
	if(dialogid == DIALOG_H_BASE_TEXTURES)
	{
		new iHouse = PlayerTemp[playerid][tmphouse];
		if(iHouse != -1)
		{
			new iCount, hInteriorEx = HouseInfo[iHouse][hInteriorPack];
			for(new c = 0; c < sizeof(HouseMaterialInfo); c++)
			{
				if(HouseMaterialInfo[c][hmLevel] != hInteriorEx) continue;
				iCount++;
			}
			if(iCount)
			{
				strcat(iMainContent, "Texture Slot\tTexture Description\n");
				for(new c = 0; c < sizeof(HouseMaterialInfo); c++)
				{
					if(HouseMaterialInfo[c][hmLevel] != hInteriorEx) continue;
					format(iFormat, sizeof(iFormat), "Slot %d:\t%s\n", HouseMaterialInfo[c][hmMaterialIndex]+1, HouseMaterialInfo[c][hmMaterialText]);
					strcat(iMainContent, iFormat);
				}
				strcat(iMainContent, "{B2D1E0}Reset All Texture Slots");
				ShowPlayerDialog(playerid, DIALOG_H_BASE_TEXTURES, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - House: {adc7e7}Texture Management", iMainContent, "Select", "Back");
			}
			else return SendClientWarning(playerid, "The textures for this house hasn't been configured yet.");
		}
		else return SendClientError(playerid, "You are no longer inside any house.");
	}
	if(dialogid == DIALOG_H_BASE_SELECTED)
	{
		new iHouse = PlayerTemp[playerid][tmphouse], iMaterialSelect = extra;
		if(iHouse != -1)
		{
			SetPVarInt(playerid, "HBaseTextureSlot", iMaterialSelect);
			strcat(iMainContent, "Edit Colour\n");
			strcat(iMainContent, "Remove Colour\n");
			strcat(iMainContent, "Edit Texture\n");
			strcat(iMainContent, "Remove Texture\n");
			strcat(iMainContent, "Texture Information");
			ShowPlayerDialog(playerid, DIALOG_H_BASE_SELECTED, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Texture Categories", iMainContent, "Select", "Back");
		}
		else return SendClientError(playerid, "You are no longer inside any house.");
	}
	if(dialogid == DIALOG_H_BASE)
	{
		new iHouse = PlayerTemp[playerid][tmphouse], iMaterialSelect = GetPVarInt(playerid, "HBaseEditTexture");
		if(iHouse != -1)
		{
			new lookingFor;
			if(iMaterialSelect == 1) lookingFor = MATERIAL_CATEGORY_TEXTURE;
			else if(iMaterialSelect == 2) lookingFor = MATERIAL_CATEGORY_COLOURS;
			for(new c = 0; c < sizeof(FurnitureMaterial); c++)
			{
				if(FurnitureMaterial[c][materialCategory] != lookingFor) continue;
				format(iFormat, sizeof(iFormat), "{FFFFFF} - %s\n", FurnitureMaterial[c][materialName]);
				strcat(iMainContent, iFormat);
			}
			ShowPlayerDialog(playerid, DIALOG_H_BASE, DIALOG_STYLE_LIST, "{3196ef} - House: {adc7e7}Apply Texture", iMainContent, "Select", "Back");
		}
		else return SendClientError(playerid, "You are no longer inside any house.");
	}
	if(dialogid == DIALOG_WHATS_NEW)
	{
		new iTitle[64];
		format(iTitle, sizeof(iTitle), "{3196ef} - What's new?: {adc7e7}%s(V%s) | Build: %s | %s\n", SERVER_GM, CURRENT_VERSION, CURRENT_BUILD, CURRENT_DEVELOPER);
		strcat(iMainContent, "----------------------------------------------------------------------\n\n");
		strcat(iMainContent, "\n\n----------------------------------------------------------------------");
		ShowPlayerDialog(playerid, DIALOG_WHATS_NEW, DIALOG_STYLE_MSGBOX, iTitle, iMainContent, "Awesome", "");
	}
	if(dialogid == DIALOG_TRUCKER_SLCT)
	{
		strcat(iMainContent, "Cargo\t"); strcat(iMainContent, "Desination\t"); strcat(iMainContent, "Reward\n");
		LOOP:i(0, sizeof(deliver))
		{
			new iZone[75];
			GetZone(deliver[i][deliverX], deliver[i][deliverY], deliver[i][deliverZ], iZone);

			format(iFormat, sizeof(iFormat), "%s\t", deliver[i][deliverCargo]);
			strcat(iMainContent, iFormat);

			format(iFormat, sizeof(iFormat), "%s\t", iZone);
			strcat(iMainContent, iZone);

			new Float:dist = GetPlayerDistanceToPointEx(playerid, deliver[i][deliverX], deliver[i][deliverY], deliver[i][deliverZ]);
			new distReal = floatround(dist);
			format(iFormat, sizeof(iFormat), "$%s\n", number_format(distReal * 5));
			strcat(iMainContent, iFormat);
		}
		ShowPlayerDialog(playerid, DIALOG_TRUCKER_SLCT, DIALOG_STYLE_TABLIST_HEADERS, "{3196ef} - Trucker: {adc7e7}Select a Delivery Job!", iMainContent, "Select", "Cancel");
	}
	return 1;
}