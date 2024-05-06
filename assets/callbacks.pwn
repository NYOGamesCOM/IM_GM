/*********************************************************************************************************************************************
						- NYOGames [callbacks.pwn file]
*********************************************************************************************************************************************/
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new vehid = FindVehicleID(vehicleid);
	PlayerLoop(x)
	{
	    if(!IsPlayerConnected(x)) continue;
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerTemp[x][spectatingID] == playerid)
		{
	        TogglePlayerSpectating(x, 1);
	        PlayerSpectateVehicle(x, vehicleid);
	        PlayerTemp[x][specType] = ADMIN_SPEC_TYPE_VEHICLE;
		}
	}
	if(!ispassenger)
	{
	    if(VehicleInfo[vehid][vFaction] != CIV) // faction car!
		{
			if(FactionInfo[VehicleInfo[vehid][vFaction]][fType] == FAC_TYPE_ARMY || FactionInfo[VehicleInfo[vehid][vFaction]][fType] == FAC_TYPE_POLICE || FactionInfo[VehicleInfo[vehid][vFaction]][fType] == FAC_TYPE_GOV || FactionInfo[VehicleInfo[vehid][vFaction]][fType] == FAC_TYPE_FBI)
			{
				if(PlayerInfo[playerid][playerteam] != VehicleInfo[vehid][vFaction])
				{
					SendClientMessage(playerid, COLOR_GREY, "This vehicle is reserved!");
					Up(playerid);
				}
			}
		}
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	PlayerLoop(x)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerTemp[x][spectatingID] == playerid && PlayerTemp[x][specType] == ADMIN_SPEC_TYPE_VEHICLE)
		{
	        TogglePlayerSpectating(x, 1);
	        PlayerSpectatePlayer(x, playerid);
	        PlayerTemp[x][specType] = ADMIN_SPEC_TYPE_PLAYER;
		}
	}
	if(PlayerTemp[playerid][belt] == 1)
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
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	SetTimerEx("OnVehicleSpawn", 1000, false, "d", vehicleid);
}

public OnVehicleSpawn(vehicleid)
{
	UnlockVehicle(vehicleid);
	if(!strcmp(VehicleInfo[FindVehicleID(vehicleid)][vOwner], "NoBodY", false) || VehicleInfo[FindVehicleID(vehicleid)][vSellPrice] > 0) UnlockVehicle(vehicleid);
	else
	{
		if(DoesVehicleHaveLock(vehicleid) == true) LockVehicle(-1, vehicleid);
	}
	SetTimerEx("ModCar", 1000, 0, "d", vehicleid);
	ChangeVehiclePaintjob(vehicleid, VehicleInfo[FindVehicleID(vehicleid)][vPaintJob]);
	return 1;
}

public FuelDown()
{
	PlayerLoop(i)
   	{
   		new carid = GetPlayerVehicleID(i);
   		if(GetPlayerState(i) != PLAYER_STATE_DRIVER) continue;
		if(carid == 0) continue;
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
		if(engine == 0) continue;
		if(CheckIfVehicleUsesFuel(carid) == false) continue;
		VehicleInfo[FindVehicleID(carid)][vFuel]--;
   	}
  	return 1;
}

