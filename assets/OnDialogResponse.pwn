/*********************************************************************************************************************************************
						- NYOGames [OnDialogResponse.pwn file]
*********************************************************************************************************************************************/
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_REGISTER)
	{
		if(response) return RegisterResponse(playerid, inputtext), 1;
		else Kick(playerid);
	}
	if(dialogid == DIALOG_LOGIN)
	{
		if(response) return LoginResponse(playerid, inputtext), 1;
		else Kick(playerid);
	}
	if(dialogid == DIALOG_SMS)
	{
		if(response)
		{
			new smsprice = dini_Int(globalstats,"sms");
			new msg[MAX_STRING], sms[MAX_STRING], giveplayerid = PlayerTemp[playerid][playertosms], message[MAX_STRING];
			format(msg,sizeof(msg),"~w~sms sent~n~cost: ~b~%d",smsprice);
			GameTextForPlayer(playerid,msg,3000,1);
			GivePlayerMoneyEx(playerid,-smsprice);
			
			new iHead[75];
			
			format(iHead, sizeof(iHead), "SMS from %s(%d):",RPName(playerid),PlayerInfo[playerid][phonenumber]);
			format(sms, MAX_STRING,"SMS from %s(%d): %s",RPName(playerid),PlayerInfo[playerid][phonenumber],inputtext);
			SendPlayerMessage(giveplayerid, COLOR_PLAYER_DARKYELLOW, sms, iHead);
			
			
			format(iHead, sizeof(iHead), "SMS sent to %s(%d):",RPName(giveplayerid),PlayerInfo[giveplayerid][phonenumber]);
			format(sms, MAX_STRING,"SMS sent to %s(%d): %s",RPName(giveplayerid),PlayerInfo[giveplayerid][phonenumber], inputtext);
			SendPlayerMessage(playerid, COLOR_PLAYER_DARKYELLOW, sms, iHead);
			
    		PlayerPlaySound(giveplayerid,SOUND_CHECKPOINT_AMBER,0.0, 0.0, 0.0);
    		for(new i; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i) && PlayerTemp[i][adminspy] == 1)
				{
				    format(message, MAX_STRING, "(/sms) %s to %s: %s", PlayerName(playerid), PlayerName(PlayerTemp[playerid][playertosms]), inputtext);
				    SendClientMessage(i, COLOR_LIGHTGREY, message);
				}
			}
			format( message, MAX_STRING, "7[SMS] %s[%d] to %s[%d]: %s",PlayerName(playerid), playerid, PlayerName(PlayerTemp[playerid][playertosms]), PlayerTemp[playerid][playertosms], inputtext);
			iEcho( message );
			PlayerTemp[playerid][playertosms] = 666;

	    	new bizID = GetClosestBiz(playerid, BUSINESS_TYPE_PHONE);
	    	BusinessInfo[bizID][bTill] += smsprice;
			return 1;
		}
	}
	if(dialogid == DIALOG_911)
	{
		if(response)
		{	   
			if(strlen(inputtext) < 10) return SendClientMessage(playerid, COLOR_PLAYER_SPECIALBLUE, "* 911 Landline: Please tell us some more details. (min. 10 chars)");
			new string[MAX_STRING];
			new zone[ 60 ];
			GetPlayer3DZone(playerid, zone, sizeof(zone));
			if(GetPlayerInterior(playerid)) myStrcpy(zone, "Unknown (( Interior ))");
			new Float:px, Float:py, Float:pz;
			GetPlayerPos(playerid, px, py, pz);
			PlayerLoop(i)
			{
				if(IsPlayerENF(i))
				{
					SendClientMessage(i, COLOR_PLAYER_SPECIALBLUE, "======== [ EMERGENCY CALL ] ========");
					SendClientMSG(i, COLOR_WHITE, " Caller: %s				Number: %d", MaskedName(playerid), PlayerInfo[playerid][phonenumber]);
					SendClientMSG(i, COLOR_WHITE, " Traced location: %s", zone);
					SendClientMSG(i, COLOR_WHITE, " Incident: %s", inputtext);
					SendClientMessage(i, COLOR_PLAYER_SPECIALBLUE, "======================================");
					PlayerPlaySound(i,1056,0.0,0.0,0.0);
					if(GetPlayerInterior(playerid) == 0) SetPlayerCheckpoint(i,px,py,pz,3);
				}
			}
			SetPlayerSpecialAction(playerid,13);
			format(string,sizeof(string),"(Phone) %s says: %s", MaskedName(playerid), inputtext);
			ProxDetectorEx(20.0, playerid, string);
			SendClientMessage(playerid, COLOR_PLAYER_SPECIALBLUE, "* 911 Landline: Thank you for your call, have a nice day!");
			return true;
		}
	}
	if(dialogid == DIALOG_AD)
	{
		if(response)
		{	
			if(strlen(inputtext) < 5 || strlen(inputtext) > 96)
				return SendClientError(playerid, "The advertisement is too short or too long! (Min 5, Max 96 chars)");
			if(strfind(inputtext, "~") != -1)
				return SendClientError(playerid, "You tried to use an invalid character!");
			new adPrice = (strlen(inputtext) * dini_Int(globalstats, "ad"));
			new iQuery[428];
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `Advertisements` (`PlayerName`, `Message`, `DateTime`, `Active`, `Price`, `PhoneNumber`, `Type`) VALUES ('%e', '%e', '%e', 1, %d, %d, 1)", PlayerName(playerid), inputtext, TimeDateEx(), adPrice, PlayerInfo[playerid][phonenumber]);
			mysql_tquery(MySQLPipeline, iQuery);
			format( iStr, sizeof(iStr), "3{ Advertisement } %s[%d]: %s",PlayerName(playerid), playerid, inputtext);
			iEcho( iStr );
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `Price` FROM `Advertisements` WHERE `Active` = 1");
			new Cache:result = mysql_query(MySQLPipeline, iQuery);
			new rows = cache_num_rows();
			cache_delete(result);
			rows = (rows * 2);
			new iFormat[128];
			format(iFormat, sizeof(iFormat), " Your advertisement will appear in approximately %d minute(s). {D13F3F}(Price: $%s)", rows, number_format(adPrice));
			SendClientMessage(playerid, COLOR_LIGHTGREY, iFormat);
			SendClientMessage(playerid, COLOR_LIGHTGREY, " Use \"/deletead\" if you would like to delete your pending advertisement.");
		}
	}
	if(dialogid == DIALOG_CAD)
	{
		if(response)
		{
			if(strlen(inputtext) < 5 || strlen(inputtext) > 96)
				return SendClientError(playerid, "The advertisement is too short or too long! (Min 5, Max 96 chars)");
			if(strfind(inputtext, "~") != -1)
				return SendClientError(playerid, "You tried to use an invalid character!");
			new adPrice = (strlen(inputtext) * dini_Int(globalstats, "ad")) * 2;
			new iQuery[428];
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `Advertisements` (`PlayerName`, `Message`, `DateTime`, `Active`, `Price`, `PhoneNumber`, `Type`) VALUES ('%e', '%e', '%e', 1, %d, %d, 2)", PlayerName(playerid), inputtext, TimeDateEx(), adPrice, PlayerInfo[playerid][phonenumber]);
			mysql_tquery(MySQLPipeline, iQuery);
			format( iStr, sizeof(iStr), "3{ Company Advertisement } %s[%d]: %s",PlayerName(playerid), playerid, inputtext);
			iEcho( iStr );
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `Price` FROM `Advertisements` WHERE `Active` = 1");
			new Cache:result = mysql_query(MySQLPipeline, iQuery);
			new rows = cache_num_rows();
			cache_delete(result);
			rows = (rows * 2);
			new iFormat[128];
			format(iFormat, sizeof(iFormat), " Your company advertisement will appear in approximately %d minute(s). {D13F3F}(Price: $%s)", rows, number_format(adPrice));
			SendClientMessage(playerid, COLOR_LIGHTGREY, iFormat);
			SendClientMessage(playerid, COLOR_LIGHTGREY, " Use \"/deletead\" if you would like to delete your pending advertisement.");
		}
	}
	if (dialogid == DIALOG_GUNSTORE)
    {
        if(response)
        {
            new tmpid = IsPlayerInBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_GUNSTORE && GetPlayerVirtualWorld(playerid) == tmpid+1)
			{
				new iPrice;
				if(GunStoreInfo[listitem][gsweapID] == WEAPON_DEAGLE) iPrice = BusinessInfo[tmpid][bDeagle];
				else if(GunStoreInfo[listitem][gsweapID] == WEAPON_MP5) iPrice = BusinessInfo[tmpid][bMP5];
				else if(GunStoreInfo[listitem][gsweapID] == WEAPON_M4) iPrice = BusinessInfo[tmpid][bM4];
				else if(GunStoreInfo[listitem][gsweapID] == WEAPON_SHOTGUN) iPrice = BusinessInfo[tmpid][bM4];
				else if(GunStoreInfo[listitem][gsweapID] == WEAPON_SNIPER) iPrice = BusinessInfo[tmpid][bSniper];
				else if(GunStoreInfo[listitem][gsweapID] == WEAPON_RIFLE) iPrice = BusinessInfo[tmpid][bRifle];
				else iPrice = BusinessInfo[tmpid][bArmour];
				if(HandMoney(playerid) < iPrice) return SendClientError(playerid, "You don't have enough money");
				BusinessInfo[tmpid][bComps] -= GunStoreInfo[listitem][gsComps];
				BusinessInfo[tmpid][bTill] += iPrice;
				GivePlayerMoneyEx(playerid, -iPrice);
				if(GunStoreInfo[listitem][gsweapID] != -1) GivePlayerWeaponEx(playerid, GunStoreInfo[listitem][gsweapID], GunStoreInfo[listitem][gsweapAmmo]);
				else SetPlayerArmour(playerid, 99);
				new string[ 128 ];
				ShowDialog(playerid, DIALOG_GUNSTORE, tmpid);
				format(string, sizeof(string), "3{ WEAPON } %s has bought a weapon: %s.", PlayerName(playerid), GunStoreInfo[listitem][gsweapName]);
				iEcho(string);
				PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
				PlayerTemp[playerid][totalguns]++;
	            return 1;
			}
			else return SendClientError(playerid, "You have left the ammunation!");
        }
    }
    if(dialogid == DIALOG_HELPME)
	{
		if(response)
		{
			new string[ 128 ], tmp[ 64 ];
			switch(listitem)
			{
				case 0: // City Hall
				{
					SetPlayerCheckpoint(playerid, 1481.0364,-1771.6887,18.7958, 3.0), myStrcpy(tmp, "City Hall");
				}
				case 1: // Trucker Department
				{
					SetPlayerCheckpoint(playerid, 2215.2393,-2653.8948,13.5469, 3.0), myStrcpy(tmp, "Trucker Department");
				}
				case 2: // Mechanic Department
				{
					SetPlayerCheckpoint(playerid, 2315.8699,-2310.3445,13.5469, 3.0), myStrcpy(tmp, "Mechanic Department");
				}
				case 3: // Farm
				{
					SetPlayerCheckpoint(playerid, -67.4851,28.3133,3.1172, 3.0), myStrcpy(tmp, "Farm");
				}
				case 4: // Car Jacker
				{
					SetPlayerCheckpoint(playerid, 1940.5886,-2032.5803,13.5469, 3.0), myStrcpy(tmp, "Car Jacker");
				}
				case 5: // Thief
				{
					SetPlayerCheckpoint(playerid, 2231.5581,-2414.6013,13.5469, 3.0), myStrcpy(tmp, "Thief");
				}
				case 6: // Quarry
				{
					SetPlayerCheckpoint(playerid, 499.3271,889.2720,-32.5264, 3.0), myStrcpy(tmp, "Quarry");
				}
				case 7: // Licensing Department
				{
					SetPlayerCheckpoint(playerid, 1248.0679,-1560.4337,13.5635, 3.0), myStrcpy(tmp, "Licensing Department");
				}
				case 8: // Vehicle Registration
				{
					new bizID = GetClosestBiz(playerid, BUSINESS_TYPE_VREGISTER);
					if(bizID != -1)
					{
						SetPlayerCheckpoint(playerid, 1481.0364,-1771.6887,18.7958, 3.0), myStrcpy(tmp, "Vehicle Registration");
					}
					else return ShowDialog(playerid, DIALOG_HELPME), 1;
				}
				case 9: // Vehicle Carlot
				{
					SetPlayerCheckpoint(playerid, 1654.0059,-1103.2327,23.9063, 3.0), myStrcpy(tmp, "Vehicle Carlot");
				}
				case 10: // Dealership carlot
				{
					SetPlayerCheckpoint(playerid, 349.2231,-1787.4951,5.2080, 3.0), myStrcpy(tmp, "Dealership Carlot");
				}
				case 11: // Closest Hotel
				{
					new bizID = GetClosestBiz(playerid, BUSINESS_TYPE_HOTEL);
					if(bizID != -1)
					{
						SetPlayerCheckpoint(playerid, 1481.0364,-1771.6887,18.7958, 3.0), myStrcpy(tmp, "Closest Hotel");
					}
					else return ShowDialog(playerid, DIALOG_HELPME), 1;
				}
				case 12: // Closest Appartment Complex
				{
					new bizID = GetClosestBiz(playerid, BUSINESS_TYPE_APPARTMENT);
					if(bizID != -1)
					{
						SetPlayerCheckpoint(playerid, 1481.0364,-1771.6887,18.7958, 3.0), myStrcpy(tmp, "Closest Appartment Complex");
					}
					else return ShowDialog(playerid, DIALOG_HELPME), 1;
				}
				case 13: // LS Police Department
				{
					SetPlayerCheckpoint(playerid, 1554.4497,-1675.5128,16.1953, 3.0), myStrcpy(tmp, "LS Police Department");
				}
				case 14: // SA Sherrif Department
				{
					SetPlayerCheckpoint(playerid, 626.9645,-571.7696,17.9207, 3.0), myStrcpy(tmp, "SA Sherrif Department");
				}
				case 15: // Los Santos GYM
				{
					SetPlayerCheckpoint(playerid, 2229.4783,-1721.5369,13.5637, 3.0), myStrcpy(tmp, "LS GYM");
				}
			}
			format(string, sizeof(string), "~r~GPS:~w~ %s", tmp);
			GameTextForPlayer(playerid, string, 5000, 1);
			return 1;
		}
	}
	if(dialogid == DIALOG_DRUGSTORE)
	{
		if(response)
		{
			new tmpid = IsPlayerInBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_DRUGSTORE && GetPlayerVirtualWorld(playerid) == tmpid+1)
			{
				new string[ 128 ];
				format(string, sizeof(string), "DRUGS: You have bought 1 gram of %s for $%d.", drugtypes[listitem][drugname], drugtypes[listitem][drugprice]);
				SendClientInfo(playerid, string);
				PlayerInfo[ playerid ][ hasdrugs ][ listitem ] += 1;

				GivePlayerMoneyEx(playerid, -drugtypes[listitem][drugprice]);
				BusinessInfo[tmpid][bTill] += (drugtypes[listitem][drugprice] * 3);

				new iString[ 192 ], tmps[ 40 ];
				for(new c; c < sizeof(drugtypes); c++)
				{
					format(tmps,sizeof(tmps),"%s ($%d/gram)\n",drugtypes[c][drugname], drugtypes[c][drugprice]);
					strcat(iString,tmps);
				}
				ShowPlayerDialog(playerid, DIALOG_DRUGSTORE, DIALOG_STYLE_LIST, "Drug Store", iString, "Buy", "Cancel");
				return 1;
			}
			else return SendClientError(playerid, "You have left the drug store.");
		}
	}
	if(dialogid == DIALOG_BIKE_DEALERSHIP)
	{
		if(response)
		{
			new tmpid = IsPlayerOutBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BIKE_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < bikes[listitem][bikeprice]) return SendClientError(playerid, "Not enough cash!");
				new string[ 128 ];
				format(string, sizeof(string), "Dealership: You have bought a %s for $%s! Enter it and park it! (/car help)", bikes[listitem][bikename], number_format(bikes[listitem][bikeprice]));
				SendClientInfo(playerid, string);
				GivePlayerMoneyEx(playerid, -bikes[listitem][bikeprice]);
				BusinessInfo[tmpid][bTill] += bikes[listitem][bikeprice]/4;
				BusinessInfo[tmpid][bComps]--;
				
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), bikes[listitem][bikemodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), bikes[listitem][bikename], number_format(bikes[listitem][bikeprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
			else return SendClientError(playerid, "You have left the bike dealership.");
		}
	}
	if(dialogid == DIALOG_CAR_DEALERSHIP)
	{
		if(response)
		{
			new tmpid=IsPlayerOutBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_CAR_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < cars_normal[listitem][cccarprice]) return SendClientError(playerid, "Not enough cash!");
				new string[ 128 ];
				format(string, sizeof(string), "Dealership: You have bought a %s for $%s! Enter it and park it! (/car help)", cars_normal[listitem][cccarname], number_format(cars_normal[listitem][cccarprice]));
				SendClientInfo(playerid, string);
				GivePlayerMoneyEx(playerid, -cars_normal[listitem][cccarprice]);
				BusinessInfo[tmpid][bTill] += cars_normal[listitem][cccarprice]/4;
				BusinessInfo[tmpid][bComps]--;
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), cars_normal[listitem][cccarmodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), cars_normal[listitem][cccarname], number_format(bikes[listitem][bikeprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
			else return SendClientError(playerid, "You have left the vehicle dealership.");
		}
	}
	if(dialogid == DIALOG_LUXUS_DEALERSHIP)
	{
		if(response)
		{
			new tmpid=IsPlayerOutBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_LUXUS_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < cars_luxus[listitem][cccarprice]) return SendClientError(playerid, "Not enough cash!");
				new string[ 128 ];
				format(string, sizeof(string), "Dealership: You have bought a %s for $%s! Enter it and park it! (/car help)", cars_luxus[listitem][cccarname], number_format(cars_luxus[listitem][cccarprice]));
				SendClientInfo(playerid, string);
				GivePlayerMoneyEx(playerid, -cars_luxus[listitem][cccarprice]);
				BusinessInfo[tmpid][bTill] += cars_luxus[listitem][cccarprice]/4;
				BusinessInfo[tmpid][bComps]--;
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), cars_luxus[listitem][cccarmodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), cars_luxus[listitem][cccarname], number_format(cars_luxus[listitem][cccarprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
			else return SendClientError(playerid, "You have left the luxus dealership.");
		}
	}
	if(dialogid == DIALOG_FOODSTORE)
	{
		if(response)
		{
			new tmpid = IsPlayerInBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_RESTAURANT && GetPlayerVirtualWorld(playerid) == tmpid+1)
			{
				new string[ 128 ];
				format(string, sizeof(string), "FOOD: You have bought %s for $%d!", foodtypes[listitem][foodname], foodtypes[listitem][foodprice]);
				SendClientInfo(playerid, string);
				format(string, sizeof(string), "3{ %s } %s has bought food: %s [-$%s].", BusinessInfo[tmpid][bName], PlayerName(playerid), foodtypes[listitem][foodname], number_format(foodtypes[listitem][foodprice]));
				iEcho(string);
				GivePlayerMoneyEx(playerid, -foodtypes[listitem][foodprice]);
				new Float:pH;
				GetPlayerHealth(playerid, pH);
				if(pH < 100) SetPlayerHealth(playerid, pH+foodtypes[listitem][foodhp]);
				BusinessInfo[tmpid][bTill] += foodtypes[listitem][foodprice];
				return 1;
			}
			else return SendClientError(playerid, "You have left the resaurant.");
		}
	}
	if(dialogid == DIALOG_GIVEGUN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 3, 1);
					GivePlayerWeaponEx(playerid, 41, 500);
					GivePlayerWeaponEx(playerid, 24, 150);
					GivePlayerWeaponEx(playerid, 25, 80);
					GivePlayerWeaponEx(playerid, 29, 400);
					GivePlayerWeaponEx(playerid, 31, 500);
					if(PlayerInfo[playerid][ranklvl] < 2) GivePlayerWeaponEx(playerid, 34, 100);
				}
				case 1: GivePlayerWeaponEx(playerid, 3, 1);
				case 2: GivePlayerWeaponEx(playerid, 41, 500);
				case 3: GivePlayerWeaponEx(playerid, 24, 150); // DGL
				case 4: GivePlayerWeaponEx(playerid, 25, 80);
				case 5: GivePlayerWeaponEx(playerid, 29, 400);
				case 6: GivePlayerWeaponEx(playerid, 31, 500);
				case 7: if(PlayerInfo[playerid][ranklvl] < 2) GivePlayerWeaponEx(playerid, 34, 100);
				case 8: GivePlayerWeaponEx(playerid, 46, 1);
				case 9: GivePlayerWeaponEx(playerid, 43, 1);
			}
			ShowDialog(playerid, DIALOG_GIVEGUN);
		}
	    return 1;
	}
	if(dialogid == DIALOG_NOOB_DEALERSHIP)
	{
		if(response)
		{
			new tmpid=IsPlayerOutBiz(playerid);
			if(tmpid!=-1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_NOOB_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < noobcars[listitem][noobcprice]) return SendClientError(playerid, "Not enough cash!");

				new string[ 128 ];
				format(string, sizeof(string), "Dealership: You have bought a %s for $%s! Enter it and park it! (/car help)", noobcars[listitem][noobcname], number_format(noobcars[listitem][noobcprice]));
				SendClientInfo(playerid, string);

				GivePlayerMoneyEx(playerid, -noobcars[listitem][noobcprice]);
				BusinessInfo[tmpid][bTill] += noobcars[listitem][noobcprice]/2;
				BusinessInfo[tmpid][bComps]--;
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), noobcars[listitem][noobcmodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), noobcars[listitem][noobcname], number_format(bikes[listitem][bikeprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_AIR_DEALERSHIP)
	{
		if(response)
		{
			new tmpid=IsPlayerOutBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_AIR_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < aircars[listitem][airprice]) return SendClientError(playerid, "Not enough cash!");

				new string[ 128 ];
				format(string, sizeof(string), "Dealership: You have bought a %s for R%s! Enter it and park it! (/car help)", aircars[listitem][airname], number_format(aircars[listitem][airprice]));
				SendClientInfo(playerid, string);
				
				GivePlayerMoneyEx(playerid, -aircars[listitem][airprice]);
				BusinessInfo[tmpid][bTill] += aircars[listitem][airprice]/4;
				BusinessInfo[tmpid][bComps]--;
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), aircars[listitem][airmodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), aircars[listitem][airname], number_format(bikes[listitem][bikeprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_BOAT_DEALERSHIP)
	{
		if(response)
		{
			new tmpid=IsPlayerOutBiz(playerid);
			if(tmpid!=-1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BOAT_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < watercars[listitem][boatprice]) return SendClientError(playerid, "Not enough cash!");

				new string[ 128 ];
				format(string, sizeof(string), "Dealership: You have bought a %s for $%s! Enter it and park it! (/car help)", watercars[listitem][boatname], number_format(watercars[listitem][boatprice]));
				SendClientInfo(playerid, string);

				GivePlayerMoneyEx(playerid, -watercars[listitem][boatprice]);
				BusinessInfo[tmpid][bTill] += watercars[listitem][boatprice]/4;
				BusinessInfo[tmpid][bComps]--;
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), watercars[listitem][boatmodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), watercars[listitem][boatname], number_format(watercars[listitem][boatprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_LAPTOP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, "You can't see any news as a civilian!");
					SendClientMessage(playerid, COLOR_HELPEROOC, ":: Faction News ::");
					new factionID = PlayerInfo[playerid][playerteam];
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #1] {FFFFFF}%s.", FactionInfo[factionID][fNews1]);
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #2] {FFFFFF}%s.", FactionInfo[factionID][fNews2]);
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #3] {FFFFFF}%s.", FactionInfo[factionID][fNews3]);
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #4] {FFFFFF}%s.", FactionInfo[factionID][fNews4]);
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #5] {FFFFFF}%s.", FactionInfo[factionID][fNews5]);
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #6] {FFFFFF}%s.", FactionInfo[factionID][fNews6]);
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #7] {FFFFFF}%s.", FactionInfo[factionID][fNews7]);
					SendClientMSG(playerid, COLOR_LIGHTGREY, "[News #8] {FFFFFF}%s.", FactionInfo[factionID][fNews8]);
				}
				case 1:
				{
					if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, "You can't see faction members as a civilian!");
					OnPlayerCommandText(playerid, "/fon");
				}
				case 2:
				{
					if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, "You can't call for backup as a civilian!");
					if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return SendClientError(playerid, "You can't use this while inside a business / house / garage.");
					new Float:px,Float:py,Float:pz;
					GetPlayerPos(playerid,px,py,pz);
					new zone[ 60 ];
					GetPlayer3DZone(playerid, zone, sizeof(zone));
					new message[ 92 ];
					format(message,sizeof(message),"[BACKUP] %s is asking for backup at %s!",RPName(playerid), zone);
					SendClientMessageToTeam(PlayerInfo[playerid][playerteam],message,COLOR_ORANGE);
					PlayerLoop(i2)
					{
						if(PlayerInfo[i2][playerteam]==PlayerInfo[playerid][playerteam]) SetPlayerCheckpoint(i2,px,py,pz,8);
					}
				}
				case 3:
				{
					new message[MAX_STRING];
					new drugstock = dini_Int(compsfile,"drugs");
					new gunstock = dini_Int(compsfile,"guns");
					new alchoolstock = dini_Int(compsfile,"alchool");
					new stuffstock = dini_Int(compsfile,"stuffs");
					new carstock = dini_Int(compsfile,"cars");
					format(message, sizeof(message),"\
					~y~Guns: ~w~%d~n~\
					~y~Drugs: ~w~%d~n~\
					~y~Carparts: ~w~%d~n~\
					~y~Stuffs: ~w~%d~n~\
					~y~Alcohol: ~w~%d~n~\
					~y~FGuns: ~w~ %d~n~\
					~y~FBullets:~w~ %d~n~",gunstock, drugstock, carstock, stuffstock, alchoolstock, dini_Int(compsfile, "fgunstock"), dini_Int(compsfile, "fgunbullets"));
					ShowInfoBox(playerid, "Quarry Stock", message);
				}
				case 4:
				{
					if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, "You can't see any members as civilian!");
					OnPlayerCommandText(playerid, "/finfo");
				}
				case 5:
				{
					OnPlayerCommandText(playerid, "/warinfo");
				}
				case 6:
				{
					ShowDialog(playerid, DIALOG_WIRETRANSFER_NAME);
				}
				case 7:
				{
					ShowDialog(playerid, DIALOG_LATEST_SMS_CALLS_ADS);
				}
			}
		}
	    return 1;
	}
	if (dialogid == DIALOG_HARDWARE) // Hardware
    {
        if(response)
        {
            new tmpid=IsPlayerInBiz(playerid), string[ 128 ];
			if(tmpid!=-1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_HARDWARE && GetPlayerVirtualWorld(playerid) == tmpid+1)
			{
				new wat[ 20 ];
	            switch (listitem)
	            {
	                case 0:
					{
					    SetPVarInt(playerid, "HasRope", GetPVarInt(playerid, "HasRope")+1);
						GivePlayerMoneyEx(playerid,-5000);
						BusinessInfo[tmpid][bTill] += 5000;
						myStrcpy(wat, "Rope");
					}
					case 1:
					{
					    SetPVarInt(playerid, "HasRag", GetPVarInt(playerid, "HasRag")+1);
						GivePlayerMoneyEx(playerid,-3000);
						BusinessInfo[tmpid][bTill] += 3000;
						myStrcpy(wat, "Rag");
					}
					case 2:
					{
					    SetPVarInt(playerid, "Toolkit", GetPVarInt(playerid, "Toolkit")+1);
						GivePlayerMoneyEx(playerid,-2000);
						BusinessInfo[tmpid][bTill] += 2000;
						myStrcpy(wat, "Toolkit");
					}
					case 3:
					{
						GivePlayerWeaponEx(playerid,WEAPON_SHOVEL,-1);
						GivePlayerMoneyEx(playerid,-200);
						BusinessInfo[tmpid][bTill] += 200;
						myStrcpy(wat, "Shovel");
					}
					case 4:
					{
						GivePlayerWeaponEx(playerid,WEAPON_CHAINSAW,-1);
						GivePlayerMoneyEx(playerid,-5000);
						BusinessInfo[tmpid][bTill] += 5000;
						myStrcpy(wat, "Chainsaw");
					}
					case 5:
					{
						GivePlayerWeaponEx(playerid,41, 300);
						GivePlayerMoneyEx(playerid,-2000);
						BusinessInfo[tmpid][bTill] += 2000;
						myStrcpy(wat, "Spraycan");
					}
				}
				if(!strcmp(wat, "Rope")) SendClientMessage(playerid, COLOR_YELLOW, "[Hardware Store] Use /tie to tie up people in your vehicle.");
				else if(!strcmp(wat, "Rag")) SendClientMessage(playerid, COLOR_YELLOW, "[Hardware Store] Use /blindfold to blindfold tied up people in your car.");
				else if(!strcmp(wat, "Toolkit")) SendClientMessage(playerid, COLOR_YELLOW, "[Hardware Store] Use /toolkit nearby a locked car to picklock it!");
				else
				{
					new iFormat[128];
					format(iFormat, sizeof(iFormat), "[Hardware Store] Item bought: %s!", wat);
					SendClientMessage(playerid, COLOR_YELLOW, iFormat);
				}
				format(string, sizeof(string), "3{ Hardware } %s has bought an item: %s.", PlayerName(playerid), wat);
				iEcho(string);
			}
		}
	}
	if (dialogid == DIALOG_247) // 24/7
    {
        if (response)
        {
            new tmpid=IsPlayerInBiz(playerid), string[ 128 ];
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_247 && GetPlayerVirtualWorld(playerid) == tmpid+1)
			{
				new wat[ 20 ];
	            switch (listitem)
	            {
					case 0:
					{
						if(PlayerTemp[playerid][sm] < 2000) return SendClientError(playerid, "You need atleast $2,000 to buy a camera.");
						GivePlayerWeaponEx(playerid,WEAPON_CAMERA,20);
						GivePlayerMoneyEx(playerid,-2000);
						BusinessInfo[tmpid][bTill] += 2000;
						myStrcpy(wat, "Camera");
					}
					case 1:
					{
						if(PlayerTemp[playerid][sm] < 5000) return SendClientError(playerid, "You need atleast $5,000 to buy a laptop.");
						PlayerInfo[playerid][laptop]=1;
						GivePlayerMoneyEx(playerid,-5000);
						BusinessInfo[tmpid][bTill] += 5000;
						myStrcpy(wat, "Laptop");
					}
					case 2:
					{
						if(PlayerTemp[playerid][sm] < 50) return SendClientError(playerid, "You need atleast $50 to buy a golf club.");
						GivePlayerWeaponEx(playerid,WEAPON_GOLFCLUB,-1);
						GivePlayerMoneyEx(playerid,-50);
						BusinessInfo[tmpid][bTill] += 50;
						myStrcpy(wat, "Golfclub");
					}
					case 3:
					{
						if(PlayerTemp[playerid][sm] < 200) return SendClientError(playerid, "You need atleast $200 to buy a pool stick.");
						GivePlayerWeaponEx(playerid,WEAPON_POOLSTICK,-1);
						GivePlayerMoneyEx(playerid,-200);
						BusinessInfo[tmpid][bTill] += 200;
						myStrcpy(wat, "Poolstick");
					}
					case 4:
					{
						if(PlayerTemp[playerid][sm] < 80) return SendClientError(playerid, "You need atleast $80 to buy a cane.");
                        GivePlayerWeaponEx(playerid,WEAPON_CANE,-1);
						GivePlayerMoneyEx(playerid,-80);
						BusinessInfo[tmpid][bTill] += 80;
						myStrcpy(wat, "Cane");
					}
					case 5:
					{
						if(PlayerTemp[playerid][sm] < 1000) return SendClientError(playerid, "You need atleast $1,000 to buy a fire extinguisher.");
                        GivePlayerWeaponEx(playerid,WEAPON_FIREEXTINGUISHER,200);
						GivePlayerMoneyEx(playerid,-1000);
						BusinessInfo[tmpid][bTill] += 1000;
						myStrcpy(wat, "Fire Extinguisher");
					}
					case 6:
					{
						if(PlayerTemp[playerid][sm] < 100) return SendClientError(playerid, "You need atleast $100 to buy a dildo.");
                        GivePlayerWeaponEx(playerid,WEAPON_DILDO2,-1);
						GivePlayerMoneyEx(playerid,-100);
						BusinessInfo[tmpid][bTill] += 100;
						myStrcpy(wat, "Dildo");
					}
					case 7:
					{
						if(PlayerTemp[playerid][sm] < 1000) return SendClientError(playerid, "You need atleast $1,000 to buy a katana.");
                        GivePlayerWeaponEx(playerid,WEAPON_KATANA,-1);
						GivePlayerMoneyEx(playerid,-1000);
						BusinessInfo[tmpid][bTill] += 1000;
						myStrcpy(wat, "Katana");
					}
					case 8:
					{
						if(PlayerTemp[playerid][sm] < 50) return SendClientError(playerid, "You need atleast $50 to buy a bunch of flowers.");
                        GivePlayerWeaponEx(playerid,WEAPON_FLOWER,-1);
						GivePlayerMoneyEx(playerid,-50);
						BusinessInfo[tmpid][bTill] += 50;
						myStrcpy(wat, "Flowers");
					}
					case 9:
					{
						if(PlayerTemp[playerid][sm] < 1000) return SendClientError(playerid, "You need atleast $1,000 to buy a parachute.");
                        GivePlayerWeaponEx(playerid,WEAPON_PARACHUTE,-1);
						GivePlayerMoneyEx(playerid,-1000);
						BusinessInfo[tmpid][bTill] += 1000;
						myStrcpy(wat, "Parachute");
					}
					case 10:
					{
						if(PlayerTemp[playerid][sm] < 1000) return SendClientError(playerid, "You need atleast $1,000 to buy a cellphone.");
                        PlayerInfo[playerid][gotphone]=1;
						PlayerInfo[playerid][phonenumber] = minrand(100000,999999);
						GivePlayerMoneyEx(playerid,-1000);
						BusinessInfo[tmpid][bTill] += 1000;
						myStrcpy(wat, "Cellphone");
					}
					case 11:
					{
						if(PlayerTemp[playerid][sm] < 3000) return SendClientError(playerid, "You need atleast $3,000 to buy a radio.");
                        PlayerInfo[playerid][radio]=1;
						GivePlayerMoneyEx(playerid,-3000);
						BusinessInfo[tmpid][bTill] += 3000;
						myStrcpy(wat, "Radio");
					}
					case 12:
					{
						if(PlayerTemp[playerid][sm] < 5000) return SendClientError(playerid, "You need atleast $5,000 to buy a phonebook.");
                        PlayerInfo[playerid][phonebook]=1;
						GivePlayerMoneyEx(playerid,-5000);
						BusinessInfo[tmpid][bTill] += 5000;
						myStrcpy(wat, "Phonebook");
					}
					case 13:
					{
						if(PlayerTemp[playerid][sm] < 2000) return SendClientError(playerid, "You need atleast $2,000 to buy a petrol canister.");
					    SetPVarInt(playerid, "PetrolCan", 1);
						GivePlayerMoneyEx(playerid,-2000);
						BusinessInfo[tmpid][bTill] += 2000;
						myStrcpy(wat, "Petrol Canister");
					}
					case 14:
					{
						if(PlayerTemp[playerid][sm] < 550) return SendClientError(playerid, "You need atleast $550 to buy a baseball bat.");
						GivePlayerWeaponEx(playerid,WEAPON_BAT,-1);
						GivePlayerMoneyEx(playerid,-550);
						BusinessInfo[tmpid][bTill] += 550;
						myStrcpy(wat, "Bat");
					}
					case 15:
					{
						if(PlayerInfo[playerid][pBoomBoxBan] == 1) return SendClientError(playerid, "A boombox ban has been placed on this account for misuse.");
						if(PlayerTemp[playerid][sm] < 450000) return SendClientError(playerid, "You need atleast $450,000 to buy a boombox.");
						GivePlayerMoneyEx(playerid, -450000);
						BusinessInfo[tmpid][bTill] += 450000;
						myStrcpy(wat, "BoomBox");
						PlayerInfo[playerid][pBoomBox] = 1;
						BusinessInfo[tmpid][bComps] -= 4;
					}
	            }
	            BusinessInfo[tmpid][bComps]--;
	            format(string, sizeof(string), "[24/7 Store] Item bought: %s", wat);
	            SendClientMessage(playerid, COLOR_YELLOW, string);
	            if(!strcmp(wat, "Petrol Canister"))
	            {
	            	SendClientMessage(playerid, COLOR_LIGHTGREY, "[24/7 Store] You can use /refuel inside or next to your vehicle.");
	            }
				else if(!strcmp(wat, "BoomBox"))
				{
					SendClientMessage(playerid, COLOR_LIGHTGREY, "[24/7 Store] You can now use /boombox to place or remove your boombox, and use /setbombox to change the link.");
				}
	            return 1;
			}
			else return SendClientError(playerid, "Not in the 24/7 anymore.");
        }
    }
    if(dialogid == DIALOG_JOB_DEALERSHIP)
	{
		if(response)
		{
			new tmpid=IsPlayerOutBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_JOB_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < jobcars[listitem][jcprice]) return SendClientError(playerid, "Not enough cash!");

				new string[ 128 ];
				format(string, sizeof(string), "Dealership: You have bought a %s for $%s! Enter it and park it! (/car help)", jobcars[listitem][jcname], number_format(jobcars[listitem][jcprice]));
				SendClientInfo(playerid, string);

				GivePlayerMoneyEx(playerid, -jobcars[listitem][jcprice]);
				BusinessInfo[tmpid][bTill] += jobcars[listitem][jcprice]/2;
				BusinessInfo[tmpid][bComps]--;
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), jobcars[listitem][jcmodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), jobcars[listitem][jcname], number_format(jobcars[listitem][jcprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_HEAVY_DEALERSHIP)
	{
		if(response)
		{
			new tmpid=IsPlayerOutBiz(playerid);
			if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_HEAVY_DEALER)
			{
				if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax]) return SendClientError(playerid, "Sorry, you have no slots left! You may donate to get more slots!");
				if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "No cars in stock!");
				if(PlayerTemp[playerid][sm] < heavycars[listitem][hprice]) return SendClientError(playerid, "Not enough cash!");
				new string[ 128 ];

				format(string, sizeof(string), "Dealership: You have bought a %s for $%s! Enter it and park it! (/car help)", heavycars[listitem][hname], number_format(heavycars[listitem][hprice]));
				SendClientInfo(playerid, string);

				GivePlayerMoneyEx(playerid, -heavycars[listitem][hprice]);
				BusinessInfo[tmpid][bTill] += heavycars[listitem][hprice]/4;
				BusinessInfo[tmpid][bComps]--;
				new posRand = minrand(0, sizeof(VehicleDealershipPos));
				CreateNewVehicle(PlayerName(playerid), heavycars[listitem][hmodel], VehicleDealershipPos[posRand][spawnx], VehicleDealershipPos[posRand][spawny], VehicleDealershipPos[posRand][spawnz], VehicleDealershipPos[posRand][spawna]);
				format(string, sizeof(string), "6[VEHICLE] %s has bought a %s for $%s from the %s!", PlayerName(playerid), heavycars[listitem][hname], number_format(heavycars[listitem][hprice]), BusinessInfo[tmpid][bName]);
				iEcho(string);
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_CCTV)
	{
		if(response)
		{
			SetPlayerInterior(playerid, 0);
			TogglePlayerControllable(playerid, false);
			SetPlayerVirtualWorld(playerid, 0);
			switch(listitem)
			{
				case 0: // 4d
				{
					SetPlayerPos(playerid, 2020.2023,1003.8996,32.7547);
					SetPlayerCameraPos(playerid, 2022.7805,998.7986,30.7661);
					SetPlayerCameraLookAt(playerid, 2043.9904,1018.0406,10.6719);
				}
				case 1: // city hall
				{
					SetPlayerPos(playerid, 2414.9646,1087.2142,28.2578);
					SetPlayerCameraPos(playerid, 2437.6846,1083.9733,18.6063);
					SetPlayerCameraLookAt(playerid, 2412.4990,1131.9431,10.8203);
				}
				case 2: // ban
				{
					SetPlayerPos(playerid, 2545.8169,1300.3774,25.9501);
					SetPlayerCameraPos(playerid, 2554.4539,1300.6667,32.9501);
					SetPlayerCameraLookAt(playerid, 2579.9966,1325.8268,10.8203);
				}
				case 3: // ban 2
				{
					SetPlayerPos(playerid, 2213.1768,1386.2935,16.4786);
					SetPlayerCameraPos(playerid, 2214.4839,1384.3402,16.4786);
					SetPlayerCameraLookAt(playerid, 2204.4570,1355.9255,10.843);
				}
				case 4: // pd
				{
					SetPlayerPos(playerid, 2270.4136,2396.7485,12.6592);
					SetPlayerCameraPos(playerid, 2263.7039,2397.2300,19.659);
					SetPlayerCameraLookAt(playerid, 2290.1851,2432.0532,10.8203);
				}
				case 5: // court
				{
					SetPlayerPos(playerid, 2349.3489,2485.4531,13.9490);
					SetPlayerCameraPos(playerid, 2357.5352,2484.7739,19.1384);
					SetPlayerCameraLookAt(playerid, 2388.8511,2466.0569,10.8203);
				}
			}
		}
	    return 1;
	}
	if (dialogid == DIALOG_JOB_SELECTION)
    {
		if(response)
		{
			if(strcmp(PlayerInfo[playerid][job], "None"))
			{
				format(iStr, sizeof(iStr), "You already have a job! (%s)\n\nDo you want to leave it or cancel?", PlayerInfo[playerid][job]);
				ShowPlayerDialog(playerid, DIALOG_QUIT_JOB, DIALOG_STYLE_MSGBOX, "LV Job Agency", iStr, "Leave Job", "Cancel");
				return 1;
			}
			switch(listitem)
			{
				case 0:
				{
					myStrcpy(PlayerInfo[playerid][job], "Farmer");
					ShowInfoBox(playerid, "Farmer", "Congratulations, you are now a ~r~farmer~w~! Use /jobhelp to see your new commands.");
					format(iStr, sizeof(iStr), "6[JOB] %s is now a Farmer!", PlayerName(playerid));
					iEcho(iStr);
				}
				case 1:
				{
					myStrcpy(PlayerInfo[playerid][job],"Detective");
					ShowInfoBox(playerid, "Detective", "Congratulations, you are now a ~r~detective~w~! Use /jobhelp to see your new commands.");
					format(iStr, sizeof(iStr), "6[JOB] %s is now a Detective!", PlayerName(playerid));
					iEcho(iStr);
				}
				case 2:
				{
					myStrcpy(PlayerInfo[playerid][job], "Trucker");
					ShowInfoBox(playerid, "Trucker", "Congratulations, you are now a ~r~trucker~w~! Use /jobhelp to see your new commands.");
					format(iStr, sizeof(iStr), "6[JOB] %s is now a Trucker!", PlayerName(playerid));
					iEcho(iStr);
				}
				case 3:
				{
					if(GetPlayerFaction(playerid) != CIV)
					{
						ShowPlayerDialog(playerid, 13, DIALOG_STYLE_MSGBOX, "** Error","You have to be a civilian in order to become a medic.", "Ok", "");
						return 1;
					}
					myStrcpy(PlayerInfo[playerid][job],"Medic");
					ShowInfoBox(playerid, "Medic", "Congratulations, you are now a ~r~medic~w~! Use /jobhelp to see your new commands.");
					SetPlayerColor(playerid,COLOR_SYSTEM_GM);
					SetPlayerSkin(playerid,276);
					format(iStr, sizeof(iStr), "6[JOB] %s is now a Medic!", PlayerName(playerid));
					iEcho(iStr);
				}
				case 4:
				{
					if(GetPlayerFaction(playerid) != CIV)
					{
						ShowPlayerDialog(playerid, 13, DIALOG_STYLE_MSGBOX, "** Error","You have to be a civilian in order to become a Taxi Driver.", "Ok", "");
						return 1;
					}
					myStrcpy(PlayerInfo[playerid][job], "TaxiDriver");
					ShowInfoBox(playerid, "TaxiDriver", "Congratulations, you are now a ~r~TaxiDriver~w~! Use /jobhelp to see your new commands.");
					format(iStr, sizeof(iStr), "6[JOB] %s is now a TaxiDriver!", PlayerName(playerid));
					iEcho(iStr);
				}
				case 5:
				{
					myStrcpy(PlayerInfo[playerid][job],"Lawyer");
					ShowInfoBox(playerid, "Lawyer", "Congratulations, you are now a ~r~lawyer~w~! Use /jobhelp to see your new commands.");
					format(iStr, sizeof(iStr), "6[JOB] %s is now a Lawyer!", PlayerName(playerid));
					iEcho(iStr);
				}
				case 6:
				{
					myStrcpy(PlayerInfo[playerid][job], "Mechanic");
					ShowInfoBox(playerid, "Lawyer", "Congratulations, you are now a ~r~mechanic~w~! Use /jobhelp to see your new commands.");
					format(iStr, sizeof(iStr), "6[JOB] %s is now a mechanic!", PlayerName(playerid));
					iEcho(iStr);
				}
				default: return 1;
			}
		}
        return 1;
    }
    if(dialogid == DIALOG_QUIT_JOB)
    {
        if(response)
        {
            OnPlayerCommandText(playerid, "/quitjob");
			OnPlayerEnterDynamicCP(playerid, gCheckPoints[CITYHALL]);
        }
    }
    if(dialogid == DIALOG_H_UPGRADE)
    {
        if(response)
        {
            new level = listitem;
			if(level < 0 || level >= sizeof(IntInfo)) return SendClientError(playerid, "Invalid ID! Use /house upgrade");

			if(PlayerTemp[playerid][sm] < IntInfo[level][intPrice])
			{
			    OnPlayerCommandText(playerid, "/house upgrade");
				return SendClientError(playerid,  "You don't have enough money!");
			}
			new h_ID = IsPlayerOutHouse(playerid);
			if(h_ID == -1) return SendClientError(playerid, "You are not outside your house.");
			GivePlayerMoneyEx(playerid,-IntInfo[level][intPrice]);
			HouseInfo[h_ID][hInteriorPack] = level;
			format(iStr,sizeof(iStr),"Your house interior has been upgraded to ID[%d] for -$%s",level, number_format(IntInfo[level][intPrice]));
			SendClientInfo(playerid ,iStr);
			ReloadHouse(h_ID);
			return 1;
        }
    }
    if(dialogid == DIALOG_G_UPGRADE)
    {
        if(response)
        {
            new level = listitem+1;
			if(PlayerTemp[playerid][sm] < garages[level][g_price]) return SendClientError(playerid,  "You don't have enough money!");
			new h_ID = IsPlayerOutHouse(playerid);
			if(h_ID == -1) return SendClientError(playerid, "You are not outside your house.");
			GivePlayerMoneyEx(playerid,-garages[level][g_price]);
			HouseInfo[h_ID][hGarageInteriorPack] = level;
			format(iStr,sizeof(iStr),"Your garage interior has been upgraded to ID[%d] for -$%s", level, number_format(garages[level][g_price]));
			SendClientInfo(playerid ,iStr);
			SaveHouse(h_ID);
			return 1;
        }
    }
    if(dialogid == DIALOG_WHEELS)
	{
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid)) return 1;
			AddVehicleComponent(GetPlayerVehicleID(playerid), CarWheels[listitem][whComponent]);
			SetVehiclePos(GetPlayerVehicleID(playerid), 1658.3151, 2194.3501, 15.4812);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), 267.4812);
			new lolvw = minrand(2000, 3000);
			SetPlayerVirtualWorld(playerid, lolvw);
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), lolvw);
			SetPlayerCameraPos(playerid, 1658.3776,2201.0320,17.2914);
			SetPlayerCameraLookAt(playerid, 1658.3151,2194.3501,15.4812);
			ShowDialog(playerid, DIALOG_WHEELS_BUY);
		}
	    return 1;
	}
	if(dialogid == DIALOG_WHEELS_BUY)
	{
	    SetPlayerVirtualWorld(playerid, 0);
        SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
        SetVehiclePos(GetPlayerVehicleID(playerid), -2729.973876,76.065795,4.107038);
        SetVehicleZAngle(GetPlayerVehicleID(playerid), 0.18);
		SetCameraBehindPlayer(playerid);
	    if(!response)
	    {
	        new curwheelsid = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), CARMODTYPE_WHEELS);
	        RemoveVehicleComponent(GetPlayerVehicleID(playerid), curwheelsid);
	        SetTimerEx("okwheels", 400, false, "d", playerid);
	    }
	    else
	    {
	        new businessid, entra;
	        OnPlayerCommandText(playerid, "/car savemod");
			BusinessLoop(b)
			{
			    if(BusinessInfo[b][bActive] != true) continue;
			    if(BusinessInfo[b][bType] != BUSINESS_TYPE_WHEEL) continue;
			    businessid = b;
			    break;
			}
			entra = BusinessInfo[businessid][bFee];
			GivePlayerMoneyEx(playerid, -entra);
			BusinessInfo[businessid][bComps]--;
			BusinessInfo[businessid][bTill] += entra;
	    }
	    return 1;
	}
	if(dialogid == DIALOG_GYM)
	{
		if(response)
		{
			SetPlayerPosEx(playerid, 758.3981,-65.1611,1000.8479, 7, 1338, false);
			SetPlayerFacingAngle(playerid, 180.0);
			TogglePlayerControllable(playerid, false);
			PreloadAnimLib(playerid,"GYMNASIUM");
			ApplyAnimation(playerid,"GYMNASIUM","gym_tread_sprint", 4.1, 1, 1, 1, 1, 0, 1); //sprint
			PlayerTemp[playerid][GYM_CURKEY] = KEY_WALK;
			PlayerTemp[playerid][GYM_CURDONE] = 1;
			SetPVarInt(playerid, "TrainingFor", listitem);
			treadmillBUSY = playerid;
			GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~~k~~SNEAK_ABOUT~", 10000, 4);
			ShowPlayerDialog(playerid, 43, DIALOG_STYLE_MSGBOX, "LV Gym | Information", "You will now start learning. Press the displayed keys to advance.", "Ok", "");
		}
	    return 1;
	}
	if(dialogid == DIALOG_BANK_WITHDRAW)
	{
		if(response)
		{
			if(!IsNumeric(inputtext) || strval(inputtext) <= 0 || strval(inputtext) > PlayerInfo[playerid][bank])
				return ShowDialog(playerid, DIALOG_BANK_WITHDRAW), 1;
			new amount = strval(inputtext);
			GivePlayerMoneyEx(playerid,amount);
			PlayerInfo[playerid][bank] -= amount;
			SendClientMSG(playerid, COLOR_YELLOW, "[BANK] Withdrawn: $%s | Balance: $%s",number_format(amount),number_format(PlayerInfo[playerid][bank]));
			if(IsAtATM(playerid))
			{
				new amount2 = (amount/100)*1;
				SendClientMSG(playerid, COLOR_YELLOW,"[ATM] Paid $%s (1%%) of fees for the usage.",number_format(amount2));
				GivePlayerMoneyEx(playerid, -amount2);
			}
			format(iStr,sizeof(iStr),"14[BANK] %s has withdrawn $%d. Balance: $%d", PlayerName(playerid), amount, PlayerInfo[playerid][bank]);
			iEcho(iStr);
			AppendTo(moneylog,iStr);
		}
	}
	if(dialogid == DIALOG_BANK_DEPOSIT)
	{
		if(response)
		{
			if(!IsNumeric(inputtext) || strval(inputtext) <= 0 || strval(inputtext) > HandMoney(playerid))
				return ShowDialog(playerid, DIALOG_BANK_DEPOSIT), 1;
			new amount = strval(inputtext);
			GivePlayerMoneyEx(playerid,-amount);
			PlayerInfo[playerid][bank] += amount;
			SendClientMSG(playerid, COLOR_YELLOW, "[BANK] Deposit: $%s | Balance: $%s",number_format(amount),number_format(PlayerInfo[playerid][bank]));
			if(IsAtATM(playerid))
			{
				new amount2 = (amount/100)*1;
				SendClientMSG(playerid, COLOR_YELLOW,"[ATM] Paid $%s (1%%) of fees for the usage.",number_format(amount2));
				GivePlayerMoneyEx(playerid, -amount2);
			}
			format(iStr,sizeof(iStr),"14[BANK] %s has depositted $%d. Balance: $%d", PlayerName(playerid), amount, PlayerInfo[playerid][bank]);
			iEcho(iStr);
			AppendTo(moneylog,iStr);
		}
	}
	if(dialogid == DIALOG_CMD_CMDS)
	{
		if(response)
		{
			if(listitem == 0) // account
			{
				new cmdstr[2400];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/charity{afafaf} - Give away money - {FF0000}{NOT REFUNDABLE} {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/pm{afafaf} - Send a private message to another online player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/opm(s){afafaf} - Send a private offline message to another player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/stats{afafaf} - Get a complete list of your current characters statistics. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/driverlicense{afafaf} - Obtain a drivers license. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/sailinglicense{afafaf} - Obtain a Sailing license. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/pilotlicense{afafaf} - Obtain a pilots license. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/enter{afafaf} - Enter a building. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/get(id){afafaf} - Get a players ID that matches the name inputted. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/togpm{afafaf} - Toggle private messages. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/number{afafaf} - Get the phone number of another player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/freq{afafaf} - Set the frequency of your radio (1-3 slots). {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/syncradio{afafaf} - synchronise the set radio slot. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/paybail{afafaf} - Pay your bail so a lawyer can free you. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/jq{afafaf} - Display when a player joins / quits the server. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/togenter{afafaf} - Toggle /enter or to press F. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/name{afafaf} - Display your name for other players. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/phone{afafaf} - Toggle your phone off / on. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/myhouses(/hlist){afafaf} - Shows all your currently owned houses. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/myvehicles(/vlist){afafaf} - Shows all your currently owned vehicles. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/mybusinesses{afafaf} - Shows all your currently owned businesses. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/dropweapon{afafaf} - Drop your primary / secondary weapon. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/dropallweapons{afafaf} - Drop both primary and secondary weapon. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/myweapons{afafaf} - Displays your primary / secondary weapon. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/myitems{afafaf} - Shows your inventory. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/kill{afafaf} - Respawn your character. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/frisk{afafaf} - Frisk another player. {228B22}]");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Account Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 1) // roleplay
			{
				new cmdstr[2000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/me{afafaf} - Displays an action your character is performing.{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/do{afafaf} - Asking another player for more roleplay details.{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/service{afafaf} - Get helper from another player! {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/c{afafaf} - Call another player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/sms{afafaf} - Send a text message to another player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/w(hisper){afafaf} - Whisper to a player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/b{afafaf} - Local OOC chat. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fish{afafaf} - Go fishing. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/ad{afafaf} - Display an advertisement. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/cad{afafaf} - Display a company advertisement. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/cc{afafaf} - Car chat. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/l(ow){afafaf} - Displays a message to people close to you. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/s(hout){afafaf} - Shout a message to people close / far from you. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/answer{afafaf} - Answer your mobile phone. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/hangup{afafaf} - Hangup your mobile phone. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/pay{afafaf} - Give another player a selected amount of money. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/showlicenses{afafaf} - Show your licenses to another player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/blindfold{afafaf} - Blindfold a player (level 3+) {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/unblindfold{afafaf} - Unblindfold a player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/tie{afafaf} - Tie a player (level 3+) {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/untie{afafaf} - Untie a player. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/laptop{afafaf} - Use your laptop. {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Roleplay Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 2) // license
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/showlicenses{afafaf} - This command will allow you to show your current licenses to other players. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/driverlicense{afafaf} - This command will start the driving test, given that you are inside the right area (/helpme). {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/sailinglicense(s){afafaf} - This command allows you to fully obtain a sailing license, meaning you can now sail and buy boats {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/pilotlicense{afafaf} - This command allows you to fully obtain a pilots license, meaning you can buy and operate a aircraft. {228B22}]");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}License Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 3) // faction
			{
				new cmdstr[3000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/f{afafaf} - This command is the OOC chat for your faction. This can be toggled by a tier 0/1 faction member. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fon{afafaf} - This command will show all the members of the faction that are currently online. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/foff(s){afafaf} - This command will list all of the members that are currently offline, in a ascending tier order. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fcars{afafaf} - This command will list all of the vehicles that are currently factionized. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fcar{afafaf} - This command allows tier 0/1 members to edit the properties of factionized vehicles. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/turftakeover [off/on]{afafaf} - This command will start a turf takeover within the gangzone you are currently in. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/finfo{afafaf} - This command will display some of the most important information regarding the faction. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/getfreq{afafaf} - This command will get the frequency that is currently reserved for your faction. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/ftakegun{afafaf} - This command allows you to take a weapon from the faction stock (HQ). {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/openhq{afafaf} - This command will open the doors of the faction Headquaters. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/closehq{afafaf} - This command will close the doors of the fation Headquaters. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fmotd{afafaf} - This command allows tier 0 members of the faction to change the Message Of The Day. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/invite{afafaf} - This command invites a civilian to join the faction. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/uninvite{afafaf} - This command will kick a member of faction, making them a civilian. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/setfreq{afafaf} - This command will set the current frequency of the faction radio to a different frequency. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fstartrank{afafaf} - This command will set the invite rank, the default rank for the faction. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fstartpayment{afafaf} - This command will set the default payment for newly invited members of the faction. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/setrank{afafaf} - This command will set the rank of a faction member, reserved for tier 0 members only. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/settier{afafaf} - This command will set the tier of a faction member, reserved for tier 0 members only. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/ftog{afafaf} - This command will toggle the faction chat. Has no effect on tier 0 members. {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/ftogcol{afafaf} - This command will set toggle the faction color. Has no effect on tier 0 members. {228B22}]\n");
				if(IsPlayerFED(playerid))
				{
					strcat(cmdstr, "{228B22}[{FFFFFF}LAW{228B22}]{FFFFFF} /get /cuff [ID] /jail [ID] [Time] /wlist /su(spect) [ID] /cl(earlvl) [ID] /unjail [ID] /givegun /heal\n");
					strcat(cmdstr, "{228B22}[{FFFFFF}LAW{228B22}]{FFFFFF} /p /b /emergency /sdeploy [#] /slist /sremove [#] /bdeploy [#] /bremove [#] /blist\n");
					strcat(cmdstr, "{228B22}[{FFFFFF}LAW{228B22}]{FFFFFF} /car impound /car unimpound /d [Text] /record /badge /getbusinesses /gethouses /getcars\n");
				}
				if(GetPlayerFactionType(playerid) == FAC_TYPE_SDC)
				{
					strcat(cmdstr, "{228B22}[{FFFFFF}SDC{228B22}]{FFFFFF} /buycomps /sellcomps /loadcomps /unloadcomps /whinfo /checkcomps /restock /checkruns /clearruns /tracehouse /tracebiz /ann\n");
					strcat(cmdstr, "{228B22}[{FFFFFF}SDC{228B22}]{FFFFFF} /liftcrates /liftprods /loadprods /loadcrates /unloadcrates\n");
				}
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Faction Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 4) // donator
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/changephone{afafaf} - This command allows the player to change their phonenumber to a custom one. Limited by the amount of number changes left.{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/changemyname{afafaf} - This command allows the player to change their name to a new one. Limited by the amount of name changes left.{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/fightstyle{afafaf} - This command allows the player to change their current fighting style. I.e Boxing, Karate, Elow... {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/wlock{afafaf} - This command allows the user to toggle whispers. {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Donator Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 5) // phone
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/phone{afafaf} - This command will display the phone menu{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/c(all) [Number]{afafaf} - This command allows you to call a player{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/sms{afafaf} [Number] - This command allows you to SMS a player{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/an(swer){afafaf} - This command will answer a phone call{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/hangup{afafaf} - This command will hangup the phone call{228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/ad{afafaf} - Display an advertisement.{228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Phone Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 6) // radio
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/r [Text]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/freq [Slot] [Frequency]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/radio {afafaf} - This command shows your frequencies {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/getfreq {afafaf} - This command will show you the Faction frequency {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/setfreq [Frequency]{afafaf} - This command will set the frequency of you Faction {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/syncradio [Slot]{afafaf} - This command allows you to sync your radio to a freq in your slot. {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Radio Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 7) // drug
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/usedrugs [Drug Name]{afafaf} - This command allows you to use drugs from your inventory{ 228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/mydrugs{afafaf} - This will show the drugs from your inventory {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/harvest{afafaf} - This command allows you to harvest the drugs you've planted {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/plant{afafaf} - This will allows you to plant drugs {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/myseeds{afafaf} - This will show you the seeds from your inventory {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Drug Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 8) // chat
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/w(hisper) [ID] [Text]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/f(action) [Text]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/irc [Text]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/o(oc) [Text]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/L(ocal) [Text]{afafaf} - This command allows you to RP with a player while on phone {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/pb [Text]{afafaf} - NA {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Chat Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 9) // job
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/jobhelp{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/jobstats{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/quitjob{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/o(oc) [Text]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/L(ocal) [Text]{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/pb [Text] [off/on]{afafaf} - NA {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Job Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 10) // bank
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/(f)withdraw{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/(f)deposit{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/(f)balance{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/transfer{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/loan{afafaf} - NA {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Bank Commands", cmdstr, "Okay", "");
			}
			else if(listitem == 11) // misc
			{
				new cmdstr[1000];
				strcat(cmdstr, "{228B22}[ {FFFFFF}/bizhelp{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/househelp{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/car help{afafaf} - NA {228B22}]\n");
				strcat(cmdstr, "{228B22}[ {FFFFFF}/faction help{afafaf} - NA {228B22}]\n");
				ShowPlayerDialog(playerid, DIALOG_NO_RESPONSE, DIALOG_STYLE_MSGBOX, "{3196ef}Angel Pine {FF0000}Roleplay {FFFFFF}Other Commands", cmdstr, "Okay", "");
			}
		}
	}
/* 	if(dialogid == DIALOG_V_SPAWN)
	{
		if(response)
		{
			new vehicleid, iCount;
			VehicleLoop(v)
			{
				if(VehicleInfo[v][vActive] != true) continue;
				if(strcmp(PlayerName(playerid), VehicleInfo[v][vOwner],false)) continue;
				if(listitem == iCount)
				{
					vehicleid = v;
					break;
				}
				iCount++;
			}
			if(VehicleInfo[vehicleid][vSpawned] == true) // despawn
			{
				if(IsVehicleOccupied(GetCarID(vehicleid))) return SendClientError(playerid, "This vehicle is currently occupied. You can't despawn it just yet.");
				DestroyVehicle(GetCarID(vehicleid));
				VehicleInfo[vehicleid][vSpawned] = false;
				VehicleInfo[vehicleid][vRID] = INVALID_VEHICLE_ID;
				VehicleInfo[vehicleid][vID] = INVALID_VEHICLE_ID;
				GameTextForPlayer(playerid, "~g~Despawned", 3000, 1);
			}
			else // spawn
			{
				if(GetPlayerSpawnedVehicleCount(playerid) >= PlayerInfo[playerid][vSpawnMax]) return SendClientError(playerid, "You cannot spawn any more vehicles!");
				VehicleInfo[vehicleid][vRID] = GetNextCreatedVehicleID();
				VehicleInfo[vehicleid][vSpawned] = true;
				VehicleInfo[vehicleid][vID] = CreateVehicle(VehicleInfo[vehicleid][vModel], VehicleInfo[vehicleid][vX], VehicleInfo[vehicleid][vY], VehicleInfo[vehicleid][vZ], VehicleInfo[vehicleid][vA], VehicleInfo[vehicleid][vColour1], VehicleInfo[vehicleid][vColour2], -1);
				SetVehicleVirtualWorld(VehicleInfo[vehicleid][vRID], VehicleInfo[vehicleid][vVirtualWorld]);
				SetVehicleNumberPlate(GetCarID(vehicleid), VehicleInfo[vehicleid][vPlate]);
				SetVehicleToRespawn(GetCarID(vehicleid));
				SetVehicleEngineOff(GetCarID(vehicleid));
				if(DoesVehicleHaveLock(GetCarID(vehicleid)) == true)
				{
					LockVehicle(-1, VehicleInfo[vehicleid][vRID]);
				}
				SetTimerEx("ModCar", 2000, 0, "d", GetCarID(vehicleid));
				GameTextForPlayer(playerid, "~r~Spawned", 3000, 1);
			}
		}
	} */
	if(dialogid == DIALOG_MNG_CATE_IN)
	{
		if(response)
		{
			new houseid = PlayerTemp[playerid][tmphouse];
			if(houseid == -1) return SendClientError(playerid, "Your nolonger inside any house!");
			if(listitem == 0) // view info
			{
				ShowDialog(playerid, DIALOG_H_VIEW_INFO);
			}
			else if(listitem == 1) // unlock / lock
			{
				if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0)
				{
					if(HouseInfo[houseid][hClosed] != false) HouseInfo[houseid][hClosed] = false;
					else HouseInfo[houseid][hClosed] = true;
					SaveHouse(houseid);
				}
				else SendClientError(playerid, "You do not own this house.");
				ShowDialog(playerid, DIALOG_MNG_CATE_IN);
			}
			else if(listitem == 2)
			{
				if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0)
				{
					if(HouseInfo[houseid][hGarageOpen] != false) HouseInfo[houseid][hGarageOpen] = false;
					else HouseInfo[houseid][hGarageOpen] = true;
					SaveHouse(houseid);
				}
				else SendClientError(playerid, "You do not own this house.");
				ShowDialog(playerid, DIALOG_MNG_CATE_IN);
			}
			else if(listitem == 3) // house locker
			{
				if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0)
				{
					if(HouseInfo[houseid][hLocker] != false) HouseInfo[houseid][hLocker] = false;
					else HouseInfo[houseid][hLocker] = true;
					SaveHouse(houseid);
				}
				else SendClientError(playerid, "You do not own this house.");
				ShowDialog(playerid, DIALOG_MNG_CATE_IN);
			}
			else if(listitem == 4) // rentroom
			{
				if(HouseInfo[houseid][hRentable] == true && HouseInfo[houseid][hRentprice] != 666 && HandMoney(playerid) >= HouseInfo[houseid][hRentprice] && PlayerInfo[playerid][housenum] != houseid)
				{
					new tmpint = HouseInfo[houseid][hInteriorPack];
					HouseInfo[houseid][hTill] += HouseInfo[houseid][hRentprice];
					PlayerInfo[playerid][housenum] = houseid;
					PlayerInfo[playerid][rentprice] = HouseInfo[houseid][hRentprice];
					GivePlayerMoneyEx(playerid, -HouseInfo[houseid][hRentprice]);
					SetSpawnInfo(playerid, CIV, PlayerInfo[playerid][Skin], IntInfo[tmpint][intX], IntInfo[tmpint][intY], IntInfo[tmpint][intZ], 0, 0, 0, 0, 0, 0, 0);
					SendClientMessage(playerid, COLOR_HELPEROOC, " Congratulations, you have rented a room.");
					SendClientMessage(playerid, COLOR_LIGHTGREY, " From now on your will spawn here, use /unrent to disable it.");
					SaveHouse(houseid);
				}
				else SendClientError(playerid, "This house isn't rentable!");
				ShowDialog(playerid, DIALOG_MNG_CATE_IN);
			}
			else if(listitem == 5) // rob house
			{
				if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0) // he is owner :/
				{
					SendClientError(playerid, "You can't rob your own house.");
					ShowDialog(playerid, DIALOG_MNG_CATE_IN);
				}
				else
				{
					// RobHouse(playerid, houseid);
				}
			}
			else if(listitem == 6) // settings
			{
				if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0 && houseid != -1)
				{
					ShowDialog(playerid, DIALOG_H_SETTINGS);
				}
				else ShowDialog(playerid, DIALOG_MNG_CATE_IN), SendClientError(playerid, "You do not own this house.");
			}
			else return 1;
		}
		return 1;
	}
	if(dialogid == DIALOG_H_VIEW_INFO)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "Your nolonger inside any house!"), 1;
		return ShowDialog(playerid, DIALOG_MNG_CATE_IN), 1;
	}
	if(dialogid == DIALOG_H_SET_RENT)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "Your nolonger inside any house!");
		if(response)
		{
			new iAmount = strval(inputtext);
			if(iAmount > 15000 || iAmount < 1) return ShowDialog(playerid, DIALOG_H_SET_RENT);
			else
			{
				HouseInfo[houseid][hRentable] = true;
				HouseInfo[houseid][hRentprice] = iAmount;
				SaveHouse(houseid);
			}
		}
		ShowDialog(playerid, DIALOG_MNG_CATE_IN);
	}
	if(dialogid == DIALOG_H_SETTINGS)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "Your nolonger inside any house!");
		if(response)
		{
			if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0)
			{
				if(listitem == 0) // rent price
				{
					ShowDialog(playerid, DIALOG_H_SET_RENT);
				}
				else if(listitem == 1) // tenants
				{
					new iQuery[350];
					mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `PlayerName`, `LastOnline`, `RentHouse`, `RentPrice` FROM `PlayerInfo` WHERE `RentHouse` = %d", houseid);
					mysql_tquery(MySQLPipeline, iQuery, "ShowTenantsInDialog", "dd", playerid, houseid);
				}
				else if(listitem == 2) // house interior
				{
					
				}
				else if(listitem == 3) // alarm
				{
				
				}
				else if(listitem == 4) // sell
				{
				
				}
				else if(listitem == 5) // armour
				{
					
				}
			}
		}
		else ShowDialog(playerid, DIALOG_MNG_CATE_IN);
	}
	if(dialogid == DIALOG_FURNITURE)
	{
		if(response)
		{
			new houseid = PlayerTemp[playerid][tmphouse];
			if(houseid == -1) return SendClientError(playerid, "You have left the house!");
			if(response)
			{
				switch(listitem)
				{
					case 0: ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
					case 1: ShowDialog(playerid, DIALOG_FURNITURE_LIST, houseid);
					case 2:
					{
						if(PlayerInfo[playerid][power] < 10 && PlayerInfo[playerid][helper] < 1) return SendClientError(playerid, "You cannot access this at the minute.");
						ShowDialog(playerid, DIALOG_H_BASE_TEXTURES);
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_FURNITURE_CATEGORY)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowDialog(playerid, DIALOG_CATE_SLCT_APPLIANCE, houseid);
				case 1: ShowDialog(playerid, DIALOG_CATE_SLCT_COMFORT, houseid);
				case 2: ShowDialog(playerid, DIALOG_CATE_SLCT_DECO, houseid);
				case 3: ShowDialog(playerid, DIALOG_CATE_SLCT_ENTERTAIN, houseid);
				case 4: ShowDialog(playerid, DIALOG_CATE_SLCT_LIGHTING, houseid);
				case 5: ShowDialog(playerid, DIALOG_CATE_SLCT_PLUMBING, houseid);
				case 6: ShowDialog(playerid, DIALOG_CATE_SLCT_STORAGE, houseid);
				case 7: ShowDialog(playerid, DIALOG_CATE_SLCT_SURFACE, houseid);
				case 8: ShowDialog(playerid, DIALOG_CATE_SLCT_MISC, houseid);
			}
		}
		else ShowDialog(playerid, DIALOG_FURNITURE);
	}
	if(dialogid == DIALOG_CATE_SLCT_APPLIANCE)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_APPLIANCE_REFRIGERATORS;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_APPLIANCE_STOVES;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_APPLIANCE_TRASHCANS;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_APPLIANCE_SMALL;
				case 4: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_APPLIANCE_DUMPSTERS;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_COMFORT)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_COMFORT_BEDS;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_COMFORT_CHAIRS;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_COMFORT_COUCHES;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_COMFORT_ARM_CHAIRS;
				case 4: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_COMFORT_STOOLS;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_SURFACE)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_SURFACES_DINNING;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_SURFACES_COFFEE_TABLES;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_SURFACES_COUNTERS;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_SURFACES_DISPLAY_CABINETS;
				case 4: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_SURFACES_DISPLAY_SHELVES;
				case 5: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_SURFACES_TV_STANDS;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_STORAGE)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_STORAGE_SAFES;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_STORAGE_BOOKSHELVES;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_STORAGE_DRESSERS;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_STORAGE_CABINETS;
				case 4: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_STORAGE_PANTRIES;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_PLUMBING)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_PLUMBING_TOILET;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_PLUMBING_SINK;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_PLUMBING_SHOWER;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_PLUMBING_BATHS;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_LIGHTING)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_LIGHTING_LAMPS;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_LIGHTING_WALLMOUNTED;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_LIGHTING_CEILING;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_LIGHTING_NEON;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_ENTERTAIN)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_ENTERTAIN_SPORTS;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_ENTERTAIN_TV;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_ENTERTAIN_GAMING;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_ENTERTAIN_MEDIA;
				case 4: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_ENTERTAIN_STEREO;
				case 5: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_ENTERTAIN_SPEAKERS;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_DECO)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_CURTAINS;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_FLAGS;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_RUGS;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_STATUES;
				case 4: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_TOWELS;
				case 5: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_PAINTINGS;
				case 6: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_PLANTS;
				case 7: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_DECO_POSTERS;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_CATE_SLCT_MISC)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_CLOTHES;
				case 1: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_CONSUMABLES;
				case 2: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_DOORS;
				case 3: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_MESS;
				case 4: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_MISC;
				case 5: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_PILLARS;
				case 6: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_SECURITY;
				case 7: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_OFFICE;
				case 8: PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = SUB_MISC_TOYS;
			}
			ShowDialog(playerid, DIALOG_FURNITURE_BUY, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_CATEGORY, houseid);
	}
	if(dialogid == DIALOG_FURNITURE_BUY)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			new iCount, iID;
			for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
			{
				if(FurnitureObjects[furSearch][furCategory] != PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT]) continue;
				if(FurnitureObjects[furSearch][furSubCategory] != PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT]) continue;
				if(listitem == iCount) iID = furSearch;
				iCount++;
			}
			if(PlayerTemp[playerid][sm] < FurnitureObjects[iID][furPrice]) return SendClientError(playerid, "You do not have enough money for this item!");
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			CreateNewFurniture(houseid, FurnitureObjects[iID][furID], x, y+1.5, z, 0.0, 0.0, 0.0);
			new iFormat[128];
			format(iFormat, sizeof(iFormat), "[Furniture:]{D1FFE0} %s, item purchase was successful. -$%s.", RPName(playerid), number_format(FurnitureObjects[iID][furPrice]));
			SendClientMessage(playerid, 0xABFFC7FF, iFormat);
			GivePlayerMoneyEx(playerid, -FurnitureObjects[iID][furPrice]);
			ShowDialog(playerid, DIALOG_FURNITURE_LIST, houseid); // back to main!
		}
		else
		{
			if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_APPLIANCES) ShowDialog(playerid, DIALOG_CATE_SLCT_APPLIANCE, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_COMFORT) ShowDialog(playerid, DIALOG_CATE_SLCT_COMFORT, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_DECORATIONS) ShowDialog(playerid, DIALOG_CATE_SLCT_DECO, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_ENTERTAINMENT) ShowDialog(playerid, DIALOG_CATE_SLCT_ENTERTAIN, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_LIGHTING) ShowDialog(playerid, DIALOG_CATE_SLCT_LIGHTING, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_PLUMBING) ShowDialog(playerid, DIALOG_CATE_SLCT_PLUMBING, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_STORAGE) ShowDialog(playerid, DIALOG_CATE_SLCT_STORAGE, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_SURFACES) ShowDialog(playerid, DIALOG_CATE_SLCT_SURFACE, houseid);
			else if(PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] == CATEGORY_MISCELLANEOUS) ShowDialog(playerid, DIALOG_CATE_SLCT_MISC, houseid);
			else ShowDialog(playerid, DIALOG_FURNITURE, houseid);
		}
	}
	// Dialog Furniture buy - END!
	if(dialogid == DIALOG_FURNITURE_LIST)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			new iID, iCount;
			FurnitureLoop(f)
			{
				if(FurnitureInfo[houseid][f][furActive] != true) continue;
				if(listitem == iCount) 
				{
					iID = f;
					break;
				}
				iCount++;
			}
			PlayerTemp[playerid][pFurnitureSelectID] = iID;
			ShowDialog(playerid, DIALOG_FURNITURE_LIST_OPTIONS, iID);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE, houseid);
	}
	if(dialogid == DIALOG_FURNITURE_LIST_OPTIONS)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowDialog(playerid, DIALOG_FURNITURE_POSITION, houseid);
				case 1: ShowDialog(playerid, DIALOG_FURNITURE_RENAME, houseid);
				case 2: ShowDialog(playerid, DIALOG_FURNITURE_SELL, houseid);
				case 3: ShowDialog(playerid, DIALOG_FURNITURE_MATERIAL, houseid);
				case 4: ShowDialog(playerid, DIALOG_FURNIUTRE_INFO, houseid);
			}
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_LIST, houseid);
	}
	if(dialogid == DIALOG_FURNIUTRE_INFO)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		ShowDialog(playerid, DIALOG_FURNITURE_LIST_OPTIONS, houseid);
	}
	if(dialogid == DIALOG_FURNITURE_POSITION)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			new currentEditing = PlayerTemp[playerid][pFurnitureSelectID];
			if(currentEditing == -1) return SendClientError(playerid, "Your not editing any object!");
			switch(listitem)
			{
				case 0: // rotate X 90
				{
					FurnitureInfo[houseid][currentEditing][furrX] += 90.0;
					ReloadFurniture(houseid, true, currentEditing);
				}
				case 1: // rotate Y 90
				{
					FurnitureInfo[houseid][currentEditing][furrY] += 90.0;
					ReloadFurniture(houseid, true, currentEditing);
				}
				case 2: // rotate Z 90
				{
					FurnitureInfo[houseid][currentEditing][furrZ] += 90.0;
					ReloadFurniture(houseid, true, currentEditing);
				}
				case 3: // Custom movement
				{
					EditDynamicObject(playerid, FurnitureInfo[houseid][currentEditing][furObject]);
				}
			}
			if(listitem != 3) ShowDialog(playerid, DIALOG_FURNITURE, houseid);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_LIST_OPTIONS, houseid);
	}
	if(dialogid == DIALOG_FURNITURE_RENAME)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			if(!strlen(inputtext) || strlen(inputtext) > 40 || strlen(inputtext) < 3)
			{
				ShowDialog(playerid, DIALOG_FURNITURE_RENAME, houseid);
				SendClientError(playerid, "Furniture objects can't have a name above 40 characters or below 3.");
				return 1;
			}
			else // valid
			{
				myStrcpy(FurnitureInfo[houseid][PlayerTemp[playerid][pFurnitureSelectID]][furName], inputtext);
				SaveHouse(houseid);
				ShowDialog(playerid, DIALOG_FURNITURE, houseid);
			}
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_LIST_OPTIONS, houseid);
	}
	if(dialogid == DIALOG_FURNITURE_SELL)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			new iAmount, iID, currentObject = PlayerTemp[playerid][pFurnitureSelectID];
			for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
			{
				if(FurnitureObjects[furSearch][furID] == FurnitureInfo[houseid][currentObject][furModel])
				{
					iID = furSearch;
					break;
				}
			}
			new iQuery[228];
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `FurnitureInfo` WHERE `House` = %d AND `Slot` = %d", houseid, currentObject);
			mysql_tquery(MySQLPipeline, iQuery);
			FurnitureInfo[houseid][currentObject][furActive] = false;
			DestroyDynamicObject(FurnitureInfo[houseid][currentObject][furObject]);
			iAmount = (FurnitureObjects[iID][furPrice] / 4);
			GivePlayerMoneyEx(playerid, iAmount);
			ShowDialog(playerid, DIALOG_FURNITURE);
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_LIST_OPTIONS, houseid);
	}
	if(dialogid == DIALOG_FURNITURE_MATERIAL)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0,1,2,3,4:
				{
					PlayerTemp[playerid][pMaterialSlotEdit] = listitem;
					ShowDialog(playerid, DIALOG_MATERIAL_SELECTION, houseid);
				}
				case 5: // remove all
				{
					new currentSlot = PlayerTemp[playerid][pFurnitureSelectID];
					for(new c = 0; c < 5; c++)
					{
						FurnitureInfo[houseid][currentSlot][furMaterial][c] = -1;
						FurnitureInfo[houseid][currentSlot][furMaterialColour][c] = -1;
					}
					ReloadFurniture(houseid, true, currentSlot);
					ShowDialog(playerid, DIALOG_FURNITURE, houseid); 
				}
			}
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_LIST_OPTIONS, houseid);
	}
	if(dialogid == DIALOG_MATERIAL_SELECTION)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			switch(listitem)
			{
				case 0,1:
				{
					if(listitem == 0) SetPVarInt(playerid, "EditingWhat", 1);
					else SetPVarInt(playerid, "EditingWhat", 2);
					ShowDialog(playerid, DIALOG_GET_MATERIAL, houseid);
				}
				case 2: // remove material
				{
					new currentSlot = PlayerTemp[playerid][pFurnitureSelectID], materialSlot = PlayerTemp[playerid][pMaterialSlotEdit];
					FurnitureInfo[houseid][currentSlot][furMaterial][materialSlot] = -1;
					FurnitureInfo[houseid][currentSlot][furMaterialColour][materialSlot] = -1;
					ReloadFurniture(houseid, true, currentSlot);
					ShowDialog(playerid, DIALOG_FURNITURE, houseid);
				}
				case 3: // material information
				{
				
				}
			}
		}
		else ShowDialog(playerid, DIALOG_FURNITURE_MATERIAL, houseid);
	}
	if(dialogid == DIALOG_GET_MATERIAL)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!");
		if(response)
		{
			new iCount, iMaterial, iFind, materialSlot = PlayerTemp[playerid][pMaterialSlotEdit], currentSlot = PlayerTemp[playerid][pFurnitureSelectID];
			if(GetPVarInt(playerid, "EditingWhat") == 1) iFind = MATERIAL_CATEGORY_COLOURS;
			else iFind = MATERIAL_CATEGORY_TEXTURE;
			for(new c = 0; c < sizeof(FurnitureMaterial); c++)
			{
				if(FurnitureMaterial[c][materialCategory] != iFind) continue;
				if(listitem == iCount)
				{
					iMaterial = c;
					break;
				}
				iCount++;
			}
			if(iFind == MATERIAL_CATEGORY_COLOURS) FurnitureInfo[houseid][currentSlot][furMaterialColour][materialSlot] = iMaterial;
			else FurnitureInfo[houseid][currentSlot][furMaterial][materialSlot] = iMaterial;
			ReloadFurniture(houseid, true, currentSlot);
		}
		DeletePVar(playerid, "EditingWhat");
		ShowDialog(playerid, DIALOG_MATERIAL_SELECTION, houseid);
	}
	if(dialogid == DIALOG_CHOOSE_ETHNICITY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_ASIAN;
					PlayerInfo[playerid][pGender] = SKIN_MALE;
				}
				case 1:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_ASIAN;
					PlayerInfo[playerid][pGender] = SKIN_FEMALE;
				}
				case 2:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_BLACK;
					PlayerInfo[playerid][pGender] = SKIN_MALE;
				}
				case 3:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_BLACK;
					PlayerInfo[playerid][pGender] = SKIN_FEMALE;
				}
				case 4:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_HISPANIC;
					PlayerInfo[playerid][pGender] = SKIN_MALE;
				}
				case 5:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_HISPANIC;
					PlayerInfo[playerid][pGender] = SKIN_FEMALE;
				}
				case 6:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_WHITE;
					PlayerInfo[playerid][pGender] = SKIN_MALE;
				}
				case 7:
				{
					PlayerInfo[playerid][pEthnicity] = SKIN_WHITE;
					PlayerInfo[playerid][pGender] = SKIN_FEMALE;
				}
			}
			RandomSkinForPlayer(playerid);
		}
		else return ShowDialog(playerid, DIALOG_CHOOSE_ETHNICITY), 1;
	}
	if(dialogid == DIALOG_UPGRADE_H)
	{
		if(response)
		{
			new iMainContent[500], iFormat[129];
			new houseid = IsPlayerOutHouse(playerid);
			if(houseid != -1)
			{
				new zone[75];
				GetZone(HouseInfo[houseid][hX],HouseInfo[houseid][hY],HouseInfo[houseid][hZ],zone);
				switch(listitem)
				{
					case 0: // interior
					{
						strcat(iMainContent, "Level\tPrice\n");
						for(new i = 0; i < sizeof(IntInfo); i++)
						{
							format(iFormat,sizeof(iFormat)," %d\t$%s\n", IntInfo[i][intLevel], number_format(IntInfo[i][intPrice]));
							strcat(iMainContent,iFormat);
						}
						ShowPlayerDialog(playerid, DIALOG_H_UPGRADE, DIALOG_STYLE_TABLIST_HEADERS, "House interior upgrade!", iMainContent, "Select", "Cancel");
					}
					case 1: // Alarm
					{
						if(HouseInfo[houseid][hAlarm] != 0) return SendClientError(playerid, "You already have an alarm system for this house!");
						if(HandMoney(playerid) < HOUSE_ALARM_PRICE) return SendClientError(playerid, "You need atleast $10,000,000 to upgrade your house alarm.");
						format(iFormat, sizeof(iFormat), "{B8E68A}------------------------------------------------------------------\n\n"); strcat(iMainContent, iFormat);
						format(iFormat, sizeof(iFormat), "{B8E68A}House ID: \t\t\t{FFFFFF}%d\n", houseid); strcat(iMainContent, iFormat);
						format(iFormat, sizeof(iFormat), "{B8E68A}Location: \t\t\t{FFFFFF}%s\n\n", zone); strcat(iMainContent, iFormat);
						format(iFormat, sizeof(iFormat), "{B8E68A}Price to upgrade: \t\t${FFFFFF}10,000,000\n\n", HOUSE_ALARM_PRICE);
						format(iFormat, sizeof(iFormat), "{B8E68A}------------------------------------------------------------------"); strcat(iMainContent, iFormat);
						ShowPlayerDialog(playerid, DIALOG_UPGRADE_H_ALARM, DIALOG_STYLE_MSGBOX, " Are you sure?", iMainContent, "Confirm", "Cancel");
					}
					case 2: // Garage
					{
						strcat(iMainContent, "Level\tDescription\tPrice\n");
						for(new i = 1; i < sizeof(garages); i++)
						{
							format(iFormat,sizeof(iFormat)," %d\t%s\t$%s\n", i, garages[i][g_desc], number_format(garages[i][g_price]));
							strcat(iMainContent,iFormat);
						}
						ShowPlayerDialog(playerid, DIALOG_G_UPGRADE, DIALOG_STYLE_TABLIST_HEADERS, "House garage interior upgrade!", iMainContent, "Select", "Cancel");
					}
					case 3: // Wardrobe
					{
						if(HouseInfo[houseid][hWardrobe] != 0) return SendClientError(playerid, "You already have a wardrobe system for this house!");
						if(HandMoney(playerid) < 5000000) return SendClientError(playerid, "You need atleast $5,000,000 to upgrade your house wardrobe.");
						format(iFormat, sizeof(iFormat), "{B8E68A}------------------------------------------------------------------\n\n"); strcat(iMainContent, iFormat);
						format(iFormat, sizeof(iFormat), "{B8E68A}House ID: \t\t\t{FFFFFF}%d\n", houseid); strcat(iMainContent, iFormat);
						format(iFormat, sizeof(iFormat), "{B8E68A}Location: \t\t\t{FFFFFF}%s\n\n", zone); strcat(iMainContent, iFormat);
						strcat(iMainContent, "{B8E68A}Price to upgrade: \t\t${FFFFFF}5,000,000\n\n");
						format(iFormat, sizeof(iFormat), "{B8E68A}------------------------------------------------------------------"); strcat(iMainContent, iFormat);
						ShowPlayerDialog(playerid, DIALOG_UPGRADE_H_WARDROBE, DIALOG_STYLE_MSGBOX, " Are you sure?", iMainContent, "Confirm", "Cancel");	
					}
					case 4: // Armour
					{
						if(HouseInfo[houseid][hArmour] != 0) return SendClientError(playerid, "You already have a armour system for this house!");
						if(HandMoney(playerid) < 15000000) return SendClientError(playerid, "You need atleast $15,000,000 to upgrade your house armour.");
						format(iFormat, sizeof(iFormat), "{B8E68A}------------------------------------------------------------------\n\n"); strcat(iMainContent, iFormat);
						format(iFormat, sizeof(iFormat), "{B8E68A}House ID: \t\t\t{FFFFFF}%d\n", houseid); strcat(iMainContent, iFormat);
						format(iFormat, sizeof(iFormat), "{B8E68A}Location: \t\t\t{FFFFFF}%s\n\n", zone); strcat(iMainContent, iFormat);
						strcat(iMainContent, "{B8E68A}Price to upgrade: \t\t${FFFFFF}15,000,000\n\n");
						format(iFormat, sizeof(iFormat), "{B8E68A}------------------------------------------------------------------"); strcat(iMainContent, iFormat);
						ShowPlayerDialog(playerid, DIALOG_UPGRADE_H_ARMOUR, DIALOG_STYLE_MSGBOX, " Are you sure?", iMainContent, "Confirm", "Cancel");	
					}
				}
			}
			else return SendClientError(playerid, "You left the house area!");
		}
	}
	if(dialogid == DIALOG_UPGRADE_H_ALARM)
	{
		if(response)
		{
			new houseid = IsPlayerOutHouse(playerid);
			if(houseid == -1) return SendClientError(playerid, "You left the house area!");
			SendClientMessage(playerid, 0x4DB8B8FF, "_______________________________________________________________________________");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "Congratulations, your house now has an alarm system.");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "The police and yourself will now be alerted if your house is being burgled.");
			SendClientMessage(playerid, 0x4DB8B8FF, "_______________________________________________________________________________");
			GivePlayerMoneyEx(playerid, -25000);
			HouseInfo[houseid][hAlarm] = 1;
			SaveHouse(houseid);
		}
	}
	if(dialogid == DIALOG_UPGRADE_H_WARDROBE)
	{
		if(response)
		{
			new houseid = IsPlayerOutHouse(playerid);
			if(houseid == -1) return SendClientError(playerid, "You left the house area!");
			SendClientMessage(playerid, 0x4DB8B8FF, "_______________________________________________________________________________");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "Congratulations, your house now has an wardrobe system.");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "You can now store up to 5 skins inside your house to change at anytime.");
			SendClientMessage(playerid, 0x4DB8B8FF, "_______________________________________________________________________________");
			GivePlayerMoneyEx(playerid, -5000);
			HouseInfo[houseid][hWardrobe] = 1;
			SaveHouse(houseid);
			UpdateHouse(houseid);
		}
	}
	if(dialogid == DIALOG_UPGRADE_H_ARMOUR)
	{
		if(response)
		{
			new houseid = IsPlayerOutHouse(playerid);
			if(houseid == -1) return SendClientError(playerid, "You left the house area!");
			SendClientMessage(playerid, 0x4DB8B8FF, "_______________________________________________________________________________");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "Congratulations, your house now has an armour system.");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "");
			SendClientMessage(playerid, COLOR_LIGHTGREY, "You can now use \"/heal\" to restore your armour at 100%%.");
			SendClientMessage(playerid, 0x4DB8B8FF, "_______________________________________________________________________________");
			GivePlayerMoneyEx(playerid, -40000);
			HouseInfo[houseid][hArmour] = 1;
			SaveHouse(houseid);
		}
	}
