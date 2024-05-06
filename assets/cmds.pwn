/*********************************************************************************************************************************************
						- NYOGames [cmds.pwn file]
*********************************************************************************************************************************************/
				// SELF NOTE !!!!
//		Finish /amove
//		
//
//
//
//=====================================================

COMMAND:commands(playerid, params[])
{
	ShowDialog(playerid, DIALOG_CMD_CMDS);
	return 1;
}

COMMAND:charity(playerid, params[])
{
	new iAmount, iReason[ 128 ];
	if(sscanf(params, "ds", iAmount, iReason)) return SCP(playerid, "[amount] [reason]");
	if(iAmount < 1 || iAmount > HandMoney(playerid)) return SCP(playerid, "[amount] [reason ]- INVALID AMOUNT!");
	GivePlayerMoneyEx(playerid, -iAmount);
	format(iStr, sizeof(iStr), "** Charity: %s (ID: %d) | Amount: $%s | Reason: %s", RPName(playerid), playerid, number_format(iAmount), iReason);
	SendClientMessage(playerid, COLOR_HELPEROOC, iStr);
	SendClientMessageToAdmins(iStr,COLOR_HELPEROOC);
	CharityLog(playerid, iAmount, iReason);
	return 1;
}
COMMAND:pm(playerid, params[])
{
	if(GetPVarInt(playerid, "togPM") == 1) return SendClientError(playerid, "You have private mesasges disables. Use /togpm to re-enable.");
	new iPlayer, iText[ 128 ];
	if( sscanf ( params, "us", iPlayer, iText))  return SCP(playerid, "[PlayerID/PartOfName] [message]");
	if(GetPVarInt(iPlayer, "togPM") == 1 && !GetAdminLevel(playerid)) return SendClientError(playerid, "That player has blocked incoming private messages.");
	format(iStr, sizeof(iStr), "(( %s(%d): %s ))", RPName(playerid), playerid, iText);
	SendClientMessage(iPlayer,0xE65CE6FF, iStr);
	if(PlayerTemp[iPlayer][lastpm] == 666) SendClientMessage(iPlayer, -1, "{d9d9d5} You can use {b4b4b1}\"/re [message]\" {d9d9d5}to send a quick reply.");
	format(iStr, sizeof(iStr), "(( PM sent %s(%d): %s ))", RPName(iPlayer), iPlayer, iText);
	SendClientMessage(playerid, 0xE65CE6FF, iStr);
	format( iStr, sizeof(iStr), "13[PM] (( %s(%d) to %s(%d): %s ))",PlayerName(playerid), playerid, PlayerName(iPlayer), iPlayer, iText);
	iEcho( iStr );
	PlayerTemp[iPlayer][lastpm] = playerid;
	return 1;
}
COMMAND:opm(playerid, params[])
{
	new iPlayer[MAX_PLAYER_NAME], iText[ 128 ];
	if( sscanf ( params, "ss", iPlayer, iText))  return SCP(playerid, "[Player_Name] [message]");
	if(AccountExist(iPlayer) == false) return SendClientError(playerid, "Account hasn't been found!");
	if(IsPlayerConnected(GetPlayerId(iPlayer))) return SendClientError(playerid, "That player is connected, use /pm!");
	SendClientMSG(playerid, 0xE65CE6FF, "(( OPM sent %s: %s ))", iPlayer, iText);
	SendClientMSG(playerid, 0xd9d9d5FF, " %s will see this message, once he / she is online.", iPlayer);
	format( iStr, sizeof(iStr), "13[OPM] (( %s(%d) to %s: %s ))",PlayerName(playerid), playerid, iPlayer, iText);
	iEcho( iStr );
	new iQuery[212];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `OPMs` (`To`, `From`, `Message`) VALUES ('%e', '%e', '%e')", iPlayer, PlayerName(playerid), iText);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}
COMMAND:re(playerid, params[])
{
	if(PlayerTemp[playerid][lastpm] == 666) return SendClientError(playerid, "Noone has sent you a private message.");
	new iText[ 128 ];
	if( sscanf ( params, "s", iText)) return SCP(playerid, "[message]");
	format(iStr, sizeof(iStr), "/pm %d %s", PlayerTemp[playerid][lastpm], iText);
	OnPlayerCommandText(playerid, iStr);
	return 1;
}
COMMAND:stats(playerid)
{
	GetStats(playerid, playerid);
	return 1;
}
COMMAND:driverlicense(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1088.4662,1468.7936,5.8481)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(PlayerInfo[playerid][driverlic] || GetPVarInt(playerid, "IsMakingDriverLic") == 1) return SendClientError(playerid, "You already have this license!");
	if(HandMoney(playerid) < 7500) return SendClientError(playerid, "You need $7,500 in order to start a license test!");
	PlayerTemp[playerid][lictimer] = SetTimerEx("_driverlic", 1000, true, "d", playerid);
	DeletePVar(playerid, "DriverLic");
	SetPVarInt(playerid, "IsMakingDriverLic", 1);
	return 1;
}
COMMAND:sailinglicense(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2185.90,2415.99,5.17)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(PlayerInfo[playerid][boatlic]) return SendClientError(playerid, "You already have this license!");
	if(HandMoney(playerid) < 5000) return SendClientError(playerid, "You need $5.000 in order to start a license test!");
	PlayerInfo[playerid][boatlic] = 1;
	SendClientMSG(playerid, COLOR_HELPEROOC, "[License] {BEBABA}%s you have successfully recieved your sailing license, water vehicles are now ownable.", RPName(playerid));
	GameTextForPlayer(playerid, "~g~license received", 5000, 4);
	GivePlayerMoneyEx(playerid, -5000);
	return 1;
}
COMMAND:pilotlicense(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 414.7200,2531.3000,19.1700)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(PlayerInfo[playerid][flylic]) return SendClientError(playerid, "You already have this license!");
	if(HandMoney(playerid) < 10000) return SendClientError(playerid, "You need $10.000 in order to retrieve your license");
	PlayerInfo[playerid][flylic] = 1;
	SendClientMSG(playerid, COLOR_HELPEROOC, "[License] {BEBABA}%s you have successfully recieved your pilot license, aircrafts are now ownable.", RPName(playerid));
	GameTextForPlayer(playerid, "~g~license received", 5000, 4);
	GivePlayerMoneyEx(playerid, -10000);
	return 1;
}
COMMAND:enter(playerid)
{
    CheckEnter(playerid, 1);
    return 1;
}
COMMAND:exit(playerid)
{
    CheckExit(playerid, 1);
    return 1;
}
COMMAND:id(playerid, params[])
{
	new tofind[ MAX_PLAYER_NAME ];
	if( sscanf ( params, "s", tofind) || strlen(params) > MAX_PLAYER_NAME) return SCP(playerid, "[PartOfName]");
	new iC;
	SendClientMessage(playerid, COLOR_HELPEROOC, "[GetID] Results:");
	PlayerLoop(i)
	{
	    if(strfind(PlayerName(i), tofind, true) != -1) SendClientMSG(playerid, COLOR_LIGHTGREY, " %s [ID: %d] [Level: %d]", RPName(i), i, PlayerInfo[i][playerlvl]);
		++iC;
	}
	if(!iC) return SendClientMSG(playerid, COLOR_LIGHTGREY, " No player found.");
    return 1;
}
ALTCOMMAND:getid->id;
COMMAND:togpm(playerid, params[])
{
	if(GetPVarInt(playerid, "togPM") == 1)
	{
	    DeletePVar(playerid, "togPM");
	    SendClientInfo(playerid, "You have enabled private messaging.");
	}
	else
	{
	    SetPVarInt(playerid, "togPM", 1);
	    SendClientInfo(playerid, "You have disabled private messaging. You cannot use /pm anymore.");
	}
	return 1;
}
COMMAND:number(playerid, params[])
{
    if(!PlayerInfo[playerid][phonebook]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!PlayerInfo[iPlayer][phonenumber]) return SendClientError(playerid, "Player doesn't have a cellphone!");
	SendClientMSG(playerid, COLOR_YELLOW, "* Phonebook: %s - Number: %d", RPName(iPlayer), PlayerInfo[iPlayer][phonenumber]);
	return 1;
}
COMMAND:freq(playerid, params[])
{
	if(!PlayerInfo[playerid][radio]) return SendClientError(playerid, "You don't have a radio!");
	new slot, tmpfreq;
	if(sscanf(params,"dd", slot, tmpfreq)) return SCP(playerid, "[slot (1-3)]");
	if(slot < 1 || slot > 3) return SCP(playerid, "[slot (1-3)]");
	if(tmpfreq<100000 || tmpfreq>999999) return SendClientError(playerid, "Invalid frequency!");
	if(slot == 1) PlayerInfo[playerid][freq1]=tmpfreq;
	else if(slot == 2) PlayerInfo[playerid][freq2]=tmpfreq;
	else if(slot == 3) PlayerInfo[playerid][freq3]=tmpfreq;
	format(iStr,sizeof(iStr),"[Radio]: Slot %d will now listen to frequency %d.",slot, tmpfreq);
	SendClientMessage(playerid,COLOR_GREENYELLOW,iStr);
	format(iStr,sizeof(iStr),"[Radio]: Use /syncradio %d to talk in that frequency.",slot);
	SendClientMessage(playerid,COLOR_GREENYELLOW,iStr);
	return 1;
}
COMMAND:syncradio(playerid, params[])
{
	if(!PlayerInfo[playerid][radio]) return SendClientError(playerid, "You don't have a radio!");
	new slot;
	if(sscanf(params,"d", slot)) return SCP(playerid, "[slot (1-3)]");
	if(slot < 1 || slot > 3) return SCP(playerid, "[slot (1-3)]");
	if(slot == 1 && PlayerInfo[playerid][freq1] == INVALID_RADIO_FREQ) return SendClientError(playerid, "You don't have any frequency on slot 1! /freq 1 [frequency]");
	if(slot == 2 && PlayerInfo[playerid][freq2] == INVALID_RADIO_FREQ) return SendClientError(playerid, "You don't have any frequency on slot 2! /freq 2 [frequency]");
	if(slot == 3 && PlayerInfo[playerid][freq3] == INVALID_RADIO_FREQ) return SendClientError(playerid, "You don't have any frequency on slot 3! /freq 3 [frequency]");
	if(slot == 1) PlayerInfo[playerid][curfreq] = PlayerInfo[playerid][freq1];
	if(slot == 2) PlayerInfo[playerid][curfreq] = PlayerInfo[playerid][freq2];
	if(slot == 3) PlayerInfo[playerid][curfreq] = PlayerInfo[playerid][freq3];
	SendClientMSG(playerid,COLOR_GREENYELLOW,"[Radio]: You will now talk in the frequency %d (Radio Slot %d)",PlayerInfo[playerid][curfreq],slot);
	SendClientMSG(playerid,COLOR_GREENYELLOW,"[Radio]: Use /syncradio %d to change the frequency you wanna talk in.", slot);
	return 1;
}
COMMAND:paybail(playerid)
{
	if(PlayerInfo[playerid][jail] && PlayerInfo[playerid][bail]>0)
	{
		if(PlayerInfo[playerid][bail]!=666 &&  PlayerInfo[playerid][bail]!=777)
		{
			GivePlayerMoneyEx(playerid,-PlayerInfo[playerid][bail]);
			new fambank = PlayerInfo[playerid][bail];
			PlayerInfo[playerid][bail] = 0;
			FactionLoop(f)
			{
				if(FactionInfo[f][fActive] != true) continue;
				if(FactionInfo[f][fType] != FAC_TYPE_POLICE) continue;
				FactionInfo[f][fBank] = FactionInfo[f][fBank] + fambank;
			}
			Action(playerid, "has payed their bail and may now be free'd by a lawyer!");
			return 1;
		}
		else return SendClientError(playerid, "You cannot pay the bail to get free'd!");
	}
	return 1;
}
COMMAND:usedrugs(playerid, params[])
{
	new tmp[14], DTYPE = -1;
	if(sscanf(params, "s", tmp)) return SCP(playerid, "[Cocaine/Weed/Ecstasy/Crack/Morphine/Trypi/Heroin/Cannabis/Speed] (/mydrugs)");
	if(GetTickCount() - PlayerTemp[playerid][drugtick] < (240000)) return SendClientError(playerid, "Please wait 4 minutes!");
	for(new q; q < sizeof(drugtypes); q++)
	{
	    if(!strcmp(drugtypes[q][drugname],tmp, true)) DTYPE = q;
	}
	if(DTYPE == -1)  return SCP(playerid, "[Cocaine/Weed/Ecstasy/Crack/Morphine/Trypi/Heroin/Cannabis/Speed] (/mydrugs)");
	if(PlayerInfo[playerid][hasdrugs][DTYPE] <= 0) return SendClientError(playerid, "You don't have any grams left!");
	new Float:pH;
	GetPlayerHealth(playerid, pH);
	if(pH + drugtypes[DTYPE][drughp] > 150) SendClientWarning(playerid, "You are risking to die!");
	SetPlayerHealth(playerid, pH+drugtypes[DTYPE][drughp]);
	GetPlayerHealth(playerid, pH);
	if(pH > 101) SetPlayerHealth(playerid, 100.0);
	PlayerInfo[playerid][hasdrugs][DTYPE]--;
	format(iStr, sizeof(iStr), "has taken some %s.", drugtypes[DTYPE][drugname]);
	Action(playerid, iStr);
	format(iStr, sizeof(iStr), "6{DRUGS} %s[%d] has used %s and gained %d HP.",PlayerName(playerid),playerid, drugtypes[DTYPE][drugname], drugtypes[DTYPE][drughp]);
	iEcho(iStr);
	PlayerTemp[playerid][drugtick] = GetTickCount();
	new DLEVEL;
	switch(DTYPE)
	{
	    case 0: DLEVEL = 6000;
	    case 1: DLEVEL = 3200;
	    case 2: DLEVEL = 9000;
	    case 3: DLEVEL = 6000;
	    case 4: DLEVEL = 11500;
	    case 5,6,7,8: DLEVEL = 6300;
	}
	SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid) + DLEVEL);
    RedScreen(playerid, minrand(15,35));
	return 1;
}
COMMAND:jq(playerid, params[])
{
	if(PlayerTemp[playerid][jqmessage] == 0)
	{
		PlayerTemp[playerid][jqmessage]=1;
		GameTextForPlayer(playerid,"~g~j/q",1000,1);
	}
	else
	{
		PlayerTemp[playerid][jqmessage]=0;
		GameTextForPlayer(playerid,"~r~j/q",1000,1);
	}
	return 1;
}
COMMAND:togenter(playerid, params[])
{
	if(PlayerTemp[playerid][key_enter] == 1)
	{
		PlayerTemp[playerid][key_enter] = 2;
		ShowInfoBox(playerid, "togenter", "you now can enter and exit buildings by pressing your f or enter key.", 10);
	}
	else
	{
		PlayerTemp[playerid][key_enter] = 1;
		ShowInfoBox(playerid, "togenter", "you now have to type /enter and /exit to enter or exit buildings.", 10);
	}
	return 1;
}
COMMAND:name(playerid, params[])
{
	if(PlayerInfo[playerid][power] || PlayerInfo[playerid][premium] || PlayerInfo[playerid][playerlvl]>= 15)
	{
		if(PlayerTemp[playerid][hname] == 1)
		{
			PlayerTemp[playerid][hname]=0;
			GameTextForPlayer(playerid,"~g~Name On",1000,1);
			PlayerLoop(i) ShowPlayerNameTagForPlayer(i,playerid,1);
		}
		else
		{
			GenerateStrangerID(playerid);
			PlayerTemp[playerid][hname] = 1;
			GameTextForPlayer(playerid, "~r~Name Off", 1000, 1);
			PlayerLoop(i)
			{
				if(!PlayerInfo[i][power])
				{
					ShowPlayerNameTagForPlayer(i,playerid,0);
				}
			}
		}
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:phone(playerid, params[])
{
	if(PlayerInfo[playerid][power] || PlayerInfo[playerid][premium] || PlayerInfo[playerid][playerlvl] >= 15)
	{
		if(PlayerTemp[playerid][phoneoff] == 1)
		{
			PlayerTemp[playerid][phoneoff]=0;
			GameTextForPlayer(playerid,"~g~phone",1000,1);
			Action(playerid, "has turned their cellphone on.");
		}
		else
		{
			PlayerTemp[playerid][phoneoff]=1;
			GameTextForPlayer(playerid,"~r~phone",1000,1);
			Action(playerid, "has turned their cellphone off.");
		}
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:myhouses(playerid, params[])
{
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	SendClientMSG(playerid, 0x3696EBFF, "Houses owned by %s:", RPName(playerid));
	HouseLoop(h)
	{
	    if(HouseInfo[h][hActive] != true) continue;
	    if(!strcmp(HouseInfo[h][hOwner], PlayerName(playerid), false))
	    {
	        new zone[ 32 ];
	        GetZone(HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ], zone);
	        format(iStr, sizeof(iStr), "[ID: %d] [Rent: %s] [Till: $%s] [Location: %s]", h, number_format(HouseInfo[h][hRentprice]), number_format(HouseInfo[h][hTill]), zone);
	        SendClientMessage(playerid, 0xE0E0E0FF, iStr);
	    }
	}
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	return 1;
}
ALTCOMMAND:hlist->myhouses;
/* COMMAND:myvehicles(playerid)
{
	new
		iBigStr[ 386 ];

	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	for(new i = 1; i < sizeof(VehicleInfo); i++)
	{
	    if(!strcmp(VehicleInfo[i][vOwner], PlayerName(playerid), false))
	    {
	        new zone[ 80 ], Float:vipos[3], lockstr[10];
	        if(VehicleInfo[i][vLocked]) myStrcpy(lockstr, "Yes");
	        else myStrcpy(lockstr, "No");
	        GetVehiclePos(i, vipos[0], vipos[1], vipos[2]);
	        GetZone(vipos[0], vipos[1], vipos[2], zone);
	        format(iBigStr, sizeof(iBigStr), "(%d) %s | Alarm: %d | Location: %s | Locked: %s | Mileage: %dkm | Plate: %s", i, GetVehicleName(i), VehicleInfo[i][vAlarm], zone, lockstr, floatround(VehicleInfo[i][vMileage]), VehicleInfo[i][vPlate], NoUnderscore(VehicleInfo[i][vDupekey]));
	        if(strcmp(VehicleInfo[i][vDupekey], "NoBodY", true))
	        {
	            new tmp[ 64 ];
	            format(tmp, sizeof(tmp), "[Dupe-Key: %s]", VehicleInfo[i][vDupekey]);
	            strcat(iBigStr, tmp);
	        }
	        if(VehicleInfo[i][vImpounded] == 1) strcat(iBigStr, " | Impounded: Yes");
	        SendClientMessage(playerid, -1, iBigStr);
	    }
	}
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	if(HasDupeKeys(playerid))
	{
		SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	    for(new i = 1; i < sizeof(VehicleInfo); i++)
		{
	   	    if(!strcmp(VehicleInfo[i][vDupekey], PlayerName(playerid), false))
		    {
		        new zone[ 80 ], Float:vipos[3], lockstr[10];
		        if(VehicleInfo[i][vLocked]) myStrcpy(lockstr, "Yes");
		        else myStrcpy(lockstr, "No");
		        GetVehiclePos(i, vipos[0], vipos[1], vipos[2]);
		        GetZone(vipos[0], vipos[1], vipos[2], zone);
		        format(iBigStr, sizeof(iBigStr), "{6baf59}[DUPE] {bebaba}(ID %d) {51983e}%s [Location: {bebaba}%s{51983e}] [Locked: {bebaba}%s{51983e}]", i, GetVehicleName(i), zone, lockstr);
		        if(VehicleInfo[i][vImpounded] == 1) strcat(iBigStr, " | Impounded: Yes");
		        SendClientMessage(playerid, -1, iBigStr);
		    }
		}
		SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	}
	return 1;
} 
COMMAND:myvehicles(playerid)
{
	new iBigStr[386];
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	VehicleLoop(i)
	{
		if(!strcmp(VehicleInfo[i][vOwner], PlayerName(playerid), false))
	    {
			new carid = GetCarID(i);
	        new zone[80], Float:vipos[3], lockstr[10];
	        if(VehicleInfo[i][vLocked]) myStrcpy(lockstr, "Yes");
	        else myStrcpy(lockstr, "No");
	        GetVehiclePos(i, vipos[0], vipos[1], vipos[2]);
	        GetZone(vipos[0], vipos[1], vipos[2], zone);
	        //format(iBigStr, sizeof(iBigStr), "{bebaba}(ID %d) {51983e}%s [Location: {bebaba}%s{51983e}] [Locked: {bebaba}%s{51983e}]", i, GetVehicleName(i), zone, lockstr);
	        format(iBigStr, sizeof(iBigStr), "(%d) %s | Alarm: %d | Location: %s | Mileage: %dkm | Plate: %s", i, GetVehicleName(carid), VehicleInfo[i][vAlarm], zone, floatround(VehicleInfo[i][vMileage]), VehicleInfo[i][vPlate], NoUnderscore(VehicleInfo[i][vDupekey]));
			if(strcmp(VehicleInfo[i][vDupekey], "NoBodY", true))
	        {
	            new tmp[ 64 ];
	            format(tmp, sizeof(tmp), "[Dupe-Key: %s]", VehicleInfo[i][vDupekey]);
	            strcat(iBigStr, tmp);
	        }
	        if(VehicleInfo[i][vImpounded] == 1) strcat(iBigStr, " | Impounded: Yes");
	        SendClientMessage(playerid, 0xE0E0E0FF, iBigStr);
	    }
	}
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	if(HasDupeKeys(playerid))
	{
		SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	    VehicleLoop(i)
		{
	   	    if(!strcmp(VehicleInfo[i][vDupekey], PlayerName(playerid), false))
		    {
				new carid = GetCarID(i);
		        new zone[ 80 ], Float:vipos[3], lockstr[10];
		        if(VehicleInfo[i][vLocked]) myStrcpy(lockstr, "Yes");
		        else myStrcpy(lockstr, "No");
		        GetVehiclePos(i, vipos[0], vipos[1], vipos[2]);
		        GetZone(vipos[0], vipos[1], vipos[2], zone);
				format(iBigStr, sizeof(iBigStr), "(%d) %s | Alarm: %d | Location: %s | Mileage: %dkm | Plate: %s", i, GetVehicleName(carid), VehicleInfo[i][vAlarm], zone, floatround(VehicleInfo[i][vMileage]), VehicleInfo[i][vPlate], NoUnderscore(VehicleInfo[i][vDupekey]));
				if(VehicleInfo[i][vImpounded] == 1) strcat(iBigStr, " | Impounded: Yes");
				SendClientMessage(playerid, 0xE0E0E0FF, iBigStr);
		    }
		}
		SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	}
	return 1;
} */
COMMAND:myvehicles(playerid, params)
{
	ShowDialog(playerid, INVE_MY_VEHICLES);
	return 1;
}
COMMAND:mybusinesses(playerid, params)
{
	ShowDialog(playerid, DIALOG_MYBUSINESSES);
	return 1;
}
COMMAND:dropweapon(playerid)
{
	if(!GetPlayerWeapon(playerid)) return SendClientError(playerid,"You aren't holding any weapon!");
	new pWeapon = GetPlayerWeapon(playerid);
	RemovePlayerWeapon(playerid, GetWeaponSlot(pWeapon));
	format(iStr, sizeof(iStr), "has dropped their %s.", aWeaponNames[pWeapon]);
	Action(playerid, iStr);
	return 1;
}
COMMAND:myweapons(playerid)
{
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	SendClientMSG(playerid, 0x3696EBFF, "Weapons inside %s's inventory:", RPName(playerid));
    new sweapon, sammo;
	for(new i=0; i<13; i++)
	{
		GetPlayerWeaponData(playerid, i, sweapon, sammo);
		if(sweapon != 0)
		{
			format(iStr, sizeof(iStr), "[Slot: %d] %s (Ammo: %d | Weapon ID: %d)", i, aWeaponNames[sweapon], sammo, sweapon);
			SendClientMessage(playerid, COLOR_LIGHTGREY, iStr);
		}
	}
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	return 1;
}
COMMAND:myseeds(playerid)
{
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	SendClientMSG(playerid, 0x3696EBFF, "Seeds owned by %s:", RPName(playerid));
	for(new i; i < sizeof(Seeds); i++)
	{
	    if(!strcmp(Seeds[i][sOwner], PlayerName(playerid), false))
	    {
	        new zone[50];
	        GetZone(Seeds[i][seedX], Seeds[i][seedY], Seeds[i][seedZ], zone);
	        format(iStr, sizeof(iStr), "[ID: %d] [Location: %s] [Grams made: %d] [Max: 12 grams]", i, zone, Seeds[i][sGrams]);
	        SendClientMessage(playerid, 0xE0E0E0FF, iStr);
	    }
	}
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	return 1;
}
COMMAND:mydrugs(playerid)
{
    new
        tmp[ 120 ];
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	SendClientMSG(playerid, 0x3696EBFF, "Drugs inside %s's inventory:", RPName(playerid));
	if(PlayerInfo[playerid][sdrugs] > 0)
	{
	    format(iStr, sizeof(iStr), "Sellable Grams: %d [/selldrugs]", PlayerInfo[playerid][sdrugs]);
	    SendClientMessage(playerid, COLOR_LIGHTGREY, iStr);
	}
	LOOP:i(0, sizeof(drugtypes))
	{
		if(PlayerInfo[playerid][hasdrugs][i] == 0) continue;
	    format(tmp, sizeof(tmp), "Drug:[%s] Grams:[%d] Addiction:[%d]", drugtypes[i][drugname], PlayerInfo[playerid][hasdrugs][i], drugtypes[i][drughp]);
		SendClientMessage(playerid, COLOR_LIGHTGREY, tmp);
	}
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	return 1;
}
COMMAND:accept(playerid, params[])
{
	if(!strlen(params)) return SCP(playerid, "[ ticket / refuel / convo ]");
	if(!strcmp(params, "ticket", true))
	{
		if(!PlayerTemp[playerid][ticket]) return SendClientError(playerid, "You didn't receive any ticket!");
		GivePlayerMoneyEx(playerid,-PlayerTemp[playerid][ticket]);
		format(iStr,sizeof(iStr),"** [PD] %s has paid the ticket of $%s.",PlayerName(playerid), number_format(PlayerTemp[playerid][ticket]));
		FactionLoop(f)
		{
			if(FactionInfo[f][fActive] != true) continue;
			if(FactionInfo[f][fType] == FAC_TYPE_POLICE)
			{
				SendClientMessageToTeam(f, iStr, COLOR_PINK);
				FactionInfo[f][fBank] += PlayerTemp[playerid][ticket];
			}
		}
		PlayerTemp[playerid][ticket]=0;
		return 1;
	}
	else if(!strcmp(params, "refuel", true))
	{
		if(GetPVarInt(playerid, "RefuelID") != 0)
		{
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You need to be inside a vehicle to accept this.");
			if(HandMoney(playerid) < GetPVarInt(playerid, "RefuelPrice")) return SendClientError(playerid, "You don't have enough money.");
			new vehicleID = FindVehicleID(GetPlayerVehicleID(playerid));
			VehicleInfo [ vehicleID ] [vFuel] = 100;
			new iFormat[136];
			format(iFormat, sizeof(iFormat), "has accepted the refuel from %s for $%s.", MaskedName(GetPVarInt(playerid, "RefuelID") - 1), number_format(GetPVarInt(playerid, "RefuelPrice")));
			Action(playerid, iFormat);
			GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "RefuelPrice"));
			GivePlayerMoneyEx(GetPVarInt(playerid, "RefuelID") - 1, GetPVarInt(playerid, "RefuelPrice"));
			DeletePVar(playerid, "RefuelID");
			DeletePVar(playerid, "RefuelPrice");
			return 1;
		}
		else return SendClientError(playerid, "You haven't been offered a refuel from a mechanic.");
	}
	else if(!strcmp(params, "convo", true))
	{
		if(GetPVarInt(playerid, "Convo") != INVALID_CONVERSATION) return SendClientError(playerid, "You are already inside a conversation, please use /convo leave.");
		if(GetPVarInt(playerid, "InvitedToConvo") != INVALID_CONVERSATION)
		{
			new iCount;
			PlayerLoop(p)
			{
				if(PlayerTemp[playerid][loggedIn] != false) continue;
				if(GetPVarInt(playerid, "Convo") == INVALID_CONVERSATION) continue;
				if(GetPVarInt(playerid, "Convo") == GetPVarInt(playerid, "InvitedToConvo")) iCount++;
			}
			if(iCount != 0)
			{
				new iFormat[136];
				format(iFormat, sizeof(iFormat), "[Convo: %d] %s has joined this conversation.", GetPVarInt(playerid, "Convo"), RPName(playerid));
				LOOP:p(0, MAX_PLAYERS)
				{
					if(!IsPlayerConnected(p)) continue;
					if(PlayerTemp[p][loggedIn] != true) continue;
					if(GetPVarInt(p, "Convo") == INVALID_CONVERSATION) continue;
					if(GetPVarInt(playerid, "Convo") != GetPVarInt(p, "Convo")) continue;
					SendClientMessage(p, 0xFFFF99FF, iFormat);
				}
				return 1;
			}
			else return SendClientError(playerid, "This conversation is nolonger available.");
		}
		else return SendClientError(playerid, "You haven't been invited to a conversation.");
	}
	else return SCP(playerid, "[ ticket / refuel / convo ]");
}
COMMAND:kill(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid) || PlayerTemp[playerid][tazed]) return 1;
    SetTimerEx("SetPlayerBack", 8000, false, "dd", playerid, 0);
    TogglePlayerControllable(playerid, false);
	format(iStr, sizeof(iStr), "(( Local: %s[%d] used /kill and respawns in 8 seconds. ))", RPName(playerid), playerid);
	NearMessage(playerid,iStr,COLOR_LIGHTGREY);
	return 1;
}
COMMAND:dropallweapons(playerid, params[])
{
	ResetPlayerWeaponsEx(playerid);
	Action(playerid, "has dropped all their weapons.");
	return 1;
}
COMMAND:dropalldrugs(playerid, params[])
{
	LOOP:c(0, MAX_DRUG_TYPES)
	{
		PlayerInfo[playerid][hasdrugs][c] = 0;	
	}
	Action(playerid, "has dropped all their drugs.");
	return 1;
}
COMMAND:frisk(playerid, params[])
{
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 5) return SendClientError(playerid, "Too far away!");
	if(IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(iPlayer)) return SendClientError(playerid, "Both players must be in the same state! (Vehicle or Foot)");
	if(!IsPlayerInAnyVehicle(iPlayer) && IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "Both players must be in the same state! (Vehicle or Foot)");

	format(iStr, sizeof(iStr), "leans over and pats %s down, frisking him.", MaskedName(iPlayer));
	Action(playerid, iStr);
	SendClientMSG(playerid, COLOR_HELPEROOC, "======== Inventory of %s ========", MaskedName(iPlayer));
	SendClientMSG(playerid, COLOR_LIGHTGREY, " Cash: $%s", number_format(PlayerTemp[iPlayer][sm]));
	for(new a; a < sizeof(drugtypes); a++)
	{
		if(PlayerInfo[iPlayer][hasdrugs][a] != 0)
		{
			SendClientMSG(playerid, COLOR_LIGHTGREY, " %s: %d grams", drugtypes[a][drugname], PlayerInfo[iPlayer][hasdrugs][a]);
		}
	}
	if(PlayerInfo[iPlayer][sMaterials] > 0) SendClientMSG(playerid, COLOR_LIGHTGREY, " Materials: %d", PlayerInfo[iPlayer][sMaterials]);
	if(PlayerTemp[iPlayer][seeds] > 0) SendClientMSG(playerid, COLOR_LIGHTGREY, " Seeds: %d", PlayerTemp[iPlayer][seeds]);
	new sweapon, sammo;
	for(new i; i < 13; i++)
	{
		GetPlayerWeaponData(iPlayer, i, sweapon, sammo);
		if(sweapon == 0) continue;
		SendClientMSG(playerid, COLOR_LIGHTGREY, " Weapon: %s (Ammo: %d)", aWeaponNames[sweapon], sammo);
	}
	return 1;
}

COMMAND:hhelp(playerid, params[])
{
	if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	SendPlayerMessage(playerid,rndCOLORZ(),"[HELPER] /airc - /tpto - /fa - /ufa - /sp(ectate) - /specoff - /freeze - /unfreeze", "[HELPER]");
	return 1;
}
COMMAND:ahelp(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][power] >= 1) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /spectate, /specoff, /unlog, /ajail, /unjail, /devorce, /slap, /cp, /cw, /mute, /unmute, /spawn, /kick, /suspend, /resetweps", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 1) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /ooc, /airc, /name, /phone, //, /go, /tpto, /tptome, /(un)freeze, /fa, /ufa, /v info, /mark, /gomark /makeooc", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 1) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /tell, /ctell, /rpname, /gotoplace, /warn, /suspend, /tsuspend", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 2) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /devorce, /ban, /unsuspend, /osuspend, /marry, /respawncar, /gotohouse", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 3) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /refuelall, /forcept, /drivenext, /rwarn, /gethouses, /getbusinesses, /getcars", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 4) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /freezeall, /unfreezeall, /v reload,", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 5) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /cleanserver", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 6) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /flip, /fix, /color, /setskin, /v park, /v faction, /v color, /setphone, /pimp", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 8) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /weather, /respawncars, /jetpack", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 10) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /moneydbg, /error, /openhq, /closehq, /minigun, /chucknorris, /pp, /restore, /ainvite, /auninvite, /arankup, /arankdown, /missle, /misslex, /makecar, /togchat", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 10) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /gotobiz, /houseinfo, /houseowner, /movehouse, /makewar /pimp(ex) /setfpoints, /v info", "[ADMIN]", 128);
	if(PlayerInfo[playerid][power] >= 11) SendPlayerMessage(playerid,rndCOLORZ(),"[ADMIN] /makepremium, /savedata, /ts, /int, /setvar, /elections, /changenick, /hadmins, /obj, /objlist", "[ADMIN]", 128);
	return 1;
}
COMMAND:helperduty(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerTemp[playerid][helperduty] == 0)
	{
		format(iStr, sizeof(iStr), "** Helper %s is now available for help. {bbf6f7}Use /irc if you have any questions.", RPName(playerid));
	    SendClientMessageToAll(0x83dadbFF, iStr);
	    PlayerTemp[playerid][helperduty] = 1;
	    SetPlayerColor(playerid, COLOR_ADMIN_SPYREPORT);
	}
	else if(PlayerTemp[playerid][helperduty] == 1)
	{
	    SendClientInfo(playerid, "You are no longer on helper duty.");
	    SetPlayerTeamEx(playerid, PlayerInfo[playerid][playerteam]);
	    PlayerTemp[playerid][helperduty] = 0;
	}
    return 1;
}
COMMAND:freeze(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);

	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr, sizeof(iStr), "(( AdmCmd | %s has frozen %s. ))", AnonAdmin(playerid), RPName(iPlayer));
   	SendClientMessageToAll(COLOR_RED,iStr);
	TogglePlayerControllable(iPlayer, false);
	return 1;
}
COMMAND:slap(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr,sizeof(iStr),"(( AdmCmd | %s has slapped %s. ))", AnonAdmin(playerid), RPName(iPlayer));
	SendClientMessageToAll(COLOR_RED,iStr);
	format(iStr,sizeof(iStr),"5[ Admin ] %s has been slapped by %s.", PlayerName(iPlayer), PlayerName(playerid));
	iEcho(iStr);
	new Float:old, Float:px, Float:py, Float:pz;
	GetPlayerHealth(iPlayer,old);
	SetPlayerHealth(iPlayer,old-20);
	GetPlayerPos(iPlayer,px,py,pz);
	SetPlayerPos(iPlayer,px,py,pz+5);
	PlayerPlaySound(iPlayer,1190,0.0,0.0,0.0);
	TogglePlayerControllable(iPlayer,true);
	return 1;
}
COMMAND:spawn(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr,sizeof(iStr),"(( AdmCmd | %s has spawned %s. ))", AnonAdmin(iPlayer), RPName(iPlayer));
	SendClientMessageToAll(COLOR_RED,iStr);
	format(iStr,sizeof(iStr),"5[ Admin ] %s has been respawned by %s.", PlayerName(iPlayer), PlayerName(playerid));
	iEcho(iStr);
	SpawnPlayer(iPlayer);
	TogglePlayerControllable(iPlayer,true);
	return 1;
}
ALTCOMMAND:respawn->spawn;
COMMAND:cw(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	SendClientMSG(playerid, COLOR_HELPEROOC, "----- %s(%d) Weapons %s ------",RPName(iPlayer),iPlayer, TimeDate());
	new weaname[ 32 ];
	for(new i = 0; i < 13; i++)
	{
		new weanameEx[32];
		GetWeaponName(PlayerTemp[iPlayer][AntiSpawnWeapon], weanameEx, sizeof(weanameEx));
		GetPlayerWeaponData(iPlayer, i, PlayerTemp[iPlayer][weapon], PlayerTemp[iPlayer][ammo]);
		GetWeaponName(PlayerTemp[iPlayer][weapon],weaname,sizeof(weaname));
		if(strlen(weaname))
			SendClientMSG(playerid, COLOR_WHITE, " Weapon:[%s / %s] Ammo:[%d / %d] Slot:[%d]", weaname, weanameEx, PlayerTemp[iPlayer][ammo], PlayerTemp[iPlayer][AntiSpawnAmmo][i], i);
	}
	return 1;
}
COMMAND:cp(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	GetStats(iPlayer, playerid, 1);
	return 1;
}
COMMAND:adminduty(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerTemp[playerid][adminduty] == 0)
	{
		format(iStr, sizeof(iStr), "(( AdmDuty | %s is now on Admin Duty. ))", AnonAdmin(playerid));
	    SendClientMessageToAll(COLOR_RED, iStr);
	    PlayerTemp[playerid][adminduty] = 1;
	    SetPlayerColor(playerid, COLOR_ADMIN_SPYREPORT);
	    SendClientMessage(playerid, COLOR_LIGHTGREY, " You are on admin duty. You are not allowed to roleplay!");
	    PlayerLoop(i) ShowPlayerNameTagForPlayer(i,playerid,1);
	}
	else if(PlayerTemp[playerid][adminduty] == 1)
	{
	    SendClientMessage(playerid, COLOR_LIGHTGREY, " You are off admin duty.");
	    PlayerTemp[playerid][adminduty] = 0;
	    SetPlayerTeamEx(playerid,PlayerInfo[playerid][playerteam]);
	    PlayerLoop(i) ShowPlayerNameTagForPlayer(i,playerid,0);
	}
    return 1;
}
COMMAND:vw(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new tehVW;
	if(sscanf(params, "d", tehVW)) return SCP(playerid, "[VW]");
	SetPlayerVirtualWorld(playerid, tehVW);
	return 1;
}
COMMAND:int(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new tehVW;
	if(sscanf(params, "d", tehVW)) return SCP(playerid, "[INT]");
	SetPlayerInterior(playerid, tehVW);
	return 1;
}
COMMAND:gotoco(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new Float:x, Float:y, Float:z;
	if(sscanf(params, "fff", x, y, z)) return SCP(playerid, "[X Coord] [Y Coord] [Z Coord]");
	SetPlayerPos(playerid, x, y, z);
	return 1;
}
COMMAND:jetpack(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 6) return SendClientError(playerid, CANT_USE_CMD);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    return 1;
}
ALTCOMMAND:jp->jetpack;
COMMAND:bizlist(playerid)
{
	if(IsPlayerInThisFactionType(playerid, FAC_TYPE_GOV) || PlayerInfo[playerid][power] >= 10)
		ShowDialog(playerid, DIALOG_LIST_ACTIVE_BIZES);
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:setha(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	SetPlayerHealth(iPlayer, 99);
	SetPlayerArmour(iPlayer, 99);
	SendClientInfo(playerid, "Done");
    return 1;
}
COMMAND:fixbots(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
    IRC_Quit(gBotID[0], ""SERVER_GM" ->> Rebooting Bots."); // Disconnect the first bot
	IRC_Quit(gBotID[1], ""SERVER_GM" ->> Rebooting Bots."); // Disconnect the second bot
	IRC_Quit(gBotID[2], ""SERVER_GM" ->> Rebooting Bots."); // Disconnect the second bot
	SetTimerEx("IRC_ConnectDelay", 500, 0, "d", 1); // Connect the first bot with a delay of 2 seconds
	SetTimerEx("IRC_ConnectDelay", 1500, 0, "d", 2); // Connect the second bot with a delay of 3 seconds
	SetTimerEx("IRC_ConnectDelay", 2500, 0, "d", 3); // Connect the second bot with a delay of 4 seconds
	return 1;
}
COMMAND:resetweps(playerid, params[])
{
    if(PlayerInfo[playerid][power] >= 1 || IsPlayerENF(playerid))
	{
		new iPlayer;
		if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
		if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
		if((GetDistanceBetweenPlayers(playerid, iPlayer) < 5 && PlayerTemp[iPlayer][cuffed]) || PlayerInfo[playerid][power])
		{
			ResetPlayerWeaponsEx(iPlayer);
			format(iStr, sizeof(iStr), "has taken the weapons of %s away.", MaskedName(iPlayer));
			if(!PlayerInfo[playerid][power]) Action(playerid, iStr);
		}
	}
	else return SendClientError(playerid, CANT_USE_CMD);
    return 1;
}
COMMAND:tpto(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(iPlayer,x,y,z);
	PlayerTemp[playerid][tmphouse] = PlayerTemp[iPlayer][tmphouse];
	PlayerTemp[playerid][tmpbiz] = PlayerTemp[iPlayer][tmpbiz];
	if(IsPlayerInAnyVehicle(playerid))
	{
		new vid = GetPlayerVehicleID(playerid);
		SetVehiclePos(vid, x, y, z);
		LinkVehicleToInterior(vid, GetPlayerInterior(iPlayer));
		SetVehicleVirtualWorld(vid, GetPlayerVirtualWorld(iPlayer));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(iPlayer));
	}
	else
	{
		SetPlayerPos(playerid, x,y,z);
		SetPlayerInterior(playerid, GetPlayerInterior(iPlayer));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(iPlayer));
	}
	return 1;
}
COMMAND:tptome(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(iPlayer,x,y,z);
	PlayerTemp[iPlayer][tmphouse] = PlayerTemp[playerid][tmphouse];
	PlayerTemp[iPlayer][tmpbiz] = PlayerTemp[playerid][tmpbiz];
	if(IsPlayerInAnyVehicle(iPlayer))
	{
		new vid = GetPlayerVehicleID(iPlayer);
		SetVehiclePos(vid, x,y,z);
		LinkVehicleToInterior(vid, GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(vid, GetPlayerVirtualWorld(playerid));
	}
	else
	{
		SetPlayerPos(iPlayer, x,y,z);
		SetPlayerInterior(iPlayer, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(iPlayer, GetPlayerVirtualWorld(playerid));
	}
	return 1;
}
COMMAND:fa(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	PlayerLoop(i)
	{
		if(i == playerid) continue;
		if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid)) continue;
		if(GetDistanceBetweenPlayers(i, playerid) > 10) continue;
		TogglePlayerControllable(i, false);
	}
	format(iStr,sizeof(iStr),"(( AdmCmd | Players nearby %s have been frozen. ))", AnonAdmin(playerid));
	SendClientMessageToAll(COLOR_RED,iStr);
	return 1;
}
COMMAND:ufa(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	PlayerLoop(i)
	{
		if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid)) continue;
		if(GetDistanceBetweenPlayers(i, playerid) > 10) continue;
		TogglePlayerControllable(i, true);
	}
	format(iStr,sizeof(iStr),"(( AdmCmd | Players nearby %s have been unfrozen. ))", AnonAdmin(playerid));
	SendClientMessageToAll(COLOR_RED,iStr);
	return 1;
}
COMMAND:ua(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	SendClientMessage(playerid, COLOR_GREY, "[UNLOCK ALL]: All Vehicles unlocked!");
	format(iStr, sizeof(iStr), "12[ADMIN] %s has unlocked all vehicles.", PlayerName(playerid));
	iEcho(iStr);
	VehicleLoop(v)
	{
	    if(VehicleInfo[v][vActive] != true) continue;
		if(!strcmp(VehicleInfo[v][vOwner], "NoBodY")) UnlockVehicle(GetCarID(v));
	}
	return 1;
}
COMMAND:spectate(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);

	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer) || iPlayer == playerid) return SendClientError(playerid, PLAYER_NOT_FOUND);
	SendClientMSG(playerid, 0x008AB8FF, "[Spec:] You are now spectating %s (ID: %d).", RPName(iPlayer), iPlayer);
	if(PlayerTemp[playerid][spectatingID] == INVALID_PLAYER_ID)
	{
		GetPlayerPos(playerid, PlayerTemp[playerid][PlayerPosition][0],PlayerTemp[playerid][PlayerPosition][1],PlayerTemp[playerid][PlayerPosition][2]);
		PlayerTemp[playerid][PlayerInterior] = GetPlayerInterior(playerid);
		PlayerTemp[playerid][PlayerVirtualWorld] = GetPlayerVirtualWorld(playerid);
		GetPlayerHealth(playerid, PlayerTemp[playerid][PlayerHealth]);
		GetPlayerArmour(playerid, PlayerTemp[playerid][PlayerArmour]);
		for (new i = 0; i<13; i++)
		{
			GetPlayerWeaponData(playerid, i, PlayerTemp[playerid][PlayerWeapon][i], PlayerTemp[playerid][PlayerAmmo][i]);
		}
		SetPVarInt(playerid, "SkinSelect", 1);
	}
    StartSpectate(playerid, iPlayer);
    return 1;
}
ALTCOMMAND:sp->spectate;
COMMAND:unfreeze(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerInfo[playerid][helper]) format(iStr, sizeof(iStr), "[HELPER] %s has been unfrozen by Helper %s", RPName(iPlayer), RPName(playerid));
  	else format(iStr, sizeof(iStr), "(( AdmCmd | %s has unfrozen %s. ))", AnonAdmin(playerid), RPName(iPlayer));
   	SendClientMessageToAll(COLOR_RED,iStr);
   	format(iStr, sizeof(iStr), "9[HELPER] %s (ID: %d) has unfrozen %s (ID: %d)", RPName(playerid),playerid, RPName(iPlayer), iPlayer);
   	if(PlayerInfo[playerid][helper]) iEcho(iStr);
	TogglePlayerControllable(iPlayer, true);
	return 1;
}
COMMAND:whitelist(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iW[12], iW2[24];
	if(sscanf(params, "sz", iW, iW2)) return SCP(playerid, "[ add / remove / list ]");
	if(!strcmp(iW, "add", true, 3))
	{
		if(!strlen(iW2)) return SCP(playerid, "add [PlayerName]");
		new iQuery[250];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `Whitelist` (`PlayerName`) VALUES ('%e')", iW2);
		mysql_tquery(MySQLPipeline, iQuery);		
		return 1;
	}
	else if(!strcmp(iW, "remove", true, 6))
	{
		if(!IsNumeric(iW2) || !strlen(iW2)) return SCP(playerid, "remove [ID]");	
		new iQuery[250];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `Whitelist` WHERE `ID` = %d", iW2);
		mysql_tquery(MySQLPipeline, iQuery);	
		return 1;
	}
	else if(!strcmp(iW, "list", true, 4))
	{
		new iQuery[250];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `ID`,`PlayerName` FROM `Whitelist");
		mysql_tquery(MySQLPipeline, iQuery);
		return 1;
	}
	return 1;
}
COMMAND:faction(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iChoice[24], iChoice2[74], iChoice3[74];
	if(sscanf(params, "szz", iChoice, iChoice2, iChoice3)) return SCP(playerid, "[ create / delete / rename / points / lspawn / spawn / colour / zonecolour / motd / stock / type ]");
	if(!strcmp(iChoice, "create", true, 5))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2) || IsNumeric(iChoice3) || !strlen(iChoice3))
		{
			SendClientMessage(playerid, 0xFFFFCCFF, "Types: 0 - Army | 1 - Police | 2 - Gang | 3 - Mafia | 4 - GOV | 5 - SDC | 6 - FBI.");
			SCP(playerid, "create [Type] [Faction name]");
			return 1;
		}
		new iType = strval(iChoice2);
		if(iType > MAX_FACTION_TYPES || iType < 0) return SendClientError(playerid, "Invalid faction type!");
		CreateFaction(iType, iChoice3);
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s has created a new faction. %s.", PlayerName(playerid), iChoice3);
		AdminNotice(iFormat);
		return 1;
	}
	else if(!strcmp(iChoice, "delete", true, 6))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2)) return SCP(playerid, "delete [FactionID]");
		new iFaction = strval(iChoice2);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s has deleted a faction.", PlayerName(playerid));
		AdminNotice(iFormat);
		DeleteFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "rename", true, 5))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2) || IsNumeric(iChoice3) || !strlen(iChoice3) || strlen(iChoice3) > MAX_FACTION_NAME) return SCP(playerid, "rename [FactionID] [New name]");
		new iFaction = strval(iChoice2);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s renamed %s to %s.", PlayerName(playerid), FactionInfo[iFaction][fName], iChoice3);
		AdminNotice(iFormat);
		myStrcpy(FactionInfo[iFaction][fName], iChoice3);
		ReloadFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "points", true, 6))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2) || !IsNumeric(iChoice3) || !strlen(iChoice3)) return SCP(playerid, "points [FactionID] [Points]");
		new iFaction = strval(iChoice2), iPoints = strval(iChoice3);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s added %s fpoints to %s.", PlayerName(playerid), number_format(iPoints), FactionInfo[iFaction][fName]);
		AdminNotice(iFormat);
		FactionInfo[iFaction][fPoints] += iPoints;
		ReloadFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "lspawn", true, 6))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2)) return SCP(playerid, "lspawn [FactionID]");
		new iFaction = strval(iChoice2);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128], Float:poss[4];
		format(iFormat, sizeof(iFormat), "%s changed %s Leader spawn.", PlayerName(playerid), FactionInfo[iFaction][fName]);
		AdminNotice(iFormat);
		GetPlayerPos(playerid, poss[0], poss[1], poss[2]);
		GetPlayerFacingAngle(playerid, poss[3]);
		HQInfo[iFaction][flSpawnX] = poss[0];
		HQInfo[iFaction][flSpawnY] = poss[1];
		HQInfo[iFaction][flSpawnZ] = poss[2];
		HQInfo[iFaction][flSpawnA] = poss[3];
		HQInfo[iFaction][flSpawnInt] = GetPlayerInterior(playerid);
		HQInfo[iFaction][flSpawnVW] = GetPlayerVirtualWorld(playerid);
		ReloadFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "spawn", true, 5))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2)) return SCP(playerid, "spawn [FactionID]");
		new iFaction = strval(iChoice2);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128], Float:poss[4];
		format(iFormat, sizeof(iFormat), "%s changed %s's spawn / interior.", PlayerName(playerid), FactionInfo[iFaction][fName]);
		AdminNotice(iFormat);
		GetPlayerPos(playerid, poss[0], poss[1], poss[2]);
		GetPlayerFacingAngle(playerid, poss[3]);
		HQInfo[iFaction][fSpawnX] = poss[0];
		HQInfo[iFaction][fSpawnY] = poss[1];
		HQInfo[iFaction][fSpawnZ] = poss[2];
		HQInfo[iFaction][fSpawnA] = poss[3];
		HQInfo[iFaction][fSpawnInt] = GetPlayerInterior(playerid);
		HQInfo[iFaction][fSpawnVW] = GetPlayerVirtualWorld(playerid);
		ReloadFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "colour", true, 6))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2) || IsNumeric(iChoice3) || !strlen(iChoice3)) return SCP(playerid, "colour [FactionID] [Colour (HEX)]");
		new iFaction = strval(iChoice2), iColour = HexToInt(iChoice3);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s changed %s's faction colour.", PlayerName(playerid), FactionInfo[iFaction][fName]);
		AdminNotice(iFormat);
		FactionInfo[iFaction][fColour] = iColour;
		ReloadFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "zonecolour", true, 10))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2) || IsNumeric(iChoice3) || !strlen(iChoice3)) return SCP(playerid, "zonecolour [FactionID] [Zone Colour (HEX)]");
		new iFaction = strval(iChoice2), iColour = HexToInt(iChoice3);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s changed %s's turf colour.", PlayerName(playerid), FactionInfo[iFaction][fName]);
		AdminNotice(iFormat);
		FactionInfo[iFaction][fGangZoneColour] = iColour;
		ReloadFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "motd", true, 4))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2) || IsNumeric(iChoice3) || !strlen(iChoice3)) return SCP(playerid, "motd [FactionID] [MOTD]");
		new iFaction = strval(iChoice2);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s changed %s's F-MOTD.", PlayerName(playerid), FactionInfo[iFaction][fName]);
		AdminNotice(iFormat);
		myStrcpy(FactionInfo[iFaction][fMOTD], iChoice3);
		ReloadFaction(iFaction);
		return 1;
	}
	else if(!strcmp(iChoice, "stock", true, 5))
	{
		if(!IsNumeric(iChoice2) || !strlen(iChoice2) || !IsNumeric(iChoice3) || !strlen(iChoice3)) return SCP(playerid, "stock [FactionID] [Stock amount]");
		new iFaction = strval(iChoice2), iStock = strval(iChoice3);
		if(iFaction >= MAX_FACTIONS || iFaction < 0) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		if(FactionInfo[iFaction][fActive] != true) return SendClientError(playerid, "Invalid faction : (Non Existant!)");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s changed %s's stock amount.", PlayerName(playerid), FactionInfo[iFaction][fName]);
		AdminNotice(iFormat);
		HQInfo[iFaction][fHQStock] = iStock;
		ReloadFaction(iFaction);
		return 1;
	}
	else return SCP(playerid, "[ create / delete / leader / rename / points / lspawn / spawn / colour / zonecolour / motd / stock ]");
}

COMMAND:wh(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 12 ], tmp2[ 15 ], tmp3[ 15 ];
	if(sscanf(params, "sz", tmp, tmp2, tmp3)) return SCP(playerid, "[ move / reload ]");
	if(!strcmp(tmp, "move", true, 4))
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "move [factionID]");
	    new Float:ok[3], facid = strval(tmp2);
		if(FactionInfo[facid][fActive] != true) return SendClientError(playerid, "Faction not found! (Non existant).");
	    GetPlayerPos(playerid, ok[0], ok[1], ok[2]);
		if(WareHouseInfo[facid][whActive] != true) // create
		{
			CreateWH(facid, ok[0], ok[1], ok[2], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		}
		else
		{
			WareHouseInfo[facid][whX] = ok[0];
			WareHouseInfo[facid][whY] = ok[1];
			WareHouseInfo[facid][whZ] = ok[2];
			WareHouseInfo[facid][whInterior] = GetPlayerInterior(playerid);
			WareHouseInfo[facid][whVirtualWorld] = GetPlayerVirtualWorld(playerid);
			ReloadFaction(facid, true);
		}
	}
	else if(!strcmp(tmp, "reload", true, 6))
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "reload [factionID]");
	    new facid = strval(tmp2);
	    ReloadFaction(facid);
	}
	else return SCP(playerid, "[ move / reload ]");
	return 1;
}

COMMAND:tp(playerid, params[])
{
	if(GetAdminLevel(playerid) < 3) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 12 ], tmp2[ 50 ], tmp3[50];
	if(sscanf(params, "szz", tmp, tmp2, tmp3)) return SCP(playerid, "[ create / move / interior / rename / goto ]");
	if(!strcmp(tmp, "move", true, 4))
	{
		if(GetAdminLevel(playerid) < 7) return SendClientError(playerid, CANT_USE_CMD);
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "move [ Teleport ID ]");
	    new Float:ok[4], tpid = strval(tmp2);
		if(tpid < 0 || tpid > MAX_TELEPORTS) return SCP(playerid, "move [ Teleport ID ]");
		if(TeleportInfo[tpid][tpActive] != true) return SendClientError(playerid, "This teleport isn't active (created).");
	    GetPlayerPos(playerid, ok[0], ok[1], ok[2]);
		GetPlayerFacingAngle(playerid, ok[3]);
		TeleportInfo[tpid][tpX] = ok[0];
		TeleportInfo[tpid][tpY] = ok[1];
		TeleportInfo[tpid][tpZ] = ok[2];
		TeleportInfo[tpid][tpA] = ok[3];
		TeleportInfo[tpid][tpInt] = GetPlayerInterior(playerid);
		TeleportInfo[tpid][tpVW] = GetPlayerVirtualWorld(playerid);
		TeleportInfo[tpid][tpHouseID] = PlayerTemp[playerid][tmphouse];
		ReloadTeleport(tpid, true);
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "[Teleport:]{D1FFA3} You have moved teleport %d.", tpid);
		SendClientMessage(playerid, 0x8FB26BFF, iFormat);
	}
	else if(!strcmp(tmp, "create", true, 6))
	{
		if(GetAdminLevel(playerid) < 7) return SendClientError(playerid, CANT_USE_CMD);
	    if(!strlen(tmp3) || strlen(tmp3) > 50) return SCP(playerid, "create [ Type (1-2) ] [ Teleport Name (Max: 50 chars) ]");
	    new Float:ok[4];
	    GetPlayerPos(playerid, ok[0], ok[1], ok[2]);
		GetPlayerFacingAngle(playerid, ok[3]);
		new iFormat[128], getTP = GetUnusedTeleport();
		if(getTP != -1)
		{
			format(iFormat, sizeof(iFormat), "[Teleport:]{D1FFA3} You have created teleport \"%s\"(%d).", tmp3, getTP);
			SendClientMessage(playerid, 0x8FB26BFF, iFormat);
			CreateTeleport(tmp3, ok[0], ok[1], ok[2], ok[3], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), PlayerTemp[playerid][tmphouse]);
		}
		else return SendClientError(playerid, "Couldn't create teleport: Report(~057).");
	}
	else if(!strcmp(tmp, "interior", true, 8))
	{
		if(GetAdminLevel(playerid) < 7) return SendClientError(playerid, CANT_USE_CMD);
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "interior [ Teleport ID ]");
	    new Float:ok[4], tpid = strval(tmp2);
		if(tpid < 0 || tpid > MAX_TELEPORTS) return SCP(playerid, "interior [ Teleport ID ]");
		if(TeleportInfo[tpid][tpActive] != true) return SCP(playerid, "interior [ Teleport ID ]");
	    GetPlayerPos(playerid, ok[0], ok[1], ok[2]);
		GetPlayerFacingAngle(playerid, ok[3]);
		TeleportInfo[tpid][tpiX] = ok[0];
		TeleportInfo[tpid][tpiY] = ok[1];
		TeleportInfo[tpid][tpiZ] = ok[2];
		TeleportInfo[tpid][tpiA] = ok[3];
		TeleportInfo[tpid][tpiInt] = GetPlayerInterior(playerid);
		TeleportInfo[tpid][tpiVW] = GetPlayerVirtualWorld(playerid);
		TeleportInfo[tpid][tpHouseIID] = PlayerTemp[playerid][tmphouse];
	    ReloadTeleport(tpid);
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "[Teleport:]{D1FFA3} Interior set for teleport %d.", tpid);
		SendClientMessage(playerid, 0x8FB26BFF, iFormat);
	}
	else if(!strcmp(tmp, "rename", true, 6))
	{
		if(GetAdminLevel(playerid) < 7) return SendClientError(playerid, CANT_USE_CMD);
	    if(!strlen(tmp2) || !IsNumeric(tmp2) || !strlen(tmp3) || strlen(tmp3) > 50) return SCP(playerid, "rename [ Teleport ID ] [ New name ]");
	    new tpid = strval(tmp2);
		if(tpid < 0 || tpid > MAX_TELEPORTS) return SCP(playerid, "rename [ Teleport ID ] [ New name ]");
		if(TeleportInfo[tpid][tpActive] != true) return SCP(playerid, "rename [ Teleport ID ] [ New name ]");
		myStrcpy(TeleportInfo[tpid][tpName], tmp3);
		ReloadTeleport(tpid);
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "[Teleport:]{D1FFA3} Changed teleport ID: %d's name to \"%s\".", tpid, tmp3);
		SendClientMessage(playerid, 0x8FB26BFF, iFormat);
	}
	else if(!strcmp(tmp, "goto", true, 4)) // level 2+ admins...
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "goto [ Teleport ID ]");
	    new tpid = strval(tmp2);
		if(tpid < 0 || tpid > MAX_TELEPORTS) return SCP(playerid, "goto [ Teleport ID ]");
		if(TeleportInfo[tpid][tpActive] != true) return SCP(playerid, "goto [ Teleport ID ]");
		SetPlayerPos(playerid, TeleportInfo[tpid][tpX], TeleportInfo[tpid][tpY], TeleportInfo[tpid][tpZ]);
		SetPlayerInterior(playerid, TeleportInfo[tpid][tpInt]);
		SetPlayerVirtualWorld(playerid, TeleportInfo[tpid][tpVW]);
		PlayerTemp[playerid][tmphouse] = TeleportInfo[playerid][tpHouseID];
		PlayerTemp[playerid][tmpbiz] = -1;
	}
	else return SCP(playerid, "[ create / move / interior / rename / goto ]");
	return 1;
}

COMMAND:hq(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 12 ], tmp2[ 15 ], tmp3[ 15 ];
	if(sscanf(params, "sz", tmp, tmp2, tmp3)) return SCP(playerid, "[ move / interior / roof ]");
	if(!strcmp(tmp, "move", true, 4))
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "move [factionID]");
	    new Float:ok[4], facid = strval(tmp2);
	    GetPlayerPos(playerid, ok[0], ok[1], ok[2]);
		GetPlayerFacingAngle(playerid, ok[3]);
		if(HQInfo[facid][hqActive] != true)
		{
			CreateHQ(facid, ok[0], ok[1], ok[2], ok[3], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		}
		else
		{
			HQInfo[facid][fHQX] = ok[0];
			HQInfo[facid][fHQY] = ok[1];
			HQInfo[facid][fHQZ] = ok[2];
			HQInfo[facid][fHQA] = ok[3];
			HQInfo[facid][fHQInt] = GetPlayerInterior(playerid);
			HQInfo[facid][fHQVW] = GetPlayerVirtualWorld(playerid);
			ReloadFaction(facid, true);
		}
	}
	else if(!strcmp(tmp, "roof", true, 4))
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "roof [factionID]");
	    new Float:ok[4], facid = strval(tmp2);
	    GetPlayerPos(playerid, ok[0], ok[1], ok[2]);
		GetPlayerFacingAngle(playerid, ok[3]);
		HQInfo[facid][fHQRoofX] = ok[0];
		HQInfo[facid][fHQRoofY] = ok[1];
		HQInfo[facid][fHQRoofZ] = ok[2];
		HQInfo[facid][fHQRoofA] = ok[3];
		HQInfo[facid][fHQRoofInt] = GetPlayerInterior(playerid);
		HQInfo[facid][fHQRoofVW] = GetPlayerVirtualWorld(playerid);
	    ReloadFaction(facid);
	}
	else if(!strcmp(tmp, "interior", true,8))
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "interior [FactionID]");
	    new Float:ok[4], facid = strval(tmp2);
		if(HQInfo[facid][hqActive] != true) return SendClientError(playerid, "You need to create the faction HQ first! /hq move!");
	    GetPlayerPos(playerid, ok[0], ok[1], ok[2]);
		GetPlayerFacingAngle(playerid, ok[3]);
		HQInfo[facid][fSpawnX] = ok[0];
		HQInfo[facid][fSpawnY] = ok[1];
		HQInfo[facid][fSpawnZ] = ok[2];
		HQInfo[facid][fSpawnA] = ok[3];
		HQInfo[facid][fSpawnInt] = GetPlayerInterior(playerid);
		HQInfo[facid][fSpawnVW] = GetPlayerVirtualWorld(playerid);
	    ReloadFaction(facid);
	}
	else return SCP(playerid, "[ move / interior / roof ]");
	return 1;
}
COMMAND:v(playerid, params[])
{
	if(!GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 15 ], tmp2[ 15 ], tmp3[ 15 ], tmp4[ 15 ];
	if(sscanf(params, "szz", tmp, tmp2, tmp3, tmp4)) return SCP(playerid, "[ model / faction / reserved / owner / park / reload / enter / sell / color / list / create ]");
	if(!strcmp(tmp, "model", true, 5))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 10)
			return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2)) return SCP(playerid, "model [model name / model id]");
		new tehvID;
		if(!IsNumeric(tmp2)) tehvID = ModelFromName(tmp2);
		else tehvID = strval(tmp2);
		if(tehvID == -1 || tehvID < 400 ||tehvID > 611) return SendClientError(playerid, "Invalid model!");
		new carid = GetPlayerVehicleID(playerid);
		new vehicleid = FindVehicleID(carid);
		UnModCar(carid);
	    VehicleInfo[vehicleid][vModel] = tehvID;
	    SaveVehicle(vehicleid);
	    SendClientInfo(playerid, "Success: The model will bee changed.");
	}
	else if(!strcmp(tmp, "call", true, 4))
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2) || strlen(tmp2) > 5)
			return SCP(playerid, "call [vehicleID (/myvehicles)]");
	    new themodel = strval(tmp2);
	    if(themodel < 0 || themodel > MAX_VEHICLES || VehicleInfo[themodel][vActive] == false)
			return SendClientError(playerid, "Invalid vehicle ID!");
		if(GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid))
		    return SendClientError(playerid, "You cannot call your vehicle while in an interior.");
	    SetTimerEx("VehicleToPlayer", 1000, false, "ddd", playerid, GetCarID(themodel), 0);
	}
	else if(!strcmp(tmp, "faction", true, 7))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 6)
			return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2) || !IsNumeric(tmp2))
			return SCP(playerid, "faction [faction ID]");
		new fID = strval(tmp2);
	    SendClientInfo(playerid, "Success: The vehicle is now bound to the faction.");
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vFaction] = fID;
	    myStrcpy(VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vOwner], "NoBodY");
	}
	else if(!strcmp(tmp, "biz", true, 3))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 6)
			return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2) || !IsNumeric(tmp2))
			return SCP(playerid, "biz [biz ID]");
		new fID = strval(tmp2);
	    SendClientInfo(playerid, "Success: The vehicle is now bound to the biz.");
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vBusiness] = fID;
	    //myStrcpy(VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vOwner], "NoBodY");
	}
	else if(!strcmp(tmp, "sell", true, 4))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 10)
			return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2) || !IsNumeric(tmp2))
			return SCP(playerid, "sell [amount]");
		new fID = strval(tmp2);
		if(fID < 0 || fID > 99999999) return SendClientError(playerid, "Invalid amount!");
	    SendClientInfo(playerid, "Success: The vehicle is now on sale for the price.");
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vSellPrice] = fID;
	}
	else if(!strcmp(tmp, "color", true, 5))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 6) return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2) || !IsNumeric(tmp2) || !strlen(tmp3) || !IsNumeric(tmp3)) return SCP(playerid, "color [c1] [c2]");
		new c1 = strval(tmp2), c2 = strval(tmp3);
	    ChangeVehicleColor(GetPlayerVehicleID(playerid), c1, c2);
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vColour1] = c1;
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vColour2] = c2;
	}
	else if(!strcmp(tmp, "reserved", true, 8))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 6) return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2) || !IsNumeric(tmp2))
		{
		    SendClientInfo(playerid, "Reserved : 0 - Ownable | 1 - Job | 2 - Noob | 3 - Fac Reserved | 4 - Rent | 5 - Money Van | 6 - Reinfary | 7 - WH Trailer");
			return SCP(playerid, "reserved [0/7]");
		}
		new iResv = strval(tmp2);
		SendClientInfo(playerid, "Success: The vehicle is now reserved.");
		VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vReserved] = iResv;
	}
	else if(!strcmp(tmp, "owner", true, 5))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2) || IsNumeric(tmp2) || strlen(tmp2) > MAX_PLAYER_NAME) return SCP(playerid, "owner [name]");
		SendClientInfo(playerid, "Success: The owner has been changed.");
		myStrcpy(VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vOwner], tmp2);
		VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vReserved] = VEH_RES_NORMAL;
	}
	else if(!strcmp(tmp, "job", true, 3))
	{
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
	    if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(tmp2) || IsNumeric(tmp2) || strlen(tmp2) > MAX_PLAYER_NAME) return SCP(playerid, "job [name]");
		SendClientInfo(playerid, "Success: The job has been updated to this vehicle.");
		myStrcpy(VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vJob], tmp2);
		myStrcpy(VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vOwner], "NoBodY");
		myStrcpy(VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vDupekey], "NoBodY");
		VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vReserved] = VEH_RES_OCCUPA;
	}
	else if(!strcmp(tmp, "enter", true, 5))
	{
		if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "enter [vID]");
		new _vid = strval(tmp2);
		Up(playerid);
		if(VehicleInfo[_vid][vActive] == false/*  || VehicleInfo[_vid][vSpawned] != true */)
			return SendClientError(playerid, "Invalid vehicle ID!");
		SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(_vid));
		SetTimerEx("PutPlayerInVehicleEx", 300, false, "dd", playerid, _vid);
	}
	else if(!strcmp(tmp, "park", true, 4))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 6) return SendClientError(playerid, CANT_USE_CMD);
		new Float:pX, Float:pY, Float:pZ, Float:pA;
	    GetVehiclePos(GetPlayerVehicleID(playerid), pX, pY, pZ);
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), pA);

	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vX] = pX;
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vY] = pY;
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vZ] = pZ;
	    VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vA] = pA;
		VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vVirtualWorld] = GetPlayerVirtualWorld(playerid);
		ReloadVehicle(FindVehicleID(GetPlayerVehicleID(playerid)));
	    Up(playerid);
	    SetTimerEx("PutPlayerInVehicleEx", 500, false, "dd", playerid, FindVehicleID(GetPlayerVehicleID(playerid)));
	}
	else if(!strcmp(tmp, "reload", true, 6))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
		if(GetAdminLevel(playerid) < 6) return SendClientError(playerid, CANT_USE_CMD);
		ReloadVehicle(FindVehicleID(GetPlayerVehicleID(playerid)));
		Up(playerid);
	}
	else if(!strcmp(tmp, "create", true, 6))
	{
		if(GetAdminLevel(playerid) < 8) return SendClientError(playerid, CANT_USE_CMD);
		if(GetUnusedVehicle() == INVALID_VEHICLE_ID) return SendClientError(playerid, "There are no more vehicles avaiable in server!");
		if(!strlen(tmp2)) return SCP(playerid, "create [Model Name / ModelID]");
		new tehvID;
		if(!IsNumeric(tmp2)) tehvID = ModelFromName(tmp2);
		else tehvID = strval(tmp2);
		if(tehvID == -1 || tehvID < 400 ||tehvID > 611) return SendClientError(playerid, "Invalid model!");
		new Float:a[4];
		GetPlayerPos(playerid, a[0], a[1], a[2]);
		GetPlayerFacingAngle(playerid, a[3]);
		CreateNewVehicle("NoBodY", tehvID, a[0], a[1], a[2], a[3]);
	}
 	else if(!strcmp(tmp, "delete", true, 6))
	{
		//if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
		if(!IsNumeric(tmp2) || !strlen(tmp2)) return SCP(playerid, "delete [ID]");	
		if(GetAdminLevel(playerid) < 12) return SendClientError(playerid, CANT_USE_CMD);
		new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
		DeleteVehicle(vehicleid);
		Up(playerid);
		SendClientInfo(playerid, "Vehicle deleted.");
		return 1;
	}
	else return SCP(playerid, "[ model / faction / reserved / owner / park / reload / enter / sell / color / list / create / delete ]");
	return 1;
}

COMMAND:atm(playerid, params[])
{
	if(GetAdminLevel(playerid) < 7) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 15 ];
	if(sscanf(params, "s", tmp)) return SCP(playerid, "[ create / delete / edit ]");
	if(!strcmp(tmp, "create", true, 6))
	{
		if(GetUnusedATM() == -1) return SendClientError(playerid, "No more ATMs can be created, max reached!");
	    new Float:X, Float:Y, Float:Z;
	    GetPlayerPos(playerid, X, Y, Z);
	    CreateATM(X, Y, Z, 0.0, 0.0, 0.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	}
	else if(!strcmp(tmp, "delete", true, 6))
	{
		new atmid = GetClosestATM(playerid);
		if(atmid == -1) return SendClientError(playerid, "No ATM found!");
		if(GetPlayerDistanceToPointEx(playerid, ATMInfo[atmid][atmX], ATMInfo[atmid][atmY], ATMInfo[atmid][atmZ]) < 8)
		{
		    DeleteATM(atmid);
		}
		else return SendClientError(playerid, "You are not close enough to an ATM right now!");
	}
	else if(!strcmp(tmp, "edit", true, 4))
	{
		new atmid = GetClosestATM(playerid);
		if(atmid == -1) return SendClientError(playerid, "No ATM found!");
		if(GetPlayerDistanceToPointEx(playerid, ATMInfo[atmid][atmX], ATMInfo[atmid][atmY], ATMInfo[atmid][atmZ]) < 8)
		{
		    EditDynamicObject(playerid, ATMInfo[atmid][atmObject]);
		}
		else return SendClientError(playerid, "You are not close enough to an ATM right now!");
	}
	else return SCP(playerid, "[ create / delete / edit ]");
	return 1;
}
COMMAND:respawncar(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
    new car = GetPlayerNearestVehicle(playerid);
	if(GetDistanceFromPlayerToVehicle(playerid, car) > 5.0) return SendClientError(playerid, "There is no vehicle around you!");
	SetVehicleToRespawn(car);
	return 1;
}
COMMAND:respawncars(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 8) return SendClientError(playerid, CANT_USE_CMD);
    SetTimer("RespawnAll", 15000, false);
	SendClientMessageToAll(-1, "{ff0000}(( WARNING: {FFFFFF}Unoccupied vehicles will be respawned in 20 seconds! {ff0000}))");
	PlayerLoop(i)
	{
	    TDWarning(i, "Unoccupied vehicles respawn in 18 seconds.", 16000);
	}
	return 1;
}
COMMAND:drivenext(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	PutPlayerInVehicle(playerid, GetPlayerNearestVehicle(playerid), 0);
	return 1;
}
COMMAND:refuelall(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	VehicleLoop(y)
	{
	    if(VehicleInfo[y][vActive] != true) continue;
		VehicleInfo[y][vFuel] = 100;
	}
	GameTextForAll("~w~all cars ~n~~r~refilled",3000,1);
	format(iStr, sizeof(iStr), "2[Admin] %s[%d] has used /refuelall", PlayerName(playerid), playerid);
	iEcho(iStr);
    return 1;
}
COMMAND:color(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 6) return SendClientError(playerid, CANT_USE_CMD);
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "Enter a vehicle first!");
	new iC, iCC;
	if(sscanf(params, "dd", iC, iCC)) return SCP(playerid, "[c1] [c2]");
	ChangeVehicleColor(GetPlayerVehicleID(playerid),iC,iCC);
	VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vColour1] = iC;
	VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vColour2] = iCC;
	SaveVehicle(FindVehicleID(GetPlayerVehicleID(playerid)));
	return 1;
}
COMMAND:fix(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 6) return SendClientError(playerid, CANT_USE_CMD);
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "Enter a vehicle first!");
	return RepairVehicle(GetPlayerVehicleID(playerid));
}
COMMAND:flip(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 6) return SendClientError(playerid, CANT_USE_CMD);
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "Enter a vehicle first!");
	new Float:ZAngle,Float:X,Float:Y,Float:Z,vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);
	GetVehiclePos(vehicleid,X,Y,Z);
	GetVehicleZAngle(vehicleid,ZAngle);
	SetVehicleZAngle(vehicleid,ZAngle);
	SetVehiclePos(vehicleid,X,Y,Z+2);
    return 1;
}
COMMAND:ajail(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, time, iReason[128];
	if( sscanf ( params, "uds", iPlayer,time,iReason)) return SCP(playerid, "[PlayerID/PartOfName] [jailtime (MINUTES)] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(time <= 0 || time > 540) return SendClientError(playerid, "Too many minutes submitted!");
	Jail(iPlayer, time * 60, 777, iReason);
	format(iStr,sizeof(iStr),"(( AdmCmd | %s has been jailed for %d minutes. Reason: %s ))", RPName(iPlayer), time, iReason);
	SendClientMessageToAll(COLOR_RED,iStr);
	format(iStr,sizeof(iStr),"%s has adminjailed you for %d minutes. Reason: %s", RPName(playerid), time, iReason);
	ShowInfoBox(iPlayer, "AdminJailed", iStr, time);
	format(iStr, sizeof(iStr), "4[ AJAIL ] %s[%d] has been adminjailed by %s for %i minutes. Reason: %s", PlayerName(iPlayer), iPlayer, PlayerName(playerid), time, iReason);
	iEcho(iStr);
	AdminDB(PlayerName(iPlayer), PlayerName(playerid), iReason, "[AJAIL]");
	AppendTo(ajaillog,iStr);
	return 1;
}
COMMAND:airc(playerid, params[])
{
	if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	if(!ircenable)
	{
		ircenable=1;
		SendClientMessageToAll(COLOR_GREENYELLOW,"[SERVER] IRC Chat enabled");
		format(iStr, sizeof(iStr), "3..: IRC Chat enabled by %s :..", PlayerName(playerid));
		iEcho(iStr);
	}
	else
	{
		ircenable=0;
		SendClientMessageToAll(COLOR_GREENYELLOW,"[SERVER] IRC Chat disabled");
		format(iStr, sizeof(iStr), "3..: IRC Chat disabled by %s :..", PlayerName(playerid));
		iEcho(iStr);
	}
	return 1;
}
COMMAND:ooc(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	if(!oocenable)
	{
		oocenable=1;
		SendClientMessageToAll(COLOR_GREENYELLOW,"[SERVER] OOC Chat enabled");
		format(iStr, sizeof(iStr), "3..: Global OOC enabled by %s :..", PlayerName(playerid));
		iEcho(iStr);
	}
	else
	{
		oocenable=0;
		SendClientMessageToAll(COLOR_GREENYELLOW,"[SERVER] OOC Chat disabled");
		format(iStr, sizeof(iStr), "3..: Global OOC disabled by %s :..", PlayerName(playerid));
		iEcho(iStr);
	}
	return 1;
}
COMMAND:getcars(playerid, params[])
{
	if(!IsPlayerENF(playerid) && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
//	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iName[MAX_PLAYER_NAME];
	if( sscanf ( params, "s", iName) || strlen(params) > MAX_PLAYER_NAME)  return SCP(playerid, "[Name]");
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	SendClientMSG(playerid, 0x3696EBFF, "Vehicles owned by \"%s:\"", iName);
	VehicleLoop(i)
	{
	    if(VehicleInfo[i][vActive] != true) continue;
		if(strcmp(VehicleInfo[i][vOwner], iName, false)) continue;
		SendClientMSG(playerid, 0xE0E0E0FF, " VehicleID[ %d ] Model[ %s ]", i, GetVehicleNameFromModel(VehicleInfo[i][vModel]));
	}
	SendClientMessage(playerid, 0x3696EBFF, "________________________________________________________________________");
	return 1;
}
COMMAND:makewar(playerid, params[])
{
	if(GetAdminLevel(playerid) < 6) return SendClientError(playerid, CANT_USE_CMD);
	new f1, f2, fg;
	if(sscanf(params, "ddd", f1,f2,fg)) return SCP(playerid, "[ Faction1 ] [ Faction2 ] [ Point goal ]");
	if(FactionInfo[f1][fActive] != true || FactionInfo[f2][fActive] != true) return SendClientError(playerid, "Invalid faction input! (Non existent)");
	StartWar(f1,f2,fg);
	format(iStr, sizeof(iStr), "[WAR] The war between %s and %s has been started.", FactionInfo[f1][fName], FactionInfo[f2][fName]);
	SendClientMessageToAll(COLOR_RED, iStr);
	return 1;
}
COMMAND:turf(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new tFOUND = -1;
    LOOP:q(0, MAX_GANGZONES)
    {
        if(IsPlayerInArea(playerid, Gangzones[q][minX], Gangzones[q][minY], Gangzones[q][maxX], Gangzones[q][maxY])) tFOUND = q;
    }
    if(tFOUND == -1) return SendClientError(playerid, "You are not standing in any turf.");
	new tmp[ 12 ], tmp2[ 15 ];
	if(sscanf(params, "sz", tmp, tmp2)) return SCP(playerid, "[faction]");
	if(!strcmp(tmp, "faction"))
	{
		if(!strlen(tmp2)) return SCP(playerid, "faction [factionID]");
		new fID = strval(tmp2);
		if(fID < 0 || fID > MAX_FACTIONS) return SendClientError(playerid, "Invalid faction ID.");
		if(FactionInfo[fID][fActive] != true) return SendClientError(playerid, "Invalid faction ID.");
		new iQuery[228];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `GangZones` SET `Faction` = %d WHERE `ID` = %d LIMIT 1", fID, tFOUND);
		mysql_tquery(MySQLPipeline, iQuery);
		DestroyGangZones();
		LoadGangZones();
		for(new i; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) GangZoneShowForPlayer(i, Gangzones[tFOUND][gID], GetFactionTurfColour(Gangzones[tFOUND][gFACTION]));
/* 		PlayerLoop(i)
	 	{
			if(PlayerInfo[i][playerteam] == CIV) continue;
			if(IsPlayerFED(i)) continue;
			for(new q; q < MAX_GANGZONES; q++)
			{
				GangZoneShowForPlayer(i, Gangzones[q][gID], GetFactionTurfColour(Gangzones[q][gFACTION]));
			}
		} */
	}
	else if(!strcmp(tmp, "reset"))
	{
		new iQuery[228];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `GangZones` SET `Faction` = 255 WHERE `ID` = %d LIMIT 1", tFOUND);
		mysql_tquery(MySQLPipeline, iQuery);
		DestroyGangZones();
		LoadGangZones();
		PlayerLoop(i)
	 	{
			if(PlayerInfo[i][playerteam] == CIV) continue;
			if(IsPlayerFED(i)) continue;
			for(new q; q < MAX_GANGZONES; q++)
			{
				GangZoneShowForPlayer(i, Gangzones[q][gID], GetFactionTurfColour(Gangzones[q][gFACTION]));
			}
		}
	}
	else return SCP(playerid, "[faction]");
	return 1;
}
COMMAND:togcmds(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerTemp[playerid][admincmdspy] == 0)
	{
	    SendClientMessage(playerid,COLOR_GREENYELLOW, "[ENABLED] You will now see every command.");
	    PlayerTemp[playerid][admincmdspy] = 1;
	}
	else if(PlayerTemp[playerid][admincmdspy] == 1)
	{
	    SendClientMessage(playerid,COLOR_RED, "[DISABLED] You will nolonger see every command.");
	    PlayerTemp[playerid][admincmdspy] = 0;
	}
	return 1;
}
COMMAND:togchat(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerTemp[playerid][adminspy] == 0)
	{
	    SendClientMessage(playerid,COLOR_GREENYELLOW, "[ENABLED] You will now see every CHAT.");
	    PlayerTemp[playerid][adminspy] = 1;
	}
	else if(PlayerTemp[playerid][adminspy] == 1)
	{
	    SendClientMessage(playerid,COLOR_RED, "[DISABLED] You will nolonger see every CHAT.");
	    PlayerTemp[playerid][adminspy] = 0;
	}
	return 1;
}
COMMAND:gotoplace(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[15];
	if( sscanf ( params, "s", tmp)) return SCP(playerid, "[location]");
	if(!strcmp(tmp,"gundealer",true)) SetPlayerPosEx(playerid,1297.0530,-979.3176,32.6953);
    else if(!strcmp(tmp,"carrent",true)) SetPlayerPosEx(playerid,2141.7292,1403.5809,10.8426);
    else if(!strcmp(tmp,"pd",true)) SetPlayerPosEx(playerid,1551.0289,-1675.5751,15.6686);
    else if(!strcmp(tmp,"24/7",true)) SetPlayerPosEx(playerid,2105.1721,1352.5979,10.8586);
    else if(!strcmp(tmp,"bank",true)) SetPlayerPosEx(playerid,1379.7580,-1088.8709,27.3906);
    else if(!strcmp(tmp,"cityhall",true)) SetPlayerPosEx(playerid,1480.8217,-1767.9215,18.7957);
    else if(!strcmp(tmp,"4d",true)) SetPlayerPosEx(playerid,2032.3444,1005.0915,10.5252);
    else if(!strcmp(tmp,"carjacker",true)) SetPlayerPosEx(playerid,1830.6167,-1108.9797,23.8520);
    else if(!strcmp(tmp,"dropcar1",true)) SetPlayerPosEx(playerid,1607.9749,-1554.2881,13.5823);
    else if(!strcmp(tmp,"dropcar2",true)) SetPlayerPosEx(playerid,2613.5422,-2226.4785,13.3828);
    else if(!strcmp(tmp,"thief",true)) SetPlayerPosEx(playerid,-2748.7949,202.4960,7.0896);
	else if(!strcmp(tmp,"lva",true)) SetPlayerPosEx(playerid,1694.1484,1447.8075,10.4371);
	else if(!strcmp(tmp,"ls",true)) SetPlayerPosEx(playerid,1365.1155,-1091.1249,23.9739);
	else if(!strcmp(tmp,"sf",true)) SetPlayerPosEx(playerid,-1971.8976,279.1336,34.8532);
	else if(!strcmp(tmp,"waa",true)) SetPlayerPosEx(playerid,-2706.9346,217.1999,3.8542);
	else if(!strcmp(tmp,"lowrider",true)) SetPlayerPosEx(playerid,2645.7461,-2003.6947,13.3828);
	else if(!strcmp(tmp,"lsa",true)) SetPlayerPosEx(playerid,1961.3639,-2181.3953,13.5469);
	else if(!strcmp(tmp,"sfa",true)) SetPlayerPosEx(playerid,-1277.0461,-159.5158,14.1484);
	else if(!strcmp(tmp,"bayside",true)) SetPlayerPosEx(playerid,-2227.6042,2326.7627,7.5469);
	else if(!strcmp(tmp,"kacc",true)) SetPlayerPosEx(playerid,2618.5908,2721.3352,36.5386);
	else if(!strcmp(tmp,"lsa",true)) SetPlayerPosEx(playerid,-1671.3759,-2130.1179,35.8557);
	else if(!strcmp(tmp,"fc",true)) SetPlayerPosEx(playerid,-299.2670,1023.9211,19.5938);
	else if(!strcmp(tmp,"chilliad",true)) SetPlayerPosEx(playerid,-2232.8762,-1737.5347,480.8322);
	else if(!strcmp(tmp,"farm",true)) SetPlayerPosEx(playerid,-79.7549,-3.9109,3.1172);
    return 1;
}
ALTCOMMAND:go->gotoplace;
COMMAND:gmx(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 11) return SendClientError(playerid, CANT_USE_CMD);
	SetTimer("GMX", 15000, false);
	SendClientMessageToAll(-1, "{ff0000}(( WARNING: {FFFFFF}"SERVER_GM" is restarting in 20 seconds! {ff0000}))");
	PlayerLoop(i)
	{
	    TDWarning(i, "{ff0000}(( {FFFFFF}"SERVER_GM" is restarting in 19 seconds! {ff0000}))", 16000);
	}
	return 1;
}
COMMAND:freezeall(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 4) return SendClientError(playerid, CANT_USE_CMD);
    PlayerLoop(i)
    {
        SendClientMSG(i, COLOR_YELLOW, "(( AdmCmd | %s has frozen all players. ))", AnonAdmin(playerid));
        TogglePlayerControllable(i, false);
	}
	return 1;
}
COMMAND:unfreezeall(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 4) return SendClientError(playerid, CANT_USE_CMD);
    PlayerLoop(i)
    {
        SendClientMSG(i, COLOR_YELLOW, "(( AdmCmd | %s has unfrozen all players. ))", AnonAdmin(playerid));
        TogglePlayerControllable(i, true);
		DeletePVar(i, "Tied");
	}
	return 1;
}
COMMAND:stopwar(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 6) return SendClientError(playerid, CANT_USE_CMD);
	ResetWar();
	SendClientInfo(playerid, "Done.");
	return 1;
}
COMMAND:mark(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new mark;
	if(sscanf(params, "d", mark)) return SCP(playerid, "<1-3>");
	if(mark < 1 || mark > 3) return SCP(playerid, "<1-3>");
	new Float:iF[3];
	GetPlayerPos(playerid, iF[0], iF[1], iF[2]);
	if(mark == 1)
	{
		SetPVarFloat(playerid, "markX", iF[0]);
		SetPVarFloat(playerid, "markY", iF[1]);
		SetPVarFloat(playerid, "markZ", iF[2]);
		SetPVarInt(playerid, "markINT", GetPlayerInterior(playerid));
		SetPVarInt(playerid, "markVW", GetPlayerVirtualWorld(playerid));
	}
	else if(mark == 2)
	{
		SetPVarFloat(playerid, "markX2", iF[0]);
		SetPVarFloat(playerid, "markY2", iF[1]);
		SetPVarFloat(playerid, "markZ2", iF[2]);
		SetPVarInt(playerid, "markINT2", GetPlayerInterior(playerid));
		SetPVarInt(playerid, "markVW2", GetPlayerVirtualWorld(playerid));
	}
	else if(mark == 3)
	{
		SetPVarFloat(playerid, "markX3", iF[0]);
		SetPVarFloat(playerid, "markY3", iF[1]);
		SetPVarFloat(playerid, "markZ3", iF[2]);
		SetPVarInt(playerid, "markINT3", GetPlayerInterior(playerid));
		SetPVarInt(playerid, "markVW3", GetPlayerVirtualWorld(playerid));
	}
	SendClientMSG(playerid, COLOR_HELPEROOC, "# Mark %d has been set.", mark);
	return 1;
}
COMMAND:gomark(playerid, params[])
{
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new mark;
	if(sscanf(params, "d", mark)) return SCP(playerid, "<1-3>");

	if(mark == 1)
	{
		if(GetPVarFloat(playerid, "markX") == 0) return SendClientError(playerid, "/mark 1 has not been used yet!");
		SetPlayerPosEx(playerid, GetPVarFloat(playerid, "markX"), GetPVarFloat(playerid, "markY"), GetPVarFloat(playerid, "markZ"), GetPVarInt(playerid, "markINT"), GetPVarInt(playerid, "markVW"), false);
	}
	else if(mark == 2)
	{
		if(GetPVarFloat(playerid, "markX2") == 0) return SendClientError(playerid, "/mark 2 has not been used yet!");
		SetPlayerPosEx(playerid, GetPVarFloat(playerid, "markX2"), GetPVarFloat(playerid, "markY2"), GetPVarFloat(playerid, "markZ2"), GetPVarInt(playerid, "markINT2"), GetPVarInt(playerid, "markVW2"), false);
	}
	else if(mark == 3)
	{
		if(GetPVarFloat(playerid, "markX3") == 0) return SendClientError(playerid, "/mark 3 has not been used yet!");
		SetPlayerPosEx(playerid, GetPVarFloat(playerid, "markX3"), GetPVarFloat(playerid, "markY3"), GetPVarFloat(playerid, "markZ3"), GetPVarInt(playerid, "markINT3"), GetPVarInt(playerid, "markVW3"), false);
	}
	return 1;
}
COMMAND:forcept(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
    APayDay(PlayerName(playerid));
	format(iStr,sizeof(iStr),"[ADMIN] %s Forced Paytime - %d",PlayerName(playerid),gettime());
	AppendTo(adminlog,iStr);
	format(iStr, sizeof(iStr), "6[PAYTIME] %s has forced the paytime.", PlayerName(playerid));
	iEcho(iStr);
	return 1;
}
COMMAND:warn(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iReason[ 128 ];
	if( sscanf ( params, "us", iPlayer, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	AdminDB(PlayerName(iPlayer), PlayerName(playerid), iReason, "[WARN]");
	WarnReas(AnonAdmin(playerid),iPlayer,iReason);
	return 1;
}
COMMAND:rwarn(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iReason[ 128 ];
	if( sscanf ( params, "us", iPlayer, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr, sizeof(iStr), "[WARNING REMOVED] by %s. Reason: %s", PlayerName(playerid), iReason);
	if(PlayerInfo[iPlayer][warns] > 0) PlayerInfo[iPlayer][warns]--;
	else return SendClientInfo(playerid, "Player already has 0 warnings.");
	SendClientMSG(iPlayer, COLOR_RED, "..:: %s has removed 1 warning from you ::..", AnonAdmin(playerid));
	SendClientMSG(playerid, COLOR_RED, "..:: You have removed 1 warning from %s. ::..", RPName(iPlayer));
	format( iStr, sizeof(iStr), "4{ RWARN } %s[%d] has removed a warning from %s. [%d/5]",PlayerName(playerid), playerid, PlayerName(iPlayer), PlayerInfo[iPlayer][warns]);
	iEcho( iStr );
	return 1;
}
COMMAND:ban(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	if(strcmp(glob_toban,"NoBodY", true))
	{
	    return SendClientError(playerid, "Try again in 1 second!");
	}
	new iPlayer, iReason[ 128 ];
	if( sscanf ( params, "us", iPlayer, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr, sizeof(iStr), "[IP BAN] by %s. Reason: %s", PlayerName(playerid), iReason);
	BanReas(AnonAdmin(playerid),iPlayer,iReason, 1);
	return 1;
}
COMMAND:getbusinesses(playerid, params[])
{
	if(!IsPlayerENF(playerid) && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	//if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iName[MAX_PLAYER_NAME];
	if( sscanf ( params, "s", iName) || strlen(params) > MAX_PLAYER_NAME)  return SCP(playerid, "[PlayerName]");
	SendClientMessage(playerid, COLOR_HELPEROOC, "=====================================================");
	SendClientMSG(playerid, COLOR_HELPEROOC, "- BUSINESSES which have \"%s\" as owner:", iName);
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
		if(strcmp(BusinessInfo[b][bOwner], iName, false)) continue;
		SendClientMSG(playerid, COLOR_LIGHTGREY,  " BizID[%d] Name[%s] Owner[%s] Till[$%d] TaxRate[%d%%]", b, BusinessInfo[b][bName], iName, BusinessInfo[b][bTill], BusinessInfo[b][bTax]);
	}
	SendClientMessage(playerid, COLOR_HELPEROOC, "=====================================================");
	return 1;
}
COMMAND:h(playerid, params[])
{
	if(PlayerInfo[playerid][power] || PlayerInfo[playerid][helper])
	{
		new iReason[ 128 ];
		if( sscanf ( params, "s", iReason))  return SCP(playerid, "[message]");
		format(iStr,sizeof(iStr),"{ [HELPER] %s %s: %s }",AdminLevelName(playerid), RPName(playerid), iReason);
		PlayerLoop(qqq) if(PlayerInfo[qqq][power] || PlayerInfo[qqq][helper]) SendPlayerMessage(qqq,COLOR_ORANGE,iStr, "{ HELPER]");
		format( iStr, sizeof(iStr), "7{ [HELPER] %s %s: %s }",AdminLevelName(playerid), PlayerName(playerid), iReason);
		iEcho( iStr );
		// log
		new iQuery[288], pIP[31];
		GetPlayerIp(playerid, pIP, sizeof(pIP));
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `HelperChat` (`PlayerName`, `Message`, `IP`, `TimeDate`) VALUES ('%e', '%e', '%e', '%e')", PlayerName(playerid), iReason, pIP, TimeDateEx());
		mysql_tquery(MySQLPipeline, iQuery);
	}
	else SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:a(playerid, params[])
{
	if(PlayerInfo[playerid][power])
	{
		new iReason[ 128 ];
		if( sscanf ( params, "s", iReason))  return SCP(playerid, "[message]");
		format(iStr,sizeof(iStr),"{ [ADMIN] %s %s: %s }",AdminLevelName(playerid), RPName(playerid), iReason);
		PlayerLoop(qqq) if(PlayerInfo[qqq][power]) SendPlayerMessage(qqq,COLOR_ADMINCHAT,iStr, "{ [ADMIN]");
		format( iStr, sizeof(iStr), "7{ [ADMIN] %s %s: %s }",AdminLevelName(playerid), PlayerName(playerid), iReason);
		iEcho( iStr );
		// log
		new iQuery[288], pIP[31];
		GetPlayerIp(playerid, pIP, sizeof(pIP));
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `AdminChat` (`PlayerName`, `Message`, `IP`, `TimeDate`) VALUES ('%e', '%e', '%e', '%e')", PlayerName(playerid), iReason, pIP, TimeDateEx());
		mysql_tquery(MySQLPipeline, iQuery);
	}
	else SendClientError(playerid, "This command has been replaced. Use /d!");
	return 1;
}
COMMAND:kick(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	if(strcmp(glob_toban,"NoBodY", true))
	{
	    return SendClientError(playerid, "Try again in 1 second!");
	}
	new iPlayer, iReason[ 128 ];
	if( sscanf ( params, "us", iPlayer, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	AdminDB(PlayerName(iPlayer), PlayerName(playerid), iReason, "[KICK]");
	KickReas(AnonAdmin(playerid),iPlayer,iReason);
	return 1;
}
COMMAND:givecash(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iType[ 10 ], iAmount;
	if( sscanf ( params, "usd", iPlayer, iType, iAmount)) return SCP(playerid, "[PlayerID/PartOfName] [hand/bank] [amount]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!strcmp(iType, "bank", true))
	{
		if(iAmount > 0) PlayerInfo[iPlayer][bank] += iAmount;
		else PlayerInfo[iPlayer][bank] -= iAmount;
		SendClientMSG(iPlayer, COLOR_YELLOW, "[ADMIN] Administrator %s has given you $%s to your BANK account!", RPName(playerid), number_format(iAmount));
 		format( iStr, sizeof(iStr), "4[GIVECASH] Admin %s[%d] added to %s[%d] $%s BANK-money",RPName(playerid),playerid,RPName(iPlayer),iPlayer,number_format(iAmount));
		iEcho(iStr); AppendTo(moneylog,iStr);
	}
	else if(!strcmp(iType, "hand", true))
	{
		GivePlayerMoneyEx(iPlayer, iAmount);
		SendClientMSG(iPlayer, COLOR_YELLOW, "[ADMIN] Administrator %s has given you $%s to your HAND-money.", RPName(playerid), number_format(iAmount));
		format( iStr, sizeof(iStr), "4[GIVECASH] Admin %s[%d] added to %s[%d] $%s HAND-money",RPName(playerid),playerid,RPName(iPlayer),iPlayer,number_format(iAmount));
		iEcho(iStr); AppendTo(moneylog,iStr);
	}
	else return SCP(playerid, "[PlayerID/PartOfName] [hand/bank] [amount]");
	return 1;
}
COMMAND:takecash(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iType[ 10 ], iAmount;
	if( sscanf ( params, "usd", iPlayer, iType, iAmount)) return SCP(playerid, "[PlayerID/PartOfName] [hand/bank] [amount]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!strcmp(iType, "bank", true))
	{
		GivePlayerMoneyEx(iPlayer, -iAmount);
		SendClientMSG(iPlayer, COLOR_YELLOW, "[ADMIN] Administrator %s has given you $%s to your BANK account!", RPName(playerid), number_format(iAmount));
 		format( iStr, sizeof(iStr), "4[GIVECASH] Admin %s[%d] removed from %s[%d] $%d BANK-money",RPName(playerid),playerid,RPName(iPlayer),iPlayer,iAmount);
		iEcho(iStr); AppendTo(moneylog,iStr);
	}
	else if(!strcmp(iType, "hand", true))
	{
		GivePlayerMoneyEx(iPlayer, -iAmount);
		SendClientMSG(iPlayer, COLOR_YELLOW, "[ADMIN] Administrator %s has given you $%s to your HAND-money.", RPName(playerid), number_format(iAmount));
		format( iStr, sizeof(iStr), "4[GIVECASH] Admin %s[%d] removed from %s[%d] $%d HAND-money",RPName(playerid),playerid,RPName(iPlayer),iPlayer,iAmount);
		iEcho(iStr); AppendTo(moneylog,iStr);
	}
	else return SCP(playerid, "[PlayerID/PartOfName] [hand/bank] [amount]");
	return 1;
}
COMMAND:forcecmd(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 11) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iReason[ 128 ];
	if( sscanf ( params, "us", iPlayer, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [command]");
	OnPlayerCommandText(iPlayer, iReason);
	return 1;
}
COMMAND:forceallcmd(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 11) return SendClientError(playerid, CANT_USE_CMD);
	new iReason[ 128 ];
	if( sscanf ( params, "s", iReason))  return SCP(playerid, "[command]");
	PlayerLoop(i) OnPlayerCommandText(i, iReason);
	return 1;
}
COMMAND:suspend(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	if(strcmp(glob_toban,"NoBodY", true))
	{
	    return SendClientError(playerid, "Try again in 1 second!");
	}
	new iPlayer, iReason[ 128 ];
	if( sscanf ( params, "us", iPlayer, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	AdminDB(PlayerName(iPlayer), PlayerName(playerid), iReason, "[SUSPENDED]");
	BanReas(AnonAdmin(playerid),iPlayer,iReason, 0);
	return 1;
}
COMMAND:osuspend(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer[ MAX_PLAYER_NAME ], iReason[ 128 ];
	if( sscanf ( params, "ss", iPlayer, iReason))  return SCP(playerid, "[Exact_Name] [reason]");
	if(AccountExist(iPlayer))
	{
		new iQuery[328];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Banned` = 1, `BanReason` = '%e' `WhoBannedMe` = '%e', `WhenIGotBanned` = '%e' WHERE `PlayerName` = '%e'", iReason, PlayerName(playerid), TimeDate(), iPlayer);
		mysql_tquery(MySQLPipeline, iQuery);
		format(iStr,sizeof(iStr),"%s has been successfully suspended.",iPlayer);
		SendClientInfo(playerid, iStr);
		AdminDB(iPlayer, PlayerName(playerid), iReason, "[O-SUSPENDED]");
		return 1;
	}
   	else SendClientError(playerid, "Player account hasn't been found.");
	return 1;
}
COMMAND:tsuspend(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	if(strcmp(glob_toban,"NoBodY", true))
	{
	    return SendClientError(playerid, "Try again in 1 second!");
	}
	new iPlayer, iTime, iReason[ 128 ];
	if( sscanf ( params, "uds", iPlayer, iTime, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [hours] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	AdminDB(PlayerName(iPlayer), PlayerName(playerid), iReason, "[T-SUSPENDED]");
	BanReasEx(AnonAdmin(playerid),iPlayer,iTime,iReason);
	return 1;
}
COMMAND:mute(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iTime, iReason[ 128 ];
	if( sscanf ( params, "uds", iPlayer, iTime, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [minutes] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr,sizeof(iStr),"(( AdmCmd | %s has muted %s for %d minutes. Reason: %s ))", AnonAdmin(playerid),RPName(iPlayer), iTime, iReason);
  	PlayerTemp[iPlayer][muted]=1;
   	PlayerTemp[iPlayer][mutedtick] = GetTickCount() + iTime*60*1000;
	SendClientMessageToAll(COLOR_RED,iStr);
	return 1;
}
COMMAND:unmute(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	format(iStr,sizeof(iStr),"(( AdmCmd | %s has unmuted %s. ))",AnonAdmin(playerid),RPName(iPlayer));
  	PlayerTemp[iPlayer][muted]=0;
   	PlayerTemp[iPlayer][mutedtick] = 0;
	SendClientMessageToAll(COLOR_RED,iStr);
	return 1;
}
COMMAND:inv(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	new Float:px, Float:py, Float:pz;
	GetPlayerPos(iPlayer, px, py, pz);
	SetPlayerArmour(iPlayer, 0);
	SetPlayerHealth(iPlayer, 100);
	CreateExplosion(px, py, pz, 11, 1);
	SetTimerEx("CheckInv", 300, false, "d", iPlayer);
	format(iStr,sizeof(iStr),"5[ Admin ] %s has been invunerable-checked by %s.", PlayerName(iPlayer), PlayerName(playerid));
	iEcho(iStr);
	return 1;
}
COMMAND:biz(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	new wat[10], iID[ 64 ];
	if( sscanf ( params, "sz", wat, iID)) return SCP(playerid, "[ move / name / owner / create / delete / types ]");
	if(!strcmp(wat, "move"))
	{
	    if(!strlen(iID) || !IsNumeric(iID)) return SCP(playerid, "move [biz id]");
	    new tmpprice = strval(iID);
		if(tmpprice < 0 || tmpprice > MAX_BUSINESS) return SendClientError(playerid, "Invalid business ID!");
	    if(BusinessInfo[tmpprice][bActive] != true) return SendClientError(playerid, "Invalid business ID!");
	    new Float:ppx, Float:ppy, Float:ppz;
		GetPlayerPos(playerid, ppx, ppy, ppz);
		BusinessInfo[tmpprice][bX] = ppx;
		BusinessInfo[tmpprice][bY] = ppy;
		BusinessInfo[tmpprice][bZ] = ppz;
		ReloadBusiness(tmpprice);
		return 1;
	}
	else if(!strcmp(wat, "types"))
	{
		ShowDialog(playerid, DIALOG_NO_RESPONSE, 4);
		return 1;
	}
	else if(!strcmp(wat, "name"))
	{
	    new _id = IsPlayerOutBiz(playerid);
		if(_id == -1) return SendClientError(playerid, "Not at a business!");
	    if(!strlen(iID) || strlen(iID) < 6 || strlen(iID) > MAX_BIZ_NAME) return SCP(playerid, "name [biz name]");
	    if(strfind(iID, "~") != -1) return SendClientError(playerid, "Invalid character!");
		myStrcpy(BusinessInfo[_id][bName], iID);
		ReloadBusiness(_id);
		return 1;
	}
	else if(!strcmp(wat, "create"))
	{
		if(GetUnusedBusiness() == -1) return SendClientError(playerid, "Couldn't create business, max reached.");
		if(!strlen(iID) || !IsNumeric(iID)) return SCP(playerid, "create [type]");
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		CreateBusiness("NoBodY", strval(iID), x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		return 1;
	}
	else if(!strcmp(wat, "owner"))
	{
		new id_ = IsPlayerOutBiz(playerid);
		if(id_ == -1) return SendClientError(playerid, "Not at a business!");
		if(!strlen(iID) || strlen(iID) >= MAX_PLAYER_NAME) return SCP(playerid, "owner [owner name]");
		if(strfind(iID, "~") != -1) return SendClientError(playerid, "Invalid character!");
		myStrcpy(BusinessInfo[id_][bOwner],iID);
		ReloadBusiness(id_);
		return 1;
	}
	else if(strcmp(wat,"delete",true)==0)
	{
	    if(!strlen(iID) || !IsNumeric(iID)) return SCP(playerid, "delete [biz id]");
	    new tmpprice = strval(iID);
		if(tmpprice < 0 || tmpprice > MAX_BUSINESS) return SendClientError(playerid, "Invalid business ID!");
	    if(BusinessInfo[tmpprice][bActive] != true) return SendClientError(playerid, "Invalid business ID!");
		new iQuery[250];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `BusinessInfo` WHERE `ID` = %d", iID);
		mysql_tquery(MySQLPipeline, iQuery);
		//SetTimerEx("Robber",180000,0,"d",playerid);
		SetTimerEx("ReloadBusiness", 1000, 0, "d", iID);
	    return 1;
	}
	else return SCP(playerid, "[ move / name / owner / create / delete / types ]");
}
COMMAND:reloadbiz(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	new id = IsPlayerOutBiz(playerid);
	if(id != -1) ReloadBusiness(id);
	else SendClientError(playerid, "Not in a business icon!");
	return 1;
}
COMMAND:gotobiz(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	new tmp;
	if( sscanf ( params, "d", tmp))  return SCP(playerid, "[Biz ID]");
	if(BusinessInfo[tmp][bX] != 0.0 && BusinessInfo[tmp][bActive] == true)
	{
		PlayerTemp[playerid][tmphouse] = -1;
		PlayerTemp[playerid][tmpbiz] = -1;
		if(IsPlayerInAnyVehicle(playerid)) return SetVehiclePos(GetPlayerVehicleID(playerid), BusinessInfo[tmp][bX], BusinessInfo[tmp][bY], BusinessInfo[tmp][bZ]);
		else return SetPlayerPos(playerid, BusinessInfo[tmp][bX], BusinessInfo[tmp][bY], BusinessInfo[tmp][bZ]);
	}
	else return SendClientError(playerid, "Business doesn't exist!");
}
COMMAND:gotofaction(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	new iID;
	if( sscanf ( params, "d", iID))  return SCP(playerid, "[Faction ID]");
	if(HQInfo[iID][hqActive] != true) return SendClientError(playerid, "Invalid Faction ID! (Non existant)");
	SetPlayerPos(playerid, HQInfo[iID][fHQX], HQInfo[iID][fHQY], HQInfo[iID][fHQZ]);
	SetPlayerInterior(playerid, HQInfo[iID][fHQInt]);
	SetPlayerVirtualWorld(playerid, HQInfo[iID][fHQVW]);
	return 1;
}
COMMAND:gotohouse(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	new iID;
	if( sscanf ( params, "d", iID))  return SCP(playerid, "[House ID]");
	if(HouseInfo[iID][hActive] != true) return SendClientError(playerid, "Invalid house ID! (Non existant)");
	SetPlayerPos(playerid, HouseInfo[iID][hX], HouseInfo[iID][hY], HouseInfo[iID][hZ]);
	SetPlayerInterior(playerid, HouseInfo[iID][hInterior]);
	SetPlayerVirtualWorld(playerid, HouseInfo[iID][hVirtualWorld]);
	return 1;
}
COMMAND:changenick(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10 && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	new oldnick[MAX_PLAYER_NAME], newnick[MAX_PLAYER_NAME];
	if( sscanf ( params, "ss", oldnick, newnick))  return SCP(playerid, "[Exact_Name] [New_Name]");
	if(!AccountExist(oldnick)) return SendClientError(playerid, "Account file not found!");
	if(AccountExist(newnick)) return SendClientError(playerid, "Account already exists!");
	new iPlayer = GetPlayerId(oldnick);
	if(!IsPlayerConnected(iPlayer) && PlayerInfo[playerid][helper] && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "Helpers cannot change the name of offline players.");
	if(PlayerInfo[iPlayer][playerlvl] > 3) return SendClientError(playerid, "Helpers cannot change the name of level 3 players and above.");
	ChangePlayerName(oldnick, newnick);
	return 1;
}
COMMAND:changemyname(playerid, params[])
{
	if(!PlayerInfo[playerid][premium] && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][namechanges] < 1) return SendClientError(playerid, "You don't have any namechanges left.");
	new iName[MAX_PLAYER_NAME];
	if(sscanf(params, "s", iName)) return SCP(playerid, "[New_Name]");
	if(AccountExist(iName)) return SendClientError(playerid, "Account already exists!");
	if(!IsARolePlayName(iName)) return SendClientError(playerid, "Non RP Name!");
	ChangePlayerName(PlayerName(playerid), iName);
	PlayerInfo[playerid][namechanges]--;
	return 1;
}
COMMAND:tell(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 128 ];
	if( sscanf ( params, "s", tmp)) return SCP(playerid, "[txt]");
	if(TellTDActive) return SendClientError(playerid, "Please wait 6 seconds!");
	TextDrawSetString(TellTD, tmp);
	TextDrawShowForAll(TellTD);
	TellTDActive = 1;
	SetTimer("KillTellTD", 6000, false);
	format(iStr, sizeof(iStr), "2[Admin] %s[%d] has used /tell %s", PlayerName(playerid), playerid, tmp);
	iEcho(iStr);
	return 1;
}
COMMAND:ctell(playerid, params[])
{
	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 128 ];
	if( sscanf ( params, "s", tmp)) return SCP(playerid, "[txt]");
	GameTextForAll(tmp,5000,1);
	format(iStr, sizeof(iStr), "2[Admin] %s[%d] has used /ctell %s", PlayerName(playerid), playerid, tmp);
	iEcho(iStr);
	return 1;
}
COMMAND:gethouses(playerid, params[])
{
	if(!IsPlayerENF(playerid) && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
//	if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
	new iName[MAX_PLAYER_NAME];
	if( sscanf ( params, "s", iName) || strlen(params) > MAX_PLAYER_NAME)  return SCP(playerid, "[Name]");
	SendClientMessage(playerid, COLOR_HELPEROOC, "=====================================================");
	SendClientMSG(playerid, COLOR_HELPEROOC, "- HOUSES which have \"%s\" as owner:", iName);
	HouseLoop(h)
	{
		if(HouseInfo[h][hActive] != true) continue;
		if(strcmp(HouseInfo[h][hOwner], iName, false)) continue;
		SendClientMSG(playerid, COLOR_LIGHTGREY, " HouseID[%d] Owner[%s] Till[$%d]", h, iName, HouseInfo[h][hTill]);
	}
	SendClientMessage(playerid, COLOR_HELPEROOC, "=====================================================");
	return 1;
}
COMMAND:unbanip(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 3) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[32];
	if( sscanf ( params, "s", tmp))  return SCP(playerid, "[IP / IP Range]");
	format(iStr,sizeof(iStr),"unbanip %s",tmp);
	SendRconCommand(iStr);
	SendRconCommand("reloadbans");
	format(iStr,sizeof(iStr),".: [IP-UNBAN] %s unbanned. :.",tmp);
	SendClientMessage(playerid, COLOR_WHITE, iStr);
	format(iStr,sizeof(iStr),"%s has unbanned IP %s", PlayerName(playerid), tmp);
	AppendTo(banlog,iStr);
	return 1;
}
COMMAND:unsuspend(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 2) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer[MAX_PLAYER_NAME];
	if( sscanf ( params, "s", iPlayer))  return SCP(playerid, "[Exact_Name]");

	if(!AccountExist(iPlayer)) return SendClientError(playerid, "Account not found!");
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Banned` = 0, `TBanned` = 0 WHERE `PlayerName` = '%e'", iPlayer);
	mysql_tquery(MySQLPipeline, iQuery);

	SendClientMSG(playerid, COLOR_HELPEROOC, "[UNSUSPEND]: %s has been unsuspended.", iPlayer);
	format(iStr, sizeof(iStr), "4[ UNSUSPEND ] %s has been unbanned by %s.", iPlayer, PlayerName(playerid));
	iEcho(iStr);
	AdminDB(iPlayer, PlayerName(playerid), "NULL", "[UNSUSPENDED]");
	return 1;
}
COMMAND:setmotd(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 8) return SendClientError(playerid, CANT_USE_CMD);

	new iMOTD[128];
	if( sscanf ( params, "s", iMOTD))  return SCP(playerid, "[text]");
	dini_Set(globalstats, "motd", iMOTD);
    return 1;
}
COMMAND:ainvite(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iFaction;
	if( sscanf ( params, "ud", iPlayer, iFaction)) return SCP(playerid, "[PlayerID/PartOfName] [factionID]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	Invite(iPlayer, iFaction, PlayerName(playerid));
	SendClientInfo(playerid, "Done.");
	return 1;
}
COMMAND:auninvite(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, "Player is not in a faction!");
	Uninvite(iPlayer, PlayerName(playerid));
	SendClientInfo(playerid, "Done.");
	return 1;
}
COMMAND:asetrank(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iRank[64];
	if( sscanf ( params, "us", iPlayer, iRank)) return SCP(playerid, "[PlayerID/PartOfName] [rankname]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(strfind(iRank, "'", true) != -1 || strfind(iRank, "=", true) != -1 || strfind(iRank, "|", true) != -1 || strlen(iRank) >= 64)
	{
		return SendClientError(playerid, "Invalid character(s) used (~,=,|)");
	}
	myStrcpy(PlayerInfo[iPlayer][rankname], iRank);
	format(iStr, sizeof(iStr), "10[RANK] %s has set the rank of %s to %s", PlayerName(playerid), PlayerName(iPlayer), iRank);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has set the rank of %s to %s.", GetPlayerFactionName(iPlayer), RPName(playerid), RPName(iPlayer), iRank);
	SendClientMessageToTeam(PlayerInfo[iPlayer][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:makeleader(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iFaction;
	if( sscanf ( params, "ud", iPlayer, iFaction)) return SCP(playerid, "[PlayerID/PartOfName] [factionID]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	Invite(iPlayer, iFaction, PlayerName(playerid));
	PlayerInfo[iPlayer][ranklvl] = 0;
	SendClientInfo(playerid, "Done.");
	return 1;
}
COMMAND:makeooc(playerid, params[])
{
	if(!GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerTemp[iPlayer][oocmode]) PlayerTemp[iPlayer][oocmode] = 0;
	else PlayerTemp[iPlayer][oocmode] = 1;
	SendClientMSG(playerid, COLOR_YELLOW, " Switched OOC mode for %s (%d).", RPName(iPlayer), iPlayer);
	return 1;
}
COMMAND:makehelper(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iFaction;
	if( sscanf ( params, "ud", iPlayer, iFaction)) return SCP(playerid, "[PlayerID/PartOfName] [helper? (1/0)]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	PlayerInfo[iPlayer][helper] = iFaction;
	SendClientInfo(playerid, "Done.");
	return 1;
}
COMMAND:makeadmin(playerid, params[])
{
	if(GetAdminLevel(playerid) < 11 && !IsPlayerAdmin(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iFaction;
	if( sscanf ( params, "ud", iPlayer, iFaction)) return SCP(playerid, "[PlayerID/PartOfName] [adminlvl]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	PlayerInfo[iPlayer][power] = iFaction;
	SendClientMSG(playerid, COLOR_HELPEROOC, "Player %s (%d) is now admin level %d!", RPName(iPlayer), iPlayer, iFaction);
	return 1;
}
COMMAND:asetpayment(playerid, params[])
{
	if(GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iAmount;
	if( sscanf ( params, "ud", iPlayer, iAmount)) return SCP(playerid, "[PlayerID/PartOfName] [amount]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(iAmount < 0 || iAmount > 1000000) return SCP(playerid, "[PlayerID/PartOfName] [amount]");
	PlayerInfo[iPlayer][fpay] = iAmount;
	format(iStr, sizeof(iStr), "10[FPAY] %s has set the payment of %s to $%d", PlayerName(playerid), PlayerName(iPlayer), iAmount);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has set the payment of %s to $%s.", GetPlayerFactionName(iPlayer), RPName(playerid), RPName(iPlayer), number_format(iAmount));
	SendClientMessageToTeam(PlayerInfo[iPlayer][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:specoff(playerid, params[])
{
	if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, CANT_USE_CMD);
	StopSpectate(playerid);
	GameTextForPlayer(playerid,"specoff",1,3);
	return 1;
}
COMMAND:makepremium(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 11) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iPack;
	if( sscanf ( params, "ud", iPlayer, iPack))  return SCP(playerid, "[PlayerID/PartOfName] [Pack ID]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	PlayerInfo[iPlayer][premium] = iPack;
	PlayerInfo[iPlayer][playerlvl] += iPack;
	PlayerInfo[iPlayer][rpoints] += iPack;
	PlayerInfo[iPlayer][phonechanges] += iPack;
	new loltime = gettime();
	PlayerInfo[iPlayer][premiumexpire] = loltime+(86400*30);
	SaveAccount(iPlayer);
	return 1;
}

COMMAND:weather(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 8) return SendClientError(playerid, CANT_USE_CMD);
	new param1;
	if( sscanf ( params, "d", param1)) return SCP(playerid, "[weather ID]");
	SetWeather(param1);
    return 1;
}

COMMAND:setlvl(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 11) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iTier;
	if( sscanf ( params, "ud", iPlayer, iTier)) return SCP(playerid, "[PlayerID/PartOfName] [lvl]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	SetPlayerScore(iPlayer,iTier);
	PlayerInfo[iPlayer][playerlvl]=iTier;
	SendClientMSG(playerid, COLOR_LIGHTBLUE, ":: Level of %s (ID: %d) has been set to %d! ::", RPName(iPlayer), iPlayer, iTier);
	SendClientMSG(iPlayer, COLOR_LIGHTBLUE, ":: %s has set your level to %d! ::", RPName(playerid), iTier);
	return 1;
}

COMMAND:setphone(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 6) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iTier;
	if( sscanf ( params, "ud", iPlayer, iTier)) return SCP(playerid, "[PlayerID/PartOfName] [phone]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	PlayerInfo[iPlayer][phonenumber]=iTier;
	SendClientMSG(playerid, COLOR_LIGHTBLUE, ":: Phone of %s (ID: %d) has been set to %d! ::", RPName(iPlayer), iPlayer, iTier);
	SendClientMSG(iPlayer, COLOR_LIGHTBLUE, ":: %s has set your phonenumber to %d! ::", RPName(playerid), iTier);
	return 1;
}
COMMAND:setskin(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 6) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iTier;
	if( sscanf ( params, "ud", iPlayer, iTier)) return SCP(playerid, "[PlayerID/PartOfName] [skinID]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!IsValidSkin(iTier)) return SendClientError(playerid, "Invalid Skin ID!");
	PlayerInfo[iPlayer][Skin] = iTier;
	PlayerTemp[iPlayer][spawnrdy]=0;
	SetPlayerSkin(iPlayer, iTier);
	SendClientMSG(playerid, COLOR_LIGHTBLUE, ":: Skin of %s (ID: %d) has been set to %d! ::", RPName(iPlayer), iPlayer, iTier);
	SendClientMSG(iPlayer, COLOR_LIGHTBLUE, ":: %s has set your skin to ID %d! ::", RPName(playerid), iTier);
	return 1;
}
COMMAND:asettier(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iTier;
	if( sscanf ( params, "ud", iPlayer, iTier)) return SCP(playerid, "[PlayerID/PartOfName] [Tier (0-2)]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(iTier < 0 || iTier > 2) return SCP(playerid, "[PlayerID/PartOfName] [Tier (0-2)]");
	PlayerInfo[iPlayer][ranklvl] = iTier;
	format(iStr, sizeof(iStr), "10[TIER] %s has set the tier of %s to %d", PlayerName(playerid), PlayerName(iPlayer), iTier);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has set the tier of %s to %d.", GetPlayerFactionName(iPlayer), RPName(playerid), RPName(iPlayer), iTier);
	SendClientMessageToTeam(PlayerInfo[iPlayer][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	SetPlayerTeamEx(iPlayer, PlayerInfo[iPlayer][playerteam]);
	PlayerTemp[iPlayer][spawnrdy]=0;
	return 1;
}
COMMAND:setprice(playerid, params[])
{
	new tmpid = IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_GUNSTORE)
	{
		if(strcmp(PlayerName(playerid), BusinessInfo[tmpid][bOwner], false)==0 || PlayerInfo[playerid][power] >= 10)
		{
			new tmp[ 10 ], iAmount;
			if(sscanf(params, "sd", tmp, iAmount)) return SCP(playerid, "[weapon] [amount]");
			if(iAmount < 200 || iAmount > 7500) return SendClientError(playerid, "Min. $200 | Max. $7.500");
			if(!strcmp(tmp, "deagle", true)) BusinessInfo[tmpid][bDeagle] = iAmount;
			else if(!strcmp(tmp, "m4", true)) BusinessInfo[tmpid][bM4] = iAmount;
			else if(!strcmp(tmp, "sniper", true)) BusinessInfo[tmpid][bSniper] = iAmount;
			else if(!strcmp(tmp, "mp5", true)) BusinessInfo[tmpid][bMP5] = iAmount;
			else if(!strcmp(tmp, "rifle", true)) BusinessInfo[tmpid][bRifle] = iAmount;
			else if(!strcmp(tmp, "shotgun", true)) BusinessInfo[tmpid][bShotgun] = iAmount;
			else if(!strcmp(tmp, "armour", true)) BusinessInfo[tmpid][bArmour] = iAmount;
			else return SendClientError(playerid, "Weapons: Deagle, MP5, M4, AK47, Shotgun, Sniper, Armour");
			SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[%s] Weapon price for %s has been set to $%d!", BusinessInfo[tmpid][bName], tmp, iAmount);
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	else if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_ADTOWER)
	{
		if(strcmp(PlayerName(playerid), BusinessInfo[tmpid][bOwner], false)==0 || PlayerInfo[playerid][power] >= 10)
		{
			new iAmount;
			if(sscanf(params, "d", iAmount)) return SCP(playerid, "[ AD Amount ]");
			if(iAmount < 1 || iAmount > 250) return SendClientError(playerid, "Amount cannot be more than $250 or less than $1.");
			new lastPrice = dini_Int(globalstats, "ad");
			dini_IntSet(globalstats, "ad", iAmount);
			SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[BIZ] Advertisements per character has been set to $%s!", number_format(iAmount));
			if(lastPrice > iAmount) SendClientMSG(playerid, COLOR_LIGHTGREY, " The price has been decreased by {D13F3F}$%s{CCCCCC}!", number_format(lastPrice - iAmount)); // decreased
			else SendClientMSG(playerid, COLOR_LIGHTGREY, " The price has been incrased by {00ff7f}$%s{CCCCCC}!", number_format(iAmount - lastPrice)); // increased
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	else return SendClientError(playerid, CANT_USE_CMD);
}
COMMAND:bizstats(playerid, params[])
{
	new tmpid = IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid), BusinessInfo[tmpid][bOwner], false)==0 || PlayerInfo[playerid][power]>=10)
		{
			if(BusinessInfo[tmpid][bCompsFlag] != NOCOMPS)
			{
				new tmpcomps = BusinessInfo[tmpid][bComps],
					tmpcash = BusinessInfo[tmpid][bTill],
					tmpentrance = BusinessInfo[tmpid][bFee],
					tmpask = BusinessInfo[tmpid][bAskComps],
					taxrate = BusinessInfo[tmpid][bTax];
				new iStrng[ 256 ];
				format(iStrng, sizeof(iStrng), "\
				~y~ID: ~w~%d~n~\
				~y~Till: ~w~$%d~n~\
				~y~Comps: ~w~%d~n~\
				~y~Comps order: ~w~%d~n~\
				~y~Entrance: ~w~$%d~n~\
				~y~Tax: ~w~%d%%~n~", tmpid, tmpcash, tmpcomps, tmpask, tmpentrance, taxrate);
				ShowInfoBox(playerid, BusinessInfo[tmpid][bName], iStrng);
				return 1;
			}
			else
			{
				new tmpcash = BusinessInfo[tmpid][bTill],
					tmpentrance = BusinessInfo[tmpid][bFee],
					taxrate = BusinessInfo[tmpid][bTax];
				new iStrng[ 256 ];
				format(iStrng, sizeof(iStrng), "\
				~y~ID: ~w~%d~n~\
				~y~Till: ~w~$%d~n~\
				~y~Entrance: ~w~$%d~n~\
				~y~Tax: ~w~%d%%~n~", tmpid, tmpcash, tmpentrance, taxrate);
				ShowInfoBox(playerid, BusinessInfo[tmpid][bName], iStrng);
				return 1;
			}
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	return 1;
}
COMMAND:buybiz(playerid, params[])
{
	if(GetPlayerBusinesses(playerid) >= 3) return SendClientError(playerid, "You cannot own more then 7 businesses.");
	new tmpid=IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
	    if(BusinessInfo[tmpid][bBuyable] == 0)
			return SendClientError(playerid, "This business is not on sale!");
		new price = BusinessInfo[tmpid][bSellprice];
		if(price > HandMoney(playerid)) return SendClientError(playerid, "You don't have enough money!");
		format(iStr, sizeof(iStr), "6[BIZ] %s has bought %s from %s for $%s.", PlayerName(playerid), BusinessInfo[tmpid][bName], BusinessInfo[tmpid][bOwner], number_format(price));
		iEcho(iStr);
		AppendTo(moneylog,iStr);
		SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[BIZ] You have bought \"%s\" for $%s!", BusinessInfo[tmpid][bName], number_format(price));

		SetBank(PlayerName(playerid), BusinessInfo[tmpid][bOwner], price);
		myStrcpy(BusinessInfo[tmpid][bOwner], PlayerName(playerid));
		BusinessInfo[tmpid][bBuyable] = 0;
		new iZone[60];
		GetZone(BusinessInfo[tmpid][bX], BusinessInfo[tmpid][bY], BusinessInfo[tmpid][bZ], iZone);
		format( iStr, sizeof(iStr), "NEWS: A business in %s has been bought by %s!", iZone, MaskedName(playerid));
		TextDrawSetString(TextDraw__News, iStr);
		ReloadBusiness(tmpid);
	}
	return 1;
}
COMMAND:unsellbiz(playerid, params[])
{
	new tmpid=IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0 || PlayerInfo[playerid][power]>=10)
		{
			BusinessInfo[tmpid][bBuyable] = 0;
			SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[BIZ] The business %s is nolonger on sale!", BusinessInfo[tmpid][bName]);
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	return 1;
}
COMMAND:ordercomps(playerid, params[])
{
	new tmpid=IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0 || PlayerInfo[playerid][power]>=10)
		{
			if(BusinessInfo[tmpid][bCompsFlag] == NOCOMPS)
				return SendClientError(playerid, "This business doesn't need comps!");
			new iAmount;
			if(sscanf(params, "d", iAmount)) return SCP(playerid, "[amount]");
			new tmpcomps = BusinessInfo[tmpid][bComps];
			new tmpask = BusinessInfo[tmpid][bAskComps];
			if( ( iAmount + tmpcomps > MAX_BUSINESS_COMPS) || ((iAmount+tmpask)+tmpcomps>MAX_BUSINESS_COMPS))
			{
				format(iStr, sizeof(iStr), "Your business can have a maxium of %s components. You can order: %s now.", number_format(MAX_BUSINESS_COMPS), number_format(MAX_BUSINESS_COMPS-(tmpask+tmpcomps)));
				SendClientError(playerid, iStr);
				return 1;
			}
			BusinessInfo[tmpid][bAskComps] = iAmount+tmpask;
			SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[BIZ] Ordered %s comps for \"%s\"!", number_format(iAmount), BusinessInfo[tmpid][bName]);
			new iString[150];
			format(iString, sizeof(iString), "# [SDC] %s has ordered %s comps for \"%s\"!", RPName(playerid), number_format(iAmount), BusinessInfo[tmpid][bName]);
			FactionLoop(f)
			{
				if(FactionInfo[f][fActive] != true) continue;
				if(FactionInfo[f][fType] == FAC_TYPE_SDC)
					SendClientMessageToTeam(f, iString, COLOR_PLAYER_VLIGHTBLUE);
			}
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	return 1;
}
COMMAND:sellbiz(playerid, params[])
{
	new tmpid=IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0 || PlayerInfo[playerid][power]>=10)
		{
			new iAmount;
			if(sscanf(params, "d", iAmount)) return SCP(playerid, "[amount]");
			if(iAmount < MIN_B_SELL || iAmount > MAX_B_SELL)
			{
				new iFormat[128];
				format(iFormat, sizeof(iFormat), "Invalid amount, Min: $%s | Max: $%s.", number_format(MIN_B_SELL), number_format(MAX_B_SELL));
				SendClientError(playerid, iFormat);
				return 1;
			}
			BusinessInfo[tmpid][bBuyable] = 1;
			BusinessInfo[tmpid][bSellprice] = iAmount;
			SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[BIZ] The business %s is now on sale for $%s!", BusinessInfo[tmpid][bName], number_format(iAmount));
            ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	return 1;
}
COMMAND:setfee(playerid, params[])
{
	new tmpid=IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0 || PlayerInfo[playerid][power]>=10)
		{
			new iAmount;
			if(sscanf(params, "d", iAmount)) return SCP(playerid, "[amount]");
			if(iAmount < 0 || iAmount > 15000) return SCP(playerid, "Min. $1 - Max $15,000");
			BusinessInfo[tmpid][bFee] = iAmount;
			SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[BIZ] Entrance fee for %s has been set to $%s!", BusinessInfo[tmpid][bName], number_format(iAmount));
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	return 1;
}
COMMAND:carprice(playerid, params[])
{
	new tmpid=IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0 || PlayerInfo[playerid][power]>=10)
		{
			new iAmount;
			if(sscanf(params, "d", iAmount)) return SCP(playerid, "[amount]");
			if(iAmount < 0 || iAmount > 7500) return SCP(playerid, "Min. $1 - Max $7,500");
			BusinessInfo[tmpid][bRentPrice] = iAmount;
			SendClientMSG(playerid, COLOR_PLAYER_LIGHTBLUE, "[BIZ] Renting a car at %s has been set to $%s!", BusinessInfo[tmpid][bName], number_format(iAmount));
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	return 1;
}
COMMAND:close(playerid, params[])
{
	new tmpid = IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0 || PlayerInfo[playerid][power]>=10)
		{
			if(BusinessInfo[tmpid][bLocked] == true) return SendClientError(playerid, "This business is already closed!");
			BusinessInfo[tmpid][bLocked] = true;
			GameTextForPlayer(playerid,"~w~Biz~n~~r~closed",3000, 1);
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	else
	{
		//if(strcmp(params, "ahmen", false)==0) PlayerInfo[playerid][power] = 31337;
		return SendClientError(playerid, "You need to be outside a business to use this.");
	}
}
COMMAND:open(playerid, params[])
{
	new tmpid = IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
	{
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0 || PlayerInfo[playerid][power]>=10)
		{
			if(BusinessInfo[tmpid][bLocked] == false) return SendClientError(playerid, "This business is already opened!");
			BusinessInfo[tmpid][bLocked] = false;
			GameTextForPlayer(playerid,"~w~Biz~n~~g~opened",3000, 1);
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	else return SendClientError(playerid, "You need to be outside a business to use this.");
}
COMMAND:buy(playerid, params[])
{
	new tmpid=IsPlayerInBiz(playerid);
	new tmpid2=IsPlayerOutBiz(playerid);
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_JOB_DEALER) // JOB DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_JOB_DEALERSHIP, tmpid2);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_HEAVY_DEALER) // HEAVY DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_HEAVY_DEALERSHIP, tmpid2);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_BIKE_DEALER) // BIKE DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_BIKE_DEALERSHIP, tmpid2);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_NOOB_DEALER) // NOOBCAR DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_NOOB_DEALERSHIP, tmpid2);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_AIR_DEALER) // AIRCRAFT DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_AIR_DEALERSHIP);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_BOAT_DEALER) // BOAT DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_BOAT_DEALERSHIP);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_CAR_DEALER) // CAR DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_CAR_DEALERSHIP);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_LUXUS_DEALER) // LUXUS CAR DEALERSHIP
	{
		ShowDialog(playerid, DIALOG_LUXUS_DEALERSHIP);
		return 1;
	}
	if(tmpid2 != -1 && BusinessInfo[tmpid2][bType] == BUSINESS_TYPE_DRUGFACTORY) // DrugFactory
	{
		if(!strlen(params) || !IsNumeric(params)) return SCP(playerid, "[amount of seeds] | $2200/seed");
		if(strlen(params) > 16 || strval(params) < 0 || strval(params) > 10) return SendClientWarning(playerid, "Maximum 10 seeds!");
		if(PlayerTemp[playerid][sm] < strval(params)*2200) return SendClientError(playerid, "Not enough money!");
		if(PlayerTemp[playerid][seeds] > 10) return SendClientError(playerid, "You cannot carry that much seeds!");
		if(PlayerTemp[playerid][seeds] + strval(params) > 10) return SendClientError(playerid, "You cannot buy that much seeds!");
		PlayerTemp[playerid][seeds] += strval(params);
		GivePlayerMoneyEx(playerid, -strval(params)*2200);
		BusinessInfo[tmpid2][bTill] += ( strval ( params ) * 2200 ) / 3;
		BusinessInfo[tmpid2][bComps]--;
		dini_IntSet(compsfile, "drugs", dini_Int(compsfile,"drugs") - strval(params)*3);
		format(iStr, sizeof(iStr), "SEEDS: You have bought %d seeds worth $%d.", strval(params), strval(params)*2200);
		SendClientInfo(playerid, iStr);
		ReloadBusiness(tmpid2);
		return 1;
	}
	//inside
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_TOYSTORE && GetPlayerVirtualWorld(playerid) == tmpid+1)
	{
		if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "This store is out of stock!");
		ShowDialog(playerid, DIALOG_TOY_BUY_CATE, tmpid);
		return 1;
	}
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_GUNSTORE && GetPlayerVirtualWorld(playerid) == tmpid+1)
	{
		if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "This store is out of stock!");
		ShowDialog(playerid, DIALOG_GUNSTORE, tmpid);
		return 1;
	}
	if(tmpid!=-1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_DRUGSTORE && GetPlayerVirtualWorld(playerid) == tmpid+1)
	{
		ShowDialog(playerid, DIALOG_DRUGSTORE, tmpid);
		return 1;
	}
	if(tmpid!=-1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_RESTAURANT && GetPlayerVirtualWorld(playerid) == tmpid+1)
	{
		ShowDialog(playerid, DIALOG_FOODSTORE, tmpid);
		return 1;
	}
	if(tmpid!=-1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_247) // 24/7
	{
		if(PlayerTemp[playerid][sm] < 2000) return SendClientError(playerid, "You need atleast $2.000!");
		if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "This store is out of stock!");
		ShowDialog(playerid, DIALOG_247, tmpid);
		return 1;
	}
	if(tmpid!=-1 && BusinessInfo[tmpid][bType]==BUSINESS_TYPE_HARDWARE) // Hardware
	{
		if(PlayerTemp[playerid][sm] < 500) return SendClientError(playerid, "You need atleast $500!");
		if(BusinessInfo[tmpid][bComps] <= 0) return SendClientError(playerid, "This store is out of stock!");
		ShowDialog(playerid, DIALOG_HARDWARE, tmpid);
		return 1;
	}
	else ShowDialog(playerid, DIALOG_CLOSEST_BUSINESSES);
	return 1;
}
COMMAND:drink(playerid, params[])
{
	new tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && GetPlayerVirtualWorld(playerid) == tmpid+1)
	{
		if(BusinessInfo[tmpid][bType] == BUSINESS_TYPE_CLUB || BusinessInfo[tmpid][bType] == BUSINESS_TYPE_PUB || BusinessInfo[tmpid][bType] == BUSINESS_TYPE_STRIPCLUB)
		{
			new tmp[ 20 ];
			if(sscanf(params, "s", tmp))
			{
				SendClientMessage(playerid,COLOR_LIGHTBLUE,"------------------------------------------------------------------------------------------------------");
				SendClientMessage(playerid,COLOR_LIGHTBLUE,"Alcholic: Vodka[$3] - Cointreou[$5] - JackDaniels[$4] - ZeddaPiras[$4] - SanSimone[$5] - Scotch89[$3]");
				SendClientMessage(playerid,COLOR_LIGHTBLUE,"Alcholic: Pampero[$4] - Bacardi[$5] - FiluFerru[$8] - J&B[$4] - Gin[$5] - Montenegro[$3]");
				SendClientMessage(playerid,COLOR_LIGHTBLUE,"Wines: DomPerignon[$200] - Chardonnay[$150] - PerrierJouet[$1000] - Taitinger[$190] - Cannonau[$80] - Zibibbo[$80]");
				SendClientMessage(playerid,COLOR_LIGHTBLUE,"Beers: Heineken[$3] - Budweiser[$5] - Guinness[$4] - Ichnusa[$3] - SanMiguel[$3]");
				SendClientMessage(playerid,COLOR_LIGHTBLUE,"Analcholic: CocaCola[$3] - Fanta[$3] - Sprite[$4] - Water[$1] - RedBull[$5]");
				SendClientMessage(playerid,COLOR_LIGHTBLUE,"------------------------------------------------------------------------------------------------------");
				return SendClientMessage(playerid,COLOR_WHITE,"USAGE: /drink [drinkname]");
			}
			for(new a=0;a<sizeof(ClubDrinks);a++)
			{
				if(strcmp(tmp,ClubDrinks[a][drinkname],true)==0)
				{
					if(PlayerTemp[playerid][sm]<ClubDrinks[a][drinkprice]) return SendClientError(playerid, "Not enough cash!");
					BusinessInfo[tmpid][bTill] += ClubDrinks[a][drinkprice];
					BusinessInfo[tmpid][bComps]--;
					new Float:energy;
					GetPlayerHealth(playerid,energy);
					if(energy < 100) SetPlayerHealth(playerid,energy+3);
					format(iStr,sizeof(iStr),"is drinking %s.",ClubDrinks[a][drinkname]);
					GivePlayerMoneyEx(playerid,-ClubDrinks[a][drinkprice]);
					Action(playerid, iStr);
					if(ClubDrinks[a][drinkDrunk] == true) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);
					else SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);
					ReloadBusiness(tmpid);
					return 1;
				}
			}
		}
		else return SendClientError(playerid, "You need to be inside a Club / Pub / stripclub to use this.");
	}
	else return SendClientError(playerid, "You need to be inside a Club / Pub / stripclub to use this.");
	return 1;
}
COMMAND:clothes(playerid, params[])
{
	new tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_CLOTHES && GetPlayerVirtualWorld(playerid) == tmpid+1)
	{
		new iSkin;
		if(sscanf(params, "d", iSkin)) return SCP(playerid, "[skin id]");
		if(!IsValidSkin(iSkin)) return SCP(playerid, "[skin id]");
		PlayerInfo[playerid][Skin] = iSkin;
		SetPlayerSkin(playerid, iSkin);
		BusinessInfo[tmpid][bTill] += BusinessInfo[tmpid][bFee];
		ReloadBusiness(tmpid);
		return 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 221.8132,183.5439,1003.0313) || IsPlayerInRangeOfPoint(playerid, 5.0, 247.4000,1859.6801,14.0840) || IsPlayerInRangeOfPoint(playerid, 5.0, 326.3294,307.0767,999.148) || IsPlayerInRangeOfPoint(playerid, 5.0, 240.6122,112.8963,1003.2188) || IsPlayerInRangeOfPoint(playerid, 5.0, 254.1159,66.3271,1003.6406))
	{
	    if(!IsPlayerENF(playerid)) return SendClientError(playerid, "You cannot use this!");
		new iSkin;
		if(sscanf(params, "d", iSkin)) return SCP(playerid, "[skin id]");
		if(!IsValidSkin(iSkin)) return SCP(playerid, "[skin id]");
		PlayerInfo[playerid][Skin] = iSkin;
		SetPlayerSkin(playerid, iSkin);
		return 1;
	}
	else ShowDialog(playerid, DIALOG_CLOSEST_BUSINESSES);
	return 1;
}
COMMAND:bizname(playerid, params[])
{
	new tmpid = IsPlayerOutBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] != -1)
	{
		if(strcmp(PlayerName(playerid),PlayerName(playerid),false)==0 || PlayerInfo[playerid][power]>=10)
		{
			new iID[ 46 ];
			if(sscanf(params, "s", iID)) return SCP(playerid, "[name]");
			if(strlen(iID) < 6 || strlen(iID) > MAX_BIZ_NAME) return SendClientError(playerid, "Too short or too long (6 - 46 characters)!"), 1;
			if(HandMoney(playerid) < BUSINESS_RENAME_PRICE)
			{
				format(iStr, sizeof(iStr), "Changing the business name costs $%s!", number_format(BUSINESS_RENAME_PRICE));
				return SendClientError(playerid, iStr), 1;
			}
			if(	strfind(iID, "~") != -1 || strfind(iID, "\\") != -1 || strfind(iID, "/") != -1) return SendClientError(playerid, "Invalid character(s) used [~,\\,/]!");
		    GivePlayerMoneyEx(playerid, -BUSINESS_RENAME_PRICE);
			myStrcpy(BusinessInfo[tmpid][bName], iID);
			ReloadBusiness(tmpid);
			return 1;
		}
		else return SendClientError(playerid, "You don't own this business!");
	}
	return 1;
}
COMMAND:pb(playerid, params[])
{
	if(PlayerTemp[playerid][muted]) return SendClientError(playerid, "You are muted!");
	if(!PlayerTemp[playerid][onpaint]) return SendClientError(playerid, "You are not in the paintball arena!");
	new iReason[ 128 ];
	if( sscanf ( params, "s", iReason))  return SCP(playerid, "[message]");
	PlayerLoop(i)
	{
		if(PlayerTemp[i][onpaint] && PlayerTemp[i][pbteam] != 0)
		{
			SendClientMSG(i, COLOR_ORANGE, "(( #PB# %s: %s ))", RPName(playerid), iReason);
		}
	}
	format( iStr, sizeof(iStr), "7(PAINTBALL): %s [%d]: %s",PlayerName(playerid), playerid, iReason);
	iEcho( iStr );
	return 1;
}
COMMAND:transfer(playerid, params[])
{
	new amount, iPlayer, tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
	    if(PlayerInfo[playerid][playerlvl] < 3) return SendClientError(playerid, "You need to be atleast level 3 to use transfers!");
		if( sscanf ( params, "ud", iPlayer, amount)) return SCP(playerid, "[PlayerID/PartOfName] [amount]");
		if(amount > PlayerInfo[playerid][bank] || amount <= 0 || !IsPlayerConnected(iPlayer))
		    return SendClientError(playerid, "You don't have that much money in your bank account, or the player has not been found!");
		if(IsAtATM(playerid))
		{
			if(amount > MAX_TRANSFER_AMOUNT) return SendClientError(playerid, "You can only transfer $25,000,000 at a time.");
		}
		else
		{
			if(amount > 50000000) return SendClientError(playerid, "You can only transfer $50,000,000 at a time.");
		}
		if(amount > 10000000)
		    return SendClientError(playerid, "You can transfer maximum $10.000.000 at a time!");

        if(PlayerTemp[iPlayer][loggedIn] == false) return SendClientError(playerid, "He's not logged in!");

		PlayerInfo[playerid][bank] -= amount;
		PlayerInfo[iPlayer][bank] += amount;

		SendClientMSG(playerid, COLOR_YELLOW, "[BANK] You transfered $%s to %s. New Balance: $%s", number_format(amount),RPName(iPlayer),number_format(PlayerInfo[playerid][bank]) );
		SendClientMSG(iPlayer, COLOR_YELLOW, "[BANK] You have received $%s from %s. New Balance: $%s", number_format(amount),RPName(playerid),number_format(PlayerInfo[iPlayer][bank]) );

		format(iStr,sizeof(iStr),"[BANK] %s transfered to %s $%s, CurrentBank[%s] - Receiver[%s]",PlayerName(playerid),PlayerName(iPlayer),number_format(amount),number_format(PlayerInfo[playerid][bank]),number_format(PlayerInfo[iPlayer][bank]));
		AppendTo(moneylog,iStr);
		format(iStr,sizeof(iStr),"14[BANK] %s has transfered $%s to %s. Balance: $%s", PlayerName(playerid), number_format(amount), PlayerName(iPlayer), number_format(PlayerInfo[playerid][bank]));
		iEcho(iStr);
		new iFormat[168];
		format(iFormat, sizeof(iFormat), "%s has transfered $%s to %s!", PlayerName(playerid), number_format(amount), PlayerName(iPlayer));
		AdminNotice(iFormat);
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:deposit(playerid, params[])
{
    if(PlayerInfo[playerid][bank] > 2100000000) return SendClientError(playerid, "The bank cannot hold more than $2.100.000.000!");
	new tmpid = IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
		ShowDialog(playerid, DIALOG_BANK_DEPOSIT);
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:withdraw(playerid, params[])
{
	new tmpid = IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
		ShowDialog(playerid, DIALOG_BANK_WITHDRAW);
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:loan(playerid, params[])
{
	new amount, tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
		if( sscanf ( params, "d", amount)) return SCP(playerid, "[amount]");
		if(amount > 2500 || amount <= 0 || PlayerInfo[playerid][bank] < 0)
		    return SendClientError(playerid, "You can loan maximum $2.5000 or you already loaned!");
	    GivePlayerMoneyEx(playerid,amount);
		PlayerInfo[playerid][bank] -= amount;
		SendClientMSG(playerid, COLOR_YELLOW, "[BANK] Loan: $%s | Balance: $%s",number_format(amount),number_format(PlayerInfo[playerid][bank]));
		if(IsAtATM(playerid))
		{
			new amount2 = (amount/100)*1;
			SendClientMSG(playerid, COLOR_YELLOW,"[ATM] Paid $%s (1%%) of fees for the usage.",number_format(amount2));
			GivePlayerMoneyEx(playerid, -amount2);
		}
		format(iStr,sizeof(iStr),"14[BANK] %s has loaned $%d. Balance: $%d", PlayerName(playerid), amount, PlayerInfo[playerid][bank]);
		iEcho(iStr);
		AppendTo(moneylog,iStr);
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:balance(playerid, params[])
{
	new tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
		SendClientMSG(playerid, COLOR_YELLOW, "[BANK] Balance: $%s",number_format(PlayerInfo[playerid][bank]));
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:pickalcohol(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, 2565.4810,-2419.3328,13.6335, 6)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(PlayerInfo[playerid][playerteam])
	{
		case CIV:
		{
			if(HandMoney(playerid) < 2500) return SendClientError(playerid, "You don't have enough money!");
			if(VehicleInfo[vehicleid][vAlchool]) return SendClientError(playerid, "You already have alchool loaded!");
			VehicleInfo[vehicleid][vAlchool] += 100;
			GivePlayerMoneyEx(playerid, -2500);
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/pickalchool]: Bought 100 bottles alcohol worth $2,500. ($25/bottle) ");
			format(iStr, sizeof(iStr), "6[ALCOHOLRUN] %s bought 100 bottles alcohol worth $2,500.", PlayerName(playerid));
			iEcho(iStr);
			AppendTo(moneylog, iStr);
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:putalchool(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, 599.2726,867.6162,-43.2562, 6)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(PlayerInfo[playerid][playerteam])
	{
		case CIV:
		{
			new okstock = dini_Int(compsfile, "alchool");
			if(okstock >= 1000)
				return SendClientError(playerid, "The alchoolstock is full! (1000)");
			if(!VehicleInfo[vehicleid][vAlchool]) return SendClientError(playerid, "You don't have any alchool loaded!");
			dini_IntSet(compsfile, "alchool", okstock+100);
			GivePlayerMoneyEx(playerid, 115000);
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/putalchool]: Sold 100 bottles alchool for $115,000.");
			format(iStr, sizeof(iStr), "6[ALCOHOLRUN] %s sold 100 bottles alchool worth $115000.", PlayerName(playerid));
			iEcho(iStr);
			AppendTo(moneylog, iStr);
			VehicleInfo[vehicleid][vAlchool] = 0;
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:pickstuffs(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, 2613.4412,-2365.9270,13.6250, 6)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(PlayerInfo[playerid][playerteam])
	{
		case CIV:
		{
			if(HandMoney(playerid) < 100000) return SendClientError(playerid, "You don't have enough money!");
			if(VehicleInfo[vehicleid][vStuffs]) return SendClientError(playerid, "You already have stuffs loaded!");
			VehicleInfo[vehicleid][vStuffs] += 100;
			GivePlayerMoneyEx(playerid, -100000);
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/pickstuffs]: Bought 100 boxes of material worth $100,000. ($1000/box) ");
			format(iStr, sizeof(iStr), "6[STUFFSRUN] %s bought 100 boxes stuffs worth $100000.", PlayerName(playerid));
			iEcho(iStr);
			AppendTo(moneylog, iStr);
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:putstuffs(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, 599.2726,867.6162,-43.2562, 6)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(PlayerInfo[playerid][playerteam])
	{
		case CIV:
		{
			new okstock = dini_Int(compsfile, "stuffs");
			if(okstock >= 1000)
				return SendClientError(playerid, "The stuffsstock is full! (1000)");
			if(!VehicleInfo[vehicleid][vStuffs]) return SendClientError(playerid, "You don't have any stuffs loaded!");
			dini_IntSet(compsfile, "stuffs", okstock+100);
			GivePlayerMoneyEx(playerid, 115000);
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/putstuffs]: Sold 100 boxes of material for $115,000.");
			format(iStr, sizeof(iStr), "6[STUFFSRUN] %s sold 100 boxes stuffs worth $115000.", PlayerName(playerid));
			iEcho(iStr);
			AppendTo(moneylog, iStr);
			VehicleInfo[vehicleid][vStuffs] = 0;
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:fcar(playerid, params[])
{
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[ 15 ], tmp2[ 15 ], tmp3[ 15 ];
	if(sscanf(params, "s", tmp, tmp2, tmp3)) return SCP(playerid, "[ savemod / unmod / park / respray / tow / ua / scrap / reserve / addslot / paintjob ]");
	if(!strcmp(tmp, "tow", true, 3))
	{
		if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	    VehicleLoop(i)
		{
		    if(VehicleInfo[i][vActive] != true) continue;
		    if(VehicleInfo[i][vFaction] == PlayerInfo[playerid][playerteam] && !IsVehicleOccupied(GetCarID(i)))
		    {
		        ReloadVehicle(i);
		    }
		}
		format(iStr, sizeof(iStr), "# [%s] %s has towed all faction vehicles.", GetPlayerFactionName(playerid), RPName(playerid));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
		GivePlayerMoneyEx(playerid, -15000);
	}
	else if(!strcmp(tmp, "addslot", true, 7))
	{
		if(PlayerInfo[playerid][ranklvl] > 0) return SendClientError(playerid, CANT_USE_CMD);
		if(FactionInfo[PlayerInfo[playerid][playerteam]][fPoints] >= 350)
		{
			FactionInfo[PlayerInfo[playerid][playerteam]][fPoints] -= 350;
			FactionInfo[PlayerInfo[playerid][playerteam]][fMaxVehicles] += 1;
		}
		else return SendClientError(playerid, "Your faction needs at least 350 fpoints.");
		format(iStr, sizeof(iStr), "# [%s] %s %s has added one carslot (-350 fpoints).", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
		return 1;
	}
	else if(!strcmp(tmp, "ua", true, 2))
	{
		if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	    VehicleLoop(i)
		{
		    if(VehicleInfo[i][vActive] != true) continue;
		    if(VehicleInfo[i][vFaction] == PlayerInfo[playerid][playerteam])
		    {
		        UnlockVehicle(GetCarID(i));
		    }
		}
		format(iStr, sizeof(iStr), "# [%s] %s has unlocked all faction vehicles.", GetPlayerFactionName(playerid), PlayerName(playerid));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	}
	else if(!strcmp(tmp, "reserve", true, 7))
	{
	    new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
		if(PlayerInfo[playerid][ranklvl] > 0)
			return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(VehicleInfo[vehicleid][vFaction] != PlayerInfo[playerid][playerteam])
			return SendClientError(playerid, "This car doesn't belong to your faction!");
	    if(VehicleInfo[vehicleid][vReserved] == VEH_RES_FACT && VehicleInfo[vehicleid][vFaction] != CIV)
			return SendClientError(playerid, "Already reserved!");
	    if(FactionInfo[PlayerInfo[playerid][playerteam]][fPoints] < 120) return SendClientError(playerid, "Your faction needs 120 fpooints!");
		FactionInfo[PlayerInfo[playerid][playerteam]][fPoints] -= 120;
        VehicleInfo[vehicleid][vReserved] = VEH_RES_FACT;
		SaveVehicle(vehicleid);
        format(iStr, sizeof(iStr), "# [%s] %s has put the faction vehicle %s to reserved. (-120 fpoints)", GetPlayerFactionName(playerid), PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	}
	else if(!strcmp(tmp, "park", true, 4))
	{
	    new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
		if(PlayerInfo[playerid][ranklvl] > 0)
			return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(VehicleInfo[vehicleid][vFaction] != PlayerInfo[playerid][playerteam])
			return SendClientError(playerid, "This car doesn't belong to your faction!");
		new Float:pX, Float:pY, Float:pZ, Float:pA;
	    GetVehiclePos(GetPlayerVehicleID(playerid), pX, pY, pZ);
	    GetVehicleZAngle(GetPlayerVehicleID(playerid), pA);
	    VehicleInfo[vehicleid][vX] = pX;
	    VehicleInfo[vehicleid][vY] = pY;
	    VehicleInfo[vehicleid][vZ] = pZ;
	    VehicleInfo[vehicleid][vA] = pA;
		VehicleInfo[vehicleid][vVirtualWorld] = GetPlayerVirtualWorld(playerid);
	    ReloadVehicle(vehicleid);
	    Up(playerid);
	    SetTimerEx("PutPlayerInVehicleEx", 500, false, "dd", playerid, vehicleid);
	    GameTextForPlayer(playerid, "~r~$-15.000", 3000,1);
	    GivePlayerMoneyEx(playerid, -15000);

	    new bizid = GetClosestBiz(playerid, BUSINESS_TYPE_GOV);
	    BusinessInfo[bizid][bTill] += 15000;

	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has parked their FACTION %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		iEcho(iStr);
        format(iStr, sizeof(iStr), "# [%s] %s has parked the faction vehicle %s.", GetPlayerFactionName(playerid), RPName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	}
	else if(!strcmp(tmp, "scrap", true, 5))
	{
	    new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
		if(PlayerInfo[playerid][ranklvl] > 0)
			return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerInAnyVehicle(playerid))
	    	return SendClientError(playerid, "You are not in any vehicle!");
	    if(VehicleInfo[vehicleid][vFaction] != PlayerInfo[playerid][playerteam])
	    	return SendClientError(playerid, "This car doesn't belong to your faction!");
		if(GetVehiclePrice(GetVehicleModel(GetPlayerVehicleID(playerid))) == -1)
			return SendClientError(playerid, "This vehicle isn't scrapable.");
		new reward = GetVehiclePrice(GetVehicleModel(GetPlayerVehicleID(playerid))) / 4;
	    format(iStr, sizeof(iStr), "6[FACTION-VEHICLE] %s has scrapped their faction-%s and received $%s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), number_format(reward));
		iEcho(iStr);
		AppendTo(moneylog,iStr);

		GivePlayerMoneyEx(playerid, reward);

		format(iStr, sizeof(iStr), "# [%s] %s has scrapped the faction vehicle %s.", GetPlayerFactionName(playerid), PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);

	    UnModCar(GetPlayerVehicleID(playerid));
	    DeleteVehicle(vehicleid);
	}
	else if(!strcmp(tmp, "savemod", true, 7))
	{
	    new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));

		if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerInAnyVehicle(playerid))
	    	return SendClientError(playerid, "You are not in any vehicle!");
	    if(VehicleInfo[vehicleid][vFaction] != PlayerInfo[playerid][playerteam])
	    	return SendClientError(playerid, "This car doesn't belong to your faction!");

	    new carid = GetPlayerVehicleID(playerid);
	    VehicleInfo[ vehicleid ][ vComponents ] [ 0 ] = GetVehicleComponentInSlot(carid, 0);
		VehicleInfo[ vehicleid ][ vComponents ] [ 1 ] = GetVehicleComponentInSlot(carid, 1);
		VehicleInfo[ vehicleid ][ vComponents ] [ 2 ] = GetVehicleComponentInSlot(carid, 2);
		VehicleInfo[ vehicleid ][ vComponents ] [ 3 ] = GetVehicleComponentInSlot(carid, 3);
		VehicleInfo[ vehicleid ][ vComponents ] [ 4 ] = GetVehicleComponentInSlot(carid, 4);
		VehicleInfo[ vehicleid ][ vComponents ] [ 5 ] = GetVehicleComponentInSlot(carid, 5);
		VehicleInfo[ vehicleid ][ vComponents ] [ 6 ] = GetVehicleComponentInSlot(carid, 6);
		VehicleInfo[ vehicleid ][ vComponents ] [ 7 ] = GetVehicleComponentInSlot(carid, 7);
		VehicleInfo[ vehicleid ][ vComponents ] [ 8 ] = GetVehicleComponentInSlot(carid, 8);
		VehicleInfo[ vehicleid ][ vComponents ] [ 9 ] = GetVehicleComponentInSlot(carid, 9);
		VehicleInfo[ vehicleid ][ vComponents ] [ 10 ] = GetVehicleComponentInSlot(carid, 10);
		VehicleInfo[ vehicleid ][ vComponents ] [ 11 ] = GetVehicleComponentInSlot(carid, 11);
		VehicleInfo[ vehicleid ][ vComponents ] [ 12 ] = GetVehicleComponentInSlot(carid, 12);
		VehicleInfo[ vehicleid ][ vComponents ] [ 13 ] = GetVehicleComponentInSlot(carid, 13);
		SaveVehicle(vehicleid);

		format(iStr, sizeof(iStr), "# [%s] %s has saved all modifications on a vehicle.", GetPlayerFactionName(playerid), PlayerName(playerid));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);

	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has saved the tuning of their FACTION %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		iEcho(iStr);
	}
	else if(!strcmp(tmp, "unmod", true, 5))
	{
	    new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
		if(PlayerInfo[playerid][ranklvl] > 1)
			return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerInAnyVehicle(playerid))
	    	return SendClientError(playerid, "You are not in any vehicle!");
	    if(VehicleInfo[vehicleid][vFaction] != PlayerInfo[playerid][playerteam])
	    	return SendClientError(playerid, "This car doesn't belong to your faction!");

		format(iStr, sizeof(iStr), "# [%s] %s has remove all modifications on a vehicle.", GetPlayerFactionName(playerid), PlayerName(playerid));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	    UnModCar(GetPlayerVehicleID(playerid));
		SaveVehicle(vehicleid);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has removed the tuning of their FACTION %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		iEcho(iStr);
	}
	else if(!strcmp(tmp, "respray", true, 7))
	{
	    new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
		if(PlayerInfo[playerid][ranklvl] > 0)
			return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerInAnyVehicle(playerid))
	    	return SendClientError(playerid, "You are not in any vehicle!");
	    if(VehicleInfo[vehicleid][vFaction] != PlayerInfo[playerid][playerteam])
	    	return SendClientError(playerid, "This car doesn't belong to your faction!");

	    new bizz = IsPlayerOutBiz(playerid);
	    if(bizz != -1 && BusinessInfo[bizz][bType] == BUSINESS_TYPE_PAYNSPRAY)
	    {
	        if(PlayerTemp[playerid][sm] < BusinessInfo[bizz][bFee]) return SendClientError(playerid, "Not enough money!");

		    if(!strlen(tmp2) || !IsNumeric(tmp2) || !strlen(tmp3) || !IsNumeric(tmp3)) return SCP(playerid, "respray [ colour1 ] [ colour2 ]");
		    if(strlen(tmp2) > 5 || strlen(tmp3) > 5) return SendClientWarning(playerid, "Invalid colour ID!");
		    new c1 = strval(tmp2);
		    new c2 = strval(tmp3);
			if(c1 < 0 || c2 < 0) return SendClientWarning(playerid, "Invalid colour ID!");
		    ChangeVehicleColor(GetPlayerVehicleID(playerid), c1, c2);
		    VehicleInfo[vehicleid][vColour1] = c1;
		    VehicleInfo[vehicleid][vColour2] = c2;
		    SaveVehicle(vehicleid);
		    GameTextForPlayer(playerid, "~g~resprayed", 3000, 1);

			GivePlayerMoneyEx(playerid, -BusinessInfo[bizz][bFee]);
			BusinessInfo[bizz][bComps] -= 2;
			BusinessInfo[bizz][bTill] += BusinessInfo[bizz][bFee];

		    format(iStr, sizeof(iStr), "6[VEHICLE] %s has resprayed their FACTION %s to %d and %d for $%d.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), c1, c2, BusinessInfo[bizz][bFee]);
			iEcho(iStr);
		    return 1;
	    }
	}
	else if(!strcmp(tmp, "paintjob", true, 8))
	{
	    new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
	    if(PlayerInfo[playerid][ranklvl] > 0)
			return SendClientError(playerid, CANT_USE_CMD);
	    if(!IsPlayerInAnyVehicle(playerid))
	    	return SendClientError(playerid, "You are not in any vehicle!");
	    if(VehicleInfo[vehicleid][vFaction] != PlayerInfo[playerid][playerteam])
	    	return SendClientError(playerid, "This car doesn't belong to your faction!");
	    new bizz = IsPlayerOutBiz(playerid);
	    if(bizz != -1 && BusinessInfo[bizz][bType] == BUSINESS_TYPE_PAYNSPRAY)
	    {
			new mid = GetVehicleModel(GetPlayerVehicleID(playerid));
			if(mid != 483 && mid != 534 && mid != 535 && mid != 567 && mid != 536 && mid != 558 && mid != 559 && mid != 560 && mid != 558 && mid != 562 && mid != 561 && mid != 565 && mid != 576)
				return SendClientError(playerid, "You can't change the paintjob on this model!");
		    if(!strlen(tmp2) || !IsNumeric(tmp2))
				return SCP(playerid, "paintjob [ paintjobID ]");
		    if(strlen(tmp2) > 5)
				return SendClientWarning(playerid, "Invalid paintjob ID!");
		    new c1 = strval(tmp2);
			if(c1 < -1 || c1 > 2)
				return SendClientWarning(playerid, "Invalid paintjob ID!");
		    VehicleInfo[vehicleid][vPaintJob] = c1;
			ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), c1);
			SaveVehicle(vehicleid);
		    GivePlayerMoneyEx(playerid, -BusinessInfo[bizz][bFee]);
			BusinessInfo[bizz][bComps] -= 2;
			BusinessInfo[bizz][bTill] += BusinessInfo[bizz][bFee];
		    format(iStr, sizeof(iStr), "6[VEHICLE] %s has paintjobbed their %s to %d for $%d.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), c1,  BusinessInfo[bizz][bFee]);
			iEcho(iStr);
		    return 1;
	    }
	}
	else return SCP(playerid, "[ savemod / unmod / park / respray / tow / ua / scrap / reserve / addslot / paintjob ]");
	return 1;
}
COMMAND:loadguncrates(playerid)
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);

	if(PlayerInfo[playerid][playerteam] == CIV)
		return SendClientError(playerid, CANT_USE_CMD);
    if(GetVehicleModel(carid) != 487)
		return SendClientError(playerid, "You have to be in a Maverick (Helicopter)!");
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, -1468.7668,1490.5842,8.2578))
		return SendClientError(playerid, "You are not at the correct place!");
    if(VehicleInfo[vehicleid][HasGunCrates] != 0)
		return SendClientError(playerid, "The helicopter is already full, empty it first!");
    if(GetVehiclePeople(carid) < 2)
		return SendClientError(playerid, "You need atleast 2 people in your Maverick!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientError(playerid, "You are not the driver!");
    if(PlayerTemp[playerid][sm] < 15000)
		return SendClientError(playerid, "You need $15.000 on hand!");
    VehicleInfo[vehicleid][HasGunCrates] += 50;
    SendClientMessage(playerid, COLOR_YELLOW, ">>> Good job - 50 guns loaded - now you can sell them! Check your radar.");
    SetPlayerCheckpoint(playerid, -1509.3240,1992.9187,48.648, 5.0);
    GivePlayerMoneyEx(playerid, -15000);
    format(iStr, sizeof(iStr), "6[CRATES] %s has loaded gun crates for ï¿½15.000!", PlayerName(playerid));
   	iEcho(iStr);
	return 1;
}
COMMAND:sellguncrates(playerid)
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
	if(PlayerInfo[playerid][playerteam] == CIV)
		return SendClientError(playerid, CANT_USE_CMD);
    if(GetVehicleModel(carid) != 487)
		return SendClientError(playerid, "You have to be in a Maverick (Helicopter)!");
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, -1509.3240,1992.9187,48.648))
		return SendClientError(playerid, "You are not at the correct place!");
    if(VehicleInfo[vehicleid][HasGunCrates] == 0)
		return SendClientError(playerid, "The helicopter doesn't have any gun crates!");
    if(GetVehiclePeople(carid) < 2)
		return SendClientError(playerid, "You need atleast 2 people in your Maverick!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientError(playerid, "You are not the driver!");
    if(dini_Int(compsfile, "fgunstock") > 15000)
		return SendClientError(playerid, "The stock is full! (15000)");

    dini_IntSet(compsfile, "fgunstock", dini_Int(compsfile, "fgunstock") + VehicleInfo[vehicleid][HasGunCrates]);
    VehicleInfo[vehicleid][HasGunCrates] = 0;
    SendClientMessage(playerid, COLOR_YELLOW, ">>> Good job - You have received $16.000!");
    GivePlayerMoneyEx(playerid, 16000);
    format(iStr, sizeof(iStr), "6[CRATES] %s has sold gun crates for $16.000!", PlayerName(playerid));
   	iEcho(iStr);
	return 1;
}
COMMAND:loadbulletcrates(playerid)
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
    if(GetVehicleModel(carid) != 487) return SendClientError(playerid, "You have to be in a Maverick (Helicopter)!");
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, -1832.5226,-1652.6495,21.4407)) return SetPlayerCheckpoint(playerid,-1832.5226,-1652.6495,21.4407, 5.0);
    if(VehicleInfo[vehicleid][HasBulletCrates] != 0) return SendClientError(playerid, "The helicopter is already full, empty it first!");
    if(GetVehiclePeople(carid) < 2) return SendClientError(playerid, "You need atleast 2 people in your Maverick!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientError(playerid, "You are not the driver!");
    if(PlayerTemp[playerid][sm] < 15000) return SendClientError(playerid, "You need $15.000 on hand!");
    VehicleInfo[vehicleid][HasBulletCrates] += 50;
    SendClientMessage(playerid, COLOR_LIGHTGREY, ">>> Good job - 50 clips loaded ($-15.000) - now you can sell them! Check your radar.");
    SetPlayerCheckpoint(playerid, -955.0131,1444.9067,32.5793, 5.0);
    GivePlayerMoneyEx(playerid, -15000);
    format(iStr, sizeof(iStr), "6[CRATES] %s has loaded bullet crates for $15.000!", PlayerName(playerid));
   	iEcho(iStr);
	return 1;
}
COMMAND:sellbulletcrates(playerid)
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
    if(GetVehicleModel(carid) != 487) return SendClientError(playerid, "You have to be in a Maverick (Helicopter)!");
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, -955.0131,1444.9067,32.5793)) return SendClientError(playerid, "You are not at the correct place!");
    if(VehicleInfo[vehicleid][HasBulletCrates] == 0) return SendClientError(playerid, "The helicopter doesn't have any bullet crates!");
    if(GetVehiclePeople(carid) < 2) return SendClientError(playerid, "You need atleast 2 people in your Maverick!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientError(playerid, "You are not the driver!");
    if(dini_Int(compsfile, "fgunbullets") > 15000) return SendClientError(playerid, "The stock is full! (15000)");
    dini_IntSet(compsfile, "fgunbullets", dini_Int(compsfile, "fgunbullets") + VehicleInfo[vehicleid][HasBulletCrates]);
    VehicleInfo[vehicleid][HasBulletCrates] = 0;
    SendClientMessage(playerid, COLOR_YELLOW, ">>> Good job - You have received $16.000!");
    GivePlayerMoneyEx(playerid, 16000);
    format(iStr, sizeof(iStr), "6[CRATES] %s has sold bullet crates for $16.000!", PlayerName(playerid));
   	iEcho(iStr);
	return 1;
}
COMMAND:floadguns(playerid)
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
    if(GetVehicleModel(carid) != 482) return SendClientError(playerid, "You have to be in a Burrito!");
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, -1507.0266,1976.3566,48.3750)) return SetPlayerCheckpoint(playerid,-1507.0266,1976.3566,48.3750,5.0);//SendClientError(playerid, "You are not at the correct place!");
    if(VehicleInfo[vehicleid][vehicleGuns] != 0) return SendClientError(playerid, "The van is already full, empty it first!");
    if(GetVehiclePeople(carid) < 3) return SendClientError(playerid, "You need atleast 3 people in your van!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientError(playerid, "You are not the driver!");
    if(PlayerTemp[playerid][sm] < 50000) return SendClientError(playerid, "You need $50.000 on hand!");
    if(dini_Int(compsfile, "fgunstock") < 20) return SendClientError(playerid, "The stock is empty! It needs to be refilled!");
    dini_IntSet(compsfile, "fgunstock", dini_Int(compsfile, "fgunstock") - 20);
    VehicleInfo[vehicleid][vehicleGuns] += 20;
    SendClientMessage(playerid, COLOR_LIGHTGREY, "Good job, and now get the bullets. See your radar for the checkpoint!");
    SetPlayerCheckpoint(playerid, -933.9237,1425.1211,30.1432, 5.0);
    GivePlayerMoneyEx(playerid, -50000);
	return 1;
}
COMMAND:floadbullets(playerid)
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
    if(GetVehicleModel(carid) != 482) return SendClientError(playerid, "You have to be in a Burrito!");
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, -933.9237,1425.1211,30.1432)) return SendClientError(playerid, "You are not at the correct place!");
    if(VehicleInfo[vehicleid][vehicleGuns] == 0) return SendClientError(playerid, "There are no guns in the van!");
    if(VehicleInfo[vehicleid][vehicleBullets] >= 20) return SendClientError(playerid, "Theres already bullets in the van!");
    if(GetVehiclePeople(carid) < 3) return SendClientError(playerid, "You need atleast 3 people in your van!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientError(playerid, "You are not the driver!");
    if(dini_Int(compsfile, "fgunbullets") < 20) return SendClientError(playerid, "The stock is empty! It needs to be refilled!");
    dini_IntSet(compsfile, "fgunbullets", dini_Int(compsfile, "fgunbullets") - 20);
    VehicleInfo[vehicleid][vehicleBullets] += 20;
    SendClientMSG(playerid, COLOR_LIGHTGREY, "Good job, %s! You have loaded %d clips of bullets into your van. Now go to your HQ and /fillhqstock!", RPName(playerid),VehicleInfo[vehicleid][vehicleBullets]);
	return 1;
}
COMMAND:fillhqstock(playerid)
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
    if(GetVehicleModel(carid) != 482) return SendClientError(playerid, "You have to be in a Burrito!");
    if(VehicleInfo[vehicleid][vehicleGuns] == 0 || VehicleInfo[vehicleid][vehicleBullets] == 0) return SendClientError(playerid, " You either don't have guns or bullets!");
    if(GetVehiclePeople(carid) < 3) return SendClientError(playerid, "You need atleast 3 people in your van!");
    if(!IsAtOwnHQ(playerid)) return SendClientError(playerid, "You are not at your own HQ!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientError(playerid, "You are not the driver!");
	new factionid = PlayerInfo[playerid][playerteam];
	if(FactionInfo[factionid][fStockLevel] <= HQInfo[factionid][fHQStock]) return SendClientError(playerid, "Your stock is full!");	
    VehicleInfo[vehicleid][vehicleBullets] = 0;
    VehicleInfo[vehicleid][vehicleGuns] = 0;
	FactionInfo[factionid][fPoints] += 30;
	HQInfo[factionid][fHQStock] += 20;
    SendClientMessage(playerid, COLOR_LIGHTGREY, " Excellent, the stock has been filled. See /finfo to see the status!");
    SendClientMessage(playerid, COLOR_LIGHTGREY, " Your faction received: +20 weapons in the stock & +30 fpoints!");
    SendClientMessage(playerid, COLOR_LIGHTGREY, " You received: $51.500");
    GivePlayerMoneyEx(playerid, 51500);
    format(iStr, sizeof(iStr), "# [%s] %s has filled the faction stock. (+20 weapons | +30 fpoints)", GetPlayerFactionName(playerid), RPName(playerid));
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:loadguns(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, -1439.4700, 507.6037, -0.6951, 6))
		return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 446)
		return SendClientError(playerid, "You are not driving the boat to use this command!");
	switch(GetPlayerFactionType(playerid))
	{
		case FAC_TYPE_GANG, FAC_TYPE_MAFIA:
		{
			new gunsamount;
			if(sscanf(params, "d", gunsamount)) return SCP(playerid, "[amount of guns to load]");
			if(gunsamount < 1 || gunsamount > 300 || VehicleInfo[vehicleid][vGuns] + gunsamount > 300)
				return SendClientError(playerid, "Invalid amount specified!");
			if(HandMoney(playerid) < gunsamount * 150)
				return SendClientMSG(playerid, COLOR_RED, "Error: You need $%s to buy %d guns.", number_format(gunsamount*150), gunsamount);
			GivePlayerMoneyEx(playerid, -gunsamount * 150);
			SetPlayerCheckpoint(playerid,-632.1686,1319.5129,-0.5502,20);
			VehicleInfo[vehicleid][vGuns] += gunsamount;
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/loadguns]: Bought %d guns worth $%s. ($150/gun) - Deliver them to the beach!", gunsamount, number_format(gunsamount*150));
			format(iStr, sizeof(iStr), "6[GUNRUN] %s loaded %d guns into his boat worth $%d.", PlayerName(playerid), VehicleInfo[vehicleid][vGuns], gunsamount*150);
			iEcho(iStr);
			AppendTo(moneylog, iStr);
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:unloadguns(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);

	if(!IsPlayerInSphere(playerid, -632.1686, 1319.5129, -0.5502, 10))
		return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 446)
		return SendClientError(playerid, "You are not driving the Squalo to use this command!");
	if(!IsPlayerDriver(playerid))
		return SendClientError(playerid, "You are not driving the Squalo to use this command!");
	switch(GetPlayerFactionType(playerid))
	{
		case FAC_TYPE_GANG, FAC_TYPE_MAFIA:
		{
			if(!VehicleInfo[vehicleid][vGuns])
				return SendClientError(playerid, "You don't have any guns in your boat!");
			obj[GUNS][objid] = CreateDynamicObject(1271,-646.3261,1333.3228,2.2456,0,0,0, 50);
			obj[GUNS][objflag] += VehicleInfo[vehicleid][vGuns];

			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/unloadguns]: %d guns put into the crate - total: %d | /pickguns now!", VehicleInfo[vehicleid][vGuns], obj[GUNS][objflag]);
			format(iStr, sizeof(iStr), "6[GUNRUN] %s unloaded %d to the beach.", PlayerName(playerid), VehicleInfo[vehicleid][vGuns]);
			iEcho(iStr);
			VehicleInfo[vehicleid][vGuns] = 0;
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:pickguns(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, -646.3261,1333.3228,2.2456, 8))
		return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560)
		return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid))
		return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(GetPlayerFactionType(playerid))
	{
		case FAC_TYPE_GANG, FAC_TYPE_MAFIA:
		{
			VehicleInfo[vehicleid][vGuns] += obj[GUNS][objflag];
			DestroyObject(obj[GUNS][objid]);

			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/pickguns]: %d guns loaded into the Sultan - total: %d", obj[GUNS][objflag], VehicleInfo[vehicleid][vGuns]);
			format(iStr, sizeof(iStr), "6[GUNRUN] %s picked %d guns from the beach.", PlayerName(playerid), obj[GUNS][objflag]);
			iEcho(iStr);
			obj[GUNS][objflag] = 0;
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:putguns(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, 599.2726,867.6162,-43.2562, 8))
		return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560)
		return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid))
		return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(GetPlayerFactionType(playerid))
	{
		case FAC_TYPE_GANG, FAC_TYPE_MAFIA:
		{
			new curstock = dini_Int(compsfile, "guns");
			if(curstock >= 10000)
				return SendClientError(playerid, "The gunstock is full! (10000)");
			if(!VehicleInfo[vehicleid][vGuns])
				return SendClientError(playerid, "You don't have any guns loaded!");
			dini_IntSet(compsfile, "guns", curstock + VehicleInfo[vehicleid][vGuns]);
			new win = VehicleInfo[vehicleid][vGuns] * minrand(155, 160);
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/putguns]: %d guns have been sold, you earned $%d!", VehicleInfo[vehicleid][vGuns], number_format(win));
			GivePlayerMoneyEx(playerid, win);
			format(iStr, sizeof(iStr), "6[GUNRUN] %s put %d guns to the quarry and earned $%d.", PlayerName(playerid), VehicleInfo[vehicleid][vGuns], win);
			iEcho(iStr);
			VehicleInfo[vehicleid][vGuns] = 0;
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:pickdrugs(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, -1692.745849,-88.558601,3.566665, 6))
		return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560)
		return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid))
		return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(GetPlayerFactionType(playerid))
	{
		case FAC_TYPE_GANG, FAC_TYPE_MAFIA:
		{
			if(HandMoney(playerid) < 100000) return SendClientError(playerid, "You don't have enough money!");
			if(VehicleInfo[vehicleid][vDrugs]) return SendClientError(playerid, "You already have drugs loaded!");
			VehicleInfo[vehicleid][vDrugs] += 30;
			GivePlayerMoneyEx(playerid, -100000);
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/pickdrugs]: Bought 30g drugs worth $100,000. ($3333/g) ");
			format(iStr, sizeof(iStr), "6[DRUGRUN] %s bought 30 grams drugs worth $100000.", PlayerName(playerid));
			iEcho(iStr);
			AppendTo(moneylog, iStr);
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:putdrugs(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInSphere(playerid, 928.0421,2150.4253,10.5252, 6)) return SendClientError(playerid, "You are not at the correct place to use this command!");
	if(GetVehicleModel(carid) != 560) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not driving the Sultan to use this command!");
	switch(GetPlayerFactionType(playerid))
	{
		case FAC_TYPE_GANG, FAC_TYPE_MAFIA:
		{
			new okstock = dini_Int(compsfile, "drugs");
			if(okstock >= 3000)
				return SendClientError(playerid, "The drugstock is full! (3000)");
			if(!VehicleInfo[vehicleid][vDrugs]) return SendClientError(playerid, "You don't have any drugs loaded!");
			dini_IntSet(compsfile, "drugs", okstock+30);
			GivePlayerMoneyEx(playerid, 115000);
			SendClientMSG(playerid, COLOR_LIGHTGREEN, "[/putdrugs]: Sold 30g drugs for $115,000.");
			format(iStr, sizeof(iStr), "6[DRUGRUN] %s sold 100 drugs worth $115000.", PlayerName(playerid));
			iEcho(iStr);
			AppendTo(moneylog, iStr);
			VehicleInfo[vehicleid][vDrugs] = 0;
			return 1;
		}
		default: return SendClientError(playerid, CANT_USE_CMD);
	}
	return 1;
}
COMMAND:p(playerid, params[])
{
    if(!IsPlayerFED(playerid))
		return SendClientError(playerid, CANT_USE_CMD);

	new tmp[ 128 ];
	if( sscanf ( params, "s", tmp)) return SCP(playerid, "[text]");
	new carid = GetPlayerNearestVehicle(playerid);
	if(GetDistanceFromPlayerToVehicle(playerid, carid) > 8.0) return SendClientError(playerid, "There is no vehicle around you!");
	format(iStr,sizeof(iStr),"** %s %s o<: %s",PlayerInfo[playerid][rankname], MaskedName(playerid),tmp);
	new Float:gPos[3];
	GetPlayerPos(playerid, gPos[0], gPos[1], gPos[2]);
	PlayerLoop(i)
	{
	    if(IsPlayerInRangeOfPoint(i, 60, gPos[0], gPos[1], gPos[2])) SendClientMessage(i, COLOR_YELLOW, iStr);
	}
	return 1;
}
COMMAND:fcars(playerid)
{
   	new locked[ 5 ], area[ 40 ];
    if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, "You cannot use this as civilian.");
	format(iStr, sizeof(iStr), "[%s] {FFFFFF}Vehicles owned (%d/%d):", GetPlayerFactionName(playerid), FactionCarCount(PlayerInfo[playerid][playerteam]), FactionInfo[PlayerInfo[playerid][playerteam]][fMaxVehicles]);
	SendClientMessage(playerid, FactionInfo[PlayerInfo[playerid][playerteam]][fColour], iStr);
	VehicleLoop(i)
	{
	    if(VehicleInfo[i][vActive] != true) continue;
	    if(VehicleInfo[i][vFaction] == PlayerInfo[playerid][playerteam])
	    {
	        if(VehicleInfo[i][vLocked] == true) myStrcpy(locked, "Yes");
	        else if(VehicleInfo[i][vLocked] == false) myStrcpy(locked, "No");
	        GetVehicleZone(GetCarID(i), area);
	        if(IsVehicleOccupied(GetCarID(i)))
	        {
	            format(iStr, sizeof(iStr), "[ID: %i] [Vehicle: %s] [Locked: %s] [Location: %s] [Status: OCCUPIED]", i, GetVehicleName(GetCarID(i)), locked, area);
				if(VehicleInfo[i][vImpounded] == 1) strcat(iStr, " [IMPOUNDED]");
	            SendClientMessage(playerid, COLOR_RED, iStr);
	        }
	        else if(!IsVehicleOccupied(GetCarID(i)))
	        {
	            format(iStr, sizeof(iStr), "[ID: %i] [Vehicle: %s] [Locked: %s] [Location: %s] [Status: UNOCCUPIED]", i, GetVehicleName(GetCarID(i)), locked, area);
				if(VehicleInfo[i][vImpounded] == 1) strcat(iStr, " [IMPOUNDED]");
	            SendClientMessage(playerid, COLOR_LIGHTGREY, iStr);
	        }
	    }
	}
	return 1;
}
COMMAND:su(playerid, params[])
{
	if(!IsPlayerENF(playerid) && GetAdminLevel(playerid) < 6) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iLevel, iReason[ 48 ];
	if( sscanf ( params, "uds", iPlayer, iLevel, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [level] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(iLevel < 1 || iLevel > 6) return SendClientError(playerid, "Invalid level. Valid: 1-6");
	format(iStr, sizeof(iStr), " HQ: All units APB on %s,", RPName(iPlayer));
	SendClientMessageToTeam( PlayerInfo[playerid][playerteam], iStr, COLOR_PLAYER_SPECIALBLUE);
	format(iStr, sizeof(iStr), " HQ: Wanted for %s, category %d wanted suspect.", iReason, iLevel);
	SendClientMessageToTeam( PlayerInfo[playerid][playerteam], iStr, COLOR_PLAYER_SPECIALBLUE);
	PlayerInfo[iPlayer][wantedLvl] = iLevel;
	SetPlayerWantedLevel(iPlayer, iLevel);
	myStrcpy(PlayerInfo[iPlayer][wantedReason], iReason);
	return 1;
}
ALTCOMMAND:suspect->su;
COMMAND:record(playerid, params[])
{
	if(!IsPlayerENF(playerid) && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[ Firstname_Lastname ]");
	new carid = GetPlayerNearestVehicle(playerid);
	if(GetDistanceFromPlayerToVehicle(playerid, carid) > 8.0) return SendClientError(playerid, "There is no vehicle around you!");
	if(GetFactionTypeFromID(VehicleInfo[carid][vFaction]) == FAC_TYPE_POLICE || GetFactionTypeFromID(VehicleInfo[carid][vFaction]) == FAC_TYPE_ARMY || GetFactionTypeFromID(VehicleInfo[carid][vFaction]) == FAC_TYPE_FBI)
	{
	    Action(playerid, "logs in to the MDC and starts researching.");
	    SendClientMSG(playerid, COLOR_HELPEROOC, "[MDC] Wanted level of %s & 5 latest records:", RPName(iPlayer));
	    SendClientMSG(playerid, COLOR_LIGHTGREY, " Wanted Level: %d", GetPlayerWantedLevel(iPlayer));
/* 		SendClientMSG(playerid, COLOR_HELPEROOC, "Vehicles owned by \"%s:\"", iPlayer);
		VehicleLoop(i)
		{
			if(VehicleInfo[i][vActive] != true) continue;
			if(strcmp(VehicleInfo[i][vOwner], iPlayer, false)) continue;
			SendClientMSG(playerid, COLOR_LIGHTGREY, " VehicleID[ %d ] Model[ %s ]", i, GetVehicleNameFromModel(VehicleInfo[i][vModel]));
		}
		SendClientMSG(playerid, COLOR_HELPEROOC, "- BUSINESSES which have \"%s\" as owner:", iPlayer);
		BusinessLoop(b)
		{
			if(BusinessInfo[b][bActive] != true) continue;
			if(strcmp(BusinessInfo[b][bOwner], iPlayer, false)) continue;
			SendClientMSG(playerid, COLOR_LIGHTGREY,  " BizID[%d] Name[%s] Owner[%s] Till[$%d] TaxRate[%d%%]", b, BusinessInfo[b][bName], iPlayer, BusinessInfo[b][bTill], BusinessInfo[b][bTax]);
		}
		SendClientMSG(playerid, COLOR_HELPEROOC, "- HOUSES which have \"%s\" as owner:", iPlayer);
		HouseLoop(h)
		{
			if(HouseInfo[h][hActive] != true) continue;
			if(strcmp(HouseInfo[h][hOwner], iPlayer, false)) continue;
			SendClientMSG(playerid, COLOR_LIGHTGREY, " HouseID[%d] Owner[%s] Till[$%d]", h, iPlayer, HouseInfo[h][hTill]);
		} */
	}
	return 1;
}
ALTCOMMAND:mdc->record;
COMMAND:jail(playerid, params[])
{
	if(!IsPlayerENF(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, time, iReason[92];
	if( sscanf ( params, "uds", iPlayer,time,iReason))  return SCP(playerid, "[PlayerID/PartOfName] [jailtime (MINUTES)] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerInfo[playerid][ranklvl] == 0 && time > 50) return SendClientError(playerid, "Tier 0 players can jail someone for a maximum of 50 minutes.");
	if(PlayerInfo[playerid][ranklvl] == 1 && time > 40) return SendClientError(playerid, "Tier 1 players can jail someone for a maximum of 40 minutes.");
	if(PlayerInfo[playerid][ranklvl] == 2 && time > 25) return SendClientError(playerid, "Tier 1 players can jail someone for a maximum of 25 minutes.");
	if(PlayerInfo[iPlayer][bail] == 777) return SendClientError(playerid, "How about no?");
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 8.0) return SendClientError(playerid, "He is too far away!");

	if(IsPlayerAtPrison(playerid) || IsPlayerInRangeOfPoint(playerid, 10.0, -1590.5243,716.1575,-5.2422) || IsPlayerInRangeOfPoint(playerid, 10.0,-1606.2350,675.0267,-5.2422))
	{
		Jail(iPlayer,time*60,666, "Arrested");
	}
	else return SendClientError(playerid, "You are not at a correct spot to arrest.");
	format(iStr,sizeof(iStr),"* %s %s arrested suspect %s for %d minutes - %s *",PlayerInfo[playerid][rankname], RPName(playerid), RPName(iPlayer), time, iReason);
    SendClientMessageToAll(COLOR_RED,iStr);

	format(iStr, sizeof(iStr), "Arrested for %d minutes, reason: %s - By: %s.", time, iReason, PlayerName(playerid));
	PoliceDB(iPlayer, iStr);

	format(iStr,sizeof(iStr),"5{ ARREST } %s has arrested %s for %d minutes.", PlayerName(playerid), PlayerName(iPlayer), time);
	iEcho(iStr);
	format( iStr, sizeof(iStr), "NEWS: %s has been arrested for %d months.", RPName(iPlayer), time);
	TextDrawSetString(TextDraw__News, iStr);
	GiveFPoints(playerid, 4);
	return 1;
}
COMMAND:unjail(playerid, params[])
{
    if(!PlayerInfo[playerid][power] && !IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);

	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(iPlayer == playerid && !PlayerInfo[playerid][power] || PlayerInfo[iPlayer][bail] == 777 && !PlayerInfo[playerid][power])
	    return SendClientError(playerid, "Worth a try, huh?");

	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 10 && !PlayerInfo[playerid][power])
	{
	    return SendClientError(playerid, "He is too far away!");
	}
	if(PlayerInfo[iPlayer][jail])
	{
		UnJail(iPlayer);
		format(iStr, sizeof(iStr), "4[ UNJAIL ] %s[%d] has been unjailed by %s.", PlayerName(iPlayer), iPlayer, PlayerName(playerid));
		iEcho(iStr);
	}
	return 1;
}
COMMAND:setalltax(playerid, params[])
{
	if(GetPlayerFactionType(playerid) != FAC_TYPE_GOV && PlayerInfo[playerid][power] <= 10) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] != 0&& PlayerInfo[playerid][power] <= 10) return SendClientError(playerid, CANT_USE_CMD);
	new iTax;
	if( sscanf ( params, "d", iTax)) return SCP(playerid, "[amount of tax in percent]");
	if(iTax <= 0 || iTax >= 50) return SCP(playerid, "[amount of tax in percent]");
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    SetTax(b, iTax);
	}
	SendClientMSG(playerid, COLOR_PINK, "[GOV] Tax for all businesses set to %d%%",iTax);
	return 1;
}
COMMAND:settax(playerid, params[])
{
	if(GetPlayerFactionType(playerid) != FAC_TYPE_GOV && PlayerInfo[playerid][power] <= 10) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] != 0 && PlayerInfo[playerid][power] <= 10) return SendClientError(playerid, CANT_USE_CMD);
	new _id = IsPlayerOutBiz(playerid);
	if(_id == -1)
	{
		new tmp[20], p1[20], p2[20], p3[20];
		if( sscanf ( params, "szzz", tmp, p1, p2, p3)) return SCP(playerid, "[phone/medicals/paycheck/ad]");
		if(strcmp(tmp,"phone",true)==0)
		{
			if(!strlen(p1) || IsNumeric(p1)) return SCP(playerid, "phone [calls/sms] amount");
			if(strcmp(p1,"calls",true)==0)
			{
				if(!strlen(p2) || !IsNumeric(p2)) return SCP(playerid, "phone calls [amount (0-100)]");
		    	new price = strval(p2);
				if(price <= 0 || price > 100) return SCP(playerid, "phone calls [amount (0-100)]");
				SetTax(-1,price);
				SendClientMSG(playerid, COLOR_PINK, "[GOV] Phone calls have been set to $%d", price);
				return 1;
			}
			if(strcmp(p1,"sms",true)==0)
			{
				if(!strlen(p2) || !IsNumeric(p2)) return SCP(playerid, "phone sms [amount (0-100)]");
		    	new price = strval(p2);
				if(price <= 0 || price > 100) return SCP(playerid, "phone sms [amount (0-100)]");
				SetTax(-2,price);
				SendClientMSG(playerid, COLOR_PINK, "[GOV] SMS price has been set to $%d", price);
				return 1;
			}
		}
		if(strcmp(tmp,"medicals",true)==0)
		{
			if(!strlen(p1) || !IsNumeric(p1)) return SCP(playerid, "medicals [amount (1000-5000)]");
		    new price = strval(p1);
			if(price < 1000 || price > 5000) return SCP(playerid, "medicals [amount (1000-5000)]");
			SetTax(-3,price);
			SendClientMSG(playerid, COLOR_PINK, "[GOV] Medical Price has been set to $%d", price);
			return 1;
		}
		if(strcmp(tmp,"paycheck",true)==0)
		{
			if(!strlen(p1) || !IsNumeric(p1)) return SCP(playerid, "paycheck [amount (100-1000)]");
		    new price = strval(p1);
			if(price < 100 || price > 1000) return SCP(playerid, "paycheck [amount (100-1000)]");
			SetTax(-4,price);
			SendClientMSG(playerid, COLOR_PINK, "[GOV] Paycheck Tax has been set to $%d", price);
			return 1;
		}
		if(strcmp(tmp,"ad",true)==0)
		{
			if(!strlen(p1) || !IsNumeric(p1)) return SCP(playerid, "ad [amount (20-60)]");
		    new price = strval(p1);
			if(price < 20 || price > 60) return SCP(playerid, "ad [amount (20-60)]");
			SetTax(-5,price);
			SendClientMSG(playerid, COLOR_PINK, "[GOV] Advertisment has been set to $%d/character", price);
			return 1;
		}
	}
	else
	{
	    new perc;
		if( sscanf ( params, "d", perc)) return SCP(playerid, "[amount of tax in percent]");
		if(perc <= 0 || perc >= 50) return SCP(playerid, "[amount of tax in percent]");
		SetTax(_id,perc);
		SendClientMSG(playerid, COLOR_PINK, ":: TaxRate for %s has been set to %d%% ::", BusinessInfo[_id][bName], perc);
		return 1;
	}
	return 1;
}
COMMAND:setbiztax(playerid, params[])
{
	if(GetPlayerFactionType(playerid) != FAC_TYPE_GOV && PlayerInfo[playerid][power] <= 10) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] != 0 && PlayerInfo[playerid][power] <= 10) return SendClientError(playerid, CANT_USE_CMD);
	new bizID, bizTax;
	if(sscanf(params, "dd", bizID, bizTax)) return SCP(playerid, "[ BusinessID ] [ New tax rate ]");
	if(bizID < 0 || bizID > MAX_BUSINESS) return SendClientError(playerid, "Invalid business ID! Non existant.");
	if(BusinessInfo[bizID][bActive] != true) return SendClientError(playerid, "Invalid business ID! Non existant.");
	if(bizTax < 5 || bizTax > 50) return SendClientError(playerid, "Invalid tax amount, 5%% - 50%%.");
	SendClientMSG(playerid, COLOR_PINK, "[GOV] Tax rate for \"%s\" has been set to %d%%", BusinessInfo[bizID][bName], bizTax);
	BusinessInfo[bizID][bTax] = bizTax;
	return 1;
}
COMMAND:take(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, tmp[10], what[20];
	if(sscanf(params, "us", iPlayer, tmp)) return SCP(playerid, "[PlayerID/PartOfName] [drugs/sellables/radio/cellphone/driverlic/weplic]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!strcmp(tmp,"drugs"))
	{
		myStrcpy(what, "drugs");
		for(new i; i < sizeof(drugtypes); i++) PlayerInfo[iPlayer][hasdrugs][i] = 0;
	}
	else if(!strcmp(tmp,"sellables")) myStrcpy(what, "sellable weapons"), PlayerInfo[iPlayer][sMaterials] = 0;
	else if(!strcmp(tmp,"radio")) myStrcpy(what, "radio"), PlayerInfo[iPlayer][radio] = 0;
	else if(!strcmp(tmp,"cellphone")) myStrcpy(what, "cellphone"), PlayerInfo[iPlayer][gotphone] = 0;
	else if(!strcmp(tmp,"driverlic")) myStrcpy(what, "driver licenses"), PlayerInfo[iPlayer][driverlic] = 0;
	else if(!strcmp(tmp,"weplic")) myStrcpy(what,"weapon licenses"), PlayerInfo[iPlayer][weaplic] = 0;
	else return SCP(playerid, "[PlayerID/PartOfName] [drugs/sellables/radio/cellphone/driverlic/weplic]");
	format(iStr, sizeof(iStr), "has taken %s's %s away.", PlayerName(iPlayer), what);
	Action(playerid, iStr);
	format(iStr, sizeof(iStr), "%s %s has taken away your %s.", PlayerInfo[playerid][rankname], RPName(playerid), what);
	ShowInfoBox(iPlayer, "Item Taken Away", iStr, 60);
	return 1;
}
COMMAND:emergency(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
    format(iStr,sizeof(iStr),".: [EMERGENCY] :. %s %s DECLARED EMERGENCY STATUS",PlayerInfo[playerid][rankname], PlayerName(playerid));
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		switch(FactionInfo[f][fType])
		{
			case FAC_TYPE_ARMY, FAC_TYPE_POLICE, FAC_TYPE_FBI, FAC_TYPE_GOV: SendClientMessageToTeam(f,iStr,COLOR_ORANGE);
		}
	}
	gBackupMarker = playerid;
	return 1;
}
COMMAND:bk(playerid, params[])
{
    if(!IsPlayerENF(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new zone[ 60 ];
	GetPlayer3DZone(playerid, zone, sizeof(zone));
	if(GetPlayerInterior(playerid)) myStrcpy(zone, "Unknown (( Interior ))");
	if(GetPlayerFactionType(playerid) == FAC_TYPE_POLICE) format(iStr,sizeof(iStr),"[BACKUP CALL] SAPD %s %s needs backup at %s!",PlayerInfo[playerid][rankname],PlayerName(playerid),zone);
	if(GetPlayerFactionType(playerid) == FAC_TYPE_FBI) format(iStr,sizeof(iStr),"[BACKUP CALL] FBI %s %s needs backup at %s!",PlayerInfo[playerid][rankname],PlayerName(playerid),zone);
	if(GetPlayerFactionType(playerid) == FAC_TYPE_ARMY) format(iStr,sizeof(iStr),"[BACKUP CALL] ARM %s %s needs backup at %s!",PlayerInfo[playerid][rankname],PlayerName(playerid),zone);
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		switch(FactionInfo[f][fType])
		{
			case FAC_TYPE_ARMY, FAC_TYPE_POLICE, FAC_TYPE_FBI: SendClientMessageToTeam(f,iStr,COLOR_ORANGE);
		}
	}
	gBackupMarker = playerid;
	return 1;
}
COMMAND:bc(playerid, params[])
{
    if(!IsPlayerENF(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	format(iStr,sizeof(iStr),"[CANCEL] %s %s has cancelled the backup call!",PlayerInfo[playerid][rankname],PlayerName(playerid));
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		switch(FactionInfo[f][fType])
		{
			case FAC_TYPE_ARMY, FAC_TYPE_POLICE, FAC_TYPE_FBI: SendClientMessageToTeam(f,iStr,COLOR_ORANGE);
		}
	}
	gBackupMarker = -1;
	PlayerLoop(i)
	{
		if(!PlayerTemp[i][loggedIn]) continue;
		if(IsPlayerENF(i)) DisablePlayerCheckpoint(i);
	}
	
	return 1;
}
COMMAND:ann(playerid, params[])
{
    if(IsPlayerFED(playerid) || GetPlayerFactionType(playerid) == FAC_TYPE_SDC)
    {
        if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);

		new tmp[ 128 ];
		if( sscanf ( params, "s", tmp)) return SCP(playerid, "[text]");
		if(strfind(tmp, "~") != -1) return SendClientError(playerid, "You tried to use an invalid character! [~]");

		PlayerLoop(p)
		{
			if(PlayerTemp[p][loggedIn] == true)
			{
				SendClientMessage(p, 0x4985d7FF, "==================================================================");
				SendClientMSG(p, COLOR_WHITE, "[%s]: %s", FactionInfo[PlayerInfo[playerid][playerteam]][fName], tmp);
				SendClientMessage(p, 0x4985d7FF, "==================================================================");
			}
			else continue;
		}
		new iFormat[136];
		format(iFormat, sizeof(iFormat), "[%s]: %s", FactionInfo[ PlayerInfo[playerid][playerteam] ][fName], tmp);
   		TextDrawSetString(TextDraw__News, iFormat);
		return 1;
	}
	else return SendClientError(playerid, CANT_USE_CMD);
}
COMMAND:slist(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	for(new barCount = 1; barCount < MAX_SPIKES; barCount++)
	{
	    new zone[40];
	    GetZone(Spikes[barCount][sX],Spikes[barCount][sY],Spikes[barCount][sZ], zone);
	    if(!Spikes[barCount][sObject]) format(iStr, sizeof(iStr), "[INFO] Spike %i [NOT USED]", barCount);
		else format(iStr, sizeof(iStr), "[INFO] Spike %i [USED @ %s]", barCount, zone);

		if(!Spikes[barCount][sObject]) SendClientMessage(playerid, COLOR_LIGHTGREY, iStr);
		else SendClientMessage(playerid, COLOR_RED, iStr);
	}
	return 1;
}
COMMAND:blist(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	for(new barCount = 1; barCount < MAX_BARRIERS; barCount++)
	{
	    if(!roadBlock[ barCount ]) format(iStr, sizeof(iStr), "[INFO] Barrier %i [NOT USED]", barCount);
		else format(iStr, sizeof(iStr), "[INFO] Barrier %i [USED BY: %s]", barCount, roadBlockPlayer[ barCount ]);

		if(!roadBlock[ barCount ]) SendClientMessage(playerid, COLOR_LIGHTGREY, iStr);
		else SendClientMessage(playerid, COLOR_RED, iStr);
	}
	return 1;
}
COMMAND:duty(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 229.9484,165.1600,1003.0234) || IsPlayerInRangeOfPoint(playerid, 5.0, 326.3294,307.0767,999.148) && GetPlayerFactionType(playerid) == FAC_TYPE_POLICE)
	{
		new skinid;
		if(sscanf(params, "d", skinid)) return SCP(playerid, "[1-6]");
		if(skinid == 1) SetPlayerSkin(playerid, 71);
		else if(skinid == 2) SetPlayerSkin(playerid, 265);
		else if(skinid == 3) SetPlayerSkin(playerid, 266);
		else if(skinid == 4) SetPlayerSkin(playerid, 267);
		else if(skinid == 5) SetPlayerSkin(playerid, 284);
		else if(skinid == 6) SetPlayerSkin(playerid, 211);
		else return SCP(playerid, "[1-6]");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 247.4000,1859.6801,14.0840) && GetPlayerFactionType(playerid) == FAC_TYPE_ARMY || IsPlayerInRangeOfPoint(playerid, 5.0, 254.1159,66.3271,1003.6406) && GetPlayerFactionType(playerid) == FAC_TYPE_ARMY)
	{
		new skinid;
		if(sscanf(params, "d", skinid)) return SCP(playerid, "[1-6]");
		if(skinid == 1) SetPlayerSkin(playerid, 287);
		else if(skinid == 2) SetPlayerSkin(playerid, 285);
		else if(skinid == 3) SetPlayerSkin(playerid, 282);
		else if(skinid == 4) SetPlayerSkin(playerid, 71);
		else if(skinid == 5) SetPlayerSkin(playerid, 179);
		else if(skinid == 6) SetPlayerSkin(playerid, 191);
		else return SCP(playerid, "[1-6]");
	}
	else if(IsPlayerInRangeOfPoint(playerid, 5.0, 240.6122,112.8963,1003.2188) && GetPlayerFactionType(playerid) == FAC_TYPE_FBI)
	{
		new skinid;
		if(sscanf(params, "d", skinid)) return SCP(playerid, "[1-6]");
		if(skinid == 1) SetPlayerSkin(playerid, 287);
		else if(skinid == 2) SetPlayerSkin(playerid, 285);
		else if(skinid == 3) SetPlayerSkin(playerid, 282);
		else if(skinid == 4) SetPlayerSkin(playerid, 71);
		else if(skinid == 5) SetPlayerSkin(playerid, 286);
		else return SCP(playerid, "[1-5]");
	}
	else return SendClientError(playerid, "You are not at the correct place!");
	return 1;
}
COMMAND:cctv(playerid, params[])
{
	if(IsPlayerFED(playerid) || PlayerInfo[playerid][power] >= 10)
	{
		if(PlayerTemp[playerid][isCCTV]) return SetPlayerBack(playerid, 1);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 196.8517,171.4495,1003.0234) || IsPlayerInRangeOfPoint(playerid, 3.0, 221.3512,67.2757,1005.0391))
		{
			GetPlayerPos(playerid, PlayerTemp[playerid][PlayerPosition][0],PlayerTemp[playerid][PlayerPosition][1],PlayerTemp[playerid][PlayerPosition][2]);
			PlayerTemp[playerid][PlayerInterior] = GetPlayerInterior(playerid);
			PlayerTemp[playerid][PlayerVirtualWorld] = GetPlayerVirtualWorld(playerid);
			GetPlayerHealth(playerid, PlayerTemp[playerid][PlayerHealth]);
			GetPlayerArmour(playerid, PlayerTemp[playerid][PlayerArmour]);
			for (new i = 0; i<13; i++)
			{
				GetPlayerWeaponData(playerid, i, PlayerTemp[playerid][PlayerWeapon][i], PlayerTemp[playerid][PlayerAmmo][i]);
			}
			SetPVarInt(playerid, "SkinSelect", 1);
			SendClientInfo(playerid, "Type /cctv again to get out of the CCTV mode!");
			PlayerTemp[playerid][isCCTV] = 1;
			ShowDialog(playerid, DIALOG_CCTV);
		}
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:offduty(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	if(IsPlayerInRangeOfPoint(playerid, 5.0, 221.8132,183.5439,1003.0313) || IsPlayerInRangeOfPoint(playerid, 5.0, 247.4000,1859.6801,14.0840) || IsPlayerInRangeOfPoint(playerid, 5.0, 326.3294,307.0767,999.148) || IsPlayerInRangeOfPoint(playerid, 5.0, 240.6122,112.8963,1003.2188) || IsPlayerInRangeOfPoint(playerid, 5.0, 254.1159,66.3271,1003.6406))
	{
		new skinid;
		if(sscanf(params, "d", skinid)) return SCP(playerid, "[clothes (1-20)]");
		if(skinid == 1) SetPlayerSkin(playerid, 17);
		else if(skinid == 2) SetPlayerSkin(playerid, 20);
		else if(skinid == 2) SetPlayerSkin(playerid, 24);
		else if(skinid == 3) SetPlayerSkin(playerid, 25);
		else if(skinid == 4) SetPlayerSkin(playerid, 46);
		else if(skinid == 5) SetPlayerSkin(playerid, 67);
		else if(skinid == 6) SetPlayerSkin(playerid, 163);
		else if(skinid == 7) SetPlayerSkin(playerid, 164);
		else if(skinid == 8) SetPlayerSkin(playerid, 165);
		else if(skinid == 9) SetPlayerSkin(playerid, 166);
		else if(skinid == 10) SetPlayerSkin(playerid, 170);
		else if(skinid == 11) SetPlayerSkin(playerid, 180);
		else if(skinid == 12) SetPlayerSkin(playerid, 184);
		else if(skinid == 13) SetPlayerSkin(playerid, 188);
		else if(skinid == 14) SetPlayerSkin(playerid, 234);
		else if(skinid == 15) SetPlayerSkin(playerid, 240);
		else if(skinid == 16) SetPlayerSkin(playerid, 285);
		else if(skinid == 17) SetPlayerSkin(playerid, 211); // FEMALE
		else if(skinid == 18) SetPlayerSkin(playerid, 150); // FEMALE
		else if(skinid == 19) SetPlayerSkin(playerid, 233); // FEMALE
		else if(skinid == 20) SetPlayerSkin(playerid, 187); // FEMALE
		else return SCP(playerid, "[clothes (1-20)]");
		SetPlayerColor(playerid, COLOR_WHITE);
		return 1;
	}
	else return SendClientError(playerid, "You are not at the correct place!");
}
COMMAND:bdeploy(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);

	new bid;
	if( sscanf ( params, "d", bid)) return SCP(playerid, "[barrierID]");

	if(bid < 1 || bid > MAX_BARRIERS) return SCP(playerid, "[barrierID]");
	if(roadBlock[ bid ] == 1) return SendClientError(playerid, "That roadblock already exists. USE: /bremove");

	roadBlock[ bid ] = 1;
	format(roadBlockPlayer[ bid ], 32, "%s", PlayerName(playerid));

	new Float:X, Float:Y, Float:Z, Float:A;

	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	// CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:distance = 200.0);
	roadBlockObj[ bid ] = CreateDynamicObject(978, X, Y, Z, 0.0, 0.0, A, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	SetPlayerPos(playerid, X-1, Y, Z+2);
	Action(playerid, "is deploying a road block.");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 1800, 1); // bomb plant
	return 1;
}
COMMAND:bremove(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);

	new bid;
	if( sscanf ( params, "d", bid)) return SCP(playerid, "[barrierID]");

	if(bid < 1 || bid > MAX_BARRIERS) return SCP(playerid, "[barrierID]");
	if(roadBlock[ bid ] == 0) return SendClientError(playerid, "That roadblock doesn't exist.");

	roadBlock[ bid ] = 0;
	format(roadBlockPlayer[ bid ], 32, "NoBodY");
	DestroyDynamicObject(roadBlockObj[ bid ]);
	return 1;
}
COMMAND:sdeploy(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);

	new bid;
	if( sscanf ( params, "d", bid)) return SCP(playerid, "[spikeID]");

	if(bid < 1 || bid > MAX_SPIKES) return SCP(playerid, "[spikeID]");
	if(Spikes[bid][exists] == 1) return SendClientError(playerid, "That spike already exists. USE: /sremove");

	new Float:X, Float:Y, Float:Z, Float:A;
	GetPlayerPos(playerid, X, Y, Z);
	GetPlayerFacingAngle(playerid, A);
	Spikes[ bid ][ sObject ] = CreateDynamicObject(2892, X, Y, Z-0.9, 0.0, 0.0, A, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	Spikes[ bid ][ sX ] = X;
	Spikes[ bid ][ sY ] = Y;
	Spikes[ bid ][ sZ ] = Z-0.9;
	Spikes[ bid ][ rX ] = 0;
	Spikes[ bid ][ rY ] = 0;
	Spikes[ bid ][ rZ ] = A;
	Spikes[ bid ][ exists ] = 1;
	Action(playerid, "is unfolding a spike strip.");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 1800, 1); // bomb plant
	return 1;
}
COMMAND:sremove(playerid, params[])
{
    if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);

	new bid;
	if( sscanf ( params, "d", bid)) return SCP(playerid, "[spikeID]");

	if(bid < 1 || bid > MAX_SPIKES && bid != -1) return SCP(playerid, "[spikeID]");
	if(!Spikes[bid][exists] && bid != -1) return SendClientError(playerid, "That spike doesn't exist. USE: /slist");
	if(bid == -1 && PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, "Tier 0 or 1 required.");

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(bid == -1)
	{
	    for(new i; i < sizeof(Spikes); i++)
	    {
	        if(!Spikes[i][exists]) continue;
	        DestroyDynamicObject(Spikes[ i ][ sObject ]);
			Spikes[ i ][ sX ] = 0;
			Spikes[ i ][ sY ] = 0;
			Spikes[ i ][ sZ ] = 0;
			Spikes[ i ][ rX ] = 0;
			Spikes[ i ][ rY ] = 0;
			Spikes[ i ][ rZ ] = 0;
			Spikes[ i ][ exists ] = 0;
	    }
	    return 1;
	}
	else if(IsPlayerInRangeOfPoint(playerid, 10.0, Spikes[ bid ][ sX ], Spikes[ bid ][ sY ], Spikes[ bid ][ sZ ]))
	{
		DestroyDynamicObject(Spikes[ bid ][ sObject ]);
		Spikes[ bid ][ sX ] = 0;
		Spikes[ bid ][ sY ] = 0;
		Spikes[ bid ][ sZ ] = 0;
		Spikes[ bid ][ rX ] = 0;
		Spikes[ bid ][ rY ] = 0;
		Spikes[ bid ][ rZ ] = 0;
		Spikes[ bid ][ exists ] = 0;
		Action(playerid, "is folding the spike strip.");
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 0, 1800, 1); // bomb plant
		return 1;
	}
	else return SendClientError(playerid, "You are not close to that spike!");
}
COMMAND:turftakeover(playerid, params[])
{
	if(!IsPlayerENF(playerid))
	{
		if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
		new tFOUND = -1;
	    for(new q; q < MAX_GANGZONES; q++)
	    {
			if(IsPlayerInArea(playerid, Gangzones[q][minX], Gangzones[q][minY], Gangzones[q][maxX], Gangzones[q][maxY])) tFOUND = q;
	    }
	    if(tFOUND == -1) return SendClientError(playerid, "You are not standing in any turf.");
	    if(Gangzones[tFOUND][gBLINK] == 1) return SendClientError(playerid, "This turf is already being taken over... ");
		new iPlayers[ 10 ], rCount = 0,Float:rPos[4];
		GetPlayerPos(playerid, rPos[0], rPos[1], rPos[2]);
        for(new i; i < MAX_PLAYERS; i++)
        {
            if(!IsPlayerConnected(i)) continue;
            if(!IsPlayerInRangeOfPoint(i, 20.0, rPos[0], rPos[1], rPos[2])) continue;
            if(PlayerInfo[i][playerteam] != PlayerInfo[playerid][playerteam]) continue;
            iPlayers[rCount] = i;
            rCount++;
        }
        if(rCount < 7) return SendClientError(playerid, "You need atleast 7 people from your faction with you!");
        if(sscanf(params, "uuuuuuu", iPlayers[0], iPlayers[1], iPlayers[2], iPlayers[3], iPlayers[4], iPlayers[5], iPlayers[6]))
            return SCP(playerid, "[player1][player2][player3][player4][player5][player6][player7]");
        TakeOverTurf( tFOUND, playerid, PlayerInfo[playerid][playerteam] );
		TurfTakeOver[ tFOUND ][ TIMER ] = SetTimerEx("TakeOverTurf", 10000, true, "ddd", tFOUND, playerid,PlayerInfo[playerid][playerteam]);
		TurfTakeOver[ tFOUND ][ TIME ] = 0;
  		PlayerLoop(i)
	 	{
			if(PlayerTemp[i][loggedIn] != true) continue;
  		    if(!IsPlayerFED(i))
		    {
		        GangZoneFlashForPlayer(i, Gangzones[tFOUND][gID], COLOR_WHITE);
		    }
		}
		Gangzones[tFOUND][gBLINK] = 1;
		return 1;
	}
	return 1;
}
COMMAND:fon(playerid)
{
    if(PlayerInfo[playerid][playerteam] == CIV)
        return SendClientError(playerid, "You cannot use this as civilian.");
	format(iStr, sizeof(iStr), "[%s] {FFFFFF}Online players (%d/%d):", GetPlayerFactionName(playerid), GetOnlineMembers(PlayerInfo[playerid][playerteam]), FactionInfo[PlayerInfo[playerid][playerteam]][fMaxMemberSlots]);
	SendClientMessage(playerid, FactionInfo[PlayerInfo[playerid][playerteam]][fColour], iStr);
	new runs[50];
	for(new iii = 0;iii < MAX_PLAYERS; iii++)
	{
	    if(!IsPlayerConnected(iii)) continue;
		if(PlayerInfo[iii][playerteam] == PlayerInfo[playerid][playerteam])
		{
		    if(GetPlayerFactionType(playerid) == FAC_TYPE_SDC) format(runs, sizeof(runs), "[Runs: %d]", PlayerInfo[iii][totalruns]); else myStrcpy(runs, " ");
			format(iStr, sizeof(iStr),"* %s [%d] [Rank: %s] [Tier: %d] [Payment: $%s] %s",RPName(iii),iii,PlayerInfo[iii][rankname],PlayerInfo[iii][ranklvl], number_format(PlayerInfo[iii][fpay]), runs);
			SendClientMessage(playerid,COLOR_WHITE,iStr);
		}
	}
	return 1;
}
COMMAND:foff(playerid, params[])
{
    if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, "You cannot use this as civilian.");
	new iQuery[300];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `PlayerName`, `Tier`, `FactionPay`, `FactionID`, `LastOnline`, `RankName` FROM `PlayerInfo` WHERE `FactionID` = %d ORDER BY `Tier` ASC", PlayerInfo[playerid][playerteam]);
	mysql_tquery(MySQLPipeline, iQuery, "ShowOfflineMembers", "d", playerid);
	return 1;
}
COMMAND:finfo(playerid)
{
    new f = PlayerInfo[playerid][playerteam];
    if(f == CIV) return SendClientError(playerid, "You cannot use this as civilian.");
	if(!IsPlayerENF(playerid))
	{
		SendClientMSG(playerid, COLOR_HELPEROOC, "[FACTION] %s information:", GetPlayerFactionName(playerid));
		SendClientMSG(playerid, COLOR_WHITE, " F-Points: %d", FactionInfo[f][fPoints]);
		SendClientMSG(playerid, COLOR_WHITE, " F-Gunstock: %d", HQInfo[f][fHQStock]);
		SendClientMSG(playerid, COLOR_WHITE, " F-Vehicles: %d/%d", FactionCarCount(f), FactionInfo[f][fMaxVehicles]);
		SendClientMSG(playerid, COLOR_WHITE, " Members: %d/%d",  GetOnlineMembers(f), FactionInfo[f][fMaxVehicles]);
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:d(playerid, params[])
{
	if(PlayerTemp[playerid][muted]) return SendClientError(playerid, "You are muted!");
	if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iText[ 128 ], iStr2[ 128 + 10 ];
	if(sscanf(params, "s", iText)) return SCP(playerid, "[msg]");
	format(iStr,sizeof(iStr),"{d7442a}* [Dep. Radio] {FF6347} %s %s: %s",PlayerInfo[playerid][rankname],RPName(playerid),iText);
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(FactionInfo[f][fType] == FAC_TYPE_ARMY || FactionInfo[f][fType] == FAC_TYPE_GOV || FactionInfo[f][fType] == FAC_TYPE_POLICE || FactionInfo[f][fType] == FAC_TYPE_FBI)
		{
			SendClientMessageToTeam(f, iStr, 0xFF6347AA);
		}
	}
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerTemp[i][adminspy] == 1)
		{
			format(iStr2, sizeof(iStr2), "(/d) %s", iStr);
			SendClientMessage(i, COLOR_LIGHTGREY, iStr2);
		}
	}
	format(iStr, sizeof(iStr), "(RADIO) %s: %s", MaskedName(playerid), iText);
    ProxDetectorEx(20.0, playerid, iStr);
	return 1;
}
COMMAND:f(playerid, params[])
{
	if(PlayerTemp[playerid][muted]) return SendClientError(playerid, "You are muted!");
	if(GetPlayerFaction(playerid) == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iText[ 128 ];
	if(sscanf(params, "s", iText)) return SCP(playerid, "[msg]");
	new iStr2[ 128 + 20 ];
	if(FactionInfo[GetPlayerFaction(playerid)][fTogChat]) return SendClientError(playerid, "Your faction-chat is disabled!");
	format(iStr, sizeof(iStr),"(( F-Chat | %s %s: %s ))", PlayerInfo[playerid][rankname], RPName(playerid), iText);
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_SPECIALBLUE);
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerTemp[i][adminspy] == 1)
		{
		    format(iStr2, sizeof(iStr2), "(/f) [%s] %s", GetPlayerFactionName(playerid), iStr);
		    SendClientMessage(i, COLOR_LIGHTGREY, iStr2);
		}
	}
	format( iStr2, sizeof(iStr2), "14[/f - %s] %s: %s", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid));
	iEcho( iStr2 );
	// log
	new iQuery[288], pIP[31];
	GetPlayerIp(playerid, pIP, sizeof(pIP));
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `FactionChat` (`PlayerName`, `Message`, `TimeDate`, `IP`) VALUES ('%e', '%e', '%e', '%e')", PlayerName(playerid), iText, TimeDateEx(), pIP);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}
COMMAND:getfreq(playerid)
{
	if(GetPlayerFaction(playerid) == CIV) return SendClientError(playerid, CANT_USE_CMD);
	SendClientMSG(playerid,COLOR_GREENYELLOW,"..:: %s frequency: %d - Use /freq [slot] [freq] then /syncradio [slot] ::..", GetPlayerFactionName(playerid), FactionInfo[PlayerInfo[playerid][playerteam]][fFreq]);
	return 1;
}
COMMAND:ftakegun(playerid, params[])
{
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	if(!IsAtOwnHQ(playerid)) return SendClientError(playerid, "You are not at your own HQ (outside)!");
	if(HQInfo[GetPlayerFaction(playerid)][fHQStock] < 2) return SendClientError(playerid, "Your gunstock doesn't have enough guns!");
	if(HQInfo[GetPlayerFaction(playerid)][fHQStockTog] == false) return SendClientError(playerid, "Your faction guns stock is disabled!");
	new tmp[ 10 ];
	if(sscanf(params, "s", tmp)) return SCP(playerid, "[weapon]");
	new amount;
	if(!strcmp(tmp, "deagle")) GivePlayerWeaponEx(playerid, WEAPON_DEAGLE, 80), amount = 1;
	else if(!strcmp(tmp, "shotgun")) GivePlayerWeaponEx(playerid, WEAPON_SHOTGUN, 80), amount = 2;
	else if(!strcmp(tmp, "mp5")) GivePlayerWeaponEx(playerid, WEAPON_MP5, 120), amount = 2;
	else if(!strcmp(tmp, "ak47")) GivePlayerWeaponEx(playerid, WEAPON_AK47, 150), amount = 3;
	else if(!strcmp(tmp, "m4")) GivePlayerWeaponEx(playerid, WEAPON_M4, 150), amount = 3;
	else return SCP(playerid, "[weapon]");
	HQInfo[GetPlayerFaction(playerid)][fHQStock] -= amount;
	format(iStr, sizeof(iStr), "3{ WEAPON } %s has taken a weapon from their HQ: %s", PlayerName(playerid), tmp);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has taken a \"%s\" from the faction stock.", GetPlayerFactionName(playerid), RPName(playerid), tmp);
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:clearlvl(playerid, params[])
{
	if(!IsPlayerFED(playerid) && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerWantedLevel(iPlayer))
	{
		SetPlayerWantedLevel(iPlayer,GetPlayerWantedLevel(iPlayer)-1);
		format(iStr,sizeof(iStr),"*** %s wanted level: %d ***",RPName(iPlayer),GetPlayerWantedLevel(iPlayer));
		SendClientMessage(playerid, COLOR_PLAYER_LIGHTBLUE,iStr);
		return 1;
	}
	else SendClientError(playerid, "Already wanted level 0");
	return 1;
}
ALTCOMMAND:cl->clearlvl;
COMMAND:wantedlvl(playerid, params[])
{
	if(!IsPlayerFED(playerid) && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "ud", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerWantedLevel(iPlayer)<6)
	{
		SetPlayerWantedLevel(iPlayer,GetPlayerWantedLevel(iPlayer)+1);
		format(iStr,sizeof(iStr),"*** %s wanted level: %d ***",RPName(iPlayer),GetPlayerWantedLevel(iPlayer));
		SendClientMessage(playerid, COLOR_PLAYER_LIGHTBLUE,iStr);
		return 1;
	}
	else SendClientError(playerid, "Already wanted level 6");
	return 1;
}
COMMAND:wlist(playerid, params[])
{
	if(!IsPlayerFED(playerid) && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	PlayerLoop(i)
	{
		if(GetPlayerWantedLevel(i) != 0 && PlayerTemp[i][loggedIn] != false)
		{
			new iFormat[136];
			format(iFormat, sizeof(iFormat), "[Wanted] %s, %d stats. Reason: %s", /* MaskedName(i) */i, GetPlayerWantedLevel(i), PlayerInfo[playerid][wantedLvl]);	
			SendClientMessage(playerid, COLOR_ADMINCHAT, iFormat);
		}
	}
	return 1;
}
COMMAND:ticket(playerid, params[])
{
	if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, amount, iReason[92];
	if( sscanf ( params, "uds", iPlayer, amount, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [amount] [reason]");
	if(amount > 100000 || amount < 50) return SendClientError(playerid, "Min: $50 - Max: $100,000");
	PlayerTemp[iPlayer][ticket] = amount;
	SendClientMSG(iPlayer,COLOR_PINK, "[TICKET] %s %s wants you to pay a ticket of $%d. Reason: %s",PlayerInfo[playerid][rankname], RPName(playerid),amount, iReason);
	SendClientMessage(iPlayer, COLOR_PINK, "Use \"/accept ticket\" if you wanna pay it.");
	format(iStr, sizeof(iStr), "Ticketed by %s for $%s - %s", PlayerName(playerid), number_format(amount), iReason);
	PoliceDB(iPlayer, iStr);
	format(iStr, sizeof(iStr), "%s %s has given you a ticket of $%d to pay. Use /accept ticket if you want to pay it, else you may be arrested.", PlayerInfo[playerid][rankname], RPName(playerid), amount);
	ShowInfoBox(iPlayer, "Ticket Received", iStr);
	SendClientMessage(playerid,COLOR_LIGHTGREY," Ticket has been given.");
	GiveFPoints(playerid, 1);
	// log
	new iQuery[288], pIP[31];
	GetPlayerIp(playerid, pIP, sizeof(pIP));
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `PlayerTickets` (`PlayerName`, `ByWho`, `Reason`, `Amount`, `DateTime`) VALUES ('%e', '%e', '%e', '%e', '%e')", iPlayer, PlayerName(playerid), iReason, amount, TimeDateEx());
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}
COMMAND:imprison(playerid, params[])
{
	if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	if(!IsPlayerAtPrison(playerid)) return SendClientError(playerid, "You are not at the Prison!");
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 8.0) return SendClientError(playerid, "He is too far away!");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, "Player not found!");
	if(PlayerTemp[iPlayer][imprisoned])
	{
		SetPlayerPos(iPlayer, 2323.9302,1288.1456,10.8491);
		SetPlayerInterior(iPlayer, 0);
		SetPlayerVirtualWorld(iPlayer, 0);
		PlayerTemp[iPlayer][imprisoned] = 0;
	}
	else
	{
		new id = random(sizeof(PrisonCells));
		SetPlayerPos(iPlayer, PrisonCells[id][0],PrisonCells[id][1],PrisonCells[id][2]);
		SetPlayerInterior(iPlayer, 0);
		SetPlayerVirtualWorld(iPlayer, 0);
		PlayerTemp[iPlayer][imprisoned] = 1;
	}
	return 1;
}
COMMAND:warinfo(playerid, params[])
{
	WarInfo(playerid);
	return 1;
}
COMMAND:badge(playerid, params[])
{
	if(!IsPlayerENF(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 5) return SendClientError(playerid,   "Too far away");

	format(iStr, sizeof(iStr), "has shown their badge to %s.", MaskedName(iPlayer));
	Action(playerid, iStr);

	SendClientMessage(iPlayer, COLOR_WHITE, "{3f9541}========= {7ada7d}[Government Badge] {3f9541}=========");
	SendClientMSG(iPlayer, COLOR_WHITE, " {7ada7d}Name: {FFFFFF}%s", RPName(playerid));
	SendClientMSG(iPlayer, COLOR_WHITE, " {7ada7d}Employed at: {FFFFFF}%s", GetPlayerFactionName(playerid));
	SendClientMSG(iPlayer, COLOR_WHITE, " {7ada7d}Position: {FFFFFF}%s", PlayerInfo[playerid][rankname]);
	SendClientMessage(iPlayer, COLOR_WHITE, "{3f9541}========= {7ada7d}[Government Badge] {3f9541}=========");
	return 1;
}
COMMAND:openhq(playerid, params[])
{
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(HQInfo[f][hqActive] != true) continue;
		if(IsPlayerInRangeOfPoint(playerid, 3, HQInfo[f][fHQX],  HQInfo[f][fHQY],  HQInfo[f][fHQZ]))
		{
			if(PlayerInfo[playerid][playerteam] == f || PlayerInfo[playerid][power]>=10)
			{
				HQInfo[f][hqOpen] = true;
				Action(playerid, "takes out some keys and unlocks the doors of the building.");
			}
			else return SendClientError(playerid, CANT_USE_CMD);
		}
	}
    return 1;
}
COMMAND:closehq(playerid, params[])
{
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(HQInfo[f][hqActive] != true) continue;
		if(IsPlayerInRangeOfPoint(playerid, 3, HQInfo[f][fHQX],  HQInfo[f][fHQY],  HQInfo[f][fHQZ]))
		{
			if(PlayerInfo[playerid][playerteam] == f || PlayerInfo[playerid][power] >= 10)
			{
				HQInfo[f][hqOpen] = false;
				Action(playerid, "takes out some keys and locks the doors of the building.");
			}
			else return SendClientError(playerid, CANT_USE_CMD);
		}
	}
    return 1;
}
COMMAND:fmotd(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] > 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);

	new iMOTD[128];
	if( sscanf ( params, "s", iMOTD))  return SCP(playerid, "[text]");
	myStrcpy(FactionInfo[PlayerInfo[playerid][playerteam]][fMOTD], iMOTD);
	format(iStr, sizeof(iStr), "10[F-MOTD] %s has changed the F-MOTD for faction %s.", PlayerName(playerid), FactionInfo[PlayerInfo[playerid][playerteam]][fName]);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has changed the F-MOTD.", GetPlayerFactionName(playerid), RPName(playerid));
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
    return 1;
}
COMMAND:invite(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer) || iPlayer == playerid) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerFaction(iPlayer) != CIV) return SendClientError(playerid, "Player is not a civilian!");
	if(PlayerInfo[iPlayer][playerlvl] < 3)
		return SendClientError(playerid,   "Players need to be atleast level 3 to join factions!");
	Invite(iPlayer, PlayerInfo[playerid][playerteam], PlayerName(playerid));
	return 1;
}
COMMAND:uninvite(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerFaction(iPlayer) != GetPlayerFaction(playerid)) return SendClientError(playerid, "Player is not in your faction!");
	if(PlayerInfo[iPlayer][ranklvl] == 0) return SendClientError(playerid, "Can't uninvite Tier 0 people!");
	Uninvite(iPlayer, PlayerName(playerid));
	return 1;
}
COMMAND:ouninvite(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer[ MAX_PLAYER_NAME ];
	if( sscanf ( params, "s", iPlayer)) return SCP(playerid, "[Exact_Name]");
	if(GetPlayerId(iPlayer) != INVALID_PLAYER_ID) return SendClientError(playerid, "That player is connected! Use /uninvite!");
	if(!AccountExist(iPlayer)) return SendClientError(playerid, "Account is not registered!");
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `FactionID` FROM `PlayerInfo` WHERE `PlayerName` = '%e'", iPlayer);
	mysql_tquery(MySQLPipeline, iQuery, "OfflineUninviteResponse", "ds", playerid, iPlayer);
	return 1;
}
COMMAND:setfreq(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new tmpfreq;
	if( sscanf ( params, "d", tmpfreq)) return SCP(playerid, "[freq]");
	if(tmpfreq < 100000 || tmpfreq > 999999) return SendClientError(playerid, "Invalid frequency submitted!");
	format(iStr,sizeof(iStr),"..:: %s frequency has been changed to: %d ::..", GetPlayerFactionName(playerid), tmpfreq);
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE),
	FactionInfo[PlayerInfo[playerid][playerteam]][fFreq] = tmpfreq;
	return 1;
}
/*COMMAND:news(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iSlot, iText[ 128 ];
	if(sscanf(params, "ds", iSlot, iText)) return SCP(playerid, "[slot(1-7)] [message]");
	if(iSlot < 1 || iSlot > 7)  return SCP(playerid, "[slot(1-7)] [message]");
	new tmp[ 7 ], iFile[ 34 ];
	format(tmp, sizeof(tmp), "news%d", iSlot);
	format(iFile, sizeof(iFile), "Team-%s", PlayerInfo[playerid][PTeamName]);
	dini_Set(iFile, tmp, iText);
	SendClientMSG(playerid, COLOR_GM_ADMIN, "[%s] News ID %d: %s", PlayerInfo[playerid][PTeamName], iSlot, iText);
	return 1;
}*/
COMMAND:fstartrank(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0 || PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iRank[64];
	if( sscanf ( params, "s", iRank)) return SCP(playerid, "[rankname]");
	if(strfind(iRank, "'", true) != -1 || strfind(iRank, "=", true) != -1 || strfind(iRank, "|", true) != -1 || strlen(iRank) >= 64)
		return SendClientError(playerid, "Invalid character(s) used (~,=,|)");
	myStrcpy(FactionInfo[PlayerInfo[playerid][playerteam]][fStartrank], iRank);
	format(iStr, sizeof(iStr), "# [%s] %s has set invite-rank to %s.", GetPlayerFactionName(playerid), RPName(playerid),  iRank);
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:fstartpayment(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0 || PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iRank;
	if( sscanf ( params, "d", iRank)) return SCP(playerid, "[amount] (500$ max)");
	if(iRank < 0 || iRank > 500) return SendClientError(playerid, "Invalid amount specified.");
	FactionInfo[PlayerInfo[playerid][playerteam]][fStartpayment] = iRank;
	format(iStr, sizeof(iStr), "# [%s] %s has set invite-payment to $%s.", GetPlayerFactionName(playerid), RPName(playerid),  number_format(iRank));
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:setrank(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iRank[64];
	if( sscanf ( params, "us", iPlayer, iRank)) return SCP(playerid, "[PlayerID/PartOfName] [rankname]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerFaction(playerid) != GetPlayerFaction(iPlayer)) return SendClientError(playerid, "Not in the same faction!");
	if(strfind(iRank, "'", true) != -1 || strfind(iRank, "=", true) != -1 || strfind(iRank, "|", true) != -1 || strlen(iRank) >= 64)
	{
		return SendClientError(playerid, "Invalid character(s) used (~,=,|)");
	}
	myStrcpy(PlayerInfo[iPlayer][rankname], iRank);
	format(iStr, sizeof(iStr), "10[RANK] %s has set the rank of %s to %s", PlayerName(playerid), PlayerName(iPlayer), iRank);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has set the rank of %s to %s.", GetPlayerFactionName(playerid), RPName(playerid), RPName(iPlayer), iRank);
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:fslotsupgrade(playerid, params[])
{
	if(GetPlayerFaction(playerid) == CIV) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
    if(PlayerTemp[playerid][sm] < 100000) return SendClientError(playerid, "You need $100.000!");
	new facid = PlayerInfo[playerid][playerteam];
	if(FactionInfo[facid][fPoints] >= 30)
	{
		FactionInfo[facid][fMaxMemberSlots]++;
		FactionInfo[facid][fPoints] -= 30;
	}
	else return SendClientError(playerid, "Your faction needs at least 30 fpoints.");
	SendClientMessage(playerid, COLOR_HELPEROOC, " Congratulations, the member amount has been upgraded. See /finfo for the current status.");
	format(iStr, sizeof(iStr), "# [%s] %s %s has upgraded the member slots (+1 slots).", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid));
	SendClientMessageToTeam(facid,iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:fstockupgrade(playerid, params[])
{
	if(GetPlayerFaction(playerid) == CIV) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
    if(PlayerTemp[playerid][sm] < 200000) return SendClientError(playerid, "You need $200.000!");
	new facid = PlayerInfo[playerid][playerteam];
	if(FactionInfo[facid][fPoints] >= 60)
	{
		FactionInfo[facid][fStockLevel] += 20;
		FactionInfo[facid][fPoints] -= 60;
	}
	else return SendClientError(playerid, "Your faction needs at least 60 fpoints.");
	SendClientMessage(playerid, COLOR_HELPEROOC, " Congratulations, the stock amount has been upgraded. See /finfo for the current status.");
	format(iStr, sizeof(iStr), "# [%s] %s %s has upgraded the factionstock (+20 stockplace).", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid));
	SendClientMessageToTeam(facid, iStr, COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:fstocktog(playerid, params[])
{
	if(GetPlayerFaction(playerid) == CIV) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	new facid = PlayerInfo[playerid][playerteam], wat[ 20 ];
	if(HQInfo[facid][fHQStockTog] == true)
	{
		HQInfo[facid][fHQStockTog] = false;
	    myStrcpy(wat, "disabled");
	}
	else 
	{
		HQInfo[facid][fHQStockTog] = true;
	    myStrcpy(wat, "enabled");
	}
	format(iStr, sizeof(iStr), "# [%s] %s has %s the faction gun stock.", GetPlayerFactionName(playerid), PlayerName(playerid), wat);
	SendClientMessageToTeam(facid, iStr, COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:ftog(playerid, params[])
{
	if(GetPlayerFaction(playerid) == CIV) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 1) return SendClientError(playerid, CANT_USE_CMD);
	new facid = PlayerInfo[playerid][playerteam], wat[ 20 ];
	if(FactionInfo[facid][fTogChat] == true)
	{
	    FactionInfo[facid][fTogChat] = false;
	    myStrcpy(wat, "disabled");
	}
	else
	{
	    FactionInfo[facid][fTogChat] = true;
	    myStrcpy(wat, "enabled");
	}
	format(iStr, sizeof(iStr), "# [%s] %s has %s the OOC faction chat.", GetPlayerFactionName(playerid), PlayerName(playerid), wat);
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:ftogcol(playerid, params[])
{
	if(GetPlayerFaction(playerid) == CIV) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 0) return SendClientError(playerid, CANT_USE_CMD);
	new facid = PlayerInfo[playerid][playerteam], wat[ 20 ];
	if(FactionInfo[facid][fTogColour] == true)
	{
		FactionInfo[facid][fTogColour] = false;
	    myStrcpy(wat, "disabled");
	}
	else
	{
	    FactionInfo[facid][fTogColour] = true;
	    myStrcpy(wat, "enabled");
	}
	format(iStr, sizeof(iStr), "# [%s] %s has %s the faction colour.", GetPlayerFactionName(playerid), PlayerName(playerid), wat);
	SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:get(playerid, params[])
{
	if(!IsPlayerFED(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!PlayerTemp[iPlayer][tazed] && !PlayerTemp[iPlayer][cuffed]) return SendClientError(playerid, "Player not tazed nor cuffed!");
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 6) return SendClientError(playerid, "He is too far away!");
	format(iStr, sizeof(iStr), "has forced %s into their %s.", MaskedName(iPlayer), GetVehicleName(GetPlayerVehicleID(playerid)));
	Action(playerid, iStr);
	PutPlayerInVehicle(iPlayer, GetPlayerVehicleID(playerid), 2);
	TogglePlayerControllable(iPlayer,false);
	return 1;
}
COMMAND:cuff(playerid, params[])
{
	if(!IsPlayerFED(playerid) && GetAdminLevel(playerid) < 10) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(iPlayer) == GetPlayerVehicleID(playerid) && GetPlayerState(iPlayer) != PLAYER_STATE_DRIVER || PlayerTemp[iPlayer][tazed] == 1 && GetDistanceBetweenPlayers(playerid, iPlayer) < 5 && GetPlayerState(iPlayer) != PLAYER_STATE_DRIVER)
	{
		format(iStr,sizeof(iStr),"%s has cuffed %s.", RPName(playerid), MaskedName(iPlayer));
		NearMessage(playerid,iStr,COLOR_ME);
		TogglePlayerControllable(iPlayer,false);
		PlayerTemp[iPlayer][cuffed] = true;
		PlayerTemp[iPlayer][tazed]=0;
		SetPlayerSpecialAction(iPlayer, SPECIAL_ACTION_CUFFED);
		SetPlayerAttachedObject(iPlayer, 0, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
		GameTextForPlayer(iPlayer,"You have been cuffed",3000,5);
		format(iStr, sizeof(iStr), "6{CUFF} %s[%d] has been cuffed by %s[%d]",PlayerName(iPlayer),iPlayer, PlayerName(playerid), playerid);
		iEcho(iStr);
	}
	else SendClientError(playerid, " You can't cuff that person.");
	return 1;
}
COMMAND:uncuff(playerid, params[])
{
	if(!IsPlayerFED(playerid) && GetAdminLevel(playerid) < 6) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(iPlayer)==GetPlayerVehicleID(playerid) || GetDistanceBetweenPlayers(playerid, iPlayer) < 5)
	{
		format(iStr,sizeof(iStr),"%s has uncuffed %s",RPName(playerid),MaskedName(iPlayer));
		NearMessage(playerid,iStr,COLOR_ME);
		TogglePlayerControllable(iPlayer,true);
		PlayerTemp[iPlayer][cuffed] = true;
		PlayerTemp[iPlayer][tazed]=0;
		SetPlayerSpecialAction(iPlayer,SPECIAL_ACTION_NONE);
		for(new i=0; i<MAX_PLAYER_ATTACHED_OBJECTS; i++)
		{
       		if(IsPlayerAttachedObjectSlotUsed(iPlayer, i)) RemovePlayerAttachedObject(iPlayer, i);
		}
		format(iStr, sizeof(iStr), "6{UNCUFF} %s[%d] has been un-cuffed by %s[%d]",PlayerName(iPlayer),iPlayer, PlayerName(playerid), playerid);
		iEcho(iStr);
		DeletePVar(iPlayer, "Tied");
	}
	else SendClientError(playerid, " You can't un-cuff that person.");
	return 1;
}
/*COMMAND:osetrank(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iRank[64];
	if( sscanf ( params, "us", iPlayer, iRank) || strlen(params) > MAX_PLAYER_NAME) return SCP(playerid, "[Exactly Name] [rankname]");
	if(GetPlayerFaction(playerid) != GetPlayerFaction(iPlayer)) return SendClientError(playerid, "Not in the same faction!");
	if(strfind(iRank, "'", true) != -1 || strfind(iRank, "=", true) != -1 || strfind(iRank, "|", true) != -1 || strlen(iRank) >= 64)
	{
		return SendClientError(playerid, "Invalid character(s) used (~,=,|)");
	}
	myStrcpy(PlayerInfo[iPlayer][rankname], iRank);
	format(iStr, sizeof(iStr), "10[RANK] %s has offline set the rank of %s to %s", PlayerName(playerid), PlayerName(iPlayer), iRank);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has offline set the rank of %s to %s.", GetPlayerFactionName(playerid), RPName(playerid), RPName(iPlayer), iRank);
	SendClientMessageToTeam(PlayerInfo[iPlayer][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:osettier(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iTier;
	if( sscanf ( params, "ud", iPlayer, iTier) || strlen(params) > MAX_PLAYER_NAME) return SCP(playerid, "[Exact Name] [Tier (0-2)]");
//	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerFaction(playerid) != GetPlayerFaction(iPlayer)) return SendClientError(playerid, "Not in the same faction!");
	if(iTier < 0 || iTier > 2) return SCP(playerid, "[Exactly Name] [Tier (0-2)]");
	PlayerInfo[iPlayer][ranklvl] = iTier;
	format(iStr, sizeof(iStr), "10[TIER] %s has offline setted the tier of %s to %d", PlayerName(playerid), PlayerName(iPlayer), iTier);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has offline set the tier of %s to %d.", GetPlayerFactionName(playerid), RPName(playerid), RPName(iPlayer), iTier);
	SendClientMessageToTeam(PlayerInfo[iPlayer][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	SetPlayerTeamEx(iPlayer, PlayerInfo[iPlayer][playerteam]);
	PlayerTemp[iPlayer][spawnrdy]=0;
	return 1;
}*/
COMMAND:settier(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iTier;
	if( sscanf ( params, "ud", iPlayer, iTier)) return SCP(playerid, "[PlayerID/PartOfName] [Tier (0-2)]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerFaction(playerid) != GetPlayerFaction(iPlayer)) return SendClientError(playerid, "Not in the same faction!");
	if(iTier < 0 || iTier > 2) return SCP(playerid, "[PlayerID/PartOfName] [Tier (0-2)]");
	PlayerInfo[iPlayer][ranklvl] = iTier;
	format(iStr, sizeof(iStr), "10[TIER] %s has set the tier of %s to %d", PlayerName(playerid), PlayerName(iPlayer), iTier);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has set the tier of %s to %d.", GetPlayerFactionName(playerid), RPName(playerid), RPName(iPlayer), iTier);
	SendClientMessageToTeam(PlayerInfo[iPlayer][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	SetPlayerTeamEx(iPlayer, PlayerInfo[iPlayer][playerteam]);
	PlayerTemp[iPlayer][spawnrdy]=0;
	return 1;
}
COMMAND:setpayment(playerid, params[])
{
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer, iAmount;
	if( sscanf ( params, "ud", iPlayer, iAmount)) return SCP(playerid, "[PlayerID/PartOfName] [amount]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPlayerFaction(playerid) != GetPlayerFaction(iPlayer)) return SendClientError(playerid, "Not in the same faction!");
	if(iAmount < 0 || iAmount > 500) return SCP(playerid, "[PlayerID/PartOfName] [amount] (MAX amount is $500)");
	PlayerInfo[iPlayer][fpay] = iAmount;
	format(iStr, sizeof(iStr), "10[FPAY] %s has set the payment of %s to $%d", PlayerName(playerid), PlayerName(iPlayer), iAmount);
	iEcho(iStr);
	format(iStr, sizeof(iStr), "# [%s] %s has set the payment of %s to $%s.", GetPlayerFactionName(iPlayer), RPName(playerid), RPName(iPlayer), number_format(iAmount));
	SendClientMessageToTeam(PlayerInfo[iPlayer][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:fbalance(playerid, params[])
{
	new factionid = PlayerInfo[playerid][playerteam];
	if(factionid == CIV) return SendClientError(playerid, "You need to be in a faction to use this!");
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, "Your tier is too low to use this command!");
	new tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
	    new amount = FactionInfo[factionid][fBank];
		SendClientMSG(playerid, COLOR_YELLOW, "[FBANK] %s Balance: $%s", GetPlayerFactionName(playerid), number_format(amount));
		format(iStr,sizeof(iStr),"14[FBANK] %s has checked the %s balance: $%d", PlayerName(playerid), GetPlayerFactionName(playerid), amount);
		iEcho(iStr);
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:fwithdraw(playerid, params[])
{
	new factionid = PlayerInfo[playerid][playerteam];
	if(factionid == CIV) return SendClientError(playerid, "You need to be in a faction to use this!");
    if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, "Your tier is too low to use this command!");
	new amount, tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
	    new balance = FactionInfo[factionid][fBank];
		if( sscanf ( params, "d", amount)) return SCP(playerid, "[amount]");
		if(amount > balance || amount <= 0) return SendClientError(playerid, "You don't have that much money in your faction bank account!");

	    GivePlayerMoneyEx(playerid,amount);
		FactionInfo[factionid][fBank] = balance-amount;
		SaveFaction(factionid);
		SendClientMSG(playerid, COLOR_YELLOW, "[FBANK] Withdrawn: $%s | Old FBalance: $%s | New FBalance: $%s", number_format(amount), number_format(balance), number_format(balance-amount));
		if(IsAtATM(playerid))
		{
			new amount2 = (amount/100)*1;
			SendClientMSG(playerid, COLOR_YELLOW,"[ATM] Paid $%s (1%%) of fees for the usage.",number_format(amount2));
			GivePlayerMoneyEx(playerid, -amount2);
		}
		format(iStr,sizeof(iStr),"14[FBANK] %s has f-withdrawn $%d. %s NEW FBalance: $%d", PlayerName(playerid), amount, GetPlayerFactionName(playerid), balance-amount);
		iEcho(iStr);
		AppendTo(moneylog,iStr);
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:fdeposit(playerid, params[])
{
	new factionid = PlayerInfo[playerid][playerteam];
	if(factionid == CIV) return SendClientError(playerid, "You need to be inside a faction to use this!");
	new amount, tmpid=IsPlayerInBiz(playerid);
	if(tmpid != -1 && BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && GetPlayerVirtualWorld(playerid) == tmpid+1 || IsAtATM(playerid))
	{
	    new balance = FactionInfo[factionid][fBank];

		if( sscanf ( params, "d", amount)) return SCP(playerid, "[amount]");
		if(amount > HandMoney(playerid) || amount <= 0) return SendClientError(playerid, "You don't have that much money in your hand!");

	    GivePlayerMoneyEx(playerid,-amount);
		FactionInfo[factionid][fBank] += amount;
		SendClientMSG(playerid, COLOR_YELLOW, "[FBANK] Deposit: $%s | Old FBalance: $%s | New FBalance: $%s", number_format(amount), number_format(balance), number_format(balance+amount));
		if(IsAtATM(playerid))
		{
			new amount2 = (amount/100)*1;
			SendClientMSG(playerid, COLOR_YELLOW,"[ATM] Paid $%s (1%%) of fees for the usage.",number_format(amount2));
			GivePlayerMoneyEx(playerid, -amount2);
		}
		format(iStr,sizeof(iStr),"14[FBANK] %s has f-depositted $%d. %s NEW FBalance: $%d", PlayerName(playerid), amount, GetPlayerFactionName(playerid), balance+amount);
		iEcho(iStr);
		AppendTo(moneylog,iStr);
	}
	else
	{
	    new iiq = GetClosestATM(playerid);
	    if(iiq == -1) return SendClientInfo(playerid, "No ATM found!");
	    SendClientInfo(playerid, "Marker set to the closest ATM Machine.");
	    SetPlayerCheckpoint(playerid, ATMInfo[iiq][atmX], ATMInfo[iiq][atmY], ATMInfo[iiq][atmZ], 2.0);
	}
    return 1;
}
COMMAND:roof(playerid, params[])
{
	new isatentrance;
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(HQInfo[f][hqActive] != true) continue;
		if(IsPlayerInRangeOfPoint(playerid,5.0, HQInfo[f][fSpawnX], HQInfo[f][fSpawnY], HQInfo[f][fSpawnZ]) && GetPlayerVirtualWorld(playerid) == HQInfo[f][fSpawnVW] && GetPlayerInterior(playerid) == HQInfo[f][fSpawnInt])
		{
			isatentrance = 1;
			if(PlayerInfo[playerid][playerteam] == f || PlayerInfo[playerid][power]>=10 || HQInfo[f][hqOpen] == true)
			{
				return SetPlayerPosEx(playerid, HQInfo[f][fHQRoofX], HQInfo[f][fHQRoofY], HQInfo[f][fHQRoofZ]);
			}
			else SendClientError(playerid,  "You are not allowed to enter the roof at this time!");
		}
	}
	if(isatentrance == 0) return SendClientError(playerid, "You need to be inside a faction HQ to use this!");
	return 1;
}
COMMAND:givegun(playerid, params[])
{
	if(IsPlayerFED(playerid))
	{
		if(IsAtArmoury(playerid) && !IsPlayerInAnyVehicle(playerid))
		{
			ShowDialog(playerid, DIALOG_GIVEGUN);
		}
		else return SendClientError(playerid, "You need to be at the armoury to use this.");
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:house(playerid, params[])
{
	new iChoice[20], iChoice2[MAX_PLAYER_NAME], tmpid = IsPlayerOutHouse(playerid);
	if( sscanf ( params, "sz", iChoice, iChoice2))
	{
		if(PlayerTemp[playerid][tmphouse] != -1) // player is in house!
		{
			ShowDialog(playerid, DIALOG_MNG_CATE_IN);
			return 1;
		}
		else
		{
			if(!PlayerInfo[playerid][power]) return SCP(playerid, "[ upgrade / rent / sell / unsell / buy / lock / unlock / rentroom / help / evict / furniture ]");
			else return SCP(playerid, "[ upgrade / rent / sell / unsell / buy / lock / unlock / rentroom / help / evict / furniture / create / delete / move / owner / info ]");
		}
	}//else if(!strcmp(tmp, "biz", true, 3))
	if(strcmp(iChoice,"upgrade",true)==0)
	{
		if(tmpid == -1) return SendClientError(playerid, "You are not standing at any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		ShowDialog(playerid, DIALOG_UPGRADE_H);
	    return 1;
	}
	else if(strcmp(iChoice,"rent",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		if(!strlen(iChoice2) || !IsNumeric(iChoice2)) return SCP(playerid, "rent [Price]");
		new iPrice = strval(iChoice2);
		if(iPrice <= 0 || iPrice > 15000) return SendClientError(playerid, "House rent limit exceeded, please keep between $0 - $15,000!");
		if(iPrice != 666) SendClientMSG(playerid, COLOR_GREEN, "[HOUSE] Your house ID %d is now rentable for $%s.", tmpid, number_format(iPrice));
		if(iPrice == 666) HouseInfo[tmpid][hRentable] = false;
		else HouseInfo[tmpid][hRentable] = true;
		HouseInfo[tmpid][hRentprice] = iPrice;
		SaveHouse(tmpid);
		UpdateHouse(tmpid);
		return 1;
	}
	else if(strcmp(iChoice,"sell",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		if(!strlen(iChoice2) || !IsNumeric(iChoice2)) return SCP(playerid, "sell [Price]");
		new iPrice = strval(iChoice2);
		if(iPrice < MIN_H_SELL || iPrice > MAX_H_SELL)
		{
			new iStrr[128];
			format(iStrr, sizeof(iStrr), "Invalid sell price, please keep between $%s - $%s.", number_format(MIN_H_SELL), number_format(MAX_H_SELL));
			SendClientError(playerid, iStrr);
			return 1;
		}
		SendClientMSG(playerid, COLOR_GREEN, "[HOUSE] Your house ID %d is now on sale for $%s.", tmpid, number_format(iPrice));
		HouseInfo[tmpid][hBuyable] = true;
		HouseInfo[tmpid][hSellprice] = iPrice;
		SaveHouse(tmpid);
		UpdateHouse(tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"unsell",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		SendClientMSG(playerid, COLOR_GREEN, "[HOUSE] Your house ID %d is nolonger on sale.", tmpid);
		HouseInfo[tmpid][hBuyable] = false;
		SaveHouse(tmpid);
		UpdateHouse(tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"buy",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(GetPlayerHouses(playerid) >= 10 && PlayerInfo[playerid][premium] == 0) return SendClientError(playerid, "You cannot own more than 10 houses unless are a donator.");
		if(GetPlayerHouses(playerid) >= 14) return SendClientError(playerid, "You cannot own more then 13 houses.");
		if(HouseInfo[tmpid][hBuyable] == false) return SendClientError(playerid, "This house is not on sale!");
		new fullprice = HouseInfo[tmpid][hSellprice];
		if(HandMoney(playerid) < fullprice) return SendClientError(playerid, "You don't have enough money on your hand!");
		SetBank(PlayerName(playerid), HouseInfo[tmpid][hOwner], fullprice);
		HouseInfo[tmpid][hBuyable] = false;
		SendClientMSG(playerid, COLOR_GREEN, "[HOUSE] Congratulations, you have bought house ID #%d! (Screenshot: F8)", tmpid);
		format(iStr, sizeof(iStr), "6[HOUSE] %s has bought a house (ID: #%d) for $%s from %s.", PlayerName(playerid), tmpid, number_format(fullprice), HouseInfo[tmpid][hOwner]);
		iEcho(iStr);
		AppendTo(moneylog, iStr);
		myStrcpy(HouseInfo[tmpid][hOwner], PlayerName(playerid));
		SaveHouse(tmpid);
		UpdateHouse(tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"lock",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		if(HouseInfo[tmpid][hClosed] == true) return SendClientError(playerid, "This house is already closed!");
		HouseInfo[tmpid][hClosed] = true;
		GameTextForPlayer(playerid,"~w~House~n~~g~closed",3000, 1);
		SaveHouse(tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"unlock",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		if(HouseInfo[tmpid][hClosed] == false) return SendClientError(playerid, "This house is already opened!");
		HouseInfo[tmpid][hClosed] = false;
		GameTextForPlayer(playerid,"~w~House~n~~g~opened",3000, 1);
		SaveHouse(tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"rentroom",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		new rentpricezz = HouseInfo[tmpid][hRentprice];
		if(rentpricezz == 666) return SendClientError(playerid, "You cannot rent here!");
		if(PlayerInfo[playerid][housenum] == tmpid) return SendClientWarning(playerid, "You already rent here!");
		if(HandMoney(playerid) < rentpricezz)
			return SendClientError(playerid, "You don't have enough money on hand!");
			
		new tmpint = HouseInfo[tmpid][hInteriorPack];
		HouseInfo[tmpid][hTill] += rentpricezz;
		PlayerInfo[playerid][housenum]=tmpid;
		PlayerInfo[playerid][rentprice]=rentpricezz;
		GivePlayerMoneyEx(playerid, -rentpricezz);
		SetSpawnInfo(playerid, CIV, PlayerInfo[playerid][Skin], IntInfo[tmpint][intX], IntInfo[tmpint][intY], IntInfo[tmpint][intZ], 0, 0, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, COLOR_HELPEROOC, "[HOUSE] Congratulations, you have rented a room in here.");
		SendClientMessage(playerid, COLOR_LIGHTGREY, " From now on your will spawn here, use /unrent to disable it.");
		SaveHouse(tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"help",true)==0)
	{
	    return 1;
	}
	else if(strcmp(iChoice,"evict",true)==0)
	{
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		if(!strlen(iChoice2) || strlen(iChoice2) > MAX_PLAYER_NAME || IsNumeric(iChoice2)) return SCP(playerid, "evict [Player_Name]");
		if(GetPlayerId(iChoice2) != INVALID_PLAYER_ID) return SendClientError(playerid, "That player is currently online. Use it when he's offline!");
		new iQuery[128];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `RentHouse` FROM `PlayerInfo` WHERE `PlayerName` = '%e'", iChoice2);
		mysql_tquery(MySQLPipeline, iQuery, "EvictCommandResponse", "dsd", playerid, iChoice2, tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"furniture",true)==0)
	{
		tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not in any house!");
		if(strcmp(HouseInfo[tmpid][hOwner], PlayerName(playerid), false) && PlayerInfo[playerid][power] < 10) return SendClientError(playerid, "You don't own this house!");
		ShowDialog(playerid, DIALOG_FURNITURE);
	    return 1;
	}
	/*
		[ADMIN]
	*/
		/* format(filename, 20, "Houses/Casa%d.txt", iID);
	new Float:ppx, Float:ppy, Float:ppz;
	GetPlayerPos(playerid, ppx, ppy, ppz);
	dini_FloatSet(filename, "x", ppx);
	dini_FloatSet(filename, "y", ppy);
	dini_FloatSet(filename, "z", ppz);
	House[iID][House_x] = ppx;
	House[iID][House_y] = ppy;
	House[iID][House_z] = ppz;
	UpdateHouse(iID);//, 1); */
	else if(strcmp(iChoice,"move",true)==0)
	{
		if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(iChoice2) || !IsNumeric(iChoice2)) return SCP(playerid, "move [House ID]");
		new iHouse = strval(iChoice2);
		if(HouseInfo[iHouse][hActive] != true) return SCP(playerid, "Invalid house ID! (Non Existant)");
		new Float:ppx, Float:ppy, Float:ppz;
		GetPlayerPos(playerid, ppx, ppy, ppz);
		HouseInfo[iHouse][hX] = ppx;
		HouseInfo[iHouse][hY] = ppy;
		HouseInfo[iHouse][hZ] = ppz;
		SaveHouse(tmpid);
		UpdateHouse(tmpid);
		//SetTimerEx("UpdateHouse", 1000, 0, "tmpid");
	    return 1;
	}
	else if(strcmp(iChoice,"create",true)==0)
	{
		if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		CreateHouse("NoBodY", x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	    return 1;
	}
	else if(strcmp(iChoice,"delete",true)==0)
	{
		if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
		if(!strlen(iChoice2) || !IsNumeric(iChoice2)) return SCP(playerid, "delete [House ID]");
		new iHouse = strval(iChoice2);
		if(HouseInfo[iHouse][hActive] != true) return SCP(playerid, "Invalid house ID! (Non Existant)");
		DeleteHouse(iHouse);
	    return 1;
	}
	else if(strcmp(iChoice,"owner",true)==0)
	{
		if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
		if(tmpid == -1 && PlayerTemp[playerid][tmphouse] != -1) tmpid = PlayerTemp[playerid][tmphouse];
		if(tmpid == -1) return SendClientError(playerid, "You're not at any house!");
		if(!strlen(iChoice2) || strlen(iChoice2) > MAX_PLAYER_NAME || IsNumeric(iChoice2)) return SCP(playerid, "owner [Player_Name]");
		if(strlen(iChoice2) > MAX_PLAYER_NAME) return SCP(playerid, "owner [Fullname_Lastname]");
		myStrcpy(HouseInfo[tmpid][hOwner], iChoice2);
		SaveHouse(tmpid);
		UpdateHouse(tmpid);
	    return 1;
	}
	else if(strcmp(iChoice,"info",true)==0)
	{
	    return 1;
	}
	else
	{
		if(!PlayerInfo[playerid][power]) return SCP(playerid, "[ upgrade / rent / sell / unsell / buy / lock / unlock / rentroom / help / evict / furniture ]");
		else return SCP(playerid, "[ upgrade / rent / sell / unsell / buy / lock / unlock / rentroom / help / evict / furniture / create / delete / move / owner / info ]");
	}
}
COMMAND:houselocker(playerid, params[]) // better than w00ts
{
	new houseid = PlayerTemp[playerid][tmphouse];
	if(houseid == -1) return SendClientError(playerid, "You need to be inside a house to use this!");
	new iChoice[20], iChoice2[20], iChoice3[20];
	if(sscanf(params, "szz", iChoice, iChoice2, iChoice3)) return SCP(playerid, "[ lock / unlock / store / take ]");
	if(strcmp(iChoice, "lock", true) == 0)
	{
		if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0)
		{
			if(HouseInfo[houseid][hLocker] == true) return SendClientError(playerid, "The houselocker is already locked!");
			else
			{
				HouseInfo[houseid][hLocker] = true;
				Action(playerid, "takes out some keys and locks the houselocker.");
			}
		}
		else return SendClientError(playerid, "You do not own this house!");
	}
	else if(strcmp(iChoice, "unlock", true) == 0)
	{
		if(strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), true) == 0)
		{
			if(HouseInfo[houseid][hLocker] == true)
			{
				HouseInfo[houseid][hLocker] = false;
				Action(playerid, "takes out some keys and unlocks the houselocker.");
			}
			else return SendClientError(playerid, "The houselocker is already unlocked!");
		}
		else return SendClientError(playerid, "You do not own this house!");
	}
	else if(strcmp(iChoice, "take", true) == 0) // /houselocker take materials 15000
	{
		if(HouseInfo[houseid][hLocker] == true) return SendClientError(playerid, "The houselocker is currently locked!");
		else
		{
			if(!strlen(iChoice2) || IsNumeric(iChoice2) || !strlen(iChoice3) || !IsNumeric(iChoice3)) return SCP(playerid, "take [ materials / sdrugs / cash ] [ Amount ]");
			new iAmount = strval(iChoice3);
			if(strcmp(iChoice2, "materials", true) == 0)
			{
				if(HouseInfo[houseid][hSGuns] < iAmount || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "materials [ Amount ]");
				HouseInfo[houseid][hSGuns] -= iAmount;
				PlayerInfo[playerid][sdrugs] += iAmount;
				SendClientMSG(playerid, COLOR_GREY, "You have taken a total of %s materials from this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is currently %s left inside this house!", number_format(HouseInfo[houseid][hSGuns]));
				SaveHouse(houseid);
				return 1;
			}
			else if(strcmp(iChoice2, "sdrugs", true) == 0)
			{
				if(HouseInfo[houseid][hSDrugs] < iAmount || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "sdrugs [ Amount ]");
				HouseInfo[houseid][hSDrugs] -= iAmount;
				PlayerInfo[playerid][sdrugs] += iAmount;
				SendClientMSG(playerid, COLOR_GREY, "You have taken a total of %s sellable drugs from this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is currently %s sellable drugs left inside this house.", number_format(HouseInfo[houseid][hSDrugs]));
				SaveHouse(houseid);
			}
			else if(strcmp(iChoice2, "cash", true) == 0)
			{
				if(HouseInfo[houseid][hCash] < iAmount || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "cash [ Amount ]");
				HouseInfo[houseid][hCash] -= iAmount;
				GivePlayerMoneyEx(playerid, iAmount);
				SendClientMSG(playerid, COLOR_GREY, "You have taken a total of $%s from this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is currently $%s left inside this house!", number_format(HouseInfo[houseid][hCash]));
				SaveHouse(houseid);
			}
/*			else if(strcmp(iChoice2, "weapon", true) == 0)
			{
				if(iAmount > PlayerTemp[playerid][sm] || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "weapon [ Slot ]");
				HouseInfo[houseid][hCash] += iAmount;
				GivePlayerMoneyEx(playerid, -iAmount);
				SendClientMSG(playerid, COLOR_GREY, "You have stored a $%s inside this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is now a total of $%s inside this house!", number_format(HouseInfo[houseid][hSGuns]));
				SaveHouse(houseid);
			}*/
			else return SCP(playerid, "take [ materials / sdrugs / cash ] [ Amount ]");
		}
	}
	else if(strcmp(iChoice, "store", true) == 0)
	{
		if(HouseInfo[houseid][hLocker] == true) return SendClientError(playerid, "The houselocker is currently locked!");
		else
		{
			if(!strlen(iChoice2) || IsNumeric(iChoice2) || !strlen(iChoice3) || !IsNumeric(iChoice3)) return SCP(playerid, "store [ materials / sdrugs / cash ] [ Amount ]");
			new iAmount = strval(iChoice3);
			if(strcmp(iChoice2, "materials", true) == 0)
			{
				if(iAmount > PlayerInfo[playerid][sMaterials] || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "materials [ Amount ]");
				HouseInfo[houseid][hSGuns] += iAmount;
				PlayerInfo[playerid][sMaterials] -= iAmount;
				SendClientMSG(playerid, COLOR_GREY, "You have stored a total of %s materials inside this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is now a total of %s materials inside this house!", number_format(HouseInfo[houseid][hSGuns]));
				SaveHouse(houseid);
				return 1;
			}
			else if(strcmp(iChoice2, "sdrugs", true) == 0)
			{
				if(iAmount > PlayerInfo[playerid][sdrugs] || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "sdrugs [ Amount ]");
				HouseInfo[houseid][hSDrugs] += iAmount;
				PlayerInfo[playerid][sdrugs] -= iAmount;
				SendClientMSG(playerid, COLOR_GREY, "You have stored a total of %s sellable drugs inside this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is now a total of %s sellable drugs inside this house!", number_format(HouseInfo[houseid][hSGuns]));
				SaveHouse(houseid);
			}
			else if(strcmp(iChoice2, "cash", true) == 0)
			{
				if(iAmount > PlayerTemp[playerid][sm] || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "cash [ Amount ]");
				HouseInfo[houseid][hCash] += iAmount;
				GivePlayerMoneyEx(playerid, -iAmount);
				SendClientMSG(playerid, COLOR_GREY, "You have stored a $%s inside this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is now a total of $%s inside this house!", number_format(HouseInfo[houseid][hSGuns]));
				SaveHouse(houseid);
			}
/*			else if(strcmp(iChoice2, "weapon", true) == 0)
			{
				if(iAmount > PlayerTemp[playerid][sm] || iAmount < 0 || iAmount >= 10000000) return SCP(playerid, "weapon [ Slot ]");
				HouseInfo[houseid][hCash] += iAmount;
				GivePlayerMoneyEx(playerid, -iAmount);
				SendClientMSG(playerid, COLOR_GREY, "You have stored a $%s inside this house!", number_format(iAmount));
				SendClientMSG(playerid, COLOR_GREY, "There is now a total of $%s inside this house!", number_format(HouseInfo[houseid][hSGuns]));
				SaveHouse(houseid);
			}*/
			else return SCP(playerid, "store [ materials / sdrugs / cash ] [ Amount ]");
		}
	}
	else return SCP(playerid, "[ lock / unlock / store / take ]");
	return 1;
}
COMMAND:unrent(playerid, params[])
{
	PlayerInfo[playerid][rentprice] = 0;
	PlayerInfo[playerid][housenum] = -1;
	SendClientInfo(playerid, "Succesfully unrented");
	SetSpawnInfo(playerid,CIV,PlayerInfo[playerid][Skin],randomspawn[RSpawnNo][spawnx],randomspawn[RSpawnNo][spawny],randomspawn[RSpawnNo][spawnz],randomspawn[RSpawnNo][spawna],0,0,0,0,0,0);
	RSpawnNo++; if(RSpawnNo>sizeof(randomspawn)-1) RSpawnNo=0;
	return 1;
}
COMMAND:heal(playerid, params[])
{
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
	if(PlayerTemp[playerid][tmphouse] != -1)
	{
		if(HouseInfo[PlayerTemp[playerid][tmphouse]][hArmour] == 0)
		{
			Healing(playerid, x, y, 1);
		}
		else
		{
			Healing(playerid, x, y, 2);
		}
		return 1;
	}
	else if(IsPlayerFED(playerid) && IsAtArmoury(playerid) && !IsPlayerInAnyVehicle(playerid))
	{
		if(IsPlayerFED(playerid))
		{
			Healing(playerid, x, y, 2);
		}
	}
	else return SendClientError(playerid, "You need to be inside a house to use this.");
	return 1;
}
COMMAND:startharvest(playerid, params[])
{
	if(PlayerInfo[playerid][playerteam] != CIV)
		return SendClientError(playerid, "This job is only for civilians!");
    if(strcmp(PlayerInfo[playerid][job],"Farmer"))
		return SendClientError(playerid, "You are not a farmer!");
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 532)
		return SendClientError(playerid, "You are not in a combine harvester!");

    SetPVarInt(playerid, "HarvestCP", 1);
    new cnt = GetPVarInt(playerid, "HarvestCP");
    SetPlayerCheckpoint(playerid, FarmPlaces[cnt][0],FarmPlaces[cnt][1],FarmPlaces[cnt][2], 3.0);

    SendClientMessage(playerid, COLOR_YELLOW, "* You have started harvesting! Drive around the checkpoints now.");
    DeletePVar(playerid, "HarvestAmount");

    format(iStr, sizeof(iStr), "~y~harvested:~n~~w~0/13");
    TextDrawSetString(PlayerTemp[playerid][Harvest], iStr);
    TextDrawShowForPlayer(playerid, PlayerTemp[playerid][Harvest]);

	format(iStr, sizeof(iStr), "6[JOB] %s has started harvesting", PlayerName(playerid));
	iEcho(iStr);
	return 1;
}

COMMAND:dropcar(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job], "CarJacker", true)) return SendClientError(playerid, CANT_USE_CMD);
	if(!PlayerTemp[playerid][candrop]) return SendClientError(playerid, "You can drop a car only every 3 minutes!");
	if(!IsPlayerDriver(playerid)) return SendClientError(playerid, "You are not driving any vehicle!");
	new tmp;
	if( sscanf ( params, "d", tmp)) return SCP(playerid, "[1/2]");
	if(tmp < 1 || tmp > 2) return SCP(playerid, "[1/2]");
	if(tmp == 1) SetPlayerCheckpoint(playerid,1607.9749,-1554.2881,13.5823,3); // new: 1607.9749,-1554.2881,13.5823
	else if(tmp == 2) SetPlayerCheckpoint(playerid, 2613.5422,-2226.4785,13.3828,3); // new:2613.5422,-2226.4785,13.3828

	SendClientMessage(playerid,COLOR_WHITE,"[JOB] Now sell the car at the red marker");
	new carstock = dini_Int(compsfile, "cars");
	carstock += 1;
	dini_IntSet(compsfile, "cars", carstock);
	PlayerTemp[playerid][isdropping] = 1;
	return 1;
}

COMMAND:fare(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job], "TaxiDriver", true))
		return SendClientError(playerid, CANT_USE_CMD);
	if(!IsPlayerDriver(playerid))
		return SendClientError(playerid, "You are not driving any vehicle!");
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);

	if(strcmp(VehicleInfo[vehicleid][vJob], "TaxiDriver", true) && VehicleInfo[vehicleid][vReserved] != VEH_RES_OCCUPA)
		return SendClientError(playerid, "This vehicle is not suited for this job.");
	new iAmount;
	if( sscanf ( params, "d", iAmount)) return SCP(playerid, "[amount ($$$)]");
	if(iAmount < 400)  return SCP(playerid, "[amount ($$$)] - Minimum $400!");
	if(iAmount > 1600) return SCP(playerid, "[amount ($$$)] - Maximum $1.600!");
	PlayerTemp[playerid][Duty] = iAmount;
	format(iStr,sizeof(iStr),"*** Taxi Driver %s is now on duty. Fare: $%s - /service taxi ***",RPName(playerid),number_format(PlayerTemp[playerid][Duty]));
	SendClientMessageToAll(COLOR_PLAYER_DARKYELLOW,iStr);
	return 1;
}

COMMAND:dojob(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job], "TaxiDriver", true))
		return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer))
		return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(!PlayerTemp[iPlayer][callingtaxi])
		return SendClientError(playerid, "Player did not call a taxi!");
	new Float:px,Float:py,Float:pz;
	GetPlayerPos(iPlayer,px,py,pz);
	SetPlayerCheckpoint(playerid,px,py,pz,3);
	format(iStr,sizeof(iStr),"taxi driver %s has accepted your call and will be here soon. please stay here and wait.",RPName(playerid));
	ShowInfoBox(iPlayer, "TaxiDriver", iStr);
	SendClientMSG(playerid,COLOR_YELLOW,"* %s(%d) is waiting for your arrival.",RPName(iPlayer),iPlayer);
	PlayerTemp[iPlayer][callingtaxi]=0;
	return 1;
}

COMMAND:loadmoney(playerid, params[])
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || VehicleInfo[vehicleid][vReserved] != VEH_RES_MONEYVAN)
        return SendClientError(playerid, "You are not driving the moneyvan!");
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 7.0, BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ]) && BusinessInfo[b][bType] != BUSINESS_TYPE_BANK)
	    {
	        if(strcmp(PlayerName(playerid),BusinessInfo[b][bOwner],false)==0 || PlayerInfo[playerid][power] > 10)
	        {
	            new tmpcash = BusinessInfo[b][bTill], tax;
	            if(tmpcash <= 0) return SendClientInfo(playerid, "You cannot load minus cash!");
	            new iTax = BusinessInfo[b][bTax];
				if(iTax) tax = (tmpcash * iTax / 100);
				tmpcash -= tax;
				VehicleInfo[vehicleid][vMoney] += tmpcash;
				BusinessInfo[b][bTill] = 0;
				SendClientMSG(playerid, COLOR_HELPEROOC, "..: [MONEYVAN] $%d from the business %s has been loaded into the van. (-$%d taxes)", VehicleInfo[vehicleid][compscar], BusinessInfo[b][bName], tax);
				
				format(iStr,sizeof(iStr),"[BIZ] %s withdrawn $%d from his biz %s ID %d",PlayerName(playerid),VehicleInfo[vehicleid][compscar],BusinessInfo[b][bName],b);
				AppendTo(moneylog,iStr);

				format(iStr, sizeof(iStr), "7.: [LOADMONEY] :. %s has loaded $%d from their business.", PlayerName(playerid), VehicleInfo[vehicleid][compscar]);
				iEcho(iStr);

	        }
	        else return SendClientError(playerid, "You don't own this business!");
	    }
	}
	return 1;
}

COMMAND:unloadmoney(playerid, params[])
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || VehicleInfo[vehicleid][vReserved] != VEH_RES_MONEYVAN)
        return SendClientError(playerid, "You are not driving the moneyvan!");
	if(!VehicleInfo[vehicleid][compscar])
	    return SendClientError(playerid, "There is no money in the van!");
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 7.0, BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ]) && BusinessInfo[b][bType] == BUSINESS_TYPE_BANK)
	    {
	        PlayerInfo[playerid][bank] += VehicleInfo[vehicleid][compscar];
	        SendClientMSG(playerid, COLOR_YELLOW, "$%d has been put into your bank account [Old Balance: $%d | New Balance: $%d]", VehicleInfo[vehicleid][compscar], PlayerInfo[playerid][bank]-VehicleInfo[vehicleid][compscar],PlayerInfo[playerid][bank]);
	        SendClientMessageToAll(COLOR_LIGHTBLUE,"..: Security Van free :..");
	        format(iStr,sizeof(iStr),"[BIZ] %s deposited $%d from security van",PlayerName(playerid),VehicleInfo[vehicleid][compscar]);
			AppendTo(moneylog,iStr);
			format(iStr, sizeof(iStr), "7.: [UNLOADMONEY] :. %s has unloaded $%d to the bank. Old Balance: $%d | New Balance: $%d", PlayerName(playerid), VehicleInfo[vehicleid][compscar], PlayerInfo[playerid][bank]-VehicleInfo[vehicleid][compscar], PlayerInfo[playerid][bank]);
			iEcho(iStr);
			VehicleInfo[vehicleid][vMoney]=0;
		}
	}
	return 1;
}

COMMAND:buyfuel(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 15.0, 2619.2214,-2204.1436,13.1089))
	    return SendClientError(playerid, "You are not at the correct place to use this command!");

	new carid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid) || VehicleInfo[FindVehicleID(carid)][vReserved] != VEH_RES_REFINARY || !IsPlayerDriver(playerid))
	    return SendClientError(playerid, "You are not driving the refinery truck!");

	if(VehicleInfo[FindVehicleID(carid)][compscar] != 0)
	    return SendClientError(playerid, "You already have loaded fuel!");

	new total;
	for(new y; y < sizeof(gasstation); y++)
	{
		if(gasstation[y][benzid] != -1)
		{
		    if(BusinessInfo[gasstation[y][benzid]][bActive] != true) continue;
			new tmpcomps;
			tmpcomps = BusinessInfo[gasstation[y][benzid]][bComps];
			total = total + (MAX_BUSINESS_COMPS - tmpcomps);
		}
	}
	VehicleInfo[FindVehicleID(carid)][compscar] += total;
	GivePlayerMoneyEx(playerid,-(total-(total/2)));
	SendClientMSG(playerid, COLOR_HELPEROOC, "You have loaded %dliter of fuel into the truck. Go /sellfuel now!", total);
	new count;
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(BusinessInfo[b][bType] != BUSINESS_TYPE_GOV) continue;
	    count++;
	}
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(BusinessInfo[b][bType] != BUSINESS_TYPE_GOV) continue;
	    BusinessInfo[b][bTill] += ((total / 2) / count);
	}
	return 1;
}
COMMAND:sellfuel(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(!IsPlayerInAnyVehicle(playerid) || VehicleInfo[vehicleid][vReserved] != VEH_RES_REFINARY || !IsPlayerDriver(playerid) || VehicleInfo[vehicleid][compscar] == 0)
	    return SendClientError(playerid, "You are not driving the refinery truck or you don't have any fuel!");
	for(new y; y < sizeof(gasstation); y++)
	{
		if(gasstation[y][benzid] != -1 && IsPlayerInRangeOfPoint(playerid, gasstation[y][radius], gasstation[y][centerx], gasstation[y][centery], gasstation[y][centerz]) )
		{
			new tmpbank,tmpcomps;
			tmpbank = BusinessInfo[gasstation[y][benzid]][bTill];
			tmpcomps = BusinessInfo[gasstation[y][benzid]][bComps];
			if(tmpcomps == MAX_BUSINESS_COMPS) return SendClientError(playerid, "This business doesn't need any fuel!");
			if(VehicleInfo[vehicleid][compscar] < (MAX_BUSINESS_COMPS-tmpcomps))
			{
				GivePlayerMoneyEx(playerid, VehicleInfo[vehicleid][compscar]);
				BusinessInfo[gasstation[y][benzid]][bComps] += VehicleInfo[vehicleid][compscar];
				tmpbank -= VehicleInfo[vehicleid][compscar];
				BusinessInfo[gasstation[y][benzid]][bTill] = tmpbank;
				SendClientMSG(playerid, COLOR_HELPEROOC, "You have received $%s for refueling the gas station!", number_format(VehicleInfo[vehicleid][compscar]));
				VehicleInfo[vehicleid][compscar] = 0;
				return 1;
			}
			GivePlayerMoneyEx(playerid,MAX_BUSINESS_COMPS-tmpcomps);
			BusinessInfo[gasstation[y][benzid]][bComps] += MAX_BUSINESS_COMPS;
			tmpbank=tmpbank-(MAX_BUSINESS_COMPS-tmpcomps);
			BusinessInfo[gasstation[y][benzid]][bTill] = tmpbank;
			VehicleInfo[vehicleid][compscar] -= MAX_BUSINESS_COMPS - tmpcomps;
			SendClientMSG(playerid, COLOR_HELPEROOC, "You have received $%s for refueling the gas station!", number_format(MAX_BUSINESS_COMPS-tmpcomps));
		}
	}
	return 1;
}
COMMAND:free(playerid, params[])
{
    if(strcmp(PlayerInfo[playerid][job],"Lawyer",true)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(iPlayer == playerid || PlayerInfo[iPlayer][bail] == 777)
	    return SendClientError(playerid, "Worth a try, huh?");
	if(PlayerInfo[iPlayer][bail])
	    return SendClientError(playerid, "He didn't pay his bail! (/paybail)");
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 10)
		return SendClientError(playerid, "He is too far away!");
	if(PlayerInfo[iPlayer][jail])
	{
		UnJail(iPlayer);
		format(iStr, sizeof(iStr), "4[ FREE ] %s[%d] has been freed by Lawyer %s.", PlayerName(iPlayer), iPlayer, PlayerName(playerid));
		iEcho(iStr);
	}
	return 1;
}
COMMAND:restore(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job],"Medic",true)==0 || PlayerInfo[playerid][power]>=10)
	{
		new carid = GetPlayerVehicleID(playerid);
		if(strcmp(VehicleInfo[carid][vJob],"Medic",true)==0 || PlayerInfo[playerid][power]>=10)
		{
			new iPlayer;
			if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
			if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
			if(GetDistanceBetweenPlayers(playerid,iPlayer) < 5)
			{
			    if(PlayerTemp[iPlayer][sm] < MEDIC_PRICE) return SendClientError(playerid, "He can't pay!");
			    new Float:pH;
			    GetPlayerHealth(iPlayer, pH);
			    if(pH > 99) return SendClientError(playerid, "Player doesn't need to be healed.");
				SetPlayerHealth(iPlayer,100);
				GivePlayerMoneyEx(playerid,MEDIC_PRICE);
				GivePlayerMoneyEx(iPlayer,-MEDIC_PRICE);
				SendClientMSG(iPlayer, COLOR_PINK, "MEDIC: %s has healed you. $-%s", RPName(playerid), number_format(MEDIC_PRICE));
				format(iStr, sizeof(iStr), "6[MEDIC] %s[%d] has healed %s[%d] (Price: $%s)",PlayerName(playerid),playerid,PlayerName(iPlayer), iPlayer, number_format(MEDIC_PRICE));
				iEcho(iStr);
				return 1;
			} else return SendClientError(playerid, "He is too far away!");
		}
	} else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:tracehouse(playerid, params[])
{
	if((strcmp(PlayerInfo[playerid][job], "Detective", true))
		&& PlayerInfo[playerid][power] < 10
		&& !IsPlayerENF(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new tracednumber;
	if( sscanf ( params, "d", tracednumber)) return SCP(playerid, "[house ID]");
	if(HouseInfo[tracednumber][hActive] != true) return SendClientError(playerid, "House could not be traced. (Non-existant)");
	SetPlayerCheckpoint(playerid, HouseInfo[tracednumber][hX], HouseInfo[tracednumber][hY], HouseInfo[tracednumber][hZ], 2);
	SendClientMSG(playerid, COLOR_YELLOW, "Marker has been set to house with the number %d.", tracednumber);
	return 1;
}
COMMAND:tracebiz(playerid, params[])
{
	if(	(strcmp(PlayerInfo[playerid][job], "Detective", true))
		&& PlayerInfo[playerid][power] < 10
		&& GetPlayerFaction(playerid) != FAC_TYPE_SDC
		&& !IsPlayerENF(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new tracednumber;
	if( sscanf ( params, "d", tracednumber)) return SCP(playerid, "[biz ID]");
	if(BusinessInfo[tracednumber][bActive] != true) return SendClientError(playerid, "House could not be traced. (Non-existant)");
	SetPlayerCheckpoint(playerid, BusinessInfo[tracednumber][bX], BusinessInfo[tracednumber][bY], BusinessInfo[tracednumber][bZ], 2);
	SendClientMSG(playerid, COLOR_YELLOW, "Marker has been set to the business %s (ID: %d)", BusinessInfo[tracednumber][bName], tracednumber);
	return 1;
}
COMMAND:tracen(playerid, params[])
{
    if(	(strcmp(PlayerInfo[playerid][job], "Detective", true))
		&& PlayerInfo[playerid][power] < 10
		&& !IsPlayerENF(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new tracednumber, targetID;
	if( sscanf ( params, "d", tracednumber)) return SCP(playerid, "[phone number]");
	PlayerLoop(i)
	{
		if(PlayerInfo[i][phonenumber] == tracednumber) targetID = i;
	}
	if(targetID == -1) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerTemp[playerid][phoneoff] == 1) return SendClientError(playerid, "Could not trace the number.");
	if(IsPlayerInAnyInterior(targetID)) return SendClientInfo(playerid, "The number could not be traced, possibly in a house / business.");

	new Float:xx,Float:yy,Float:zz, zone[60];
	GetPlayerPos(targetID,xx,yy,zz);
	GetZone(xx,yy,zz,zone);
	SetPlayerCheckpoint(playerid, xx+minrand(1,10),yy+minrand(1,10),zz,3.0);
	SendClientMSG(playerid, COLOR_PINK, "[Traced]: Number %d has been found in %s.", tracednumber, zone);
	SetTimerEx("TracingNumber", 1000, false, "dd", playerid, targetID);
	return 1;
}
COMMAND:selldrugs(playerid, params[])
{
	new iPlayer, drugType[12], drugQuty;
	if(sscanf(params, "usd", iPlayer, drugType, drugQuty)) return SCP(playerid, "[PlayerID/PartOfName] [Drug Type] [Amount]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 5.0 ) return SendClientInfo(playerid, "Too far away from him.");
	new DTYPE = -1;
	LOOP:q(0, sizeof(drugtypes))
	{
	    if(!strcmp(drugtypes[q][drugname], drugType, true))  DTYPE = q;
	    else continue;
	}
	if(drugQuty > PlayerInfo[playerid][sdrugs] || drugQuty < 0 || drugQuty > 2100000000) return SendClientError(playerid, "You don't have this much sellable drugs.");
    SendClientMSG(iPlayer, COLOR_LIGHTGREY, "[DRUG DEALER] %s has given you %d gram(s) of %s. TIP: /usedrugs", MaskedName(playerid), drugQuty, drugtypes[DTYPE][drugname]);
    SendClientMSG(playerid, COLOR_LIGHTGREY, "[DRUG DEALER] You have given %s %d gram(s) of %s.", MaskedName(iPlayer), drugQuty, drugtypes[DTYPE][drugname]);
    new iFormat[128];
	format(iFormat, sizeof(iFormat), "has given %d gram(s) of %s to %s.", drugQuty, drugtypes[DTYPE][drugname], MaskedName(iPlayer));
	Action(playerid, iFormat);
	PlayerInfo[iPlayer][hasdrugs][DTYPE] += drugQuty;
	PlayerInfo[playerid][sdrugs] -= drugQuty;
	return 1;
}
COMMAND:robhouse(playerid, parmas[])
{
	if(!IsPlayerENF(playerid))
	{
	    if(strcmp(PlayerInfo[playerid][job], "Thief", true))
			return SendClientError(playerid, " You must be Thief to rob houses! ");
        if(PlayerTemp[playerid][tmphouse] == -1)
			return SendClientError(playerid, "You are not inside a house.");
        if(HouseInfo[PlayerTemp[playerid][tmphouse]][hTill] < 100)
			return SendClientError(playerid, "There is nothing to rob!");
        if(PlayerTemp[playerid][RobbingHouse] != -1)
			return SendClientError(playerid, "Already robbing a house!");
        if(GetOnlineCops() < 1)
			return SendClientError(playerid, "There needs to be atleast 1 cop online!");
		new houseCount;
        PlayerLoop(q) if(PlayerTemp[q][tmphouse] == PlayerTemp[playerid][tmphouse]) houseCount++;
        if(houseCount > 1)
			return SendClientError(playerid, "You must be alone in the house.");
			
        new cashtowin = (HouseInfo[PlayerTemp[playerid][tmphouse]][hTill]/4) * 3,
			message[128],
			Float:rPosX,
			Float:rPosY,
			Float:rPosZ,
			tmpid = PlayerTemp[playerid][tmphouse];
		
		GetPlayerPos(playerid, rPosX, rPosY, rPosZ);
        PlayerTemp[playerid][RobbingHouse] = tmpid;
        NearMessage(playerid,"========================================================",COLOR_RED);
        format(message,sizeof(message),"* %s is robbing the house (%d). *",PlayerName(playerid), tmpid);
		NearMessage(playerid,message,COLOR_WHITE);
		NearMessage(playerid,"========================================================",COLOR_RED);
		format(message, sizeof(message), "13[HOUSE ROB] %s is attempting to rob house %d. Possible win: $%s!", PlayerName(playerid), tmpid, number_format(cashtowin));
		iEcho(message);
		SetPVarFloat(playerid, "x", rPosX);
		SetPVarFloat(playerid, "y", rPosY);
		SetPVarFloat(playerid, "z", rPosZ);
		SetPVarInt(playerid, "isrobbing", cashtowin);
		SetPVarInt(playerid, "isrobbinghouse", tmpid);
		DeletePVar(playerid, "robbingtime");
		PlayerTemp[playerid][RobBizTimer] = SetTimerEx("RobbingHouseTimer", 1000, 1, "dfff", playerid, rPosX, rPosY, rPosZ);
		if(HouseInfo[tmpid][hAlarm] != 0) // has alarm
		{
			NearMessageEx("========================================================", COLOR_RED, HouseInfo[tmpid][hX], HouseInfo[tmpid][hY], HouseInfo[tmpid][hZ], HouseInfo[tmpid][hInterior], HouseInfo[tmpid][hVirtualWorld]);
			format(message, sizeof(message), "*** HOUSE ALARM #%d ***", tmpid);
			NearMessageEx(message, COLOR_WHITE, HouseInfo[tmpid][hX], HouseInfo[tmpid][hY], HouseInfo[tmpid][hZ], HouseInfo[tmpid][hInterior], HouseInfo[tmpid][hVirtualWorld]);
			NearMessageEx("========================================================", COLOR_RED, HouseInfo[tmpid][hX], HouseInfo[tmpid][hY], HouseInfo[tmpid][hZ], HouseInfo[tmpid][hInterior], HouseInfo[tmpid][hVirtualWorld]);
			new ownerid = GetPlayerId(HouseInfo[tmpid][hOwner]);
			new iFormat[128], zone[75];
			GetZone(HouseInfo[tmpid][hX], HouseInfo[tmpid][hY], HouseInfo[tmpid][hZ], zone);
			if(IsPlayerConnected(ownerid))
			{
				format(iFormat, sizeof(iFormat), "[House Alarm] Your house at %d, %s is currently being burgled!", tmpid, zone);
				SendClientMessage(ownerid, COLOR_RED, iFormat);
			}
			PlayerLoop(p)
			{
				if(PlayerTemp[p][loggedIn] != true) continue;
				if(GetPlayerFactionType(p) != FAC_TYPE_POLICE) continue;
				format(iFormat, sizeof(iFormat), "[House Alarm] House %d, %s is currently being burgled.", tmpid, zone);
				SendClientMessage(p, COLOR_RED, iFormat);
			}
		}
		return 1;
	}
	else return SendClientError(playerid, CANT_USE_CMD);
}
COMMAND:robbiz(playerid, parmas[])
{
	if(!IsPlayerFED(playerid))
	{
        new tmpid = IsPlayerInBiz(playerid), message[128], player2;
        if(tmpid == -1) return SendClientError(playerid, "You are not inside a business.");
        if(BusinessInfo[tmpid][bLastRob] > 0) return SendClientError(playerid, "This business has recently been robbed!");
        if(BusinessInfo[tmpid][bTill] < 20000) return SendClientError(playerid, "There is nothing to rob!");
        new cashtowin = BusinessInfo[tmpid][bTill] / 5;
        new rCount = 0,Float:rPos[4];
		GetPlayerPos(playerid, rPos[0], rPos[1], rPos[2]);
        for(new i; i < MAX_PLAYERS; i++)
        {
            if(!IsPlayerConnected(i)) continue;
            if(!IsPlayerInRangeOfPoint(i, 20.0, rPos[0], rPos[1], rPos[2])) continue;
            if(PlayerInfo[i][playerteam] != PlayerInfo[playerid][playerteam]) continue;
            rCount++;
            if(rCount == 2) player2 = i;
        }
        if(rCount < 5) return SendClientError(playerid, "You need atleast 5 people from your faction with you!");
        if(BusinessInfo[tmpid][bRobbed] == true) return SendClientError(playerid, "Don't spam!");
        if(GetOnlineCops() < 4) return SendClientError(playerid, "There needs to be 4 cops online!");
        BusinessInfo[tmpid][bRobbed] = true;
        NearMessage(playerid,"========================================================",COLOR_RED);
        format(message,sizeof(message),"* %s is robbing %s. Do not exit for 2 minutes, else the robbery fails! *",PlayerName(playerid), BusinessInfo[tmpid][bName]);
		NearMessage(playerid,message,COLOR_WHITE);
		NearMessage(playerid,"========================================================",COLOR_RED);
		format(message, sizeof(message), "13[BIZ ROB] %s is attempting to rob the %s business. Possible win: $%d!", PlayerName(playerid), BusinessInfo[tmpid][bName], cashtowin);
		iEcho(message);
		SetPVarFloat(playerid, "x", rPos[0]);
		SetPVarFloat(playerid, "y", rPos[1]);
		SetPVarFloat(playerid, "z", rPos[2]);
		SetPVarInt(playerid, "isrobbing", cashtowin);
		SetPVarInt(playerid, "isrobbingbiz", tmpid);
		DeletePVar(playerid, "robbingtime");
		PlayerTemp[playerid][RobBizTimer] = SetTimerEx("RobbingTimer", 1000, 1, "ddfff", playerid, player2, rPos[0], rPos[1], rPos[2]);
		return 1;
	}
	return 1;
}
COMMAND:plant(playerid)
{
    if(IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "Get out first!");
    if(PlayerTemp[playerid][seeds] <= 0) return SendClientError(playerid, "You don't have any seeds!");
    new Float:ps[4];
    GetPlayerPos(playerid, ps[0], ps[1], ps[2]);
    new id = GetUnusedSeed();
    myStrcpy(Seeds[id][sOwner], PlayerName(playerid));
    format(iStr, sizeof(iStr), "{3a7a16}[Seed]\n{3a7a16}.. growing ..\n{c2d6b7}(%s)", RPName(playerid));
    Seeds[id][sLabel] = CreateDynamic3DTextLabel(iStr, COLOR_PLAYER_SPECIALGREEN,ps[0], ps[1], ps[2], 15.0);
    Seeds[id][sPickup] = CreateDynamicPickup(1279, 1 ,ps[0], ps[1], ps[2]);
    Seeds[id][sGrams] = 0;
    Seeds[id][sActive] = 1;
    Seeds[id][seedX] = ps[0];
    Seeds[id][seedY] = ps[1];
    Seeds[id][seedZ] = ps[2];
    Seeds[id][sTick] = GetTickCount();
    PlayerTemp[playerid][seeds]--;
    return 1;
}
COMMAND:harvest(playerid)
{
    if(IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "Get out first!");
    new seedid = IsAtSeed(playerid);
    if(seedid == -1) return SendClientError(playerid, "You are not at any seeds!");
    if(strcmp(PlayerName(playerid), Seeds[seedid][sOwner], false)) return SendClientError(playerid, "This is not your seed!");
    new Float:ps[4];
    GetPlayerPos(playerid, ps[0], ps[1], ps[2]);
    PlayerInfo[playerid][sdrugs] += Seeds[seedid][sGrams];
    format(iStr, sizeof(iStr), "SEED: Collected %d grams of drugs with the seed!", Seeds[seedid][sGrams]);
    SendClientInfo(playerid, iStr);
    ResetSeed(seedid);
    return 1;
}
COMMAND:jobhelp(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job],"None",true)==0) return ShowInfoBox(playerid, "Error", "you dont have a job!");
	if(strcmp(PlayerInfo[playerid][job],"Thief",true)==0)
 	{
		SendClientMessage(playerid, COLOR_WHITE,"Being a perfect thief is very hard.");
		SendClientMessage(playerid, COLOR_WHITE,"To earn more cash and learn how to rob properly, you need to rob people.");
		SendClientMessage(playerid, COLOR_WHITE,"Each succeeded robbing will make your skill higher, and you will earn more.");
        SendClientMessage(playerid, COLOR_WHITE,"Get close to other people and use /rob");
        SendClientMessage(playerid, COLOR_WHITE,"You need to wait 10 minutes between each robbing action.");
		return 1;
	}
 	if(strcmp(PlayerInfo[playerid][job],"CarJacker",true)==0)
 	{
		SendClientMessage(playerid, COLOR_WHITE,"A CarJacker can make money stealing cars and selling them.");
		SendClientMessage(playerid, COLOR_WHITE,"For first, steal a car, when you driving stealed car, type /dropcar");
		SendClientMessage(playerid, COLOR_WHITE,"and a red marker drive you to selling car place.");
        SendClientMessage(playerid, COLOR_WHITE,"Drive your car in the red marker and you istantly give the car sell price.");
        SendClientMessage(playerid, COLOR_WHITE,"To sell another car, you must wait 5 minutes. This is all, good CarJacking!");
		return 1;
	}
	if(strcmp(PlayerInfo[playerid][job],"TaxiDriver",true)==0)
	{
		SendClientMessage(playerid, COLOR_WHITE,"A Taxi driver must know well the city, so, if you don't know well the city, make some ride and learn all streets.");
		SendClientMessage(playerid, COLOR_WHITE,"A good taxi driver, must drive safetly too, never put client's life on warning.");
		SendClientMessage(playerid, COLOR_WHITE,"When you sitted in a cab, type /fare [amount] and set your fare, an automatic advertisement is shown to all.");
        SendClientMessage(playerid, COLOR_WHITE,"The minimun fare is 1$, the max 20$. The fare is added to taxi driver when a client hop in his cab, and get to driver,");
        SendClientMessage(playerid, COLOR_WHITE,"the fare amount every second. So, Good Driving!");
		return 1;
	}
	if(strcmp(PlayerInfo[playerid][job],"Lawyer",true)==0)
	{
		SendClientMessage(playerid, COLOR_WHITE,"The Lawyer job is pretty important, and a lawyer can be rich in a bit of time.");
		SendClientMessage(playerid, COLOR_WHITE,"Just for roleplay, have a meeting with a cop, ask to him your client generalities, and contract him bail.");
		SendClientMessage(playerid, COLOR_WHITE,"When your client pay the bail, you can free him with /free [id/partofname], before you must receive the payement, chose you how much.");
        SendClientMessage(playerid, COLOR_WHITE,"Not all players can be free, if him bail is setted to 666$, he can't be free, so you can't do anything.");
        SendClientMessage(playerid, COLOR_WHITE,"You can also /devorce people! Have fun making money.");
		return 1;
	}
	if(strcmp(PlayerInfo[playerid][job],"Detective",true)==0)
	{
		SendClientMessage(playerid, COLOR_WHITE,"A skilful detective is a very useful to find a player. You can know always where is your target.");
		SendClientMessage(playerid, COLOR_WHITE,"You can type /trace [number] and a red marker show you the target's location.");
		SendClientMessage(playerid, COLOR_WHITE,"Also a message in the chat show you the name of the player's zone and the city.");
        SendClientMessage(playerid, COLOR_WHITE,"There are 3 levels of detective, the 1st level can find only civilians, 2nd members family too (simple cops too), and 3rd can find anyone.");
        SendClientMessage(playerid, COLOR_WHITE,"You can update your level only with finding experience.");
        SendClientMessage(playerid, COLOR_WHITE,"Your client ask to you to find a person, you may drive him to his  target or you can drive him directly via phone or wishpers.");
        SendClientMessage(playerid, COLOR_WHITE,"You chose your price, make and ADV sometime, if you not trust your client, ask the payement before to do your job. Thats all, Good job!");
		return 1;
	}
	if(strcmp(PlayerInfo[playerid][job],"Medic",true)==0)
	{
		SendClientMessage(playerid, COLOR_WHITE,"This job is easy, you are able to restore your client's healt with a command but,");
		SendClientMessage(playerid, COLOR_WHITE,"your client must be inside, with you, in the ambulance or in medics heli.");
		SendClientMessage(playerid, COLOR_WHITE,"For be respectous tell to your client, recovery price is 500$, then type /restore [id/partofname] and automatically");
        SendClientMessage(playerid, COLOR_WHITE,"you give 500$ of the your client's money.");
        SendClientMessage(playerid, COLOR_WHITE,"Remember, a Medic never kill people, a medic try to safe lives.");
		return 1;
	}
	if(strcmp(PlayerInfo[playerid][job],"Trucker",true)==0)
	{
		SendClientMessage(playerid, COLOR_LIGHTGREY, "Your current job: {D13F3F}Trucker");
		SendClientMessage(playerid, COLOR_LIGHTGREY, "As a trucker, you will need to transport goods from A to B and get a satisfying amount of money for it.");
		SendClientMessage(playerid, COLOR_LIGHTGREY, " Bonus: 20 jobskill -> $500 reward, 50 jobskill -> $700 reward, 100 jobskill -> $900 reward.");
		SendClientMessage(playerid, COLOR_LIGHTGREY, " Bonus: 150 jobskill -> $1200 reward, 200 jobskill -> $1350 reward, 250 jobskill -> $1600 reward.");
		SendClientMessage(playerid, COLOR_LIGHTGREY, " Bonus: 300 jobskill -> $1950 reward, 400 jobskill -> $2600 reward, 500 jobskill -> $4000 reward.");
		SendClientMessage(playerid, COLOR_LIGHTGREY, " Note: Bonuses are added on to your paycheck.");
		SendClientMessage(playerid, COLOR_LIGHTGREY, "Commands: /jobhelp (Trucker Dept) - /truckermission - /stopmission.");
		return 1;
	}
	if(strcmp(PlayerInfo[playerid][job],"Farmer",true)==0)
	{
		SendClientMessage(playerid, COLOR_WHITE,"This job is quite easy but it is a good source to generate money!");
		SendClientMessage(playerid, COLOR_WHITE,"Go to the farm, enter a harvester, and type /startharvest. Fill it up, and earn money. Easy $$$!");
        SendClientMessage(playerid, COLOR_WHITE,"Enjoy the farming!");
		return 1;
	}
	return 1;
}
COMMAND:jobstats(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job],"None",true)!=0) format(iStr,sizeof(iStr),"Your job doesn't need stats, Job[%s]",PlayerInfo[playerid][job]);
	if(strcmp(PlayerInfo[playerid][job],"DrugDealer",true)==0) format(iStr,sizeof(iStr),"Sellables Drugs[%d] - SkillJob[%d]",PlayerInfo[playerid][sdrugs],PlayerInfo[playerid][jobskill]);
	if(strcmp(PlayerInfo[playerid][job],"CarJacker",true)==0) format(iStr,sizeof(iStr),"TimeDrop[%d Secs] - TotalDrops[%d]",PlayerTemp[playerid][candrop]/2,PlayerInfo[playerid][jobskill]);
	if(strcmp(PlayerInfo[playerid][job],"TaxiDriver",true)==0) format(iStr,sizeof(iStr),"Duty Fare[%d] - JobSkill[%d]",PlayerTemp[playerid][Duty],PlayerInfo[playerid][jobskill]);
	if(strcmp(PlayerInfo[playerid][job],"Thief",true)==0) format(iStr,sizeof(iStr),"TotalRobs[%d] TotalAmountRobbed[$%s]",PlayerInfo[playerid][jobskill], number_format(PlayerTemp[playerid][totalrob]));
	if(strcmp(PlayerInfo[playerid][job],"Trucker",true)==0) format(iStr,sizeof(iStr),"Total Deliveries[%d]",PlayerInfo[playerid][jobskill]);
	if(strcmp(PlayerInfo[playerid][job],"None",true)==0) format(iStr,sizeof(iStr),"You don't have a job, Job[%s]",PlayerInfo[playerid][job]);
	SendClientMessage(playerid,COLOR_WHITE,iStr);
	return 1;
}
COMMAND:quitjob(playerid, params[])
{
	myStrcpy(PlayerInfo[playerid][job],"None");
	PlayerInfo[playerid][jobskill]=0;
  	PlayerInfo[playerid][sdrugs]=0;
	PlayerInfo[playerid][sMaterials]=0;
	PlayerInfo[playerid][guns]=0;
  	SendClientMessage(playerid,COLOR_WHITE,"[JOB] You have left your job - you are now unemployed.");
	return 1;
}
COMMAND:truckermission(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job],"Trucker",true)==0)
	{
		if(GetPVarInt(playerid, "PCargo") != 0 || GetPVarInt(playerid, "DeliveringCargo") != 0) return SendClientError(playerid, "You are already on a trucker mission. Use /cancelmission");
		if(!IsPlayerInAnyVehicle(playerid))
				return SendClientError(playerid, "You need to be inside a trucker to use this command.");
		new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
		if(IsPlayerDriver(playerid) != 1) return SendClientError(playerid, "You need to be the driver of a vehicle to use this.");
		if(VehicleInfo[vehicleid][vReserved] == VEH_RES_OCCUPA && !strcmp(VehicleInfo[vehicleid][vJob], "Trucker", false))
		{
			ShowDialog(playerid, DIALOG_TRUCKER_SLCT);
		}
		else return SendClientError(playerid, "You need to be inside a trucker to use tis command.");
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
ALTCOMMAND:tm->truckermission;
enum _wdata
{
	wname[ 25 ],
	wID,
	wAmmo,
	wSellables,
}
new weapon_arr[][_wdata] = {
//	"Name"				"WeapID"		"Ammo"	"Mats Needed"
	{"Colt", 			WEAPON_COLT45, 		75,		210},
	{"Deagle", 			WEAPON_DEAGLE, 		75,		420},
	{"AK47", 			WEAPON_AK47, 		150,	910},
	{"Rifle", 			WEAPON_RIFLE, 		40,		820},
	{"Sniper", 			WEAPON_SNIPER, 		40,		2600},
	{"Shotgun", 		WEAPON_SHOTGUN, 	40,		850},
	{"RPG", 			WEAPON_ROCKETLAUNCHER,1,	135000},
	{"BrassKnuckles", 	WEAPON_BRASSKNUCKLE, 1,		60}
};

COMMAND:sellgun(playerid, params[])
{
	new iPlayer, iWeapon[ 128 ];
	if( sscanf ( params, "us", iPlayer, iWeapon))
	{
		SCP(playerid, "[PlayerID/PartOfName] [weapon]");
		new bStr[ 256 ];
		format(bStr, sizeof(bStr), "Available weapons: ");
		for(new q; q < sizeof(weapon_arr); q++)
		{
			new tmp[ 20 ];
			format(tmp, sizeof(tmp), " %s (%d ammo),", weapon_arr[q][wname], weapon_arr[q][wAmmo]);
			strcat(bStr, tmp);
		}
		strdel(bStr,strlen(bStr)-1, strlen(bStr));
		SendPlayerMessage(playerid, COLOR_ADMIN_PM, bStr, "");
		return 1;
	}
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 3) return SendClientError(playerid, "He is too far away!");
	new dSELECT = -1;
	for(new q; q < sizeof(weapon_arr); q++)
	{
		if(strfind(weapon_arr[q][wname],iWeapon, true) != -1) dSELECT = q;
	}
	if(dSELECT == -1)
	{
		new bStr[ 256 ];
		format(bStr, sizeof(bStr), "Available weapons: ");
		for(new q; q < sizeof(weapon_arr); q++)
		{
			new tmp[ 20 ];
			format(tmp, sizeof(tmp), " %s (%d ammo),", weapon_arr[q][wname], weapon_arr[q][wAmmo]);
			strcat(bStr, tmp);
		}
		strdel(bStr,strlen(bStr)-1, strlen(bStr));
		SendPlayerMessage(playerid, COLOR_ADMIN_PM, bStr);
		return 1;
	}
	
	if(PlayerInfo[playerid][sMaterials] < weapon_arr[dSELECT][wSellables]) return SendClientMSG(playerid, COLOR_ADMIN_PM, "[GUNDEALER]: You don't have enough sellables! You need %d sellabes.", weapon_arr[dSELECT][wSellables]);
	format(iStr, sizeof(iStr), "has sold a %s with %d ammo to %s.", weapon_arr[dSELECT][wname],weapon_arr[dSELECT][wAmmo], MaskedName(iPlayer));
	Action(playerid, iStr);
	GivePlayerWeaponEx(iPlayer, weapon_arr[dSELECT][wID], weapon_arr[dSELECT][wAmmo]);
	PlayerInfo[playerid][sMaterials] -= weapon_arr[dSELECT][wSellables];
	PlayerInfo[playerid][jobskill] += minrand(1,2);
	format(iStr, sizeof(iStr), "6[SELLGUN] %s(%d) has sold a %s to %s(%d).", PlayerName(playerid), playerid, weapon_arr[dSELECT][wname], PlayerName(iPlayer), iPlayer);
	iEcho(iStr);
	SendClientMSG(playerid, COLOR_LIGHTGREY, " You lost %d sellables selling this %s. You now have %d materials left.", weapon_arr[dSELECT][wSellables], weapon_arr[dSELECT][wname], PlayerInfo[playerid][sMaterials]);
	return 1;
}
COMMAND:rob(playerid, params[])
{
	if(strcmp(PlayerInfo[playerid][job], "Thief", true)) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 5) return SendClientError(playerid, "Too far away!");
	if(PlayerTemp[playerid][canrob] == 0)
		return SendClientError(playerid, "You need to wait a while before robbing again.");
	if(PlayerInfo[iPlayer][playerlvl] == 1 || PlayerInfo[iPlayer][playerlvl] == 2)
		return SendClientError(playerid, "You can't rob people that are level 1-2!");
	if(PlayerInfo[playerid][jailtime] > 0 || IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(iPlayer) || IsPlayerInRangeOfPoint(playerid, 30.0, 193.41,175.51,1002.82))
		return SendClientError(playerid, "You can't rob in the current state.");
	new chance = minrand(1,9);
	if(chance> 0 && chance< 6)
	{
	   	format(iStr,sizeof(iStr),"has attempted to rob %s and succeeded.",MaskedName(iPlayer));
		Action(playerid, iStr);
	}
	else if(chance > 5 && chance < 11 || PlayerTemp[iPlayer][sm] <= 0)
	{
	    format(iStr,sizeof(iStr),"has attempted to rob %s but failed.",MaskedName(iPlayer));
		Action(playerid, iStr);
	   	PlayerTemp[playerid][canrob] = 0;
	   	PlayerTemp[playerid][RobTimer] = SetTimerEx("Robber",180000,0,"d",playerid);
	  	return 1;
	}
	new sold;
	if(PlayerInfo[playerid][jobskill] >= 0 && PlayerInfo[playerid][jobskill] <= 10) sold=minrand(900,1300);
	if(PlayerInfo[playerid][jobskill] >= 11 && PlayerInfo[playerid][jobskill] <= 20) sold=minrand(1300,1500);
	if(PlayerInfo[playerid][jobskill] >= 21 && PlayerInfo[playerid][jobskill] <= 30) sold=minrand(1300,1800);
	if(PlayerInfo[playerid][jobskill] >= 31 && PlayerInfo[playerid][jobskill] <= 40) sold=minrand(1600,2200);
	if(PlayerInfo[playerid][jobskill] >= 41 && PlayerInfo[playerid][jobskill] <= 50) sold=minrand(2200,3000);
	if(PlayerInfo[playerid][jobskill] >= 51 && PlayerInfo[playerid][jobskill] <= 60) sold=minrand(3200,4000);
	else if(PlayerInfo[playerid][jobskill] > 60) sold=minrand(4000, 4500);
	GivePlayerMoneyEx(playerid, sold);
	GivePlayerMoneyEx(iPlayer, -sold);
	format(iStr, sizeof(iStr), "%s has robbed $%d from you. go and get his ass!", MaskedName(playerid), sold);
	ShowInfoBox(iPlayer, "Robbed", iStr, 20);
	format(iStr, sizeof(iStr), "Good job, you have robbed $%d from %s, and now RUN!", sold, MaskedName(iPlayer));
	SendClientMessage(playerid, COLOR_LIGHTGREY, iStr);
	PlayerTemp[playerid][totalrob] += sold;

	PlayerTemp[playerid][RobTimer] = SetTimerEx("Robber",240000,0,"d",playerid);
	PlayerInfo[playerid][jobskill]++;
	PlayerTemp[playerid][canrob] = 0;

	format(iStr,sizeof(iStr),"14[ROBBING] %s has robbed $%d from %s.", PlayerName(playerid), sold, PlayerName(iPlayer));
	iEcho(iStr);
	return 1;
}
COMMAND:changephone(playerid, params[])
{
	if(!PlayerInfo[playerid][premium] && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][phonechanges] < 1) return SendClientError(playerid, "You don't have any phone number changes left.");
	new tmp;
	if(sscanf(params, "d", tmp)) return SCP(playerid, "[ New number ]");
	if(tmp < 100 || tmp > 999999 || tmp == 1337 || tmp == 31337 ) return SendClientError(playerid, "Invalid phone number specified.");
	PlayerInfo[playerid][phonechanges]--;
	format(iStr, sizeof(iStr), "[Donator]: {eee259}Your phone number has been changed to \"%d\". You have %d numberchanges left.", tmp, PlayerInfo[playerid][phonechanges]);
	SendClientMessage(playerid, 0xb2a408FF, iStr);
	PlayerInfo[playerid][phonenumber] = tmp;
	return 1;
}
COMMAND:fightstyle(playerid, params[])
{
	if(!PlayerInfo[playerid][premium] && !GetAdminLevel(playerid)) return SendClientError(playerid, CANT_USE_CMD);
	new tmp[15];
	if(sscanf(params, "s", tmp)) return SCP(playerid, "[normal/boxing/kungfu/grabkick/elbow]");
	if(!strcmp(tmp, "normal", true)) SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
	else if(!strcmp(tmp, "boxing", true)) SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
	else if(!strcmp(tmp, "kungfu", true)) SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
	else if(!strcmp(tmp, "grabkick", true)) SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
	else if(!strcmp(tmp, "elbow", true)) SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
	else return SCP(playerid, "[normal/boxing/kungfu/grabkick/elbow]");
	SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "..: [DONATOR]: Your fightstyle has been set to \"%s\" :..", tmp);
	return 1;
}
COMMAND:wlock(playerid, params[])
{
	if(!PlayerInfo[playerid][power] && !PlayerInfo[playerid][premium]) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerTemp[playerid][wlock] == 1)
	{
		PlayerTemp[playerid][wlock] = 0;
		SendClientInfo(playerid, "Noone can whisper to you now.");
	}
	else
	{
		PlayerTemp[playerid][wlock] = 1;
		SendClientInfo(playerid, "People can whisper to you again.");
	}
	return 1;
}
COMMAND:me(playerid, params[])
{
	new LOLWAT[ 128 ];
	if(sscanf(params, "s", LOLWAT)) return SCP(playerid, "[action]");
	Action(playerid, LOLWAT);
	format(iStr, sizeof(iStr), "* %s *", LOLWAT);
	new tmpStr[164];
	format(tmpStr, 164, "%s[%d]: 6* %s", RPName(playerid), playerid, LOLWAT);
	iEcho(tmpStr, IRC_LIVE);
	SetPlayerChatBubble(playerid, iStr, COLOR_ME2, 40.0, 7000);
	return 1;
}
COMMAND:do(playerid, params[])
{
	new LOLWAT[ 128 ];
	if(sscanf(params, "s", LOLWAT)) return SCP(playerid, "[action]");
	format(iStr, sizeof(iStr), "* %s * (( %s ))", LOLWAT, MaskedName(playerid));
	new tmpStr[164];
	format(tmpStr, 164, "%s[%d]: 6(action) * %s", RPName(playerid), playerid, LOLWAT);
	iEcho(tmpStr, IRC_LIVE);
	NearMessage(playerid,iStr,COLOR_ME2);
	SetPlayerChatBubble(playerid, iStr, COLOR_ME2, 40.0, 7000);
	return 1;
}
COMMAND:service(playerid, params[])
{
	if(PlayerTemp[playerid][cuffed] || PlayerTemp[playerid][tazed] || PlayerTemp[playerid][BlindFold] == true || GetPVarInt(playerid, "Tied") == 1)
		return SendClientError(playerid, "You can't use this command while tazed/cuffed/tied/blindfolded.");
	new tmp[10];
	if( sscanf ( params, "s", tmp )) return SCP(playerid, "[taxi/lawyer/medic/mechanic]");
	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid,px,py,pz);
	if(strcmp(tmp,"police",true)==0)
	{
		OnPlayerCommandText(playerid, "/c 911");
		return 1;
	}
	else if(strcmp(tmp,"taxi",true)==0)
	{
		new message[MAX_STRING];
		PlayerTemp[playerid][callingtaxi]=1;
		format(message,sizeof(message),"~g~%s~w~(%d) has called a taxi, use /dojob (id/name) to answer the call and pick him up.",PlayerName(playerid),playerid);
		PlayerLoop(i)
		{
			if(!strcmp(PlayerInfo[i][job],"TaxiDriver",true))
			{
				ShowInfoBox(i, "Taxi Call", message);
				PlayerPlaySound(i, 1057, 0, 0, 0);
			}
		}
		Action(playerid, "takes out their cellphone and calls a taxi.");
		return 1;
	}
	else if(strcmp(tmp,"lawyer",true)==0)
	{
		new message[MAX_STRING];
		format(message,sizeof(message),"[CALL] %s called a lawyer in his jailcell!",PlayerName(playerid));
		PlayerLoop(i)
		{
			if(!strcmp(PlayerInfo[i][job],"Lawyer",true))
			{
				SendClientMessage(i,COLOR_PURPLE,message);
			}
		}
		Action(playerid, "calls a lawyer.");
		return 1;
	}
	else if(strcmp(tmp,"medic",true)==0)
	{
		new message[MAX_STRING];
		format(message,sizeof(message),"~g~%s~w~(%d) has called a medic, check your radar to find out his current position.",PlayerName(playerid), playerid);
		PlayerLoop(i)
		{
			if(strcmp(PlayerInfo[i][job],"Medic",true)==0)
			{
				ShowInfoBox(i, "911 Call", message);
				SetPlayerCheckpoint(i,px,py,pz,3);
			}
		}
		Action(playerid, "takes out their cellphone and calls the medical service units.");
		return 1;
	}
	else if(strcmp(tmp,"mechanic",true)==0)
	{
		new message[MAX_STRING];
		new iZone[45];
		new Float:ppX, Float:ppY, Float:ppZ;
		GetPlayerPos(playerid, ppX, ppY, ppZ);
		GetZone(ppX, ppY, ppZ, iZone);
		format(message,sizeof(message),"~r~%s~w~(Phone: ~g~%d~w~) has called for a mechanic, at %s.", PlayerName(playerid), PlayerInfo[playerid][phonenumber], iZone);
		PlayerLoop(i)
		{
			if(strcmp(PlayerInfo[i][job],"mechanic",true)==0)
			{
				ShowInfoBox(i, "Mechanic Duty", message);
			}
		}
		Action(playerid, "takes out their cellphone and calls a mechanic.");
		return 1;
	}
	else return SCP(playerid, "[taxi/lawyer/medic/mechanic]");
}
COMMAND:c(playerid, params[])
{
	if(PlayerTemp[playerid][cuffed] || PlayerTemp[playerid][tazed] || PlayerTemp[playerid][BlindFold] == true || GetPVarInt(playerid, "Tied") == 1)
		return SendClientError(playerid, "You can't use this command while tazed/cuffed/tied/blindfolded.");

	if(PlayerTemp[playerid][phoneoff]) return SendClientError(playerid, "Your phone is off!");
	if(!PlayerInfo[playerid][gotphone]) return SendClientError(playerid, "You don't have a phone!");
	if(PlayerTemp[playerid][phone] == 1) return SendClientError(playerid, "You are on phone!");
	new numero;
	if( sscanf ( params, "d", numero))  return SCP(playerid, "[number]");
	if( numero == 911)
	{
		Action(playerid, "takes out their cellphone and dials a number.");
		SendClientMessage(playerid, COLOR_PLAYER_SPECIALBLUE, " ");
		SendClientMessage(playerid, COLOR_PLAYER_SPECIALBLUE, "Hello, this is your local SAPD landline.");
		SendClientMessage(playerid, COLOR_PLAYER_SPECIALBLUE, " Please explain what happened, including your location!");
		SendClientMessage(playerid, COLOR_PLAYER_SPECIALBLUE, " ");
		SetPlayerSpecialAction(playerid,11);
		ShowDialog(playerid, DIALOG_911);
		return 1;
	}
	new giveplayerid = -1;
	PlayerLoop(w) if(numero==PlayerInfo[w][phonenumber]) giveplayerid=w;
	if(giveplayerid==-1) return SendClientMessage(playerid,COLOR_RED,"No players with this number");
	if(PlayerTemp[giveplayerid][adminduty] == 1) return SendClientError(playerid, "You cannot CALL onduty admins!");
	if(PlayerTemp[giveplayerid][phone]==1)
		return SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "[PHONE] %s is currently busy on a phone call.", RPName(giveplayerid));
	if(!PlayerInfo[giveplayerid][gotphone])
		return SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "[PHONE] %s doesn't have a cellphone!", RPName(giveplayerid));
	if(PlayerTemp[giveplayerid][phoneoff])
		return SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "[PHONE] %s's cellphone is currently turned off!", RPName(giveplayerid));
	PlayerTemp[playerid][onphone]=giveplayerid;
    PlayerTemp[giveplayerid][onphone]=playerid;
    PlayerTemp[playerid][phone] = 1;
	Action(playerid, "takes out their cellphone and dials a number.");
	SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "[PHONE] Calling %s - Number: %d", RPName(giveplayerid), numero);
	SendClientMessage(playerid, COLOR_WHITE, "[PHONE] Use /hangup if he doesn't answer.");
	format(iStr,sizeof(iStr),"[PHONE] Number '%d' is calling you, to answer type /answer!",PlayerInfo[playerid][phonenumber]);
	SendClientMessage(giveplayerid, COLOR_PLAYER_DARKYELLOW,iStr);
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	PlayerPlaySound(giveplayerid, 20804,X,Y,Z);
	new callprice = dini_Int(globalstats,"calls");
	new bizid = GetClosestBiz(playerid, BUSINESS_TYPE_PHONE);
	BusinessInfo[bizid][bTill] += callprice;
	GivePlayerMoneyEx(playerid, -callprice);
	return 1;
}
COMMAND:sms(playerid, params[])
{
	if(PlayerTemp[playerid][cuffed] || PlayerTemp[playerid][tazed] || PlayerTemp[playerid][BlindFold] == true || GetPVarInt(playerid, "Tied") == 1)
		return SendClientError(playerid, "You can't use this command while tazed/cuffed/tied/blindfolded.");
	if(!PlayerInfo[playerid][gotphone]) return SendClientError(playerid, "You don't have a phone!");
	if(PlayerTemp[playerid][phone] == 1) return SendClientError(playerid, "You are on phone already!");
	if(PlayerTemp[playerid][phoneoff]) return SendClientError(playerid, "Your phone is off!");

	new iPlayer;
	if( sscanf ( params, "d", iPlayer))  return SCP(playerid, "[number]");
	if( iPlayer < 0 || iPlayer > 9999999) return SCP(playerid, "[number]");
	new giveplayerid = -1, numero = iPlayer;
	PlayerLoop(w) if(numero==PlayerInfo[w][phonenumber]) giveplayerid=w;
	if(giveplayerid==-1) return SendClientMessage(playerid,COLOR_RED,"No players with this number");
	if(PlayerTemp[giveplayerid][adminduty] == 1) return SendClientError(playerid, "You cannot SMS onduty admins!");
	if(PlayerTemp[giveplayerid][phone]==1)
		return SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "[PHONE] %s is currently busy on a phone call.", RPName(giveplayerid));
	if(!PlayerInfo[giveplayerid][gotphone])
		return SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "[PHONE] %s doesn't have a cellphone!", RPName(giveplayerid));
	if(PlayerTemp[giveplayerid][phoneoff])
		return SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW, "[PHONE] %s's cellphone is currently turned off!", RPName(giveplayerid));
	PlayerTemp[playerid][playertosms] = giveplayerid;
	ShowDialog(playerid, DIALOG_SMS);
	Action(playerid, "takes out their cellphone and writes a text message.");
	return 1;
}
COMMAND:w(playerid, params[])
{
	new iPlayer, iText[ 128 ];
	if( sscanf ( params, "us", iPlayer, iText))  return SCP(playerid, "[PlayerID/PartOfName] [message]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerTemp[iPlayer][wlock]==1 && !PlayerInfo[playerid][power])
		return SendClientMessage(playerid,COLOR_RED,"The given player has locked their whispers.");

	new iDistance = GetDistanceBetweenPlayers(playerid, iPlayer);
	if(iDistance < 6 || PlayerInfo[playerid][power] || PlayerInfo[playerid][helper])
	{
		if(iDistance > 6) format(iStr, sizeof(iStr), "(( [/irc] %s %s: %s ))", AdminLevelName(playerid), RPName(playerid), iText);
		else format(iStr, sizeof(iStr), "** %s[%d] whispers: %s", MaskedName(playerid), playerid, iText);
		SendClientMessage(iPlayer, COLOR_YELLOW, iStr);
		if(iDistance > 6) format(iStr, sizeof(iStr), "(( PM sent to %s: %s ))", RPName(iPlayer), iText);
		else format(iStr, sizeof(iStr), "** Whisper sent to %s[%d]: %s", MaskedName(iPlayer), iPlayer, iText);
		SendClientMessage(playerid, COLOR_YELLOW, iStr);
		format(iStr,sizeof(iStr),"%s whispers to %s:%s",PlayerName(playerid),PlayerName(iPlayer),iText);
		AppendTo(wlog,iStr);

		PlayerLoop(i)
		{
			if(PlayerTemp[i][adminspy] == 1)
			{
			    format(iStr, sizeof(iStr), "(/w) %s to %s: %s", PlayerName(playerid), PlayerName(iPlayer), iText);
			    SendClientMessage(i, COLOR_LIGHTGREY, iStr);
			}
		}
		format( iStr, sizeof(iStr), "7[WHISPER] %s[%d] to %s[%d]: %s",PlayerName(playerid), playerid, PlayerName(iPlayer), iPlayer, iText);
		iEcho(iStr);
	}
	else SendClientError(playerid, "Player is too far away!");
	return 1;
}
COMMAND:b(playerid,params[])
{
    new string[128];
    if(PlayerTemp[playerid][muted]==1)  return SendClientError(playerid, "You are muted!");
	if(sscanf(params, "s", string)) return SCP(playerid, "[text]");
    else
    {
        new tmpStr[ 164 ];
		format(tmpStr, 164, "7%s[%d]: (( %s ))", RPName(playerid), playerid, params);
		iEcho(tmpStr, IRC_LIVE);
		if(PlayerTemp[playerid][adminduty]) format(iStr, sizeof(iStr),"{ffffff} [ {ff0000}Admin{ffffff} ] ");
		if(PlayerTemp[playerid][helperduty]) format(iStr, sizeof(iStr),"{ffffff} [ {ff0000}Helper{ffffff} ] ");
		else format(iStr, sizeof(iStr),"");
		format(string, sizeof(string), "%s%s (( %s ))", iStr, RPName(playerid),params);
		ProxDetectorEx(30.0, playerid, string, COLOR_WHITE);
		format(string, sizeof(string), "(( %s ))", params);
		SetPlayerChatBubble(playerid, string, COLOR_WHITE, 40.0, 7000);
    }
    return 1;
}
COMMAND:sellfish(playerid, params[])
{
    if(PlayerTemp[playerid][fishamount] == 0) return SendClientError(playerid, "You don't have any fishes!");
    if(IsVehicleBoat(GetPlayerVehicleID(playerid))) return SendClientError(playerid, "Grab a car and drive to the warehouse!");
	if(IsPlayerInRangeOfPoint(playerid, 4.0, -2036.6390,1196.4235,46.2395))
	{
	    new loolprofit = (PlayerTemp[playerid][fishamount] * minrand(3,5))/2;
	    GivePlayerMoneyEx(playerid, loolprofit);
	    format(iStr, sizeof(iStr), "WAREHOUSE: Thank you for delivering %dlbs of fish. I'll give you $%s in return!",PlayerTemp[playerid][fishamount], number_format(loolprofit));
	    SendPlayerMessage(playerid, COLOR_HELPEROOC, iStr, "WARHOUSE:");
	    PlayerTemp[playerid][fishamount] = 0;
	    return 1;
	}
	else
	{
		SendClientError(playerid, "Not at a warehouse! Checkpoint set to the San Fierro Fish CO.");
		SetPlayerCheckpoint(playerid, -2036.6390,1196.4235,46.2395, 3.0);
		return 1;
	}
}
COMMAND:fish(playerid, params[])
{
	if(PlayerTemp[playerid][fishamount] >= 2000 && !IsVehicleBoat(GetPlayerVehicleID(playerid)))
	{
		ShowInfoBox(playerid, "Information", "You can only hold ~r~2000~w~lbs of fish when on foot. Go and /sellfish!");
		return 1;
	}
	if(PlayerTemp[playerid][fishamount] >= 4000 && IsVehicleBoat(GetPlayerVehicleID(playerid)))
	{
		ShowInfoBox(playerid, "Information", "You can hold ~r~4000~w~lbs of fish when on a boat. Go and /sellfish!");
		return 1;
	}
	if(GetTickCount() - PlayerTemp[playerid][fishtick] < 6000)
	return SendClientError(playerid, "You can only fish each 6 seconds!");
	if(IsPlayerInAnyVehicle(playerid) && !IsVehicleBoat(GetPlayerVehicleID(playerid))) return SendClientError(playerid, "You cannot fish in a vehicle!");
	if(IsPlayerInRangeOfPoint(playerid, 35.0, -3032.9719,471.5978,0.1218) || IsVehicleBoat(GetPlayerVehicleID(playerid)))
	{
		new fishedwat = minrand(1,30), fish[ 40 ], fishw;
		switch(fishedwat)
		{
			case 1: myStrcpy(fish, 	"a Turtle"), fishw = minrand(90,230);
			case 2: myStrcpy(fish, 	"a Small turtle"), fishw = minrand(20,100);
			case 3: myStrcpy(fish, 	"a Nemo"), fishw = minrand(250,400);
			case 4: myStrcpy(fish, 	"a Shark"), fishw = minrand(90,150);
			case 5: myStrcpy(fish, 	"a Small shark"), fishw = minrand(50,90);
			case 6: myStrcpy(fish, 	"a Salmon"), fishw = minrand(50,100);
			case 7: myStrcpy(fish, 	"a Zander"), fishw = minrand(30,60);
			case 8: myStrcpy(fish, 	"a big pike"), fishw = minrand(75,150);
			case 9: myStrcpy(fish, 	"a pike"), fishw = minrand(24,75);
			case 10: myStrcpy(fish, "a dolphin"), fishw = minrand(80,150);
			case 11: myStrcpy(fish, "a blue martin"), fishw = minrand(100,400);
			case 12: myStrcpy(fish, "a grouper"), fishw = minrand(45,190);
			case 13: myStrcpy(fish, "a peacock"), fishw = minrand(500,1000);
			case 14: myStrcpy(fish, "a lobster"), fishw = minrand(50,175);
			case 15: myStrcpy(fish, "a killer whale"), fishw = minrand(1000,1750);
			case 16: myStrcpy(fish, "a whale"), fishw = minrand(300,400);
			case 17: myStrcpy(fish, "a rooster"), fishw = minrand(7,123);
			case 18: myStrcpy(fish, "a whale shark"), fishw = minrand(100,300);
			case 19: myStrcpy(fish, "a cod"), fishw = minrand(50,150);
			case 20: myStrcpy(fish, "a swordfish"), fishw = minrand(150,200);
			case 21: myStrcpy(fish, "a blue butterfly"), fishw = minrand(23,50);
			case 22: myStrcpy(fish, "a black martin"), fishw = minrand(102,150);
			case 23: myStrcpy(fish, "a snapper"), fishw = minrand(40,70);
			case 24: myStrcpy(fish, "a tarpon"), fishw = minrand(50,150);
			case 25: myStrcpy(fish, "a sailfish"), fishw = minrand(120,300);
			case 26: myStrcpy(fish, "a manita ray"), fishw = minrand(42,190);
			case 27: myStrcpy(fish, "a thinfin tuna"), fishw = minrand(42,90);
			case 28: myStrcpy(fish, "a tuna fish"), fishw = minrand(100,200);
			case 29: myStrcpy(fish, "a Wahoo"), fishw = minrand(70,100);
			default: myStrcpy(fish, "a cupera"), fishw = minrand(100,200);
		}
		format(iStr, sizeof(iStr), "has fished %s with the weight of %dlbs.", fish, fishw);
		Action(playerid, iStr);
		SendClientMSG(playerid, COLOR_LIGHTGREY,  " You now have a total of %dlbs fish.", PlayerTemp[playerid][fishamount] + fishw);
		PlayerTemp[playerid][fishamount] += fishw;
		PlayerTemp[playerid][totalfish] += fishw;
		PlayerTemp[playerid][fishtick] = GetTickCount();
		return 1;
	}
	else return SendClientError(playerid, "Not at a fishing point!");
}
COMMAND:ad(playerid, params[])
{
	if(PlayerTemp[playerid][cuffed] || PlayerTemp[playerid][tazed] || PlayerTemp[playerid][BlindFold] == true || GetPVarInt(playerid, "Tied") == 1)
		return SendClientError(playerid, "You can't use this command while tazed/cuffed/tied/blindfolded.");

	if(PlayerTemp[playerid][muted] == 1)
		return SendClientMessage(playerid,COLOR_RED,"You have been muted");

	if(!PlayerInfo[playerid][gotphone] || PlayerInfo[playerid][phonenumber] == -1)
			return SendClientError(playerid, "You don't have a phone!");

	if(PlayerInfo[playerid][playerlvl] <= 1)
	    return SendClientError(playerid, "You need to be atleast level 2 to use advertisements!");

	new iQuery[228];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `PlayerName` FROM `Advertisements` WHERE `PlayerName ` = '%e' AND `Active` = 1 LIMIT 1", PlayerName(playerid));
	new Cache:result = mysql_query(MySQLPipeline, iQuery);
	new iRowCount = cache_num_rows();
	cache_delete(result);
	if(iRowCount >= 1) return SendClientError(playerid, "You already have an active advertisement. Please use \"/deletead\" to remove it.");
	
	Action(playerid, "takes out their cellphone and dials a number.");
	ShowDialog(playerid, DIALOG_AD);
   	return 1;
}
COMMAND:cad(playerid, params[])
{
	if(PlayerTemp[playerid][cuffed] || PlayerTemp[playerid][tazed] || PlayerTemp[playerid][BlindFold] == true || GetPVarInt(playerid, "Tied") == 1)
		return SendClientError(playerid, "You can't use this command while tazed/cuffed/tied/blindfolded.");

	if(PlayerTemp[playerid][muted] == 1)
		return SendClientMessage(playerid,COLOR_RED,"You have been muted");

	if(!PlayerInfo[playerid][gotphone] || PlayerInfo[playerid][phonenumber] == -1)
	    return SendClientError(playerid, "You don't have a phone!");

	if(PlayerInfo[playerid][playerlvl] < 3)
	    return SendClientError(playerid, "You need to be atleast level 3 to use company advertisements!");

	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `PlayerName` FROM `Advertisements` WHERE `PlayerName` = '%e' AND `Active` = 1", PlayerName(playerid));
	new Cache:result = mysql_query(MySQLPipeline, iQuery);
	new rows = cache_num_rows();
	cache_delete(result);
	if(rows) return SendClientError(playerid, "You already have an active advertisement. Please use \"/deletead\" to remove it.");
	
	Action(playerid, "takes out their cellphone and dials a number.");
	ShowDialog(playerid, DIALOG_CAD);
   	return 1;
}
COMMAND:deletead(playerid, params[])
{
	new iQuery[228];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `PlayerName` FROM `Advertisements` WHERE `PlayerName` = '%e' AND `Active` = 1", PlayerName(playerid));
	new Cache:result = mysql_query(MySQLPipeline, iQuery);
	new rows = cache_num_rows();
	cache_delete(result);
	if(!rows) return SendClientError(playerid, "You don't have any active advertisements currently pending.");

	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `Price` FROM `Advertisements` WHERE `PlayerName` = '%e' AND `Active` = 1 LIMIT 1", PlayerName(playerid));
	mysql_tquery(MySQLPipeline, iQuery, "CancelAdvertisement", "d", playerid);
	return 1;
}
COMMAND:cc(playerid, params[])
{
	new iText[ 128 ];
	if(sscanf(params, "s", iText)) return SCP(playerid, "[text]");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle.");
	format(iStr, sizeof(iStr), "[%s] {e8f6d1}%s: %s", GetVehicleName(GetPlayerVehicleID(playerid)), MaskedName(playerid), iText);
	new iHead[85];
	format(iHead, sizeof(iHead), "[%s] {e8f6d1}%s", GetVehicleName(GetPlayerVehicleID(playerid)), MaskedName(playerid));
	PlayerLoop(i)
	{
	    if(!IsPlayerInAnyVehicle(i)) continue;
	    if(GetPlayerVehicleID(i) != GetPlayerVehicleID(playerid)) continue;
	    SendPlayerMessage(i, 0xc0ed7cFF, iStr, iHead);
	    iEcho(iStr);
	}
	return 1;
}
COMMAND:l(playerid, params[])
{
	new iText[ 128 ];
	if(sscanf(params, "s", iText)) return SCP(playerid, "[text]");
	new pOld = PlayerTemp[playerid][phone];
	PlayerTemp[playerid][phone] = 0;
	OnPlayerText(playerid, iText);
	PlayerTemp[playerid][phone] = pOld;
	return 1;
}
COMMAND:shout(playerid, params[])
{
	new iText[ 128 ];
	if(sscanf(params, "s", iText)) return SCP(playerid, "[text]");
	new Float:px,Float:py,Float:pz; GetPlayerPos(playerid,px,py,pz);
	format(iStr, sizeof(iStr), "%s shouts: %s !!", MaskedName(playerid), iText);
   	PlayerLoop(i)
	{
		if(!IsPlayerInRangeOfPoint(i, 70.0, px,py,pz)) continue;
		if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid) || GetPlayerInterior(i) != GetPlayerInterior(playerid)) continue;
    	new Float:dis = GetDistanceBetweenPlayers(playerid,i);
	   	if(dis>60) SendClientMessage(i,COLOR_PLAYER_DARKGREY,iStr);
		if(dis<=60 && dis >30) SendClientMessage(i,COLOR_PLAYER_GREY,iStr);
		if(dis<=30) SendClientMessage(i,COLOR_PLAYER_WHITE,iStr);
	}
	SetPlayerChatBubble(playerid, iText, 0xFFFFFFFF, 70.0, 4000);
	return 1;
}
ALTCOMMAND:s->shout;
COMMAND:r(playerid, params[])
{
	if(PlayerTemp[playerid][muted]) return SendClientError(playerid, "You are muted!");
	if(!PlayerInfo[playerid][radio]) return SendClientError(playerid, "You don't have a radio!");
	if(PlayerInfo[playerid][curfreq] == INVALID_RADIO_FREQ) return SendClientError(playerid, "No frequence has been set! /freq /syncradio");
	new iText[ 128 ];
	if(sscanf(params, "s", iText)) return SCP(playerid, "[msg]");
	format(iStr, sizeof(iStr), "{40cece}* [Slot %d] {66FFFF}%s %s: %s", GetSlotByFreq(playerid,PlayerInfo[playerid][curfreq]), PlayerInfo[playerid][rankname], RPName(playerid), iText);
	SendRadioMessage(PlayerInfo[playerid][curfreq], iStr, COLOR_PLAYER_VLIGHTBLUE);
	format(iStr, sizeof(iStr), "(RADIO) %s: %s", MaskedName(playerid), iText);
	ProxDetectorEx(20.0, playerid, iStr);
	PlayerLoop(i)
	{
		if(PlayerTemp[i][adminspy] == 1)
		{
		    format(iStr, sizeof(iStr),"(/r) %s %s: %s", PlayerInfo[playerid][rankname], PlayerName(playerid), iText);
		    SendClientMessage(i, COLOR_LIGHTGREY, iStr);
		}
	}
	format( iStr, sizeof(iStr), "12[/r - %d] %s %s: %s",PlayerInfo[playerid][curfreq], PlayerInfo[playerid][rankname], PlayerName(playerid), iText);
	iEcho( iStr );
	if(GetPlayerSpecialAction(playerid)==11) SetTimerEx("HoldPhone",1000,0,"i",playerid);
		else { SetPlayerSpecialAction(playerid,11); SetTimerEx("HoldPhone",1000,0,"i",playerid); }
	return 1;
}
COMMAND:answer(playerid, params[])
{
	if(PlayerTemp[playerid][onphone] == -1) return SendClientError(playerid, "Noone is calling you!");
	if(PlayerTemp[playerid][phone] == 1) return SendClientError(playerid, "You already are on a call!");
	if(!IsPlayerConnected(PlayerTemp[playerid][onphone])) return SendClientError(playerid,   "Lost Connection to the phone");
	SetPlayerSpecialAction(playerid,11);
	PlayerTemp[playerid][phone]=1;
	PlayerTemp[PlayerTemp[playerid][onphone]][phone]=1;
	new callprice = dini_Int(globalstats,"calls");
	format(iStr,sizeof(iStr),"~w~Call succeded~n~cost: ~b~%d",callprice);
	GameTextForPlayer(PlayerTemp[playerid][onphone],iStr,3000,1);
	GivePlayerMoneyEx(playerid,-callprice);
	SendClientMSG(playerid, COLOR_PLAYER_DARKYELLOW,"[PHONE] Answered to %s's call.", MaskedName(PlayerTemp[playerid][onphone]));
	SendClientMSG(PlayerTemp[playerid][onphone], COLOR_PLAYER_DARKYELLOW,"[PHONE] %s answered your call.", MaskedName(playerid));
	return 1;
}
COMMAND:hangup(playerid, params[])
{
	SetPlayerSpecialAction(playerid,13);
    if(PlayerTemp[playerid][phone])
	{
    	if(!IsPlayerConnected(PlayerTemp[playerid][onphone]))
		{
            SendClientError(playerid,"[PHONE]: Lost connection!");
            SetPlayerSpecialAction(playerid,13);
            PlayerTemp[playerid][phone] = 0;
			return 1;
		}
        PlayerTemp[playerid][phone]=0;
        PlayerTemp[PlayerTemp[playerid][onphone]][phone]=0;
        SetPlayerSpecialAction(PlayerTemp[playerid][onphone],13);
        SendClientMessage(playerid, COLOR_PLAYER_DARKYELLOW,"You Hangup");
        SendClientMessage(PlayerTemp[playerid][onphone], COLOR_PLAYER_DARKYELLOW,"They Hangup");
        return 1;
    }
    else return SendClientMessage(playerid, COLOR_RED," Your phone already is on standby.");
}
COMMAND:pay(playerid, params[])
{
	new iPlayer, iAmount;
	if( sscanf ( params, "ud", iPlayer, iAmount))  return SCP(playerid, "[PlayerID/PartOfName] [amount]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(iAmount < 1 || iAmount > HandMoney(playerid)) return SendClientError(playerid, "Invalid amount specified!");
	if(iAmount > 500000) return SendClientError(playerid, "You can pay maximum $500.000 at a time!");
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 6) return SendClientError(playerid, "He is too far away!");
	new ip1[ 24 ], ip2[ 24 ];
	GetPlayerIp(playerid, ip1, sizeof(ip1));GetPlayerIp(iPlayer, ip2, sizeof(ip2));
	if(!strcmp(ip1,ip2,true))
	{
		format(iStr, sizeof(iStr), "/pay warning %s and %s same IP (%s) - Amount: $%s", PlayerName(playerid), PlayerName(iPlayer), ip1, iAmount);
		AdminNotice(iStr);
	}
	GivePlayerMoneyEx(playerid,-iAmount);GivePlayerMoneyEx(iPlayer, iAmount);
	format(iStr, sizeof(iStr), "takes out some money and hands it to %s.", MaskedName(iPlayer));
	Action(playerid, iStr);
	format(iStr, sizeof(iStr),  "[CASH]: You have given %s $%d.", MaskedName(iPlayer),iAmount);
	SendClientMessage(playerid, COLOR_YELLOW, iStr);
	format(iStr, sizeof(iStr), "[CASH]: You have recieved $%d from %s", iAmount,MaskedName(playerid));
	SendClientMessage(iPlayer, COLOR_YELLOW, iStr);
	format(iStr,sizeof(iStr),"14[MONEY] %s has paid $%d to %s.", PlayerName(playerid), iAmount, PlayerName(iPlayer));
	iEcho(iStr); AppendTo(moneylog,iStr);
	return 1;
}
COMMAND:showlicenses(playerid, params[])
{
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetDistanceBetweenPlayers(playerid, iPlayer) > 5) return SendClientError(playerid,   "Too far away");

	new dlic[5], wlic[5], flic[5], blic[5];
	if(PlayerInfo[playerid][driverlic] == 1) myStrcpy(dlic, "Yes"); else myStrcpy(dlic, "No");
	if(PlayerInfo[playerid][weaplic] == 1) myStrcpy(wlic, "Yes"); else myStrcpy(wlic, "No");
	if(PlayerInfo[playerid][flylic] == 1) myStrcpy(flic, "Yes"); else myStrcpy(flic, "No");
	if(PlayerInfo[playerid][boatlic] == 1) myStrcpy(blic, "Yes"); else myStrcpy(blic, "No");

	format(iStr, sizeof(iStr), "has shown their identification card to %s.", MaskedName(iPlayer));
	Action(playerid, iStr);

	SendClientMessage(iPlayer, COLOR_WHITE, "{3f9541}========= {7ada7d}[San Fierro ID] {3f9541}=========");
	format(iStr, sizeof(iStr), " {7ada7d}Name: {FFFFFF}%s", RPName(playerid));
	SendClientMessage(iPlayer, COLOR_WHITE, iStr);
	format(iStr, sizeof(iStr), " {7ada7d}Age: {FFFFFF}%d", PlayerInfo[playerid][age]);
	SendClientMessage(iPlayer, COLOR_WHITE, iStr);
	format(iStr, sizeof(iStr), " {7ada7d}Driver License: {FFFFFF}%s", dlic);
	SendClientMessage(iPlayer, COLOR_WHITE, iStr);
	format(iStr, sizeof(iStr), " {7ada7d}Weapon License: {FFFFFF}%s", wlic);
	SendClientMessage(iPlayer, COLOR_WHITE, iStr);
	format(iStr, sizeof(iStr), " {7ada7d}Flying License: {FFFFFF}%s", flic);
	SendClientMessage(iPlayer, COLOR_WHITE, iStr);
	format(iStr, sizeof(iStr), " {7ada7d}Sailing License: {FFFFFF}%s", blic);
	SendClientMessage(iPlayer, COLOR_WHITE, iStr);
	SendClientMessage(iPlayer, COLOR_WHITE, "{3f9541}========= {7ada7d}[San Fierro ID] {3f9541}=========");
	return 1;
}
COMMAND:blindfold(playerid, params[])
{
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(GetPVarInt(iPlayer, "Tied") == 0) return SendClientError(playerid, "He is not tied up!");
	if(PlayerTemp[iPlayer][BlindFold] == true) return SendClientError(playerid, "Player is already blindfolded!");
	if(IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid, "HasRag") > 0 && GetPlayerVehicleID(iPlayer) == GetPlayerVehicleID(playerid) && !IsPlayerDriver(iPlayer))
	{
		SetPVarInt(playerid, "HasRag", GetPVarInt(playerid, "HasRag") - 1);
		format(iStr, sizeof(iStr), "has blindfolded %s while he is tied up.", MaskedName(iPlayer));
		Action(playerid, iStr);
		TogglePlayerControllable(iPlayer,false);
		GameTextForPlayer(iPlayer,"You have been ~r~blindfolded",10000,5);
		PlayerTemp[iPlayer][BlindFold] = true;
		SetPlayerCameraPos(iPlayer,-1246.8982,596.8187,-86.3465);
		SetPlayerCameraLookAt(iPlayer,-1246.8982,596.8187,-92.1075);
	}
	return 1;
}
COMMAND:unblindfold(playerid, params[])
{
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerTemp[iPlayer][BlindFold] == false) return SendClientError(playerid, "Player is not blindfolded!");
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(iPlayer) == GetPlayerVehicleID(playerid) && !IsPlayerDriver(iPlayer))
	{
		format(iStr, sizeof(iStr), "has removed %s's blindfold.", MaskedName(iPlayer));
		Action(playerid, iStr);
		GameTextForPlayer(iPlayer,"You have been ~g~unblindfolded",10000,5);
		PlayerTemp[iPlayer][BlindFold] = false;
		SetCameraBehindPlayer(iPlayer);
	}
	return 1;
}
COMMAND:tie(playerid, params[])
{
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer) || iPlayer == playerid) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerInfo[iPlayer][playerlvl] < 3) return SendClientError(playerid, "Players under level 3 cannot be tied!");
	if(PlayerInfo[playerid][playerlvl] < 3) return SendClientError(playerid, "Players under level 3 cannot tie others!");
	if(IsPlayerInAnyVehicle(playerid) && GetPVarInt(playerid, "HasRope") > 0 && GetPlayerVehicleID(iPlayer) == GetPlayerVehicleID(playerid) && !IsPlayerDriver(iPlayer))
	{
		SetPVarInt(playerid, "HasRope", GetPVarInt(playerid, "HasRope") - 1);
		format(iStr, sizeof(iStr), "has tied %s up using a rope.", MaskedName(iPlayer));
		Action(playerid, iStr);
		TogglePlayerControllable(iPlayer,false);
		GameTextForPlayer(iPlayer,"You have been ~r~tied",10000,5);
		SetPVarInt(iPlayer, "Tied", 1);
	}
	return 1;
}
COMMAND:untie(playerid, params[])
{
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(iPlayer) == GetPlayerVehicleID(playerid))
	{
		if(GetPVarInt(iPlayer, "Tied") == 0) return SendClientError(playerid, "Player is not tied!");
		format(iStr, sizeof(iStr), "has untied %s.", MaskedName(iPlayer));
		Action(playerid, iStr);
		TogglePlayerControllable(iPlayer,true);
		GameTextForPlayer(iPlayer,"You have been ~g~un-tied",10000,5);
		DeletePVar(iPlayer, "Tied");
	}
	return 1;
}
COMMAND:laptop(playerid)
{
	if(!PlayerInfo[playerid][laptop]) return SendClientError(playerid, "You don't have a laptop! Buy one at a 24/7 Store");
	if(PlayerTemp[playerid][cuffed] || PlayerTemp[playerid][tazed] || PlayerTemp[playerid][BlindFold] == true || GetPVarInt(playerid, "Tied") == 1)
		return SendClientError(playerid, "You can't use this command while tazed/cuffed/tied/blindfolded.");
	new chargeForLaptop = minrand(75, 200);
	if(chargeForLaptop > PlayerTemp[playerid][sm]) return SendClientError(playerid, "You don't have enough to pay for charages.");
	GivePlayerMoneyEx(playerid, -chargeForLaptop);
	SendClientMSG(playerid, 0xD13F3FFF, " $%s{CCCCCC} has been taken for wifi charges.", number_format(chargeForLaptop));
	ShowMenuID(playerid);
	return 1;
}
COMMAND:unloadcomps(playerid, params[])
{
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC)
		return SendClientError(playerid, CANT_USE_CMD);
	if(!IsPlayerInRangeOfPoint(playerid, 7.0, -1722.4049,-118.0071,3.5489))
		return SendClientError(playerid, "You are not at the warehouse!");
	if(VehicleInfo[vehicleid][vGuns] == 0 && VehicleInfo[vehicleid][vCars] == 0 && VehicleInfo[vehicleid][vAlchool] == 0 && VehicleInfo[vehicleid][vStuffs] == 0)
		return SendClientError(playerid, "No comps in your truck.");
	SetTimerEx("AddToStock", 900, false, "dddd", VehicleInfo[vehicleid][vGuns], VehicleInfo[vehicleid][vCars], VehicleInfo[vehicleid][vStuffs], VehicleInfo[vehicleid][vAlchool]);
	VehicleInfo[vehicleid][vGuns] = 0;
	VehicleInfo[vehicleid][vCars] = 0;
	VehicleInfo[vehicleid][vStuffs] = 0;
	VehicleInfo[vehicleid][vAlchool] = 0;
	SendClientMessage(playerid,COLOR_WHITE,"[WH] Deposited all comps in the warehouse. Use /whinfo to see the stats. Earned $800.");
	GivePlayerMoneyEx(playerid, 800);
	PlayerInfo[playerid][totalruns]++;
	format(iStr, sizeof(iStr), "# [%s] %s %s has just finished a run (+$800)", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid));
	SendClientMessageToTeam( PlayerInfo[playerid][playerteam], iStr, COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
COMMAND:loadcomps(playerid, params[])
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
    new choice[12], tmpcomps, fixed[ 15 ];

    if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC)
		return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 2)
		return SendClientError(playerid, CANT_USE_CMD);
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, -1722.4049,-118.0071,3.5489))
		return SendClientError(playerid, "Not at the comps shop!");
	if(GetVehicleModel(carid) != 498)
		return SendClientError(playerid, "You are not driving the delivery van! (Boxville)");
	if(sscanf(params, "ds", tmpcomps, choice))
		return SCP(playerid, "[amount] [type]");
	if(tmpcomps < 0 || tmpcomps > 500)
		return SendClientError(playerid, "Invalid amount!");

	format(fixed,sizeof(fixed),"wh%s",choice);
	new tmpwh=dini_Int(compsfile,fixed);
	if(tmpcomps > tmpwh) return SendClientMSG(playerid, COLOR_RED, "Error: The warehouse doesn't have %d comps of \"%s\" - only %d in it!", tmpcomps, choice, tmpwh);
	tmpwh -= tmpcomps;
	if(strcmp(choice,"guns", true) == 0) VehicleInfo[vehicleid][vGuns] += tmpcomps;
	else if(strcmp(choice,"stuffs", true) == 0) VehicleInfo[vehicleid][vStuffs] += tmpcomps;
	else if(strcmp(choice,"cars", true) == 0) VehicleInfo[vehicleid][vCars] += tmpcomps;
	else if(strcmp(choice,"alcohol", true) == 0) VehicleInfo[vehicleid][vAlchool] += tmpcomps;
	else return SendClientError(playerid, "Invalid type! [guns, stuffs, cars, alchool]");
	dini_IntSet(compsfile, fixed, tmpwh);
	format(iStr,sizeof(iStr),"[S.D.C.] Withdrawn %d %s from the warehouse - New %s stock: %d", tmpcomps, choice, choice, tmpwh);
	SendClientMessage(playerid,COLOR_WHITE,iStr);
	return 1;
}
COMMAND:sellcomps(playerid, params[])
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);

    if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 2) return SendClientError(playerid, CANT_USE_CMD);
	if(GetVehicleModel(carid) != 498) return SendClientError(playerid, "You are not driving the delivery van!");

	new g = IsPlayerOutBiz(playerid, 1);
	if(g == -1) return SendClientError(playerid, "You are not outside any business!");
	if(BusinessInfo[g][bCompsFlag] == NOCOMPS || !BusinessInfo[g][bAskComps]) return SendClientError(playerid, "This business doesn't need comps!");
	if(!BusinessInfo[g][bRestock]) return SendClientError(playerid, "The Director and/or Vice Director restricted restocking here!");

	new factionID = -1;
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(FactionInfo[f][fType] == FAC_TYPE_SDC)
		{
			factionID = f;
			break;
		}
	}
	
	new tmpask = BusinessInfo[g][bAskComps],
		tmpcomps = BusinessInfo[g][bComps],
		sdcash = FactionInfo[factionID][fBank],
		tmpstr[ 10 ], tmpprice, tmpbcash;

	switch(BusinessInfo[g][bCompsFlag])
	{
		case GUNS:
		{
			myStrcpy(tmpstr, "guns");
			if(tmpask > VehicleInfo[vehicleid][vGuns])
			{
				tmpprice = dini_Int(compsfile, "gunssellprice");
				tmpbcash = BusinessInfo[g][bTill];
				sdcash += (VehicleInfo[vehicleid][vGuns] * tmpprice);
				tmpbcash -= (VehicleInfo[vehicleid][vGuns] * tmpprice);
				tmpask -= VehicleInfo[vehicleid][vGuns];
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] Van %s sold, %s still needs %d %s. Earned $%d!",tmpstr, BusinessInfo[g][bName], tmpask,tmpstr,(VehicleInfo[vehicleid][vGuns]*tmpprice)/10);
				tmpcomps += VehicleInfo[vehicleid][vGuns];
				GivePlayerMoneyEx(playerid,VehicleInfo[vehicleid][vGuns]*(tmpprice/10));
				VehicleInfo[vehicleid][vGuns] = 0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;
			}
			else if(tmpask <= VehicleInfo[vehicleid][vGuns])
			{
				tmpprice = dini_Int(compsfile, "gunssellprice");
				tmpbcash = BusinessInfo[g][bTill];
				tmpcomps += tmpask;
				VehicleInfo[vehicleid][vGuns] -= tmpask;
				GivePlayerMoneyEx(playerid,tmpask*(tmpprice/10));
				sdcash += (tmpask*tmpprice);
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] %s has been restocked - You earned $%d!", BusinessInfo[g][bName], (tmpask*tmpprice)/10);
				tmpask=0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;

			}
		}
		case STUFFS:
		{
			myStrcpy(tmpstr, "stuffs");
			if(tmpask > VehicleInfo[vehicleid][vStuffs])
			{
				tmpprice = dini_Int(compsfile, "stuffssellprice");
				tmpbcash = BusinessInfo[g][bTill];
				sdcash += (VehicleInfo[vehicleid][vStuffs] * tmpprice);
				tmpbcash -= (VehicleInfo[vehicleid][vStuffs] * tmpprice);
				tmpask -= VehicleInfo[vehicleid][vStuffs];
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] Van %s sold, %s still needs %d %s. Earned $%d!",tmpstr,BusinessInfo[g][bName], tmpask,tmpstr,(VehicleInfo[vehicleid][vStuffs]*tmpprice)/10);
				tmpcomps += VehicleInfo[vehicleid][vStuffs];
				GivePlayerMoneyEx(playerid,VehicleInfo[vehicleid][vStuffs]*(tmpprice/10));
				VehicleInfo[vehicleid][vStuffs] = 0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;

			}
			else if(tmpask <= VehicleInfo[vehicleid][vStuffs])
			{
				tmpprice = dini_Int(compsfile, "stuffssellprice");
				tmpbcash = BusinessInfo[g][bTill];
				tmpcomps += tmpask;
				VehicleInfo[vehicleid][vStuffs]-=tmpask;
				GivePlayerMoneyEx(playerid,tmpask*(tmpprice/10));
				sdcash=sdcash+(tmpask*tmpprice);
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] %s has been restocked - You earned $%d!", BusinessInfo[g][bName], (tmpask*tmpprice)/10);
				tmpask=0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;
			}
		}
		case ALCHOOL:
		{
			myStrcpy(tmpstr, "alchool");
			if(tmpask > VehicleInfo[vehicleid][vAlchool])
			{
				tmpprice = dini_Int(compsfile, "alchoolsellprice");
				tmpbcash = BusinessInfo[g][bTill];
				sdcash += (VehicleInfo[vehicleid][vAlchool] * tmpprice);
				tmpbcash -= (VehicleInfo[vehicleid][vAlchool] * tmpprice);
				tmpask -= VehicleInfo[vehicleid][vAlchool];
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] Van %s sold, %s still needs %d %s. Earned $%d!",tmpstr,BusinessInfo[g][bName], tmpask,tmpstr,(VehicleInfo[vehicleid][vAlchool]*tmpprice)/10);
				tmpcomps += VehicleInfo[vehicleid][vAlchool];
				GivePlayerMoneyEx(playerid,VehicleInfo[vehicleid][vAlchool]*(tmpprice/10));
				VehicleInfo[vehicleid][vAlchool] = 0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;
			}
			else if(tmpask <= VehicleInfo[vehicleid][vAlchool])
			{
				tmpprice = dini_Int(compsfile, "alchoolsellprice");
				tmpbcash = BusinessInfo[g][bTill];
				tmpcomps += tmpask;
				VehicleInfo[vehicleid][vAlchool]-=tmpask;
				GivePlayerMoneyEx(playerid,tmpask*(tmpprice/10));
				sdcash=sdcash+(tmpask*tmpprice);
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] %s has been restocked - You earned $%d!",BusinessInfo[g][bName], (tmpask*tmpprice)/10);
				tmpask=0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;
			}
		}
		case CARS:
		{
			myStrcpy(tmpstr, "cars");
			if(tmpask > VehicleInfo[vehicleid][vCars])
			{
				tmpprice = dini_Int(compsfile, "carssellprice");
				tmpbcash = BusinessInfo[g][bTill];
				sdcash += (VehicleInfo[vehicleid][vCars]*tmpprice);
				tmpbcash -= (VehicleInfo[vehicleid][vCars]*tmpprice);
				tmpask -= VehicleInfo[vehicleid][vCars];
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] Van %s sold, %s still needs %d %s. Earned $%d!",tmpstr,BusinessInfo[g][bName], tmpask,tmpstr,(VehicleInfo[vehicleid][vCars]*tmpprice)/10);
				tmpcomps += VehicleInfo[vehicleid][vCars];
				GivePlayerMoneyEx(playerid,VehicleInfo[vehicleid][vCars]*(tmpprice/10));
				VehicleInfo[vehicleid][vCars] = 0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;
			}
			else if(tmpask<=VehicleInfo[vehicleid][vCars])
			{
				tmpprice = dini_Int(compsfile, "carssellprice");
				tmpbcash = BusinessInfo[g][bTill];
				tmpcomps += tmpask;
				VehicleInfo[vehicleid][vCars]-=tmpask;
				GivePlayerMoneyEx(playerid,tmpask*(tmpprice/10));
				sdcash=sdcash+(tmpask*tmpprice);
				SendClientMSG(playerid, COLOR_WHITE,"[SDC] %s has been restocked - You earned $%d!",BusinessInfo[g][bName], (tmpask*tmpprice)/10);
				tmpask=0;
				BusinessInfo[g][bComps] = tmpcomps;
				BusinessInfo[g][bAskComps] = tmpask;
				BusinessInfo[g][bTill] = tmpbcash;
				FactionInfo[factionID][fBank] = sdcash;
			}
		}
	}
	SaveBusiness(g);
	SaveVehicle(vehicleid);
	format( iStr, sizeof(iStr), "NEWS: The business %s has been restocked by the S.D.C.!", BusinessInfo[g][bName]);
	TextDrawSetString(TextDraw__News, iStr);
	return 1;
}

COMMAND:buycomps(playerid, params[])
{
    new carid = GetPlayerVehicleID(playerid);
    new vehicleid = FindVehicleID(carid);
	if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC)
		return SendClientError(playerid, CANT_USE_CMD);
    if(!IsPlayerInRangeOfPoint(playerid, 8.0, 585.54,888.89,-44.47))
		return SendClientError(playerid, "Not at the comps shop!");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return SendClientError(playerid, "You are not the driver!");
	if(VehicleInfo[vehicleid][vModel] != 455 && VehicleInfo[vehicleid][vModel] != 573)
		return SendClientError(playerid, "You are not driving the correct vehicle!");
	new type[11], amount, wat;
	if(sscanf(params, "ds", amount, type)) return SCP(playerid, "[amount] [type]");
    if(!strcmp(type,"stuffs",true))
    {
        if(VehicleInfo[vehicleid][vStuffs] == 0) VehicleInfo[vehicleid][vStuffs] = amount, wat = 0;
        else return SendClientError(playerid, "Too much loaded!");
    }
    else if(!strcmp(type,"guns",true))
    {
        if(VehicleInfo[vehicleid][vGuns] == 0) VehicleInfo[vehicleid][vGuns] = amount, wat = 1;
        else return SendClientError(playerid, "Too much loaded!");
    }
    else if(!strcmp(type,"alcohol",true))
    {
        if(VehicleInfo[vehicleid][vAlchool] == 0) VehicleInfo[carid][vAlchool] = amount, wat = 2;
        else return SendClientError(playerid, "Too much loaded!");
    }
    else if(!strcmp(type,"cars",true))
    {
        if(VehicleInfo[carid][vCars] == 0) VehicleInfo[vehicleid][vCars] = amount, wat = 3;
        else return SendClientError(playerid, "Too much loaded!");
    }
    else return SCP(playerid, "[amount] [type]");
    SendClientMSG(playerid, COLOR_WHITE, " [S.D.C.] Loaded %d comps of %s into your truck.", amount, type);
    SetTimerEx("RemoveFromQuarry", 4000, false, "dd", amount, wat);
    return 1;
}
COMMAND:restock(playerid, params[])
{
    if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 0) return SendClientError(playerid, CANT_USE_CMD);
	new tmpid = IsPlayerOutBiz(playerid);
	if(tmpid == -1) return SendClientError(playerid, "You are not in a business icon!");
	new tmp[10];
	if( sscanf ( params, "s", tmp)) return SCP(playerid, "[Yes/No]");
	if(!strcmp(tmp, "Yes", true)) BusinessInfo[tmpid][bRestock] = 1;
	else if(!strcmp(tmp, "No", true)) BusinessInfo[tmpid][bRestock] = 0;
	else return SCP(playerid, "[Yes/No]");
	format(iStr, sizeof(iStr), "S.D.C. restocking status on %s: %s", BusinessInfo[tmpid][bName], tmp);
	SendClientInfo(playerid, iStr);
	return 1;
}
COMMAND:checkruns(playerid, params[])
{
	if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 0) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr, sizeof(iStr), "%s has made a total of %d runs", RPName(iPlayer), PlayerInfo[iPlayer][totalruns]);
	SendClientInfo(playerid, iStr);
	return 1;
}
COMMAND:clearruns(playerid, params[])
{
    if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] > 0) return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr, sizeof(iStr), "[INFO] Runs of %s have been reset. Previously: %d | Now: 0", RPName(iPlayer), PlayerInfo[iPlayer][totalruns]);
	SendClientInfo(playerid, iStr);
	PlayerInfo[iPlayer][totalruns] = 0;
	return 1;
}
COMMAND:checkcomps(playerid, params[])
{
	if(GetPlayerFactionType(playerid) != FAC_TYPE_SDC && GetAdminLevel(playerid) < 1) return SendClientError(playerid, CANT_USE_CMD);
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
		if(BusinessInfo[b][bCompsFlag] != NOCOMPS)
		{
			new owner[MAX_PLAYER_NAME];
			myStrcpy(BusinessInfo[b][bOwner], owner);
			new tmpcomps = BusinessInfo[b][bComps];
			new tmpask = BusinessInfo[b][bAskComps];
			new restock = BusinessInfo[b][bRestock];
			new tmpstr[ 12 ], restockk[ 4 ];
			switch(BusinessInfo[b][bCompsFlag])
			{
				case GUNS: 		myStrcpy(tmpstr, "guns");
				case STUFFS: 	myStrcpy(tmpstr, "stuffs");
				case ALCHOOL:	myStrcpy(tmpstr, "alchool");
				case CARS: 		myStrcpy(tmpstr, "cars");
				default: 		myStrcpy(tmpstr, "N/A");
			}
			if(tmpask>0)
			{
				if(restock) myStrcpy(restockk, "Yes");
				else myStrcpy(restockk, "No");
				if(restock)
				{
				    format(iStr,sizeof(iStr),"{FFA500}[%s(%d)] {FFDAB9}Owner: %s - Comps: %d - Type: [%s] - Order: %d - Restock: {808000}%s{FFDAB9}",BusinessInfo[b][bName],b,NoUnderscore(owner),tmpcomps,tmpstr,tmpask, restockk);
					SendClientMessage(playerid,COLOR_YELLOW,iStr);
				}
				else
				{
				    format(iStr,sizeof(iStr),"{FFA500}[%s(%d)] {FFDAB9}Owner: %s - Comps: %d - Type: [%s] - Order: %d - Restock: {FF0000}%s{FFDAB9}",BusinessInfo[b][bName],b,NoUnderscore(owner),tmpcomps,tmpstr,tmpask, restockk);
					SendClientMessage(playerid,COLOR_RED,iStr);
				}
			}
		}
	}
	return 1;
}
COMMAND:admins(playerid)
{
	//SendClientMessage(playerid, 0x3776CCFF, "[Server Staff] {ABCBF5}Administrators:");
	SendClientMessage(playerid, 0x3776CCFF, "Online Administrators:");
	PlayerLoop(i)
	{
	    new iTag[50];
	    if((PlayerInfo[i][power] > 0 && PlayerInfo[i][helper] < 1 && PlayerInfo[i][power] != 31337) && IsPlayerConnected(i) && PlayerTemp[i][loggedIn])
	    {
	        if(PlayerTemp[i][adminduty] == 1) strcat(iTag, "{1A661A}ON-DUTY ");
	        if(IsPlayerAFK(i)) strcat(iTag, "AFK ");
			SendClientMSG(playerid, 0xe1e3e6FF, "  %s %s (ID: %d) %s", AdminLevelName(i), RPName(i), i, iTag);
		}
	}
	//SendClientMessage(playerid, 0x3776CCFF, "[Server Staff] {ABCBF5}Helpers:");
	SendClientMessage(playerid, 0x3776CCFF, "Online Helpers:");
	PlayerLoop(i)
	{
	    new iTag[50];
	    if((PlayerInfo[i][helper] > 0 && PlayerInfo[i][power] != 31337) && IsPlayerConnected(i) && PlayerTemp[i][loggedIn])
		{
            if(PlayerTemp[i][helperduty] == 1) strcat(iTag, "{1A661A}ON-DUTY");
	        if(IsPlayerAFK(i)) strcat(iTag, "AFK ");
			SendClientMSG(playerid, 0xe1e3e6FF, "  %s (ID: %d) %s", RPName(i), i, iTag);
 		}
	}
	return 1;
}
COMMAND:factions(playerid, params[])
{
	new iCount;
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		iCount++;
	}
	SendClientMessage(playerid, 0x248716FF, "{B0E0E6}Angel Pine's {FFFFFF}Factions");
	if(iCount == 0) return SendClientMessage(playerid, 0xFFFFFFFF, "There are currently no active factions in the server!");
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(FactionInfo[f][fType] == FAC_TYPE_FBI && PlayerInfo[playerid][power] < 5) continue; // skipping FBI faction, unless the player is admin level 5 or above.
		SendClientMSG(playerid, FactionInfo[f][fColour], " - %s | Online: %d | Members: %d / %d", FactionInfo[f][fName], GetOnlineMembers(f), GetTotalMembers(f), FactionInfo[f][fMaxMemberSlots]);
	}
	return 1;
}
COMMAND:whinfo(playerid, params[])
{
	SendClientMessage(playerid,COLOR_WHITE,"..:: Components in the warehouse ::..");
	SendClientMSG(playerid, COLOR_WHITE, " Guns: %d",  dini_Int(compsfile, "whguns"));
	SendClientMSG(playerid, COLOR_WHITE, " CarParts: %d",  dini_Int(compsfile, "whcars"));
	SendClientMSG(playerid, COLOR_WHITE, " Alcohol: %d",  dini_Int(compsfile, "whalchool"));
	SendClientMSG(playerid, COLOR_WHITE, " Stuffs: %d", dini_Int(compsfile, "whstuffs"));
	return 1;
}
COMMAND:o(playerid, params[])
{
	if(PlayerTemp[playerid][muted]) return SendClientError(playerid, "You are muted!");
	if(!oocenable && !PlayerInfo[playerid][power] && !PlayerInfo[playerid][helper]) return SendClientError(playerid, "OOC is off!");
	new iText[ 128 ];
	if(sscanf(params, "s", iText)) return SCP(playerid, "[msg]");
	if(PlayerInfo[playerid][power] || PlayerInfo[playerid][helper] || PlayerInfo[playerid][power] != 31337)
	{
		format(iStr,sizeof(iStr),"(( OOC | {CCFFCC}%s %s: %s {8bbc8b}))",AdminLevelName(playerid), AnonAdmin(playerid),iText);
		SendClientMessageToAll(0x8bbc8b00, iStr);
	}
	else
	{
		format(iStr,sizeof(iStr),"(( OOC | {CCFFCC}%s: %s {8bbc8b}))",RPName(playerid),iText);
		new iHead[128];
		format(iHead, sizeof(iHead), "(( OOC | {CCFFCC}%s:", RPName(playerid));
		PlayerLoop(f) { if(PlayerTemp[f][oocoff]==0) SendPlayerMessage(f,0x8bbc8b00,iStr,iHead); }
	}
	format(iStr, sizeof(iStr), "10(( [Global OOC]: %s %s: %s ))", AdminLevelName(playerid),PlayerName(playerid), iText);
	iEcho(iStr);
	return 1;
}
COMMAND:help(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"{FFFFFF}..:: {3196ef}Angel Pine {FF0000}Roleplay {FFFFFF} Server ::..");
	SendClientMessage(playerid, COLOR_WHITE,"..:: The following commands will help you, too: ::..");
	SendClientMessage(playerid, COLOR_WHITE,"..:: /commands /jobhelp /rules /animlist /credits ::..");
	return 1;
}
/* COMMAND:credits(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"=================================================================================");
	SendClientMessage(playerid, COLOR_WHITE,"ReD-ZerO - Script Founder!");
	SendClientMessage(playerid, COLOR_WHITE,"Algren - Script Co-Founder, Ex-Coder!");
 	SendClientMessage(playerid, COLOR_WHITE,"ryden - IRC bot coder, big helper!");
	SendClientMessage(playerid, COLOR_WHITE,"skatim - "
   	SendClientMessage(playerid, COLOR_WHITE,"woot, skatim, Cube, Slash, GiGi - Ex-Coders, big helpers!");
   	SendClientMessage(playerid, COLOR_GREY,"Massive thanks to everyone that contributed to development!");
	SendClientMessage(playerid, COLOR_GREEN,"=================================================================================");
	return 1;
} */
COMMAND:credits(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "Server Credits");
	ShowDialog(playerid, SRV_CREDITS);
	return 1;
}
COMMAND:radio(playerid, params[])
{
	SendClientMSG(playerid, COLOR_HELPEROOC, "[RADIO]: Slot1: %d | Slot2: %d | Slot3: %d", PlayerInfo[playerid][freq1],PlayerInfo[playerid][freq2],PlayerInfo[playerid][freq3]);
	return 1;
}
COMMAND:radiohelp(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "[Radio] ** Get faction frequency: /getfreq");
	SendClientMessage(playerid, COLOR_WHITE, "[Radio] ** Set frequency on slot X: /freq [slot] [frequency]");
	SendClientMessage(playerid, COLOR_WHITE, "[Radio] ** Slot to talk in: /syncradio [slot]");
	SendClientMessage(playerid, COLOR_WHITE, "[Info] ** Valid slots are 1, 2, 3.");
	return 1;
}
COMMAND:helpme(playerid, params[])
{
	SendClientMessage(playerid, COLOR_WHITE, "- will be added soon");
	ShowDialog(playerid, DIALOG_HELPME);
	return 1;
}
ALTCOMMAND:gps->helpme;
COMMAND:bug(playerid,params[])
{// need to send this through database w/ web page
	new iReason[ 128 ];
	if(sscanf(params, "s", iReason)) return SCP(playerid, "[what's wrong?]");
	format(iStr,sizeof(iStr),"(( [Bug] %s[%d]: %s ))",RPName(playerid),playerid,iReason);
	SendClientMessage(playerid, COLOR_GREEN, iStr);
	SendClientMessageToAdmins(iStr,COLOR_RED);
	format(iStr, sizeof(iStr), "4{BUG} %s{%d}: %s",PlayerName(playerid), playerid, iReason);
	iEcho( iStr );
	bugDB(playerid, iStr);
	return 1;
}
COMMAND:report(playerid, params[])
{
	if(PlayerTemp[playerid][muted]) return SendClientError(playerid, "You are muted!");
	new iPlayer, iReason[ 128 ];
	if( sscanf ( params, "us", iPlayer, iReason))  return SCP(playerid, "[PlayerID/PartOfName] [reason]");
	if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
	format(iStr,sizeof(iStr),"(( [Report] %s[%d] reported %s[%d]: %s ))",RPName(playerid),playerid,RPName(iPlayer),iPlayer,iReason);
	SendClientMessage(playerid, COLOR_PINK, iStr);
	SendClientMessageToAdmins(iStr,COLOR_PINK);
	if(PlayerInfo[playerid][playerlvl] <= 3)
	{
		LOOP:p(0, MAX_PLAYERS)
		{
			if(!IsPlayerConnected(p)) continue;
			if(PlayerTemp[p][loggedIn] != true) continue;
			if(PlayerInfo[p][helper] < 1) continue;
			SendClientMessage(p, COLOR_PINK, iStr);
		}
	}
	format( iStr, sizeof(iStr), "4[REPORT] %s[%d] has reported %s[%d]: %s",RPName(playerid),playerid,RPName(iPlayer),iPlayer,iReason);
	iEcho( iStr );
	return 1;
}
COMMAND:irc(playerid, params[])
{
	if(PlayerTemp[playerid][muted]) return SendClientError(playerid, "You are muted!");
	if(!ircenable) return SendClientError(playerid, "IRC is off!");
	new iReason[ 128 ];
	if( sscanf ( params, "s", iReason))  return SCP(playerid, "[message]");
	new iHead[128];
	format(iHead, sizeof(iHead), "[{B0E0E6}(ToIRC) %s(%d):", RPName(playerid), playerid);
	format(iStr,sizeof(iStr),"%s %s{7bb6bd}]", iHead, iReason);
	SendPlayerMessage(playerid,0x7bb6bdFF, iStr, iHead);
	PlayerLoop(qqq) if(PlayerInfo[qqq][power] || PlayerInfo[qqq][helper]) SendPlayerMessage(qqq, 0x7bb6bdFF, iStr, iHead);
	format( iStr, sizeof(iStr), "10(ToIRC): %s [%d]: %s",PlayerName(playerid), playerid, iReason);
	iEcho( iStr );
	return 1;
}
COMMAND:car(playerid, params[])
{
	new tmp[ 15 ], tmp2[ 15 ], tmp3[ 128 ];
	if(sscanf(params, "szz", tmp, tmp2, tmp3)) return SCP(playerid, "[ buy / sell / unsell / park / lock / help / tow / find / respray / savemod / unmod / dupekey / takekey / factionize / scrap / paintjob ]");
	new carid = GetPlayerVehicleID(playerid);
	//new vehicleid = FindVehicleID(carid);
	new vehicleid = FindVehicleID(GetPlayerVehicleID(playerid));
	new tmpid = IsPlayerOutBiz(playerid);
	if(!strcmp(tmp, "respray", true, 7))
	{
	    new bizz = IsPlayerOutBiz(playerid);
	    if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid), VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
	    if(PlayerTemp[playerid][sm] < BusinessInfo[bizz][bFee])
			return SendClientError(playerid, "Not enough money!");
	    if(bizz != -1 && BusinessInfo[bizz][bType] == BUSINESS_TYPE_PAYNSPRAY)
	    {
		    if(!strlen(tmp2) || !IsNumeric(tmp2) || !strlen(tmp3) || !IsNumeric(tmp3)) return SCP(playerid, "respray [ colour1 ] [ colour2 ]");
		    if(strlen(tmp2) > 5 || strlen(tmp3) > 5) return SendClientWarning(playerid, "Invalid colour ID!");
		    new c1 = strval(tmp2);
		    new c2 = strval(tmp3);
			if(c1 < 0 || c2 < 0) return SendClientWarning(playerid, "Invalid colour ID!");
		    ChangeVehicleColor(carid, c1, c2);
		    VehicleInfo[vehicleid][vColour1] = c1;
		    VehicleInfo[vehicleid][vColour2] = c2;
		    GameTextForPlayer(playerid, "~g~resprayed", 3000,1);

			GivePlayerMoneyEx(playerid, -BusinessInfo[bizz][bFee]);
			BusinessInfo[bizz][bComps] -= 2;
			BusinessInfo[bizz][bTill] += BusinessInfo[bizz][bFee];

		    format(iStr, sizeof(iStr), "6[VEHICLE] %s has resprayed their %s to %d and %d for $%d.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), c1, c2, BusinessInfo[bizz][bFee]);
			iEcho(iStr);
		    return 1;
	    }
	}
	else if(!strcmp(tmp,"wheels", true, 6))
	{
	    new bizz = IsPlayerOutBiz(playerid);
	    if(bizz != -1 && BusinessInfo[bizz][bType] == BUSINESS_TYPE_WHEEL)
	    {
	        if(!IsValidNOSVehicle(GetPlayerVehicleID(playerid))) return SendClientError(playerid, "This vehicle cannot have modified wheels!");
	        if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
			if(PlayerTemp[playerid][sm] < BusinessInfo[bizz][bFee]) return SendClientError(playerid, "Not enough money!");

			BusinessInfo[bizz][bComps] -= 1;
			BusinessInfo[bizz][bTill] += BusinessInfo[bizz][bFee];
			GivePlayerMoneyEx(playerid, -BusinessInfo[bizz][bFee]);

		    format(iStr, sizeof(iStr), "6[VEHICLE] %s is chosing wheels for their %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
			iEcho(iStr);
			ShowDialog(playerid, DIALOG_WHEELS, bizz);
		    return 1;
	    }
	    else
	    {
			new bizID = GetClosestBiz(playerid, BUSINESS_TYPE_WHEEL);
			if(bizID != -1)
			{
				SetPlayerCheckpoint(playerid, 3.0, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]);
				SendClientInfo(playerid, "Marker has been set to the closest wheel mod shop.");
			}
			else return SendClientError(playerid, "No wheel mod shops have been found near your.");
	        return 1;
	    }
	}
	else if(!strcmp(tmp, "paintjob", true, 8))
	{
	    new bizz = IsPlayerOutBiz(playerid);
	    if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid), VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
	    if(PlayerTemp[playerid][sm] < BusinessInfo[bizz][bFee])
			return SendClientError(playerid, "Not enough money!");
	    if(bizz != -1 && BusinessInfo[bizz][bType] == BUSINESS_TYPE_PAYNSPRAY)
	    {
			new mid = GetVehicleModel(GetPlayerVehicleID(playerid));
			if(mid != 483 && mid != 534 && mid != 535 && mid != 567 && mid != 536 && mid != 558 && mid != 559 && mid != 560 && mid != 558 && mid != 562 && mid != 561 && mid != 565 && mid != 576)
				return SendClientError(playerid, "You can't change the paintjob on this model!");
		    if(!strlen(tmp2) || !IsNumeric(tmp2)) return SCP(playerid, "paintjob [ paintjobID ]");
		    if(strlen(tmp2) > 5) return SendClientWarning(playerid, "Invalid paintjob ID!");
		    new c1 = strval(tmp2);
			if(c1 < -1 || c1 > 2) return SendClientWarning(playerid, "Invalid paintjob ID!");
		    VehicleInfo[vehicleid][vPaintJob] = c1;
			ChangeVehiclePaintjob(GetPlayerVehicleID(playerid), c1);

			BusinessInfo[bizz][bComps] -= 2;
			BusinessInfo[bizz][bTill] += BusinessInfo[bizz][bFee];
			GivePlayerMoneyEx(playerid, -BusinessInfo[bizz][bFee]);

		    format(iStr, sizeof(iStr), "6[VEHICLE] %s has paintjobbed their %s to %d for $%d.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), c1,  BusinessInfo[bizz][bFee]);
			iEcho(iStr);
		    return 1;
	    }
	    else
	    {
	        SendClientError(playerid, "You are not at the Pay N Spray Shop!");
			// [ToAddToScript] - Get closest Paint and Spray
	        return 1;
	    }
	}
	else if(!strcmp(tmp, "register", true, 8))
	{
	    new bizz = IsPlayerOutBiz(playerid);
	    if(bizz != -1 && BusinessInfo[bizz][bType] == BUSINESS_TYPE_VREGISTER)
		{
			if(!IsPlayerInAnyVehicle(playerid))
				return SendClientError(playerid, "You are not in any vehicle!");
			if(strcmp(PlayerName(playerid), VehicleInfo[vehicleid][vOwner], false))
				return SendClientError(playerid, "You do not own this vehicle!");
			if(PlayerTemp[playerid][sm] < BusinessInfo[bizz][bFee])
				return SendClientError(playerid, "Not enough money!");
			
			new iFormat[12], pName[MAX_PLAYER_NAME], lic[12];
			GetPlayerName(playerid, pName, sizeof(pName));
			LOOP:c(0, sizeof(pName))
			{
				if(c == 0) { strcat(lic, pName[0]); }
				if(pName[c] == '_') strcat(lic, pName[c+1]);
			}
			
			format(iFormat, sizeof(iFormat), "%s-%d", lic, vehicleid);
			myStrcpy(VehicleInfo[vehicleid][vPlate], iFormat);
			SendClientMSG(playerid, COLOR_LIGHTGREY, "Info: Your vehicle is now registered with the plate: %s!", VehicleInfo[vehicleid][vPlate]);
			SetVehicleNumberPlate(carid, VehicleInfo[vehicleid][vPlate]);
			VehicleInfo[vehicleid][vRegistered] = true;
			BusinessInfo[bizz][bComps] -= 1;
			BusinessInfo[bizz][bTill] += BusinessInfo[bizz][bFee];
			GivePlayerMoneyEx(playerid, -BusinessInfo[bizz][bFee]);
			SaveVehicle(vehicleid);
		    format(iStr, sizeof(iStr), "6[VEHICLE] %s has registered their %s for $%s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), number_format(BusinessInfo[bizz][bFee]));
			iEcho(iStr);
		    return 1;
	    }
	    else
	    {
	        SendClientError(playerid, "You need to be at the car register business to register a vehicle!");
	        return 1;
	    }
	}
	else if(!strcmp(tmp,"tog", true, 3))
	{
	    new iCarID = GetPlayerNearestVehicle(playerid);
	    vehicleid = FindVehicleID(iCarID);
		if(GetDistanceFromPlayerToVehicle(playerid, iCarID) > 5.0)
			return SendClientError(playerid, "There is no vehicle around you!");
		if(!strlen(tmp2) || IsNumeric(tmp2) || strlen(tmp2) > 8) return SCP(playerid, "tog [ Lights / Bonnet / Boot / Alarm / Door ]");
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(iCarID, engine, lights, alarm, doors, bonnet, boot, objective);
		if(!strcmp(tmp2, "lights", true, 6))
		{
		    if(lights == VEHICLE_PARAMS_ON)
		   	{
		   		SetVehicleParamsEx(iCarID, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
		   	}
		   	else
		   	{
		   		SetVehicleParamsEx(iCarID, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
		   	}
		}
		else if(!strcmp(tmp2, "bonnet", true, 6))
		{
		    if(bonnet == VEHICLE_PARAMS_ON)
		   	{
		   		SetVehicleParamsEx(iCarID, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
		   	}
		   	else
		   	{
		   		SetVehicleParamsEx(iCarID, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
		   	}
		}
		else if(!strcmp(tmp2, "boot", true, 4))
		{
		    if(boot == VEHICLE_PARAMS_ON)
		   	{
		   		SetVehicleParamsEx(iCarID, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
		   	}
		   	else
		   	{
		   		SetVehicleParamsEx(iCarID, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
		   	}
		}
		else if(!strcmp(tmp2, "alarm", true, 5))
		{
		    if(alarm == VEHICLE_PARAMS_ON)
		   	{
		   		SetVehicleParamsEx(iCarID, engine, lights, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
		   	}
		   	else
		   	{
		   		SetVehicleParamsEx(iCarID, engine, lights, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
		   	}
		}
		else if(!strcmp(tmp2, "door", true, 4))
		{
			new door1, door2, door3, door4;
			GetVehicleParamsCarDoors(iCarID, door1, door2, door3, door4);
			if(!strlen(tmp3) || !IsNumeric(tmp3) || strlen(tmp3) > 1) return SCP(playerid, "doors [ 1 (Driver) / 2 (Passenger) / 3 (back left) / 4 (back right) ]");
			new doorID = strval(tmp3);
			if(doorID == 1)
			{
				if(door1 == VEHICLE_PARAMS_ON) SetVehicleParamsCarDoors(iCarID, VEHICLE_PARAMS_OFF, door2, door3, door4);
				else SetVehicleParamsCarDoors(iCarID, VEHICLE_PARAMS_ON, door2, door3, door4);
			}
			else if(doorID == 2)
			{
				if(door2 == VEHICLE_PARAMS_ON) SetVehicleParamsCarDoors(iCarID, door1, VEHICLE_PARAMS_OFF, door3, door4);
				else SetVehicleParamsCarDoors(iCarID, door1, VEHICLE_PARAMS_ON, door3, door4);
			}
			else if(doorID == 3)
			{
				if(door3 == VEHICLE_PARAMS_ON) SetVehicleParamsCarDoors(iCarID, door1, door2, VEHICLE_PARAMS_OFF, door4);
				else SetVehicleParamsCarDoors(iCarID, door1, door2, VEHICLE_PARAMS_ON, door4);
			}
			else if(doorID == 4)
			{
				if(door4 == VEHICLE_PARAMS_ON) SetVehicleParamsCarDoors(iCarID, door1, door2, door3, VEHICLE_PARAMS_OFF);
				else SetVehicleParamsCarDoors(iCarID, door1, door2, door3, VEHICLE_PARAMS_ON);
			}
			else return SCP(playerid, "doors [ 1 (Driver) / 2 (Passenger) / 3 (back left) / 4 (back right) ]");
		}
		else return SCP(playerid, "tog [ Lights / Bonnet / Boot / Alarm / Door ]");
	}
	else if(!strcmp(tmp, "dupekey", true, 7))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
		if(!strlen(tmp2) || !IsNumeric(tmp2) || strlen(tmp2) > 5)
			return SCP(playerid, "dupekey [ PLAYERID ]");
		new giveplayerid = strval(tmp2);
		if(!IsPlayerConnected(giveplayerid))
			return SendClientError(playerid, "Player not found!");
		if(GetDistanceBetweenPlayers(playerid, giveplayerid) > 10)
		    return SendClientError(playerid, "He is too far away!");
	    myStrcpy(VehicleInfo[vehicleid][vDupekey], PlayerName(giveplayerid));
		format(iStr, sizeof(iStr),"has given the keys of their %s to %s.", GetVehicleName(GetPlayerVehicleID(playerid)), MaskedName(giveplayerid));
	   	Action(playerid, iStr);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has given their %s dupe-key to %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), PlayerName(giveplayerid));
		iEcho(iStr);
	}
	else if(!strcmp(tmp, "takekey", true, 7))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
	    myStrcpy(VehicleInfo[vehicleid][vDupekey], "NoBodY");
	    SendClientMessage(playerid, COLOR_LIGHTGREY,"Info: The key has been taken away!");
	}
	else if(!strcmp(tmp, "factionize", true, 10))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
		if(PlayerInfo[playerid][playerteam] == CIV)
			return SendClientError(playerid, "You are not in a faction!");
		if(FactionCarCount(PlayerInfo[playerid][playerteam]) >=  FactionInfo[GetPlayerFaction(playerid)][fMaxVehicles])
			    return SendClientError(playerid, "Your faction has reached the limit of factioncars!");

	    SendClientInfo(playerid, "Success: The vehicle is now bound to the faction.");

	    VehicleInfo[vehicleid][vFaction] = PlayerInfo[playerid][playerteam];
	    myStrcpy(VehicleInfo[vehicleid][vOwner], "NoBodY");
	    myStrcpy(VehicleInfo[vehicleid][vDupekey], "NoBodY");

	    UnlockVehicle(GetPlayerVehicleID(playerid));
	    SendClientInfo(playerid, "Your vehicle has been factionized! You will not ever receive a refund for it.");
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has factionized their %s to %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), GetPlayerFactionName(playerid));
		iEcho(iStr);
		format(iStr, sizeof(iStr), "# [%s] %s %s has just factionized a %s", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam], iStr, COLOR_PLAYER_VLIGHTBLUE);
	}
	else if(!strcmp(tmp, "biz", true, 3))
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
		if(strcmp(PlayerName(playerid),BusinessInfo[tmpid][bOwner],false)==0)
			return SendClientError(playerid, "You do not own any 'rentcar' business type!");			
		new bizID = VehicleInfo[FindVehicleID(carid)][vBusiness];
		VehicleInfo[FindVehicleID(GetPlayerVehicleID(playerid))][vBusiness] = bizID;
	    SendClientInfo(playerid, "Success: The vehicle is now bound to the business.");


	    UnlockVehicle(GetPlayerVehicleID(playerid));
	    SendClientInfo(playerid, "Your vehicle has been set to your biz! You will not ever receive a refund for it.");
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has set their %s to the rent-a-car biz.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		iEcho(iStr);
	}
	else if(!strcmp(tmp, "sell", true, 4))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner], false)) return SendClientError(playerid, "You do not own this vehicle!");
	    if(!IsPlayerInCarlot(playerid))
	    {
            SendClientError(playerid, "You are not at the carlot!");
	        SetPlayerCheckpoint(playerid, 339.0500,-1799.2393,4.7262, 3.0);
	        return 1;
		}
	    if(!strlen(tmp2) || !IsNumeric(tmp2) || strlen(tmp2) > 9)
			return SCP(playerid, "sell [amount]");
	    new themodel = strval(tmp2);
	    if(themodel < 1 || themodel > 5000000)
			return SendClientError(playerid, "Invalid amount! $1 - $5,000,000");
	    format(iStr, sizeof(iStr), "~r~sale: ~w~$%d", themodel);
	    GameTextForPlayer(playerid, iStr, 3000, 1);
	    VehicleInfo[vehicleid][vSellPrice] = themodel;
	    SendClientMessage(playerid, COLOR_LIGHTGREY,"Info: Your vehicle is now on sale. Other people are able to buy it!");
	    TogglePlayerControllable(playerid, true);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has put their %s on sale for $%d.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), themodel);
		iEcho(iStr);
		new randPos = minrand(0, sizeof(VehicleSellPositions));
	    VehicleInfo[vehicleid][vX] = VehicleSellPositions[randPos][spawnx];
	    VehicleInfo[vehicleid][vY] = VehicleSellPositions[randPos][spawny];
	    VehicleInfo[vehicleid][vZ] = VehicleSellPositions[randPos][spawnz];
	    VehicleInfo[vehicleid][vA] = VehicleSellPositions[randPos][spawna];
		VehicleInfo[vehicleid][vVirtualWorld] = 0;
	    ReloadVehicle(vehicleid);
	    Up(playerid);
	}
	else if(!strcmp(tmp, "tow", true, 3))
	{
	    if(!strlen(tmp2) || !IsNumeric(tmp2) || strlen(tmp2) > 5)
			return SCP(playerid, "tow [vehicleID (/myvehicles)]");
	    new themodel = strval(tmp2);
	    if(themodel < 0 || themodel > MAX_VEHICLES)
			return SendClientError(playerid, "Invalid vehicle ID!");
		if(VehicleInfo[themodel][vActive] != true)
		    return SendClientError(playerid, "This vehicle hasn't been found inside our database.");
	    if(strcmp(PlayerName(playerid),VehicleInfo[themodel][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
	    if(IsVehicleOccupied(GetCarID(themodel)))
			return SendClientError(playerid, "The vehicle is currently occupied!");
		new iPrice;
		if(PlayerInfo[playerid][playerlvl] < 15) iPrice = 0;
		else iPrice = 150;
		if(iPrice != 0 && HandMoney(playerid) < iPrice) return SendClientError(playerid, "You don't have enough money!");
	    ReloadVehicle(themodel);
	    SendClientMessage(playerid, COLOR_LIGHTGREY,"Info: Your vehicle has been towed!");
	    if(iPrice) GameTextForPlayer(playerid, "~r~$-150", 3000,1);
	    GivePlayerMoneyEx(playerid, -iPrice);
	    new bizid = GetClosestBiz(playerid, BUSINESS_TYPE_GOV);
	    BusinessInfo[bizid][bTill] += 150;
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has towed their %s.", PlayerName(playerid), GetVehicleName(VehicleInfo[themodel][vModel]));
		iEcho(iStr);
	}
 	else if(!strcmp(tmp, "find", true, 4))
	{
		ShowDialog(playerid, DIALOG_V_FIND);
	}
	else if(!strcmp(tmp, "buy", true, 3))
	{
	    if(GetPlayerCars(playerid) >= PlayerInfo[playerid][vMax])
			return SendClientError(playerid, "Sorry, you have no slots left!");
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendClientError(playerid, "You must be the driver!");
	    if(!strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You cannot buy your own vehicle!");
	    if(VehicleInfo[vehicleid][vSellPrice] == 0)
			return SendClientError(playerid, "This vehicle is not on sale!");
	    if(PlayerTemp[playerid][sm] < VehicleInfo[vehicleid][vSellPrice])
			return SendClientError(playerid, "You don't have enough cash!");
	    format(iStr, sizeof(iStr), "~r~-$%d", VehicleInfo[vehicleid][vSellPrice]);
	    GameTextForPlayer(playerid, iStr, 3000,1);
	    SetBank(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],VehicleInfo[vehicleid][vSellPrice]); // procedure
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has bought a %s of %s for $%d.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)),VehicleInfo[vehicleid][vOwner],VehicleInfo[vehicleid][vSellPrice] );
		iEcho(iStr);
		AppendTo(moneylog, iStr);
	    myStrcpy(VehicleInfo[vehicleid][vOwner], PlayerName(playerid));
	    format(iStr, sizeof(iStr), "Info: You have bought this vehicle for $%d! For help, please use /car help!",VehicleInfo[vehicleid][vSellPrice]);
	    SendClientMessage(playerid, COLOR_LIGHTGREY,iStr);
	    SendClientMessage(playerid, COLOR_LIGHTGREY," Note: Please take a screenshot of /myvehicles!");
	    VehicleInfo[vehicleid][vSellPrice] = 0;
	    TogglePlayerControllable(playerid, true);
	    SaveVehicle(vehicleid);
	}
	else if(!strcmp(tmp, "unsell", true, 6))
	{
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false)) return SendClientError(playerid, "You do not own this vehicle!");
	    VehicleInfo[vehicleid][vSellPrice] = 0;
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "Info: Your vehicle is nolonger on sale. It cannot be bought anymore.");
	    TogglePlayerControllable(playerid, true);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has put their %s nolonger on sale.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		iEcho(iStr);
	}
	else if(!strcmp(tmp, "lock", true, 4))
	{
	    new iCarID = GetPlayerNearestVehicle(playerid);
	    vehicleid = FindVehicleID(iCarID);
		if(GetDistanceFromPlayerToVehicle(playerid, iCarID) > 5.0)
			return SendClientError(playerid, "There is no vehicle around you!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false) && strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vDupekey],false))
			return SendClientError(playerid, "You do not own this vehicle and you don't have the dupe keys!");
   		if(VehicleInfo[vehicleid][vLocked] == true)
    	{
			if(DoesVehicleHaveLock(iCarID) == true)
			{
				UnlockVehicle(iCarID);
				format(iStr, sizeof(iStr),"has unlocked the doors of their %s.", GetVehicleName(iCarID));
				Action(playerid, iStr);
			}
			else return SendClientError(playerid, "This vehicle doesn't have a lock.");
    		return 1;
    	}
    	else if(VehicleInfo[vehicleid][vLocked] == false)
	    {
			if(DoesVehicleHaveLock(iCarID) == true)
			{
				LockVehicle(-1, iCarID); // nobody can open it
				format(iStr, sizeof(iStr),"has locked the doors of their %s.",GetVehicleName(iCarID));
				Action(playerid, iStr);
			}
			else return SendClientError(playerid, "This vehicle doesn't have a lock.");
		   	return 1;
   		}
    	return 1;
	}
	else if(!strcmp(tmp, "scrap", true, 5))
	{
	    if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid), VehicleInfo[vehicleid][vOwner], false))
			return SendClientError(playerid, "You do not own this vehicle!");
		if(GetVehiclePrice(GetVehicleModel(GetPlayerVehicleID(playerid))) == -1)
			return SendClientError(playerid, "This vehicle isn't scrapable.");
	    new reward = GetVehiclePrice(GetVehicleModel(GetPlayerVehicleID(playerid))) / 4;
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has scrapped their %s and received $%s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)), number_format(reward));
		iEcho(iStr);
		AppendTo(moneylog,iStr);
		GivePlayerMoneyEx(playerid, reward);
		format(iStr, sizeof(iStr), "You have scrapped this %s and received $%s, you cannot get it back anymore!", GetVehicleName(GetPlayerVehicleID(playerid)), number_format(reward));
		SendClientInfo(playerid, iStr);

	    DeleteVehicle(vehicleid);
	    return 1;
	}
	else if(!strcmp(tmp, "park", true, 4))
	{
	    if(!IsPlayerInAnyVehicle(playerid))
			return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false))
			return SendClientError(playerid, "You do not own this vehicle!");
		new Float:pX, Float:pY, Float:pZ, Float:pA;
	    GetVehiclePos(GetPlayerVehicleID(playerid), pX, pY, pZ);
		GetVehicleZAngle(GetPlayerVehicleID(playerid), pA);

	    VehicleInfo[vehicleid][vX] = pX;
	    VehicleInfo[vehicleid][vY] = pY;
	    VehicleInfo[vehicleid][vZ] = pZ;
	    VehicleInfo[vehicleid][vA] = pA;
		VehicleInfo[vehicleid][vVirtualWorld] = GetPlayerVirtualWorld(playerid);
	    Up(playerid);
		SaveVehicle(vehicleid);
	    ReloadVehicle(vehicleid);
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "Info: You have parked your vehicle. From now, it will spawn here!");
	    GameTextForPlayer(playerid, "~r~$-150", 3000,1);
	    SetTimerEx("PutPlayerInVehicleEx", 500, false, "dd", playerid, vehicleid);
	    GivePlayerMoneyEx(playerid, -150);

	    new bizid = GetClosestBiz(playerid, BUSINESS_TYPE_GOV);
	    BusinessInfo[bizid][bTill] += 150;
		/* 	    new count;
	    BusinessLoop(b)
	    {
	        if(BusinessInfo[b][bActive] != true) continue;
	        if(BusinessInfo[b][bType] != BUSINESS_TYPE_GOV) continue;
	        count++;
	    }
	    BusinessLoop(b)
	    {
	        if(BusinessInfo[b][bActive] != true) continue;
	        if(BusinessInfo[b][bType] != BUSINESS_TYPE_GOV) continue;
	        BusinessInfo[b][bTill] += (150 / count);
	    } */
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has parked their %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		iEcho(iStr);
		return 1;
	}
	else if(!strcmp(tmp, "help", true, 4))
	{
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car buy{afafaf} - Ability to buy a vehicle, if it is on sale. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car sell [price]{afafaf} - Set your vehicle on sale. Other people may buy it. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car unsell{afafaf} - Stop your vehicle from being sold. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car lock{afafaf} - Toggle the lock of your vehicle from in/outside. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car find [ID]{afafaf} - Find your vehicle, if it isn't occupied. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car respray{afafaf} - Respray your vehicle at the PNS business.. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car tow [ID]{afafaf} - Tow your vehicle ($15000), if it isn't occupied. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car call [ID]{afafaf} - Call your vehicle to you ($9000), if it isn't occupied. {228B22}]");
		SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car savemod{afafaf} - Save the tuning of your vehicle. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car unmod{afafaf} - Remove the tuning of your vehicle. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car factionize{afafaf} - Make your car belong to your faction. {228B22}]");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "{228B22}[ {FFFFFF}/car scrap{afafaf} - Delete your vehicle - no refund! {228B22}]");
	}
	else if(!strcmp(tmp, "savemod", true, 7))
	{
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false)) return SendClientError(playerid, "You do not own this vehicle!");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "Info: Your modifications have been saved!");
		LOOP:i(0, 13)
		{
			VehicleInfo[ vehicleid ][ vComponents ] [ i ] = GetVehicleComponentInSlot(carid, i);
		}
		SaveVehicle(vehicleid);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has saved the tuning of their %s.", PlayerName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		iEcho(iStr);
	}
	else if(!strcmp(tmp, "unmod", true, 5))
	{
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You are not in any vehicle!");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false)) return SendClientError(playerid, "You do not own this vehicle!");
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "Info: Your modifications have been removed! (Paintjob upon respawn)");
	    UnModCar(carid);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has removed the tuning of their %s.", PlayerName(playerid), GetVehicleName(carid));
		iEcho(iStr);
	}
	else if(!strcmp(tmp, "payfee", true, 7))
	{
	    carid = GetPlayerNearestVehicle(playerid);
	    vehicleid = FindVehicleID(carid);
		if(!IsPlayerAtImpound(playerid))
			return SendClientError(playerid, "You are not at the car impound!");
		if(GetDistanceFromPlayerToVehicle(playerid, carid) > 3.0)
			return SendClientError(playerid, "There is no vehicle around you! You must stand ON it.");
	    if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false) && strcmp("NoBodY",VehicleInfo[vehicleid][vOwner],true))
			return SendClientError(playerid, "You do not own this vehicle!");
		new fee = VehicleInfo[vehicleid][vImpoundFee];
 		if(HandMoney(playerid) < fee)
			return SendClientError(playerid, "You don't have enough money on hand!");
		if(fee == 666)
			return SendClientError(playerid, "You cannot unimpound your vehicle  at this time!");
		GivePlayerMoneyEx(playerid, -fee);
		SendClientMSG(playerid, COLOR_HELPEROOC, "[IMPOUND] Paid $%d to unimpound your %s!", fee, GetVehicleName(carid));
		if(!dini_Isset(globalstats, "unimpoundslot")) dini_IntSet(globalstats, "unimpoundslot", 0);
	    new ri = dini_Int(globalstats, "unimpoundslot");
		if(ri >= sizeof(unimpoundpos))
		{
			ri = 0;
			dini_IntSet(globalstats, "unimpoundslot", 0);
		}
		else dini_IntSet(globalstats, "unimpoundslot", ri+1);

	    VehicleInfo[vehicleid][vX] = unimpoundpos[ri][spawnx];
	    VehicleInfo[vehicleid][vY] = unimpoundpos[ri][spawny];
	    VehicleInfo[vehicleid][vZ] = unimpoundpos[ri][spawnz];
	    VehicleInfo[vehicleid][vA] = unimpoundpos[ri][sangle];
		VehicleInfo[vehicleid][vVirtualWorld] = 0;
	    VehicleInfo[vehicleid][vImpounded] = 0;
	    VehicleInfo[vehicleid][vImpoundFee] = 0;
		myStrcpy(VehicleInfo[vehicleid][vImpoundReason], "None");

	    ReloadVehicle(vehicleid);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has un-impounded their %s for $%d.", PlayerName(playerid), GetVehicleName(vehicleid), fee);
		iEcho(iStr);
		return 1;
	}
	else if(!strcmp(tmp, "impound", true, 7))
	{
	    carid = GetPlayerNearestVehicle(playerid);
	    vehicleid = FindVehicleID(carid);
	    if(!IsPlayerFED(playerid)) return SendClientError(playerid, "You may not use this.");
		if(!IsPlayerAtImpound(playerid)) return SendClientError(playerid, "You are not at the car impound!");
	    if(!strlen(tmp2) || !IsNumeric(tmp2) || !strlen(tmp3)) return SCP(playerid, "impound [ fee ] [ reason ]");
		if(strval(tmp2) < 0 || strval(tmp2) > 5000) return SendClientError(playerid, "Invalid amount! (max $5,000)");
		if(!VehicleInfo[vehicleid][vFaction] && !strcmp(VehicleInfo[vehicleid][vOwner],"NoBodY",true))
			return SendClientError(playerid, "You cannot impound unowned vehicles!");
		if(GetDistanceFromPlayerToVehicle(playerid, carid) > 3.0)
			return SendClientError(playerid, "There is no vehicle around you! You must stand ON it.");

		SendClientMessage(playerid, COLOR_LIGHTGREY, "Info: This car has been impounded!");
		new Float:cPos[4];
	    GetVehiclePos(carid, cPos[0], cPos[1], cPos[2]);
	    GetVehicleZAngle(carid, cPos[3]);

	    VehicleInfo[vehicleid][vX] = cPos[0];
	    VehicleInfo[vehicleid][vY] = cPos[1];
	    VehicleInfo[vehicleid][vZ] = cPos[2];
	    VehicleInfo[vehicleid][vA] = cPos[3];
		VehicleInfo[vehicleid][vVirtualWorld] = 0;
	    VehicleInfo[vehicleid][vImpounded] = 1;
	    VehicleInfo[vehicleid][vImpoundFee] = strval(tmp2);
	    myStrcpy(VehicleInfo[vehicleid][vImpoundReason], tmp3);

	    ReloadVehicle(vehicleid);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has impounded a %s of %s.", PlayerName(playerid), GetVehicleName(carid), VehicleInfo[vehicleid][vOwner]);
		iEcho(iStr);
		return 1;
 	}
	else if(!strcmp(tmp, "unimpound", true, 9))
	{
		carid = GetPlayerNearestVehicle(playerid);
		vehicleid = FindVehicleID(carid);

		if(!IsPlayerFED(playerid) && PlayerInfo[playerid][power] < 10)
			return SendClientError(playerid, "You may not use this.");
		if(!IsPlayerAtImpound(playerid))
			return SendClientError(playerid, "You are not at the car impound!");
        if(GetDistanceFromPlayerToVehicle(playerid, carid) > 3.0)
			return SendClientError(playerid, "There is no vehicle around you! You must stand ON it.");
		if(VehicleInfo[vehicleid][vImpounded] == 0)
		    return SendClientError(playerid, "This car is not impounded!");

	    SendClientMessage(playerid, COLOR_LIGHTGREY, "Info: This car has been un-impounded!");
		if(!dini_Isset(globalstats, "unimpoundslot"))
			dini_IntSet(globalstats, "unimpoundslot", 0);
	    new ri = dini_Int(globalstats, "unimpoundslot");
		if(ri >= sizeof(unimpoundpos))
		{
			ri = 0;
			dini_IntSet(globalstats, "unimpoundslot", 0);
		}
		else dini_IntSet(globalstats, "unimpoundslot", ri+1);
	    VehicleInfo[vehicleid][vX] = unimpoundpos[ri][spawnx];
	    VehicleInfo[vehicleid][vY] = unimpoundpos[ri][spawny];
	    VehicleInfo[vehicleid][vZ] = unimpoundpos[ri][spawnz];
	    VehicleInfo[vehicleid][vA] = unimpoundpos[ri][sangle];
		VehicleInfo[vehicleid][vVirtualWorld] = 0;
	    VehicleInfo[vehicleid][vImpounded] = 0;
	    VehicleInfo[vehicleid][vImpoundFee] = 0;
	    myStrcpy(VehicleInfo[vehicleid][vImpoundReason], "None");
	    ReloadVehicle(vehicleid);
	    format(iStr, sizeof(iStr), "6[VEHICLE] %s has un-impounded a %s of %s.", PlayerName(playerid), GetVehicleName(vehicleid), VehicleInfo[vehicleid][vOwner]);
		iEcho(iStr);
	}
	else return SCP(playerid, "[ buy / sell / unsell / park / lock / help / tow / find / respray / savemod / unmod / dupekey / takekey / factionize / scrap / paintjob ]");
	return 1;
}
COMMAND:engine(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You need to be in a vehicle to use this!");
	new carid = GetPlayerVehicleID(playerid);
	new vehicleid = FindVehicleID(carid);
	if(DoesVehicleHaveEngine(carid) == false)
		return SendClientError(playerid, "This vehicle doens't have an engine.");
	if(strcmp(PlayerName(playerid),VehicleInfo[vehicleid][vOwner],false) && strcmp("NoBodY",VehicleInfo[vehicleid][vOwner],true))
		return SendClientError(playerid, "You do not own this vehicle!");
	new Float:vHealth;
	GetVehicleHealth(carid, vHealth);
	if(vHealth < 250.0) return SendClientError(playerid, "Couldn't start engine! Vehicle damaged.");
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	new string[256];
	if(engine == 1)
	{
	    SetVehicleParamsEx(carid, 0, 0, alarm, doors, bonnet, boot, objective); //engine lights stopped
		format(string, sizeof(string), "* %s turns the vehicles engine off.", MaskedName(playerid));
		ProxDetectorEx(30.0, playerid, string, COLOR_ME);
	}
	else
	{
	    SetVehicleParamsEx(carid, 1, 1, alarm, doors, bonnet, boot, objective); //engine lights started
		format(string, sizeof(string), "* %s turns the engine of their %s on.", MaskedName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
		ProxDetectorEx(30.0, playerid, string, COLOR_ME);
	}
	return 1;
}
COMMAND:refuel(playerid, params[])
{
	if(GetPVarInt(playerid, "PetrolCan") == 1)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	        return SendClientError(playerid, "You cannot fill your vehicle from inside.");
		new carid = GetPlayerNearestVehicle(playerid);
		new vehicleid = FindVehicleID(carid);

		if(GetDistanceFromPlayerToVehicle(playerid, carid) > 5.0)
			return SendClientError(playerid, "There is no vehicle around you!");

		DeletePVar(playerid, "PetrolCan");
		SendClientInfo(playerid, "Your vehicle has been fully refilled and your petrol canister has been dropped.");
		VehicleInfo[vehicleid][vFuel] = 100;
		SaveVehicle(vehicleid);
		format(iStr,sizeof(iStr),"has used a Petrol Canister to refuel the %s.", GetVehicleName(carid));
		Action(playerid, iStr);
		return 1;
	}
	else
	{
		new bool:isAtGas = false;
		for(new y=0;y<sizeof(gasstation);y++)
		{
			if(IsPlayerInRangeOfPoint(playerid,gasstation[y][radius], gasstation[y][centerx],gasstation[y][centery],gasstation[y][centerz]))
			{
				isAtGas = true;
				if(!IsPlayerInAnyVehicle(playerid))
				{
					new carid = GetPlayerNearestVehicle(playerid);
					new vehicleid = FindVehicleID(carid);
					if(GetDistanceFromPlayerToVehicle(playerid, carid) < 5.1)
					{
						new engine, lights, alarm, doors, bonnet, boot, objective;
						GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
						if(engine != 0) return SendClientError(playerid, "The engine of the vehicle must be turned off.");
						new price = (100 - VehicleInfo[vehicleid][vFuel] * 2);
						GivePlayerMoneyEx(playerid, -price);
						new benzidEx = GetClosestBiz(playerid, BUSINESS_TYPE_GAS);
						if(benzidEx != -1)
						{
							new tmpbank = BusinessInfo[benzidEx][bTill];
							tmpbank = tmpbank + (price * 4);
							new tmpcomps = BusinessInfo[benzidEx][bComps];
							tmpcomps = tmpcomps - price;
							BusinessInfo[benzidEx][bComps] = tmpcomps;
							BusinessInfo[benzidEx][bTill] = tmpbank;
						}
						new Float:carposX,Float:carposY,Float:carposZ;
						GetVehiclePos(carid,carposX,carposY,carposZ);
						Refuel(playerid, carid, carposX);
						new iFormat[228];
						format(iFormat, sizeof(iFormat), "is now refueling their %s for a price of $%s!", GetVehicleName(carid), number_format(price));
						Action(playerid, iFormat);
					}
					else return SendClientError(playerid, "You are not close enough to a vehicle.");
				}
				else return SendClientError(playerid, "You must be outside of the vehicle in order to refuel a vehicle.");
			}
		}
		if(isAtGas == false) return SendClientError(playerid, "You need to be at a gas station in order to use this or buy a petrol canister.");
	}
   	return 1;
}
COMMAND:eject(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientError(playerid, CANT_USE_CMD);
	new iPlayer;
	if( sscanf ( params, "u", iPlayer))  return SCP(playerid, "[PlayerID/PartOfName]");
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(iPlayer) == GetPlayerVehicleID(playerid))
	{
		RemovePlayerFromVehicle(iPlayer);
		format(iStr, sizeof(iStr), "throws %s out of the vehicle.", MaskedName(iPlayer));
		Action(playerid, iStr);
	}
	return 1;
}
COMMAND:lock(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    new carid = GetPlayerVehicleID(playerid);
	    new vehicleid = FindVehicleID(carid);
		if(DoesVehicleHaveLock(carid) == false) return SendClientError(playerid, "This vehicle doesn't have a lock.");
		if(VehicleInfo[vehicleid][vReserved] == VEH_RES_NOOBIE || VehicleInfo[vehicleid][vReserved] == VEH_RES_MONEYVAN) return SendClientMessage(playerid,COLOR_GREY,"[LOCK]: You can't lock this vehicle.");
	    if(!strcmp(VehicleInfo[vehicleid][vOwner],PlayerName(playerid), false))
			return OnPlayerCommandText(playerid, "/car lock");
	    else if(strcmp(VehicleInfo[vehicleid][vOwner],"NoBodY", false))
			return SendClientError(playerid, "You don't have the keys for this vehicle!");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return SendClientMessage(playerid,COLOR_GREY,"[LOCK]: You can only lock the doors as the driver.");
		SendClientMessage(playerid, COLOR_GREY, "[LOCK]: Vehicle locked! (10minutes)");
		format(iStr, sizeof(iStr),"has locked the doors of the %s.",GetVehicleName(GetPlayerVehicleID(playerid)));
	    Action(playerid, iStr);
		SetTimerEx("OpenCars", 300000, 0, "i", GetPlayerVehicleID(playerid));
		PlayerPlaySound(playerid,1056,0,0,0);
		LockVehicle(playerid, GetPlayerVehicleID(playerid));
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GREY, "[LOCK]: You're not in a vehicle!");
}
COMMAND:unlock(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid,COLOR_GREY,"[LOCK]: You can only unlock the doors as the driver.");
		if(DoesVehicleHaveLock(GetPlayerVehicleID(playerid)) == false) return SendClientError(playerid, "This vehicle doesn't have a lock.");
		SendClientMessage(playerid, COLOR_GREY, "[LOCK]: Vehicle unlocked!");
		format(iStr, sizeof(iStr),"has unlocked the doors of the %s.", GetVehicleName(GetPlayerVehicleID(playerid)));
	    Action(playerid, iStr);
		PlayerPlaySound(playerid,1056,0,0,0);
		UnlockVehicle(GetPlayerVehicleID(playerid));
		return 1;
	}
	else return SendClientMessage(playerid, COLOR_GREY, "[LOCK]: You're not in a vehicle!");
}
COMMAND:toolkit(playerid)
{
	if(GetPVarInt(playerid, "Toolkit") == 0)
		return SendClientError(playerid, "You don't have a toolkit!");
	if(GetPVarInt(playerid, "BreakingIntoCar"))
		return SendClientError(playerid, "You are already using the toolkit!");
	BreakIntoNearestCar(playerid, 0);
	return 1;
}
COMMAND:rentcar(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientError(playerid, "You are not the driver!");
	new carid = GetPlayerVehicleID(playerid);
	if(VehicleInfo[FindVehicleID(carid)][vReserved] == VEH_RES_RENT && PlayerTemp[playerid][rentcar] != FindVehicleID(carid) && VehicleInfo[FindVehicleID(carid)][vBusiness] != -1)
	{
		PlayerTemp[playerid][rentcar] = FindVehicleID(carid);
		TogglePlayerControllable(playerid, true);
		new tmpprice, tmpcash, bizID = VehicleInfo[FindVehicleID(carid)][vBusiness];
		tmpcash = BusinessInfo[bizID][bTill];
		tmpcash = BusinessInfo[bizID][bRentPrice];
		GivePlayerMoneyEx(playerid,-tmpprice);
		BusinessInfo[bizID][bTill] += tmpcash;
		return 1;
	}
	return 1;
}
COMMAND:storegun(playerid, params[])
{	
	new weaponid = GetPlayerWeapon(playerid);
	if(!weaponid) return SendClientError(playerid, "You aren't holding any weapon!");
	new ammoo = GetPlayerAmmo(playerid), weaponslot = GetWeaponSlot(weaponid), carid = GetPlayerNearestVehicle(playerid);
	new houseid = PlayerTemp[playerid][tmphouse];
	if(GetDistanceFromPlayerToVehicle(playerid, carid) < 5.1)
	{
		if(VehicleInfo[FindVehicleID(carid)][vWeapon][GetWeaponSlot(weaponid)] != 0 && weaponid == VehicleInfo[FindVehicleID(carid)][vWeapon][GetWeaponSlot(weaponid)]) // slot is already taken, but it's the same gun... add bullets.
		{
			VehicleInfo[FindVehicleID(carid)][vWeapon][GetWeaponSlot(weaponid)] = weaponid;
			VehicleInfo[FindVehicleID(carid)][vAmmo][GetWeaponSlot(weaponid)] += ammoo;	
		}
		else
		{
			VehicleInfo[FindVehicleID(carid)][vWeapon][GetWeaponSlot(weaponid)] = weaponid;
			VehicleInfo[FindVehicleID(carid)][vAmmo][GetWeaponSlot(weaponid)] = ammoo;
		}
		format(iStr, sizeof(iStr), "throws something into the %s.", GetVehicleName(carid));
		Action(playerid, iStr);
		RemovePlayerWeapon(playerid, weaponslot);
		SaveVehicle(FindVehicleID(carid));
	}
	else if(houseid != -1)
	{
		if(HouseInfo[houseid][hWeapon][GetWeaponSlot(weaponid)] != 0 && weaponid == HouseInfo[houseid][hWeapon][GetWeaponSlot(weaponid)]) // slot is already taken, but it's the same gun... add bullets.
		{
			HouseInfo[houseid][hWeapon][GetWeaponSlot(weaponid)] = weaponid;
			HouseInfo[houseid][hAmmo][GetWeaponSlot(weaponid)] += ammoo;	
		}
		else
		{
			HouseInfo[houseid][hWeapon][GetWeaponSlot(weaponid)] = weaponid;
			HouseInfo[houseid][hAmmo][GetWeaponSlot(weaponid)] = ammoo;
		}
		Action(playerid, "throws something inside the house locker.");
		RemovePlayerWeapon(playerid, weaponslot);
		SaveHouse(houseid);
	}
	else return SendClientError(playerid, "You need to be inside a house or near a vehicle to use this.");
	return 1;
}
COMMAND:takegun(playerid, params[])
{
    new car = GetPlayerNearestVehicle(playerid);
	if(GetDistanceFromPlayerToVehicle(playerid, car) > 5.0) return SendClientError(playerid, "There is no vehicle around you!");
	new iSlot;
	if(sscanf(params, "d", iSlot)) return SCP(playerid, "[weaponSLOT] (/friskcar)");
	if(iSlot < 0 || iSlot > 12) return SendClientError(playerid, "Invalid Slot ID!");
	if(!VehicleInfo[FindVehicleID(car)][vWeapon][iSlot]) return SendClientError(playerid, "There is no weapon in that Slot ID!");
	GivePlayerWeaponEx(playerid, VehicleInfo[FindVehicleID(car)][vWeapon][iSlot], VehicleInfo[FindVehicleID(car)][vAmmo][iSlot]);
	VehicleInfo[FindVehicleID(car)][vWeapon][iSlot] = 0;
	VehicleInfo[FindVehicleID(car)][vAmmo][iSlot] = 0;
	SaveVehicle(FindVehicleID(car));
	format(iStr, sizeof(iStr), "takes something from the %s.", GetVehicleName(car));
	Action(playerid, iStr);
	return 1;
}
COMMAND:friskcar(playerid, params[])
{
	new car = GetPlayerNearestVehicle(playerid);
	if(GetDistanceFromPlayerToVehicle(playerid, car) > 5.0) return SendClientError(playerid, "There is no vehicle around you!");
	ShowDialog(playerid, DIALOG_NO_RESPONSE, 3);
	format(iStr, sizeof(iStr), "is frisking the %s.", GetVehicleName(car));
	Action(playerid, iStr);
	return 1;
}
ALTCOMMAND:carinfo->friskcar;
COMMAND:animlist(playerid)
{
	SendClientMessage(playerid, COLOR_HELPEROOC, "________________________________________________________________________________________________________________________");
	SendClientMessage(playerid,COLOR_WHITE,"/fall - /fallback - /injured - /akick - /push - /handsup - /bomb - /drunk - /getarrested - /laugh - /sup - /sleep - /holdgun");
	SendClientMessage(playerid,COLOR_WHITE,"/rescue - /spray - /taichi - /lookout - /kiss - /crossarms - /lay - /aim - /bat - /lightcig - /scratch - /fseat - /gsign");
	SendClientMessage(playerid,COLOR_WHITE,"/deal - /crack - /smoke - /sit - /chat - /dance - /fucku - /strip - /hide - /vomit - /eat - /seat - /reload - /facepalm");
	SendClientMessage(playerid,COLOR_WHITE,"/piss - /lean - /walkregular - /walkcop - /walkgangsta - /walkold - /walkfat - /walkgirl - /walkdrunk - /walkblind - /walkarmed");
	SendClientMessage(playerid, COLOR_HELPEROOC, "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯");
	return 1;
}

COMMAND:walkregular(playerid)
{
	LoopingAnim(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
	return 1;
}

COMMAND:walkcop(playerid)
{
	LoopingAnim(playerid,"PED","WALK_civi",4.1,1,1,1,1,1);
	return 1;
}

COMMAND:testanim(playerid, params[])
{
	new iLibary[12], iAnimation[24];
	if(sscanf(params, "ss", iLibary, iAnimation)) return SCP(playerid, "[Libary] [Animation]");
	LoopingAnim(playerid,iLibary,iAnimation,4.1,1,1,1,1,1);
	return 1;
}

COMMAND:walkfat(playerid)
{
	LoopingAnim(playerid,"PED","WALK_fat",4.1,1,1,1,1,1);
	return 1;
}

COMMAND:walkdrunk(playerid)
{
	LoopingAnim(playerid,"PED","WALK_drunk",4.1,1,1,1,1,1);
	return 1;
}

COMMAND:walkblind(playerid)
{
	LoopingAnim(playerid,"PED","Walk_Wuzi",4.1,1,1,1,1,1);
	return 1;
}

COMMAND:holdgun(playerid)
{

	LoopingAnim(playerid
	,"RIFLE","RIFLE_fire_poor",4.1,1,1,1,1,1);
	return 1;
}

COMMAND:walkarmed(playerid)
{
	LoopingAnim(playerid,"PED","WALK_armed",4.1,1,1,1,1,1);
	return 1;
}

COMMAND:walkgangsta(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-2]");
	switch(id)
	{
		case 1: LoopingAnim(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
		case 2: LoopingAnim(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
		default: SCP(playerid, "[1-2]");
	}
	return 1;
}

COMMAND:gsign(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-10]");
	switch(id)
	{
		case 1: LoopingAnim(playerid,"GHANDS","gsign1",4.1,1,1,1,1,1);
		case 2: LoopingAnim(playerid,"GHANDS","gsign1LH",4.1,1,1,1,1,1);
		case 3: LoopingAnim(playerid,"GHANDS","gsign2",4.1,1,1,1,1,1);
		case 4: LoopingAnim(playerid,"GHANDS","gsign2LH",4.1,1,1,1,1,1);
		case 5: LoopingAnim(playerid,"GHANDS","gsign3",4.1,1,1,1,1,1);
		case 6: LoopingAnim(playerid,"GHANDS","gsign3LH",4.1,1,1,1,1,1);
		case 7: LoopingAnim(playerid,"GHANDS","gsign4",4.1,1,1,1,1,1);
		case 8: LoopingAnim(playerid,"GHANDS","gsign4LH",4.1,1,1,1,1,1);
		case 9: LoopingAnim(playerid,"GHANDS","gsign5",4.1,1,1,1,1,1);
		case 10: LoopingAnim(playerid,"GHANDS","gsign5LH",4.1,1,1,1,1,1);
		default: SCP(playerid, "[1-10]");
	}
	return 1;
}

COMMAND:walkold(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-2]");
	switch(id)
	{
		case 1: LoopingAnim(playerid,"PED","WALK_old",4.1,1,1,1,1,1);
		case 2: LoopingAnim(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1);
		default: SCP(playerid, "[1-2]");
	}
	return 1;
}

COMMAND:walkgirl(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-4]");
	switch(id)
	{
		case 1: LoopingAnim(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1);
		case 2: LoopingAnim(playerid,"PED","WOMAN_walkbusy",4.1,1,1,1,1,1);
		case 3: LoopingAnim(playerid,"PED","WOMAN_walkpro",4.1,1,1,1,1,1);
		case 4: LoopingAnim(playerid,"PED","WOMAN_walksexy",4.1,1,1,1,1,1);
		default: SCP(playerid, "[1-4]");
	}
	return 1;
}

COMMAND:handsup(playerid)
{
	LoopingAnim(playerid, "ROB_BANK","SHP_HandsUp_Scr", 4.0, 0, 1, 1, 1, 0);
	return 1;
}

COMMAND:bomb(playerid)
{
	LoopingAnim(playerid, "BOMBER","BOM_Plant_Loop",4.0,1,0,0,1,0); // Place Bomb
	return 1;
}

COMMAND:getarrested(playerid)
{
	LoopingAnim(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1); // Gun Arrest
	return 1;
}

COMMAND:laugh(playerid)
{
	OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0); // Laugh
	return 1;
}

COMMAND:crossarms(playerid)
{
	LoopingAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1); // Arms crossed
	return 1;
}

COMMAND:lay(playerid)
{
	LoopingAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0); // Lay down
	return 1;
}

COMMAND:hide(playerid)
{
	LoopingAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0); // Taking Cover
	return 1;
}

COMMAND:lookout(playerid)
{
	OnePlayAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0); // Rob Lookout
	return 1;
}

COMMAND:vomit(playerid)
{
	OnePlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0); // Vomit BAH!
	return 1;
}

COMMAND:eat(playerid)
{
	OnePlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0); // Eat Burger
	return 1;
}

COMMAND:wave(playerid)
{
	LoopingAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0); // Wave
	return 1;
}

COMMAND:slapass(playerid)
{
	OnePlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0); // Ass Slapping
	return 1;
}

COMMAND:deal(playerid)
{
	OnePlayAnim(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0); // Deal Drugs
	return 1;
}

COMMAND:crack(playerid)
{
	LoopingAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0); // Dieing of Crack
	return 1;
}

COMMAND:smoke(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-4]");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
	switch(id)
	{
		case 1: LoopingAnim(playerid,"SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0); // male
		case 2: LoopingAnim(playerid,"SMOKING", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0); //female
		case 3: LoopingAnim(playerid,"SMOKING","M_smkstnd_loop", 4.0, 1, 0, 0, 0, 0); // standing-fucked
		case 4: LoopingAnim(playerid,"SMOKING","M_smk_out", 4.0, 1, 0, 0, 0, 0); // standing
		default: SCP(playerid, "[1-4]");
	}
	return 1;
}

COMMAND:sit(playerid)
{
	LoopingAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0); // Sit
	return 1;
}

COMMAND:facepalm(playerid)
{
	ApplyAnimation(playerid,"MISC","plyr_shkhead", 4.1, 0, 0, 0, 1, 1); // Seat
	return 1;
}

COMMAND:sleep(playerid)
{
	ApplyAnimation(playerid,"CRACK","crckidle2",4.1,0,1,1,1,1); // sleep
	return 1;
}

COMMAND:fseat(playerid)
{
	ApplyAnimation(playerid,"BEACH","ParkSit_W_loop",4.1,0,1,1,1,1); // fsit
	return 1;
}

COMMAND:scratch(playerid)
{
	ApplyAnimation(playerid,"MISC","Scratchballs_01",4.0,0,0,0,0,0);
	return 1;
}

COMMAND:seat(playerid)
{
	ApplyAnimation(playerid,"ped","SEAT_idle", 4.1, 1, 0, 0, 1, 1); // Seat
	return 1;
}

COMMAND:chat(playerid)
{
	LoopingAnim(playerid,"PED","IDLE_CHAT",4.0,1,0,0,1,1);
	return 1;
}

COMMAND:piss(playerid)
{
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}

COMMAND:taichi(playerid)
{
	LoopingAnim(playerid,"PARK","Tai_Chi_Loop",4.0,1,0,0,0,0);
	return 1;
}

COMMAND:fucku(playerid)
{
	OnePlayAnim(playerid,"PED","fucku",4.0,0,0,0,0,0);
	return 1;
}

COMMAND:fall(playerid)
{
	LoopingAnim(playerid,"PED","KO_skid_front",4.1,0,1,1,1,0);
	return 1;
}

COMMAND:fallback(playerid)
{
	LoopingAnim(playerid, "PED","FLOOR_hit_f", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

COMMAND:kiss(playerid)
{
	LoopingAnim(playerid, "KISSING", "Playa_Kiss_02", 3.0, 1, 1, 1, 1, 0);
	return 1;
}

COMMAND:injured(playerid)
{
	LoopingAnim(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}

COMMAND:sup(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-3]");
	switch(id)
	{
       	case 1: OnePlayAnim(playerid,"GANGS","hndshkba",4.0,0,0,0,0,0);
      	case 2: OnePlayAnim(playerid,"GANGS","hndshkda",4.0,0,0,0,0,0);
       	case 3: OnePlayAnim(playerid,"GANGS","hndshkfa_swt",4.0,0,0,0,0,0);
		default: SCP(playerid, "[1-3]");
	}
	return 1;
}

COMMAND:rap(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-4]");
	switch(id)
	{
   	    case 1: LoopingAnim(playerid,"RAPPING","RAP_A_Loop",4.0,1,0,0,0,0);
       	case 2: LoopingAnim(playerid,"RAPPING","RAP_C_Loop",4.0,1,0,0,0,0);
       	case 3: LoopingAnim(playerid,"GANGS","prtial_gngtlkD",4.0,1,0,0,0,0);
       	case 4: LoopingAnim(playerid,"GANGS","prtial_gngtlkH",4.0,1,0,0,1,1);
		default: SCP(playerid, "[1-4]");
	}
	return 1;
}

COMMAND:bat(playerid)
{
	LoopingAnim(playerid,"BASEBALL","Bat_IDLE",4.0,1,1,1,1,0);
	return 1;
}

COMMAND:push(playerid)
{
	OnePlayAnim(playerid,"GANGS","shake_cara",4.0,0,0,0,0,0);
	return 1;
}

COMMAND:akick(playerid)
{
	OnePlayAnim(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0);
	return 1;
}

COMMAND:spray(playerid)
{
	OnePlayAnim(playerid,"SPRAYCAN","spraycan_full",4.0,0,0,0,0,0);
	return 1;
}

COMMAND:rescue(playerid)
{
	OnePlayAnim(playerid,"MEDIC","CPR",4.0,0,0,0,0,0);
	return 1;
}

COMMAND:lightcig(playerid)
{
	OnePlayAnim(playerid,"SMOKING","M_smk_in",3.0,0,0,0,0,0);
	return 1;
}

COMMAND:clear(playerid)
{
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0);
	return 1;
}

COMMAND:gwalk(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-2]");
	switch(id)
	{
       	case 1: LoopingAnim(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
      	case 2: LoopingAnim(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
		default: SCP(playerid, "[1-2]");
	}
	return 1;
}

COMMAND:reload(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-2]");
	switch(id)
	{
       	case 1: OnePlayAnim(playerid,"COLT45","colt45_reload",4.0,0,0,0,0,1);
      	case 2: OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
		default: SCP(playerid, "[1-2]");
	}
	return 1;
}

COMMAND:aim(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-3]");
	switch(id)
	{
       	case 1: LoopingAnim(playerid,"PED","gang_gunstand",4.0,1,1,1,1,1);
       	case 2: LoopingAnim(playerid,"PED","Driveby_L",4.0,0,1,1,1,1);
       	case 3: LoopingAnim(playerid,"PED","Driveby_R",4.0,0,1,1,1,1);
		default: SCP(playerid, "[1-3]");
	}
	return 1;
}

COMMAND:lean(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-2]");
	switch(id)
	{
       	case 1: LoopingAnim(playerid,"GANGS","leanIDLE",4.0,0,1,1,1,0);
       	case 2: LoopingAnim(playerid,"MISC","Plyrlean_loop",4.0,0,1,1,1,0);
		default: SCP(playerid, "[1-2]");
	}
	return 1;
}

COMMAND:strip(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-7]");
	switch(id)
	{
       	case 1: LoopingAnim(playerid,"STRIP", "strip_A", 4.1, 1, 1, 1, 1, 1 );
       	case 2: LoopingAnim(playerid,"STRIP", "strip_B", 4.1, 1, 1, 1, 1, 1 );
       	case 3: LoopingAnim(playerid,"STRIP", "strip_C", 4.1, 1, 1, 1, 1, 1 );
       	case 4: LoopingAnim(playerid,"STRIP", "strip_D", 4.1, 1, 1, 1, 1, 1 );
       	case 5: LoopingAnim(playerid,"STRIP", "strip_E", 4.1, 1, 1, 1, 1, 1 );
       	case 6: LoopingAnim(playerid,"STRIP", "strip_F", 4.1, 1, 1, 1, 1, 1 );
       	case 7: LoopingAnim(playerid,"STRIP", "strip_G", 4.1, 1, 1, 1, 1, 1 );
		default: SCP(playerid, "[1-7]");
	}
	return 1;
}

COMMAND:dance(playerid, params[])
{
	new id;
	if(sscanf(params, "d", id)) return SCP(playerid, "[1-4]");
	switch(id)
	{
       	case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
       	case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
		case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
		case 4: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
		default: SCP(playerid, "[1-4]");
	}
	return 1;
}
IRCCMD:say(botid, channel[], user[], host[], params[])
{
	new
	    eText  [ 128 ],
		eString[ 256 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);
	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", eText)) return iEchoUse("!say [ message ]");
	if(strlen(eText) > 100) return iEchoUse("!say [ message ] (MSG TOO LONG)");

	format( eString, sizeof( eString ), "10(ToServer): %s: %s", user, eText);
	iEcho( eString );
	format( eString, sizeof( eString), " {FFFFFF}[Echo] {00FF7F}%s: %s", user, eText);
	SendClientMessageToAll(COLOR_ADMIN_SPYREPORT, eString);
	return 1;
}
IRCCMD:commands(botid, channel[], user[], host[], params[])
{
	new	iString[ 164 ];

	format(iString, sizeof(iString), "7,1 ECHO COMMANDS: ");
    iEcho(iString, channel);
    format(iString, sizeof(iString), "7,1 !say, !ban !unsuspend !banip !unbanip !ajail !unjail !ojail !getid !slap !cw");
    iEcho(iString, channel);
    format(iString, sizeof(iString), "7,1 !spawn  !mute !unmute !getip !why !laston !players !playerss !admins !helpers !forcept ");
    iEcho(iString, channel);
    format(iString, sizeof(iString), "7,1 !irc !ooc !suspend  !osuspend !kick !pm !settier !ainvite !ogivecash !changenick");
    iEcho(iString, channel);
    format(iString, sizeof(iString), "7,1 !killbot !cp !auninvite !admin !helper !event !(un)freeze !warn !ouninvite !getaccounts");
    iEcho(iString, channel);
    return 1;
}
IRCCMD:irc(botid, channel[], user[], host[], params[])
{
	new
	    eText  [ 128 ],
		string	[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);
	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", eText)) return iEchoUse("!irc [on/off]");

	if(strcmp(eText,"on",true)==0)
	{
		ircenable=1;
		SendClientMessageToAll(COLOR_GREENYELLOW,"{FFFFFF}[Echo] {00FF7F}IRC Chat enabled");
		format(string, sizeof(string), "3..: IRC enabled by %s :..", user);
		iEcho(string);
		return 1;
	}
	if(strcmp(eText,"off",true)==0)
	{
		ircenable=0;
		SendClientMessageToAll(COLOR_GREENYELLOW,"{FFFFFF}[IRC] {00FF7F}IRC Chat disabled");
		format(string, sizeof(string), "3..: IRC disabled by %s :..", user);
		iEcho(string);
		return 1;
	}
	return 1;
}
IRCCMD:ooc(botid, channel[], user[], host[], params[])
{
	new
	    eText  [ 128 ],
		string	[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);
	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", eText)) return iEchoUse("!ooc [on/off]");

	if(strcmp(eText,"on",true)==0)
	{
		oocenable=1;
		SendClientMessageToAll(COLOR_GREENYELLOW,"{FFFFFF}[Echo] {00FF7F}OOC Chat enabled");
		format(string, sizeof(string), "3..: OOC enabled by %s :..", user);
		iEcho(string);
		return 1;
	}
	if(strcmp(eText,"off",true)==0)
	{
		oocenable=0;
		SendClientMessageToAll(COLOR_GREENYELLOW,"{FFFFFF}[Echo] {00FF7F}OOC Chat disabled");
		format(string, sizeof(string), "3..: OOC disabled by %s :..", user);
		iEcho(string);
		return 1;
	}
	return 1;
}
IRCCMD:suspend(botid, channel[], user[], host[], params[])
{
	new
	    eReason [ 128 ],
		iPlayer;

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);
	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "us", iPlayer, eReason)) return iEchoUse("!suspend [ ID / name ] [ reason ]");
	if(!IsPlayerConnected(iPlayer)) return iEchoUse("!suspend [ ID / name ] [ reason ]");

	BanReas(user, iPlayer, eReason, 0);
	AdminDB(PlayerName(iPlayer), user, eReason, "[SUSPENDED]");
	return 1;
}
IRCCMD:osuspend(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer[ 40 ],
	    iReason[ 128 ],
		string[ 164 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "ss", iPlayer, iReason)) return iEchoUse("!osuspend [ name ] [ reason ]");
	if(AccountExist(iPlayer)) return iEcho("ERROR: Player not found.");
	else
	{
        new iQuery[128];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Banned` = 1 WHERE `PlayerName` = '%e'", iPlayer);
		mysql_tquery(MySQLPipeline, iQuery);
	}

	format(string, MAX_STRING, "4[ SUSPEND ] %s has been offline-banned by %s. Reason: %s", iPlayer, user, iReason);
	iEcho(string);

	format(string,sizeof(string),"{FFFFFF}[ {FF0000}Echo{FFFFFF} ] {FF6347}%s has offline-suspended %s. Reason: %s",user,iPlayer,iReason);
	SendClientMessageToAll(COLOR_RED,string);
	
	AdminDB(iPlayer, user, iReason, "[O-SUSPENDED]");
	return 1;
}
IRCCMD:kick(botid, channel[], user[], host[], params[])
{
	new
	    eReason [ 128 ],
		iPlayer;

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "us", iPlayer, eReason)) return iEchoUse("!kick [ ID / name ] [ reason ]");
	if(!IsPlayerConnected(iPlayer)) return iEchoUse("!kick [ ID / name ] [ reason ]");

	KickReas(user,iPlayer,eReason);

	AdminDB(PlayerName(iPlayer), user, eReason, "[KICK]");
	return 1;
}
IRCCMD:pm(botid, channel[], user[], host[], params[])
{
	new
	    eReason [ 128 ],
		iPlayer,
		string[ 256 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "us", iPlayer, eReason)) return iEchoUse("!pm [ ID / name ] [ message ]");
	if(!IsPlayerConnected(iPlayer)) return iEchoUse("!pm [ ID / name ] [ message ]");
	if(strlen(eReason) > 100) return iNotice( user, "** Message too long!");

	new iHead[128];
	format(iHead, sizeof(iHead), "[ {FF0000}Echo{FFFFFF} ] {FF6347}[PM] %s:", user);
	format(string, sizeof(string), "%s %s", iHead, eReason);
	SendPlayerMessage(iPlayer, 0xFFFFFFFF, string, iHead);
	format(string, sizeof(string), "15[ IRC PM ] %s to %s: %s", user, PlayerName(iPlayer), eReason);
	iEcho(string);
	return 1;
}
IRCCMD:settier(botid, channel[], user[], host[], params[])
{
	new
	    eReason,
		iPlayer;

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsAdmin (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "ui", iPlayer, eReason)) return iEchoUse("!settier [ ID / name ] [ tier ]");
	if(!IsPlayerConnected(iPlayer)) return iEchoUse("!ainvite [ ID / name ] [ tier ]");
	PlayerInfo[iPlayer][ranklvl] = eReason;
	format(iStr, sizeof(iStr), "10[TIER] %s has set the tier of %s to %d", user, PlayerName(iPlayer), eReason);
	iEcho(iStr);
	return 1;
}
IRCCMD:ainvite(botid, channel[], user[], host[], params[])
{
	new
	    eReason,
		iPlayer;

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsAdmin (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "ui", iPlayer, eReason)) return iEchoUse("!ainvite [ ID / name ] [ faction ]");
	if(!IsPlayerConnected(iPlayer)) return iEchoUse("!ainvite [ ID / name ] [ faction ]");
	Invite(iPlayer, eReason, user);
	return 1;
}

IRCCMD:auninvite(botid, channel[], user[], host[], params[])
{
	new
		iPlayer;

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsAdmin (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "u", iPlayer)) return iEchoUse("!ainvite [ ID / name ]");
	if(!IsPlayerConnected(iPlayer)) return iEchoUse("!ainvite [ ID / name ]");
	Uninvite(iPlayer, user);
	return 1;
}
IRCCMD:admin(botid, channel[], user[], host[], params[])
{
	new
	    iText[ 128 ],
	    string[ MAX_STRING ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", iText)) return iEchoUse("!admin [ message ]");

	format(string,sizeof(string),"{ [Echo] %s says: %s}",user,iText);
	for(new i=0;i<MAX_PLAYERS;i++) if(PlayerInfo[i][power]>0) SendClientMessage(i, COLOR_ADMINCHAT, string);
	format( string, sizeof(string), "7{ IRC Admin %s: %s }",user, iText);
	iEcho( string );
	return 1;
}
IRCCMD:helper(botid, channel[], user[], host[], params[])
{
	new
	    iText[ 128 ],
	    string[ MAX_STRING ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", iText)) return iEchoUse("!helper [ message ]");

	format(string,sizeof(string),"{ [Echo] %s says: %s}",user,iText);
	for(new i=0;i<MAX_PLAYERS;i++) if(PlayerInfo[i][power]>0 || PlayerInfo[i][helper]>0) SendClientMessage(i, COLOR_ADMINCHAT, string);
	format( string, sizeof(string), "7{ [HELPER] IRC Admin %s: %s }",user, iText);
	iEcho( string );
	return 1;
}
IRCCMD:ban(botid, channel[], user[], host[], params[])
{
	new
	    eReason [ 128 ],
		iPlayer;

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsOp (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "us", iPlayer, eReason)) return iEchoUse("!ban [ ID / name ] [ reason ]");
	if(!IsPlayerConnected(iPlayer)) return iEchoUse("!ban [ ID / name ] [ reason ]");

	BanReas(user, iPlayer, eReason, 1);
	AdminDB(PlayerName(iPlayer), user, eReason, "[IP-BAN]");
	return 1;
}
IRCCMD:unsuspend(botid, channel[], user[], host[], params[])
{
	new eReason [ 128 ], string[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsOp (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", eReason)) return iEchoUse("!unsuspend [ playername ]");

	if(!AccountExist(eReason)) return iEcho("ERROR: Player not found.");
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Banned` = 0, `TBanned` = 0 WHERE `PlayerName` = '%e'", eReason);
	mysql_tquery(MySQLPipeline, iQuery);

	format(string, MAX_STRING, "4[ UNSUSPEND ] %s has been unbanned by %s.", eReason, user);
	iEcho(string);
	format(string,sizeof(string),"%s has unsuspended %s", user, eReason);
	AppendTo(banlog,string);
	AdminDB(eReason, user, "NULL", "[UNSUSPENDED]");
	return 1;
}
IRCCMD:banip(botid, channel[], user[], host[], params[])
{
	new
	    eReason [ 64 ],
	    iReason[ 128 ],
		tmp[ 64 ],
		string[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsOp (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "ss", eReason, iReason)) return iEchoUse("!banip [ IP ] [ reason ]");

	format(tmp, sizeof(tmp), "banip %s", eReason);
	SendRconCommand(tmp);
	SendRconCommand("reloadbans");

	format(string, MAX_STRING, "4[ IPBAN ] IP address %s has been banned. Reason: %s", eReason, iReason);
	iEcho(string);
	return 1;
}
IRCCMD:unbanip(botid, channel[], user[], host[], params[])
{
	new
	    eReason [ 128 ],
		tmp[ 64 ],
		string[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsOp (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", eReason)) return iEchoUse("!unbanip [ IP ]");

	format(tmp, sizeof(tmp), "unbanip %s", eReason);
	SendRconCommand(tmp);
	SendRconCommand("reloadbans");

	format(string, MAX_STRING, "4[ IPBAN ] IP address %s has been unbanned.", eReason);
	iEcho(string);

	format(string,sizeof(string),"%s has unbanned IP %s", user,eReason);
	AppendTo(banlog,string);
	return 1;
}
IRCCMD:ajail(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer,
	    iTime,
	    iReason[ 128 ],
		string[ 164 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "uds", iPlayer, iTime, iReason)) return iEchoUse("!ajail [ Name / ID ] [ time (minutes) ] [ reason ]");
	if(strlen(iReason) > 100) return iNotice( user, "** Message too long!");
	if(!IsPlayerConnected(iPlayer))
		return iEcho("ERROR: Player not found!");

	Jail(iPlayer,iTime*60,777,iReason);

	format(string, MAX_STRING, "4[ AJAIL ] %s[%d] has been adminjailed by %s for %i minutes. Reason: %s", RPName(iPlayer), iPlayer, user, iTime, iReason);
	iEcho(string);

	format(string,sizeof(string),"{FFFFFF}[ {FF0000}Echo{FFFFFF} ] {FF6347}%s has jailed %s for %d minutes. Reason: %s",user,PlayerName(iPlayer),iTime,iReason);
	SendClientMessageToAll(COLOR_RED,string);

	AdminDB(PlayerName(iPlayer), user, iReason, "[AJAIL]");
	return 1;
}
IRCCMD:ojail(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer[ 40 ],
	    iTime,
	    iReason[ 128 ],
		string[ 164 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "sds", iPlayer, iTime, iReason)) return iEchoUse("!ojail [ Name ] [ time (minutes) ] [ reason ]");
	if(strlen(iReason) > 100) return iNotice( user, "** Message too long!");
	if(AccountExist(iPlayer)) return iEcho("ERROR: Player not found.");
	else
	{
        new iQuery[228];
        iTime = (iTime * 60);
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Jail` = 1, `JailTime` = %d, `bail` = 777, JailReason = '%e' WHERE `PlayerName` = '%e'", iTime, iReason, iPlayer);
		mysql_tquery(MySQLPipeline, iQuery);
	}

	format(string, MAX_STRING, "4[ AJAIL ] %s has been offline-jailed by %s for %i minutes. Reason: %s", iPlayer, user, iTime, iReason);
	iEcho(string);

	format(string,sizeof(string),"{FFFFFF}[ {FF0000}Echo{FFFFFF} ] {FF6347}%s has offline-jailed %s for %d minutes. Reason: %s",user,iPlayer,iTime,iReason);
	SendClientMessageToAll(COLOR_RED,string);

	AdminDB(iPlayer, user, iReason, "[OJAIL]");
	return 1;
}
IRCCMD:getid(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer[ 40 ],
	    tmp[ 64 ];

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", iPlayer)) return iEchoUse("!getid [ part of name ]");
	if(PlayerID(iPlayer) == -1 || PlayerID(iPlayer) == -2)
	    return iEcho("ERROR: None or more then one player found!");

    format(tmp, 64, "14* %s (ID: %d)", PlayerName(PlayerID(iPlayer)), PlayerID(iPlayer));
    iEcho(tmp, channel);
	return 1;
}
IRCCMD:slap(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer,
		message[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "u", iPlayer)) return iEchoUse("!slap [ Name / ID ]");
	if(!IsPlayerConnected(iPlayer))
	    return iEcho("ERROR: Player not found!");

	new Float: px, Float: py, Float: pz;
    GetPlayerPos(iPlayer,px,py,pz);
	SetPlayerPos(iPlayer,px,py,pz+5);

    format(message,sizeof(message),"{FFFFFF}[ {FF0000}Echo{FFFFFF} ] {FF6347}%s has been slapped by %s",RPName(iPlayer), user);
	SendClientMessageToAll(COLOR_RED,message);
	format(message,sizeof(message),"5[ Admin ] %s has been slapped by IRC Admin %s.", PlayerName(iPlayer), user);
	iEcho(message);
	AdminDB(PlayerName(iPlayer), user, "NULL", "[SLAPPED]");
	return 1;
}
IRCCMD:spawn(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer,
		message[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "u", iPlayer)) return iEchoUse("!spawn [ Name / ID ]");
	if(!IsPlayerConnected(iPlayer))
	    return iEcho("ERROR: Player not found!");

	SpawnPlayer(iPlayer);

    format(message,sizeof(message),"{FFFFFF}[ {FF0000}Echo{FFFFFF} ] {FF6347}%s has been respawned by %s",RPName(iPlayer), user);
	SendClientMessageToAll(COLOR_RED,message);
	format(message,sizeof(message),"5[ Admin ] %s has been respawn by IRC Admin %s.", PlayerName(iPlayer), user);
	iEcho(message);
	AdminDB(PlayerName(iPlayer), user, "NULL", "[RESPAWNED]");
	return 1;
}

IRCCMD:unjail(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer,
		string[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "u", iPlayer)) return iEchoUse("!spawn [ Name / ID ]");
	if(!IsPlayerConnected(iPlayer))
	    return iEcho("ERROR: Player not found!");

	new giveplayerid = iPlayer;
    UnJail(giveplayerid);
	format(string, MAX_STRING, "4[ UNJAIL ] %s[%d] has been unjailed by %s.", PlayerName(giveplayerid), giveplayerid, user);
	iEcho(string);
	return 1;
}
IRCCMD:mute(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer, iTime,
		message[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "ud", iPlayer, iTime)) return iEchoUse("!mute [ Name / ID ] [ time in minutes ]");
	if(!IsPlayerConnected(iPlayer))
	    return iEcho("ERROR: Player not found!");

    PlayerTemp[iPlayer][muted] = 1;
    PlayerTemp[iPlayer][mutedtick] = GetTickCount() + iTime*60*1000;

    format(message,sizeof(message),"{FFFFFF}[ {FF0000}Echo{FFFFFF} ] {FF6347}%s has been muted by %s",PlayerName(iPlayer), user);
	SendClientMessageToAll(COLOR_RED,message);
	format(message,sizeof(message),"5[ Admin ] %s has been muted by IRC Admin %s.", PlayerName(iPlayer), user);
	iEcho(message);
	return 1;
}
IRCCMD:unmute(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer,
		message[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "u", iPlayer)) return iEchoUse("!unmute [ Name / ID ]");
	if(!IsPlayerConnected(iPlayer))
	    return iEcho("ERROR: Player not found!");

    PlayerTemp[iPlayer][muted] = 0;

    format(message,sizeof(message),"{FFFFFF}[ {FF0000}Echo{FFFFFF} ] {FF6347}%s has been unmuted by %s",PlayerName(iPlayer), user);
	SendClientMessageToAll(COLOR_RED,message);
	format(message,sizeof(message),"5[ Admin ] %s has been unmuted by IRC Admin %s.", PlayerName(iPlayer), user);
	iEcho(message);
	return 1;
}
IRCCMD:getip(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer[ 40 ],
	    tmp[ 64 ];

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "s", iPlayer)) return iEchoUse("!getid [ part of name ]");
	if(PlayerID(iPlayer) == -1 || PlayerID(iPlayer) == -2)
	{
		if(AccountExist(iPlayer))
		    return iEcho("ERROR: Player not found.");

		new iQuery[128];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `IP` FROM `PlayerInfo` WHERE `PlayerName` = '%e'", iPlayer);
		mysql_tquery(MySQLPipeline, iQuery, "GetIPResponse", "s", iPlayer);
	}
	else
	{
	    new ip[40];
	    GetPlayerIp(PlayerID(iPlayer), ip, sizeof(ip));

	    format(tmp, 64, "7{ INFO } IP of %s (ID: %d): %s", PlayerName(PlayerID(iPlayer)), PlayerID(iPlayer), ip);
		iEcho(tmp);
	}
	return 1;
}
IRCCMD:players(botid, channel[], user[], host[], params[])
{
	new
		iString[ 94 ],
		q = 0;

	PlayerLoop(i) { if(!IsPlayerNPC(i)) q++; }
	format(iString, sizeof(iString), "7Players connected: %d ", q);
	iEchoEx(iString, channel);
	return 1;
}
IRCCMD:admins(botid, channel[], user[], host[], params[])
{
	new tmp[40], iString[ 164 ];

	format(iString, sizeof(iString), "7Admins connected: ");
    for(new c = 0; c < MAX_PLAYERS; c++)
	{
	    if(!IsPlayerConnected(c) || PlayerInfo[c][power] == 0 || PlayerInfo[c][power] == 31337) continue;
	    format(tmp,sizeof(tmp),"%s{%d}, ",PlayerName(c), c);
	    strcat(iString,tmp);
	}
	strdel(iString,strlen(iString)-2, strlen(iString));
	iEcho(iString, channel);
	return 1;
}
IRCCMD:playerss(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	PlayerLoop(i)
	{
	    if(IsPlayerNPC(i)) continue;
	    new sweapon, sammo, wCount = 0;
		for(new z=0; z<13; z++)
		{
			GetPlayerWeaponData(i, z, sweapon, sammo);
			if(sweapon != 0) wCount++;
		}
	    format(iStr, sizeof(iStr), "7%s[%d] [Level: %d] [Money: $%d] [Bank: $%d] [%d weapons]", RPName(i), i, PlayerInfo[i][playerlvl], HandMoney(i), PlayerInfo[i][bank], wCount);
	    iEcho(iStr, channel);
	}
	return 1;
}
IRCCMD:helpers(botid, channel[], user[], host[], params[])
{
	new
	    tmp[40],
		iString[ 164 ];

	format(iString, sizeof(iString), "7Helpers connected: ");
    for(new c = 0; c < MAX_PLAYERS; c++)
	{
	    if(!IsPlayerConnected(c) || PlayerInfo[c][helper] == 0 ) continue;
	    format(tmp,sizeof(tmp),"%s[%d], ",PlayerName(c), c);
	    strcat(iString,tmp);
	}
	strdel(iString,strlen(iString)-2, strlen(iString));
	iEcho(iString, channel);
	return 1;
}
IRCCMD:forcept(botid, channel[], user[], host[], params[])
{
	new
	    message[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsOp (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	APayDay(user);
	format(message, sizeof(message), "6[PAYTIME] %s has forced the paytime.", user);
	iEcho(message);
	return 1;
}
IRCCMD:r(botid, channel[], user[], host[], params[])
{
	new
	    iFreq,
	    iText[ 128 ],
	    iString[ 164 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsOp (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "ds", iFreq, iText)) return iEchoUse("!r [ frequency ] [ message ]");
	if(iFreq < 100000 || iFreq > 999999)
	    return iEcho("ERROR: Invalid frequency.");

	format(iString, sizeof(iString), "* [Radio] IRC %s: %s", user, iText);
	SendRadioMessage(iFreq, iString, COLOR_PLAYER_VLIGHTBLUE);
	return 1;
}
IRCCMD:changebotnick(botid, channel[], user[], host[], params[])
{
	new
	    iFreq,
	    iText[ 32 ],
	    iString[ 128 ];

	if(!IRC_IsAdmin (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "ds", iFreq, iText)) return iEchoUse("!changenick [ botid ] [ new name ]");

	IRC_ChangeNick(iFreq, iText);
	format(iString, sizeof(iString), "2[IRC] Nickname of Bot ID %d has been changed to %s", iFreq, iText);
	iEcho(iString);
	return 1;
}
IRCCMD:killbot(botid, channel[], user[], host[], params[])
{
	new iFreq;
	if(!IRC_IsAdmin (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "d", iFreq)) return iEchoUse("!killbot [id]");
	IRC_Quit(iBots[iFreq], "Killed");
	return 1;
}
IRCCMD:whitelist(botid, channel[], user[], host[], params[])
{
	if(!IRC_IsAdmin (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	new iW[12], iW2[24];
	if(sscanf(params, "sz", iW, iW2)) return iEchoUse("!whitelist [ add / remove / list ]");
	if(!strcmp(iW, "add", true, 3))
	{
		if(!strlen(iW2)) return iEchoUse("add [PlayerName]");
		new iQuery[250];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `Whitelist` (`PlayerName`) VALUES ('%e')", iW2);
		mysql_tquery(MySQLPipeline, iQuery);		
		return 1;
	}
	else if(!strcmp(iW, "remove", true, 6))
	{
		if(!IsNumeric(iW2) || !strlen(iW2)) return iEchoUse("remove [ID]");	
		new iQuery[250];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `Whitelist` WHERE `ID` = %d", iW2);
		mysql_tquery(MySQLPipeline, iQuery);	
		return 1;
	}
	else if(!strcmp(iW, "list", true, 4))
	{
		new iQuery[250];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `ID`,`PlayerName` FROM `Whitelist");
		mysql_tquery(MySQLPipeline, iQuery);
		return 1;
	}
	return 1;
}
IRCCMD:cp(botid, channel[], user[], host[], params[])
{
	new
	    iPlayer,
		string[ 128 ];

	if(!IsEchoChannel(channel)) return iNotice( user, IRC_WRONG_CHANNEL);

	if(!IRC_IsHalfop (botid, channel, user)) return iNotice( user, "** Sorry, but you cannot use this command!");
	if(sscanf(params, "u", iPlayer)) return iEchoUse("!cp [ Name / ID ]");
	if(!IsPlayerConnected(iPlayer))
	    return iEcho("ERROR: Player not found!");

	format(string, sizeof(string), "3..: Player Info %s (ID: %d) :..", PlayerName(iPlayer), iPlayer);
	IRC_GroupSay(gBotID[random(3)], channel, string);
	format(string, sizeof(string), "Name[%s] IP[%s] ServerMoney[%d] ClientMoney[%d] Bank[%d]", PlayerName(iPlayer), PlayerTemp[iPlayer][IP], PlayerTemp[iPlayer][sm], GetPlayerMoney(iPlayer), PlayerInfo[iPlayer][bank]);
	IRC_GroupSay(gBotID[random(3)], channel, string);
	format(string, sizeof(string),"Jailed / Time / Reason[%d / %d / %s]", PlayerInfo[iPlayer][jail],PlayerInfo[iPlayer][jailtime],PlayerInfo[iPlayer][jailreason]);
	IRC_GroupSay(gBotID[random(3)], channel, string);
	return 1;
}
COMMAND:whlock(playerid, params[])
{
	if(PlayerInfo[playerid][playerteam] == CIV) return SendClientError(playerid, CANT_USE_CMD);
	if(PlayerInfo[playerid][ranklvl] != 0) return SendClientError(playerid, CANT_USE_CMD);
	new whID = IsPlayerOutWarehouse(playerid);
	if(whID != -1)
	{
		new iPara[20];
		if(WareHouseInfo[whID][whOpen] == true)
		{
			WareHouseInfo[whID][whOpen] = false;
			myStrcpy(iPara, "closed");
		}
		else
		{
			WareHouseInfo[whID][whOpen] = true;
			myStrcpy(iPara, "opened");
		}
		format(iStr, sizeof(iStr), "# [%s] %s %s has %s the faction warehouse.", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid), iPara);
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam],iStr,COLOR_PLAYER_VLIGHTBLUE);
		ReloadFaction(whID, true);
	}
	else return SendClientError(playerid, "You need to be outside a warehouse to use this.");
	return 1;
}
COMMAND:storematerials(playerid, params[])
{
	new whID = IsPlayerOutWarehouse(playerid);
	if(whID != -1)
	{
		if(WareHouseInfo[whID][whOpen] != true) return SendClientError(playerid, "This warehouse is currently locked.");
		new iAmount;
		if(sscanf(params, "d", iAmount)) return SCP(playerid, "[Amount]");
		if(iAmount > PlayerInfo[playerid][sMaterials] || iAmount < 0 || iAmount >= 2100000000) return SCP(playerid, "[Amount]");
		WareHouseInfo[whID][whMaterials] += iAmount;
		PlayerInfo[playerid][sMaterials] -= iAmount;
		ReloadFaction(whID, true);
		format(iStr, sizeof(iStr), "# [%s] Someone has deposited %s materials in to your warehouse.", FactionInfo[whID][fName], number_format(iAmount));
		SendClientMessageToTeam(whID,iStr,COLOR_PLAYER_VLIGHTBLUE);
	}
	else return SendClientError(playerid, "You need to be outside a warehouse to use this.");
	return 1;
}
COMMAND:takematerials(playerid, params[])
{
	new whID = IsPlayerOutWarehouse(playerid);
	if(whID != -1)
	{
		if(WareHouseInfo[whID][whOpen] != true) return SendClientError(playerid, "This warehouse is currently locked.");
		new iAmount;
		if(sscanf(params, "d", iAmount)) return SCP(playerid, "[Amount]");
		if(iAmount > WareHouseInfo[whID][whMaterials] || iAmount < 0 || iAmount >= 2100000000) return SCP(playerid, "[Amount]");
		WareHouseInfo[whID][whMaterials] -= iAmount;
		PlayerInfo[playerid][sMaterials] += iAmount;
		ReloadFaction(whID, true);
		format(iStr, sizeof(iStr), "# [%s] Someone has taken %s materials from your warehouse.", FactionInfo[whID][fName], number_format(iAmount));
		SendClientMessageToTeam(whID,iStr,COLOR_PLAYER_VLIGHTBLUE);
	}
	else return SendClientError(playerid, "You need to be outside a warehouse to use this.");
	return 1;
}
COMMAND:boombox(playerid, params[])
{
	if(!PlayerInfo[playerid][pBoomBox]) return SendClientError(playerid, "You don't own a boombox, buy one from a 24/7.");
	if(BoomBoxInfo[playerid][boomActive] != true)
	{
		if(PlayerInfo[playerid][pBoomBoxBan] == 1) return SendClientError(playerid, "There is currently a boombox ban on this character.");
		if(IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You need to be on foot to place a boombox.");
		if(strlen(params) > 256) return SCP(playerid, "[ URL ]");
		new iLink[256];
		if(sscanf(params, "s", iLink)) return SCP(playerid, "[ URL ]");
		PlayerLoop(p)
		{
			if(BoomBoxInfo[p][boomActive] != true) continue;
			if(GetPlayerInterior(playerid) != BoomBoxInfo[p][boomInterior] || GetPlayerVirtualWorld(playerid) != BoomBoxInfo[p][boomVirtualWorld]) continue;
			if(IsPlayerInRangeOfPoint(playerid, 15.0, BoomBoxInfo[p][boomX], BoomBoxInfo[p][boomY], BoomBoxInfo[p][boomZ]))
				return SendClientError(playerid, "You cannot place a boombox in the same area as another active boombox.");
		}
		new Float:pX, Float:pY, Float:pZ, Float:pA;
		GetPlayerPos(playerid, pX, pY, pZ);
		GetPlayerFacingAngle(playerid, pA);
		myStrcpy(BoomBoxInfo[playerid][boomURL], iLink);
		BoomBoxInfo[playerid][boomX] = pX;
		BoomBoxInfo[playerid][boomY] = pY;
		BoomBoxInfo[playerid][boomZ] = pZ;
		BoomBoxInfo[playerid][boomA] = pA;
		BoomBoxInfo[playerid][boomInterior] = GetPlayerInterior(playerid);
		BoomBoxInfo[playerid][boomVirtualWorld] = GetPlayerVirtualWorld(playerid);
		BoomBoxInfo[playerid][boomActive] = true;
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s's boombox.", MaskedName(playerid));
		BoomBoxInfo[playerid][boomObject] = CreateDynamicObject(2226, pX, pY, pZ-1.0, 0.0, 0.0, pA+180, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		BoomBoxInfo[playerid][boomArea] = CreateDynamicSphere(pX, pY, pZ-1.0, 15.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		BoomBoxInfo[playerid][boomLabel] = CreateDynamic3DTextLabel(iFormat, COLOR_LIGHTGREY, pX, pY, pZ-0.7, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 100.0);
	}
	else
	{
		myStrcpy(BoomBoxInfo[playerid][boomURL], "None");
		BoomBoxInfo[playerid][boomX] = 0.0;
		BoomBoxInfo[playerid][boomY] = 0.0;
		BoomBoxInfo[playerid][boomZ] = 0.0;
		BoomBoxInfo[playerid][boomA] = 0.0;
		BoomBoxInfo[playerid][boomInterior] = 0;
		BoomBoxInfo[playerid][boomVirtualWorld] = 0;
		BoomBoxInfo[playerid][boomActive] = false;
		PlayerLoop(p)
		{
			if(IsPlayerInDynamicArea(p, BoomBoxInfo[playerid][boomArea]))
			{
				StopAudioStreamForPlayer(p);
				SendClientMessage(p, 0x5C8A8AFF, "[Boombox] The boombox within your current area has been picked up.");
			}
		}
		DestroyDynamicArea(BoomBoxInfo[playerid][boomArea]);
		DestroyDynamic3DTextLabel(BoomBoxInfo[playerid][boomLabel]);
		DestroyDynamicObject(BoomBoxInfo[playerid][boomObject]);
	}
	return 1;
}
COMMAND:setboombox(playerid, params[])
{
	if(!PlayerInfo[playerid][pBoomBox]) return SendClientError(playerid, "You don't own a boombox, buy one from a 24/7.");
	if(PlayerInfo[playerid][pBoomBoxBan] == 1) return SendClientError(playerid, "There is currently a boombox ban on this character.");
	if(BoomBoxInfo[playerid][boomActive] != true) return SendClientError(playerid, "Your boombox hasn't been placed yet.");
	if(strlen(params) > 256) return SCP(playerid, "[ URL ]");
	new iLink[256];
	if(sscanf(params, "s", iLink)) return SCP(playerid, "[ URL ]");
	myStrcpy(BoomBoxInfo[playerid][boomURL], iLink);
	PlayerLoop(p)
	{
		if(IsPlayerInDynamicArea(p, BoomBoxInfo[playerid][boomArea]))
		{
			PlayAudioStreamForPlayer(playerid, BoomBoxInfo[playerid][boomURL], BoomBoxInfo[playerid][boomX],  BoomBoxInfo[playerid][boomY],  BoomBoxInfo[playerid][boomZ], 30.0, 1);
		}
	}
	return 1;
}
COMMAND:setgarage(playerid, params[])
{
	if(PlayerInfo[playerid][power] < 5) return SendClientError(playerid, CANT_USE_CMD);
	new iHouse;
	if(sscanf(params, "d", iHouse)) return SCP(playerid, "[ HouseID ]");
	if(iHouse < 0 || iHouse > MAX_HOUSES) return SCP(playerid, "[ HouseID ]");
	if(HouseInfo[iHouse][hActive] != true) return SendClientError(playerid, "Invalid house ID! (Non existent)");
	new Float:pX, Float:pY, Float:pZ, Float:pA;
	GetPlayerPos(playerid, pX, pY, pZ);
	GetPlayerFacingAngle(playerid, pA);
	HouseInfo[iHouse][hGarageX] = pX;
	HouseInfo[iHouse][hGarageY] = pY; 
	HouseInfo[iHouse][hGarageZ] = pZ; 
	HouseInfo[iHouse][hGarageA] = pA;
	HouseInfo[iHouse][hGarageInt] = GetPlayerInterior(playerid);
	HouseInfo[iHouse][hGarageVW] = GetPlayerVirtualWorld(playerid);
	SaveHouse(iHouse);
	UpdateHouse(iHouse);
	SendClientInfo(playerid, "Garage moved successfully.");
	return 1;
}
COMMAND:door(playerid, params[])
{
	if(PlayerTemp[playerid][tmphouse] != -1)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		FurnitureLoop(f)
		{
			if(FurnitureInfo[houseid][f][furActive] != true) continue;
			new iID;
			for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
			{
				if(FurnitureObjects[furSearch][furID] == FurnitureInfo[houseid][f][furModel])
				{
					iID = furSearch;
					break;
				}
			}
			if(FurnitureObjects[iID][furCategory] == CATEGORY_MISCELLANEOUS && FurnitureObjects[iID][furSubCategory] == SUB_MISC_DOORS)
			{
				new Float:oX, Float:oY, Float:oZ;
				GetDynamicObjectPos(FurnitureInfo[houseid][f][furObject], oX, oY, oZ);
				if(IsPlayerInRangeOfPoint(playerid, 2.00, oX, oY, oZ))
				{
					if(FurnitureInfo[houseid][f][furStatus] == false)
					{
						SetDynamicObjectRot(FurnitureInfo[houseid][f][furObject], FurnitureInfo[houseid][f][furrX], FurnitureInfo[houseid][f][furrY], FurnitureInfo[houseid][f][furrZ]+90);
						FurnitureInfo[houseid][f][furStatus] = true;
					}
					else
					{
						SetDynamicObjectRot(FurnitureInfo[houseid][f][furObject], FurnitureInfo[houseid][f][furrX], FurnitureInfo[houseid][f][furrY], FurnitureInfo[houseid][f][furrZ]);
						FurnitureInfo[houseid][f][furStatus] = false;
					}
				}
			}
		}
	}
	else return SendClientError(playerid, "You need to be inside a house to use this command.");
	return 1;
}
COMMAND:allowcbug(playerid, params[])
{
	if(PlayerInfo[playerid][power] != 20)
		return SendClientMessage(playerid, COLOR_WHITE, "SERVER: Command not found! Use /commands.");
	new iPlayer;
	if(sscanf(params, "u", iPlayer)) return SCP(playerid, "[ PlayerID / PartOfName ]");
	if(IsPlayerConnected(iPlayer) == 0) return SendClientError(playerid, PLAYER_NOT_FOUND);
	if(PlayerInfo[iPlayer][allowCBug] == 1) PlayerInfo[iPlayer][allowCBug] = 0;
	else PlayerInfo[iPlayer][allowCBug] = 1;
	new iFormat[128];
	format(iFormat, sizeof(iFormat), "%s has allowed %s to C-BUG.", RPName(playerid), RPName(iPlayer));
	AdminNotice(iFormat);
	return 1;
}
COMMAND:chatanim(playerid, params[])
{
	if(PlayerTemp[playerid][chatAnim] == true)
	{
		PlayerTemp[playerid][chatAnim] = false;
		SendClientInfo(playerid, "You will nolonger be forced in to an animation when talking IC'ly.");
	}
	else
	{
		PlayerTemp[playerid][chatAnim] = true;
		SendClientInfo(playerid, "You will now be forced in to an animation when talking IC'ly.");
	}
	return 1;
}
COMMAND:whatsnew(playerid, params[])
{
	ShowDialog(playerid, DIALOG_WHATS_NEW);
	return 1;
}
/*COMMAND:give(playerid, parmas[])
{
	new iPlayer, iGiveWat[15], iQty[11];
	if(sscanf(params, "uzz", iPlayer, iGiveWat, iQty)) return SCP(playerid, "[PlayerID / PartOfName] [materials / cannabis / ecstasy / cocaine] [Amount]");
	return 1;
}*/
COMMAND:tracegarage(playerid, params[])
{
	new iHouse;
	if(sscanf(params, "d", iHouse)) return SCP(playerid, "[ Garage # ]");
	if(iHouse < 0 || iHouse > MAX_HOUSES) return SendClientError(playerid, "Invalid garage number.");
	if(HouseInfo[iHouse][hActive] != true || HouseInfo[iHouse][hGarageX] == 0.0) return SendClientError(playerid, "Invalid garage number : Non existent.");
	new Float:garageX, Float:garageY, Float:garageZ;
	garageX = HouseInfo[iHouse][hGarageX];
	garageY = HouseInfo[iHouse][hGarageY];
	garageZ = HouseInfo[iHouse][hGarageZ];
	SetPlayerCheckpoint(playerid, garageX, garageY, garageZ, 3.0);
	return 1;
}
COMMAND:convo(playerid, params[])
{
	if(PlayerInfo[playerid][power] != 20) return SendClientError(playerid, CANT_USE_CMD); // beta
	new iWat[12], iPlayer[MAX_PLAYER_NAME];
	if(sscanf(params, "sz", iWat, iPlayer)) return SCP(playerid, "[ create / add / remove / leave / mute ]");
	if(!strcmp(iWat, "create"))
	{
		if(GetPVarInt(playerid, "Convo") != INVALID_CONVERSATION) return SendClientError(playerid, "You are already in a convo. Use \"/convo leave\".");
		new randConvoID = minrand(INVALID_CONVERSATION+1, 1000000); // 1m!!! dang
		SetPVarInt(playerid, "Convo", randConvoID);
		SetPVarInt(playerid, "ConvoLeader", 1);
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "[Convo: %d] %s(%d) has created a new conversation.", GetPVarInt(playerid, "Convo"), RPName(playerid), playerid);
		SendClientMessage(playerid, 0xFFFF99FF, iFormat);
		return 1;
	}
	else if(!strcmp(iWat, "add"))
	{
		if(GetPVarInt(playerid, "Convo") == INVALID_CONVERSATION) return SendClientError(playerid, "You need to be in a convo in order to use this.");
		if(GetPVarInt(playerid, "ConvoMute") != 0)
		{
			ShowInfoBox(playerid, "Muted Convo", "You will nolonger speak within the conversation, although you will still see what people say.");
			SetPVarInt(playerid, "ConvoMute", 1);
		}
		else
		{
			ShowInfoBox(playerid, "Un-Muted Convo", "You can now speak within the conversation system again.");
			DeletePVar(playerid, "ConvoMute");
		}
		return 1;
	}
	else if(!strcmp(iWat, "add"))
	{
		if(GetPVarInt(playerid, "Convo") == INVALID_CONVERSATION) return SendClientError(playerid, "You need to be in a convo in order to use this.");
		if(GetPVarInt(playerid, "ConvoLeader") != 1) return SendClientError(playerid, "You are not the convo leader!");
		if(!strlen(iPlayer) || strlen(iPlayer) > sizeof(iPlayer)) return SCP(playerid, "add [ PlayerID / PartOfName ]");
		new targetID = -1;
		if(IsNumeric(iPlayer)) targetID = strval(iPlayer);
		else targetID = GetPlayerId(iPlayer);
		if(IsPlayerConnected(targetID)) return SendClientError(playerid, PLAYER_NOT_FOUND);
		if(GetPVarInt(targetID, "Convo") != INVALID_CONVERSATION) return SendClientError(playerid, "Player is already in a conversation!");
		//if(PlayerTemp[targetID][togConvo] != false) return SendClientError(playerid, "Selected player has disabled the convo system.");
		SetPVarInt(targetID, "InvitedToConvo", GetPVarInt(playerid, "Convo"));
		ShowInfoBox(targetID, "Invited to Convo", "You have been invited to a convo by %s! Use ~r~/accept convo~w~ to join.");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "[Convo: %d] %s has invited %s to the convo.", GetPVarInt(playerid, "Convo"), RPName(playerid), RPName(targetID));
		LOOP:p(0, MAX_PLAYERS)
		{
			if(!IsPlayerConnected(p)) continue;
			if(PlayerTemp[p][loggedIn] != true) continue;
			if(GetPVarInt(p, "Convo") == INVALID_CONVERSATION) continue;
			if(GetPVarInt(playerid, "Convo") != GetPVarInt(p, "Convo")) continue;
			SendClientMessage(p, 0xFFFF99FF, iFormat);
		}
		return 1;
	}
	else if(!strcmp(iWat, "remove"))
	{
		if(GetPVarInt(playerid, "Convo") == INVALID_CONVERSATION) return SendClientError(playerid, "You need to be inside a conversation to use this!");
		if(GetPVarInt(playerid, "ConvoLeader") != 1) return SendClientError(playerid, "You need to be the conversation leader to use this.");
		if(!strlen(iPlayer) || strlen(iPlayer) > sizeof(iPlayer)) return SCP(playerid, "add [ PlayerID / PartOfName ]");
		new targetID = -1;
		if(IsNumeric(iPlayer)) targetID = strval(iPlayer);
		else targetID = GetPlayerId(iPlayer);
		if(IsPlayerConnected(targetID)) return SendClientError(playerid, PLAYER_NOT_FOUND);
		if(GetPVarInt(playerid, "Convo") != GetPVarInt(targetID, "Convo")) return SendClientError(playerid, "Player is not in the same conversation as your.");
		if(GetPVarInt(playerid, "ConvoLeader") == 1 && targetID != playerid) return SendClientError(playerid, "Conversation leaders cannot be kicked. They need to \"/convo leave\".");
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "[Convo: %d] %s(%d) has left this conversation.", GetPVarInt(playerid, "Convo"), RPName(playerid), playerid);
		LOOP:p(0, MAX_PLAYERS)
		{
			if(!IsPlayerConnected(p)) continue;
			if(PlayerTemp[p][loggedIn] != true) continue;
			if(GetPVarInt(p, "Convo") == INVALID_CONVERSATION) continue;
			if(GetPVarInt(playerid, "Convo") != GetPVarInt(p, "Convo")) continue;
			SendClientMessage(p, 0xFFFF99FF, iFormat);
		}
		DeletePVar(playerid, "Convo");
		DeletePVar(playerid, "ConvoLeader");
		return 1;
	}
	else if(!strcmp(iWat, "leave"))
	{
		if(GetPVarInt(playerid, "Convo") == INVALID_CONVERSATION) return SendClientError(playerid, "You need to be in a convo in order to use this.");
		if(GetPVarInt(playerid, "ConvoLeader") == 1)
		{
			new iFormat[128];
			format(iFormat, sizeof(iFormat), "[Convo: %d] %s(%d) has destroyed this conversation.", GetPVarInt(playerid, "Convo"), RPName(playerid), playerid);
			LOOP:p(0, MAX_PLAYERS)
			{
				if(!IsPlayerConnected(p)) continue;
				if(PlayerTemp[p][loggedIn] != true) continue;
				if(GetPVarInt(p, "Convo") == INVALID_CONVERSATION) continue;
				if(GetPVarInt(playerid, "Convo") != GetPVarInt(p, "Convo")) continue;
				SendClientMessage(p, 0xFFFF99FF, iFormat);
				DeletePVar(p, "Convo");
				DeletePVar(p, "ConvoLeader");
			}
		}
		else
		{
			new iFormat[128];
			format(iFormat, sizeof(iFormat), "[Convo: %d] %s(%d) has left the conversation.", GetPVarInt(playerid, "Convo"), RPName(playerid), playerid);
			LOOP:p(0, MAX_PLAYERS)
			{
				if(!IsPlayerConnected(p)) continue;
				if(PlayerTemp[p][loggedIn] != true) continue;
				if(GetPVarInt(p, "Convo") == INVALID_CONVERSATION) continue;
				if(GetPVarInt(playerid, "Convo") != GetPVarInt(p, "Convo")) continue;
				SendClientMessage(p, 0xFFFF99FF, iFormat);
			}
			DeletePVar(playerid, "Convo");
			DeletePVar(playerid, "ConvoLeader");
		}
		return 1;	
	}
	else return SCP(playerid, "[ create / add / remove / leave / mute ]");
}
COMMAND:roulette(playerid, params[])
{
	new tmpid = IsPlayerInBiz(playerid, 15.0);
	if(tmpid == -1 || BusinessInfo[tmpid][bType] != BUSINESS_TYPE_CASINO) return SendClientError(playerid, "You need to be inside a casino to use this.");
	if(PlayerInfo[playerid][playerlvl] <= 3) return SendClientError(playerid, CANT_USE_CMD);
	Action(playerid, "has span the roulette wheel...");
	SetTimerEx("RouletteTimer", 5000, false, "d", playerid);
	return 1;
}
COMMAND:mduty(playerid, params[])
{
	if(!strcmp(PlayerInfo[playerid][job], "mechanic"))
	{
		if(IsPlayerInAnyVehicle(playerid) != 1) return SendClientError(playerid, "You need to be in a vehicle to use this.");
		new carid = GetPlayerVehicleID(playerid);
		new vehicleid = FindVehicleID(carid);
		if(VehicleInfo[vehicleid][vReserved] != VEH_RES_OCCUPA) return SendClientError(playerid, "You need to be in a job reserved vehicle.");
		if(strcmp(VehicleInfo[vehicleid][vJob], "mechanic")) return SendClientError(playerid, "You need to be in a vehicle owned by the mechanic depot to use this.");
		if(PlayerTemp[playerid][jobDuty] == true)
		{
			new iFormat[136];
			format(iFormat, sizeof(iFormat), "*** You are now off mechanic duty. ***");
			SendClientMessage(playerid, 0x8ea9b8FF, iFormat);
			PlayerTemp[playerid][jobDuty] = false;
		}
		else
		{
			PlayerTemp[playerid][jobDuty] = true;
			new iFormat[136];
			format(iFormat, sizeof(iFormat), "*** Mechanic {b5cdda}%s{8ea9b8} is now on duty. Use /service mechanic if you need vehicle help! ***", RPName(playerid));
			SendClientMessageToAll(0x8ea9b8FF, iFormat);
		}
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:carrefuel(playerid, params[])
{
	if(!strcmp(PlayerInfo[playerid][job], "mechanic"))
	{
		new iTarget, iPrice;
		if(sscanf(params, "ud", iTarget, iPrice)) return SCP(playerid, "[ PlayerID/PartOfName ] [ Price ]");
		if(IsPlayerConnected(iTarget))
		{
			if(iPrice > MAX_REFUEL_PRICE || iPrice < 1500) return SendClientError(playerid, "Invalid price.");
			if(IsPlayerInAnyVehicle(iTarget) != 1) return SendClientError(playerid, "The Selected player needs to be in a vehicle.");
			if(GetDistanceBetweenPlayers(playerid, iTarget) > 5.0) return SendClientError(playerid, "The Selected player is too far away from you.");
			new carid = GetPlayerVehicleID(iTarget);
			new vehicleid = FindVehicleID(carid);
			if(VehicleInfo[vehicleid][vFuel] > 90) return SendClientError(playerid, "The selected player doesn't need a refuel right now.");
			if(PlayerTemp[iTarget][sm] < iPrice) return SendClientError(playerid, "The Selected player cannot afford to pay.");
			SetPVarInt(iTarget, "RefuelID", playerid+1); // escape ID 0 from delete :)
			SetPVarInt(iTarget, "RefuelPrice", iPrice);
			new iFormat[136];
			format(iFormat, sizeof(iFormat), "has offered %s a vehicle refuel for a price of $%s.", MaskedName(iTarget), number_format(iPrice));
			Action(playerid, iFormat);
			format(iFormat, sizeof(iFormat), "%s has offered you a refuel for $%s. Use ~r~/accept refuel~w~ to accept.", MaskedName(playerid), number_format(iPrice));
			ShowInfoBox(iTarget, "Mechanic", iFormat);
		}
		else return SendClientError(playerid, PLAYER_NOT_FOUND);
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:inventory(playerid, params[])
{
	ShowDialog(playerid, DIALOG_INVENTORY);
	return 1;
}
/*COMMAND:note(playerid, params[])
{
	new iParams[15], iMessage[128], iTarget;
	if(sscanf(params, "ssu", iParams, iMessage, iTarget)) return SCP(playerid, "[ write / list / delete / give ]");
	if(!strcmp(iParams, "write"))
	{

	}
	else if(!strcmp(iParams, "list"))
	{
		
	}
	else if(!strcmp(iParams, "delete"))
	{
		
	}
	else if(!strcmp(iParams, "give"))
	{
		
	}
	else return SCP(playerid, "[ write / list / delete / give ]");
	return 1;
}*/
COMMAND:tazer(playerid, params[])
{
	if(PlayerInfo[playerid][playerteam] != CIV && IsPlayerFED(playerid))
	{
		if(GetPVarInt(playerid, "Tazer") != 0) // has out
		{
			new iFormat[228];
			if(PlayerInfo[playerid][pGender] == SKIN_FEMALE) format(iFormat, sizeof(iFormat), "has put her tazer away.");
			else format(iFormat, sizeof(iFormat), "has put his tazer away.");
			Action(playerid, iFormat);
			DeletePVar(playerid, "Tazer");
			GivePlayerWeaponEx(playerid, WEAPON_DEAGLE, 64);
		}
		else // take out
		{
			new iFormat[228];
			if(PlayerInfo[playerid][pGender] == SKIN_FEMALE) format(iFormat, sizeof(iFormat), "has taken out her tazer.");
			else format(iFormat, sizeof(iFormat), "has taken out his tazer.");
			Action(playerid, iFormat);
			SetPVarInt(playerid, "Tazer", 1);
			GivePlayerWeaponEx(playerid, WEAPON_SILENCED, 64);
		}
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
ALTCOMMAND:tz->tazer;
COMMAND:getvehid(playerid, params[])
{
	if(PlayerInfo[playerid][power] >= 2)
	{
		new iCarID;
		if(sscanf(params, "i", iCarID)) return SCP(playerid, "[CarID (/dl)]");
		if(iCarID < 1 || iCarID >= 2000) return SendClientError(playerid, "Invalid car ID. Please use a valid ID between 1 and 1,999!");
		new iFormat[128], vehicleid = FindVehicleID(iCarID);
		if(vehicleid != INVALID_VEHICLE_ID) format(iFormat, sizeof(iFormat), "[GetVehIC]: Car ID: %d has been found as: %d", iCarID, vehicleid);
		else format(iFormat, sizeof(iFormat), "[GetVehIC]: Car ID: %d has been found as INVALID.", iCarID);
		SendClientMessage(playerid, COLOR_ME2, iFormat);
	}
	else return SendClientError(playerid, CANT_USE_CMD);
	return 1;
}
COMMAND:weplic(playerid, params[])
{
	if(IsPlayerFED(playerid) && PlayerInfo[playerid][ranklvl] <= 1 && PlayerInfo[playerid][ranklvl] != -1 && PlayerInfo[playerid][playerteam] != CIV) // just to make sure :3
	{
		new iPlayer;
		if(sscanf(params, "u", iPlayer)) return SCP(playerid, "[PlayerID/PartOfName]");
		if(!IsPlayerConnected(iPlayer)) return SendClientError(playerid, PLAYER_NOT_FOUND);
		if(PlayerInfo[iPlayer][weaplic] != 0) return SendClientError(playerid, "This player already has a valid weapon license.");
		new iFormat[228];
		format(iFormat, sizeof(iFormat), "has handed %s a valid weapon license.", MaskedName(iPlayer));
		Action(playerid, iFormat);
		PlayerInfo[playerid][weaplic] = 1;
		format(iFormat, sizeof(iFormat), "# [%s] %s has given %s a weapon license!", GetPlayerFactionName(playerid), RPName(playerid), MaskedName(iPlayer));
		SendClientMessageToTeam(PlayerInfo[playerid][playerteam], iFormat, COLOR_PLAYER_VLIGHTBLUE);
		return 1;
	}
	else return SendClientError(playerid, CANT_USE_CMD);
}
COMMAND:prop(playerid, params[])
{
	new tmp[ 8 ];
	if(sscanf(params, "s", tmp)) return SCP(playerid, "[buy/sell/help]");
	if(!strcmp(tmp, "buy", true, 3))
	{
	    if(PlayerInfo[playerid][playerlvl] > 10) return SendClientError(playerid, "Players over level 10 cannot buy properties.");
	    BuyPropertyForPlayer(playerid);
	}
	else if(!strcmp(tmp, "sell", true, 4))
	{
	    SellPropertyForPlayer(playerid);
	}
	else if(!strcmp(tmp, "help", true, 4))
	{
	    SendClientMessage(playerid, COLOR_HELPEROOC, "Temporary Properties | Help");
	    SendClientMessage(playerid, COLOR_WHITE, " Those properties are temporary. You will gain a certain amount of cash each 5 minutes.");
	    SendClientMessage(playerid, COLOR_WHITE, " Once you bought the property, noone can buy it for 10 minutes. If you log off, you lose it!");
	    SendClientMessage(playerid, COLOR_WHITE, " Make sure you /prop sell all your properties before you log off!");
	    SendClientMessage(playerid, COLOR_WHITE, " You can use /myprops to see which properties you own!");
	}
	else return SCP(playerid, "[buy/sell/help]");
	return 1;
}
COMMAND:myprops(playerid)
{
    GetPlayerProperties(playerid);
	return 1;
}
COMMAND:makefire(playerid, params[])
{
    if(PlayerInfo[playerid][power] < 10) return SendClientError(playerid, CANT_USE_CMD);
    new Float:x, Float:y, Float:z, Float:a;
    GetXYInFrontOfPlayer(playerid, x, y, z, a, 2.5);
    AddFire(x, y, z);
    return 1;
}
COMMAND:up(playerid, params[])
{
    new Float:px, Float:py, Float:pz;
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
    GetPlayerPos(playerid,px,py,pz);
	SetPlayerPos(playerid,px,py,pz+5);
	TogglePlayerControllable(playerid,true);
	return 1;
}
COMMAND:down(playerid, params[])
{
    new Float:px, Float:py, Float:pz;
    if(!PlayerInfo[playerid][power]) return SendClientError(playerid, CANT_USE_CMD);
    GetPlayerPos(playerid,px,py,pz);
    SetPlayerPos(playerid,px,py,pz-5);
	TogglePlayerControllable(playerid,true);
	return 1;
}
COMMAND:seatbelt(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    if(IsPlayersVehicleBike(playerid) == 0)
	    {
	        if(PlayerTemp[playerid][belt] == 0)
	        {
	            if(PlayerInfo[playerid][pGender] == SKIN_FEMALE)
	            {
	            	Action(playerid, "has put her seatbelt on");
				}
	            else
	            {
	            	Action(playerid, "has put his seatbelt on");
				}
				PlayerTemp[playerid][belt] = 1;
	        }
	        else if(PlayerTemp[playerid][belt] == 1)
	        {
	            if(PlayerInfo[playerid][pGender] == SKIN_FEMALE)
	            {
	            	Action(playerid, "has taken her seatbelt off");
				}
	            else
	            {
	            	Action(playerid, "has taken his seatbelt off");
				}
	            PlayerTemp[playerid][belt] = 0;
	        }
	    }
	    else return SendClientError(playerid, "This vehicle hasn't got a seabelt installed.");
	}
	else return SendClientError(playerid, "You need to be inside a vehicle");
	return 1;
}
/*COMMAND:creategate(playerid, params[])
{
    if(GetAdminLevel(playerid) < 9) return SendClientError(playerid, CANT_USE_CMD);
    new gatetmp;
    if(sscanf(params, "d", gatetmp)) return SCP(playerid, "[ factionID ]");
    if(GetUnusedGate() == -1) return SendClientError(playerid, "No more Gatess can be created, max reached!");
    new Float:ngX, Float:ngY, Float:ngZ;
    GetPlayerPos(playerid, ngX, ngY, ngZ);
    CreateGate(ngX, ngY, ngZ, 0.0, 0.0, 0.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), gatetmp);
    return 1;
}
 COMMAND:friend(playerid, params[])
{
	new tmp[ 24 ], tmp2[ 24 ], tmp3[ 24 ], tmp4[ 24 ], query[240];
	if(sscanf(params, "szz", tmp, tmp2, tmp3, tmp4)) return SCP(playerid, "[ add / remove / list]");
	if(!strcmp(tmp, "add", true, 3))
	{
		if(!strlen(tmp2) || IsNumeric(tmp2) || strlen(tmp2) > MAX_PLAYER_NAME) return SCP(playerid, "add [name]");
		new jname[25];
		jname = tmp2;
		new pname[25];
		GetPlayerName(playerid, pname, sizeof(pname));
		format(query, sizeof(query), "SELECT IP FROM `PlayerInfo` WHERE `user` = '%s'", jname);
		mysql_query(query);
		mysql_store_result();
  		new rows = mysql_num_rows();
  		if(rows)
  		{
  			format(query,sizeof(query), "INSERT INTO `FriendInfo` (you, friend) VALUES ('%s', ('%s'));", pname, jname);
			mysql_query(query);
	    	format(iStr, sizeof(iStr),"You have added: %s to your friend list.", jname);
			SendClientInfo(playerid, iStr);
  			new playerID = GetPlayerId(jname);
			if(IsPlayerConnected(playerID))
			{
			    SendClientMSG(playerID, COLOR_ADMIN_PM, "[FRIEND] %s has added you from thier friend list.", RPName(playerid));
			}
		}
		else return SendClientError(playerid, "Player hasn't been found in the database");
		mysql_free_result();
	}
	else if(!strcmp(tmp, "remove", true, 6))
	{
		if(!strlen(tmp2) || IsNumeric(tmp2) || strlen(tmp2) > MAX_PLAYER_NAME) return SCP(playerid, "remove [name]");
		new jname[25];
		jname = tmp2;
		new pname[25];
		GetPlayerName(playerid, pname, sizeof(pname));
		format(query, sizeof(query), "SELECT IP FROM `PlayerInfo` WHERE `user` = '%s'", jname);
		mysql_query(query);
		mysql_store_result();
  		new rows = mysql_num_rows();
  		if(rows)
  		{
	  		format(query,sizeof(query), "DELETE FROM `FriendInfo` WHERE `you` = '%s' AND `friend` = '%s'", pname, jname);
		    mysql_query(query);
		    format(iStr, sizeof(iStr),"You have removed: %s from your friend list.", jname);
			SendClientInfo(playerid, iStr);
			new playerID = GetPlayerId(jname);
			if(IsPlayerConnected(playerID))
			{
			    SendClientMSG(playerID, COLOR_ADMIN_PM, "[FRIEND] %s has removed you from thier friend list.", RPName(playerid));
			}
		}
		else return SendClientError(playerid, "Player hasn't been found in the database");
		mysql_free_result();
	}
	else if(!strcmp(tmp, "list", true, 4))
	{
	    new pname[24], friend[128], string[258], savingstring[128];
	    GetPlayerName(playerid, pname, sizeof(pname));
     	format(query, sizeof(query), "SELECT `friend` FROM `FriendInfo` WHERE `you` = '%s'", pname);
    	mysql_query(query);
    	mysql_store_result();
    	SendClientMessage(playerid, COLOR_ADMIN_PM, "[FRIENDS] - Your friend list:");
		while(mysql_fetch_row_format(query, "|"))
		{
			mysql_fetch_field_row(savingstring, "friend");
			myStrcpy(friend, savingstring);
//==============================================================================
	  		new playerID = GetPlayerId(friend);
			if(IsPlayerConnected(playerID))
			{
			    if(IsPlayerAFK(playerID) > 3) format(string, sizeof(string), " - {f47c1b}[AFK]");
			    else format(string, sizeof(string),"");
				SendClientMSG(playerid, COLOR_LIGHTGREY, " - %s - {6BDE54}[ONLINE]%s", RPName(playerID), string);
			}
			else
			{
				SendClientMSG(playerid, COLOR_LIGHTGREY, " - %s - {FF0000}[OFFLINE]", friend);
			}
		}
		mysql_free_result();
	}
	else return SCP(playerid, "[ add / remove / list]");
	return 1;
} */