public CheckGas()
{
	new string[164];
	PlayerLoop(i)
   	{
		if(GetPlayerState(i) == PLAYER_STATE_DRIVER || IsPlayerInAnyVehicle(i) && GetPlayerWeapon(i) == 24) SetPlayerArmedWeapon(i, 0);
		if(IsPlayerAFK(i))
		{
			new iAFK[75];
			format(iAFK, sizeof(iAFK), "%s(%d) [Paused: %s secs]", PlayerName(i), i, number_format(PlayerTemp[i][pAFK]));
			SetPlayerChatBubble(i, iAFK, COLOR_ADMIN_SPYREPORT, 50.0, 10000);
		}
		if(!PlayerTemp[i][adminduty])
		{
			if(PlayerTemp[i][oocmode]) SetPlayerChatBubble(i, "(( OOC MODE ))", COLOR_ADMIN_SPYREPORT, 50.0, 10000);
			if(PlayerTemp[i][helperduty]) SetPlayerChatBubble(i, "(( HELPERDUTY ))", 0xe70909AA, 50.0, 10000);
		}
		else SetPlayerChatBubble(i, "(( ADMINDUTY ))", 0xe70909AA, 50.0, 10000);
       	new Float:pH, Float:pA;
	    GetPlayerHealth(i, pH);
	    GetPlayerArmour(i, pA);
	    new Float:x, Float:y, Float:z, Float:distance, value;
       	if(!IsPlayerInAnyVehicle(i))
       	{
	    	if(PlayerTemp[ i ][ tazed ]) ApplyAnimation(i,"CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 1); // irl crack!
			TextDrawHideForPlayer(i, PlayerTemp[i][Status]);
       	}
        else
		{
		    new isLocked[25];
			new carid = GetPlayerVehicleID(i);
			new vehicleid = FindVehicleID(carid);
			if(VehicleInfo[vehicleid][vLocked] == true) myStrcpy(isLocked, "~r~Locked"); else myStrcpy(isLocked, "~w~Unlocked");
			GetPlayerPos(i, x, y, z);
           	distance = floatsqroot(floatpower(floatabs(floatsub(x,SavePlayerPos[i][LastX])),2)+floatpower(floatabs(floatsub(y,SavePlayerPos[i][LastY])),2)+floatpower(floatabs(floatsub(z,SavePlayerPos[i][LastZ])),2));
            value = floatround(distance * 5600);
            new Float:tmph;
            GetVehicleHealth(carid, tmph);
			format(string, sizeof(string),"~g~Speed: ~w~%d km/h~n~~g~Fuel: ~w~%d%%~n~~g~Health: ~w~%.0f%%~n~~g~Mileage: ~w~%dkm~n~~g~Doors: %s", floatround(value/600), VehicleInfo[vehicleid][vFuel], (tmph / 10), floatround(VehicleInfo[vehicleid][vMileage]), isLocked);
			TextDrawSetString(PlayerTemp[i][Status], string);
			TextDrawShowForPlayer(i, PlayerTemp[i][Status]);
			if(IsVehicleOccupied(carid))
			{
				new Float:mileagetoadd = floatround(value/600) / 60;
				VehicleInfo[vehicleid][vMileage] += mileagetoadd / 60;
			}	
			if(VehicleInfo[vehicleid][vFuel] <= 10 && IsPlayerDriver(i)) TDWarning(i, "you are running out of fuel!", 1400);
         	if(VehicleInfo[vehicleid][vFuel] <= 0 && IsPlayerDriver(i)) Up(i), SendClientInfo(i, "No fuel!");
         	SavePlayerPos[i][LastX] = x;
          	SavePlayerPos[i][LastY] = y;
         	SavePlayerPos[i][LastZ] = z;
		}
	}
	return 1;
}

public Refuel(playerid, carid, Float:carX)
{
	new Float:carNewX, Float:carNewY, Float:carNewZ;
	GetVehiclePos(carid, carNewX, carNewY, carNewZ);	
	if(VehicleInfo[FindVehicleID(carid)][vFuel] == 100 || carNewX != carX)
	{
	    new messaggio[MAX_STRING]; format(messaggio,sizeof(messaggio),"* %s's vehicle has been refilled.", MaskedName(playerid));
		NearMessage(playerid,messaggio,COLOR_ME);
		return 1;
	}
	if(VehicleInfo[FindVehicleID(carid)][vFuel] < 100) VehicleInfo[FindVehicleID(carid)][vFuel] = VehicleInfo[FindVehicleID(carid)][vFuel] + 1;
	SetTimerEx("Refuel", 1000, 0, "iif", playerid, carid, carNewX);
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	new carid = FindVehicleID(vehicleid);
	VehicleInfo[ carid ][ vComponents ] [ 0 ] = GetVehicleComponentInSlot(vehicleid, 0);
	VehicleInfo[ carid ][ vComponents ] [ 1 ] = GetVehicleComponentInSlot(vehicleid, 1);
	VehicleInfo[ carid ][ vComponents ] [ 2 ] = GetVehicleComponentInSlot(vehicleid, 2);
	VehicleInfo[ carid ][ vComponents ] [ 3 ] = GetVehicleComponentInSlot(vehicleid, 3);
	VehicleInfo[ carid ][ vComponents ] [ 4 ] = GetVehicleComponentInSlot(vehicleid, 4);
	VehicleInfo[ carid ][ vComponents ] [ 5 ] = GetVehicleComponentInSlot(vehicleid, 5);
	VehicleInfo[ carid ][ vComponents ] [ 6 ] = GetVehicleComponentInSlot(vehicleid, 6);
	VehicleInfo[ carid ][ vComponents ] [ 7 ] = GetVehicleComponentInSlot(vehicleid, 7);
	VehicleInfo[ carid ][ vComponents ] [ 8 ] = GetVehicleComponentInSlot(vehicleid, 8);
	VehicleInfo[ carid ][ vComponents ] [ 9 ] = GetVehicleComponentInSlot(vehicleid, 9);
	VehicleInfo[ carid ][ vComponents ] [ 10 ] = GetVehicleComponentInSlot(vehicleid, 10);
	VehicleInfo[ carid ][ vComponents ] [ 11 ] = GetVehicleComponentInSlot(vehicleid, 11);
	VehicleInfo[ carid ][ vComponents ] [ 12 ] = GetVehicleComponentInSlot(vehicleid, 12);
	VehicleInfo[ carid ][ vComponents ] [ 13 ] = GetVehicleComponentInSlot(vehicleid, 13);
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new Float:oldX, Float:oldY, Float:oldZ, Float:oldRotX, Float:oldRotY, Float:oldRotZ;
	GetDynamicObjectPos(objectid, oldX, oldY, oldZ);
	GetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
	if(response == EDIT_RESPONSE_FINAL)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(houseid != -1)
		{
			FurnitureLoop(f)
			{
				if(FurnitureInfo[houseid][f][furActive] != true) continue;
				if(FurnitureInfo[houseid][f][furObject] == objectid)
				{
					DestroyDynamicObject(FurnitureInfo[houseid][f][furObject]);
					FurnitureInfo[houseid][f][furX] = x;
					FurnitureInfo[houseid][f][furY] = y;
					FurnitureInfo[houseid][f][furZ] = z;
					FurnitureInfo[houseid][f][furrX] = rx;
					FurnitureInfo[houseid][f][furrY] = ry;
					FurnitureInfo[houseid][f][furrZ] = rz;
					ReloadFurniture(houseid, true, f);
					return 1;
				}
			}
		}
		else
		{
			ATMLoop(i)
			{
				if(ATMInfo[i][atmActive] != true) continue;
				if(ATMInfo[i][atmObject] == objectid)
				{
					DestroyDynamicObject(ATMInfo[i][atmObject]);
					DestroyDynamic3DTextLabel(ATMInfo[i][atmLabel]);

					ATMInfo[i][atmX] = x; ATMInfo[i][atmrotX] = rx;
					ATMInfo[i][atmY] = y; ATMInfo[i][atmrotY] = ry;
					ATMInfo[i][atmZ] = z; ATMInfo[i][atmrotZ] = rz;
					ATMInfo[i][atmInterior] = GetPlayerInterior(playerid);
					ATMInfo[i][atmVirtualWorld] = GetPlayerVirtualWorld(playerid);
					ReloadATM(i);
					return 1;
				}
			}
		}
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		SetDynamicObjectPos(objectid, oldX, oldY, oldZ);
		SetDynamicObjectRot(objectid, oldRotX, oldRotY, oldRotZ);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{

	if(!Whitelisted(PlayerName(playerid))) return WhiteKick(playerid);
    LoadPlayerAnimLibs(playerid);
	RemoveBuildingForPlayer(playerid, 4239, 1407.9063, -1407.3984, 33.9844, 0.25);
	new playerip[32];
	GetPlayerIp(playerid,playerip,32);
	format(PlayerTemp[playerid][IP], 32, "%s", playerip);

	dini_IntSet(globalstats, "connects", dini_Int(globalstats,"connects")+1);

    new nome[ MAX_STRING ], nome2[ MAX_STRING ];
	format( nome, sizeof(nome), "14[JOIN] %s[%d] has joined "SERVER_GM". (IP: %s) - Connects: %d | Online: %d",PlayerName(playerid), playerid, playerip, dini_Int(globalstats,"connects"), ConnectedPlayers());
	iEcho( nome );

	format(nome,sizeof(nome),"[JOIN] %s(%d) has joined "SERVER_GM"",RPName(playerid),playerid);
	format(nome2,sizeof(nome2),"[JOIN] %s(%d) has joined "SERVER_GM" (IP: %s)",RPName(playerid),playerid, playerip);
	PlayerLoop(i)
	{
		if(PlayerTemp[i][jqmessage])
		{
		    if(PlayerInfo[i][power]) SendClientMessage(i,COLOR_LIGHTGREY, nome2);
		    else SendClientMessage(i,COLOR_LIGHTGREY, nome);
		}
	}

	SetTimerEx("ConnectIRC", 200, false, "d", playerid);
	SetTimerEx("WelcomeMessage", 2000, 0, "ii", playerid, 0);
	
	TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Status]);
	TextDrawHideForPlayer(playerid, PlayerTemp[playerid][LocationTD]);
    TextDrawHideForPlayer(playerid, TextDraw__News);
    TextDrawHideForPlayer(playerid, IMtxt);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(PlayerTemp[playerid][CPTimer]);
	KillTimer(PlayerTemp[playerid][DropTimer]);
	KillTimer(PlayerTemp[playerid][RobTimer]);
	KillTimer(PlayerTemp[playerid][RobBizTimer]);
	KillTimer(PlayerTemp[playerid][lictimer]);
	KillTimer(PlayerTemp[playerid][PlayerBugTimer]);
	ResetPlayerPropertyInfo(playerid);
	PlayerLoop(x)
	{
		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerTemp[x][spectatingID] == playerid) AdvanceSpectate(x);
	}
	new playername[MAX_PLAYER_NAME], str[MAX_STRING];
	GetPlayerName(playerid, playername, sizeof(playername));
  	if (PlayerTemp[playerid][loggedIn])
	{
		new wat[ 40 ];
		switch (reason)
		{
			case 0:
			{
				format(str, 256, "[PART] %s has left the server (Timeout)", playername);
				for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i) && PlayerTemp[i][jqmessage]) SendClientMessage(i,COLOR_LIGHTGREY, str);
				format( str, sizeof(str), "14[QUIT] %s[%d] has left "SERVER_GM". (Timeout)",PlayerName(playerid), playerid);
				iEcho( str );
				format(str, sizeof(str), "# [%s] %s %s has logged out (Timeout/Crash)",  GetPlayerFactionName(playerid),PlayerInfo[playerid][rankname], RPName(playerid));
				if(PlayerInfo[playerid][playerteam] != CIV) SendClientMessageToTeam(PlayerInfo[playerid][playerteam],str,COLOR_PLAYER_VLIGHTBLUE);
				myStrcpy(wat, "Timeout");
			}
			case 1:
			{
				format(str, 256, "[PART] %s has left the server (Leaving)", playername);
				for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i) && PlayerTemp[i][jqmessage]) SendClientMessage(i,COLOR_LIGHTGREY, str);
				format( str, sizeof(str), "14[QUIT] %s[%d] has left "SERVER_GM". (Leaving)",PlayerName(playerid), playerid);
				iEcho( str );
				format(str, sizeof(str), "# [%s] %s %s has logged out (Leaving)",  GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], RPName(playerid));
				if(PlayerInfo[playerid][playerteam] != CIV) SendClientMessageToTeam(PlayerInfo[playerid][playerteam],str,COLOR_PLAYER_VLIGHTBLUE);
				myStrcpy(wat, "Leaving");
			}
			case 2:
			{
				format(str, 256, "[PART] %s has left the server (Kicked/Banned)", playername);
				for(new i=0;i<MAX_PLAYERS;i++) if(IsPlayerConnected(i) && PlayerTemp[i][jqmessage]) SendClientMessage(i,COLOR_LIGHTGREY, str);
				format( str, sizeof(str), "14[QUIT] %s[%d] has left "SERVER_GM". (Kicked/Banned)",PlayerName(playerid), playerid);
				iEcho( str );
				format(str, sizeof(str), "# [%s] %s %s has logged out (Kicked/Banned)",  GetPlayerFactionName(playerid),PlayerInfo[playerid][rankname], RPName(playerid));
				if(PlayerInfo[playerid][playerteam] != CIV) SendClientMessageToTeam(PlayerInfo[playerid][playerteam],str,COLOR_PLAYER_VLIGHTBLUE);
				myStrcpy(wat, "Kicked/Banned");
			}
		}
		format(str, sizeof(str), "(( Local: %s[%d] has left the server [%s] ))", playername, playerid, wat);
		NearMessage(playerid,str,COLOR_LIGHTGREY);
		if(PlayerTemp[playerid][cuffed] && reason == 1)
		{
			PlayerInfo[playerid][jail]=1;
			PlayerInfo[playerid][jailtime]=1800;
			PlayerInfo[playerid][bail]=777;
			myStrcpy(PlayerInfo[playerid][jailreason], "Quit on Arrest");
			new avoid[MAX_STRING];
			format(avoid,sizeof(avoid),"[QUITJAIL] %s got 30 minutes of autojail for quitting during arrest.", playername);
			SendClientMessageToAll(0xCCFFCC00,avoid);
			PlayerTemp[playerid][cuffed] = false;
		}
	    SaveAccount(playerid);
		/*			[Checks] 		*/
	    for(new q; q < sizeof(Seeds); q++)
		{
			if(!strcmp(PlayerName(playerid), Seeds[q][sOwner], false)) ResetSeed(q);
		}
		if(PlayerTemp[playerid][rentcar] != 0)
		{
	        UnlockVehicle(PlayerTemp[playerid][rentcar]);
			PlayerTemp[playerid][rentcar] = -0;
		}
		if(IsPlayerInPaintball(playerid))
		{
		    if(PlayerTemp[playerid][pbteam] == 1) PBTeams[PlayerTemp[playerid][onpaint]][redteamcount]--;
		    else PBTeams[PlayerTemp[playerid][onpaint]][blueteamcount]--;
		}
		if(PlayerTemp[playerid][phone] == 1)
		{
		    SendClientMessage(PlayerTemp[playerid][onphone], COLOR_PLAYER_DARKYELLOW, "Phone Connection Lost");
	    	PlayerTemp[playerid][phone] = 0;
	        PlayerTemp[PlayerTemp[playerid][onphone]][phone] = 0;
	        PlayerTemp[PlayerTemp[playerid][onphone]][onphone] = INVALID_PLAYER_ID;
	        PlayerTemp[playerid][onphone] = INVALID_PLAYER_ID;
	    }
		/*			[PVars] 		*/
		SetPVarInt(playerid, "GarageID", -1);
		SetPVarInt(playerid, "TrainingFor", -1);
		DeletePVar(playerid, "InvitedBy");
		DeletePVar(playerid, "BreakingIntoCar");
		DeletePVar(playerid, "BreakingIntoCarTimer");
		DeletePVar(playerid, "BreakingIntoCarNeeded");
		DeletePVar(playerid, "x");
		DeletePVar(playerid, "y");
		DeletePVar(playerid, "z");
		DeletePVar(playerid, "robbingtime");
		DeletePVar(playerid, "isrobbingbiz");
		DeletePVar(playerid, "isrobbing");
		DeletePVar(playerid, "RobBagAmount");
		DeletePVar(playerid, "DriverLic");
		DeletePVar(playerid, "ReadyToGetCargo");
		DeletePVar(playerid, "DeliveringCargo");
		DeletePVar(playerid, "HarvestCP");
		DeletePVar(playerid, "HarvestAmount");
		DeletePVar(playerid, "StoringLeadToWareHouse");
		DeletePVar(playerid, "StoringMetalToWareHouse");
		DeletePVar(playerid, "TakingFromLead");
		DeletePVar(playerid, "TakingFromMetal");
		DeletePVar(playerid, "oposx");
		DeletePVar(playerid, "oposy");
		DeletePVar(playerid, "oposz");
		DeletePVar(playerid, "BriefCaseTill");
		DeletePVar(playerid, "Tazer");
		DeletePVar(playerid, "WardrobeDialog");
		DeletePVar(playerid, "HBaseTextureSlot");
		DeletePVar(playerid, "HasRope");
		DeletePVar(playerid, "HasRag");
		DeletePVar(playerid, "Toolkit");
		DeletePVar(playerid, "PetrolCan");
		DeletePVar(playerid, "EditingWhat");
		DeletePVar(playerid, "WardrobeSlotSelect");
		DeletePVar(playerid, "HBaseEditTexture");
		DeletePVar(playerid, "IsMakingDriverLic");
		DeletePVar(playerid, "togPM");
		DeletePVar(playerid, "SkinSelect");
		DeletePVar(playerid, "Tied");
		DeletePVar(playerid, "StrangerID");
		DeletePVar(playerid, "WireTransfer");
		DeletePVar(playerid, "RefuelID");
		DeletePVar(playerid, "RefuelPrice");
		DeletePVar(playerid, "Convo");
		DeletePVar(playerid, "ConvoLeader");
		DeletePVar(playerid, "ConvoMute");
		for(new c = 0; c < 3; c++)
		{
			new iFormat[15];
			format(iFormat, sizeof(iFormat), "markX$d", c); DeletePVar(playerid, iFormat);
			format(iFormat, sizeof(iFormat), "markY$d", c); DeletePVar(playerid, iFormat);
			format(iFormat, sizeof(iFormat), "markZ$d", c); DeletePVar(playerid, iFormat);
			format(iFormat, sizeof(iFormat), "markINT$d", c); DeletePVar(playerid, iFormat);
			format(iFormat, sizeof(iFormat), "markVW$d", c); DeletePVar(playerid, iFormat);
		}
		/*			[PlayerInfo] 		*/
		PlayerInfo[playerid][SQL_ID] = -1;
		PlayerInfo[playerid][bank] = 0;
		PlayerInfo[playerid][playerlvl] = 0;
		PlayerInfo[playerid][rpoints] = 0;
		PlayerInfo[playerid][rpoints] = 0;
		PlayerInfo[playerid][playertime] = 0;
		PlayerInfo[playerid][jail] = 0;
		myStrcpy(PlayerInfo[playerid][jailreason], "None");
		PlayerInfo[playerid][jailtime] = 0;
		PlayerInfo[playerid][banned] = 0;
		myStrcpy(PlayerInfo[playerid][banreason], "None");
		myStrcpy(PlayerInfo[playerid][whobannedme], "NoBodY");
		myStrcpy(PlayerInfo[playerid][whenigotbanned], "Never");
		PlayerInfo[playerid][Skin] = 7;
		PlayerInfo[playerid][ranklvl] = 0;
		PlayerInfo[playerid][rentprice] = 0;
		PlayerInfo[playerid][driverlic] = 0;
		PlayerInfo[playerid][flylic] = 0;
		PlayerInfo[playerid][boatlic] = 0;
		PlayerInfo[playerid][weaplic] = 0;
		PlayerInfo[playerid][jobskill] = 0;
		PlayerInfo[playerid][totalpayt] = 0;
		PlayerInfo[playerid][kills] = 0;
		PlayerInfo[playerid][deaths] = 0;
		PlayerInfo[playerid][housenum] = -1;
		PlayerInfo[playerid][loan] = 0;
		PlayerInfo[playerid][guns] = 0;
		PlayerInfo[playerid][sMaterials] = 0;
		PlayerInfo[playerid][sdrugs] = 0;
		PlayerInfo[playerid][power] = 0;
		PlayerInfo[playerid][bail] = 0;
		PlayerInfo[playerid][premium] = 0;
		PlayerInfo[playerid][gotphone] = 0;
		PlayerInfo[playerid][phonenumber] = 0;
		PlayerInfo[playerid][phonebook] = 0;
		PlayerInfo[playerid][laptop] = 0;
		PlayerInfo[playerid][age] = 0;
		PlayerInfo[playerid][premiumexpire] = 0;
		PlayerInfo[playerid][playerteam] = 255;
		PlayerInfo[playerid][radio] = 0;
		PlayerInfo[playerid][freq1] = INVALID_RADIO_FREQ;
		PlayerInfo[playerid][freq2] = INVALID_RADIO_FREQ;
		PlayerInfo[playerid][freq3] = INVALID_RADIO_FREQ;
		PlayerInfo[playerid][tbanned] = 0;
		myStrcpy(PlayerInfo[playerid][job], "None");
		PlayerInfo[playerid][totalruns] = 0;
		PlayerInfo[playerid][fpay] = 0;
		LOOP:c(0, MAX_DRUG_TYPES) PlayerInfo[playerid][hasdrugs][c] = 0;
		PlayerInfo[playerid][warns] = 0;
		PlayerInfo[playerid][helper] = 0;
		PlayerInfo[playerid][curfreq] = 0;
		myStrcpy(PlayerInfo[playerid][rankname], "CIV");
		PlayerInfo[playerid][phonechanges] = 0;
		PlayerInfo[playerid][namechanges] = 0;
		PlayerInfo[playerid][lastonline] = 0;
		PlayerInfo[playerid][vMax] = 0;
		PlayerInfo[playerid][vSpawnMax] = 0;
		PlayerInfo[playerid][pbkills] = 0;
		PlayerInfo[playerid][pbdeaths] = 0;
		PlayerInfo[playerid][pGender] = 0;
		PlayerInfo[playerid][pEthnicity] = 0;
		PlayerInfo[playerid][pBoomBox] = 0;
		PlayerInfo[playerid][allowCBug] = 0;
		PlayerInfo[playerid][pBoomBoxBan] = 0;
		PlayerInfo[playerid][wantedLvl] = 0;
		SetPlayerWantedLevel(playerid, 0);
		/*			[PlayerTemp] 		*/
		ResetPlayerWeaponsEx(playerid);
		PlayerTemp[playerid][sm] = 0;
		PlayerTemp[playerid][candrop] = 0;
		PlayerTemp[playerid][Duty] = 0;
		PlayerTemp[playerid][callingtaxi] = 0;
		PlayerTemp[playerid][phoneoff] = 0;
		PlayerTemp[playerid][oocoff] = 0;
		PlayerTemp[playerid][tokick] = 0;
		PlayerTemp[playerid][onphone] = INVALID_PLAYER_ID;
		PlayerTemp[playerid][phone] = 0;
		PlayerTemp[playerid][muted] = 0;
		PlayerTemp[playerid][mutedtick] = 0;
		PlayerTemp[playerid][rentcar] = 0;
		PlayerTemp[playerid][carfrozen] = 0;
		PlayerTemp[playerid][wlock] = 0;
		PlayerTemp[playerid][tmphouse] = -1;
		PlayerTemp[playerid][tmpbiz] = -1;
		PlayerTemp[playerid][jqmessage] = 0;
		PlayerTemp[playerid][hname] = 0;
		PlayerTemp[playerid][onpaint] = 0;
		PlayerTemp[playerid][pbteam] = 0;
		PlayerTemp[playerid][playertosms] = INVALID_PLAYER_ID;
		PlayerTemp[playerid][adminduty] = 0;
		PlayerTemp[playerid][helperduty] = 0;
		PlayerTemp[playerid][adminspy] = 0;
		PlayerTemp[playerid][admincmdspy] = 0;
		PlayerTemp[playerid][DropTimer] = 0;
		PlayerTemp[playerid][isdropping] = 0;
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Status]);
		myStrcpy(PlayerTemp[playerid][IP], "0.0.0.0");
		PlayerTemp[playerid][canrob] = 0;
		PlayerTemp[playerid][RobTimer] = 0;
		PlayerTemp[playerid][spawnrdy] = 0;
		PlayerTemp[playerid][WrongPass] = 0;
		PlayerTemp[playerid][cmdtick] = 0;
		PlayerTemp[playerid][tp] = 0;
		PlayerTemp[playerid][hashadhelp] = 0;
		PlayerTemp[playerid][RobBizTimer] = 0;
		PlayerTemp[playerid][seeds] = 0;
		PlayerTemp[playerid][drugtick] = 0;
		PlayerTemp[playerid][fishamount] = 0;
		PlayerTemp[playerid][fishtick] = 0;
		PlayerTemp[playerid][fontick] = 0;
		PlayerTemp[playerid][lictimer] = 0;
		myStrcpy(PlayerTemp[playerid][ppassword], "Nothing");
		PlayerTemp[playerid][totalfish] = 0;
		PlayerTemp[playerid][totalrob] = 0;
		PlayerTemp[playerid][totalguns] = 0;
		PlayerTemp[playerid][totallogin] = 0;
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][InfoBox]);
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][InfoBoxTitle]);
		PlayerTemp[playerid][key_enter] = 2;
		PlayerTemp[playerid][imprisoned] = 2;
		PlayerTemp[playerid][HasRedScreen] = 2;
		PlayerTemp[playerid][RobbingHouse] = -1;
		PlayerTemp[playerid][GYM_CURKEY] = 0;
		PlayerTemp[playerid][GYM_CURDONE] = 0;
		PlayerTemp[playerid][oocmode] = 0;
		PlayerTemp[playerid][fightstyleleft] = 0;
		PlayerTemp[playerid][lastpm] = INVALID_PLAYER_ID;
		PlayerTemp[playerid][PlayerUsingBug] = 0;
		PlayerTemp[playerid][PlayerBugTimer] = 0;
		PlayerTemp[playerid][animation] = 0;
		PlayerTemp[playerid][pupdates] = 0;
		PlayerTemp[playerid][CPTimer] = 0;
		PlayerTemp[playerid][airbreakcount] = 0;
		PlayerTemp[playerid][BlindFold] = false;
		PlayerTemp[playerid][iconcount] = 0;
		PlayerTemp[playerid][cuffed] = false;
		PlayerTemp[playerid][weapon] = 0;
		PlayerTemp[playerid][ammo] = 0;
		PlayerTemp[playerid][tazed] = 0;
		PlayerTemp[playerid][gettingTreatmentFromHospital] = false;
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Cargo]);
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Harvest]);
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][plrwarning]);
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][jailtd]);
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][LocationTD]);
		PlayerTemp[playerid][pFurnitureCategorySelect][MAIN_CATEGORY_SELECT] = -1;
		PlayerTemp[playerid][pFurnitureCategorySelect][SUB_CATEGORY_SELECT] = -1;
		PlayerTemp[playerid][pFurnitureSelectID] = -1;
		PlayerTemp[playerid][pMaterialSlotEdit] = -1;
		PlayerTemp[playerid][pAFK] = 0;
		PlayerTemp[playerid][spectatingID] = 0;
		PlayerTemp[playerid][gPlayerUsingLoopingAnim] = 0;
		PlayerTemp[playerid][gPlayerAnimLibsPreloaded] = 0;
		PlayerTemp[playerid][ticket] = 0;
		PlayerTemp[playerid][isCCTV] = 0;
		PlayerTemp[playerid][loggedIn] = false;
		PlayerTemp[playerid][jobDuty] = false;
		PlayerTemp[playerid][belt]=0;
		for(new c = 0; c < 13; c++)
		{
			PlayerTemp[playerid][PlayerWeapon][c] = 0;
			PlayerTemp[playerid][PlayerAmmo][c] = 0;
		}
		for(new c = 0; c < 3; c++) PlayerTemp[playerid][PlayerPosition][c] = 0.0;
		PlayerTemp[playerid][PlayerHealth] = 0.0;
		PlayerTemp[playerid][PlayerArmour] = 0.0;
		PlayerTemp[playerid][PlayerInterior] = 0;
		PlayerTemp[playerid][PlayerVirtualWorld] = 0;
		PlayerTemp[playerid][RecentlyShot] = 0;
	    SetPlayerMoney(playerid, 0);
	    SetPlayerWantedLevel(playerid, 0);
	    SetPlayerScore(playerid, 0);
		VehicleLoop(i)
		{
		    if(VehicleInfo[i][vActive] != true) continue;
		    if(!strcmp(VehicleInfo[i][vOwner], playername, false))
			{
				SaveVehicle(i);
				if(VehicleInfo[i][vSpawned] == true)
				{
				    if(!IsVehicleOccupied(GetCarID(i)))
					{
				    	DestroyVehicle(GetCarID(i));
						VehicleInfo[i][vRID] = INVALID_VEHICLE_ID;
						VehicleInfo[i][vID] = INVALID_VEHICLE_ID;
						VehicleInfo[i][vSpawned] = false;
					}
				}
			}
		}
		if(BoomBoxInfo[playerid][boomActive] == true)
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
		for(new c = 0; c < MAX_PLAYER_TOYS; c++)
		{
			myStrcpy(PlayerToyInfo[playerid][c][ptName], "None");
			PlayerToyInfo[playerid][c][ptModelID] = -1;
			PlayerToyInfo[playerid][c][ptBone] = -1;
			PlayerToyInfo[playerid][c][ptPosX] = 0.0;
			PlayerToyInfo[playerid][c][ptPosY] = 0.0;
			PlayerToyInfo[playerid][c][ptPosZ] = 0.0;
			PlayerToyInfo[playerid][c][ptRotX] = 0.0;
			PlayerToyInfo[playerid][c][ptRotY] = 0.0;
			PlayerToyInfo[playerid][c][ptRotZ] = 0.0;
			PlayerToyInfo[playerid][c][ptScaleX] = 0.0;
			PlayerToyInfo[playerid][c][ptScaleY] = 0.0;
			PlayerToyInfo[playerid][c][ptScaleZ] = 0.0;
			PlayerToyInfo[playerid][c][ptActive] = false;
		}
		if(treadmillBUSY == playerid) treadmillBUSY = -1;
	}
	else
	{
		LoginDB(playerid, 0);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(PlayerTemp[playerid][gPlayerUsingLoopingAnim])
	{
        PlayerTemp[playerid][gPlayerUsingLoopingAnim] = 0;
        TextDrawHideForPlayer(playerid,txtAnimHelper);
	}
	PlayerInfo[playerid][deaths]++;
	SaveAccount(playerid);
	TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Status]);
    TextDrawHideForPlayer(playerid, TextDraw__News);
    TextDrawHideForPlayer(playerid, IMtxt);
	if(killerid != INVALID_PLAYER_ID) // player was killed by another player!
	{
		PlayerInfo[killerid][kills]++;
		SaveAccount(killerid);

		if(PlayerInfo[playerid][jail])
		{
			new iFormat[128];
			format(iFormat, sizeof(iFormat), "%s(%d) was killed in prison, by %s(%d).", RPName(playerid), playerid, RPName(killerid), killerid);
			AdminNotice(iFormat);
			return 1;
		}

	    if(PlayerTemp[playerid][onpaint] && PlayerTemp[killerid][onpaint])
		{
			new pbDeatherCol[12], pbKillerCol[12]; // Deather :/ really w00t?
			if(PlayerTemp[killerid][pbteam] == 1) myStrcpy(pbKillerCol, "{CC3300}");
			if(PlayerTemp[killerid][pbteam] == 2) myStrcpy(pbKillerCol, "{0000FF}");
			if(PlayerTemp[playerid][pbteam] == 1) myStrcpy(pbDeatherCol, "{CC3300}");
			if(PlayerTemp[playerid][pbteam] == 2) myStrcpy(pbDeatherCol, "{0000FF}");
			new wname[ 40 ];
			GetWeaponName(reason, wname, sizeof(wname));
			PlayerLoop(i)
		    {
		        if(!PlayerTemp[i][onpaint]) continue;
		        SendClientMSG(i, 0xFFFF00FF, "[PB]: %s%s (%.2f){FFFF00} killed %s%s (%.2f){FFFF00} with a %s (Distance: %dm)", pbKillerCol, RPName(killerid), pbDeatherCol, RPName(playerid), wname, GetDistanceBetweenPlayers(playerid, killerid));
		    }
		    if(PlayerTemp[playerid][pbteam] == 1) PBTeams[PlayerTemp[playerid][onpaint]][redscore]++;
		    else PBTeams[PlayerTemp[playerid][onpaint]][bluescore]++;
		    UpdatePBScore(PlayerTemp[playerid][onpaint], PBTeams[PlayerTemp[playerid][onpaint]][redscore], PBTeams[PlayerTemp[playerid][onpaint]][bluescore]);
			PlayerInfo[playerid][pbdeaths]++;
			PlayerInfo[killerid][pbkills]++;
			return 1;
		}

		new iQuery[246];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `Deaths` (`PlayerName`, `KillerName`, `Reason`, `TimeDate`) VALUES ('%e', '%e', '%d', '%e')", PlayerName(playerid), PlayerName(killerid), reason, TimeDateEx());
		mysql_pquery(MySQLPipeline, iQuery);
		PlayerLoop(p)
		{
			if(PlayerTemp[p][loggedIn] != true) continue;
			if(PlayerInfo[p][power]) SendDeathMessageToPlayer(p, killerid, playerid, reason);
		}

	    if(PlayerInfo[playerid][playerlvl] >= 3)
	    {
		    if(IsPlayerFED(killerid))
			{
				GivePlayerMoneyEx(playerid, -10000);
				SendClientMessage(playerid, COLOR_HELPEROOC, "=======================================================================================");
				SendClientMessage(playerid, COLOR_HELPEROOC, " ");
				SendClientMessage(playerid, COLOR_WHITE,"FINED: -$10.000 for resisting arrest.");
				SendClientMessage(playerid, COLOR_HELPEROOC, " ");
				SendClientMessage(playerid, COLOR_HELPEROOC, "=======================================================================================");
				FactionLoop(f)
				{
					if(FactionInfo[f][fActive] != true)
					if(FactionInfo[f][fType] == FAC_TYPE_GOV || FactionInfo[f][fType] == FAC_TYPE_POLICE)
					{
						new iReason[228];
						format(iReason, sizeof(iReason), "[F-BANK] %s was finded for resisting arrest. Previous Balance: $%s | New Balance: $%s.", RPName(playerid), number_format(FactionInfo[f][fBank]), number_format(FactionInfo[f][fBank] + 5000));
						FactionLog(f, iReason, FACTION_LOG_TIER_1);
						FactionInfo[f][fBank] += 5000;
					}
				}
				new stringa[ 128 ];
				format(stringa, sizeof(stringa), "Severely wounded by PD/SASF %s %s for resisting arrest", PlayerInfo[killerid][rankname], PlayerName(killerid));
				PoliceDB(playerid, stringa);
			}
		}
		if(IsPlayerInWar(playerid) && IsPlayerInWar(killerid)) UpdateWar(playerid, killerid);
		new string[ MAX_STRING ], wname[ 40 ];
		GetWeaponName(reason, wname, sizeof(wname));
	    format( string, sizeof(string), "5..: [DEATH] %s[%d] has been killed by %s[%d] (%s) :..",PlayerName(playerid),playerid, PlayerName(killerid), killerid,wname);
		iEcho( string );
		new iReason[228];
		format(iReason, sizeof(iReason), "%s", wname);
		DeathLog(playerid, killerid, iReason);
	}
	else
	{
	    new string[ 128 ];
		format( string, sizeof(string), "5..: [DEATH] %s[%d] has suicided :..",PlayerName(playerid),playerid);
		iEcho( string );
		format( string, sizeof(string), "[KILL] %s has killed himself", PlayerName(playerid));
		AppendTo(deathlog, string);
	}
	if(PlayerInfo[playerid][playerlvl] >= 3) PlayerTemp[playerid][gettingTreatmentFromHospital] = true;
 	return 1;
}