/****************************************************************
	[My business stats]:
****************************************************************/
	if(dialogid == DIALOG_MYBUSINESSES)
	{
		if(response)
		{
			new iCount;
			if(GetPlayerBusinesses(playerid) >= 1) // owned
			{
				new businessid = -1;
				BusinessLoop(b)
				{
					if(BusinessInfo[b][bActive] != true) continue;
					if(!strcmp(BusinessInfo[b][bOwner], PlayerName(playerid), false))
					{
						if(iCount == listitem)
						{
							businessid = b;
							break;
						}
						iCount++;
					}
				}
				switch(businessid)
				{
					case -1: ShowDialog(playerid, DIALOG_MY_B_DUPELICATES);
					default: ShowDialog(playerid, DIALOG_SHOW_B_OWN_INFO, businessid);
				}
			}
			else
			{
				switch(listitem)
				{
					case 0: ShowDialog(playerid, DIALOG_MYBUSINESSES);
					case 1: ShowDialog(playerid, DIALOG_MY_B_DUPELICATES);
				}
			}
		}
	}
	if(dialogid == DIALOG_MY_B_DUPELICATES)
	{
		if(response)
		{
			
		}
		else return ShowDialog(playerid, DIALOG_MYBUSINESSES);
	}
	if(dialogid == DIALOG_SHOW_B_OWN_INFO) return ShowDialog(playerid, DIALOG_MYBUSINESSES), 1;
	if(dialogid == DIALOG_WARDROBE)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!"), 1;
		if(response)
		{
			switch(listitem)
			{
				case 0,1,2,3,4: // slots
				{
					SetPVarInt(playerid, "WardrobeSlotSelect", listitem+1); // to avoid slot 0 - default :/
					ShowDialog(playerid, DIALOG_WARDROBE_OPTIONS, houseid);
				}
				case 5: // wardrobe info
				{	
					ShowDialog(playerid, DIALOG_WARDROBE, houseid);
					//ShowDialog(playerid, DIALOG_WARDROBE_INFO, houseid);
				}
				case 6: // remove skins from all.
				{
					for(new c = 0; c < 5; c++)
					{
						HouseInfo[houseid][hSkins][c] = -1;
					}
					SaveHouse(houseid);
					SendClientMessage(playerid, 0xB2B2B2FF, "[Wardrobe]{FFFFFF} All clothing slots have been removed.");
					ShowDialog(playerid, DIALOG_WARDROBE, houseid);
				}
			}
		}
		else SetTimerEx("SafeWarDrobeLimit", 1500, false, "i", playerid);
	}
	if(dialogid == DIALOG_WARDROBE_INFO)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!"), 1;
		ShowDialog(playerid, DIALOG_WARDROBE, houseid);
	}
	if(dialogid == DIALOG_WARDROBE_OPTIONS)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid == -1) return SendClientError(playerid, "You have left the house!"), 1;
		if(response)
		{
			new slotID = GetPVarInt(playerid, "WardrobeSlotSelect");
			switch(listitem)
			{
				case 0: // replace
				{
					/* Remove skin from house and replace with the one the player is current wearing. */
					slotID = slotID - 1;
					if(HouseInfo[houseid][hSkins][slotID] != -1)
					{
						ShowDialog(playerid, DIALOG_WARDROBE_OPTIONS, houseid);
						return 1;
					}
					HouseInfo[houseid][hSkins][slotID] = GetPlayerSkin(playerid);
					SendClientMessage(playerid, 0xB2B2B2FF, "[Wardrobe]{FFFFFF} Clothing slot replaced.");
				}
				case 1: // switch
				{
					/* Remove player skin and place the one that's inside the house active with his old one */
					slotID = slotID - 1;
					if(HouseInfo[houseid][hSkins][slotID] == -1)
					{
						ShowDialog(playerid, DIALOG_WARDROBE_OPTIONS, houseid);
						return 1;
					}
					new curSkin = GetPlayerSkin(playerid);
					SetPlayerSkin(playerid, HouseInfo[houseid][hSkins][slotID]);
					PlayerInfo[playerid][Skin] = HouseInfo[houseid][hSkins][slotID];
					HouseInfo[houseid][hSkins][slotID] = curSkin;
					SendClientMessage(playerid, 0xB2B2B2FF, "[Wardrobe]{FFFFFF} Clothing slot switched.");
				}
				case 2: // remove
				{
					/* Remove skin from house @ slot selected */
					slotID = slotID - 1;
					if(HouseInfo[houseid][hSkins][slotID] == -1)
					{
						ShowDialog(playerid, DIALOG_WARDROBE_OPTIONS, houseid);
						return 1;
					}
					HouseInfo[houseid][hSkins][slotID] = -1;
					SendClientMessage(playerid, 0xB2B2B2FF, "[Wardrobe]{FFFFFF} Clothing removed from slot.");
				}
			}
			SaveHouse(houseid);
			ShowDialog(playerid, DIALOG_WARDROBE, houseid), DeletePVar(playerid, "WardrobeSlotSelect");
		}
		else ShowDialog(playerid, DIALOG_WARDROBE, houseid), DeletePVar(playerid, "WardrobeSlotSelect");
	}
	
	if(dialogid == DIALOG_H_BASE_TEXTURES)
	{
		if(response)
		{
			new iHouse = PlayerTemp[playerid][tmphouse];
			if(iHouse != -1)
			{
				new iMaterialSelect = -1,
					hInteriorEx = HouseInfo[iHouse][hInteriorPack],
					iCount;
				for(new c = 0; c < sizeof(HouseMaterialInfo); c++)
				{
					if(HouseMaterialInfo[c][hmLevel] != hInteriorEx) continue;
					if(iCount == listitem) {	iMaterialSelect = HouseMaterialInfo[c][hmMaterialIndex]; break; }
					iCount++;
				}
				if(iMaterialSelect == -1) // remove all materials
				{
					for(new hiss = 0; hiss < IntInfo[hInteriorEx][intMaterials]; hiss++)
					{
						new iFormat[128];
						format(iFormat, sizeof(iFormat), "TextureSlot-%d", hiss);
						if(dini_Isset(HouseTextureDirectory(iHouse), iFormat))
						{
							dini_Unset(HouseTextureDirectory(iHouse), iFormat);
						}

						format(iFormat, sizeof(iFormat), "ColourSlot-%d", hiss);
						if(dini_Isset(HouseTextureDirectory(iHouse), iFormat))
						{
							dini_Unset(HouseTextureDirectory(iHouse), iFormat);
						}
					}
					UpdateHouse(iHouse);
					ShowDialog(playerid, DIALOG_H_BASE_TEXTURES);
				}
				else ShowDialog(playerid, DIALOG_H_BASE_SELECTED, iMaterialSelect);
			}
			else return SendClientError(playerid, "You are no longer inside any house.");
		}
	}
	if(dialogid == DIALOG_H_BASE_SELECTED)
	{
		if(response)
		{
			new iHouse = PlayerTemp[playerid][tmphouse];
			if(iHouse != -1)
			{
				new iMaterialSelect = GetPVarInt(playerid, "HBaseTextureSlot");
				switch(listitem)
				{
					case 0: // edit colour
					{
						SetPVarInt(playerid, "HBaseEditTexture", 2);
						ShowDialog(playerid, DIALOG_H_BASE, iMaterialSelect);
					}
					case 1: // remove colour
					{
						new iFormat[38];
						format(iFormat, sizeof(iFormat), "ColourSlot-%d", iMaterialSelect);
						dini_Unset(HouseTextureDirectory(iHouse), iFormat);
						UpdateHouse(iHouse);
						ShowDialog(playerid, DIALOG_H_BASE_SELECTED, iMaterialSelect);
					}
					case 2: // edit texture
					{
						SetPVarInt(playerid, "HBaseEditTexture", 1);
						ShowDialog(playerid, DIALOG_H_BASE, iMaterialSelect);
					}
					case 3: // remove texture
					{
						new iFormat[38];
						format(iFormat, sizeof(iFormat), "TextureSlot-%d", iMaterialSelect);
						dini_Unset(HouseTextureDirectory(iHouse), iFormat);
						UpdateHouse(iHouse);
						ShowDialog(playerid, DIALOG_H_BASE_SELECTED, iMaterialSelect);
					}
					case 4: // texture Info
					{
						
					}
				}
			}
			else return SendClientError(playerid, "You are no longer inside any house.");
		}
	}
	if(dialogid == DIALOG_H_BASE)
	{
		if(response)
		{
			new iHouse = PlayerTemp[playerid][tmphouse];
			if(iHouse != -1)
			{
				new iMaterialSelect = GetPVarInt(playerid, "HBaseTextureSlot");
				new lookingFor, iCount, iID;
				if(GetPVarInt(playerid, "HBaseEditTexture") == 1) lookingFor = MATERIAL_CATEGORY_TEXTURE;
				else lookingFor = MATERIAL_CATEGORY_COLOURS;
				for(new c = 0; c < sizeof(FurnitureMaterial); c++)
				{
					if(FurnitureMaterial[c][materialCategory] != lookingFor) continue;
					if(iCount == listitem)
					{
						iID = c;
						break;
					}
					iCount++;
				}
				new iFormat[128];
				if(lookingFor == MATERIAL_CATEGORY_TEXTURE) format(iFormat, sizeof(iFormat), "TextureSlot-%d", iMaterialSelect);
				else format(iFormat, sizeof(iFormat), "ColourSlot-%d", iMaterialSelect);
				dini_IntSet(HouseTextureDirectory(iHouse), iFormat, iID);
				UpdateHouse(iHouse);
				ShowDialog(playerid, DIALOG_H_BASE_TEXTURES);
			}
			else return SendClientError(playerid, "You are no longer inside any house.");
		}
	}
	if(dialogid == DIALOG_CLOSEST_BUSINESSES)
	{
		if(response)
		{
			new bizID = -1, atmID = -1;
			switch(listitem)
			{
				case 0: bizID = GetClosestBiz(playerid, BUSINESS_TYPE_BANK);
				case 1: bizID = GetClosestBiz(playerid, BUSINESS_TYPE_247);
				case 2: bizID = GetClosestBiz(playerid, BUSINESS_TYPE_HARDWARE);
				case 3: bizID = GetClosestBiz(playerid, BUSINESS_TYPE_CLOTHES);
				case 4: bizID = GetClosestBiz(playerid, BUSINESS_TYPE_PAYNSPRAY);
				case 5: atmID = GetClosestATM(playerid);
				case 6: bizID = GetClosestBiz(playerid, BUSINESS_TYPE_GAS);
			}
			new Float:possX, Float:possY, Float:possZ;
			if(atmID != -1)
			{
				possX = ATMInfo[atmID][atmX];
				possY = ATMInfo[atmID][atmY];
				possZ = ATMInfo[atmID][atmZ];
			}
			else
			{
				possX = BusinessInfo[bizID][bX];
				possY = BusinessInfo[bizID][bY];
				possZ = BusinessInfo[bizID][bZ];
			}
			SetPlayerCheckpoint(playerid, possX, possY, possZ, 3.0);
		}
	}
	if(dialogid == DIALOG_WIRETRANSFER_NAME)
	{
		if(response)
		{
			if(!strlen(inputtext) || strlen(inputtext) < 4 || strlen(inputtext) > MAX_PLAYER_NAME)
			{
				SendClientError(playerid, "Invalid name, try again.");
				ShowDialog(playerid, DIALOG_WIRETRANSFER_NAME);
				return 1;
			}
			new giveplayerid = GetPlayerId(inputtext);
			if(!IsPlayerConnected(giveplayerid))
			{
				SendClientError(playerid, "Invalid name, try again.");
				ShowDialog(playerid, DIALOG_WIRETRANSFER_NAME);
				return 1;
			}
			if(playerid == giveplayerid)
			{
				SendClientError(playerid, "You can't send a wiretransfer to yourself.");
				ShowDialog(playerid, DIALOG_WIRETRANSFER_NAME);
				return 1;
			}
			SetPVarString(playerid, "WireTransfer", inputtext);
			ShowDialog(playerid, DIALOG_WIRETRANSFER_AMOUNT);
		}
		else ShowDialog(playerid, DIALOG_LAPTOP);
	}
	if(dialogid == DIALOG_WIRETRANSFER_AMOUNT)
	{
		if(response)
		{
			if(!strlen(inputtext) || !IsNumeric(inputtext))
			{
				SendClientError(playerid, "Invalid input. Please keep it numeric.");
				ShowDialog(playerid, DIALOG_WIRETRANSFER_AMOUNT);
				return 1;
			}
			new iAmount = strval(inputtext);
			if(iAmount > MAX_TRANSFER_AMOUNT || iAmount <= 0 || iAmount > PlayerInfo[playerid][bank])
			{
				SendClientError(playerid, "Invalid amount.");
				ShowDialog(playerid, DIALOG_WIRETRANSFER_AMOUNT);
				return 1;
			}
			new iPlayer[MAX_PLAYER_NAME];
			GetPVarString(playerid, "WireTransfer", iPlayer, sizeof(iPlayer));
			if(IsPlayerConnected(GetPlayerId(iPlayer)))
			{
				SetBank(PlayerName(playerid), iPlayer, iAmount);
				return 1;
			}
			else SendClientInfo(playerid, "Player has disconnected, transfer failed.");
		}
		else ShowDialog(playerid, DIALOG_WIRETRANSFER_NAME);
	}
	if(dialogid == DIALOG_V_FIND)
	{
		if(response)
		{
			new iCount, vehicleID;
			VehicleLoop(v)
			{
				if(VehicleInfo[v][vActive] != true) continue;
				//if(VehicleInfo[v][vSpawned] != true) continue;
				if(!strcmp(VehicleInfo[v][vOwner], PlayerName(playerid), false))
				{
					if(iCount == listitem)
					{
						vehicleID = v;
						break;
					}
					iCount++;
				}
			}
			new carID = GetCarID(vehicleID), vWorldID;
			vWorldID = GetVehicleVirtualWorld(carID);
			new Float:vPosX, Float:vPosY, Float:vPosZ;
			if(vWorldID != 0) // in garage
			{
				new hgID = vWorldID - 1;
				vPosX = HouseInfo[hgID][hGarageX];
				vPosY = HouseInfo[hgID][hGarageY];
				vPosZ = HouseInfo[hgID][hGarageZ];
			}
			else
			{
				GetVehiclePos(carID, vPosX, vPosY, vPosZ);
			}
			new iZone[75];
			GetZone(vPosX, vPosY, vPosZ, iZone);
			SendClientMSG(playerid, COLOR_LIGHTGREY, " Your %s has been found in %s! Checkpoint set.", GetVehicleName(carID), iZone);
			SetPlayerCheckpoint(playerid, vPosX, vPosY, vPosZ, 5.0);
		}
	}
	if(dialogid == DIALOG_INVENTORY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: ShowDialog(playerid, INVE_MY_HOUSES);
				case 1: ShowDialog(playerid, INVE_MY_BUSINESSES);
				case 2: ShowDialog(playerid, INVE_MY_VEHICLES);
				case 3: ShowDialog(playerid, INVE_MY_DRUGS);
				case 4: ShowDialog(playerid, INVE_MY_SEEDS);
				case 5: ShowDialog(playerid, INVE_MY_WEAPONS);
				case 6: ShowDialog(playerid, INVE_MY_ITEMS);
			}
		} else return 1;
	}
	if(dialogid == INVE_MY_HOUSES)
	{
		if(response) ShowDialog(playerid, DIALOG_INVENTORY);
		else return 1;
	}
	if(dialogid == INVE_MY_BUSINESSES)
	{
		if(response) ShowDialog(playerid, DIALOG_INVENTORY);
		else return 1;
	}
	if(dialogid == INVE_MY_VEHICLES)
	{
		if(response) ShowDialog(playerid, DIALOG_INVENTORY);
		else return 1;
	}
	if(dialogid == INVE_MY_DRUGS)
	{
		if(response) ShowDialog(playerid, DIALOG_INVENTORY);
		else return 1;
	}
	if(dialogid == INVE_MY_SEEDS)
	{
		if(response) ShowDialog(playerid, DIALOG_INVENTORY);
		else return 1;
	}
	if(dialogid == INVE_MY_WEAPONS)
	{
		if(response) ShowDialog(playerid, DIALOG_INVENTORY);
		else return 1;
	}
	if(dialogid == INVE_MY_ITEMS)
	{
		if(response) ShowDialog(playerid, DIALOG_INVENTORY);
		else return 1;
	}
	if(dialogid == DIALOG_TRUCKER_SLCT)
	{
		if(response)
		{
			new iDeliver = listitem;
			new iFormat[228], iCargo[25], iLocation[75], iPrice;
			GetZone(deliver[iDeliver][deliverX], deliver[iDeliver][deliverY], deliver[iDeliver][deliverZ], iLocation);
			myStrcpy(iCargo, deliver[iDeliver][deliverCargo]);
			new Float:dist = GetPlayerDistanceToPointEx(playerid, deliver[iDeliver][deliverX], deliver[iDeliver][deliverY], deliver[iDeliver][deliverZ]);
			new distReal = floatround(dist);
			iPrice = (distReal * 5);

			format(iFormat, sizeof(iFormat), "Trucker: {E0E0E0}You will deliver {EDCE51}%s{E0E0E0} to {EDCE51}%s{E0E0E0} and earn approximately {33D113}$%s!", iCargo, iLocation, number_format(iPrice));
			SendClientMessage(playerid, 0x187234FF, iFormat);

			format(iFormat, sizeof(iFormat), "Trucker: {E0E0E0}Please proceed to the loading bay (checkpoint marked). You have 60 seconds to load.");
			SendClientMessage(playerid, 0x187234FF, iFormat);

			SetPlayerCheckpoint(playerid, 2239.4912, -2609.5598, 13.5200, 3.0);
			SetPVarInt(playerid, "PCargo", 1); // PickingCargo
			SetPVarInt(playerid, "CargoLoad", iDeliver + 1); // to avoid 0 when delete p var
			SetTimerEx("TruckerCancelCargo", 60000, false, "d", playerid);
		}
		else return 1;
	}
	return 1;
}