public OnPlayerSpawn(playerid)
{
	if (PlayerTemp[playerid][loggedIn])
	{
		StopAudioStreamForPlayer(playerid);
		if(!PlayerTemp[playerid][gPlayerAnimLibsPreloaded])
		{
			PreloadAnimLib(playerid,"BOMBER");
			PreloadAnimLib(playerid,"RAPPING");
			PreloadAnimLib(playerid,"SHOP");
			PreloadAnimLib(playerid,"BEACH");
			PreloadAnimLib(playerid,"SMOKING");
			PreloadAnimLib(playerid,"FOOD");
			PreloadAnimLib(playerid,"ON_LOOKERS");
			PreloadAnimLib(playerid,"DEALER");
			PreloadAnimLib(playerid,"CRACK");
			PreloadAnimLib(playerid,"CARRY");
			PreloadAnimLib(playerid,"COP_AMBIENT");
			PreloadAnimLib(playerid,"PARK");
			PreloadAnimLib(playerid,"INT_HOUSE");
			PreloadAnimLib(playerid,"FOOD");
			PreloadAnimLib(playerid,"PED");
			PlayerTemp[playerid][gPlayerAnimLibsPreloaded] = 1;
		}
		SetTimerEx("JustSpawned", 500, false, "d", playerid);
		
	    StopPlayerHoldingObjectEx(playerid);
		
		DeletePVar(playerid, "BriefCaseTill");
		DeletePVar(playerid, "Tazer");
		SetPVarInt(playerid, "GarageID", -1);
		
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][plrwarning]);
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][jailtd]);
		TextDrawHideForPlayer(playerid, PlayerTemp[playerid][InfoBox]);
	    TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Harvest]);
	    TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Cargo]);
	    TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Status]);
	    TextDrawShowForPlayer(playerid, PlayerTemp[playerid][LocationTD]);
    	TextDrawShowForPlayer(playerid, TextDraw__News);
    	TextDrawShowForPlayer(playerid, IMtxt);
    	TextDrawHideForPlayer(playerid, TellTD);
		TextDrawHideForPlayer(playerid, InjuredTD);
		
		PlayerTemp[playerid][HasRedScreen] = 0;
	    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 1);
	    if(PlayerTemp[playerid][adminduty])
	    {
	        SendClientMessage(playerid, COLOR_LIGHTGREY, " Info: You are still on adminduty! You cannot roleplay!");
	        SetTimerEx("AdminDutyFunction", 1200, false, "d", playerid);
	    }
 	    if(PlayerTemp[playerid][helperduty])
	    {
	        SendClientMessage(playerid, COLOR_LIGHTGREY, " Info: You are still on helperduty! You cannot roleplay!");
	        SetTimerEx("AdminDutyFunction", 1200, false, "d", playerid);
	    }
		
	    SetPlayerArmour(playerid, 0.0);
		SetPlayerHealth(playerid, 100);
		new Float:px, Float:py, Float:pz;
		GetPlayerPos(playerid,px,py,pz);
		PlayerPlaySound(playerid,SOUND_GOGO_TRACK_STOP,px,py,pz);
		
		for(new q; q < MAX_GANGZONES; q++)
		{
		    TextDrawHideForPlayer(playerid, Gangzones[q][gDRAW]);
			if(!IsPlayerFED(playerid))
		    {
				GangZoneShowForPlayer(playerid, Gangzones[q][gID], GetFactionTurfColour(Gangzones[q][gFACTION]));
				if(Gangzones[q][gBLINK] == 1)
					GangZoneFlashForPlayer(playerid, Gangzones[q][gID], COLOR_WHITE);
			}
		}
 		if(PlayerInfo[playerid][jailtime] > 1 || PlayerInfo[playerid][jail])
	 	{
	 	    PlayerTemp[playerid][imprisoned] = 1;
		    Jail(playerid,PlayerInfo[playerid][jailtime], PlayerInfo[playerid][bail], PlayerInfo[playerid][jailreason]);
		    return 1;
		}
		if(IsPlayerInPaintball(playerid))
		{
			SetPlayerPaintBall(playerid, PlayerTemp[playerid][onpaint], PlayerTemp[playerid][pbteam]);
			return 1;
		}
		DefaultSpawn(playerid);
	}
	else
	{
		SetPlayerCameraPos(playerid, -1980.7375,-2404.8035,30.6250);
		SetPlayerPos(playerid, 1416.13232, -806.92108, 85.97500);
		SetPlayerCameraLookAt(playerid, 1514.0645, -955.6357, 106.4819);
		
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 1);
		SetPlayerColor(playerid, COLOR_RED);
		TogglePlayerControllable(playerid, false);
		return 1;
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
	PlayerTemp[playerid][pAFK] = 0;
	if(IsPlayerHoldingAnyObject(playerid)) SetPlayerArmedWeapon(playerid, 0);
	PlayerTemp[playerid][pupdates]++;
	if(PlayerTemp[playerid][pupdates] > UPDATE_COUNT && PlayerInfo[playerid][power] == 0)
	{
	    PlayerTemp[playerid][pupdates] = 0;
	    new check;
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsVehicleValid(GetPlayerVehicleID(playerid)))
		{
			new Float:vx,Float:vy,Float:vz;
			GetVehicleVelocity(GetPlayerVehicleID(playerid),vx,vy,vz);
			if(vx==0.0 && vy==0.0 && vz < -0.0032 && vz > -0.022)
			{
				if(IsPlayerInWater(playerid)==0) check=1;
			 	else check=3;
			}
		}
		else
		{
		    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		    {
				new Float:vx,Float:vy,Float:vz,Float:px,Float:py,Float:pz;
				GetVehicleVelocity(GetPlayerVehicleID(playerid),vx,vy,vz);
				GetPlayerVelocity(playerid,vx,vy,vz);
				GetPlayerPos(playerid,px,py,pz);
			    PlayerTemp[playerid][pupdates] = 0;
			    if(-0.022 < vz < -0.0040 && -0.121 < vx < 0.121 && -0.121 < vy < 0.121 && GetPlayerSurfingVehicleID(playerid)==INVALID_VEHICLE_ID)
			    {
			        if(!IsPlayerInRangeOfPoint(playerid,2.0,GetPVarFloat(playerid,"oposx"),GetPVarFloat(playerid,"oposy"),GetPVarFloat(playerid,"oposz")) || -0.5>(GetPVarFloat(playerid,"oposz")-pz)>-0.1 || 0.075>(GetPVarFloat(playerid,"oposz")-pz)>-0.075)
      				{
						if(IsPlayerInWater(playerid)==0) check=2;
						else check=3;
			        }
			        SetPVarFloat(playerid,"oposx",px);
			        SetPVarFloat(playerid,"oposy",py);
			        SetPVarFloat(playerid,"oposz",pz);
			    }
		    }
		}
		if(check > 0)
		{
			if(check < 3)
			{
			    new POSSIBLE_AIRBREAK_COUNT;
				switch(check)
	 			{
		 			case 1: POSSIBLE_AIRBREAK_COUNT=POSSIBLE_AIRBREAK_COUNT_CAR;
			 		case 2: POSSIBLE_AIRBREAK_COUNT=POSSIBLE_AIRBREAK_COUNT_ONFOOT;
		 		}
				PlayerTemp[playerid][airbreakcount]++;
				if(PlayerTemp[playerid][airbreakcount] > POSSIBLE_AIRBREAK_COUNT)
				{
					PlayerTemp[playerid][airbreakcount] = 0;
					new messaggio[ 192 ];
					format(messaggio,sizeof(messaggio),"..: ADMIN has IP banned %s. Reason: Cheating [Code #004] %s :..",PlayerName(playerid),TimeDate());
					SendClientMessageToAll(COLOR_RED,messaggio);
					format( messaggio, sizeof(messaggio), "4{ IP-BAN } ADMIN has IP banned %s (IP: %s). Reason: Cheating [Code #004] %s",PlayerName(playerid), PlayerTemp[playerid][IP], TimeDate());
					iEcho(messaggio);
					PlayerInfo[playerid][banned]=1;
					BanEx(playerid, "[ANTICHEAT] AIRBREAK");
				}
			}
		}
		else PlayerTemp[playerid][airbreakcount] = 0;
	}
	if(IsPlayerConnected(playerid))
	{
		if(CheckPlayerWeaponSpawn(playerid) == true)
		{
			new iFormat[128];
			format(iFormat, sizeof(iFormat), "%s(%d) possible weapon spawn!", PlayerName(playerid), playerid);
			AdminNotice(iFormat);
			ResetPlayerWeaponsEx(playerid);
		}
	    if(GetPVarInt(playerid, "Tazer") && GetPlayerWeapon(playerid) != 23)
	    {
	        SendClientInfo(playerid, "You cannot hold a weapon while having the taser in your hand.");
	        SetPlayerArmedWeapon(playerid, WEAPON_SILENCED);
	    }
	    if(IsPlayerInAnyVehicle(playerid))
	    {
		    for(new i; i < sizeof(Spikes); i++)
		    {
		        if(IsPlayerInRangeOfPoint(playerid, 5.0, Spikes[i][sX], Spikes[i][sY], Spikes[i][sZ]) && Spikes[i][sX] != 0)
		        {
		            new tires, panels, doors, lights;
		            GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
		            tires = encode_tires(1,1,1,1); // damage all tires
		            UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
		        }
		    }
	    }
	}
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && !IsPlayerAdmin(playerid) && PlayerInfo[playerid][power] < 1)
	{
		new iFormat[128];
		format(iFormat, sizeof(iFormat), "%s(%d) possible jetpack hack.");
		AdminNotice(iFormat);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if(GetTickCount() - PlayerTemp[playerid][cmdtick] < 500 && !PlayerInfo[playerid][power]) return SendClientError(playerid, "Commands can only be performed every 0.5 seconds!"), 0;
	PlayerTemp[playerid][cmdtick] = GetTickCount();
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: Command not found! Use /commands.");
	if(!PlayerTemp[playerid][loggedIn]) return SendClientError(playerid, "You are not logged in!");
	
	new commandFile[156], d, m, y; getdate(y, m, d);
	format(commandFile, sizeof(commandFile), "Command-logs/Command-logs-%02d-%02d-%d.log", d, m, y);
	new File:cmdlog = fopen(commandFile, io_append); 
	format(commandFile, sizeof(commandFile), "%s : %s, %s\r\n", TimeDate(), PlayerName(playerid), cmdtext);
	fwrite(cmdlog, commandFile);
	fclose(cmdlog);	
	
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i) && PlayerTemp[i][admincmdspy] == 1)
	    {
	        format(iStr, sizeof(iStr), "[ CMD ] %s[%d]: %s", PlayerName(playerid), playerid, cmdtext);
	        SendClientMessage(i, COLOR_ORANGE, iStr);
	    }
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	PlayerLoop(p)
	{
		if(BoomBoxInfo[p][boomActive] != true) continue;
		if(areaid == BoomBoxInfo[p][boomArea])
		{
			StopAudioStreamForPlayer(p);
			SendClientMessage(playerid, 0x5C8A8AFF, "[Boombox] You have left the boombox area.");
		}
	}
	HideInfoBox(playerid);
  	return 1;
}

public HoldPhone(playerid)
{
	if(IsPlayerConnected(playerid)) SetPlayerSpecialAction(playerid, 13);
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(PlayerInfo[playerid][power])
    {
    	SetPlayerPosFindZ(playerid, fX, fY, fZ);
   	    //return 1;
	}
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnRconLoginAttempt( ip[], password[], success )
{
	new playerip[31], pName[MAX_PLAYER_NAME], iFormat[128], playerid;
	PlayerLoop(p)
	{
		GetPlayerIp(p, playerip, sizeof(playerip));
		if(strcmp(playerip, ip, true) == 0)
		{
			myStrcpy(pName, PlayerName(p));
			playerid = p;
			break;
		}
	}
	if(success)
	{
		format(iFormat, sizeof(iFormat), "Successfully logged in to RCON.");
		SecurityLog(playerid, iFormat);
	}
	else
	{
		format(iFormat, sizeof(iFormat), "Attempted to login in to RCON but failed. (%s)", password);
		SecurityLog(playerid, iFormat);
	}
	return 1;
}

public RealTimeUpdate()
{
	new h=0, m=0, sec=0;
	gettime(h,m,sec);
	SetWorldTime(h);
	SetTimer("RealTimeUpdate",30000,0);
	return 1;
}

public ToKick(playerid)
{
 	Kick(playerid);
	return 1;
}

public ToBan(playerid, reason[])
{
	BanEx(playerid, reason);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PlayerTemp[playerid][GYM_CURDONE] > 0)
	{
	    if(newkeys & PlayerTemp[playerid][GYM_CURKEY] && PlayerTemp[playerid][GYM_CURDONE])
	    {
	        PlayerTemp[playerid][GYM_CURDONE]++;
	        if(PlayerTemp[playerid][GYM_CURDONE] >= 55)
	        {
	            if(GetPVarInt(playerid, "TrainingFor") == 0) SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
	            if(GetPVarInt(playerid, "TrainingFor") == 1) SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
	            if(GetPVarInt(playerid, "TrainingFor") == 2) SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
	            if(GetPVarInt(playerid, "TrainingFor") == 3) SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
	            SetPlayerPosEx(playerid, 758.3981,-68.1611,1000.8479, 7, 1338);
	            SetCameraBehindPlayer(playerid);
	            PlayerTemp[playerid][GYM_CURDONE] = 0;
	            PlayerTemp[playerid][GYM_CURKEY] = 0;
	            PlayerTemp[playerid][fightstyleleft] = 3;
	            TogglePlayerControllable(playerid, true);
				ShowDialog(playerid, DIALOG_NO_RESPONSE, 0);
	            treadmillBUSY = -1;
	            GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~done", 5000, 4);
	            return 1;
	        }
	        ApplyAnimation(playerid,"GYMNASIUM","gym_tread_sprint", 4.1, 1, 1, 1, 1, 0, 1);
			new lol = minrand(1,4);
			if(lol == 1)
			{
			    PlayerTemp[playerid][GYM_CURKEY] = KEY_SPRINT;
			    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~~k~~PED_SPRINT~", 10000, 4);
			}
			else if(lol == 2)
			{
			    PlayerTemp[playerid][GYM_CURKEY] = KEY_JUMP;
			    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~~k~~PED_JUMPING~", 10000, 4);
			}
			else
			{
			    PlayerTemp[playerid][GYM_CURKEY] = KEY_WALK;
			    GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~~k~~SNEAK_ABOUT~", 10000, 4);
			}
		}
	}
	if(IsKeyJustDown(KEY_ACTION,newkeys,oldkeys) && PlayerTemp[playerid][gPlayerUsingLoopingAnim])
	{
	    StopLoopingAnim(playerid);
        TextDrawHideForPlayer(playerid,txtAnimHelper);
        PlayerTemp[playerid][animation] = 0;
    }
    if(IsBugWeapon(playerid) && RELEASED(KEY_FIRE))
	{
 		PlayerTemp[playerid][PlayerUsingBug] = 1;
		PlayerTemp[playerid][PlayerBugTimer] = SetTimerEx("BugTimeOut",700,0,"i",playerid);
	}
	if(PlayerTemp[playerid][PlayerUsingBug] ==1 && newkeys != KEY_FIRE && newkeys & KEY_CROUCH && PlayerInfo[playerid][allowCBug] != 1)
	{
		ApplyAnimation(playerid,"PED","getup",4.1,0,0,0,0,0);
	 	PlayerTemp[playerid][PlayerUsingBug] = 0;
		KillTimer(PlayerTemp[playerid][PlayerBugTimer]);
		new mestr[128];
		format(mestr,sizeof(mestr)," %s(%d) has attempted to C-Bug!", PlayerName(playerid), playerid);
		AdminNotice(mestr);
		iEcho(mestr);
	}
	if (newkeys & KEY_YES && IsPlayerDriver(playerid))
	{
		new EngineStatus, lights, alarm, doors, bonnet, boot, objective;
		new vid = GetPlayerVehicleID(playerid);
		new Float:tmph;
		new string[ 128 ];
		GetVehicleHealth(vid, tmph);
		GetVehicleParamsEx(vid,EngineStatus,lights,alarm,doors,bonnet,boot,objective);
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 510){}
		else{
			if(vid != INVALID_VEHICLE_ID && EngineStatus== 0 && tmph > 310)
			{
				SetVehicleParamsEx(vid, 1, 1, alarm, doors, bonnet, boot, objective); //engine lights started
				format(string, sizeof(string), "* %s turns the engine of their %s on.", MaskedName(playerid), GetVehicleName(GetPlayerVehicleID(playerid)));
				ProxDetectorEx(30.0, playerid, string, COLOR_ME);
			}
			else if(vid != INVALID_VEHICLE_ID && EngineStatus== 1)
			{
				SetVehicleParamsEx(vid, 0, 0, alarm, doors, bonnet, boot, objective); //engine lights stopped
				format(string, sizeof(string), "* %s turns the vehicles engine off.", MaskedName(playerid));
				ProxDetectorEx(30.0, playerid, string, COLOR_ME);
			}
		}
	}
	/********************************************************************************************************************************
					[WAREHOUSE SYSTEM]:
	********************************************************************************************************************************/
	if(newkeys & KEY_YES && !IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][playerteam] != CIV && !IsPlayerFED(playerid)) // take from refinary / vehicle!
	{
		new carid = GetPlayerNearestVehicle(playerid);
		new vehicleid = FindVehicleID(carid);
	    new model = GetVehicleModel(carid);
		if(IsPlayerInRangeOfPoint(playerid, 3.0, 679.9108, 826.1727, -38.9921)) // getting metal - quarry
		{
			if(GetPVarInt(playerid, "TakingFromMetal") != 0) return SendClientError(playerid, "You're already carrying metal.");
			if(GetPVarInt(playerid, "TakingFromLead") != 0) return SendClientError(playerid, "You cannot carry metal and lead at the same time.");
			SetPVarInt(playerid, "TakingFromMetal", 1);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			SendClientMessage(playerid, COLOR_LIGHTGREY, "* You are currently carrying a crate with 25 metal pieces.");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.0, -1521.0822, 117.2174, 17.3281)) // getting lead - ship
		{
			if(GetPVarInt(playerid, "TakingFromMetal") != 0) return SendClientError(playerid, "You cannot carry metal and lead at the same time.");
			if(GetPVarInt(playerid, "TakingFromLead") != 0) return SendClientError(playerid, "You're already carrying lead.");
			SetPVarInt(playerid, "TakingFromLead", 1);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			SendClientMessage(playerid, COLOR_LIGHTGREY, "* You are currently carrying a crate with 25 lead pieces.");
		}
		else if(GetDistanceFromPlayerToVehicle(playerid, vehicleid) < 5.1) // take from vehicle
		{
			if(model == 591 || model == 435 && VehicleInfo[vehicleid][vReserved] == VEH_TYPE_WH_TRAILER) // making sure it's made for warehouses...
			{
				if(GetPVarInt(playerid, "TakingFromMetal") == 0 && GetPVarInt(playerid, "TakingFromLead") == 0 && GetPVarInt(playerid, "StoringLeadToWareHouse") == 0 && GetPVarInt(playerid, "StoringMetalToWareHouse") == 0)
				{
					if(VehicleInfo[vehicleid][vWHMetal] != 0 && VehicleInfo[vehicleid][vWHLead] == 0) // vehicle has metal
					{
						SetPVarInt(playerid, "StoringMetalToWareHouse", 1);
						VehicleInfo[vehicleid][vWHMetal] -= 25;
						Action(playerid, "takes a crate of metal from the back of the trailer.");
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
					}
					else if(VehicleInfo[vehicleid][vWHLead] != 0 && VehicleInfo[vehicleid][vWHMetal] == 0) // vehicle has lead
					{
						SetPVarInt(playerid, "StoringLeadToWareHouse", 1);
						VehicleInfo[vehicleid][vWHLead] -= 25;
						Action(playerid, "takes a crate of lead from the back of the trailer.");
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
					}
				}
			}
		}
	}
	if(newkeys & KEY_NO && !IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][playerteam] != CIV && !IsPlayerFED(playerid))
	{
	    new carid = GetPlayerNearestVehicle(playerid);
		new vehicleid = FindVehicleID(carid);
	    new model = GetVehicleModel(carid);
		if(GetDistanceFromPlayerToVehicle(playerid, carid) < 5.1) // load / metal lead to the vehicle!
		{
			if(model == 591 || model == 435 && VehicleInfo[vehicleid][vReserved] == VEH_TYPE_WH_TRAILER) // let's make sure it's able to load...
			{
				if(GetPVarInt(playerid, "TakingFromLead") == 1 || GetPVarInt(playerid, "StoringLeadToWareHouse") == 1) // store lead to vehicle
				{
					if(VehicleInfo[vehicleid][vWHMetal] != 0) return SendClientError(playerid, "You cannot store both metal and lead inside this trailer.");
					if(VehicleInfo[vehicleid][vWHLead] >= 100000) return SendClientError(playerid, "This trailer cannot hold more than 100,000 lead pieces.");
					DeletePVar(playerid, "TakingFromLead");
					DeletePVar(playerid, "StoringLeadToWareHouse");
					VehicleInfo[vehicleid][vWHLead] += 25;
					SendClientMessage(playerid, COLOR_LIGHTGREY, "* You have stored 25 lead pieces in to this vehicle.");
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				}
				else if(GetPVarInt(playerid, "TakingFromMetal") == 1 || GetPVarInt(playerid, "StoringMetalToWareHouse") == 1) // store metal to vehicle
				{
					if(VehicleInfo[vehicleid][vWHLead] != 0) return SendClientError(playerid, "You cannot store both metal and lead inside this trailer.");
					if(VehicleInfo[vehicleid][vWHMetal] >= 100000) return SendClientError(playerid, "This trailer cannot hold more than 100,000 metal pieces.");
					DeletePVar(playerid, "TakingFromMetal");
					DeletePVar(playerid, "StoringMetalToWareHouse");
					VehicleInfo[vehicleid][vWHMetal] += 25;
					SendClientMessage(playerid, COLOR_LIGHTGREY, "* You have stored 25 metal pieces in to this vehicle.");
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				}
			}
		}
		else if(IsPlayerOutWarehouse(playerid) != -1) // warehouse load
		{
			new whID = IsPlayerOutWarehouse(playerid);
			if(GetPVarInt(playerid, "TakingFromLead") == 1 || GetPVarInt(playerid, "StoringLeadToWareHouse") == 1) // store lead to warehouse
			{
				if(WareHouseInfo[whID][whOpen] == false) return SendClientError(playerid, "This warehouse is currently locked.");
				SendClientMessage(playerid, COLOR_LIGHTGREY, "* You have deposited 25 lead pieces in to the warehouse.");
				DeletePVar(playerid, "TakingFromLead");
				DeletePVar(playerid, "StoringLeadToWareHouse");
				WareHouseInfo[whID][whLead] += 25;
				ReloadFaction(whID, true);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
			else if(GetPVarInt(playerid, "TakingFromMetal") == 1 || GetPVarInt(playerid, "StoringMetalToWareHouse") == 1) // store metal to warehouse
			{
				if(WareHouseInfo[whID][whOpen] == false) return SendClientError(playerid, "This warehouse is currently locked.");
				SendClientMessage(playerid, COLOR_LIGHTGREY, "* You have deposited 25 metal pieces in to the warehouse.");
				DeletePVar(playerid, "TakingFromMetal");
				DeletePVar(playerid, "StoringMetalToWareHouse");
				WareHouseInfo[whID][whMetal] += 25;
				ReloadFaction(whID, true);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
		}
	}
	/********************************************************************************************************************************
					[WAREHOUSE SYSTEM END]:
	********************************************************************************************************************************/
	if(newkeys & 16 && !IsPlayerInAnyVehicle(playerid))
	{
		if(PlayerTemp[playerid][key_enter] == 2)
		{
			CheckExit(playerid);
			CheckEnter(playerid);
		}
	}
    if(newkeys & KEY_FIRE)
	{
	    HideInfoBox(playerid);
	    if(IsInPeaceZone(playerid) && !IsPlayerInAnyVehicle(playerid))
	    {
	        TDWarning(playerid, "do not fight in this zone!", 2000);
	        SetPlayerArmedWeapon(playerid, 0);
	        Up(playerid);
	    }
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerTemp[playerid][spectatingID] != INVALID_PLAYER_ID)
	{
		if(newkeys == KEY_JUMP)
			AdvanceSpectate(playerid);
		else if(newkeys == KEY_SPRINT)
	    	ReverseSpectate(playerid);
	}
	if(newkeys & KEY_FIRE && newkeys & KEY_HANDBRAKE)
	{
	    if(!IsPlayerInAnyVehicle(playerid) && GetPlayerWeapon(playerid) == 41)
	    {
	        new Float:fp[4];
	        PlayerLoop(q)
			{
				if(q == playerid) continue;
				GetPlayerPos(q, fp[0], fp[1], fp[2]);
				if(IsPlayerAimingAt(playerid, fp[0], fp[1], fp[2], 0.9) && GetDistanceBetweenPlayers(playerid, q) < 4 && PlayerTemp[q][tazed] == 0)
				{
				    RedScreen(q, minrand(5,15));
					return 1;
				}
			}
	    }
		return 1;
 	}
 	if ((newkeys==KEY_ACTION)&&(IsPlayerInAnyVehicle(playerid))&&(GetPlayerState(playerid)==PLAYER_STATE_DRIVER) && GetVehicleModel(GetPlayerVehicleID(playerid)) == 525)
    {
		new Float:pX,Float:pY,Float:pZ, Float:vehX,Float:vehY,Float:vehZ, Found = 0, vid = 1;
		GetPlayerPos(playerid,pX,pY,pZ);
		while((vid < MAX_CREATED_VEHICLES) && (!Found))
		{
  			vid++;
   			GetVehiclePos(vid,vehX,vehY,vehZ);
   			if( (floatabs(pX - vehX) < 7.0) && (floatabs(pY - vehY) < 7.0) && (floatabs(pZ - vehZ) < 7.0) && (vid != GetPlayerVehicleID(playerid)))
   		    {
   			    Found=1;
   			    if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			   	{
				   	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
				}
   			    else AttachTrailerToVehicle(vid, GetPlayerVehicleID(playerid));
			}
		}
		if (!Found) SendClientError(playerid, " Unable to tow any vehicle.");
	}
	return 1;
}

public PayDay()
{
	new ore,minuti,secondi;
	gettime(ore,minuti,secondi);
	if((minuti==0 || minuti==1) && paycheck==0)
	{
	    paycheck=1;
		BusinessLoop(b)
		{
		    if(BusinessInfo[b][bActive] != true) continue;
		    if(BusinessInfo[b][bLastRob] > 0) BusinessInfo[b][bLastRob]--;
		    new businessType = BusinessInfo[b][bType];
		    new incomeHourly = 8000;
		    if(businessType == BUSINESS_TYPE_BANK) continue;

			if(businessType == BUSINESS_TYPE_247
			|| businessType == BUSINESS_TYPE_CLOTHES) incomeHourly = 12500;
			if(businessType == BUSINESS_TYPE_HARDWARE) incomeHourly = 13500;
			if(businessType == BUSINESS_TYPE_CLUB
			|| businessType == BUSINESS_TYPE_PUB
			|| businessType == BUSINESS_TYPE_STRIPCLUB
			|| businessType == BUSINESS_TYPE_RESTAURANT
			|| businessType == BUSINESS_TYPE_PIZZA
			|| businessType == BUSINESS_TYPE_BURGER
			|| businessType == BUSINESS_TYPE_CHICKEN
			|| businessType == BUSINESS_TYPE_CAFE) incomeHourly = 11500;
		    if(businessType == BUSINESS_TYPE_CASINO) incomeHourly = 23000;
		    if(businessType == BUSINESS_TYPE_GAS) incomeHourly = 14500;
		    if(businessType == BUSINESS_TYPE_BIKE_DEALER
		    || businessType == BUSINESS_TYPE_HEAVY_DEALER
		    || businessType == BUSINESS_TYPE_CAR_DEALER
		    || businessType == BUSINESS_TYPE_LUXUS_DEALER
		    || businessType == BUSINESS_TYPE_NOOB_DEALER
		    || businessType == BUSINESS_TYPE_AIR_DEALER
			|| businessType == BUSINESS_TYPE_BOAT_DEALER
			|| businessType == BUSINESS_TYPE_JOB_DEALER) incomeHourly = 14000;
		    if(BusinessInfo[b][bLocked] == true) incomeHourly = (incomeHourly / 10);
		    BusinessInfo[b][bTill] += incomeHourly;
		    SaveBusiness(b);
		}
		new tax = dini_Int(globalstats,"tax");
		FactionLoop(f)
		{
			if(FactionInfo[f][fActive] != true) continue;
			if(FactionInfo[f][fBank] != -1 && FactionInfo[f][fBank] < 75000000)
			{
				new iReason[228];
				format(iReason, sizeof(iReason), "[F-BANK] Recieved $%s for bank interests. Previous Balance: $%s | New Balance: $%s.", number_format(FactionInfo[f][fBank] / 100), number_format(FactionInfo[f][fBank]), number_format(FactionInfo[f][fBank] + (FactionInfo[f][fBank] / 100)));
				FactionLog(f, iReason, FACTION_LOG_TIER_0);
				FactionInfo[f][fBank] += FactionInfo[f][fBank]/100;
			}
		}
		new gov_TaxIncome[MAX_FACTIONS], faction_PayCheckOutcome[MAX_FACTIONS];
		
		PlayerLoop(i)
		{
			if(PlayerTemp[i][loggedIn])
			{
				if(PlayerInfo[i][playertime] >= 6000)
				{

					if(PlayerInfo[i][playerteam] != CIV)
					{
						new f = PlayerInfo[i][playerteam];
						if(FactionInfo[f][fBank] >= PlayerInfo[i][fpay])
						{
							FactionInfo[f][fBank] -= PlayerInfo[i][fpay];
							faction_PayCheckOutcome[f] += PlayerInfo[i][fpay];
						}
					}
					PlayerInfo[i][rpoints]++;

					if((PlayerInfo[i][rpoints]/2)>=PlayerInfo[i][playerlvl] && PlayerInfo[i][playerlvl]>8)
					{
					  	PlayerInfo[i][playerlvl]++;
					  	PlayerInfo[i][rpoints]=0;
					  	SetPlayerScore(i,PlayerInfo[i][playerlvl]);
					  	MessagePayDay(i, PlayerInfo[i][rpoints], PlayerInfo[i][playerlvl], PlayerInfo[i][rentprice], PlayerInfo[i][playertime], PlayerInfo[i][fpay]);
					  	//MessagePayDay(i);
						SendClientMessage(i,COLOR_GREEN,"[PayTime] You have levelled up!");
					}

					if(PlayerInfo[i][rpoints] >= 9 && PlayerInfo[i][playerlvl] <= 8)
					{
					  	PlayerInfo[i][playerlvl]++;
					  	PlayerInfo[i][rpoints]=0;
					  	SetPlayerScore(i,PlayerInfo[i][playerlvl]);
					  	MessagePayDay(i,PlayerInfo[i][rpoints],PlayerInfo[i][playerlvl],PlayerInfo[i][rentprice],PlayerInfo[i][playertime], PlayerInfo[i][fpay]);
					  	//MessagePayDay(i);
			          	SendClientMessage(i,COLOR_GREEN,"[PayTime] You have levelled up!");
					}

					else
					{
					    if(PlayerInfo[i][bank] < 750000000) PlayerInfo[i][bank]=PlayerInfo[i][bank]+(PlayerInfo[i][bank]/500);
						else PlayerInfo[i][bank] = PlayerInfo[i][bank]+(750000000/500);
					    MessagePayDay(i,PlayerInfo[i][rpoints],PlayerInfo[i][playerlvl],PlayerInfo[i][rentprice],PlayerInfo[i][playertime], PlayerInfo[i][fpay]);
					  	//MessagePayDay(i);
					}

					FactionLoop(f)
					{
						if(FactionInfo[f][fActive] != true) continue;
						if(FactionInfo[f][fType] != FAC_TYPE_GOV) continue;
						FactionInfo[f][fBank] += tax;
						gov_TaxIncome[f] += tax;
					}
					new totalpt = PlayerInfo[i][playertime] + PlayerInfo[i][fpay] - PlayerInfo[i][rentprice] - tax;
			    	GivePlayerMoneyEx(i,totalpt);
			    	if(PlayerInfo[i][housenum] != -1 && PlayerInfo[i][rentprice] > 0)
					{
						new houseid = PlayerInfo[i][housenum];
						HouseInfo[houseid][hTill] += PlayerInfo[i][rentprice];
						SaveHouse(houseid);
			    	}
			   		GameTextForPlayer(i,"~w~Pay~p~Time",3000,1);
					PlayerInfo[i][playertime]=0;
					PlayerInfo[i][totalpayt]++;
				}
				else SendClientMessage(i,COLOR_ORANGE,"[PayTime] You haven't played long enough for PayTime");
			}
			else SendClientMessage(i,COLOR_YELLOW,"[SERVER] You are not authed, no PayDay.");
		}
		FactionLoop(f)
		{
			if(FactionInfo[f][fActive] != true) continue;
			new iReason[228];
			if(faction_PayCheckOutcome[f] != 0)
			{
				format(iReason, sizeof(iReason), "[F-BANK] Paychecks handed out. Previous Balance: $%s | New Balance: $%s.", number_format(FactionInfo[f][fBank] - faction_PayCheckOutcome[f]), number_format(FactionInfo[f][fBank]));
				FactionLog(f, iReason, FACTION_LOG_TIER_0);
			}
			if(FactionInfo[f][fType] == FAC_TYPE_GOV)
			{
				if(gov_TaxIncome[f] != 0)
				{
					format(iReason, sizeof(iReason), "[F-BANK] Government tax income: $%s. Previous Balance: $%s | New Balance: $%s.", number_format(gov_TaxIncome[f]), number_format(FactionInfo[f][fBank] - gov_TaxIncome[f]), number_format(FactionInfo[f][fBank]));
					FactionLog(f, iReason, FACTION_LOG_TIER_0);
				}
			}
		}
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(PlayerTemp[playerid][loggedIn])
	{
	    if(GetPVarInt(playerid, "SkinSelect") == 1)
	    {
	        SetPlayerPos(playerid, 204.2521,-158.8996,1001.5491);
	        SetPlayerFacingAngle(playerid, 179.28);
	        SetPlayerInterior(playerid, 14);
	        SetPlayerCameraPos(playerid, 202.5867,-164.1917,1001.7235);
	        SetPlayerCameraLookAt(playerid, 204.2521,-158.8996,1001.5491);
	    }
	    else
	    {
			SetPlayerTeamEx(playerid,PlayerInfo[playerid][playerteam]);
			PlayerTemp[playerid][spawnrdy]=0;
		}
	 }
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new stringa[256];
	new Float:px,Float:py,Float:pz;
	GetPlayerPos(playerid,px,py,pz);
	if(PlayerTemp[playerid][muted]==0)
	{
		// if(GetPVarInt(playerid, "Convo") != INVALID_CONVERSATION && GetPVarBool(playerid, "ConvoMute") != false)
		if(GetPVarInt(playerid, "Convo") != INVALID_CONVERSATION && GetPVarInt(playerid, "ConvoMute") != 1)
		{
			new iFormat[200], iHeader[23];
			format(iHeader, sizeof(iHeader), "[Convo: %d]", GetPVarInt(playerid, "Convo"));
			format(iFormat, sizeof(iFormat), "%s %s: %s", iHeader, RPName(playerid), text);
			PlayerLoop(p)
			{
				if(PlayerTemp[p][loggedIn] != true) continue;
				if(GetPVarInt(p, "Convo") == INVALID_CONVERSATION) continue;
				if(GetPVarInt(p, "Convo") != GetPVarInt(playerid, "Convo")) continue;
				SendPlayerMessage(p, 0xFFFF99FF, iFormat, iHeader);
			}
			return false;
		}
		else if(PlayerTemp[playerid][phone]!=0)
		{
		    if(text[0] == '(')
			{
			    new mid[MAX_STRING];
				strmid(mid, text, 1, 256, sizeof(mid));
				format(stringa,sizeof(stringa),"(( [Phone] %s says: %s ))", RPName(playerid),mid);
			}
			else format(stringa,sizeof(stringa),"[Phone] %s says: %s", MaskedName(playerid), text);
			SendClientMessage(PlayerTemp[playerid][onphone],COLOR_YELLOW,stringa);
		}
		else
		{
			if(text[0]== '(')
			{
				new mid[MAX_STRING];
				strmid(mid,text,1,256,sizeof(mid));
				format(stringa,sizeof(stringa),"%s says: (( %s ))",RPName(playerid),mid);
			}
			else
			{
			    toupper(text[0]);
				format(stringa,sizeof(stringa),"%s says: %s", MaskedName(playerid), text);
				if(PlayerTemp[playerid][chatAnim] == true)
				{
					new AnimTime = strlen(text) * 50;
					ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 0, AnimTime, 1);
				}
			}
		}
		PlayerLoop(i)
		{
			if(!IsPlayerConnected(i)) continue;
			if(!IsPlayerInRangeOfPoint(i, 60.0, px,py,pz)) continue;
			if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid) || GetPlayerInterior(i) != GetPlayerInterior(playerid)) continue;
	    	new Float:dis;
	    	dis = GetDistanceBetweenPlayers(playerid,i);
	    	if(dis>40) SendClientMessage(i,COLOR_PLAYER_DARKGREY,stringa);
			if(dis<=30 && dis >10) SendClientMessage(i,COLOR_PLAYER_GREY,stringa);
			if(dis<=10) SendClientMessage(i,COLOR_PLAYER_WHITE,stringa);
		}
		strdel(stringa,0,strlen(PlayerName(playerid))+7);
		new tmpStr[ 164 ];
		if(text[0]== '(')
		{
			new mid[MAX_STRING];
			strmid(mid,text,1,256,sizeof(mid));
			format(tmpStr, 164, "7%s[%d]: (( %s ))", RPName(playerid), playerid, mid);
			iEcho(tmpStr, IRC_LIVE);
		}
		else
		{
			format(tmpStr, 164, "7%s[%d]: %s", RPName(playerid), playerid, text);
			iEcho(tmpStr ,IRC_LIVE);
		}
		if(stringContainsIP(text))
		{
		    new wat[ 80 ];
		    format(wat, sizeof(wat),"IP Advertisments");
		    SendClientMessageToAll(0xFFFFFFFF, wat);
		    return BanReas("[SERVER]",playerid,wat, 1), false;
		}
	}
	else return SendClientMessage(playerid,COLOR_RED," You are muted!"), 0;
	return 0;
}

public JustSpawned(playerid);
public JustSpawned(playerid)
{
	SetPlayerChatBubble(playerid, "(( JUST SPAWNED ))", COLOR_RED, 45.0, (1000 * 30));
	return 1;
}

public SetPlayerBack(playerid, wat);
public SetPlayerBack(playerid, wat)
{
	if(wat == 1)
	{
		ResetPlayerWeaponsEx(playerid);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, true);
	    SetPlayerPos(playerid, PlayerTemp[playerid][PlayerPosition][0],PlayerTemp[playerid][PlayerPosition][1],PlayerTemp[playerid][PlayerPosition][2]);
		SetPlayerInterior(playerid, PlayerTemp[playerid][PlayerInterior]);
		SetPlayerVirtualWorld(playerid, PlayerTemp[playerid][PlayerVirtualWorld]);
		SetPlayerHealth(playerid, PlayerTemp[playerid][PlayerHealth]);
		SetPlayerArmour(playerid, PlayerTemp[playerid][PlayerArmour]);
		DeletePVar(playerid, "SkinSelect");
		for(new i = 0; i < WEAPON_SLOTS; i++) GivePlayerWeaponEx(playerid, PlayerTemp[playerid][PlayerWeapon][i], PlayerTemp[playerid][PlayerAmmo][i]);
		PlayerInfo[playerid][Skin] = GetPlayerSkin(playerid);
		PlayerTemp[playerid][isCCTV] = 0;
	}
	else
	{
	    new str[128];
	    format(str, sizeof(str), "(( Local: %s[%d] has killed/respawned himself. ))", RPName(playerid), playerid);
		NearMessage(playerid,str,COLOR_LIGHTGREY);
	    SetPlayerHealth(playerid, 0.0);
	    ForceClassSelection(playerid);
	    SpawnPlayer(playerid);
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	for(new x=0; x<MAX_PLAYERS; x++)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerTemp[x][spectatingID] == playerid && PlayerTemp[x][specType] == ADMIN_SPEC_TYPE_VEHICLE)
		{
	        TogglePlayerSpectating(x, 1);
	        PlayerSpectatePlayer(x, playerid);
	        PlayerTemp[x][specType] = ADMIN_SPEC_TYPE_PLAYER;
		}
	}
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(source == CLICK_SOURCE_SCOREBOARD)
	{
		if(PlayerTemp[clickedplayerid][loggedIn] == false) return SendClientError(playerid, "Player hasn't logged in yet.");
		ShowDialog(playerid, DIALOG_NO_RESPONSE, 1, clickedplayerid);
	}
	return 1;
}

public PayCheck()
{
	paycheck=0;
}

public TimeConn()
{
	new Float:healt;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(PlayerTemp[i][loggedIn] && IsPlayerConnected(i) && PlayerInfo[i][jail] == 0)
		{
			GetPlayerHealth(i,healt);
			SetPlayerHealth(i,healt-0.003);
			PlayerInfo[i][playertime] +=200;
		}
	}
	VehicleLoop(v) // owner is offline, vehicle is spawned and owned.
	{
		if(VehicleInfo[v][vActive] != true) continue; // vehicle is created
		if(VehicleInfo[v][vSpawned] != true) continue; // vehicle is spawned
		if(!strcmp(VehicleInfo[v][vOwner], "NoBodY", false)) continue; // vehicle is owned
		if(IsPlayerConnected(GetPlayerId(VehicleInfo[v][vOwner]))) continue; // vehicle owner is offline
		if(IsVehicleOccupied(GetCarID(v))) continue; // vehicle is not occupied
	  	DestroyVehicle(GetCarID(v));
  		VehicleInfo[v][vSpawned] = false;
  		VehicleInfo[v][vRID] = INVALID_VEHICLE_ID;
  		VehicleInfo[v][vID] = INVALID_VEHICLE_ID;
	}
	return 1;
}

public UpdateZone()
{
	PlayerLoop(i)
	{
	    if(!PlayerTemp[i][loggedIn]) continue;
	    if(GetPlayerState(i) != PLAYER_STATE_WASTED)
	    {
	        if(!GetPlayerVirtualWorld(i))
	        {
		        new iZone[ 40 ], Float:pPos[3];
		        GetPlayerPos(i, pPos[0], pPos[1], pPos[2]);
		        GetZone(pPos[0], pPos[1], pPos[2], iZone);
		        TextDrawSetString(PlayerTemp[i][LocationTD], iZone);
				TextDrawShowForPlayer(i, PlayerTemp[i][LocationTD]);
			}
			else
			{
				if(PlayerTemp[i][tmphouse] != -1)
				{
					new iZone[ 112 ], houseid = PlayerTemp[i][tmphouse];
					GetZone(HouseInfo[houseid][hX], HouseInfo[houseid][hY], HouseInfo[houseid][hZ], iZone);
					format(iZone, sizeof(iZone), "~y~%d, %s", houseid, iZone);
					TextDrawSetString(PlayerTemp[i][LocationTD], iZone);
					TextDrawShowForPlayer(i, PlayerTemp[i][LocationTD]);
				}
				else if(PlayerTemp[i][tmpbiz] != -1)
				{
					new iZone[ 112 ], iBizID = PlayerTemp[i][tmpbiz];
					GetZone(BusinessInfo[iBizID][bX], BusinessInfo[iBizID][bY], BusinessInfo[iBizID][bZ], iZone);
					format(iZone, sizeof(iZone), "~b~%d, %s", iBizID, iZone);
					TextDrawSetString(PlayerTemp[i][LocationTD], iZone);
					TextDrawShowForPlayer(i, PlayerTemp[i][LocationTD]);
				}
				else
				{
					TextDrawSetString(PlayerTemp[i][LocationTD], " ");
					TextDrawShowForPlayer(i, PlayerTemp[i][LocationTD]);
				}
			}
		}
		new playerid = i;
	    if(PlayerInfo[playerid][power] == 0)
	    {
     		new result = 0;
       		switch(GetPlayerWeapon(playerid))
        	{
         		case 22,26,28,32,36..40,44,45: result = 1;
           		default: result = 0;
      		}
        	if(result)
        	{
         		new wat[ 80 ];
           		myStrcpy(wat, "Cheating [Code #001]");
	            ResetPlayerWeaponsEx(playerid);
				GameTextForPlayer(playerid, "~r~banned", 60000, 0);
				format(iStr, sizeof(iStr), "4{ IP-BAN } SERVER has IP banned %s (IP: %s). Reason: %s %s",PlayerName(playerid), PlayerTemp[playerid][IP], wat, TimeDate());
				iEcho(iStr);
				BanEx(playerid, wat);
				return 1;
    		}
	    }
	}
	return 1;
}

public Healing(playerid, Float:playerx, Float:playery, flag)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:playerNewX,Float:playerNewY,Float:playerNewZ;
	    GetPlayerPos(playerid,playerNewX,playerNewY,playerNewZ);
	    new Float:armour,Float:health;
		switch(flag)
		{
	        case 0:
			{
	            SendClientError(playerid,  "Heal System not implemented here");
	            return 1;
	        }
		    case 1:
			{
		        GetPlayerHealth(playerid,health);
		        if(health >= 100 || playerNewX != playerx || playerNewY != playery)
				{
		            Action(playerid, "has been healed.");
					return 1;
				}
				SetPlayerHealth(playerid,health+1);
			}
			case 2:
			{
			    GetPlayerHealth(playerid,health);
			    if(health < 100) SetPlayerHealth(playerid, health+1);
			    GetPlayerArmour(playerid,armour);
			    if(armour <= 98) SetPlayerArmour(playerid,armour+1);
			    if((health >= 100 && armour >= 99) || playerNewX != playerx || playerNewY != playery)
				{
		            Action(playerid, "has been healed and puts on body armour.");
					return 1;
				}

			}
			case 3:
			{
	            GetPlayerArmour(playerid,armour);
	            if(armour >= 99 || playerNewX != playerx || playerNewY != playery)
				{
		            Action(playerid, "has been armoured.");
					return 1;
				}
	        	SetPlayerArmour(playerid,armour+1);
			}
	    }
	    SetTimerEx("Healing",30,0,"iffi", playerid, playerx, playery, flag);
		return 1;
	}
	return 1;
}

public TempData()
{
	PlayerLoop(i)
	{
	    if(!PlayerTemp[i][loggedIn]) continue;
		new iQuery[1028], iFormat[228];
		myStrcpy(iQuery, "UPDATE `PlayerInfo` SET ");
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Money` = %d, `Bank` = %d, `Skin` = %d, ", PlayerTemp[i][sm], PlayerInfo[i][bank], GetPlayerSkin(i)); strcat(iQuery, iFormat);
	    if(PlayerInfo[i][jail])
	    {
			mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Jail` = %d, `JailTime` = %d, ", PlayerInfo[i][jail], PlayerInfo[i][jailtime]);
			strcat(iQuery, iFormat);
	    }
	    mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`level` = %d, `FactionID` = %d, `RankName` = '%e', `Tier` = %d WHERE `PlayerName` = '%e'", PlayerInfo[i][playerlvl], PlayerInfo[i][playerteam], PlayerInfo[i][rankname], PlayerInfo[i][ranklvl], PlayerName(i)); strcat(iQuery, iFormat);
	    mysql_tquery(MySQLPipeline, iQuery);
	}
	return 1;
}

public Checker()
{
	new t[6];
 	gettime(t[2], t[1], t[0]);
	getdate(t[5], t[4], t[3]);
	format(iStr, sizeof(iStr), "%02d/%02d/%d~n~%02d:%02d:%02d", t[3], t[4], t[5], t[2], t[1], t[0]);
	TextDrawSetString(IMtxt, iStr);
	new ora,minuti,secondi;
	gettime(ora,minuti,secondi);
	for (new i = 0; i <= MAX_PLAYERS; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		if(PlayerTemp[i][loggedIn])
		{
			PlayerTemp[i][pAFK]++;
		    new Float:PlayerHP, Float:PlayerARMOUR;
		    GetPlayerHealth(i, PlayerHP);
		    GetPlayerArmour(i, PlayerARMOUR);
		    if(PlayerHP > 100) SetPlayerHealth(i, 100);
		    if(PlayerARMOUR > 100)
		    {
		        BanReas("ADMIN",i,"Cheating [Code #003]", 1);
		    }
			SetPlayerScore(i,PlayerInfo[i][playerlvl]);
			if(PlayerInfo[i][jail] > 0 && PlayerInfo[i][jailtime]>2)
			{
			   	new Float:tmpx, Float:tmpy, Float:tmpz;
			   	GetPlayerPos(i,tmpx,tmpy,tmpz);
			   	if(!IsPlayerAtPrison(i))
				{
					new id = random(sizeof(PrisonCells));
					SetPlayerPosEx(i, PrisonCells[id][0],PrisonCells[id][1],PrisonCells[id][2], 0, 0, false);
				}
				PlayerInfo[i][jailtime]=PlayerInfo[i][jailtime]-1;
				new tmpstr[ 128 ];
				format(tmpstr, 128 ,"jailtime left: %d seconds",PlayerInfo[i][jailtime]);
				SetJailTD(i, tmpstr);
			}
			if(PlayerInfo[i][jail] > 0 && PlayerInfo[i][jailtime] <= 3)
			{
			    SendClientMessage(i,COLOR_GREEN,"[JAIL] You have been unjailed! Have a nice day, and have fun roleplaying.");
			    UnJail(i);
			}
			ResetPlayerMoney(i);
			GivePlayerMoney(i, PlayerTemp[i][sm]);

			if(IsPlayerConnected(gBackupMarker) || gBackupMarker != -1)
			{
				if(IsPlayerENF(i) && !IsPlayerInAnyInterior(gBackupMarker))
				{
					new Float:px, Float:py, Float:pz;
					GetPlayerPos(gBackupMarker, px, py, pz);
					SetPlayerCheckpoint(i, px, py, pz, 5.0);
				}
			}

		    for(new q; q < MAX_GANGZONES; q++)
		    {
				if(IsPlayerInArea(i, Gangzones[q][minX], Gangzones[q][minY], Gangzones[q][maxX], Gangzones[q][maxY]))
		        {
					if(!IsPlayerFED(i)) TextDrawShowForPlayer(i, Gangzones[q][gDRAW]);
		        }
		        else TextDrawHideForPlayer(i, Gangzones[q][gDRAW]);
		    }

		    new Float:x,Float:y,Float:z;
          	GetPlayerPos(i, x, y, z);
       		new Float:distance = floatsqroot(floatpower(floatabs(floatsub(x,SavePlayerPosEx[i][LastX])),2)+floatpower(floatabs(floatsub(y,SavePlayerPosEx[i][LastY])),2)+floatpower(floatabs(floatsub(z,SavePlayerPosEx[i][LastZ])),2));
            new value = floatround(distance);
            if(value > 100 && value < 600 && PlayerTemp[i][tp] == 0 && !IsPlayerInAnyVehicle(i) && PlayerInfo[i][power] == 0)
            {
	            new sDq[ 100 ];
			    format(sDq, 100, "%s{%d} possible airbreak (%d KM/H)", PlayerName(i), i, value);
			    AdminNotice(sDq);
		    }
         	SavePlayerPosEx[i][LastX] = x;
          	SavePlayerPosEx[i][LastY] = y;
         	SavePlayerPosEx[i][LastZ] = z;
         	if(PlayerTemp[i][muted] == 1 && GetTickCount() > PlayerTemp[i][mutedtick])
         	{
         	    PlayerTemp[i][muted] = 0;
         	    PlayerTemp[i][mutedtick] = 0;
         	    SendClientInfo(i, "You have been automatically unmuted.");
         	}
		}
	}
	if(gTick__GMX != -1 && now() - gTick__GMX > 10)
	{
	    SendRconCommand("gmx");
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    new message[ 128 ];
    if(GetPVarInt(playerid, "BriefCaseTill") != 0 && IsPlayerHoldingObjectID(playerid, 1210))
    {
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1380.84814,-1088.80822,27.38435))
            return SendClientError(playerid, "No bug abusing! ;)");
		format(message, 128, "Deposit successful!~n~Received $%d from your house till.",GetPVarInt(playerid, "BriefCaseTill"));
		ShowInfoBox(playerid, "House Till", message);
		GivePlayerMoneyEx(playerid, GetPVarInt(playerid, "BriefCaseTill"));
        DeletePVar(playerid, "BriefCaseTill");
        StopPlayerHoldingObjectEx(playerid);
        KillTimer(PlayerTemp[playerid][CPTimer]);
		DisablePlayerCheckpoint(playerid);
		PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
		return 1;
    }
    if(GetPVarInt(playerid, "HarvestCP") != 0 && (!strcmp(PlayerInfo[playerid][job], "Farmer", true)))
    {
        new cnt = GetPVarInt(playerid, "HarvestCP");
        if(FarmPlaces[cnt][3] == 3)
        {
            DeletePVar(playerid, "HarvestAmount");
			format(message, 128, "~y~harvested:~n~~w~0/13");
            TextDrawHideForPlayer(playerid, PlayerTemp[playerid][Harvest]);
            SetVehicleToRespawn(GetPlayerVehicleID(playerid));
            new amm = minrand(4000, 6000);
            SendClientMSG(playerid, COLOR_YELLOW, "* Here you go, %s. $%d for the work!", RPName(playerid), amm);
            GivePlayerMoneyEx(playerid,amm);
            DeletePVar(playerid, "HarvestCP");
            KillTimer(PlayerTemp[playerid][CPTimer]);
            DisablePlayerCheckpoint(playerid);
            PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
            return 1;
        }
        if(FarmPlaces[cnt][3] == 2)
        {
            SetPVarInt(playerid, "HarvestAmount", GetPVarInt(playerid, "HarvestAmount")+1);
			format(message, 128, "~y~harvested:~n~~w~%d/13",GetPVarInt(playerid, "HarvestAmount"));
			TextDrawSetString(PlayerTemp[playerid][Harvest], message);
            TextDrawShowForPlayer(playerid, PlayerTemp[playerid][Harvest]);
        }
        cnt++;
        SetPVarInt(playerid, "HarvestCP", cnt);
        KillTimer(PlayerTemp[playerid][CPTimer]);
        DisablePlayerCheckpoint(playerid);
        PlayerTemp[playerid][CPTimer] = SetTimerEx("SetCP", 500, true, "dffff", playerid,FarmPlaces[cnt][0],FarmPlaces[cnt][1],FarmPlaces[cnt][2], 3.0);
        return 1;
    }
    if(GetPVarInt(playerid, "DeliveringCargo") == 1 && (!strcmp(PlayerInfo[playerid][job], "Trucker", true)))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You need to be inside a trucker to use this.");
    	new carid = GetPlayerVehicleID(playerid); new vehicleid = FindVehicleID(carid);
	    if(IsTrailerAttachedToVehicle(carid) != 1) return SendClientError(playerid, "You don't have any trailer attached!");
	    if(VehicleInfo[vehicleid][vReserved] == VEH_RES_OCCUPA && !strcmp(VehicleInfo[vehicleid][vJob], "Trucker", false))
	    {
	    	if(IsPlayerInRangeOfPoint(playerid, 15.0, deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverX], deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverY], deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverZ]))
	    	{
	    		new trailerID = GetPVarInt(playerid, "TruckingTrailerID"); new totalGained; new iFormat[128];
	    		PlayerInfo[playerid][jobskill]++;
	    		SendClientMessage(playerid, 0x187234FF, "======================== [ Trucking Career ] ========================");
	    		SendClientMessage(playerid, 0x187234FF, "Your cargo has been unloaded. Thankyou for your delivery!");
	    		format(iFormat, sizeof(iFormat), " +$%s", number_format(totalGained));
	    		SendClientMessage(playerid, 0x187234FF, iFormat);
	    		format(iFormat, sizeof(iFormat), "Deliveries: %d", PlayerInfo[playerid][jobskill]);
	    		SendClientMessage(playerid, COLOR_WHITE, iFormat);
	    		SendClientMessage(playerid, 0x187234FF, "======================== [ Trucking Career ] ========================");
	    		SendClientMessage(playerid, COLOR_LIGHTGREY, " This amount has been added on to your next paycheck.");
	    		// PlayerInfo[playerid][jobPaycheck] += totalGained;
	    		DeleteVehicle(trailerID);
	    		DisablePlayerCheckpoint(playerid);
	    		KillTimer(PlayerTemp[playerid][CPTimer]);
	    		DeletePVar(playerid, "CargoLoad");
	    		DeletePVar(playerid, "DeliveringCargo");
	    		DeletePVar(playerid, "PCargo");
	    		DeletePVar(playerid, "TruckingTrailerID");
	    	}
	    }
    	else return SendClientError(playerid, "You need to be inside a trucker to use this.");
	    return 1;
	}
    if(GetPVarInt(playerid, "PCargo") == 1 && (!strcmp(PlayerInfo[playerid][job], "Trucker", true)))
    {
    	if(!IsPlayerInAnyVehicle(playerid)) return SendClientError(playerid, "You need to be inside a trucker to use this.");
    	new carid = GetPlayerVehicleID(playerid); new vehicleid = FindVehicleID(carid);
	    if(IsTrailerAttachedToVehicle(carid) != 0) return SendClientError(playerid, "You already have a trailer attached!");
    	if(VehicleInfo[vehicleid][vReserved] == VEH_RES_OCCUPA && !strcmp(VehicleInfo[vehicleid][vJob], "Trucker", false))
    	{
	    	DeletePVar(playerid, "PCargo");
	    	SendClientMessage(playerid, 0x187234FF, "Trucker: {E0E0E0}Use {187234}/cancelmission{E0E0E0} if you want to cancel the current trucking mission.");
	    	new iFormat[128], iZone[75];
	    	GetZone(deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverX], deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverY], deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverZ], iZone);
	    	format(iFormat, sizeof(iFormat), "Trucker: {E0E0E0}Destination %s has been marked on your radar.", iZone);
	    	SendClientMessage(playerid, 0x187234FF, iFormat);
	    	SetPVarInt(playerid, "DeliveringCargo", 1);
	    	DisablePlayerCheckpoint(playerid);
	    	PlayerTemp[playerid][CPTimer] = SetTimerEx("SetCP", 2000, true, "dffff", playerid, deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverX], deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverY], deliver[GetPVarInt(playerid, "CargoLoad") - 1][deliverZ], 5.0);
    		new Float:cX, Float:cY, Float:cZ, Float:cA;
    		GetPlayerPos(playerid, cX, cY, cZ);
    		GetPlayerFacingAngle(playerid, cA);
    		new trailerID = CreateNewVehicle("NoBodY", TRUCKING_TRAILER, cX, (cY - 5), (cZ + 2), cA, 0);
    		SetPVarInt(playerid, "TruckingTrailerID", trailerID);
    		SetTimerEx("SetTruckingTrailerToVehicle", 2000, false, "dd", carid, trailerID);
    	}
    	else return SendClientError(playerid, "You need to be inside a trucker to use this.");
    	return 1;
    }
	if(GetPVarInt(playerid, "RobBagAmount") != 0 && IsAtRobDropPlace(playerid))
	{
		NearMessage(playerid,"========================================================",COLOR_RED);
		format(message,sizeof(message),"* %s has gotten $%s for delivering the moneybag *",RPName(playerid), number_format(GetPVarInt(playerid, "RobBagAmount")));
		NearMessage(playerid,message,COLOR_WHITE);
		NearMessage(playerid,"========================================================",COLOR_RED);
		new moneytxt[ 128 ];
		format(moneytxt,sizeof(moneytxt),"[BIZROB] %s robbed $%d - OldMoney:%d - NewMoney:%d",PlayerName(playerid),GetPVarInt(playerid, "RobBagAmount"), PlayerTemp[playerid][sm],(PlayerTemp[playerid][sm]+GetPVarInt(playerid, "RobBagAmount")));
		AppendTo(moneylog,moneytxt);
	    GivePlayerMoneyEx(playerid, GetPVarInt(playerid, "RobBagAmount"));
	    DeletePVar(playerid, "RobBagAmount");
        KillTimer(PlayerTemp[playerid][CPTimer]);
	    StopPlayerHoldingObject(playerid);
	    DisablePlayerCheckpoint(playerid);
	}
   	if(strcmp(PlayerInfo[playerid][job],"CarJacker",true)==0)
	{
		if(PlayerTemp[playerid][loggedIn] && IsPlayerDriver(playerid) && PlayerTemp[playerid][isdropping] == 1)
		{
		    if(IsPlayerInSphere(playerid,1607.9749,-1554.2881,13.5823,6) || IsPlayerInSphere(playerid, 2613.5422,-2226.4785,13.3828, 6))
		    {
		        new carid = GetPlayerVehicleID(playerid);
		        new vehicleid = FindVehicleID(carid);
  				new Float:vHealth;
				GetVehicleHealth(GetPlayerVehicleID(playerid), vHealth);
		        
			    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 481)
					return SendClientError(playerid, "We don't accept this bike!");
				if(vHealth < 900)
				    return SendClientError(playerid, "We don't accept damaged vehicles!");
				if(!strcmp(VehicleInfo[vehicleid][vOwner], PlayerName(playerid), false))
					return SendClientError(playerid, "You cannot sell your own cars.");
				if(!strcmp(VehicleInfo[vehicleid][vOwner], "NoBodY") && !VehicleInfo[vehicleid][vFaction])
					return SendClientError(playerid, "You cannot sell vehicles owned by noone.");
					
				new sold;
				if(PlayerInfo[playerid][jobskill] >= 0 && PlayerInfo[playerid][jobskill]<10) sold=minrand(900,1300);
				if(PlayerInfo[playerid][jobskill] >= 10 && PlayerInfo[playerid][jobskill]<30) sold=minrand(1100,1500);
				if(PlayerInfo[playerid][jobskill] >= 30 && PlayerInfo[playerid][jobskill]<70) sold=minrand(1600,3500);
				if(PlayerInfo[playerid][jobskill] >= 70 && PlayerInfo[playerid][jobskill]<120) sold=minrand(3500,4500);
				if(PlayerInfo[playerid][jobskill] >= 120 && PlayerInfo[playerid][jobskill]<180) sold=minrand(4000,5000);
				if(PlayerInfo[playerid][jobskill] >= 180 && PlayerInfo[playerid][jobskill]<300) sold=minrand(5000,6000);
				else if(PlayerInfo[playerid][jobskill] >= 300) sold=minrand(5500,6500);
				SetVehicleToRespawn(carid);
				GivePlayerMoneyEx(playerid,sold);
				SendClientMSG(playerid, COLOR_WHITE, "[JOB] You have sold this vehicle and earned $%d. JobSkill: %d", sold, PlayerInfo[playerid][jobskill]+1);
				DisablePlayerCheckpoint(playerid);
				PlayerTemp[playerid][candrop]=0;
				PlayerTemp[playerid][isdropping] = 0;
				PlayerInfo[playerid][jobskill]++;
				KillTimer(PlayerTemp[playerid][DropTimer]);
				PlayerTemp[playerid][DropTimer] = SetTimerEx("Dropper",180000,0,"d",playerid);
				new mestr[MAX_STRING];
				format(mestr,sizeof(mestr),"14[DROPCAR] %s has dropped a car for $%d. Skill: %d", PlayerName(playerid), sold, PlayerInfo[playerid][jobskill]);
				iEcho(mestr);
				new iCount;
				BusinessLoop(bizID)
				{
					if(BusinessInfo[bizID][bActive] != true) continue;
					if(BusinessInfo[bizID][bType] != BUSINESS_TYPE_EXPORT) continue;
					iCount++;
				}
				BusinessLoop(bizID)
				{
					if(BusinessInfo[bizID][bActive] != true) continue;
					if(BusinessInfo[bizID][bType] != BUSINESS_TYPE_EXPORT) continue;
					BusinessInfo[bizID][bTill] += 300 / iCount;
				}
			}
			return 1;
		}
	}
	if(!IsAtDynamicCP(playerid)) DisablePlayerCheckpoint(playerid);
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(IsPlayerDriver(playerid) && pickupid == obj[GUNS][objid])
	{
		DestroyPickup(pickupid);
		new carid = GetPlayerVehicleID(playerid);
		VehicleInfo[FindVehicleID(carid)][vGuns] = obj[GUNS][objflag];
		new infostring[MAX_STRING];
		format(infostring,sizeof(infostring), "Guns taken: total in car: [%d]", VehicleInfo[FindVehicleID(carid)][vGuns]);
		SendClientMessage(playerid,COLOR_WHITE,infostring);
		return 1;
	}
	return 1;
}

public Dropper(playerid)
{
	PlayerTemp[playerid][candrop] = 1;
	return 1;
}

public WeatherSet()
{
    SetWeather(minrand(1,7));
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    PlayerTemp[playerid][airbreakcount] = 0;
	switch(newstate)
	{
		case PLAYER_STATE_PASSENGER:
		{
			new carid = GetPlayerVehicleID(playerid);
		    new vehicleid = FindVehicleID(carid);
			if(VehicleInfo[vehicleid][vModel] == 420)
			{
				if(PlayerTemp[playerid][sm] < 800)
				{
					Up(playerid);
					SendClientMessage(playerid, COLOR_RED,"You can't pay");
					return 1;
				}
				new bizID = VehicleInfo[vehicleid][vBusiness];
				GivePlayerMoneyEx(playerid, -PlayerTemp[VehicleDriverID(carid)][Duty]);
				GivePlayerMoneyEx(VehicleDriverID(carid), PlayerTemp[VehicleDriverID(carid)][Duty]);
				new tmpbank = BusinessInfo[bizID][bTill];
				tmpbank = BusinessInfo[bizID][bTill] + ((PlayerTemp[VehicleDriverID(carid)][Duty] * 20) / 100);
				BusinessInfo[bizID][bTill] = tmpbank;
				return 1;
			}
		}
		case PLAYER_STATE_DRIVER:
		{
		    new carid = GetPlayerVehicleID(playerid);
		    new vehicleid = FindVehicleID(carid);
		    ModCar(carid);
			if(IsVehicleBoat(carid)) if(PlayerInfo[playerid][boatlic] == 0) SendClientWarning(playerid, "You are sailing without a license, you may be arrested!");
			else if(IsVehiclePlane(carid)) if(PlayerInfo[playerid][flylic] == 0) SendClientWarning(playerid, "You are flying without a license, you may be arrested!");
			else
			{
				if(PlayerInfo[playerid][driverlic] == 0) SendClientWarning(playerid, "You are driving without a license, you may be arrested!");
			}
		    if(VehicleInfo[vehicleid][vModel] == 425 || VehicleInfo[vehicleid][vModel] == 432)
		    {
		    	if(PlayerInfo[playerid][playerteam] == CIV || PlayerInfo[playerid][ranklvl] >= 1)
		    	{
		    		Up(playerid);
		    		SendClientError(playerid, "This vehicle is not for you.");
		    	}
		    }
			if(VehicleInfo[vehicleid][vReserved] == VEH_RES_NOOBIE && PlayerInfo[playerid][playerlvl] > 3)
			{
				if(PlayerInfo[playerid][playerlvl] > 3)
				{
					Up(playerid);
					SendClientError(playerid, "This vehicle is reserved for players level 3 or below.");
				}
				else SendClientInfo(playerid, "This is a vehicle to show you around Los Santos, this will automaticlly despawn after 3 minutes of being unoccupied.");
			}
		    if(VehicleInfo[vehicleid][vFaction] != CIV)
		    {
				if(VehicleInfo[vehicleid][vReserved] == VEH_RES_FACT && PlayerInfo[playerid][playerteam] != VehicleInfo[vehicleid][vFaction])
				{
					new Message[MAX_STRING];
					format(Message, sizeof(Message), "This %s is faction reserved.", GetVehicleName(carid), VehicleInfo[vehicleid][vJob]);
					SendClientError(playerid, Message);
					Up(playerid);
				}
				else
				{
					new string[ 128 ];
					format(string, sizeof(string), " This %s is owned by %s.", GetVehicleName(GetPlayerVehicleID(playerid)), FactionInfo[VehicleInfo[vehicleid][vFaction]][fName]);
					SendClientMessage(playerid, COLOR_LIGHTGREY, string);
				}
		    }
		    if(strcmp(VehicleInfo[vehicleid][vOwner],"NoBodY"))
		    {
		        new string[ 128 ];
		        format(string, sizeof(string), " This %s is owned by %s.", GetVehicleName(GetPlayerVehicleID(playerid)),NoUnderscore(VehicleInfo[vehicleid][vOwner]));
		        SendClientMessage(playerid, COLOR_LIGHTGREY, string);
		    }
			if(VehicleInfo[vehicleid][vReserved] == VEH_RES_OCCUPA) // job vehicle...
			{
				if(!strcmp(PlayerInfo[playerid][job], VehicleInfo[vehicleid][vJob], false))
				{
					if(!strcmp(VehicleInfo[vehicleid][vJob], "Farmer", false))
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Welcome to the the Combine Harvester! Type /startharvest to get started.");
					}
					if(!strcmp(VehicleInfo[vehicleid][vJob], "Trucker", false))
					{
						SendClientMessage(playerid, COLOR_YELLOW, "Welcome to the truck! Use /tm (/truckermission) to get started.");
/*	
						SetPlayerCheckpoint(playerid, 1751.6613,-2058.0962,13.6231, 3.0);
						SetPVarInt(playerid, "ReadyToGetCargo", 1);
						SendClientMessage(playerid, COLOR_YELLOW, "Welcome to the truck, buddy! Please attach a trailer and enter the checkpoint!");*/
					}
				}
				else
				{
		            Up(playerid);
		            SendClientError(playerid, "This vehicle is reserved for a job profession!");
				}
			}
		    if(VehicleInfo[vehicleid][vSellPrice] != 0)
		    {
		        new string[ 128 ];
		        format(string, sizeof(string), "VEHICLE: This %s is on sale!", GetVehicleName(carid));
		        SendClientMessage(playerid, COLOR_HELPEROOC, string);
		        format(string, sizeof(string), " You can buy this vehicle from %s for $%s with /car buy.", NoUnderscore(VehicleInfo[vehicleid][vOwner]), number_format(VehicleInfo[vehicleid][vSellPrice]));
		        SendClientMessage(playerid, COLOR_LIGHTGREY, string);
		        SendClientMessage(playerid, COLOR_LIGHTGREY, " Type /exit to exit the vehicle.");
		        TogglePlayerControllable(playerid, false);
		    }
			if(IsPlayerAtImpound(playerid))
			{
			    if(VehicleInfo[vehicleid][vImpounded])
			    {
					SendClientError(playerid, "This vehicle is impounded!");
					RemovePlayerFromVehicle(playerid);
			    }
			}
			if(VehicleInfo[vehicleid][vReserved] == VEH_RES_RENT && PlayerTemp[playerid][rentcar] != vehicleid && VehicleInfo[vehicleid][vBusiness] != -1)
			{
				PlayerTemp[playerid][carfrozen] = 1;
				TogglePlayerControllable(playerid, false);
				new messaggio[MAX_STRING];
				new bizID = VehicleInfo[vehicleid][vBusiness];
				format(messaggio,sizeof(messaggio),"~w~Vehicle for rent~n~type ~b~/rentcar~n~~w~price:~g~%d~n~~w~or ~r~/exit", BusinessInfo[bizID][bRentPrice]);
				GameTextForPlayer(playerid, messaggio, 5000, 1);
			}
			if(GetEngineStatus(carid) == 0) SendClientMessage(playerid, COLOR_LIGHTGREY, "The engine of this vehicle is off! Use /engine to turn it on.");
		}
	}
	return 1;
}

public CarFrozen()
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(PlayerTemp[i][carfrozen]==1)
		{
		    PlayerTemp[i][carfrozen]=0;
			TogglePlayerControllable(i,true);
		}
	}
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	new carid = FindVehicleID(vehicleid);
	if(VehicleInfo[carid][vLocked] == true && VehicleInfo[carid][vLockedBy] != forplayerid) SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
	else SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 0);
}

public OnPlayerStreamIn(playerid, forplayerid)
{
    if(PlayerTemp[playerid][hname] == 1 && PlayerInfo[forplayerid][power] < 1) ShowPlayerNameTagForPlayer(forplayerid, playerid, false);
    else ShowPlayerNameTagForPlayer(forplayerid, playerid, true);
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(PlayerTemp[playerid][tmphouse] != -1)
	{
		new houseid = PlayerTemp[playerid][tmphouse];
		if(pickupid == HouseInfo[houseid][wardrobePickup] && HouseInfo[houseid][hWardrobe] == 1 && !strcmp(HouseInfo[houseid][hOwner], PlayerName(playerid), false))
		{
			if(GetPVarInt(playerid, "WarDrobeDialog") != 1)
			{
				ShowDialog(playerid, DIALOG_WARDROBE, houseid);
			}
		}
	}
	for(new o; o < sizeof(objfloat); o++)
	{
		if(pickupid == objfloat[o][pickupID]) GameTextForPlayer(playerid, objfloat[o][oinfomsg], 3000, 6);
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == gCheckPoints[CITYHALL])
	{
		ShowDialog(playerid, DIALOG_JOB_SELECTION);
	}
	else if(checkpointid == gCheckPoints[TREADMILL])
	{
	    if(treadmillBUSY != -1)
	    {
			ShowDialog(playerid, DIALOG_NO_RESPONSE, 2);
	        return 1;
	    }
		ShowDialog(playerid, DIALOG_GYM);
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	BusinessLoop(b)
	{
	    new infoh2[ 164 ];
	    if(BusinessInfo[b][bActive] != true || BusinessInfo[b][bType] == BUSINESS_TYPE_BANK) continue;
		if(IsPlayerInRangeOfPoint(playerid, 3.0, BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ]) && areaid == BusinessInfo[b][bArea])
		{
		    new bizType = BusinessInfo[b][bType];
		    if(bizType == BUSINESS_TYPE_CLUB || bizType == BUSINESS_TYPE_PUB || bizType == BUSINESS_TYPE_STRIPCLUB || bizType == BUSINESS_TYPE_GUNSTORE || bizType == BUSINESS_TYPE_PAYNSPRAY || bizType == BUSINESS_TYPE_PAINTBALL)
			{
				if(!BusinessInfo[b][bBuyable]) format(infoh2,sizeof(infoh2),"~w~Owner: ~y~%s~n~~w~Entrance: ~g~$%d~n~~w~Level: ~g~%d~w~",NoUnderscore(BusinessInfo[b][bOwner]), BusinessInfo[b][bFee], BusinessInfo[b][bLevel]);
				else format(infoh2,sizeof(infoh2),"~w~Owner: ~g~%s~n~~w~Entrance: ~g~$%d~n~~w~Level: ~g~%d~n~~w~Price: ~y~%d~w~",NoUnderscore(BusinessInfo[b][bOwner]),BusinessInfo[b][bFee], BusinessInfo[b][bLevel], BusinessInfo[b][bSellprice]);
			}
			else
			{
				if(!BusinessInfo[b][bBuyable]) format(infoh2,sizeof(infoh2),"~w~Owner: ~y~%s~n~~w~Level: ~g~%d~w~",NoUnderscore(BusinessInfo[b][bOwner]), BusinessInfo[b][bLevel]);
				else format(infoh2,sizeof(infoh2),"~w~Owner: ~g~%s~n~~w~Level: ~g~%d~n~~w~Price: ~y~%d~w~", NoUnderscore(BusinessInfo[b][bOwner]), BusinessInfo[b][bLevel], BusinessInfo[b][bSellprice]);
			}
			ShowInfoBox(playerid, NoUnderscore(BusinessInfo[b][bName]), infoh2, 20);
		}
	}
	PlayerLoop(p)
	{
		if(BoomBoxInfo[p][boomActive] != true) continue;
		if(IsPlayerInRangeOfPoint(playerid, 15.0, BoomBoxInfo[p][boomX],  BoomBoxInfo[p][boomY],  BoomBoxInfo[p][boomZ]) && areaid == BoomBoxInfo[p][boomArea])
		{
			new iFormat[128];
			format(iFormat, sizeof(iFormat), "[Boombox] %s has placed a boombox in your current area.", MaskedName(playerid));
			SendClientMessage(p, 0x5C8A8AFF, iFormat);
			PlayAudioStreamForPlayer(playerid, BoomBoxInfo[p][boomURL], BoomBoxInfo[p][boomX],  BoomBoxInfo[p][boomY],  BoomBoxInfo[p][boomZ], 30.0, 1);
		}
	}
  	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	if(GetPVarInt(playerid, "Tazer") != 0 && weaponid == 23 && IsPlayerFED(playerid) && !IsPlayerInAnyVehicle(damagedid) && PlayerTemp[damagedid][tazed] != 1)
	{
		new iFormat[228];
		format(iFormat, sizeof(iFormat), "has been tazed by %s.", MaskedName(playerid));
		Action(damagedid, iFormat);
		PlayerTemp[damagedid][tazed] = 1;
	}
	return 1;
}

public AddFire(Float:x, Float:y, Float:z)
{
        new slot = GetFlameSlot();
        if(slot == -1) {return slot;}
        Flame[slot][Flame_Exists] = 1;
        Flame[slot][Flame_pos][0] = x;
        Flame[slot][Flame_pos][1] = y;
        Flame[slot][Flame_pos][2] = z - Z_DIFFERENCE;
        Flame[slot][Flame_id] = CreateDynamicObject(18689, Flame[slot][Flame_pos][0], Flame[slot][Flame_pos][1], Flame[slot][Flame_pos][2], 0.0, 0.0, 0.0);
        return slot;
}

public KillFire(id)
{
        DestroyDynamicObject(Flame[id][Flame_id]);
        Flame[id][Flame_Exists] = 0;
        Flame[id][Flame_pos][0] = 0.0;
        Flame[id][Flame_pos][1] = 0.0;
        Flame[id][Flame_pos][2] = 0.0;
        DestroyTheSmokeFromFlame(id);
}

//# A suggestion from a user of this script. Very simple functions to add and remove smoke without flames.
//# Think about a way to kill the smoke and use it, if you wish.
//# Maybe you could link smoke on a house with variables to a flame inside a house so if the flame gets extinguished the smoke disappears.

public AddSmoke(Float:x, Float:y, Float:z)
{
        return CreateDynamicObject(18727, x, y, z, 0.0, 0.0, 0.0);
}

public KillSmoke(id)
{
        DestroyDynamicObject(id);
}

// Destroys extinguishing-smoke
public DestroyTheSmokeFromFlame(id)
{
    for(new i; i < 5; i++) { DestroyDynamicObject(Flame[id][Smoke][i]); }
}

public FireTimer(playerid, id)
{
        if(id < -1 && (Aiming_at_Flame(playerid) == id || Pissing_at_Flame(playerid) == id)) { StopPlayerBurning(id+MAX_PLAYERS); }
        else if(Flame[id][Flame_Exists] && ((Pressing(playerid) & KEY_FIRE && Aiming_at_Flame(playerid) == id) || (Pissing_at_Flame(playerid) == id)))
        {
        	new sendername[MAX_PLAYER_NAME+26];
        	GetPlayerName(playerid, sendername, sizeof(sendername));
        }
        KillTimer(ExtTimer[playerid]);
        ExtTimer[playerid] = -1;
}

public SetPlayerBurn(playerid)
{
		SetPlayerAttachedObject(playerid, FIRE_OBJECT_SLOT, 18690, 2, -1, 0, -1.9, 0, 0);
        PlayerOnFire[playerid] = 1;
        GetPlayerHealth(playerid, PlayerOnFireHP[playerid]);
        KillTimer(PlayerOnFireTimer[playerid]); KillTimer(PlayerOnFireTimer2[playerid]);
        PlayerOnFireTimer[playerid] = SetTimerEx("BurningTimer", 91, 1, "d", playerid);
        PlayerOnFireTimer2[playerid] = SetTimerEx("StopPlayerBurning", 7000, 0, "d", playerid);
        return 1;
}

public BurningTimer(playerid)
{
        if(PlayerOnFire[playerid])
        {
            new Float:hp;
            GetPlayerHealth(playerid, hp);
            if(hp < PlayerOnFireHP[playerid])
            {
                PlayerOnFireHP[playerid] = hp;
            }
            CallRemoteFunction("SetPlayerHealth", "dd", playerid, PlayerOnFireHP[playerid]-1.0);
            PlayerOnFireHP[playerid] -= 1.0;
        }
        else { KillTimer(PlayerOnFireTimer[playerid]); KillTimer(PlayerOnFireTimer2[playerid]); }
}

public StopPlayerBurning(playerid)
{
        KillTimer(PlayerOnFireTimer[playerid]);
        PlayerOnFire[playerid] = 0;
        RemovePlayerAttachedObject(playerid, FIRE_OBJECT_SLOT);
}

public OnFireUpdate()
{
	new aim, piss;
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
	{
		aim = -1; piss = -1;
		if(!IsPlayerConnected(playerid) || IsPlayerNPC(playerid))
		{
			continue;
		}
		if(PlayerOnFire[playerid] && !CanPlayerBurn(playerid, 1))
		{
				StopPlayerBurning(playerid);
		}
		if(Pissing_at_Flame(playerid) != -1 || Aiming_at_Flame(playerid) != -1)
		{
			piss = Pissing_at_Flame(playerid); aim = Aiming_at_Flame(playerid);
			if(ExtTimer[playerid] == -1 && ((aim != -1 && Pressing(playerid) & KEY_FIRE) || piss != -1))
			{
				new value, time, Float:x, Float:y, Float:z;
				if(piss != -1)
				{
					value = piss;
					time = EXTINGUISH_TIME_PEEING;
				}
				else if(aim != -1)
				{
					value = aim;
					if(GetPlayerWeapon(playerid) == 41)
					{
						CreateExplosion(Flame[value][Flame_pos][0], Flame[value][Flame_pos][1], Flame[value][Flame_pos][2], 2, 5);
						continue;
					}
					if(IsPlayerInAnyVehicle(playerid))
					{
						time = EXTINGUISH_TIME_VEHICLE;
					}
					else
					{
							time = EXTINGUISH_TIME_ONFOOT;
					}
				}
				if(value < -1) { time = EXTINGUISH_TIME_PLAYER; }
				time *= 1000;
				if(value >= -1)
				{
					x = Flame[value][Flame_pos][0];
					y = Flame[value][Flame_pos][1];
					z = Flame[value][Flame_pos][2];
					DestroyTheSmokeFromFlame(value);
					Flame[value][Smoke][0] = CreateDynamicObject(18727, x, y, z, 0.0, 0.0, 0.0);
					Flame[value][Smoke][1] = CreateDynamicObject(18727, x+1, y, z, 0.0, 0.0, 0.0);
					Flame[value][Smoke][2] = CreateDynamicObject(18727, x-1, y, z, 0.0, 0.0, 0.0);
					Flame[value][Smoke][3] = CreateDynamicObject(18727, x, y+1, z, 0.0, 0.0, 0.0);
					Flame[value][Smoke][4] = CreateDynamicObject(18727, x, y-1, z, 0.0, 0.0, 0.0);
					SetTimerEx("DestroyTheSmokeFromFlame", time, 0, "d", value);
				}
				ExtTimer[playerid] = SetTimerEx("FireTimer", time, 0, "dd", playerid, value);
			}
		}
		if(CanPlayerBurn(playerid) && IsAtFlame(playerid))
		{
				SetPlayerBurn(playerid);
		}
		#if defined BurnOthers
		new Float:x, Float:y, Float:z;
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(playerid != i && IsPlayerConnected(i) && !IsPlayerNPC(i))
			{
				if(CanPlayerBurn(i) && PlayerOnFire[playerid] && !PlayerOnFire[i])
				{
					GetPlayerPos(i, x, y, z);
					if(IsPlayerInRangeOfPoint(playerid, 1, x, y, z))
					{
						SetPlayerBurn(i);
					}
				}
			}
		}
		#endif
	}
	return 1;
}