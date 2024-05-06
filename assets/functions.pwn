/*********************************************************************************************************************************************
						- NYOGames [functions.pwn file]
*********************************************************************************************************************************************/
forward bool:IsPlayerInThisFactionType(playerid, facType);

stock RGBAToARGB( rgba )
    return rgba >>> 8 | rgba << 24;

stock g_OnGameModeInit()
{
	CreateDynamicObject(1498, 662.79340, -565.22870, 15.29860,   0.00000, 0.00000, 0.00000); // gas station door!
	
	printf("Max Objects: %d", Streamer_GetMaxItems(STREAMER_TYPE_OBJECT));
	
	Streamer_TickRate(40);
    AntiDeAMX();
    ConnectToDatabase();
	
	SendRconCommand("mapname Angel Pine");
	SendRconCommand("hostname [ Test-Server ] Angel Pine Roleplay");
	SetGameModeText(SERVER_GM_TEXT);
	ShowNameTags(1);
	AllowInteriorWeapons(1);
	EnableStuntBonusForAll(false);
	DisableInteriorEnterExits();
	SetNameTagDrawDistance(15.0);
	ShowPlayerMarkers(0);

	LOOP:iC(1, 311) if(IsValidSkin(iC)) AddPlayerClass(iC, 0.0, 0.0, 0.0, 0.0, 0,0,0,0,0,0);

    gCheckPoints[CITYHALL] = CreateDynamicCP(361.8299,173.6822,1008.3828, 1, 20, 3, -1, 30);
    gCheckPoints[TREADMILL] = CreateDynamicCP(758.3981,-65.1611,1000.8479, 1, 1338, 7, -1, 20);
	
    SetTimer("SendMSG", 120000, true);
    SetTimer("RealTimeUpdate",1000,0);
	SetTimer("PayDay", 40002, 1);
	SetTimer("PayCheck", 1200000, 1);
	SetTimer("TimeConn", 60000, 1);
	SetTimer("FuelDown", RunOutTime, 1);
	SetTimer("CheckGas", 400, 1);
	SetTimer("UpdateZone", 4000, 1);
	SetTimer("WeatherSet", 1800000, 1);
	SetTimer("TempData", 61000, 1);
	SetTimer("Checker", 1000, true);
	SetTimer("AdvertisementCenter", 60000, true); // 60 * 1000 == 1 minute.
	SetTimer("OnFireUpdate", 500, 1);

    Init__Textdraw();
    LoadBusinesses();
	LoadFactions();
    LoadVehicles();
    LoadGangZones();
  	LoadHouses();
	LoadTeleports();
	echo_Init();
	GlobalFiles();
	LoadATMs();
	LoadGates();
	//LoadObjects();

    for(new i; i < MAX_BARRIERS; i++) roadBlockPlayer[i] = "NoBodY";
    for(new i; i < sizeof(Seeds); i++) myStrcpy(Seeds[i][sOwner], "NoBodY");
	for(new p; p < sizeof(labels); p++) CreateDynamic3DTextLabel(labels[p][labtext], COLOR_HELPEROOC, labels[p][labx], labels[p][laby],labels[p][labz]+0.3, 15.0);
	for(new o; o < sizeof(objfloat); o++) objfloat[o][pickupID] = CreateDynamicPickup(objfloat[o][icontype], 1, objfloat[o][olocation_x], objfloat[o][olocation_y], objfloat[o][olocation_z],-1);
	if(!dini_Exists(deathlog)) dini_Create(deathlog), printf("%s created", deathlog);
 	for(new pID; pID < MAX_PROPERTIES; pID++)
	{
		new tmps[ 128 ];
	    PropInfo[pID][PropIsBought] = 0;
	    PropInfo[pID][PropOwner] = 255;
	    format(tmps, 128, "[Property]\n%s\nPrice: $%s\nEarning: $%s/5min\n/prop buy", PropInfo[pID][PropName], number_format(PropInfo[pID][PropPrice]),number_format(PropInfo[pID][PropEarning]));
	    CreateDynamic3DTextLabel(tmps, COLOR_GOLD, PropInfo[pID][PropX],PropInfo[pID][PropY],PropInfo[pID][PropZ]+0.75, 20);
	}
	return 1;
}

stock g_OnGameModeExit()
{
	mysql_close(MySQLPipeline);
    echo_Exit();
	for(new i; i < MAX_FLAMES; i++)
	{
		KillFire(i);
	}
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
	{
		if(PlayerOnFire[playerid] && !CanPlayerBurn(playerid, 1))
		{
			StopPlayerBurning(playerid);
		}
	}
	return 1;
}

stock ConnectToDatabase()
{
	printf("[ConnectToMainPipeline:] Connecting to %s...", SQL_DATA);
	mysql_log(LOG_ERROR | LOG_WARNING | LOG_DEBUG);
	
	MySQLPipeline = mysql_connect(SQL_HOST, SQL_USER, SQL_DATA, SQL_PASS, 2083, true, 2);
	if(mysql_errno(MySQLPipeline) != 0)
	{
		printf("[MySQL] (MySQLPipeline) Fatal Error! Could not connect to MySQL: Host %s - DB: %s - User: %s", SQL_HOST, SQL_DATA, SQL_USER);
		print("[MySQL] Note: Make sure that you have provided the correct connection credentials.");
		printf("[MySQL] Error number: %d", mysql_errno(MySQLPipeline));
		SendRconCommand("exit");
	}
	return 1;
}

stock frenametextfile(oldname[],newname[])
{
    if (!fexist(oldname)) return false;
    fremove(newname);
    if (!fcopytextfile(oldname,newname)) return false;
    fremove(oldname);
    return true;
}

stock bool:IsPlayerAFK(playerid)
{
	if(PlayerTemp[playerid][pAFK] >= 3) return true;
	return false;
}

stock IntToBase(number, const base)
{
    new str[32];
	if(1 < base < 37)
	{
        new m = 1,
            depth = 0;
        while (m <= number)
		{
            m *= base;
            depth++;
        }
        for ( ; (--depth) != -1; ){
            str[depth] = (number % base);
            number = ((number - str[depth]) / base);
            if(str[depth] > 9) str[depth] += 'A'; else str[depth] += '0';
        }
    }
    return str;
}
#define IntToDual(%0) IntToBase(%0, 2)
#define IntToOctal(%0) IntToBase(%0, 8)
#define IntToHex(%0) IntToBase(%0, 16)

stock IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0')
		{
			return 0;
		}
	}
	return 1;
}

stock OnePlayAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    if(PlayerTemp[playerid][gPlayerUsingLoopingAnim] == 1) TextDrawHideForPlayer(playerid,txtAnimHelper);
	ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp, 1);
	PlayerTemp[playerid][animation]++;
}

stock LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
	if (PlayerTemp[playerid][gPlayerUsingLoopingAnim] == 1) TextDrawHideForPlayer(playerid,txtAnimHelper);
    PlayerTemp[playerid][gPlayerUsingLoopingAnim] = 1;
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp, 1);
    TextDrawShowForPlayer(playerid,txtAnimHelper);
    PlayerTemp[playerid][animation]++;
}

stock StopLoopingAnim(playerid)
{
	PlayerTemp[playerid][gPlayerUsingLoopingAnim] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}

stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

stock stringContainsIP(string[])
{
    new dotCount;
    for(new i; string[i] != EOS; ++i)
    {
        if(('0' <= string[i] <= '9') || string[i] == '.' || string[i] == ':')
        {
            if((string[i] == '.') && (string[i + 1] != '.') && ('0' <= string[i - 1] <= '9'))
            {
                ++dotCount;
            }
            continue;
        }
    }
    return (dotCount > 2);
}

stock WeaponFromName(wname[])
{
    for(new i = 0; i < 48; i++)
    {
        if (i == 19 || i == 20 || i == 21) continue;
		if (strfind(aWeaponNames[i], wname, true) != -1)
		{
			return i;
		}
	}
	return -1;
}

stock GivePlayerMoneyEx(playerid, amount)
{
    PlayerTemp[playerid][sm]+=amount;
    GivePlayerMoney(playerid,amount);
    if(amount >= 25000)
    {
		SaveAccount(playerid);
    }
	return 1;
}

stock PlayerName(playerid)
{
  new name[MAX_PLAYER_NAME];
  GetPlayerName(playerid, name, MAX_PLAYER_NAME);
  return name;
}

stock SendClientError(playerid, errormessage[])
{
	new _error[256];
	format(_error, 256, "Error | {F7BEBF}%s", errormessage);
	if(IsPlayerConnected(playerid)) SendClientMessage(playerid, 0xDB2E2EFF,  _error);
	return 1;
}

stock SendClientInfo(playerid, infostr[])
{
	new _info[MAX_STRING];
	format(_info, MAX_STRING, "Info | {8bee94}%s", infostr);
	if(IsPlayerConnected(playerid)) SendClientMessage(playerid, 0x49ab52FF, _info);
	return 1;
}

stock AdminBroadcase(infostr[])
{
	new _aBroad[MAX_STRING];
	format(_aBroad, sizeof(_aBroad), "(( AdmCmd | {f58686}%s {ed5151}))");
	LOOP:p(0, MAX_PLAYERS)
	{
		if(IsPlayerConnected(p) != true) continue;
		if(PlayerTemp[p][loggedIn] != true) continue;
		SendClientMessage(p, 0xed5151FF, _aBroad);
	}
	return 1;
}

stock AdminNotice(infostr[], aRestriction = 0)
{
	new _info[MAX_STRING];
	format(_info, MAX_STRING, "(( A-Notice | {FFD1D1}%s {FF9E9E}))", infostr);
	if(aRestriction != 0)
	{
		PlayerLoop(p)
		{
		    if(PlayerInfo[p][power] >= aRestriction)
				SendClientMessage(p, 0xFF9E9EFF, _info);
		}
	}
	else
	{
		PlayerLoop(p)
		{
		    if(PlayerInfo[p][power] >= 1)
				SendClientMessage(p, 0xFF9E9EFF, _info);
		}
	}
	format(_info, sizeof(_info), "13A-Notice | $s", infostr);
	iEcho(_info);
	return 1;
}

stock SendClientWarning(playerid, warnstr[])
{
	new _warn[MAX_STRING];
	format(_warn, MAX_STRING, "Warning | {edb357}%s", warnstr);
	if(IsPlayerConnected(playerid)) SendClientMessage(playerid, 0xd58609FF, _warn);
	return 1;
}

stock SCP(_id, _param[])
{
	new iFormat[256];
	LOOP:i(0, strlen(_param))
	{
		if(_param[i] == '[') _param[i] = '<';
		if(_param[i] == ']') _param[i] = '>';
	}
	format(iFormat, sizeof(iFormat), "[cmd]: {9c9a9c}%s", _param);
	return SendPlayerMessage(_id, 0x6A696AFF, iFormat, "[cmd]: {9c9a9c}", 128);
}

stock IsPlayerInSphere(playerid,Float:sx,Float:sy,Float:sz,sradius) //By Sacky
{
	if(GetPlayerDistanceToPointEx(playerid,sx,sy,sz) < sradius) return 1;
	return 0;
}

stock GetPlayerDistanceToPointEx(playerid,Float:sx,Float:sy,Float:sz) //By Sacky
{
	new Float:x1,Float:y1,Float:z1;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(sx,x1)),2)+floatpower(floatabs(floatsub(sy,y1)),2)+floatpower(floatabs(floatsub(sz,z1)),2));
	return floatround(tmpdis);
}

stock GetDistanceBetweenPlayers(playerid,playerid2) //By Slick (Edited by Sacky)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	GetPlayerPos(playerid2,x2,y2,z2);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(tmpdis);
}

stock minrand(min, max) //By Alex "Y_Less" Cole
{
	return random(max - min) + min;
}

stock IsPlayerInAnyInterior(playerid) //By Sacky
{
	new Float:x;
	new Float:y;
	new Float:z;
	if(IsPlayerConnected(playerid))
	{
		GetPlayerPos(playerid,x,y,z);
		if(z > 900 && !IsPlayerInAnyVehicle(playerid))	return 1;
	}
	return 0;
}

stock bool:AccountExist(playername[])
{
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `PlayerName` FROM `PlayerInfo` WHERE `PlayerName` = '%e'", playername);
	new Cache:result = mysql_query(MySQLPipeline, iQuery);
	new rows = cache_num_rows();
	cache_delete(result);
	if(rows > 0) return true;
	return false;
}

stock bool:Whitelisted(playername[])
{
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `PlayerName` FROM `Whitelist` WHERE `PlayerName` = '%e'", playername);
	new Cache:result = mysql_query(MySQLPipeline, iQuery);
	new rows = cache_num_rows();
	cache_delete(result);
	if(rows > 0) return true;
	return false;
}

stock GetPlayerId(playername[]) //By Alex "Y_Less" Cole (Edited by Sacky)
{
	new playername2[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i,playername2,sizeof(playername2));
			if(strcmp(playername,playername2)==0) return i;
		}
	}
	return  INVALID_PLAYER_ID;
}

stock PlayerID(partofname[]) //By Jan "DracoBlue" Schï¿½tze
{
	new i;
	new playername[MAX_STRING];
	for (i=0;i<MAX_PLAYERS;i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i,playername,MAX_STRING);
			if (strcmp(playername,partofname,true)==0) 	return i;
		}
	}
	return INVALID_PLAYER_ID;
}

stock myStrcpy(dest[], src[])
{
    new i = 0;
    while ((dest[i] = src[i])) i++;
}

stock WarnReas(kicker[],kicked,reason[])
{
	new messaggio[MAX_STRING], string[MAX_STRING];
	if(IsPlayerConnected(PlayerID(kicker)) && PlayerInfo[PlayerID(kicker)][power]==31337) myStrcpy(kicker,"Unknown Admin");
	format(messaggio,sizeof(messaggio),"(( AdmCmd | %s has warned %s. Reason: %s [%d/5] ))",kicker, PlayerName(kicked), reason, PlayerInfo[kicked][warns]+1);
	SendClientMessageToAll(COLOR_RED, messaggio);
	PlayerInfo[kicked][warns]++;

	if(PlayerInfo[kicked][warns] >= 5)
	    return BanReas("SERVER",kicked,"5/5 warns");

	format( string, sizeof(string), "4{ WARN } %s[%d] has warned %s[%d]. Reason: %s [%d/5]",kicker, GetPlayerId(kicker), PlayerName(kicked), kicked, reason, PlayerInfo[kicked][warns]);
	iEcho( string );

	AppendTo(kicklog,messaggio);
	return 1;
}

stock KickReas(kicker[],kicked,reason[])
{
	new messaggio[MAX_STRING], string[MAX_STRING];
	if(IsPlayerConnected(PlayerID(kicker)) && PlayerInfo[PlayerID(kicker)][power]==31337) myStrcpy(kicker,"Unknown Admin");
	format(messaggio,sizeof(messaggio),"(( AdmCmd | %s has kicked %s. Reason: %s ))",kicker,PlayerName(kicked),reason);
	SendClientMessageToAll(COLOR_RED,messaggio);

	format( string, sizeof(string), "4{ KICK } %s[%d] has kicked %s[%d]. Reason: %s %s",kicker, GetPlayerId(kicker), PlayerName(kicked), kicked, reason, TimeDate());
	iEcho( string );
	//==============
	SendClientMessage(kicked,COLOR_RED,"==============================================");
	SendClientMessage(kicked,COLOR_RED,"    You have been kicked from "SERVER_GM"! ");
	SendClientMessage(kicked,COLOR_RED," ");
	SendClientMSG(kicked,COLOR_GREY,"Your IP: %s", PlayerTemp[kicked][IP]);
	SendClientMSG(kicked,COLOR_GREY,"Reason: %s", reason);
	SendClientMSG(kicked,COLOR_GREY,"Kicked by: %s", kicker);
	SendClientMSG(kicked,COLOR_GREY,"Date&Time: %s", TimeDate());
	//SendClientMSG(kicked,COLOR_YELLOW," NOTE: {FF6347}Screenshot is required for ban appeals! ");
	SendClientMessage(kicked,COLOR_RED,"==============================================");
	//==============
	PlayerTemp[kicked][tokick]=1;
	AppendTo(kicklog,messaggio);
	SetTimerEx("ToKick",500,0,"i",kicked);
	ShowInfoBox(kicked, "Kicked", "you have been kicked from the server. you may reconnect by restarting your game.", 60);
	return 1;
}

stock WhiteKick(kicked)
{
	new messaggio[MAX_STRING], string[MAX_STRING];
	format(messaggio,sizeof(messaggio),"(( AdmCmd | SYSTEM has kicked %s. Reason: Not whitelisted ))",PlayerName(kicked));
	SendClientMessageToAll(COLOR_RED,messaggio);

	format( string, sizeof(string), "4{ KICK } SYSTEM has kicked %s[%d]. Reason: Not Whitelisted %s", PlayerName(kicked), kicked, TimeDate());
	iEcho( string );
	//==============
	SendClientMessage(kicked,COLOR_RED,"==============================================");
	SendClientMessage(kicked,COLOR_RED,"    You have been kicked from "SERVER_GM"! ");
	SendClientMessage(kicked,COLOR_RED," ");
	SendClientMSG(kicked,COLOR_GREY,"Your IP: %s", PlayerTemp[kicked][IP]);
	SendClientMSG(kicked,COLOR_GREY,"Reason: Not Whitelisted");
	SendClientMSG(kicked,COLOR_GREY,"Kicked by: SYSTEM");
	SendClientMSG(kicked,COLOR_GREY,"Date&Time: %s", TimeDate());
	//SendClientMSG(kicked,COLOR_YELLOW," NOTE: {FF6347}Screenshot is required for ban appeals! ");
	SendClientMessage(kicked,COLOR_RED,"==============================================");
	//==============
	PlayerTemp[kicked][tokick]=1;
	AppendTo(kicklog,messaggio);
	SetTimerEx("ToKick",500,0,"i",kicked);
	ShowInfoBox(kicked, "Kicked", "you have been kicked from the server.", 60);
	return 1;
}

stock BanReas(banner[],bans,reason[],ipban = 0)
{
	new messaggio[MAX_STRING], string[MAX_STRING];
	if(IsPlayerConnected(PlayerID(banner)) && PlayerInfo[PlayerID(banner)][power]==31337) myStrcpy(banner,"Unknown Admin");
	if(ipban == 0) format(messaggio,sizeof(messaggio),"(( AdmCmd | %s has account banned %s. Reason: %s ))",banner,PlayerName(bans),reason);
	else if(ipban == 1) format(messaggio,sizeof(messaggio),"(( AdmCmd | %s has IP banned %s. Reason: %s ))",banner,PlayerName(bans),reason);
	SendClientMessageToAll(COLOR_RED,messaggio);
	//SendClientMessage(bans,COLOR_YELLOW,"If you think you have been wrongly banned, take a screenshot with F8 and appeal at www.elifegaming.com");
	SendClientMessage(bans,COLOR_RED,"==============================================");
	SendClientMessage(bans,COLOR_RED,"    You have been banned from "SERVER_GM"! ");
	SendClientMessage(bans,COLOR_RED," ");
	SendClientMSG(bans,COLOR_GREY,"Your IP: %s", PlayerTemp[bans][IP]);
	SendClientMSG(bans,COLOR_GREY,"Reason: %s", reason);
	SendClientMSG(bans,COLOR_GREY,"Banned by: %s", banner);
	SendClientMSG(bans,COLOR_GREY,"Date&Time: %s", TimeDate());
	SendClientMSG(bans,COLOR_YELLOW," NOTE: {FF6347}Screenshot is required for ban appeals! ");
	SendClientMessage(bans,COLOR_RED,"==============================================");

	if(ipban == 0) format( string, sizeof(string), "4{ SUSPEND } %s[%d] has suspended %s[%d]. Reason: %s %s",banner, GetPlayerId(banner), PlayerName(bans), bans, reason, TimeDate());
	else if(ipban == 1) format( string, sizeof(string), "4{ IP-BAN } %s[%d] has IP banned %s[%d] (IP: %s). Reason: %s %s",banner, GetPlayerId(banner), PlayerName(bans), bans, PlayerTemp[bans][IP], reason, TimeDate());
	iEcho( string );

	ShowInfoBox(bans, "Banned", "you have been banned from "SERVER_GM"!", 60);

	PlayerInfo[bans][banned]=1;
	myStrcpy(PlayerInfo[bans][banreason], reason);
	PlayerTemp[bans][tokick]=1;
	myStrcpy(glob_toban, PlayerName(bans));
	SetTimerEx("ToSuspend", 4000, false, "d", 1);
	if(ipban == 0) SetTimerEx("ToKick",500,0,"i",bans);
	else SetTimerEx("ToBan",500,0,"is",bans,reason);
	return 1;
}

stock BanReasEx(banner[],bans,days,reason[])
{
	new messaggio[MAX_STRING];
	if(IsPlayerConnected(PlayerID(banner)) && PlayerInfo[PlayerID(banner)][power]==31337) myStrcpy(banner,"Unknown Admin");
	format(messaggio,sizeof(messaggio),"(( AdmCmd | %s suspended %s for %d hours. Reason: %s ))",banner,PlayerName(bans),days,reason);
	SendClientMessageToAll(COLOR_RED,messaggio);
	SendClientMessage(bans,COLOR_RED,"==============================================");
	SendClientMessage(bans,COLOR_RED,"    You have been banned from "SERVER_GM"! ");
	SendClientMessage(bans,COLOR_RED," ");
	SendClientMSG(bans,COLOR_GREY,"Your IP: %s", PlayerTemp[bans][IP]);
	SendClientMSG(bans,COLOR_GREY,"Reason: %s", reason);
	SendClientMSG(bans,COLOR_GREY,"Banned by: %s", banner);
	SendClientMSG(bans,COLOR_GREY,"Date&Time: %s", TimeDate());
	SendClientMSG(bans,COLOR_YELLOW,"You're account will be auto-unbanned in %s hours",days);
	SendClientMessage(bans,COLOR_RED,"==============================================");

	new string[ 164 ];
	format( string, sizeof(string), "4{ TSUSPEND } %s[%d] has suspended %s[%d] for %d hours. Reason: %s %s",banner, GetPlayerId(banner), PlayerName(bans), bans, days, reason, TimeDate());
	iEcho(string);

	ShowInfoBox(bans, "Banned", "you have been banned from "SERVER_GM"!", 60);

	myStrcpy(PlayerInfo[bans][banreason], reason);
	PlayerInfo[bans][tbanned]=now()+days*3600;
	AppendTo(banlog,messaggio);
	PlayerTemp[bans][tokick]=1;
	myStrcpy(glob_toban, PlayerName(bans));
	SetTimerEx("ToSuspend", 4000, false, "d", now()+days*3600);
	SetTimerEx("ToKick",1200,0,"i",bans);
	return 1;
}

stock SetPlayerPaintBall(playerid, tmpid, flag)
{
	new tmpteam;
	if(flag == 666) tmpteam = GetPBFreeSpot(playerid, tmpid);
	else tmpteam = flag;
	if(tmpteam == 0) return 0;
	if(tmpteam == 1)
	{
	    SetPlayerPos(playerid, pb[0][teamred_x], pb[0][teamred_y], pb[0][teamred_z]);
	    SetPlayerFacingAngle(playerid, pb[0][teamred_a]);
	    SetPlayerColor(playerid, COLOR_RED);
	}
	else if(tmpteam == 2)
	{
		SetPlayerPos(playerid, pb[0][teamblue_x], pb[0][teamblue_y], pb[0][teamblue_z]);
	    SetPlayerFacingAngle(playerid, pb[0][teamblue_a]);
	    SetPlayerColor(playerid, COLOR_BLUE);
	}
	ResetPlayerWeaponsEx(playerid);
	GivePlayerWeaponEx(playerid, WEAPON_DEAGLE, 999);
	GivePlayerWeaponEx(playerid, WEAPON_M4, 999);
	GivePlayerWeaponEx(playerid, WEAPON_SNIPER, 450);
	GivePlayerWeaponEx(playerid, WEAPON_MP5, 450);
    SetPlayerVirtualWorld(playerid, tmpid+1);
    SetPlayerInterior(playerid, 10);
    UpdatePBScore(tmpid, PBTeams[PlayerTemp[playerid][onpaint]][redscore], PBTeams[PlayerTemp[playerid][onpaint]][bluescore]);
    return 1;
}

stock GetPBFreeSpot(playerid, bizno)
{
    PlayerTemp[playerid][pbteam] = 0;
	PlayerTemp[playerid][onpaint] = 0;
	if(PBTeams[bizno][redteamcount] >= PBTeams[bizno][blueteamcount])
	{
		PlayerTemp[playerid][onpaint] = bizno;
		PlayerTemp[playerid][pbteam] = 1;
		PBTeams[bizno][blueteamcount]++;
		return 1;
	}
	if(PBTeams[bizno][redteamcount] < PBTeams[bizno][blueteamcount])
	{
	    PlayerTemp[playerid][onpaint] = bizno;
	    PlayerTemp[playerid][pbteam] = 2;
	    PBTeams[bizno][redteamcount]++;
		return 2;
	}
	return 0;
}

stock IsPlayerInPaintball(playerid)
{
	if(PlayerTemp[playerid][onpaint] && PlayerTemp[playerid][pbteam]) return 1;
	return 0;
}

stock UpdatePBScore(bizno, redcount, bluecount)
{
	PBTeams[bizno][redscore] = redcount;
	PBTeams[bizno][redscore] = bluecount;
	return 1;
}

stock StartSpectate(playerid, specid)
{
	PlayerLoop(x)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerTemp[x][spectatingID] == playerid)	AdvanceSpectate(x);
	}
	if(IsPlayerInAnyVehicle(specid))
	{
	    TogglePlayerSpectating(playerid, 1);
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specid));
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(specid));
		PlayerTemp[playerid][spectatingID] = specid;
		PlayerTemp[playerid][specType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else
	{
	    TogglePlayerSpectating(playerid, 1);
	    PlayerSpectatePlayer(playerid, specid);
		SetPlayerInterior(playerid,GetPlayerInterior(specid));
		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(specid));
		PlayerTemp[playerid][spectatingID] = specid;
		PlayerTemp[playerid][specType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	format(iStr,sizeof(iStr),"~n~~n~~n~~n~~n~~n~~n~~n~~g~%s~w~(%d)~n~~w~< Sprint - Jump >", RPName(specid),specid);
	GameTextForPlayer(playerid,iStr,9999999999,3);
	return 1;
}

stock AdvanceSpectate(playerid)
{
    if(ConnectedPlayers() == 2){ StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerTemp[playerid][spectatingID] != INVALID_PLAYER_ID)
	{
	    for(new x = PlayerTemp[playerid][spectatingID]+1; x<=MAX_PLAYERS; x++)
		{
	    	if(x == MAX_PLAYERS) x = 0;
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerTemp[x][spectatingID] != INVALID_PLAYER_ID ||
					(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue; //so ugly
				}
				else
				{
					StartSpectate(playerid, x);
					break; // more ugly :/
				}
			}
		}
	}
	return 1;
}

stock ReverseSpectate(playerid)
{
    if(ConnectedPlayers() == 2){ StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && PlayerTemp[playerid][spectatingID] != INVALID_PLAYER_ID)
	{
	    for(new x=PlayerTemp[playerid][spectatingID]+1; x>=0; x--)
		{
	    	if(x == 0){ x = MAX_PLAYERS; }
	        if(IsPlayerConnected(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && PlayerTemp[x][spectatingID] != INVALID_PLAYER_ID ||
					(GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ConnectedPlayers()
{
	new count;
	PlayerLoop(lolz)
	{
	    if(IsPlayerNPC(lolz)) continue;
	    count++;
	}
	return count;
}

stock Init__Textdraw()
{
	txtAnimHelper = TextDrawCreate(610.0, 400.0, "~p~~k~~PED_ANSWER_PHONE~ ~w~to stop the animation");
	TextDrawUseBox(txtAnimHelper, 0);
	TextDrawFont(txtAnimHelper, 2);
	TextDrawSetShadow(txtAnimHelper,0);
    TextDrawSetOutline(txtAnimHelper,1);
    TextDrawBackgroundColor(txtAnimHelper,0x000000FF);
    TextDrawColor(txtAnimHelper,0xFFFFFFFF);
    TextDrawAlignment(txtAnimHelper,3);

    InjuredTD = TextDrawCreate(331.000000,-8.000000," ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~");
	TextDrawUseBox(InjuredTD,1);
	TextDrawBoxColor(InjuredTD,0xff000066);
	TextDrawTextSize(InjuredTD,590.000000,690.000000);
	TextDrawAlignment(InjuredTD,2);
	TextDrawBackgroundColor(InjuredTD,0x000000ff);
	TextDrawFont(InjuredTD,3);
	TextDrawLetterSize(InjuredTD,1.000000,1.000000);
	TextDrawColor(InjuredTD,0xffffffff);
	TextDrawSetOutline(InjuredTD,1);
	TextDrawSetProportional(InjuredTD,1);
	TextDrawSetShadow(InjuredTD,1);


	TextDraw__News = TextDrawCreate(314.000000,429.000000,"~w~There is nothing new at this moment!");
	TextDrawUseBox(TextDraw__News,1);
	TextDrawBoxColor(TextDraw__News,0x00000033);
	TextDrawTextSize(TextDraw__News,0.000000,892.000000);
	TextDrawAlignment(TextDraw__News,2);
	TextDrawBackgroundColor(TextDraw__News,0x00000033);
	TextDrawFont(TextDraw__News,1);
	TextDrawLetterSize(TextDraw__News,0.199999,1.400000);
	TextDrawColor(TextDraw__News,0xffffffff);
	TextDrawSetOutline(TextDraw__News,1);
	TextDrawSetProportional(TextDraw__News,1);
	TextDrawSetShadow(TextDraw__News,1);

	IMtxt = TextDrawCreate(576.000000,25.000000,"11/11/2011~n~15:01");
	TextDrawAlignment(IMtxt,2);
	TextDrawBackgroundColor(IMtxt,0x000000ff);
	TextDrawFont(IMtxt,3);
	TextDrawLetterSize(IMtxt,0.299999,1.000000);
	TextDrawColor(IMtxt,0xffffffff);
	TextDrawSetOutline(IMtxt,1);
	TextDrawSetProportional(IMtxt,1);
	TextDrawSetShadow(IMtxt,1);

	TellTD = TextDrawCreate(315.000000,126.000000,"Nothing really ..");
	TextDrawAlignment(TellTD,2);
	TextDrawBackgroundColor(TellTD,0x000000ff);
	TextDrawFont(TellTD,2);
	TextDrawLetterSize(TellTD,0.499999,1.800001);
	TextDrawColor(TellTD,0xffffffff);
	TextDrawSetProportional(TellTD,1);
	TextDrawSetShadow(TellTD,1);

	PeaceZone = TextDrawCreate(471.000000,101.000000,"~r~no-shooting zone");
	TextDrawAlignment(PeaceZone,0);
	TextDrawBackgroundColor(PeaceZone,0xffffff33);
	TextDrawFont(PeaceZone,2);
	TextDrawLetterSize(PeaceZone,0.399999,1.699999);
	TextDrawColor(PeaceZone,0xffffffff);
	TextDrawSetOutline(PeaceZone,1);
	TextDrawSetProportional(PeaceZone,1);
	TextDrawSetShadow(PeaceZone,1);

	for(new i; i < MAX_PLAYERS; i++)
	{
	    new playerid = i;

		PlayerTemp[playerid][Status] = TextDrawCreate(551.000000,389.000000, "~g~Speed: ~w~150km/h~n~~g~Fuel: ~w~100%~n~~g~Health: ~w~100%~n~~g~Mileage: ~w~150,000km~n~~g~Doors: ~g~Locked");
		TextDrawUseBox(PlayerTemp[playerid][Status],1);
		TextDrawBoxColor(PlayerTemp[playerid][Status],0x00000033);
		TextDrawTextSize(PlayerTemp[playerid][Status],750.000000,10.000000);
		TextDrawAlignment(PlayerTemp[playerid][Status],0);
		TextDrawBackgroundColor(PlayerTemp[playerid][Status],0x00000033);
		TextDrawFont(PlayerTemp[playerid][Status],1);
		TextDrawLetterSize(PlayerTemp[playerid][Status],0.199999,0.799999);
		TextDrawColor(PlayerTemp[playerid][Status],0xffffffff);
		TextDrawSetOutline(PlayerTemp[playerid][Status],1);
		TextDrawSetProportional(PlayerTemp[playerid][Status],1);
		TextDrawSetShadow(PlayerTemp[playerid][Status],3);

		PlayerTemp[playerid][InfoBoxTitle] = TextDrawCreate(21.000000, 152.000000,"Box Title Here");
		TextDrawAlignment(PlayerTemp[playerid][InfoBoxTitle],0);
		TextDrawBackgroundColor(PlayerTemp[playerid][InfoBoxTitle],0x000000ff);
		TextDrawFont(PlayerTemp[playerid][InfoBoxTitle],0);
		TextDrawLetterSize(PlayerTemp[playerid][InfoBoxTitle],0.599999,2.200000);
		TextDrawSetProportional(PlayerTemp[playerid][InfoBoxTitle],1);
		TextDrawSetOutline(PlayerTemp[playerid][InfoBoxTitle],1);
		TextDrawColor(PlayerTemp[playerid][InfoBoxTitle],0xffffffff);
		
		PlayerTemp[playerid][InfoBox] = TextDrawCreate(21.000000, 167.500000,"~n~here goes your text~n~text~n~text");
		TextDrawUseBox(PlayerTemp[playerid][InfoBox],1);
		TextDrawBoxColor(PlayerTemp[playerid][InfoBox],0x00000099);
		TextDrawTextSize(PlayerTemp[playerid][InfoBox],180.000000,0.000000);
		TextDrawAlignment(PlayerTemp[playerid][InfoBox],0);
		TextDrawBackgroundColor(PlayerTemp[playerid][InfoBox],0x00000033);
		TextDrawFont(PlayerTemp[playerid][InfoBox],2);
		TextDrawLetterSize(PlayerTemp[playerid][InfoBox],0.199999,1.199999);
		TextDrawColor(PlayerTemp[playerid][InfoBox],0xffffffff);
		TextDrawSetOutline(PlayerTemp[playerid][InfoBox],1);
		TextDrawSetProportional(PlayerTemp[playerid][InfoBox],1);

		PlayerTemp[playerid][Cargo] = TextDrawCreate(94.000000,303.000000,"~g~Cargo:~n~~w~5000kg of fish");
		TextDrawUseBox(PlayerTemp[playerid][Cargo],1);
		TextDrawBoxColor(PlayerTemp[playerid][Cargo],0xffffff33);
		TextDrawTextSize(PlayerTemp[playerid][Cargo],3.000000,139.000000);
		TextDrawAlignment(PlayerTemp[playerid][Cargo],2);
		TextDrawBackgroundColor(PlayerTemp[playerid][Cargo],0x00000066);
		TextDrawFont(PlayerTemp[playerid][Cargo],2);
		TextDrawLetterSize(PlayerTemp[playerid][Cargo],0.299999,1.600001);
		TextDrawColor(PlayerTemp[playerid][Cargo],0xffffffff);
		TextDrawSetOutline(PlayerTemp[playerid][Cargo],1);
		TextDrawSetProportional(PlayerTemp[playerid][Cargo],1);
		TextDrawSetShadow(PlayerTemp[playerid][Cargo],1);
		
		PlayerTemp[playerid][Harvest] = TextDrawCreate(94.000000,271.000000,"~y~harvested:~n~~w~x/14");
		TextDrawUseBox(PlayerTemp[playerid][Harvest],1);
		TextDrawBoxColor(PlayerTemp[playerid][Harvest],0xffffff33);
		TextDrawTextSize(PlayerTemp[playerid][Harvest],0.000000,139.000000);
		TextDrawAlignment(PlayerTemp[playerid][Harvest],2);
		TextDrawBackgroundColor(PlayerTemp[playerid][Harvest],0x00000066);
		TextDrawFont(PlayerTemp[playerid][Harvest],2);
		TextDrawLetterSize(PlayerTemp[playerid][Harvest],0.399999,1.500000);
		TextDrawColor(PlayerTemp[playerid][Harvest],0xffffffff);
		TextDrawSetOutline(PlayerTemp[playerid][Harvest],1);
		TextDrawSetProportional(PlayerTemp[playerid][Harvest],1);
		TextDrawSetShadow(PlayerTemp[playerid][Harvest],1);

		PlayerTemp[playerid][plrwarning] = TextDrawCreate(314.000000,401.000000,"~r~warning goes here");
		TextDrawAlignment(PlayerTemp[playerid][plrwarning],2);
		TextDrawBackgroundColor(PlayerTemp[playerid][plrwarning],0x000000cc);
		TextDrawFont(PlayerTemp[playerid][plrwarning],2);
		TextDrawLetterSize(PlayerTemp[playerid][plrwarning],0.299999,1.700000);
		TextDrawColor(PlayerTemp[playerid][plrwarning],0xffffffff);
		TextDrawSetOutline(PlayerTemp[playerid][plrwarning],1);
		TextDrawSetProportional(PlayerTemp[playerid][plrwarning],1);
		TextDrawSetShadow(PlayerTemp[playerid][plrwarning],1);

		PlayerTemp[playerid][jailtd] = TextDrawCreate(314.000000,401.000000,"~r~warning goes here");
		TextDrawAlignment(PlayerTemp[playerid][jailtd],2);
		TextDrawBackgroundColor(PlayerTemp[playerid][jailtd],0x000000cc);
		TextDrawFont(PlayerTemp[playerid][jailtd],2);
		TextDrawLetterSize(PlayerTemp[playerid][jailtd],0.299999,1.700000);
		TextDrawColor(PlayerTemp[playerid][jailtd],0xffffffff);
		TextDrawSetOutline(PlayerTemp[playerid][jailtd],1);
		TextDrawSetProportional(PlayerTemp[playerid][jailtd],1);
		TextDrawSetShadow(PlayerTemp[playerid][jailtd],1);

		PlayerTemp[playerid][LocationTD] = TextDrawCreate(88.000000,429.000000,"lollocation here");
		TextDrawAlignment(PlayerTemp[playerid][LocationTD],2);
		TextDrawBackgroundColor(PlayerTemp[playerid][LocationTD],0x000000ff);
		TextDrawFont(PlayerTemp[playerid][LocationTD],2);
		TextDrawLetterSize(PlayerTemp[playerid][LocationTD],0.199999,1.200000);
		TextDrawColor(PlayerTemp[playerid][LocationTD],0xffffffff);
		TextDrawSetOutline(PlayerTemp[playerid][LocationTD],1);
		TextDrawSetProportional(PlayerTemp[playerid][LocationTD],1);
		TextDrawSetShadow(PlayerTemp[playerid][LocationTD],1);
	}
	return 1;
}

stock APayDay(forcer[])
{
	#pragma unused forcer
	paycheck = 1;
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(BusinessInfo[b][bLastRob] > 0) BusinessInfo[b][bLastRob]--;
	    new businessType = BusinessInfo[b][bType];
	    new incomeHourly = 8000;
	    if(businessType == BUSINESS_TYPE_BANK) continue;

		if(businessType == BUSINESS_TYPE_247
		|| businessType == BUSINESS_TYPE_CLOTHES) incomeHourly = 125;
		
		if(businessType == BUSINESS_TYPE_HARDWARE) incomeHourly = 135;
		
		if(businessType == BUSINESS_TYPE_CLUB
		|| businessType == BUSINESS_TYPE_PUB
		|| businessType == BUSINESS_TYPE_STRIPCLUB
		|| businessType == BUSINESS_TYPE_RESTAURANT
		|| businessType == BUSINESS_TYPE_PIZZA
		|| businessType == BUSINESS_TYPE_BURGER
		|| businessType == BUSINESS_TYPE_CHICKEN
		|| businessType == BUSINESS_TYPE_CAFE) incomeHourly = 115;
		
	    if(businessType == BUSINESS_TYPE_CASINO) incomeHourly = 230;
		
	    if(businessType == BUSINESS_TYPE_GAS) incomeHourly = 145;
		
	    if(businessType == BUSINESS_TYPE_BIKE_DEALER
	    || businessType == BUSINESS_TYPE_HEAVY_DEALER
	    || businessType == BUSINESS_TYPE_CAR_DEALER
	    || businessType == BUSINESS_TYPE_LUXUS_DEALER
	    || businessType == BUSINESS_TYPE_NOOB_DEALER
	    || businessType == BUSINESS_TYPE_AIR_DEALER
		|| businessType == BUSINESS_TYPE_BOAT_DEALER
		|| businessType == BUSINESS_TYPE_JOB_DEALER) incomeHourly = 140;
	    
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
			SendClientMessageToTeam(PlayerInfo[f][playerteam], iReason, COLOR_PLAYER_VLIGHTBLUE);
		}
	}
	new gov_TaxIncome[MAX_FACTIONS], faction_PayCheckOutcome[MAX_FACTIONS];
	PlayerLoop(i)
	{
		if(PlayerTemp[i][loggedIn])
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
			if((PlayerInfo[i][rpoints] / 2) >= PlayerInfo[i][playerlvl] && PlayerInfo[i][playerlvl] > 5)
			{
				PlayerInfo[i][playerlvl]++;
				PlayerInfo[i][rpoints]=0;
				SetPlayerScore(i,PlayerInfo[i][playerlvl]);
				MessagePayDay(i,PlayerInfo[i][rpoints],PlayerInfo[i][playerlvl],PlayerInfo[i][rentprice],PlayerInfo[i][playertime], PlayerInfo[i][fpay]);
				SendClientMessage(i,COLOR_GREEN,"[PayTime] You have levelled up!");
			}
			if(PlayerInfo[i][rpoints] >= 9 && PlayerInfo[i][playerlvl] <= 5)
			{
				PlayerInfo[i][playerlvl]++;
				PlayerInfo[i][rpoints]=0;
				SetPlayerScore(i,PlayerInfo[i][playerlvl]);
				MessagePayDay(i,PlayerInfo[i][rpoints],PlayerInfo[i][playerlvl],PlayerInfo[i][rentprice],PlayerInfo[i][playertime], PlayerInfo[i][fpay]);
			    SendClientMessage(i,COLOR_GREEN,"[PayTime] You have levelled up!");
			}
			else
			{
				if(PlayerInfo[i][bank] < 750000000) PlayerInfo[i][bank]=PlayerInfo[i][bank]+(PlayerInfo[i][bank]/700);
				else PlayerInfo[i][bank] = PlayerInfo[i][bank]+(750000000/700);
				MessagePayDay(i,PlayerInfo[i][rpoints],PlayerInfo[i][playerlvl],PlayerInfo[i][rentprice],PlayerInfo[i][playertime], PlayerInfo[i][fpay]);
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
				if(HouseInfo[houseid][hActive] == true && houseid >= 0 && houseid < MAX_HOUSES)
				{
					HouseInfo[houseid][hTill] += PlayerInfo[i][rentprice];
					SaveHouse(houseid);
				}
				else
				{
					PlayerInfo[i][housenum] = -1;
				}
		    }
		   	GameTextForPlayer(i,"~w~Pay~p~Time",3000,1);
			PlayerInfo[i][playertime]=0;
			PlayerInfo[i][totalpayt]++;
		}
		else SendClientMessage(i,COLOR_YELLOW,"[SERVER] You are not authed, nothing PayDay");
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
	return 1;
}

stock MessagePayDay(playerid, rpoints2, level2, rentprice2, playertime2, fpay2 = 0)
{
	new eInterests = (PlayerInfo[playerid][bank]/500);
	SendClientMessage(playerid, 0xB8E65CFF, "|--------------------------[PayCheck Information]--------------------------|");
	SendClientMSG(playerid, COLOR_WHITE, " - Name: {DBFF94}%s", RPName(playerid));
	SendClientMSG(playerid, COLOR_WHITE, " - Paycheck: {DBFF94}$%s", number_format(playertime2));
	SendClientMSG(playerid, COLOR_WHITE, " - Level: {DBFF94}%d", level2);
	SendClientMSG(playerid, COLOR_WHITE, " - R-Points: {DBFF94}%d",rpoints2);

	if(PlayerInfo[playerid][housenum] != -1) SendClientMSG(playerid, COLOR_WHITE, " - Rent: {DBFF94}-$%s", number_format(rentprice2));
	if(fpay2 != 0) SendClientMSG(playerid, COLOR_WHITE, " - Faction: {DBFF94}$%s", number_format(fpay2));

	SendClientMSG(playerid, COLOR_WHITE, " - Interests: {DBFF94}+$%s - {FFFFFF}Balance: {DBFF94}$%s", number_format(eInterests), number_format(PlayerInfo[playerid][bank]));
	SendClientMessage(playerid, 0xB8E65CFF, "|--------------------------------------------------------------------------------------|");
	return 1;
}

/*stock MessagePayDay(playerid)
{
	new tax = dini_Int(globalstats,"tax");
	new totalToTake;
	new intrestRate = 500;
	new PlayerPayCheck = PAYTIME_DEFAULT_PAYCHECK,
		PlayerPoints = PlayerInfo[playerid][rpoints],
		PlayerLevel = PlayerInfo[playerid][playerlvl],
		PlayerRentPrice = PlayerInfo[playerid][rentprice],
		PlayerPlayTime = PlayerInfo[playerid][playertime],
		PlayerFactionPay = PlayerInfo[playerid][fpay],
		PlayerInterests = (PlayerInfo[playerid][bank] / intrestRate);
	new vehicleTax = GetPlayerVehicles(playerid) * PAYTIME_VEH_TAX,
		businessTax = GetPlayerBusinesses(playerid) * PAYTIME_BIZ_TAX,
		houseTax = GetPlayerHouses(playerid) * PAYTIME_HOUSE_TAX;
	totalToTake = vehicleTax;
	totalToTake = totalToTake + businessTax;
	totalToTake = totalToTake + houseTax;
	totalToTake = totalToTake + PlayerRentPrice;
	totalToTake = totalToTake + tax;

	SendClientMessage(playerid, 0xB8E65CFF, "|--------------------------[PayCheck Information]--------------------------|");

	SendClientMSG(playerid, COLOR_WHITE, " - Name: {DBFF94}%s", RPName(playerid));
	SendCLientMSG(playerid, COLOR_WHITE, " - Paycheck: {DBFF94}$%s", number_format(PlayerPayCheck));
	SendClientMSG(playerid, COLOR_WHITE, " - R-Points: {DBFF94}%d", PlayerPoints);

	if(GetPlayerBusinesses(playerid) >= 1)
	{
		SendClientMSG(playerid, COLOR_WHITE, " - Business Tax: {DBFF94}$%s", number_format(businessTax));
	}

	if(GetPlayerHouses(playerid) >= 1)
	{
		SendClientMSG(playerid, COLOR_WHITE, " - Housing Tax: {DBFF94}$%s", number_format(houseTax));
	}

	if(GetPlayerVehicles(playerid) >= 1)
	{
		SendClientMSG(playerid, COLOR_WHITE, " - Vehicle Tax: {DBFF94}$%s", number_format(vehicleTax));
	}

	SendClientMSG(playerid, COLOR_WHITE, " - Interests: {DBFF94}+$%s - {FFFFFF}Balance: {DBFF94}$%s", number_format(PlayerInterests), number_format(PlayerInfo[playerid][bank]));
	SendClientMessage(playerid, 0xB8E65CFF, "|--------------------------------------------------------------------------------------|");
	GivePlayerMoneyEx(playerid, -totalToTake);
	return 1;
}*/

stock IsARolePlayName(name[])
{
	new szLastCell, bool:bUnderScore;
	for(new i; i < strlen(name); i++)
	{
		if(name[i] == '_')
		{
			if(bUnderScore == true) return 0;
			bUnderScore = true;
		}
		else if(!szLastCell || szLastCell == '_')
		{
			if(name[i] < 'A' || name[i] > 'Z') return 0;
		}
		else
		{
			if(name[i] < 'a' || name[i] > 'z') return 0;
		}
		szLastCell = name[i];
	}
	if(bUnderScore == false) return 0;	
	return 1;
}

stock RegisterResponse(playerid, params[])
{
    if(PlayerTemp[playerid][loggedIn]) return SendClientMessage(playerid,COLOR_SYSTEM_GM,"Already authed.");
	if(strlen(params) > 40 || strlen(params) < 5 || !strlen(params))
	{
		SendClientError(playerid, "Invalid password attempt, please try again.");
		ShowDialog(playerid, DIALOG_REGISTER);
	 	return 1;
	}
	else
	{
		new iQuery[528];
		WP_Hash(PlayerTemp[playerid][ppassword], 129, params);
	    mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `PlayerInfo` (`PlayerName`, `Password`) VALUES ('%e', '%s')", PlayerName(playerid), PlayerTemp[playerid][ppassword]);
	    mysql_tquery(MySQLPipeline, iQuery);
		new string[ 128 ];
		format(string, sizeof(string), "3[ REGISTER ] %s[%d] has registered.", PlayerName(playerid), playerid);
		iEcho(string);
        ShortCutLoad(playerid);
	}
    return true;
}

stock ShortCutLoad(playerid)
{
	SetTimerEx("ShortCutLoadEx", 500, false, "i", playerid);
	return 1;
}

stock LoginResponse(playerid, params[])
{
	if(PlayerTemp[playerid][loggedIn]) return SendClientMessage(playerid,COLOR_SYSTEM_GM,"Already authed.");
	if(strlen(params) > 40 || strlen(params) < 5 || !strlen(params))
	{
	    SendClientMessage(playerid,COLOR_SYSTEM_GM," Invalid password!");
	    ShowDialog(playerid, DIALOG_LOGIN);
		return 1;
	}
	new hashPass[129];
	WP_Hash(hashPass, 129, params);
	if(!strcmp(hashPass, PlayerTemp[playerid][ppassword]))
		return ShortCutLoad(playerid);
	else
	{
	    new string[ 128 ];
		format(string, sizeof(string), "7[ LOGIN ] %s[%d] has failed to log in.", PlayerName(playerid), playerid);
		iEcho(string);
		PlayerTemp[playerid][WrongPass]++;
		if(PlayerTemp[playerid][WrongPass] >= 3)
		{
			format(string, sizeof(string), "%s has been kicked. INVALID_PASS!", PlayerName(playerid));
	     	AdminNotice(string);
			SendClientMessage(playerid, COLOR_GREEN,"==================================================================================");
			SendClientMessage(playerid, COLOR_GREEN," - "SERVER_GM" // Invalid password attempts reached.");
			SendClientMessage(playerid, COLOR_GREEN,"==================================================================================");
		    PlayerTemp[playerid][WrongPass] = 0;
		    Kick(playerid);
			return 1;
		}
		ShowDialog(playerid, DIALOG_LOGIN);
		return 1;
	}
}

stock SetBank(sender[], receiver[], amount)
{
	new playerid = GetPlayerId(sender), playerID = GetPlayerId(receiver);
	if(IsPlayerConnected(playerid))
	{
		new stringa[MAX_STRING];
		GivePlayerMoneyEx(playerid, -amount);
		if(IsPlayerConnected(playerID))
		{
			PlayerInfo[playerID][bank] += amount;
			format(stringa, sizeof(stringa), "%s has transfered $%s to your bank account. Previous Balance: $%s | New Balance: $%s.", NoUnderscore(sender), number_format(amount), number_format(PlayerInfo[playerID][bank] - amount), number_format(PlayerInfo[playerID][bank]));
			SendClientMessage(playerID, COLOR_YELLOW, stringa);
		}
		else
		{
			new iQuery[250];
			mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `Money` = `Money` + %d WHERE `PlayerName` = '%e'", amount, receiver);
			mysql_tquery(MySQLPipeline, iQuery);
		}
		format(stringa, sizeof(stringa), "You have transfered $%s to %s.", number_format(amount), NoUnderscore(receiver));
		SendClientMessage(GetPlayerId(sender), COLOR_YELLOW, stringa);
	}
	return 1;
}

stock bool:IsPlayerAuthed(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerTemp[playerid][loggedIn] != false) return true;
	}
	return false;
}

/*
stock SetBank(sender[], reciever[], amount, message[]) // SetBank("Marcio_Sindaco", "Marcus_Vanderbilt", 15000000, "Marcio Sindaco bought your Cheetah for a price of $15,000,000!");
{
	new recieverid = GetPlayerID(reciever), senderid = GetPlayerID(sender);
	if(IsPlayerConnected(recieverid) && PlayerTemp[recieverid][loggedIn] != false) // online & logged in
	{
		PlayerInfo[recieverid][bank] += amount;
		if(IsPlayerConnected(senderid) && PlayerTemp[senderid][loggedIn] != false)
	}
	else // offline
	{
	
	}
	return 1;
}
*/

stock SendRadioMessage(frequence,text[],colore)
{
    for(new i = 0; i <= MAX_PLAYERS; i ++)
	{
        if(IsPlayerConnected(i) && PlayerTemp[i][loggedIn])
		{
            if(frequence == PlayerInfo[i][freq1] || frequence == PlayerInfo[i][freq2] || frequence == PlayerInfo[i][freq3])
				SendClientMessage(i, colore, text);
        }
    }
    return 1;
}

stock GetSlotByFreq(playerid,freq)
{
	if(PlayerInfo[playerid][freq1] == freq) return 1;
	if(PlayerInfo[playerid][freq2] == freq) return 2;
	if(PlayerInfo[playerid][freq3] == freq) return 3;
	return 0;
}

stock SendClientMessageToTeam(team, text[], colore)
{
	if(FactionInfo[team][fActive] != true) return 0;
	PlayerLoop(i)
	{
		if(PlayerTemp[i][loggedIn])
		{
	    	if (team == PlayerInfo[i][playerteam]) SendClientMessage(i, colore, text);
		}
    }
    return 1;
}

stock SendClientMessageToAdmins(text[],colore)
{
    PlayerLoop(i)
	{
		if(PlayerTemp[i][loggedIn])
		{
	    	if (PlayerInfo[i][power]) SendClientMessage(i, colore, text);
		}
    }
    return 1;
}

stock IsPlayerOutBiz(playerid, extra = 0)
{
	new temp = -1, iSize;
	if(extra) iSize = 5;
	else iSize = 2;
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
		if(GetPlayerVirtualWorld(playerid) != BusinessInfo[b][bVirtualWorld] || GetPlayerInterior(playerid) != BusinessInfo[b][bInterior]) continue;
	    if(IsPlayerInRangeOfPoint(playerid, iSize, BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ])) return b;
	}
	return temp;
}

stock IsPlayerInBiz(playerid, Float:iRange = 10.0)
{
	LOOP:b(0, MAX_BUSINESS)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
		new bizInte = GetRealBusinessID(b);
		if(GetPlayerVirtualWorld(playerid) != b+1 || GetPlayerInterior(playerid) != BusinessInteriors[bizInte][enterInt]) continue;
		if(IsPlayerInRangeOfPoint(playerid, iRange, BusinessInteriors[bizInte][enterX], BusinessInteriors[bizInte][enterY], BusinessInteriors[bizInte][enterZ])) return b;
	}
	return -1;
}

stock AntiDeAMX()
{
    new a[][] =
	{
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

stock encode_tires(tire1, tire2, tire3, tire4)
{
	return tire1 | (tire2 << 1) | (tire3 << 2) | (tire4 << 3);
}

stock CheckWeapons(reason)
{
	new fuck=1;
	for(new a=0;a<sizeof(allweps);a++)	if(allweps[a][0]==reason) fuck=0;
	return fuck;
}

stock ShowMenuID(playerid)
{
	ShowDialog(playerid, DIALOG_LAPTOP);
	return 1;
}

stock AppendTo(filename[],string[])
{
	if(!fexist(filename))
	{
		new File:myfile=fopen(filename,io_write);
		fclose(myfile);
	}
	new File:myfile=fopen(filename,io_append);
	new timestring[MAX_STRING];
	new hour,minu,seco,giorno,mese,anno;
	gettime(hour,minu,seco); getdate(anno,mese,giorno);
	format(timestring,sizeof(timestring),"[%d:%d:%d/%d-%d-%d]%s\r\n",hour,minu,seco,giorno,mese,anno,string);
	fwrite(myfile,timestring);
	fclose(myfile);
	return 1;
}

stock SetTax(type,amount)
{
	if(type >= 0) return BusinessInfo[type][bTax] = amount;
	if(type<0)
	{
		switch(type)
		{
		    case -1: dini_IntSet(globalstats,"calls",amount);
		    case -2: dini_IntSet(globalstats,"sms",amount);
		    case -3: dini_IntSet(globalstats,"medicals",amount);
		    case -4: dini_IntSet(globalstats,"tax",amount);
		    case -5: dini_IntSet(globalstats,"ad",amount);
		}
	}
	return 1;
}

stock GlobalFiles()
{
	if(!dini_Exists(globalstats))
	{
		dini_Create(globalstats);
		dini_IntSet(globalstats,"medicals", 250);
		dini_IntSet(globalstats,"sms", 1);
		dini_IntSet(globalstats,"calls", 5);
		dini_IntSet(globalstats,"ad", minrand(100,500));
		dini_IntSet(globalstats,"tax",minrand(50,150));
		printf("%s created\n",globalstats);
	}
	if(!dini_Exists(elections))
	{
	    dini_Create(elections);
	    dini_IntSet(elections,"polltime",0);
	    dini_Set(elections,"democratic","None");
	    dini_Set(elections,"republican","None");
	    dini_IntSet(elections,"candidates",0);
	    dini_IntSet(elections,"pollend",0);
	    dini_IntSet(elections,"end",0);
	    dini_IntSet(elections,"pollnumber",1);
	    dini_IntSet(elections,"demvotes",0);
	    dini_IntSet(elections,"repvotes",0);
	    dini_BoolSet(elections,"systemactive",false);
	    printf("%s created\n",elections);
	 }
	if(!dini_Exists(compsfile))
	{
		dini_Create(compsfile);
	 	dini_IntSet(compsfile,"whguns",1000);
	 	dini_IntSet(compsfile,"whstuffs",500);
	 	dini_IntSet(compsfile,"whcars",500);
	 	dini_IntSet(compsfile,"whalchool",500);
	 	dini_IntSet(compsfile,"stuffs",1000);
	 	dini_IntSet(compsfile,"guns",1000);
	 	dini_IntSet(compsfile,"alchool",1000);
	 	dini_IntSet(compsfile,"cars",1000);
	 	dini_IntSet(compsfile,"drugs",200);
	 	dini_IntSet(compsfile,"oil",500);
	 	dini_IntSet(compsfile,"money",500);
	 	dini_IntSet(compsfile,"gunsbuyprice",300);
	 	dini_IntSet(compsfile,"gunssellprice",850);
	 	dini_IntSet(compsfile,"stuffsbuyprice",300);
	 	dini_IntSet(compsfile,"stuffssellprice",300);
	 	dini_IntSet(compsfile,"alchoolbuyprice",300);
	 	dini_IntSet(compsfile,"alchoolsellprice",300);
	 	dini_IntSet(compsfile,"drugsbuyprice",300);
	 	dini_IntSet(compsfile,"drugssellprice",300);
	 	dini_IntSet(compsfile,"oilbuyprice",300);
	 	dini_IntSet(compsfile,"oilsellprice",300);
	 	dini_IntSet(compsfile,"carsbuyprice",300);
	 	dini_IntSet(compsfile,"carssellprice",300);
	 	dini_IntSet(compsfile,"wharehouse",300);
		printf("%s created\n",compsfile);
	}
	if(!dini_Exists(warfile))
	{
		dini_Create(warfile);
	    dini_IntSet(warfile, "faction1", -1);
	    dini_IntSet(warfile, "faction2", -1);
	    dini_IntSet(warfile, "faction1points", -1);
	    dini_IntSet(warfile, "faction2points", -1);
	    dini_IntSet(warfile, "pointsgoal", -1);
	    printf("%s created\n", warfile);
	}
	if(!dini_Isset(compsfile,"fgunstock")) dini_IntSet(compsfile, "fgunstock", 200);
	if(!dini_Isset(compsfile,"fgunbullets")) dini_IntSet(compsfile, "fgunbullets", 200);
	return 1;
}

stock ResetWar()
{
    dini_Create(warfile);
    dini_IntSet(warfile, "faction1", -1);
    dini_IntSet(warfile, "faction2", -1);
    dini_IntSet(warfile, "faction1points", -1);
    dini_IntSet(warfile, "faction2points", -1);
    dini_IntSet(warfile, "pointsgoal", -1);
}

stock StartWar(faction1, faction2, goal)
{
    dini_IntSet(warfile, "faction1", faction1);
    dini_IntSet(warfile, "faction2", faction2);
    dini_IntSet(warfile, "faction1points", 0);
    dini_IntSet(warfile, "faction2points", 0);
    dini_IntSet(warfile, "pointsgoal", goal);
}

stock WarInfo(playerid)
{
	if(dini_Int(warfile, "faction1") != -1)
	{
	    new string[ 164 ],
			factionex1 = dini_Int(warfile,"faction1"),
			factionex2 = dini_Int(warfile,"faction2");

		SendClientMessage(playerid, COLOR_HELPEROOC, "======== THERE IS CURRENTLY A WAR GOING ON! =========");
	    format(string, sizeof(string), " %s vs. %s", FactionInfo[factionex1][fName], FactionInfo[factionex2][fName]);
	    SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	    format(string, sizeof(string), " %s points: %d", FactionInfo[factionex1][fName], dini_Int(warfile, "faction1points"));
	    SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	    format(string, sizeof(string), " %s points: %d", FactionInfo[factionex2][fName], dini_Int(warfile, "faction2points"));
	    SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	    format(string, sizeof(string), " Points needed: %d", dini_Int(warfile, "pointsgoal"));
	    SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	    SendClientMessage(playerid, COLOR_HELPEROOC, "====================================================");
	    return 1;
	}
	else return SendClientInfo(playerid, "There is no war at the moment.");
}

stock UpdateWar(playerid, killerid)
{
	new winpoints;
	switch(PlayerInfo[playerid][ranklvl])
	{
		case 0: winpoints = 10;
		case 1: winpoints = 5;
	    case 2: winpoints = 2;
	    default: winpoints = 1;
	}
	if(PlayerInfo[killerid][playerteam] == dini_Int(warfile,"faction1") && PlayerInfo[playerid][playerteam] == dini_Int(warfile,"faction2"))
		dini_IntSet(warfile, "faction1points", dini_Int(warfile,"faction1points") + winpoints);
	else if(PlayerInfo[killerid][playerteam] == dini_Int(warfile,"faction2") && PlayerInfo[playerid][playerteam] == dini_Int(warfile,"faction1"))
		dini_IntSet(warfile, "faction2points", dini_Int(warfile,"faction2points") + winpoints);
	CheckWar();
	return 1;
}

stock bool:IsPlayerInWar(playerid)
{
	new iFaction = PlayerInfo[playerid][playerteam];
	if(iFaction == CIV) return false;
	if(dini_Int(warfile,"faction1") == -1 || dini_Int(warfile,"faction2") == -1) return false;
	if(iFaction == dini_Int(warfile,"faction1") || iFaction == dini_Int(warfile,"faction2")) return true;
	return false;
}

stock CheckWar()
{
    if(dini_Int(warfile, "faction1") != -1)
	{
		new wWINNER = -1, wLOSER = -1, factionex1 = dini_Int(warfile,"faction1"), factionex2 = dini_Int(warfile,"faction2");
		if(	dini_Int(warfile, "faction1points") >= dini_Int(warfile, "pointsgoal") )
		{
		    wWINNER = factionex1;
		    wLOSER = factionex2;
		}
		if(	dini_Int(warfile, "faction2points") >= dini_Int(warfile, "pointsgoal") )
		{
		    wWINNER = factionex2;
		    wLOSER = factionex1;
		}
		if(wWINNER != -1)
		{
		    new string[ 128 ];
		    format(string, sizeof(string), "..:: [ WAR INFORMATION ] %s has won the ongoing war! ::..", FactionInfo[wWINNER][fName]);
		    SendClientMessageToAll(COLOR_HELPEROOC, string);
			FactionInfo[wLOSER][fPoints] -= dini_Int(warfile, "pointsgoal");
			FactionInfo[wWINNER][fPoints] += dini_Int(warfile, "pointsgoal");
		    GameTextForAll("WAR OVER!", 5000, 3);
		    ResetWar();
		}
	}
}

stock Jail(playerid, time, bailcost, reason[])
{
	PlayerTemp[playerid][cuffed] = false;
	PlayerTemp[playerid][tazed] = 0;
	new id = random(sizeof(PrisonCells));
	SetPlayerPos(playerid, PrisonCells[id][0], PrisonCells[id][1], PrisonCells[id][2]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	PlayerTemp[playerid][imprisoned] = 1;
	format(PlayerInfo[playerid][jailreason], 128, "%s", reason);
	SetPlayerWantedLevel(playerid, 0);
	PlayerInfo[playerid][jailtime] = time;
	PlayerInfo[playerid][jail] = 1;
	PlayerInfo[playerid][bail] = bailcost;
	if(bailcost != 777) GivePlayerMoneyEx(playerid,-PlayerInfo[playerid][bail]);
	ResetPlayerWeaponsEx(playerid);
	format(iStr,sizeof(iStr),"[JAIL] You have been jailed for %d minutes! Reason: %s",time/60, PlayerInfo[playerid][jailreason]);
	SendPlayerMessage(playerid, COLOR_RED, iStr, "[JAIL]");
	return 1;
}

stock UnJail(playerid)
{
	PlayerInfo[playerid][jailtime] = 0;
	GivePlayerMoneyEx(playerid, PlayerInfo[playerid][bail]);
	format(PlayerInfo[playerid][jailreason], 128, "None");
 	PlayerInfo[playerid][bail] = 0;
 	TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid,COLOR_GREEN,"[JAIL] You have been unjailed, please behave!");
	SpawnPlayer(playerid);
	PlayerInfo[playerid][jail] = 0;
	PlayerTemp[playerid][imprisoned] = 0;
	TextDrawHideForPlayer(playerid, PlayerTemp[playerid][jailtd]);
	return 1;
}

stock IsAtDynamicCP(iPlayer)
{
	if(IsPlayerInRangeOfPoint(iPlayer, 5.0, 362.3347,173.6566,1008.3828)) return 1;
	return 0;
}

stock MoneyCheckEx(playerid)
{
    if(IsPlayerConnected(playerid) && PlayerTemp[playerid][loggedIn] && (GetPlayerMoney(playerid)>PlayerTemp[playerid][sm]+1000))
	{
        new stringa[MAX_STRING];
	 	format(stringa,sizeof(stringa),"%s(%d) - [+%d$] (Possible Money Cheater)",PlayerName(playerid),playerid,(GetPlayerMoney(playerid)-(PlayerTemp[playerid][sm]+1000)));
		SetPlayerMoney(playerid,PlayerTemp[playerid][sm]);
		SendClientMessageToAdmins(stringa,COLOR_GREEN);
	 	return true;
	}
	return false;
}

stock NearMessage(playerid, text[], color, Float:dist = 50.0)
{
	new Float:newx,Float:newy,Float:newz;
	GetPlayerPos(playerid,newx,newy,newz);
    PlayerLoop(i)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerInRangeOfPoint(i, dist, newx, newy, newz)) continue;
		if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(playerid) || GetPlayerInterior(i) != GetPlayerInterior(playerid)) continue;
		SendClientMessage(i,color,text);
	}
	return 1;
}

stock NearMessageEx(text[], color, Float:rrX, Float:rrY, Float:rrZ, rrInterior, rrVirtualWorld, Float:dist = 75.00)
{
    PlayerLoop(i)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerInRangeOfPoint(i, dist, rrX, rrY, rrZ)) continue;
		if(GetPlayerVirtualWorld(i) != rrVirtualWorld || GetPlayerInterior(i) != rrInterior) continue;
		SendClientMessage(i, color, text);
	}
	return 1;
}

stock DefaultSpawn(playerid)
{
	ResetPlayerWeaponsEx(playerid);
    PlayerTemp[playerid][tmphouse] = -1;
    PlayerTemp[playerid][tmpbiz] = -1;
    PlayerTemp[playerid][spawnrdy] = 1;
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	if(PlayerTemp[playerid][gettingTreatmentFromHospital] != false)
	{	
		SetSpawnInfo(playerid, CIV, PlayerInfo[playerid][Skin], 1989.2710, -1475.7676, 22.4653, 0.0, 0, 0, 0, 0, 0, 0);
		SetPlayerHealth(playerid, 1);
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid, 0);	
		SetPlayerPos(playerid, 2004.25525, -1476.96033, 10.34170);
		SetPlayerCameraPos(playerid, 1989.2710, -1475.7676, 22.4653);
		SetPlayerCameraLookAt(playerid, 1989.8212, -1474.9314, 22.3949);
		SetTimerEx("OnHospitalHeal", 250, 0, "i", playerid);
		format(iStr, sizeof(iStr), "Info: You have paid $%s for the medical bills, have a nice day!", number_format(dini_Int(globalstats, "medicals")));
		SendClientMessage(playerid,COLOR_ORANGE, iStr);
		GivePlayerMoneyEx(playerid, -dini_Int(globalstats, "medicals"));
		return 1;
	}
	SetPlayerWantedLevel(playerid, PlayerInfo[playerid][wantedLvl]);
	if(PlayerInfo[playerid][housenum] != -1) // house spawn
	{
		HouseSpawn(playerid, PlayerInfo[playerid][housenum]);
		return 1;
	}
	new fID = PlayerInfo[playerid][playerteam];
	if(fID != CIV && HQInfo[fID][hqActive] == true) // player is in a faction and they're HQ has been created!
	{
		new playertier = PlayerInfo[playerid][ranklvl];
		if(FactionInfo[fID][fActive] != true) //invalid
		{
			Uninvite(playerid, "SERVER");
			return DefaultSpawn(playerid);
		}
		if(playertier == 0 || IsPlayerInThisFactionType(playerid, FAC_TYPE_ARMY) == true || IsPlayerInThisFactionType(playerid, FAC_TYPE_POLICE) == true) // faction leader |  spawn
		{
			SetSpawnInfo(playerid, CIV, PlayerInfo[playerid][Skin], HQInfo[fID][flSpawnX], HQInfo[fID][flSpawnY], HQInfo[fID][flSpawnZ], 0,0,0,0,0,0,0);
			SetPlayerInterior(playerid, HQInfo[fID][flSpawnInt]);
			SetPlayerVirtualWorld(playerid, HQInfo[fID][flSpawnVW]);
			SetPlayerPos(playerid, HQInfo[fID][flSpawnX], HQInfo[fID][flSpawnY], HQInfo[fID][flSpawnZ]);
			SetPlayerFacingAngle(playerid, HQInfo[fID][flSpawnA]);
		}
		else if(playertier >= 1 && playertier <= 2)
		{
			SetSpawnInfo(playerid, CIV, PlayerInfo[playerid][Skin], HQInfo[fID][fSpawnX], HQInfo[fID][fSpawnY], HQInfo[fID][fSpawnZ], 0,0,0,0,0,0,0);
			SetPlayerInterior(playerid, HQInfo[fID][fSpawnInt]);
			SetPlayerVirtualWorld(playerid, HQInfo[fID][fSpawnVW]);
			SetPlayerPos(playerid, HQInfo[fID][fSpawnX], HQInfo[fID][fSpawnY], HQInfo[fID][fSpawnZ]);
			SetPlayerFacingAngle(playerid, HQInfo[fID][fSpawnA]);
		}
		else
		{
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid, 0);
			SetSpawnInfo(playerid, CIV, PlayerInfo[playerid][Skin], randomspawn[RSpawnNo][spawnx], randomspawn[RSpawnNo][spawny], randomspawn[RSpawnNo][spawnz], randomspawn[RSpawnNo][spawna],0,0,0,0,0,0);
			SetPlayerPosEx(playerid, randomspawn[RSpawnNo][spawnx],randomspawn[RSpawnNo][spawny],randomspawn[RSpawnNo][spawnz], 0, 0, false);
			SetPlayerFacingAngle(playerid, randomspawn[RSpawnNo][spawna]);
			RSpawnNo++; if(RSpawnNo>sizeof(randomspawn)-1) RSpawnNo=0;
		}
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	else
	{
	    SetPlayerInterior(playerid,0);
	 	SetSpawnInfo(playerid,CIV,PlayerInfo[playerid][Skin],randomspawn[RSpawnNo][spawnx],randomspawn[RSpawnNo][spawny],randomspawn[RSpawnNo][spawnz],randomspawn[RSpawnNo][spawna],0,0,0,0,0,0);
		SetPlayerPosEx(playerid, randomspawn[RSpawnNo][spawnx],randomspawn[RSpawnNo][spawny],randomspawn[RSpawnNo][spawnz], 0, 0, false);
		SetPlayerFacingAngle(playerid, randomspawn[RSpawnNo][spawna]);
	 	RSpawnNo++; if(RSpawnNo>sizeof(randomspawn)-1) RSpawnNo=0;
	 	SetCameraBehindPlayer(playerid);
	    return 1;
	}
}

stock SendPlayerMessage(playerid, color, text[], msg_Header[] = "", len = 132)
{
	new text2[ 256 ], maxstring = 384;
	new iFormat[40];
	if(strlen(text) > len)
	{
	    strmid(text2, text, len, maxstring);
	    strdel(text, len, maxstring);
	    strins(text, "", len, maxstring);
		
		format(iFormat, sizeof(iFormat), "%s ", msg_Header);
	    strins(text2, iFormat, 0, maxstring);
		
	    SendClientMessage(playerid, color, text);
	    SendClientMessage(playerid, color, text2);
	    return 1;
	}
	else return SendClientMessage(playerid, color, text);
}

stock iEchoEx(text[], channel[] = IRC_CHANNEL, len = 340)
{
	new
	    text2[ 384 ],
		maxstring = 768;

	if(strlen(text) > len)
	{
	    strmid(text2, text, len, maxstring);
	    strdel(text, len, maxstring);
	    strins(text, "...", len, maxstring);
	    strins(text2, "...", 0, maxstring);
	    IRC_GroupSay(gBotID[random(3)], channel, text);
	    IRC_GroupSay(gBotID[random(3)], channel, text2);
	    return 1;
	}
	else return iEcho(text, channel);
}

stock ProxDetectorEx(Float:radi, playerid, string[],col1 = COLOR_GRAD1,col2 = COLOR_GRAD1,col3 = COLOR_GRAD1,col4 = COLOR_GRAD1,col5 = COLOR_GRAD1)
{
	new Float:posx, Float:posy, Float:posz;
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerPos(i, posx, posy, posz);
			tempposx = (oldposx -posx);
			tempposy = (oldposy -posy);
			tempposz = (oldposz -posz);
			if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16))) SendClientMessage(i, col1, string);
			else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8))) SendClientMessage(i, col2, string);
			else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4))) SendClientMessage(i, col3, string);
			else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2))) SendClientMessage(i, col4, string);
			else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) SendClientMessage(i, col5, string);
		}
	}
	return 1;
}

stock NoUnderscore(string[])
{
    new str[MAX_PLAYER_NAME];
    strmid(str, string, 0, strlen(string), MAX_PLAYER_NAME);
	for(new arr = 0; arr < strlen(str); arr++)
	{
		if(str[arr] == '_') str[arr] = ' ';
	}
	return str;
}

stock now()
{
    new hour,minute,second;
	gettime(hour,minute,second);
	new day,month,year;
	getdate(year,month,day);
	if (m_iLastTime[ 0 ] == (minute * second ))
	{
	    return m_iLastTime[ 1 ];
	}
	new time = mktime(hour,minute,second,day,month,year);
	m_iLastTime[ 0 ] = (minute * second);
	m_iLastTime[ 1 ] = time;
	return time;
}

stock IsEchoChannel(chan[])
{
	if(!strcmp(chan, IRC_CHANNEL)) return true;
	else return false;
}

stock TimeDate()
{
	new Timee[3],Date[3],tmp[64];
	gettime(Timee[0],Timee[1],Timee[2]);
	getdate(Date[0],Date[1],Date[2]);
	format(tmp,128,"[%02d/%02d/%d - %02d:%02d:%02d]",Date[2], Date[1], Date[0], Timee[0], Timee[1], Timee[2]);
	return tmp;
}

stock TimeDateEx()
{
	new Timee[3],Date[3],tmp[64];
	gettime(Timee[0],Timee[1],Timee[2]);
	getdate(Date[0],Date[1],Date[2]);
	format(tmp,128,"%02d/%02d/%d %02d:%02d:%02d",Date[2], Date[1], Date[0], Timee[0], Timee[1], Timee[2]);
	return tmp;
}

stock SetPlayerPosEx(playerid, Float:tp_x, Float:tp_y, Float:tp_z, tp_interior = 0, tp_virtualworld = 0, bool:freeZe = true)
{
	SetPlayerInterior(playerid, tp_interior);
	SetPlayerVirtualWorld(playerid, tp_virtualworld);
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), tp_x, tp_y, tp_z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid),  tp_interior);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), tp_virtualworld);
		return 1;
	}
	else
	{
		SetPlayerPos(playerid, tp_x, tp_y, tp_z);
		if(freeZe == true)
		{
			TogglePlayerControllable(playerid, false);
			SetTimerEx("Unfreeze", 500, false, "d", playerid);
		}
		return 1;
	}
}

stock IsValidSkin(_id)
{
	if(_id < 1 || _id > 311) return 0;
	new np = -1;
	return np;
}

stock IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) return 1;
	return 0;
}

stock IsPlayerAtImpound(playerid)
{
	if(IsPlayerInArea(playerid, 2425.2207,-2143.8057, 2540.5481,-2066.7754)) return 1;
	return 0;
}

stock IsPlayerAtPrison(playerid)
{
	if(IsPlayerInArea(playerid, 2425.2207,-2143.8057, 2540.5481,-2066.7754)) return 1;
	return 0;
}

stock AdminLevelName(playerid)
{
	new tmp[ 40 ];
	if(PlayerInfo[playerid][helper] == 1)
	{
	    myStrcpy(tmp, "Helper");
	    return tmp;
	}
	switch(PlayerInfo[playerid][power])
	{
	    case 31337: myStrcpy(tmp, "N/A");
		case 1337: myStrcpy(tmp, "Developer");
	    case 11,12: myStrcpy(tmp, "Head Admin");
	    case 10: myStrcpy(tmp, "Lead Admin");
	    case 6..9: myStrcpy(tmp, "Senior Admin");
	    case 2..5: myStrcpy(tmp, "Basic Admin");
	    case 1: myStrcpy(tmp, "Trial Admin");
	    case 0: myStrcpy(tmp, "Player");
	    default: myStrcpy(tmp, "Owner");
	}
	return tmp;
}

stock Up(playerid)
{
	if(GetPVarInt(playerid, "CurrentUP") == 0) 
	{
		new Float:PosX, Float:PosY, Float:PosZ;
		GetPlayerPos(playerid, PosX, PosY, PosZ);
		SetPlayerPos(playerid, PosX, PosY, PosZ+3);
		SetPVarInt(playerid, "CurrentUP", 1);
		SetTimerEx("RemoveUP", 500, false, "d", playerid);
	}
}

stock LoadGangZones(turfID = -1) // relload / load
{
	if(turfID == -1) mysql_tquery(MySQLPipeline, "SELECT * FROM `GangZones`", "OnLoadGangZones");
	else
	{
		new iQuery[228];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT * FROM `GangZones` WHERE `ID` = %d LIMIT 1", turfID);
		mysql_tquery(MySQLPipeline, iQuery, "OnLoadGangZones");
	}
}

stock DestroyGangZones(turfID = -1)
{
	if(turfID == -1)
	{
		LOOP:i(0, MAX_GANGZONES)
		{
			GangZoneDestroy(Gangzones[i][gID]);
			TextDrawHideForAll(Gangzones[i][gDRAW]);
			TextDrawDestroy(Gangzones[i][gDRAW]);
		}
	}
	else
	{
		GangZoneDestroy(Gangzones[turfID][gID]);
		TextDrawHideForAll(Gangzones[turfID][gDRAW]);
		TextDrawDestroy(Gangzones[turfID][gDRAW]);
	}
}

stock GetPlayerBusinesses(playerid)
{
	new count = 0;
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(!strcmp(BusinessInfo[b][bOwner], PlayerName(playerid), false)) count++;
	}
	return count;
}

/***********************************************************************************************************************
	Seed Functions
***********************************************************************************************************************/
stock GetUnusedSeed()
{
	new found = -1;
	for(new v; v < sizeof(Seeds); v++)
	{
	    if(Seeds[v][sActive] == 0) return v;
	}
	return found;
}

stock IsAtSeed(playerid)
{
	new found = -1;
	for(new v; v < sizeof(Seeds); v++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, Seeds[v][seedX],Seeds[v][seedY],Seeds[v][seedZ])) found = v;
	}
	return found;
}

stock GetSeeds(playerid)
{
	new found = 0;
	for(new v; v < sizeof(Seeds); v++)
	{
	    if(!strcmp(Seeds[v][sOwner], PlayerName(playerid), false)) found++;
	}
	return found;
}

stock ResetSeed(id)
{
	myStrcpy(Seeds[id][sOwner], "NoBodY");
	DestroyDynamic3DTextLabel(Seeds[id][sLabel]);
	DestroyDynamicPickup(Seeds[id][sPickup]);
	Seeds[id][sGrams] = 0;
	Seeds[id][sTick] = 666;
	Seeds[id][seedX] = 0.0;
	Seeds[id][seedY] = 0.0;
	Seeds[id][seedZ] = 0.0;
	Seeds[id][sActive] = 0;
}

/***********************************************************************************************************************
	Weapon Functions
***********************************************************************************************************************/
stock GivePlayerWeaponEx(playerid, weaponid, ammoo)
{
	new slotid = GetWeaponSlot(weaponid);
	PlayerTemp[playerid][AntiSpawnWeapon][slotid] = weaponid;
	PlayerTemp[playerid][AntiSpawnAmmo][slotid] = ammoo;
	GivePlayerWeapon(playerid, weaponid, ammoo);
	return 1;
}

stock RemovePlayerWeapon(playerid, slotid)
{
	new playerweapons[WEAPON_SLOTS][2];
	for(new c = 0; c < WEAPON_SLOTS; c++) // getting current weapons!
	{
		if(slotid == c) continue;
		GetPlayerWeaponData(playerid, c, playerweapons[c][0], playerweapons[c][1]);
	}
	ResetPlayerWeaponsEx(playerid);
	for(new c = 0; c < WEAPON_SLOTS; c++) // getting current weapons!
	{
		PlayerTemp[playerid][AntiSpawnWeapon][c] = playerweapons[c][0];
		PlayerTemp[playerid][AntiSpawnAmmo][c] = playerweapons[c][1];
		GivePlayerWeaponEx(playerid, playerweapons[c][0], playerweapons[c][1]);
	}
	return 1;
}

stock ResetPlayerWeaponsEx(playerid)
{
	ResetPlayerWeapons(playerid);
	for(new c = 0; c < WEAPON_SLOTS; c++)
	{
		PlayerTemp[playerid][AntiSpawnWeapon][c] = 0;
		PlayerTemp[playerid][AntiSpawnAmmo][c] = 0;	
	}
}

stock bool:CheckPlayerWeaponSpawn(playerid)
{
	new playerweapons[WEAPON_SLOTS][2], bool:spawning = false;
	for(new c = 0; c < WEAPON_SLOTS; c++) // getting current weapons!
	{
		GetPlayerWeaponData(playerid, c, playerweapons[c][0], playerweapons[c][1]);
		if(playerweapons[c][0] != 0) // has weapon inside!
		{
			if(PlayerTemp[playerid][AntiSpawnWeapon][c] != playerweapons[c][0]) spawning = true;
		}
		else // no weapon inside that slot!
		{
			PlayerTemp[playerid][AntiSpawnWeapon][c] = 0; // maybe he ran out of bullets!
			PlayerTemp[playerid][AntiSpawnAmmo][c] = 0; //
		}
	}
	return spawning;
}

stock GetWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid)
	{
		case 0, 1: slot = 0;            // No weapon
		case 2 .. 9: slot = 1;          // Melee
		case 22 .. 24: slot = 2;        // Handguns
		case 25 .. 27: slot = 3;        // Shotguns
		case 28, 29, 32: slot = 4;      // Sub-Machineguns
		case 30, 31: slot = 5;          // Machineguns
		case 33, 34: slot = 6;          // Rifles
		case 35 .. 38: slot = 7;        // Heavy Weapons
		case 16, 18, 39: slot = 8;      // Projectiles
		case 41 .. 43: slot = 9;          // Special 1
		case 14: slot = 10;             // Gifts
		case 44 .. 46: slot = 11;       // Special 2
		case 40: slot = 12;             // Detonators
		default: slot = -1;  // No slot
	}
	return slot;
}

/***********************************************************************************************************************
	Server Functions
***********************************************************************************************************************/
stock number_format( num )
{
	new stri[16], stro[16], i, v, p, d, l, n = num < 0;
	format( stri, sizeof( stri ), "%d", num * ( n ? -1 : 1 ) );
	l = strlen( stri ) - 1;
	d = ( l - ( l % 3 ) ) / 3;
	l = l + 1;
	i = l + d;
	p = l;
	while ( i >= 0 )
	{
	    v = l + d - i;
	    if ( v && !( v % 4 ) ) stro[i + n] = ',';
		else stro[i + n] = stri[p--];
     	i--;
	}
	stro[0] = n ? '-' : stro[0];
	return stro;
}

stock Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ,   Float:ObjX, Float:ObjY, Float:ObjZ,   Float:FrX, Float:FrY, Float:FrZ)
{
	new Float:TGTDistance;
	TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));
	new Float:tmpX, Float:tmpY, Float:tmpZ;
	tmpX = FrX * TGTDistance + CamX;
	tmpY = FrY * TGTDistance + CamY;
	tmpZ = FrZ * TGTDistance + CamZ;
	return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}

stock SendClientMSG(playerid, color, fstring[], {Float, _}:...)
{
    #define BYTES_PER_CELL 4
    static const
        STATIC_ARGS = 3;
    new n = (numargs() - STATIC_ARGS) * BYTES_PER_CELL;
    if (n)
    {
        new message[128], arg_start, arg_end;
        #emit CONST.alt        fstring
        #emit LCTRL          5
        #emit ADD
        #emit STOR.S.pri       arg_start
        #emit LOAD.S.alt       n
        #emit ADD
        #emit STOR.S.pri       arg_end
        do
        {
            #emit LOAD.I
            #emit PUSH.pri
            arg_end -= BYTES_PER_CELL;
            #emit LOAD.S.pri     arg_end
        }
        while (arg_end > arg_start);
        #emit PUSH.S         fstring
        #emit PUSH.C         128
        #emit PUSH.ADR        message
        n += BYTES_PER_CELL * 3;
        #emit PUSH.S         n
        #emit SYSREQ.C        format
        n += BYTES_PER_CELL;
        #emit LCTRL          4
        #emit LOAD.S.alt       n
        #emit ADD
        #emit SCTRL          4
        return SendPlayerMessage(playerid, color, message, "");
    }
    else return SendPlayerMessage(playerid, color, fstring, "");
}

stock rndCOLORZ()
{
	if(rndCOLOR == 0)
	{
	    rndCOLOR ++;
		return COLOR_LIGHTGREY;
	}
	else
	{
	    rndCOLOR = 0;
	    return COLOR_LIGHTGREYEX;
	}
}

stock Float:PointToPoint(Float:x, Float:y, Float:z, Float:xx, Float:yy, Float:zz)
{
    return floatsqroot( (x - xx) * (x - xx) + (y - yy) * (y - yy) + (z - zz) * (z - zz) );
}

stock FactionLog(factionid, Reason[], logLevel)
{
	new iQuery[228];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `FactionLogs` (`FactionID`, `TimeDate`, `Reason`, `LogLevel`) VALUES ('%e', '%e', '%e', %d)", factionid, TimeDateEx(), Reason, logLevel);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock DeathLog(playerid, killerid, Reason[])
{
	new iQuery[228];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `Deaths` (`PlayerName`, `KillerName`, `Reason`, `TimeDate`) VALUES ('%e', '%e', '%e', '%e')", PlayerName(playerid), PlayerName(killerid), Reason, TimeDateEx());
	return 1;
}

stock AdminDB(Who[], By[], Reason[], Header[])
{
	new iQuery[228];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `AdminDB` (`PlayerName`, `By`, `TimeDate`, `Reason`, `Header`) VALUES ('%e', '%e', '%e', '%e', '%e')", Who, By, TimeDateEx(), Reason, Header);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock PoliceDB(playerid, Reason[])
{
	new iQuery[248];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `PoliceDB` (`PlayerName`, `Reason`, `Date`) VALUES ('%e', '%e', '%e')", PlayerName(playerid), Reason, TimeDateEx());
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock LoginDB(playerid, successful = 1)
{
	new iQuery[248], IP_Address[27];
	GetPlayerIp(playerid, IP_Address, sizeof(IP_Address));
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `LoginDB` (`PlayerName`, `IP`, `DateTime`, `Successful`) VALUES ('%e', '%e', '%e', %d)", PlayerName(playerid), IP_Address, TimeDateEx(), successful);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock bugDB(playerid, Reason[])
{
	new iQuery[248];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `bugDB` (`PlayerName`, `Reason`, `Date`) VALUES ('%e', '%e', '%e')", PlayerName(playerid), Reason, TimeDateEx());
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}
stock CharityLog(playerid, iAmount, iReason[])
{
	new iQuery[248];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `CharityLog` (`PlayerName`, `Amount`, `TimeDate`,`Reason`) VALUES ('%e', '%e', '%e', '%e')", PlayerName(playerid), iAmount, TimeDateEx(), iReason);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock GenerateStrangerID(playerid)
{
	new strangerID = minrand(1, 1000000);
	SetPVarInt(playerid, "StrangerID", strangerID);
	new ip[30], iQuery[228];
	GetPlayerIp(playerid, ip, 30);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `StrangerDB` (`PlayerName`, `IP`, `Date`, `StrangerID`) VALUES ('%e', '%e', '%e', %d)", PlayerName(playerid), ip, TimeDateEx(), strangerID);
	mysql_tquery(MySQLPipeline, iQuery);
	return strangerID;
}

/***********************************************************************************************************************
	Player Functions
***********************************************************************************************************************/
stock SaveAccount(playerid)
{
	if(PlayerTemp[playerid][loggedIn] == false) return 1;
	new iFormat[100], iQuery[2750];
	strcat(iQuery, "UPDATE `PlayerInfo` SET ");
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Money` = %d, ", PlayerTemp[playerid][sm]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Bank` = %d, ", PlayerInfo[playerid][bank]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Level` = %d, ", PlayerInfo[playerid][playerlvl]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RPoints` = %d, ", PlayerInfo[playerid][rpoints]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PlayerTime` = %d, ", PlayerInfo[playerid][playertime]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Tier` = %d, ", PlayerInfo[playerid][ranklvl]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Jail` = %d, ", PlayerInfo[playerid][jail]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Warns` = %d, ", PlayerInfo[playerid][warns]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`JailTime` = %d, ", PlayerInfo[playerid][jailtime]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Banned` = %d, ", PlayerInfo[playerid][banned]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RentPrice` = %d, ", PlayerInfo[playerid][rentprice]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`DriverLicense` = %d, ", PlayerInfo[playerid][driverlic]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`WeaponLicense` = %d, ", PlayerInfo[playerid][weaplic]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PilotLicense` = %d, ", PlayerInfo[playerid][flylic]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SailingLicense` = %d, ", PlayerInfo[playerid][boatlic]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`JobSkill` = %d, ", PlayerInfo[playerid][jobskill]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TotalPlayTime` = %d, ", PlayerInfo[playerid][totalpayt]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Kills` = %d, ", PlayerInfo[playerid][kills]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Deaths` = %d, ", PlayerInfo[playerid][deaths]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SellableDrugs` = %d, ", PlayerInfo[playerid][sdrugs]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RentHouse` = %d, ", PlayerInfo[playerid][housenum]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`AdminLevel` = %d, ", PlayerInfo[playerid][power]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Skin` = %d, ", PlayerInfo[playerid][Skin]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Guns` = %d, ", PlayerInfo[playerid][guns]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SGuns` = %d, ", PlayerInfo[playerid][sMaterials]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Bail` = %d, ", PlayerInfo[playerid][bail]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PremiumLevel` = %d, ", PlayerInfo[playerid][premium]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PhoneNumber` = %d, ", PlayerInfo[playerid][phonenumber]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GotPhone` = %d, ", PlayerInfo[playerid][gotphone]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PhoneChanges` = %d, ", PlayerInfo[playerid][phonechanges]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PhoneBook` = %d, ", PlayerInfo[playerid][phonebook]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Laptop` = %d, ", PlayerInfo[playerid][laptop]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Age` = %d, ", PlayerInfo[playerid][age]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Radio` = %d, ", PlayerInfo[playerid][radio]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Freq1` = %d, ", PlayerInfo[playerid][freq1]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Freq2` = %d, ", PlayerInfo[playerid][freq2]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Freq3` = %d, ", PlayerInfo[playerid][freq3]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`CurrentFrequency` = %d, ", PlayerInfo[playerid][curfreq]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`FactionID` = %d, ", PlayerInfo[playerid][playerteam]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TotalRuns` = %d, ", PlayerInfo[playerid][totalruns]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`FactionPay` = %d, ", PlayerInfo[playerid][fpay]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TBanned` = %d, ", PlayerInfo[playerid][tbanned]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Helper` = %d, ", PlayerInfo[playerid][helper]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PremiumExpire` = %d, ", PlayerInfo[playerid][premiumexpire]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`NameChanges` = %d, ", PlayerInfo[playerid][namechanges]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`JailReason` = '%e', ", PlayerInfo[playerid][jailreason]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Job` = '%e', ", PlayerInfo[playerid][job]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RankName` = '%e', ", PlayerInfo[playerid][rankname]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`WhenIGotBanned` = '%e', ", PlayerInfo[playerid][whenigotbanned]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`WhoBannedMe` = '%e', ", PlayerInfo[playerid][whobannedme]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`BanReason` = '%e', ", PlayerInfo[playerid][banreason]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Loan` = %d, ", PlayerInfo[playerid][loan]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VMax` = %d, ", PlayerInfo[playerid][vMax]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`vSMax` = %d, ", PlayerInfo[playerid][vSpawnMax]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Gender` = %d, ", PlayerInfo[playerid][pGender]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Ethnicity` = %d, ", PlayerInfo[playerid][pEthnicity]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`pbkills` = %d, ", PlayerInfo[playerid][pbkills]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`pbdeaths` = %d, ", PlayerInfo[playerid][pbdeaths]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Boombox` = %d, ", PlayerInfo[playerid][pBoomBox]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Seeds` = %d, ", PlayerTemp[playerid][seeds]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TotalFish` = %d, ", PlayerTemp[playerid][totalfish]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TotalRob` = %d, ", PlayerTemp[playerid][totalrob]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TotalLogin` = %d, ", PlayerTemp[playerid][totallogin]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Key_Enter` = %d, ", PlayerTemp[playerid][key_enter]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Fightstyleleft` = %d, ", PlayerTemp[playerid][fightstyleleft]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`PhoneOFF` = %d, ", PlayerTemp[playerid][phone]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`OOCOff` = %d, ", PlayerTemp[playerid][oocoff]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`WhisperLock` = %d, ", PlayerTemp[playerid][wlock]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`jqmessage` = %d, ", PlayerTemp[playerid][jqmessage]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`NameOFF` = %d, ", PlayerTemp[playerid][hname]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`FishAmount` = %d, ", PlayerTemp[playerid][fishamount]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`totalguns` = %d, ", PlayerTemp[playerid][totalguns]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`imprisoned` = %d, ", PlayerTemp[playerid][imprisoned]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`OOCMode` = %d, ", PlayerTemp[playerid][oocmode]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`AllowCBug` = %d, ", PlayerInfo[playerid][allowCBug]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`BoomBoxBan` = %d, ", PlayerInfo[playerid][pBoomBoxBan]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Wanted` = %d, ", PlayerInfo[playerid][wantedLvl]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`WantedReason` = '%e', ", PlayerInfo[playerid][wantedReason]); strcat(iQuery, iFormat);
	new iiSave;
	if(PlayerTemp[playerid][chatAnim] == true) iiSave = 1; else iiSave = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ChatAnim` = %d, ", iiSave); strcat(iQuery, iFormat);
    new iString[ 50 ], tmp[ 10 ];
    for(new c = 0; c < MAX_DRUG_TYPES; c++)
	{
	    format(tmp,sizeof(tmp),"%d,", PlayerInfo[playerid][hasdrugs][c]);
	    strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`DrugInfo` = '%e' WHERE `PlayerName` = '%e'", iString, PlayerName(playerid)); strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
    return 1;
}

stock TeleportCheck(playerid)
{
	PlayerTemp[playerid][tp] = 1;
	SetTimerEx("TeleportCheckEx", 300, 0, "d", playerid);
}

stock RandomSkinForPlayer(playerid)
{
	new iCount, skinCount, iSkin;
	for(new c = 0; c < sizeof(SkinInfo); c++)
	{
		if(SkinInfo[c][skinType] != SKIN_PEDESTRIAN) continue;
		if(SkinInfo[c][skinGender] != PlayerInfo[playerid][pGender]) continue;
		if(SkinInfo[c][skinEthnic] != PlayerInfo[playerid][pEthnicity]) continue;
		skinCount++;
	}
	new iRandom = random(skinCount);
	for(new c = 0; c < sizeof(SkinInfo); c++)
	{
		if(SkinInfo[c][skinType] != SKIN_PEDESTRIAN) continue;
		if(SkinInfo[c][skinGender] != PlayerInfo[playerid][pGender]) continue;
		if(SkinInfo[c][skinEthnic] != PlayerInfo[playerid][pEthnicity]) continue;
		if(iCount == iRandom)
		{
			iSkin = SkinInfo[c][skinID];
			break;
		}
		iCount++;
	}
	SetPlayerSkin(playerid, iSkin);
	PlayerInfo[playerid][Skin] = iSkin;
	return 1;
}

stock IsPlayerAimingAt(playerid, Float:qcx, Float:qcy, Float:qcz, Float:qcradius)
{
	new Float:acx,Float:acy,Float:acz,Float:bfx,Float:bfy,Float:bfz;
 	GetPlayerCameraPos(playerid, acx, acy, acz);
  	GetPlayerCameraFrontVector(playerid, bfx, bfy, bfz);
   	return (qcradius >= DistanceCameraTargetToLocation(acx, acy, acz, qcx, qcy, qcz, bfx, bfy, bfz));
}

stock IsPlayerInWater(playerid)
{
	new Float:x,Float:y,Float:pz;
	GetPlayerPos(playerid,x,y,pz);
	if ( (IsPlayerInArea(playerid, 2032.1371, 1841.2656, 1703.1653, 1467.1099) && pz <= 9.0484) //lv piratenschiff
  	|| (IsPlayerInArea(playerid, 2109.0725, 2065.8232, 1962.5355, 10.8547) && pz <= 10.0792) //lv visage
  	|| (IsPlayerInArea(playerid, -492.5810, -1424.7122, 2836.8284, 2001.8235) && pz <= 41.06) //lv staucamm
  	|| (IsPlayerInArea(playerid, -2675.1492, -2762.1792, -413.3973, -514.3894) && pz <= 4.24) //sf sï¿½dwesten kleiner teich
  	|| (IsPlayerInArea(playerid, -453.9256, -825.7167, -1869.9600, -2072.8215) && pz <= 5.72) //sf gammel teich
  	|| (IsPlayerInArea(playerid, 1281.0251, 1202.2368, -2346.7451, -2414.4492) && pz <= 9.3145) //ls neben dem airport
  	|| (IsPlayerInArea(playerid, 2012.6154, 1928.9028, -1178.6207, -1221.4043) && pz <= 18.45) //ls mitte teich
  	|| (IsPlayerInArea(playerid, 2326.4858, 2295.7471, -1400.2797, -1431.1266) && pz <= 22.615) //ls weiter sï¿½dï¿½stlich
  	|| (IsPlayerInArea(playerid, 2550.0454, 2513.7588, 1583.3751, 1553.0753) && pz <= 9.4171) //lv pool ï¿½stlich
  	|| (IsPlayerInArea(playerid, 1102.3634, 1087.3705, -663.1653, -682.5446) && pz <= 112.45) //ls pool nordwestlich
  	|| (IsPlayerInArea(playerid, 1287.7906, 1270.4369, -801.3882, -810.0527) && pz <= 87.123) //pool bei maddog's haus oben
  	|| (pz < 1.5)) return 1;
	return 0;
}

stock IsAtATM(playerid)
{
	ATMLoop(i)
	{
	    if(ATMInfo[i][atmActive] != true) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, ATMInfo[i][atmX], ATMInfo[i][atmY], ATMInfo[i][atmZ])) return 1;
	}
	return 0;
}

stock LoadPlayerAnimLibs(playerid)
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
}

stock ShowInfoBox(playerid, iTitle[], iMessage[], hidedelay = -1)
{
	new string[ 512 ];
	format(string, sizeof(string), "~n~~w~%s", iMessage);
	if(hidedelay == -1) strcat(string, "~n~~n~~w~Press ~y~LMB~w~ to close");
	TextDrawSetString(PlayerTemp[playerid][InfoBox], string);
	format(string, sizeof(string), "%s", iTitle);
	TextDrawSetString(PlayerTemp[playerid][InfoBoxTitle], string);
	TextDrawShowForPlayer(playerid, PlayerTemp[playerid][InfoBox]);
	TextDrawShowForPlayer(playerid, PlayerTemp[playerid][InfoBoxTitle]);
	if(hidedelay != -1) SetTimerEx("HideInfoBox", hidedelay*1000, false, "d", playerid);
	return 1;
}

stock RPName(playerid)
{
    new string[24];
    GetPlayerName(playerid,string,24);
    new str[24];
    strmid(str,string,0,strlen(string),24);
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if (str[i] == '_') str[i] = ' ';
    }
    return str;
}

stock Misc__ClearWindow(iPlayer)
{
    for(new count = 0; count < 100; count++) SendClientMessage(iPlayer, COLOR_WHITE, "");
}

stock IsAtRobDropPlace(playerid)
{
	for(new i = 1; i < sizeof(robbingplaces); i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, robbingplaces[i][0],robbingplaces[i][1],robbingplaces[i][2])) return i;
	}
	return 0;
}

stock Misc__IsAtDeliverPlace(playerid)
{
	for(new i = 1; i < sizeof(deliver); i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 9.0, deliver[i][deliverX],deliver[i][deliverY], deliver[i][deliverZ])) return i;
	}
	return 0;
}

stock IsInPeaceZone(playerid)
{
	if(IsPlayerInArea(playerid, 1743.2206,-1950.4374, 1811.4928,-1880.5083)) return 1;
	return 0;
}

stock IsPlayerInCarlot(playerid)
{
	if(IsPlayerInArea(playerid, 308.7599,-1812.3955, 359.7181,-1785.7979)) return 1;
	return 0;
}

stock MaskedName(_id)
{
	new sender[MAX_PLAYER_NAME];
	if(PlayerTemp[_id][hname])
	{
		new iFormat[25];
		format(iFormat, sizeof(iFormat), "Stranger [%d]", GetPVarInt(_id, "StrangerID"));
		myStrcpy(sender, iFormat);
	}
	else myStrcpy(sender, RPName(_id));
	return sender;
}

stock Action(playerid, what[])
{
	format(iStr,sizeof(iStr),"** %s %s", MaskedName(playerid), what);
	NearMessage(playerid,iStr,COLOR_ME2);
}

stock IsBugWeapon(playerid)
{
  new weaponid = GetPlayerWeapon(playerid);
  switch(weaponid){ case 24,25,27,34,35: return true;}
  return false;
}

stock StopPlayerHoldingObjectEx(playerid)
{
    StopPlayerHoldingObject(playerid);
	DeletePVar(playerid, "PlayerHoldingObject");
}

stock IsPlayerHoldingObjectID(playerid, _objid)
{
	if(IsPlayerHoldingObject(playerid) && GetPVarInt(playerid, "PlayerHoldingObject") == _objid) return 1;
	return 0;
}

stock IsPlayerHoldingAnyObject(playerid)
{
	return GetPVarInt(playerid, "PlayerHoldingObject");
}

stock IsAtArmoury(playerid)
{
	for(new giD = 0; giD < sizeof(GiveGunPositions); giD++)
	{
		if(GiveGunPositions[giD][fac_Type] != -1 && GetPlayerFactionType(playerid) != GiveGunPositions[giD][fac_Type]) continue;
		if(GetPlayerInterior(playerid) != GiveGunPositions[giD][ggInterior]) continue;
		if(IsPlayerInRangeOfPoint(playerid, 4.0, GiveGunPositions[giD][ggX], GiveGunPositions[giD][ggY], GiveGunPositions[giD][ggZ])) return 1;
	}
    return 0;
}

stock HasPlayerWeapon(playerid, weaponid)
{
	new has = 0;
    for(new i=0;i<13;i++)
	{
		GetPlayerWeaponData(playerid,i,PlayerTemp[iPlayer][weapon],PlayerTemp[iPlayer][ammo]);
		if(PlayerTemp[playerid][weapon] == weaponid) has++;
	}
	return has;
}

stock AnonAdmin(playerid)
{
	new sender[MAX_STRING];
	if(PlayerInfo[playerid][power]==31337) myStrcpy(sender,"Unknown");
	else myStrcpy(sender,RPName(playerid));
	return sender;
}

stock GetStats(playerid, forplayerid, more = 0)
{
	new tlvl, genDer[15], ethnicity[21];
	
	if(PlayerInfo[playerid][pGender] == SKIN_MALE) myStrcpy(genDer, "Male");
	else if(PlayerInfo[playerid][pGender] == SKIN_FEMALE) myStrcpy(genDer, "Female");
	else myStrcpy(genDer, "Unknown");
	
	if(PlayerInfo[playerid][pEthnicity] == SKIN_ASIAN) myStrcpy(ethnicity, "Asian");
	else if(PlayerInfo[playerid][pEthnicity] == SKIN_BLACK) myStrcpy(ethnicity, "Black");
	else if(PlayerInfo[playerid][pEthnicity] == SKIN_HISPANIC) myStrcpy(ethnicity, "Hispanic");
	else if(PlayerInfo[playerid][pEthnicity] == SKIN_WHITE) myStrcpy(ethnicity, "White");
	else myStrcpy(ethnicity, "Unknown");
	
	new PTStatus = (PlayerInfo[playerid][playertime] / 200);
	if(PTStatus >= 30) PTStatus = 30;
	
	if(PlayerInfo[playerid][playerlvl]<=8) tlvl=9; else tlvl=PlayerInfo[playerid][playerlvl]*2;
	SendClientMessage(forplayerid, 0x3696EBFF, "_____________________________________________________________________________________");
	SendClientMessage(forplayerid, 0x3696EBFF, " ");
	SendClientMSG(forplayerid, 0xE0E0E0FF, " %s(%d): Money: $%s | Bank: $%s | Level: %d | RPoints: %d/%d", RPName(playerid), playerid, number_format(PlayerTemp[playerid][sm]), number_format(PlayerInfo[playerid][bank]), PlayerInfo[playerid][playerlvl], PlayerInfo[playerid][rpoints], tlvl);
	SendClientMSG(forplayerid, 0xE0E0E0FF, " Phone: %d | Age: %d | Renthouse: %d | FishCarried: %slbs | Playtime: %d (that's %d days!)", PlayerInfo[playerid][phonenumber], PlayerInfo[playerid][age], PlayerInfo[playerid][housenum], number_format(PlayerTemp[playerid][totalfish]), PlayerInfo[playerid][totalpayt], PlayerInfo[playerid][totalpayt] / 24);
	SendClientMSG(forplayerid, 0xE0E0E0FF, " Job: %s | Warns: %d | Skin: %d | Gender: %s | Ethnicity: %s | PTStatus: %d/30min", PlayerInfo[playerid][job], PlayerInfo[playerid][warns], PlayerInfo[playerid][Skin], genDer, ethnicity, PTStatus);
	if(PlayerInfo[playerid][premium] != 0 || PlayerInfo[playerid][phonechanges] || PlayerInfo[playerid][namechanges])
		SendClientMSG(forplayerid, 0xE0E0E0FF, " Premium Level: %d | Phone Changes: %d | Name changes: %d", PlayerInfo[playerid][premium], PlayerInfo[playerid][phonechanges], PlayerInfo[playerid][namechanges]);
	if(PlayerInfo[playerid][playerteam] != CIV)
		SendClientMSG(forplayerid, 0xE0E0E0FF, " Faction: %s | Rank: %s | Tier: %d | Faction pay: $%s", GetPlayerFactionName(playerid), PlayerInfo[playerid][rankname], PlayerInfo[playerid][ranklvl], number_format(PlayerInfo[playerid][fpay]));
	if(PlayerInfo[playerid][jail])
		SendClientMSG(forplayerid, 0xE0E0E0FF, " JailTime: %dsec | Reason: %s", PlayerInfo[playerid][jailtime], PlayerInfo[playerid][jailreason]);
	if(PlayerTemp[playerid][onpaint])
		SendClientMSG(forplayerid, 0xE0E0E0FF, " Kills: %d | Deaths: %d | K/D: %d", PlayerInfo[playerid][pbkills], PlayerInfo[playerid][pbdeaths], (PlayerInfo[playerid][pbkills]+PlayerInfo[playerid][pbdeaths])/2);
	if(more)
	{
		new okzone[ 40 ], Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		GetZone(x, y, z, okzone);
		SendClientMSG(forplayerid, 0xE0E0E0FF, " {FF0000}ADMIN | {E0E0E0} IP: %s | Location: %s | Int/VW: %d/%d",  PlayerTemp[playerid][IP], okzone, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	}
	SendClientMessage(forplayerid, 0x3696EBFF, "_____________________________________________________________________________________");
}

stock CheckExit(playerid, extra = 0)
{
	if(PlayerInfo[playerid][jail]) return 1;
	Streamer_Update(playerid);
	if(PlayerTemp[playerid][onpaint])
	{
		ResetPlayerWeaponsEx(playerid);
		if(PlayerTemp[playerid][pbteam] == 1) PBTeams[PlayerTemp[playerid][onpaint]][redteamcount]--;
		else if(PlayerTemp[playerid][pbteam] == 2) PBTeams[PlayerTemp[playerid][onpaint]][blueteamcount]--;
		PlayerTemp[playerid][pbteam] = 0;
		SetPlayerTeamEx(playerid, PlayerInfo[playerid][playerteam]);
		PlayerTemp[playerid][spawnrdy]=0;
		SetPlayerPos(playerid, BusinessInfo[PlayerTemp[playerid][onpaint]][bX], BusinessInfo[PlayerTemp[playerid][onpaint]][bY], BusinessInfo[PlayerTemp[playerid][onpaint]][bZ]);
      	SetPlayerInterior(playerid, BusinessInfo[PlayerTemp[playerid][onpaint]][bInterior]);
      	SetPlayerVirtualWorld(playerid, BusinessInfo[PlayerTemp[playerid][onpaint]][bVirtualWorld]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SaveBusiness(PlayerTemp[playerid][onpaint]);
		PlayerTemp[playerid][onpaint] = 0;
		return 1;
	}
	if(PlayerTemp[playerid][tmphouse] != -1 && !IsPlayerInAnyVehicle(playerid))
	{
	    new houseid = PlayerTemp[playerid][tmphouse];
		new intpack = HouseInfo[houseid][hInteriorPack];
	    if(!IsPlayerInRangeOfPoint(playerid, 4.0, IntInfo[intpack][intX], IntInfo[intpack][intY], IntInfo[intpack][intZ])) return SendClientError(playerid, "You are not close enough to the door.");
		SetPlayerPosEx(playerid, HouseInfo[houseid][hX], HouseInfo[houseid][hY], HouseInfo[houseid][hZ], HouseInfo[houseid][hInterior], HouseInfo[houseid][hVirtualWorld]);
		PlayerTemp[playerid][tmphouse] = -1;
		SaveHouse(houseid);
		return 1;
	}
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(HQInfo[f][hqActive] != true) continue;
		if(GetPlayerVirtualWorld(playerid) == HQInfo[f][fSpawnVW] && GetPlayerInterior(playerid) == HQInfo[f][fSpawnInt])
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, HQInfo[f][fSpawnX], HQInfo[f][fSpawnY], HQInfo[f][fSpawnZ]))
			{
				SetPlayerPos(playerid, HQInfo[f][fHQX], HQInfo[f][fHQY], HQInfo[f][fHQZ]);
				SetPlayerInterior(playerid, HQInfo[f][fHQInt]);
				SetPlayerVirtualWorld(playerid, HQInfo[f][fHQVW]);
				return 1;
			}
		}
		if(IsPlayerInRangeOfPoint(playerid, 4.0, HQInfo[f][fHQRoofX], HQInfo[f][fHQRoofY], HQInfo[f][fHQRoofZ]))
		{
			if(PlayerInfo[playerid][playerteam] == f || PlayerInfo[playerid][power]>=10 || HQInfo[f][hqOpen] == false)
			{
				SetPlayerPos(playerid, HQInfo[f][fSpawnX], HQInfo[f][fSpawnY], HQInfo[f][fSpawnZ]);
				SetPlayerInterior(playerid, HQInfo[f][fSpawnInt]);
				SetPlayerVirtualWorld(playerid, HQInfo[f][fSpawnVW]);
				return 1;
			}
			else return SendClientError(playerid,  "You are not allowed to do that.");
		}
	}
	for(new i=0;i<sizeof(places);i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, places[i][int_inx],places[i][int_iny],places[i][int_inz]) && GetPlayerVirtualWorld(playerid)==places[i][int_virtual] && GetPlayerInterior(playerid)==places[i][int_interior])
		{
			if(!IsPlayerInAnyVehicle(playerid)) SetPlayerPosEx(playerid,places[i][int_outx],places[i][int_outy],places[i][int_outz], 0, 0);
			return 1;
		}
	}
	// if(PlayerTemp[playerid][tmpbiz] != -1)
	if(IsPlayerInBiz(playerid, 2.0) != -1)
	{
		new tmpid = IsPlayerInBiz(playerid, 2.0);
		SetPlayerPos(playerid, BusinessInfo[tmpid][bX], BusinessInfo[tmpid][bY], BusinessInfo[tmpid][bZ]);
      	SetPlayerInterior(playerid, BusinessInfo[tmpid][bInterior]);
      	SetPlayerVirtualWorld(playerid, BusinessInfo[tmpid][bVirtualWorld]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SaveBusiness(tmpid);
		return 1;
	}
	if(IsPlayerDriver(playerid) && PlayerTemp[playerid][tazed] == 0 && PlayerTemp[playerid][cuffed] == false && PlayerTemp[playerid][carfrozen])
	{
		RemovePlayerFromVehicle(playerid);
		PlayerTemp[playerid][carfrozen]=0;
		SetTimer("CarFrozen",3000,0);
		TogglePlayerControllable(playerid,true);
		return 1;
	}
	TeleportLoop(t)
	{
		if(TeleportInfo[t][tpActive] != true) continue;
		if(IsPlayerInRangeOfPoint(playerid, 3.0, TeleportInfo[t][tpiX],  TeleportInfo[t][tpiY],  TeleportInfo[t][tpiZ]) && GetPlayerInterior(playerid) == TeleportInfo[t][tpiInt] && GetPlayerVirtualWorld(playerid) == TeleportInfo[t][tpiVW])
		{
			if(PlayerTemp[playerid][tmphouse] == TeleportInfo[t][tpHouseIID])
			{
				SetPlayerInterior(playerid, TeleportInfo[t][tpInt]);
				SetPlayerVirtualWorld(playerid, TeleportInfo[t][tpVW]);
				SetPlayerPos(playerid, TeleportInfo[t][tpX], TeleportInfo[t][tpY], TeleportInfo[t][tpZ]);
				SetPlayerFacingAngle(playerid, TeleportInfo[t][tpA]);
				SetCameraBehindPlayer(playerid);
				PlayerTemp[playerid][tmphouse] = TeleportInfo[t][tpHouseID];
				return 1;
			}
		}
	}
	if(extra)
	{
		if(GetPVarInt(playerid, "GarageID") != -1)
		{
			new _id = GetPVarInt(playerid, "GarageID");
			printf("[Extra #1] - Garage: %d!", _id);
			SetPlayerPosEx(playerid, HouseInfo[_id][hGarageX], HouseInfo[_id][hGarageY], HouseInfo[_id][hGarageZ]+0.5, HouseInfo[_id][hGarageInt], HouseInfo[_id][hGarageVW], false);
			printf("[Extra #1] - Garage: %d - X: %f | Y: %f | Z: %f | Int: %d | VW: %d!", _id, HouseInfo[_id][hGarageX], HouseInfo[_id][hGarageY], HouseInfo[_id][hGarageZ]+0.5, HouseInfo[_id][hGarageInt], HouseInfo[_id][hGarageVW]);
			if(IsPlayerInAnyVehicle(playerid))
			{
				new _vid = GetPlayerVehicleID(playerid);
				SetVehicleZAngle(_vid, HouseInfo[_id][hGarageA]);
				Up(playerid);
				SetTimerEx("PutPlayerInVehicleEx", 300, false, "dd", playerid, FindVehicleID(_vid));
			}
			SetPVarInt(playerid, "GarageID", -1);
		}
	}
	return 1;
}

stock CheckEnter(playerid, extra = 0)
{
	if(PlayerInfo[playerid][jail]) return 1;
	Streamer_Update(playerid);
    new tmpid;
    tmpid = IsPlayerOutHouse(playerid);
    if(tmpid != -1 && !IsPlayerInAnyVehicle(playerid))
	{
		if(HouseInfo[tmpid][hClosed] == true && PlayerInfo[playerid][housenum] != tmpid) return GameTextForPlayer(playerid,"~r~Closed", 3000, 3);
		new intpack = HouseInfo[tmpid][hInteriorPack];
		SetPlayerPos(playerid, IntInfo[intpack][intX], IntInfo[intpack][intY], IntInfo[intpack][intZ]);
		SetPlayerInterior(playerid, tmpid+1);
		SetPlayerVirtualWorld(playerid, tmpid+1);
		SetPlayerFacingAngle(playerid, IntInfo[intpack][intA]);
		SetCameraBehindPlayer(playerid);
		PlayerTemp[playerid][tmphouse] = tmpid;
		SaveHouse(tmpid);
		return 1;
	}
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(HQInfo[f][hqActive] != true) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, HQInfo[f][fHQX], HQInfo[f][fHQY], HQInfo[f][fHQZ]))
		{
	        if(PlayerInfo[playerid][playerteam] == f || HQInfo[f][hqOpen] == true || PlayerInfo[playerid][power] >= 10)
			{
	            SetPlayerPos(playerid, HQInfo[f][fSpawnX], HQInfo[f][fSpawnY], HQInfo[f][fSpawnZ]);
				SetPlayerFacingAngle(playerid, HQInfo[f][fSpawnA]);
	            SetPlayerInterior(playerid, HQInfo[f][fSpawnInt]);
	            SetPlayerVirtualWorld(playerid, HQInfo[f][fSpawnVW]);
				SetCameraBehindPlayer(playerid);
	            return 1;
	         }
	         else return SendClientError(playerid, "You are not allowed to enter this HQ!");
		}
	}
	for(new i=0;i<sizeof(places);i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,3.0, places[i][int_outx],places[i][int_outy],places[i][int_outz]) && !IsPlayerInAnyVehicle(playerid))
		{
			SetPlayerPos(playerid,places[i][int_inx],places[i][int_iny],places[i][int_inz]);
			SetPlayerInterior(playerid, places[i][int_interior]);
			SetPlayerVirtualWorld(playerid, places[i][int_virtual]);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
	}
	tmpid=IsPlayerOutBiz(playerid);
	if(tmpid != -1)
	{
		if(BusinessInfo[tmpid][bLocked] == true && BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK) return GameTextForPlayer(playerid,"~r~Closed",3000,3);
		new iCount;
		for(new c = 0; c < sizeof(BusinessInteriors); c++)
		{
			if(BusinessInteriors[c][intType] == BusinessInfo[tmpid][bType]) iCount++;
		}
		if(iCount == 0) return SendClientError(playerid, "This business is not enterable!");
		new h, m, s; gettime(h,m,s);
		if(BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && h < 7 || BusinessInfo[tmpid][bType] == BUSINESS_TYPE_BANK && h > 22) return SendClientError(playerid, "The bank is closed! Use ATM Machines.");
		if(BusinessInfo[tmpid][bType] != BUSINESS_TYPE_BANK)
		{
			new entrance = BusinessInfo[tmpid][bFee];
			if(PlayerInfo[playerid][playerlvl] > 2)
			{
				if(entrance > HandMoney(playerid))
					return SendClientError(playerid, "You don't have enough money to enter this business!");
				GivePlayerMoneyEx(playerid, -entrance);
				BusinessInfo[tmpid][bTill] += entrance;
			}
		}
	   	if(BusinessInfo[tmpid][bType] == BUSINESS_TYPE_PAINTBALL)
		{
			if(!SetPlayerPaintBall(playerid, tmpid, 666))
				return SendClientError(playerid,  "Unable to get inside the PaintBall. Main reason: Full");
			return 1;
		}
		new inteLevel = GetRealBusinessID(tmpid);
		SetPlayerInterior(playerid, BusinessInteriors[inteLevel][enterInt]);
		SetPlayerVirtualWorld(playerid, tmpid+1);
		SetPlayerPos(playerid, BusinessInteriors[inteLevel][enterX], BusinessInteriors[inteLevel][enterY], BusinessInteriors[inteLevel][enterZ]);
		SetCameraBehindPlayer(playerid);
		PlayerTemp[playerid][tmpbiz] = tmpid;
		SaveBusiness(tmpid);
		return 1;
	}
	TeleportLoop(t)
	{
		if(TeleportInfo[t][tpActive] != true) continue;
		if(IsPlayerInRangeOfPoint(playerid, 3.0, TeleportInfo[t][tpX],  TeleportInfo[t][tpY],  TeleportInfo[t][tpZ]))
		{
			if(GetPlayerInterior(playerid) == TeleportInfo[t][tpInt] && GetPlayerVirtualWorld(playerid) == TeleportInfo[t][tpVW])
			{
				if(PlayerTemp[playerid][tmphouse] == TeleportInfo[t][tpHouseID])
				{
					SetPlayerInterior(playerid, TeleportInfo[t][tpiInt]);
					SetPlayerVirtualWorld(playerid, TeleportInfo[t][tpiVW]);
					SetPlayerPos(playerid, TeleportInfo[t][tpiX], TeleportInfo[t][tpiY], TeleportInfo[t][tpiZ]);
					SetPlayerFacingAngle(playerid, TeleportInfo[t][tpiA]);
					SetCameraBehindPlayer(playerid);
					PlayerTemp[playerid][tmphouse] = TeleportInfo[t][tpHouseIID];
					return 1;
				}
			}
		}
	}
	if(extra)
	{
		tmpid = IsPlayerOutGarage(playerid);
		if(tmpid != -1)
		{
			new garageID = HouseInfo[tmpid][hGarageInteriorPack];
			if(HouseInfo[tmpid][hGarageOpen] != true) return GameTextForPlayer(playerid,"~r~Closed",3000,3);
			if(garageID == 0) return GameTextForPlayer(playerid,"~r~No interior~n~~w~/house upgrade",1000,3);
			SetPlayerPosEx(playerid, garages[garageID][g_x], garages[garageID][g_y], garages[garageID][g_z]+0.5, 0, tmpid+1, false);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), garages[garageID][g_a]);
			SetPVarInt(playerid, "GarageID", tmpid);
			return 1;
		}
	}
	return 1;
}

stock IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

stock TDWarning(playerid, const wrnmsg[], wrntime)
{
	format(iStr, sizeof(iStr), "~r~%s", wrnmsg);
	TextDrawSetString(PlayerTemp[playerid][plrwarning], iStr);
	TextDrawShowForPlayer(playerid, PlayerTemp[playerid][plrwarning]);
	SetTimerEx("KillTDWarning", wrntime, false, "d", playerid);
}

stock SetJailTD(playerid, const wrnmsg[])
{
	format(iStr, sizeof(iStr), "~r~%s", wrnmsg);
	TextDrawSetString(PlayerTemp[playerid][jailtd], iStr);
	TextDrawShowForPlayer(playerid, PlayerTemp[playerid][jailtd]);
}

stock RedScreen(playerid, time)
{
	new colour = minrand(1,3);
	if(colour == 1) TextDrawBoxColor(InjuredTD,0xff000066);
	if(colour == 2) TextDrawBoxColor(InjuredTD,0xff000033);
	else TextDrawBoxColor(InjuredTD,0xff000099);
	time = time*1000;
	SetTimerEx("HideRedScreen", time, false, "d", playerid);
	TextDrawShowForPlayer(playerid, InjuredTD);
	PlayerTemp[playerid][HasRedScreen] = 1;
	return 1;
}

stock IsPlayerInTurf( playerid, turfID )
{
	if(IsPlayerInArea(playerid, Gangzones[turfID][minX], Gangzones[turfID][minY], Gangzones[turfID][maxX], Gangzones[turfID][maxY])) return 1;
	return 0;
}

stock GetClosestBiz( playerid, bizTYPE )
{
	new cl_ID = -1, Float:cl_DIST = 9999.0;
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(BusinessInfo[b][bType] != bizTYPE) continue;
		if( GetPlayerDistanceToPointEx(playerid, BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ]) < cl_DIST )
		{
		    cl_ID = b;
		    cl_DIST = GetPlayerDistanceToPointEx(playerid, BusinessInfo[b][bX], BusinessInfo[b][bY], BusinessInfo[b][bZ]);
		}
	}
	return cl_ID;
}

stock GetClosestATM( playerid )
{
	new cl_ID = -1, Float:cl_DIST = 9999.0;
	ATMLoop(i)
	{
	    if(ATMInfo[i][atmActive] != true) continue;
		if( GetPlayerDistanceToPointEx(playerid, ATMInfo[i][atmX], ATMInfo[i][atmY], ATMInfo[i][atmZ]) < cl_DIST )
		{
		    cl_ID = i;
		    cl_DIST = GetPlayerDistanceToPointEx(playerid, ATMInfo[i][atmX], ATMInfo[i][atmY], ATMInfo[i][atmZ]);
		}
	}
	return cl_ID;
}

stock SecurityLog(playerid, sReason[])
{
	new iQuery[228], ip[31];
	GetPlayerIp(playerid, ip, sizeof(ip));
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `Security` (`PlayerName`, `IP`, `TimeDate`, `Reason`) VALUES ('%e', '%e', '%e', '%e')", PlayerName(playerid), ip, TimeDateEx(), sReason);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock ChangePlayerName(oldnick[], newnick[])
{
	new iQuery[158];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `PlayerName` = '%e' WHERE `PlayerName` = '%e'", newnick, oldnick);
	mysql_tquery(MySQLPipeline, iQuery);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `HDuplicatedKey` SET `Owner` = '%e' WHERE `Owner` = '%e'", newnick, oldnick);
	mysql_tquery(MySQLPipeline, iQuery);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `NameChanges` (`NewName`, `OldName`, `TimeDate`) VALUES ('%e', '%e', '%e')", newnick, oldnick, TimeDateEx());
	mysql_tquery(MySQLPipeline, iQuery);
	HouseLoop(h)
	{
		if(HouseInfo[h][hActive] != true) continue;
		if(!strcmp(HouseInfo[h][hOwner], oldnick, false))
		{
			myStrcpy(HouseInfo[h][hOwner], newnick);
			SaveHouse(h);
		}
	}
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) continue;
	    if(!strcmp(BusinessInfo[b][bOwner], oldnick, false))
	    {
			myStrcpy(BusinessInfo[b][bOwner], newnick);
			ReloadBusiness(b);
	    }
	}
	VehicleLoop(i)
	{
	    if(VehicleInfo[i][vActive] != true) continue;
		if(!strcmp(VehicleInfo[i][vOwner], oldnick))
		{
			myStrcpy(VehicleInfo[i][vOwner], newnick);
			SaveVehicle(i);
		}
	}
	new nickid = GetPlayerId(oldnick);
	if(IsPlayerConnected(nickid))
	{
		SetPlayerName(nickid, newnick);
		SendClientMessage(nickid, COLOR_LIGHTGREY, "");
		SendClientMessage(nickid, COLOR_LIGHTGREY, "");
		SendClientMessage(nickid, COLOR_LIGHTGREY, "");
		SendClientMessage(nickid, COLOR_RED, "=========================== ATTENTION ===========================");
		SendClientMessage(nickid, COLOR_LIGHTGREY, "");
		format(iStr, sizeof(iStr), " Your name has been changed to \"%s\". Make sure you always login with that name now!", newnick);
		SendClientMessage(nickid, COLOR_LIGHTGREY, iStr);
		SendClientMessage(nickid, COLOR_LIGHTGREY, "");
		SendClientMessage(nickid, COLOR_RED, "=========================== ATTENTION ===========================");
		SendClientMessage(nickid, COLOR_LIGHTGREY, "");
		SendClientMessage(nickid, COLOR_LIGHTGREY, "");
	}
	return 1;
}

/***********************************************************************************************************************
	ATM Functions
***********************************************************************************************************************/
stock GetUnusedATM()
{
	ATMLoop(i)
	{
	    if(ATMInfo[i][atmActive] != true) return i;
	}
	return -1;
}

stock CreateATM(Float:X, Float:Y, Float:Z, Float:rotX, Float:rotY, Float:rotZ, Interior, VirtualWorld)
{
	new atmid = GetUnusedATM();
	if(atmid == -1) return printf("[ERROR] - Maximum ATMS reached. %d/%d", atmid, MAX_ATMS);
	new iQuery[250];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `ATMInfo` (`ID`, `X`, `Y`, `Z`, `rotX`, `rotY`, `rotZ`, `Interior`, `VirtualWorld`) VALUES (%d, %f, %f, %f, %f, %f, %f, %d, %d)", atmid, X, Y, Z, rotX, rotY, rotZ, Interior, VirtualWorld);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadATM(atmid, false);
	return 1;
}

stock DeleteATM(atmid)
{
	new iQuery[182];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `ATMInfo` WHERE `ID` = %d", atmid);
	mysql_tquery(MySQLPipeline, iQuery);
	
	DestroyDynamicObject(ATMInfo[atmid][atmObject]);
    DestroyDynamic3DTextLabel(ATMInfo[atmid][atmLabel]);

    ATMInfo[atmid][atmX] = 0.0;
    ATMInfo[atmid][atmY] = 0.0;
    ATMInfo[atmid][atmZ] = 0.0;
    ATMInfo[atmid][atmrotX] = 0.0;
    ATMInfo[atmid][atmrotY] = 0.0;
    ATMInfo[atmid][atmrotZ] = 0.0;
    ATMInfo[atmid][atmInterior] = 0;
    ATMInfo[atmid][atmVirtualWorld] = 0;
    ATMInfo[atmid][atmActive] = false;
	return 1;
}

stock LoadATMs()
{
	mysql_tquery(MySQLPipeline, "SELECT * FROM `ATMInfo`", "OnLoadATMS", "d", 1);
}

stock ReloadATM(atmid, bool:tosave = true)
{
	if(tosave == true) SaveATM(atmid);
	SetTimerEx("OnReloadATM", 500, 0, "i", atmid);
}

stock SaveATM(atmid)
{
	new iQuery[500], iFormat[212];
	strcat(iQuery, "UPDATE `ATMInfo` SET ");
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", ATMInfo[atmid][atmX]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", ATMInfo[atmid][atmY]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", ATMInfo[atmid][atmZ]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rotX` = '%f', ", ATMInfo[atmid][atmrotX]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rotY` = '%f', ", ATMInfo[atmid][atmrotY]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rotZ` = '%f', ", ATMInfo[atmid][atmrotZ]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Interior` = %d, ", ATMInfo[atmid][atmInterior]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VirtualWorld` = %d WHERE `ID` = %d", ATMInfo[atmid][atmVirtualWorld], atmid);
	strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

/***********************************************************************************************************************
	Gate Functions
***********************************************************************************************************************/

stock LoadGates()
{
	mysql_tquery(MySQLPipeline, "SELECT * FROM `GateInfo`", "OnLoadGates", "d", 1);
}

stock GetUnusedGate()
{
	LOOP:g(0, MAX_GATES)
	{
		if(GateInfo[g][gateActive] != true) return g;
	}
	return -1;
}

stock CreateGate(Float:X, Float:Y, Float:Z, Float:grX, Float:grY, Float:grZ, Interior, VirtualWorld)
{
	new gateid = GetUnusedGate();
	if(gateid == -1) return print("[CreateGate] All slots are vacant, please reconfigure the maximum gates allowed."), 0;
	new iQuery[250];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `GateInfo` (`ID`, `X`, `Y`, `Z`, `rX`, `rY`, `rZ`, `Interior`, `VirtualWorld`) VALUES (%d, %f, %f, %f, %f, %f, %f, %d, %d)", gateid, X, Y, Z, grX, grY, grZ, Interior, VirtualWorld);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadGate(gateid, false);
	return 1;
}

stock DeleteGate(gateid)
{
	if(gateid < 0 || gateid >= MAX_GATES || GateInfo[gateid][gateActive] != true) return 0;
	new iQuery[182];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `GateInfo` WHERE `ID` = %d", gateid);
	mysql_tquery(MySQLPipeline, iQuery);
	
	DestroyDynamicObject(GateInfo[gateid][gateObject]);

	myStrcpy(GateInfo[gateid][gateName], "None");
	GateInfo[gateid][gateModel] = 975;
	GateInfo[gateid][gateX] = 0.0;
	GateInfo[gateid][gateY] = 0.0;
	GateInfo[gateid][gateZ] = 0.0;
	GateInfo[gateid][gateRX] = 0.0;
	GateInfo[gateid][gateRY] = 0.0;
	GateInfo[gateid][gateRZ] = 0.0;
	GateInfo[gateid][gateMX] = 0.0;
	GateInfo[gateid][gateMY] = 0.0;
	GateInfo[gateid][gateMZ] = 0.0;
	GateInfo[gateid][gateMRX] = 0.0;
	GateInfo[gateid][gateMRY] = 0.0;
	GateInfo[gateid][gateMRZ] = 0.0;
	GateInfo[gateid][gateInterior] = 0;
	GateInfo[gateid][gateVirtualWorld] = 0;
	GateInfo[gateid][gateHouse] = -1;
	GateInfo[gateid][gateBusiness] = -1;
	GateInfo[gateid][gateFaction] = CIV;
	myStrcpy(GateInfo[gateid][gateOwner], "NoBodY");
	GateInfo[gateid][gateActive] = false;
	return 1;
}

stock ReloadGate(gateid, bool:tosave = true)
{
	if(tosave == true) SaveGate(gateid);
	SetTimerEx("OnReloadGate", 500, 0, "i", gateid);
}

stock SaveGate(gateid)
{
	new iQuery[750], iFormat[212];
	strcat(iQuery, "UPDATE `GateInfo` SET ");
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Model` = '%f', ", GateInfo[gateid][gateModel]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Name` = '%e', ", GateInfo[gateid][gateName]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", GateInfo[gateid][gateRX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", GateInfo[gateid][gateRY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", GateInfo[gateid][gateRZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rX` = '%f', ", GateInfo[gateid][atmrotX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rY` = '%f', ", GateInfo[gateid][atmrotY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rZ` = '%f', ", GateInfo[gateid][atmrotZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`mX` = '%f', ", GateInfo[gateid][gateMX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`mY` = '%f', ", GateInfo[gateid][gateMY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`mZ` = '%f', ", GateInfo[gateid][gateMZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`mrX` = '%f', ", GateInfo[gateid][gateMRX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`mrY` = '%f', ", GateInfo[gateid][gateMRY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`mrZ` = '%f', ", GateInfo[gateid][gateMRZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Interior` = %d, `VirtualWorld` = %d, ", GateInfo[gateid][gateInterior], GateInfo[gateid][gateVirtualWorld]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`House` = '%d', ", GateInfo[gateid][gateHouse]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Business` = '%d', ", GateInfo[gateid][gateBusiness]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Faction` = '%d', ", GateInfo[gateid][gateFaction]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Owner` = '%e' WHERE `ID` = %d", GateInfo[gateid][gateVirtualWorld], gateid); strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

/***********************************************************************************************************************
	Business Functions
***********************************************************************************************************************/

stock GetRealBusinessID(businessid)
{
	new inteID = BusinessInfo[businessid][bInteriorPack], iCount;
	LOOP:iID(0, sizeof(BusinessInteriors))
	{
		if(BusinessInteriors[iID][intType] != BusinessInfo[businessid][bType]) continue;
		if(iCount == inteID) return iID;
		iCount++;
	}
	return -1;
}

stock GetUnusedBusiness()
{
	BusinessLoop(b)
	{
	    if(BusinessInfo[b][bActive] != true) return b;
	}
	return -1;
}

stock LoadBusinesses()
{
	mysql_tquery(MySQLPipeline, "SELECT * FROM `BusinessInfo`", "OnLoadBusinesses", "d", 1);
	return 1;
}

stock CreateBusiness(bizOwner[], bizType, Float:bizX, Float:bizY, Float:bizZ, Interior, VirtualWorld)
{
	new businessid = GetUnusedBusiness(), compsF;
	if(businessid == -1) return printf("[ERROR] - Maximum businesses reached. %d/%d", businessid, MAX_BUSINESS);
	if(bizType == BUSINESS_TYPE_247
	|| bizType == BUSINESS_TYPE_HARDWARE
	|| bizType == BUSINESS_TYPE_DRUGFACTORY
	|| bizType == BUSINESS_TYPE_BURGER
	|| bizType == BUSINESS_TYPE_PIZZA
	|| bizType == BUSINESS_TYPE_CHICKEN
	|| bizType == BUSINESS_TYPE_RESTAURANT) compsF = STUFFS;
	else if(bizType == BUSINESS_TYPE_GUNSTORE) compsF = GUNS;
	else if(bizType == BUSINESS_TYPE_PUB
	|| bizType == BUSINESS_TYPE_STRIPCLUB
	|| bizType == BUSINESS_TYPE_CLUB) compsF = ALCHOOL;
	else if(bizType == BUSINESS_TYPE_BIKE_DEALER
	|| bizType == BUSINESS_TYPE_HEAVY_DEALER
	|| bizType == BUSINESS_TYPE_CAR_DEALER
	|| bizType == BUSINESS_TYPE_LUXUS_DEALER
	|| bizType == BUSINESS_TYPE_NOOB_DEALER
	|| bizType == BUSINESS_TYPE_AIR_DEALER
	|| bizType == BUSINESS_TYPE_BOAT_DEALER
	|| bizType == BUSINESS_TYPE_JOB_DEALER
	|| bizType == BUSINESS_TYPE_WHEEL
	|| bizType == BUSINESS_TYPE_PAYNSPRAY) compsF = CARS;
	else if(bizType == BUSINESS_TYPE_GAS) compsF = OIL;
	else compsF = NOCOMPS;
	new iQuery[250];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `BusinessInfo` (`ID`, `Owner`, `Type`, `X`, `Y`, `Z`, `CompsFlag`, `Interior`, `VirtualWorld`) VALUES (%d, '%e', %d, %f, %f, %f, %d, %d, %d)", businessid, bizOwner, bizType, bizX, bizY, bizZ, compsF, Interior, VirtualWorld);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadBusiness(businessid, false);
	return 1;
}

stock ReloadBusiness(businessid, bool:tosave = true)
{
	if(tosave == true) SaveBusiness(businessid);
    SetTimerEx("OnReloadBusiness", 500, 0, "i", businessid);
	return 1;
}

stock UpdateBiz(bizID, tosave = 1)
{
	if(tosave == 1) SaveBusiness(bizID);
	new tmps[500], bizcommands[ 50 ];
	switch(BusinessInfo[bizID][bType])
	{
		case BUSINESS_TYPE_BANK: myStrcpy(bizcommands, "/deposit - /withdraw - /balance");
		case BUSINESS_TYPE_247: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_HARDWARE: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_GAS: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_GUNSTORE: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_PIZZA: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_BURGER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_CHICKEN: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_RESTAURANT: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_DRUGFACTORY: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_DRUGSTORE: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_STADIUM: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_BIKE_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_HEAVY_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_CAR_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_LUXUS_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_NOOB_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_AIR_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_BOAT_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_JOB_DEALER: myStrcpy(bizcommands, "/buy");
		case BUSINESS_TYPE_RENT: myStrcpy(bizcommands, "/rentcar");
		case BUSINESS_TYPE_CAFE: myStrcpy(bizcommands, "/buy - /drink");
		case BUSINESS_TYPE_CLOTHES: myStrcpy(bizcommands, "/clothes");
		case BUSINESS_TYPE_WHEEL: myStrcpy(bizcommands, "/car wheels");
		case BUSINESS_TYPE_ADTOWER: myStrcpy(bizcommands, "/ad - /cad");
		case BUSINESS_TYPE_PHONE: myStrcpy(bizcommands, "/c - /sms");
		case BUSINESS_TYPE_EXPORT: myStrcpy(bizcommands, "/dropcar");
		default: myStrcpy(bizcommands, "N/A");
	}
	new iFormat[168];
	if(BusinessInfo[bizID][bType] != BUSINESS_TYPE_BANK)
	{
		new iOpen[30], iInStock[30];
		
		if(BusinessInfo[bizID][bLocked] == true) myStrcpy(iOpen, "{CC2900}Closed");
		else myStrcpy(iOpen, "{66FF66}Opened");
		
		if(BusinessInfo[bizID][bComps] > 2) myStrcpy(iInStock, "{66FF66}In Stock");
		else myStrcpy(iInStock, "{CC2900}Out of Stock");
		
		format(iFormat, sizeof(iFormat), "{0358d8}[%s {0358d8}| %s{0358d8}]\n", iOpen, iInStock);
		strcat(tmps, iFormat);
	}
	format(iFormat, sizeof(iFormat), "{0358d8}[ {ffffff}%s{0358d8} ]\n", BusinessInfo[bizID][bName]); strcat(tmps, iFormat);
	format(iFormat, sizeof(iFormat), "{0358d8}Owner: {ffffff}%s\n", NoUnderscore(BusinessInfo[bizID][bOwner])); strcat(tmps, iFormat);
	format(iFormat, sizeof(iFormat), "{0358d8}Commands: {ffffff}%s", bizcommands); strcat(tmps, iFormat);
	if(BusinessInfo[bizID][bBuyable] == 1)
	{
		format(iFormat, sizeof(iFormat), "\n{0358d8}For Sale: {ffffff}$%s", number_format(BusinessInfo[bizID][bSellprice]));
		strcat(tmps, iFormat);
	}
	DestroyDynamic3DTextLabel(BusinessInfo[bizID][bLabel]);
	BusinessInfo[bizID][bLabel] = CreateDynamic3DTextLabel(tmps, COLOR_PLAYER_SPECIALBLUE, BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ]+0.3, 10.0);
	DestroyDynamicArea(BusinessInfo[bizID][bArea]);
	BusinessInfo[bizID][bArea] = CreateDynamicCircle(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], 2.0);
	if(BusinessInfo[bizID][bType] == BUSINESS_TYPE_BANK)
	{
		DestroyDynamicMapIcon(BusinessInfo[bizID][bMapIcon]);
		BusinessInfo[bizID][bMapIcon] = CreateDynamicMapIcon(BusinessInfo[bizID][bX], BusinessInfo[bizID][bY], BusinessInfo[bizID][bZ], 56, 0xAAFFAAFF);
	}
}

stock SaveBusiness(bid)
{
	if(BusinessInfo[bid][bActive] != true)
	{
	    printf("[ERROR] Failed to save business: %d - Not VALID", bid);
	    return 0;
	}
	new iQuery[1400], iFormat[175];
	strcat(iQuery, "UPDATE `BusinessInfo` SET ");
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Owner` = '%e', ", BusinessInfo[bid][bOwner]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Dupekey` = '%e', ", BusinessInfo[bid][bDupekey]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Name` = '%e', ", BusinessInfo[bid][bName]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", BusinessInfo[bid][bX]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", BusinessInfo[bid][bY]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", BusinessInfo[bid][bZ]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Interior` = %d, ", BusinessInfo[bid][bInterior]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VirtualWorld` = %d, ", BusinessInfo[bid][bVirtualWorld]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Type` = %d, ", BusinessInfo[bid][bType]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`CompsFlag` = %d, ", BusinessInfo[bid][bCompsFlag]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Tax` = %d, ", BusinessInfo[bid][bTax]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`LastRob` = %d, ", BusinessInfo[bid][bLastRob]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Level` = %d, ", BusinessInfo[bid][bLevel]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Sellprice` = %d, ", BusinessInfo[bid][bSellprice]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Restock` = %d, ", BusinessInfo[bid][bRestock]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RentPrice` = %d, ", BusinessInfo[bid][bRentPrice]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Till` = %d, ", BusinessInfo[bid][bTill]);
	strcat(iQuery, iFormat);
	new isLocked; if(BusinessInfo[bid][bLocked] == true) isLocked = 1; else isLocked = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Locked` = %d, ", isLocked);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Comps` = %d, ", BusinessInfo[bid][bComps]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Fee` = %d, ", BusinessInfo[bid][bFee]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Deagle` = %d, ", BusinessInfo[bid][bDeagle]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MP5` = %d, ", BusinessInfo[bid][bMP5]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`M4` = %d, ", BusinessInfo[bid][bM4]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Shotgun` = %d, ", BusinessInfo[bid][bShotgun]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Rifle` = %d, ", BusinessInfo[bid][bRifle]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Sniper` = %d, ", BusinessInfo[bid][bSniper]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Armour` = %d, ", BusinessInfo[bid][bArmour]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`AskComps` = %d, ", BusinessInfo[bid][bAskComps]);
	strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Buyable` = %d WHERE `ID` = %d", BusinessInfo[bid][bBuyable], bid);
	strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

/***********************************************************************************************************************
	House Functions
***********************************************************************************************************************/
stock LoadFactions()
{
	mysql_tquery(MySQLPipeline, "SELECT * FROM `FactionInfo`", "OnLoadFactions", "d", 1);
	mysql_tquery(MySQLPipeline, "SELECT * FROM `HQInfo`", "OnLoadHQs", "d", 1);
	mysql_tquery(MySQLPipeline, "SELECT * FROM `WHInfo`", "OnLoadWHs", "d", 1);
	return 1;
}

stock ReloadFaction(factionid, bool:tosave = true)
{
	if(tosave == true) SaveFaction(factionid);
    SetTimerEx("OnReloadFaction", 500, 0, "i", factionid);
	return 1;
}

stock PlayersAroundSameFaction(playerid)
{
	new rCount = 0,Float:rPos[4];
	GetPlayerPos(playerid, rPos[0], rPos[1], rPos[2]);
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(!IsPlayerConnected(i)) continue;
 		if(!IsPlayerInRangeOfPoint(i, 20.0, rPos[0], rPos[1], rPos[2])) continue;
		if(PlayerInfo[i][playerteam] != PlayerInfo[playerid][playerteam]) continue;
		rCount++;
	}
	return rCount;
}

stock GetUnusedFaction()
{
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) return f;
	}
	return -1;
}

stock CreateFaction(factionType, factionName[])
{
	new factionid = GetUnusedFaction();
	if(factionid == -1) return printf("[ERROR] - Maximum factions reached. %d/%d", factionid, MAX_FACTIONS);
	new iQuery[250];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `FactionInfo` (`ID`, `Type`, `FactionName`) VALUES (%d, %d, '%e')", factionid, factionType, factionName);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadFaction(factionid, false);
	return 1;
}

stock CreateHQ(factionid, Float:hqX, Float:hqY, Float:hqZ, Float:hqA, hqInterior, hqVirtualWorld)
{
	if(factionid == -1 || FactionInfo[factionid][fActive] != true || HQInfo[factionid][hqActive] != false) return printf("[ERROR] - Maximum factions reached. %d/%d", factionid, MAX_FACTIONS);
	new iQuery[350];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `HQInfo` (`ID`, `X`, `Y`, `Z`, `A`, `Interior`, `VirtualWorld`) VALUES (%d, '%f', '%f', '%f', '%f', %d, %d)", factionid, hqX, hqY, hqZ, hqA, hqInterior, hqVirtualWorld);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadFaction(factionid, false);
	return 1;
}

stock CreateWH(factionid, Float:whx, Float:why, Float:whz, whInt, whVW)
{
	if(factionid == -1 || FactionInfo[factionid][fActive] != true || WareHouseInfo[factionid][whActive] != false) return printf("[ERROR] - Maximum warehouses reached. %d/%d", factionid, MAX_FACTIONS);
	new iQuery[550];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `WHInfo` (`ID`, `X`, `Y`, `Z`, `Interior`, `VirtualWorld`) VALUES (%d, '%f', '%f', '%f', %d, %d)", factionid, whx, why, whz, whInt, whVW);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadFaction(factionid, false);
	return 1;
}

stock DeleteFaction(factionid)
{
	new iQuery[182];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `FactionInfo` WHERE `ID` = %d", factionid);
	mysql_tquery(MySQLPipeline, iQuery);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `HQInfo` WHERE `ID` = %d", factionid);
	mysql_tquery(MySQLPipeline, iQuery);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `WHInfo` WHERE `ID` = %d", factionid);
	mysql_tquery(MySQLPipeline, iQuery);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `PlayerInfo` SET `FactionID` = 255, `FactionName` = 'CIV', `FactionPay` = 0, `RankName` = 'CIV', `Tier` = -1 WHERE `FactionID` = %d", factionid);
	mysql_tquery(MySQLPipeline, iQuery);
	PlayerLoop(p)
	{
		if(PlayerTemp[p][loggedIn] != true) continue;
		if(PlayerInfo[p][playerteam] == factionid)
		{
			Uninvite(p, "SERVER");
		}
	}
	myStrcpy(FactionInfo[factionid][fName], "None");
	FactionInfo[factionid][fType] = -1;
	FactionInfo[factionid][fColour] = 0xFFFFFFFF;
	FactionInfo[factionid][fGangZoneColour] = 0xFFFFFF99;
	FactionInfo[factionid][fPoints] = 0;
	FactionInfo[factionid][fTogChat] = false;
	FactionInfo[factionid][fTogColour] = false;
	FactionInfo[factionid][fMaxVehicles] = 0;
	FactionInfo[factionid][fMaxMemberSlots] = 0;
	FactionInfo[factionid][fStartpayment] = 0;
	myStrcpy(FactionInfo[factionid][fLeader], "NoBodY");
	myStrcpy(FactionInfo[factionid][fStartrank], "None");
	myStrcpy(FactionInfo[factionid][fMOTD], "None");
	FactionInfo[factionid][fBank] = 0;
	FactionInfo[factionid][fFreq] = INVALID_RADIO_FREQ;
	FactionInfo[factionid][fStockLevel] = 0;
	FactionInfo[factionid][fSDCCompsPrice] = 0;
	FactionInfo[factionid][fSDCWarehouse] = 0;
	FactionInfo[factionid][fActive] = false;
	
	HQInfo[factionid][flSpawnX] = 0.0;
	HQInfo[factionid][flSpawnY] = 0.0;
	HQInfo[factionid][flSpawnZ] = 0.0;
	HQInfo[factionid][flSpawnA] = 0.0;
	HQInfo[factionid][flSpawnInt] = 0;
	HQInfo[factionid][flSpawnVW] = 0;
	HQInfo[factionid][fSpawnX] = 0.0;
	HQInfo[factionid][fSpawnY] = 0.0;
	HQInfo[factionid][fSpawnZ] = 0.0;
	HQInfo[factionid][fSpawnA] = 0.0;
	HQInfo[factionid][fSpawnInt] = 0;
	HQInfo[factionid][fSpawnVW] = 0;
	HQInfo[factionid][fHQX] = 0.0;
	HQInfo[factionid][fHQY] = 0.0;
	HQInfo[factionid][fHQZ] = 0.0;
	HQInfo[factionid][fHQA] = 0.0;
	HQInfo[factionid][fHQInt] = 0;
	HQInfo[factionid][fHQVW] = 0;
	HQInfo[factionid][fHQRoofX] = 0.0;
	HQInfo[factionid][fHQRoofY] = 0.0;
	HQInfo[factionid][fHQRoofZ] = 0.0;
	HQInfo[factionid][fHQRoofA] = 0.0;
	HQInfo[factionid][hqOpen] = false;
	HQInfo[factionid][fHQStockTog] = false;
	HQInfo[factionid][fHQStock] = 0;
	HQInfo[factionid][hqActive] = false;
	DestroyDynamicPickup(HQInfo[factionid][hqPickup]);
	DestroyDynamic3DTextLabel(HQInfo[factionid][hqLabel]);
	
	WareHouseInfo[factionid][whX] = 0.0;
	WareHouseInfo[factionid][whY] = 0.0;
	WareHouseInfo[factionid][whZ] = 0.0;
	WareHouseInfo[factionid][whInterior] = 0;
	WareHouseInfo[factionid][whVirtualWorld] = 0;
	WareHouseInfo[factionid][whOpen] = false;
	WareHouseInfo[factionid][whMaterials] = 0;
	WareHouseInfo[factionid][whLead] = 0;
	WareHouseInfo[factionid][whMetal] = 0;
	DestroyDynamic3DTextLabel(WareHouseInfo[factionid][whLabel]);
	KillTimer(WareHouseInfo[factionid][whTimer]);
	WareHouseInfo[factionid][whActive] = false;
	VehicleLoop(v)
	{
		if(VehicleInfo[v][vActive] != true) continue;
		if(VehicleInfo[v][vFaction] == factionid)
		{
			DeleteVehicle(v);
		}
	}
	return 1;
}

stock SaveFaction(factionid)
{
	if(FactionInfo[factionid][fActive] != true) return printf("[ERROR] Failed to save faction: %d - Not VALID", factionid);
	new iQuery[850], iFormat[125], iiQuery[850], iSave, iiiQuery[850];
	strcat(iQuery, "UPDATE `FactionInfo` SET ");
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`FactionName` = '%e', ", FactionInfo[factionid][fName]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Type` = %d, ", FactionInfo[factionid][fType]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Colour` = %d, ", FactionInfo[factionid][fColour]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GangZoneColour` = %d, ", FactionInfo[factionid][fGangZoneColour]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Points` = %d, ", FactionInfo[factionid][fPoints]);strcat(iQuery, iFormat);
	if(FactionInfo[factionid][fTogChat] == true) iSave = 1; else iSave = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TogChat` = %d, ", iSave);strcat(iQuery, iFormat);
	if(FactionInfo[factionid][fTogColour] == true) iSave = 1; else iSave = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`TogColour` = %d, ", iSave);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MaxVehicles` = %d, ", FactionInfo[factionid][fMaxVehicles]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MaxMembers` = %d, ", FactionInfo[factionid][fMaxMemberSlots]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Startpayment` = %d, ", FactionInfo[factionid][fStartpayment]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Startrank` = '%e', ", FactionInfo[factionid][fStartrank]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Leader` = '%e', ", FactionInfo[factionid][fLeader]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MOTD` = '%e', ", FactionInfo[factionid][fMOTD]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Bank` = %d, ", FactionInfo[factionid][fBank]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Freq` = %d, ", FactionInfo[factionid][fFreq]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`StockLevel` = %d, ", FactionInfo[factionid][fStockLevel]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SDCWarehouse` = %d, ", FactionInfo[factionid][fSDCWarehouse]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SDCCompsprice` = %d ", FactionInfo[factionid][fSDCCompsPrice]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "WHERE `ID` = %d", factionid);strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
	
	if(HQInfo[factionid][hqActive] != false)
	{
		strcat(iiQuery, "UPDATE `HQInfo` SET ");
		if(HQInfo[factionid][hqOpen] == true) iSave = 1; else iSave = 0;
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Open` = %d, ", iSave); strcat(iiQuery, iFormat);
		if(HQInfo[factionid][fHQStockTog] == true) iSave = 1; else iSave = 0;
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`StockTog` = %d, ", iSave);strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Stock` = %d, ", HQInfo[factionid][fHQStock]); strcat(iiQuery, iFormat);
		
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", HQInfo[factionid][fHQX]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", HQInfo[factionid][fHQY]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", HQInfo[factionid][fHQZ]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`A` = '%f', ", HQInfo[factionid][fHQA]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Interior` = %d, ", HQInfo[factionid][fHQInt]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VirtualWorld` = %d, ", HQInfo[factionid][fHQVW]); strcat(iiQuery, iFormat);
		
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`LeaderX` = '%f', ", HQInfo[factionid][flSpawnX]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`LeaderY` = '%f', ", HQInfo[factionid][flSpawnY]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`LeaderZ` = '%f', ", HQInfo[factionid][flSpawnZ]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`LeaderA` = '%f', ", HQInfo[factionid][flSpawnA]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`LeaderInterior` = %d, ", HQInfo[factionid][flSpawnInt]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`LeaderVirtualWorld` = %d, ", HQInfo[factionid][flSpawnVW]); strcat(iiQuery, iFormat);
		
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SpawnX` = '%f', ", HQInfo[factionid][fSpawnX]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SpawnY` = '%f', ", HQInfo[factionid][fSpawnY]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SpawnZ` = '%f', ", HQInfo[factionid][fSpawnZ]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SpawnA` = '%f', ", HQInfo[factionid][fSpawnA]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SpawnInterior` = %d, ", HQInfo[factionid][fSpawnInt]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SpawnVirtualWorld` = %d, ", HQInfo[factionid][fSpawnVW]); strcat(iiQuery, iFormat);
		
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RoofX` = '%f', ", HQInfo[factionid][fHQRoofX]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RoofY` = '%f', ", HQInfo[factionid][fHQRoofY]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RoofZ` = '%f', ", HQInfo[factionid][fHQRoofZ]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RoofA` = '%f', ", HQInfo[factionid][fHQRoofA]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RoofInterior` = %d, ", HQInfo[factionid][fHQRoofInt]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`RoofVirtualWorld` = %d ", HQInfo[factionid][fHQRoofVW]); strcat(iiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "WHERE `ID` = %d LIMIT 1", factionid); strcat(iiQuery, iFormat);
		mysql_tquery(MySQLPipeline, iiQuery);
	}
	if(WareHouseInfo[factionid][whActive] != false)
	{
		if(WareHouseInfo[factionid][whOpen] == true) iSave = 1; else iSave = 0;
		strcat(iiiQuery, "UPDATE `WHInfo` SET ");
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", WareHouseInfo[factionid][whX]); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", WareHouseInfo[factionid][whY]); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", WareHouseInfo[factionid][whZ]); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Interior` = %d, ", WareHouseInfo[factionid][whInterior]); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VirtualWorld` = %d, ", WareHouseInfo[factionid][whVirtualWorld]); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Open` = %d, ", iSave); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Materials` = %d, ", WareHouseInfo[factionid][whMaterials]); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Lead` = %d, ", WareHouseInfo[factionid][whLead]); strcat(iiiQuery, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Metal` = %d WHERE `ID` = %d LIMIT 1", WareHouseInfo[factionid][whMetal], factionid); strcat(iiiQuery, iFormat);
		mysql_tquery(MySQLPipeline, iiiQuery);
	}
	return 1;
}

stock GetPlayerFactionType(playerid)
{
	new iFactionID = PlayerInfo[playerid][playerteam];
	if(iFactionID == CIV) return FAC_TYPE_INVALID;
	if(FactionInfo[iFactionID][fActive] == false) return FAC_TYPE_INVALID;
	else return FactionInfo[iFactionID][fType];
}

stock bool:IsPlayerInThisFactionType(playerid, facType)
{
	if(GetPlayerFactionType(playerid) != facType) return false;
	else return true;
}

stock GetFactionTypeFromID(factionid)
{
	if(factionid == CIV) return FAC_TYPE_INVALID;
	return FactionInfo[factionid][fType];
}

stock SetPlayerTeamEx(playerid, teamid)
{
	if(teamid != CIV && PlayerInfo[playerid][ranklvl] != 0 && FactionInfo[teamid][fTogColour] == false)
		if(FactionInfo[teamid][fTogColour] == false) return SetPlayerColor(playerid,COLOR_PLAYER_WHITE);
	switch(GetPlayerFactionType(playerid))
	{
		case FAC_TYPE_ARMY, FAC_TYPE_GOV:
		{
			SetPlayerColor(playerid, FactionInfo[teamid][fColour]);
			return 1;
		}
		case FAC_TYPE_MAFIA, FAC_TYPE_GANG, FAC_TYPE_SDC:
		{
		    if(PlayerInfo[playerid][ranklvl] == 0) SetPlayerColor(playerid, COLOR_PLAYER_DARKRED);
		    else SetPlayerColor(playerid, FactionInfo[teamid][fColour]);
			return 1;
		}
		case FAC_TYPE_POLICE:
		{
		    if(PlayerInfo[playerid][ranklvl] == 0) SetPlayerColor(playerid, COLOR_PLAYER_DARKBLUE);
		    else SetPlayerColor(playerid, FactionInfo[teamid][fColour]);
			return 1;
		}
		case FAC_TYPE_INVALID:
		{
		 	PlayerInfo[playerid][playerteam] = CIV;
		 	PlayerInfo[playerid][fpay] = 0;
		    PlayerInfo[playerid][ranklvl] = -1;
		    myStrcpy(PlayerInfo[playerid][rankname], "CIV");
			SetPlayerColor(playerid, COLOR_PLAYER_WHITE); return 1;
		}
		default: return SetPlayerColor(playerid,COLOR_PLAYER_WHITE); // FBI
	}
	return 1;
}

stock GiveFPoints(playerid, amount)
{
	new factionid = PlayerInfo[playerid][playerteam];
	if(factionid == CIV) return 0;
	FactionInfo[factionid][fPoints] += amount;
	return 1;
}

stock Invite(giveplayerid, factionid, invited_by[])
{
	format(iStr,sizeof(iStr), "# [%s] %s has been invited to the faction by %s!",  GetPlayerFactionName(giveplayerid), RPName(giveplayerid), invited_by);
	SendClientMessageToTeam(factionid, iStr, COLOR_PLAYER_VLIGHTBLUE);
	format(iStr, sizeof(iStr),"10[INVITE] %s has been invited to %s.", PlayerName(giveplayerid), FactionInfo[factionid][fName]);
	iEcho(iStr);
	PlayerInfo[giveplayerid][fpay] = 0;
	PlayerTemp[giveplayerid][spawnrdy] = 0;
	PlayerInfo[giveplayerid][playerteam] = factionid;
	SetPlayerTeamEx(giveplayerid, factionid);
	PlayerInfo[giveplayerid][ranklvl] = 2; // LOWEST !!!!!!
	myStrcpy(PlayerInfo[giveplayerid][rankname], FactionInfo[factionid][fStartrank]);
	PlayerInfo[giveplayerid][fpay] = FactionInfo[factionid][fStartpayment];
	SetPVarString(giveplayerid, "InvitedBy", "NoBodY");
	return 1;
}

stock Uninvite(giveplayerid, kicker[])
{
    new stringa[MAX_STRING];
 	format(stringa, sizeof(stringa), "# [%s] %s has been kicked from the faction by %s!",  GetPlayerFactionName(giveplayerid), RPName(giveplayerid), kicker);
	SendClientMessageToTeam(PlayerInfo[giveplayerid][playerteam], stringa, COLOR_PLAYER_VLIGHTBLUE);
	format(stringa, sizeof(stringa),"you have been kicked from %s!", GetPlayerFactionName(giveplayerid));
	ShowInfoBox(giveplayerid, "Faction kick!", stringa);
	format(stringa, sizeof(stringa),"10[UNINVITE] %s has been kicked from %s by %s!", PlayerName(giveplayerid), GetPlayerFactionName(giveplayerid), kicker);
	iEcho(stringa);
	PlayerTemp[giveplayerid][spawnrdy] = 0;
	PlayerInfo[giveplayerid][playerteam] = CIV;
	SetPlayerTeamEx(giveplayerid, PlayerInfo[giveplayerid][playerteam]);
	return 1;
}

stock IsPlayerFED(playerid)
{
	new isFED = 0;
	switch(GetPlayerFactionType(playerid))
	{
	    case FAC_TYPE_POLICE, FAC_TYPE_GOV, FAC_TYPE_ARMY, FAC_TYPE_FBI: isFED = 1;
	    default: isFED = 0;
	}
	return isFED;
}

stock IsPlayerENF(playerid)
{
	new isFED = 0;
	switch(GetPlayerFactionType(playerid))
	{
	    case FAC_TYPE_POLICE, FAC_TYPE_ARMY, FAC_TYPE_FBI: isFED = 1;
	    default: isFED = 0;
	}
	return isFED;
}

stock GetFactionTurfColour(factionid)
{
	if(factionid == -1 || FactionInfo[factionid][fActive] != true) return COLOR_GANG_NOBODY;
	new dCOLOR;
	dCOLOR = FactionInfo[factionid][fGangZoneColour];
	return dCOLOR;
}

stock IsAtOwnHQ(playerid)
{
	FactionLoop(f)
	{
		if(FactionInfo[f][fActive] != true) continue;
		if(HQInfo[f][hqActive] != true) continue;
		if(IsPlayerInSphere(playerid, HQInfo[f][fHQX], HQInfo[f][fHQY], HQInfo[f][fHQZ], 5))
		{
			if(PlayerInfo[playerid][playerteam] == f) return 1;
		}
	}
	return 0;
}

stock GetOnlineCops()
{
	new count = 0;
	PlayerLoop(q)
	{
		if(!PlayerTemp[q][loggedIn]) continue;
	    switch(GetPlayerFactionType(q))
	    {
	        case FAC_TYPE_POLICE, FAC_TYPE_FBI, FAC_TYPE_ARMY: count++;
	        default: continue;
	    }
	}
	return count;
}

stock GetOnlineMembers(f)
{
	new iCount;
	PlayerLoop(p)
	{
		if(!PlayerTemp[p][loggedIn]) continue;
		if(PlayerInfo[p][playerteam] == f) iCount++;
	}
	return iCount;
}

stock GetTotalMembers(f)
{
	if(FactionInfo[f][fActive] != true) return 0;
	new iQuery[128];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `FactionID` FROM `PlayerInfo` WHERE `FactionID` = %d", f);
	new Cache:result = mysql_query(MySQLPipeline, iQuery);
	new rows = cache_num_rows();
	cache_delete(result);
	return rows;
}

stock GetPlayerFactionName(playerid)
{
	new fNameEx[MAX_FACTION_NAME];
	if(PlayerInfo[playerid][playerteam] == CIV) myStrcpy(fNameEx, "Civilian");
	else if(PlayerInfo[playerid][playerteam] > MAX_FACTIONS || PlayerInfo[playerid][playerteam] < 0) myStrcpy(fNameEx, "Civilian");
	else
	{
		myStrcpy(fNameEx, FactionInfo[PlayerInfo[playerid][playerteam]][fName]);
	}
	return fNameEx;
}

stock IsPlayerOutWarehouse(playerid) // get player warehouse!
{
	FactionLoop(f)
	{
	    if(FactionInfo[f][fActive] != true) continue;
		if(WareHouseInfo[f][whActive] != true) continue;
		if(GetPlayerVirtualWorld(playerid) != WareHouseInfo[f][whVirtualWorld] || GetPlayerInterior(playerid) != WareHouseInfo[f][whInterior]) continue;
	    if(IsPlayerInRangeOfPoint(playerid, 2, WareHouseInfo[f][whX], WareHouseInfo[f][whY], WareHouseInfo[f][whZ])) return f;
	}
	return -1;
}

/***********************************************************************************************************************
	House Functions
***********************************************************************************************************************/
stock LoadHouses()
{
	mysql_tquery(MySQLPipeline, "SELECT * FROM `HouseInfo`", "OnLoadHouses", "d", 1);
	mysql_tquery(MySQLPipeline, "SELECT * FROM `FurnitureInfo`", "OnLoadFurniture", "d", 1);
	return 1;
}

stock GetUnusedFurnitureSlot(houseid)
{
	if(HouseInfo[houseid][hActive] != true) return -1;
	FurnitureLoop(h)
	{
		if(FurnitureInfo[houseid][h][furActive] != true) return h;
	}
	return -1;
}

stock GetUnusedHouse()
{
	HouseLoop(h)
	{
	    if(HouseInfo[h][hActive] != true) return h;
	}
	return -1;
}

stock GetNumberOfHouseDupekeys(houseid)
{
	if(HouseInfo[houseid][hActive] != true) return 1;
	new Cache:result = mysql_query(MySQLPipeline, "SELECT `ID` FROM `HDuplicatedKey` WHERE `HouseID` = %d", houseid);
	new rows = cache_num_rows();
	cache_delete(result);
	return rows;
}

stock CreateNewFurniture(h_ID, ModelID, Float:X, Float:Y, Float:Z, Float:rrX, Float:rrY, Float:rrZ)
{
	new furnitureslot = GetUnusedFurnitureSlot(h_ID);
	if(furnitureslot == -1) return printf("House slots expired! %d (%d)!", h_ID, furnitureslot);
	new iName[85];
	for(new furSearch = 0; furSearch < sizeof(FurnitureObjects); furSearch++)
	{
		if(FurnitureObjects[furSearch][furID] == ModelID)
		{
			myStrcpy(iName, FurnitureObjects[furSearch][furName]);
			break;
		}
	}
	new iQuery[650];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `FurnitureInfo` (`House`, `Slot`, `Model`, `X`, `Y`, `Z`, `rX`, `rY`, `rZ`, `Name`) VALUES (%d, %d, %d, '%f', '%f', '%f', '%f', '%f', '%f', '%e')", h_ID, furnitureslot, ModelID, X, Y, Z, rrX, rrY, rrZ, iName);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadFurniture(h_ID, false, furnitureslot);
	return 1;
}

stock CreateHouse(houseOwner[], Float:houseX, Float:houseY, Float:houseZ, Interior, VirtualWorld)
{
	new houseid = GetUnusedHouse();
	new iQuery[250];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `HouseInfo` (`ID`, `Owner`, `X`, `Y`, `Z`, `Interior`,  `VirtualWorld`) VALUES (%d, '%e', '%f', '%f', '%f', %d, %d)", houseid, houseOwner, houseX, houseY, houseZ, Interior, VirtualWorld);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadHouse(houseid, false);
	return 1;
}

stock DeleteHouse(houseid)
{
	if(HouseInfo[houseid][hActive] != true) return 0;
	new iQuery[182];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `HouseInfo` WHERE `ID` = %d", houseid);
	mysql_tquery(MySQLPipeline, iQuery);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `HDuplicatedKey` WHERE `ID` = %d", houseid);
	mysql_tquery(MySQLPipeline, iQuery);
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `FurnitureInfo` WHERE `House` = %d", houseid);
	mysql_tquery(MySQLPipeline, iQuery);
	DestroyDynamic3DTextLabel(HouseInfo[houseid][hLabel]);
	myStrcpy(HouseInfo[houseid][hOwner], "NoBodY");
	HouseInfo[houseid][hRentable] = false;
	HouseInfo[houseid][hRentprice] = 0;
	HouseInfo[houseid][hLevel] = 0;
	HouseInfo[houseid][hClosed] = false;
	HouseInfo[houseid][hSellprice] = 0;
	HouseInfo[houseid][hBuyable] = false;
	HouseInfo[houseid][hCash] = 0;
	HouseInfo[houseid][hTill] = 0;
	HouseInfo[houseid][hSGuns] = 0;
	HouseInfo[houseid][hSDrugs] = 0;
	HouseInfo[houseid][hInteriorPack] = 0;
	HouseInfo[houseid][hX] = 0.0;
	HouseInfo[houseid][hY] = 0.0;
	HouseInfo[houseid][hZ] = 0.0;
	HouseInfo[houseid][hInterior] = 0;
	HouseInfo[houseid][hAlarm] = 0;
	HouseInfo[houseid][hArmour] = 0;
	HouseInfo[houseid][hWardrobe] = 0;
	HouseInfo[houseid][hVirtualWorld] = 0;
	HouseInfo[houseid][hGarageX] = 0.0;
	HouseInfo[houseid][hGarageY] = 0.0;
	HouseInfo[houseid][hGarageZ] = 0.0;
	HouseInfo[houseid][hGarageA] = 0.0;
	HouseInfo[houseid][hGarageInt] = 0;
	HouseInfo[houseid][hGarageVW] = 0;
	HouseInfo[houseid][hGarageInteriorPack] = 0;
	HouseInfo[houseid][hGarageOpen] = false;
	for(new c = 0; c < 13; c++)
	{
		HouseInfo[houseid][hWeapon][c] = 0;
		HouseInfo[houseid][hAmmo][c] = 0;
	}
	for(new c = 0; c < 5; c++)
	{
		HouseInfo[houseid][hSkins][c] = -1;
	}
	HouseInfo[houseid][hLocker] = false;
	DestroyDynamicArea(HouseInfo[houseid][hArea]);
	HouseInfo[houseid][hActive] = false;
	DestroyDynamicObject(HouseInfo[houseid][hInteriorObject]);
	FurnitureLoop(f)
	{
		if(FurnitureInfo[houseid][f][furActive] != true) continue;
		DestroyDynamicObject(FurnitureInfo[houseid][f][furObject]);
		myStrcpy(FurnitureInfo[houseid][f][furName], "Please rename!");
		FurnitureInfo[houseid][f][furModel] = 0;
		FurnitureInfo[houseid][f][furX] = 0.0;
		FurnitureInfo[houseid][f][furY] = 0.0;
		FurnitureInfo[houseid][f][furZ] = 0.0;
		FurnitureInfo[houseid][f][furrX] = 0.0;
		FurnitureInfo[houseid][f][furrY] = 0.0;
		FurnitureInfo[houseid][f][furrZ] = 0.0;
		FurnitureInfo[houseid][f][furActive] = false;
	}
	return 1;
}

stock ReloadHouse(houseid, bool:tosave = true)
{
	if(tosave == true) SaveHouse(houseid);
	SetTimerEx("OnReloadHouse", 500, 0, "i", houseid);
	return 1;
}

stock ReloadFurniture(houseid, bool:tosave = true, slotid = -1)
{
	if(tosave == true) SaveHouse(houseid);
	SetTimerEx("OnReloadFurniture", 500, 0, "ii", houseid, slotid);
	return 1;
}

stock UpdateHouse(houseid)
{
	new zone[60], tmps[1250];
	GetZone(HouseInfo[houseid][hX], HouseInfo[houseid][hY], HouseInfo[houseid][hZ], zone);
	new iLabel[128], iCommands[128];
	format(iLabel, sizeof(iLabel), "{07aa0b}[ {ffffff}%d, %s {07aa0b}]\n", houseid, zone); strcat(tmps, iLabel);
	format(iLabel, sizeof(iLabel), "{07aa0b}Owner: {ffffff}%s\n", NoUnderscore(HouseInfo[houseid][hOwner])); strcat(tmps, iLabel);
	format(iCommands, sizeof(iCommands), "{07aa0b}Commands: {ffffff}");
	new iSize = strlen(iCommands);
	if(HouseInfo[houseid][hRentable] == true)
	{
		format(iLabel, sizeof(iLabel), "{07aa0b}Rent: {ffffff}$%s\n", number_format(HouseInfo[houseid][hRentprice])); strcat(tmps, iLabel);
		strcat(iCommands, "/house rentroom | /house unrent");
	}
	if(HouseInfo[houseid][hBuyable] == true)
	{
		format(iLabel, sizeof(iLabel), "{07aa0b}For Sale: {ffffff}$%s\n", number_format(HouseInfo[houseid][hSellprice])); strcat(tmps, iLabel);
		strcat(iCommands, " | /house buy\n");
	}
	if(strlen(iCommands) > iSize) strcat(tmps, iCommands);
 	DestroyDynamic3DTextLabel(HouseInfo[houseid][hLabel]);
	HouseInfo[houseid][hLabel] = CreateDynamic3DTextLabel(tmps, COLOR_GREEN, HouseInfo[houseid][hX], HouseInfo[houseid][hY], HouseInfo[houseid][hZ]+0.3, 7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HouseInfo[houseid][hVirtualWorld], HouseInfo[houseid][hInterior], -1, 100.0);
	DestroyDynamic3DTextLabel(HouseInfo[houseid][hGarageLabel]);
	format(tmps, sizeof(tmps), "[ Garage #%d ]\n{FFFFFF}/enter", houseid);
	HouseInfo[houseid][hGarageLabel] = CreateDynamic3DTextLabel(tmps, COLOR_GREY, HouseInfo[houseid][hGarageX], HouseInfo[houseid][hGarageY], HouseInfo[houseid][hGarageZ]+0.3, 5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HouseInfo[houseid][hGarageVW], HouseInfo[houseid][hGarageInt], -1, 100.0);
	new hInt = HouseInfo[houseid][hInteriorPack];
	DestroyDynamicObject(HouseInfo[houseid][hInteriorObject]);
	HouseInfo[houseid][hInteriorObject] = CreateDynamicObject(IntInfo[hInt][intModel], IntInfo[hInt][baseX], IntInfo[hInt][baseY], IntInfo[hInt][baseZ], IntInfo[hInt][baserX], IntInfo[hInt][baserY], IntInfo[hInt][baserZ], houseid+1, houseid+1);
	DestroyDynamicArea(HouseInfo[houseid][wardrobeArea]);
	DestroyDynamicPickup(HouseInfo[houseid][wardrobePickup]);
	if(HouseInfo[houseid][hWardrobe] != 0)
	{
		HouseInfo[houseid][wardrobeArea] = CreateDynamicSphere(IntInfo[hInt][wardrobeX], IntInfo[hInt][wardrobeY], IntInfo[hInt][wardrobeZ], 2.5, houseid+1, houseid+1);
		HouseInfo[houseid][wardrobePickup] = CreateDynamicPickup(1275, 1, IntInfo[hInt][wardrobeX], IntInfo[hInt][wardrobeY], IntInfo[hInt][wardrobeZ]+0.3, houseid+1, houseid+1);
	}
	LOOP:hiss(0, IntInfo[HouseInfo[houseid][hInteriorPack]][intMaterials])
	{
		new iFormat[35];
		format(iFormat, sizeof(iFormat), "TextureSlot-%d", hiss);
		if(dini_Isset(HouseTextureDirectory(houseid), iFormat))
		{
			new iColour = -1;
			new iTexture = dini_Int(HouseTextureDirectory(houseid), iFormat);
			format(iFormat, sizeof(iFormat), "ColourSlot-%d", hiss);
			if(dini_Isset(HouseTextureDirectory(houseid), iFormat))
			{
				new iColourEx = dini_Int(HouseTextureDirectory(houseid), iFormat);
				iColour = RGBAToARGB( FurnitureMaterial[iColourEx][materialColour] );
			}
			if(iColour != -1) SetDynamicObjectMaterial(HouseInfo[houseid][hInteriorObject], hiss, FurnitureMaterial[iTexture][modelID], FurnitureMaterial[iTexture][txdName], FurnitureMaterial[iTexture][textureName], iColour);
			else SetDynamicObjectMaterial(HouseInfo[houseid][hInteriorObject], hiss, FurnitureMaterial[iTexture][modelID], FurnitureMaterial[iTexture][txdName], FurnitureMaterial[iTexture][textureName]);
		}
	}
	return 1;
}

stock SaveHouse(houseid)
{
	if(HouseInfo[houseid][hActive] != true)
	{
	    printf("[ERROR] Failed to save house: %d - Not VALID", houseid);
	    return 0;
	}
	new iQuery[2500], iFormat[300], saveSimplifier;
	strcat(iQuery, "UPDATE `HouseInfo` SET ");
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Owner` = '%e', ", HouseInfo[houseid][hOwner]);strcat(iQuery, iFormat);
	if(HouseInfo[houseid][hBuyable] == true) saveSimplifier = 1;else saveSimplifier = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Buyable` = %d, ", saveSimplifier);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Sellprice` = %d, ", HouseInfo[houseid][hSellprice]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Level` = %d, ", HouseInfo[houseid][hLevel]);strcat(iQuery, iFormat);
	if(HouseInfo[houseid][hClosed] == true) saveSimplifier = 1; else saveSimplifier = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Closed` = %d, ", saveSimplifier);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Rentprice` = %d, ", HouseInfo[houseid][hRentprice]);strcat(iQuery, iFormat);
	if(HouseInfo[houseid][hRentable] == true) saveSimplifier = 1; else saveSimplifier = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Rentable` = %d, ", saveSimplifier); strcat(iQuery, iFormat);
	if(HouseInfo[houseid][hLocker] == true) saveSimplifier = 1; else saveSimplifier = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Houselocker` = %d, ", saveSimplifier); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Cash` = %d, ", HouseInfo[houseid][hCash]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Alarm` = %d, ", HouseInfo[houseid][hAlarm]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Wardrobe` = %d, ", HouseInfo[houseid][hWardrobe]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Armour` = %d, ", HouseInfo[houseid][hArmour]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Till` = %d, ", HouseInfo[houseid][hTill]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SGuns` = %d, ", HouseInfo[houseid][hSGuns]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`SDrugs` = %d, ", HouseInfo[houseid][hSDrugs]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`InteriorPack` = %d, ", HouseInfo[houseid][hInteriorPack]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", HouseInfo[houseid][hX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", HouseInfo[houseid][hY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", HouseInfo[houseid][hZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GarageX` = '%f', ", HouseInfo[houseid][hGarageX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GarageY` = '%f', ", HouseInfo[houseid][hGarageY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GarageZ` = '%f', ", HouseInfo[houseid][hGarageZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GarageA` = '%f', ", HouseInfo[houseid][hGarageA]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GarageInterior` = %d, ", HouseInfo[houseid][hGarageInt]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GarageVirtualWorld` = %d, ", HouseInfo[houseid][hGarageVW]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GInteriorPack` = %d, ", HouseInfo[houseid][hGarageInteriorPack]); strcat(iQuery, iFormat);
	if(HouseInfo[houseid][hGarageOpen] == true) saveSimplifier = 1; else saveSimplifier = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`GarageOpen` = %d, ", saveSimplifier); strcat(iQuery, iFormat);
	for(new c = 0; c < 5; c++)
	{
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Skin-Slot-%d` = %d, ", c, HouseInfo[houseid][hSkins][c]); strcat(iQuery, iFormat);
	}
	new iString[50], tmp[6];
 	for(new c = 0; c < 13; c++)
	{
 		format(tmp,sizeof(tmp),"%d,", HouseInfo[houseid][hWeapon][c]);
   		strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Weapons` = '%e', ", iString); strcat(iQuery, iFormat);
 	for(new c = 0; c < 13; c++)
	{
 		format(tmp,sizeof(tmp),"%d,", HouseInfo[houseid][hAmmo][c]);
   		strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Ammo` = '%e', ", iString); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VirtualWorld` = %d, ", HouseInfo[houseid][hVirtualWorld]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Interior` = %d WHERE `ID` = %d", HouseInfo[houseid][hInterior], houseid); strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
	
	FurnitureLoop(f) // not sure about this!!!!! i'll try and find a better way to do this but atm this is best I could do :(
	{
		if(FurnitureInfo[houseid][f][furActive] != true) continue;
		new iQueryEx[650];
		strcat(iQueryEx, "UPDATE `FurnitureInfo` SET ");
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Name` = '%e', ", FurnitureInfo[houseid][f][furName]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Model` = %d, ", FurnitureInfo[houseid][f][furModel]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MaterialSlot1` = %d, ", FurnitureInfo[houseid][f][furMaterial][0]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MaterialSlot2` = %d, ", FurnitureInfo[houseid][f][furMaterial][1]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MaterialSlot3` = %d, ", FurnitureInfo[houseid][f][furMaterial][2]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MaterialSlot4` = %d, ", FurnitureInfo[houseid][f][furMaterial][3]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`MaterialSlot5` = %d, ", FurnitureInfo[houseid][f][furMaterial][4]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ColourMaterial1` = %d, ", FurnitureInfo[houseid][f][furMaterialColour][0]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ColourMaterial2` = %d, ", FurnitureInfo[houseid][f][furMaterialColour][1]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ColourMaterial3` = %d, ", FurnitureInfo[houseid][f][furMaterialColour][2]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ColourMaterial4` = %d, ", FurnitureInfo[houseid][f][furMaterialColour][3]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ColourMaterial5` = %d, ", FurnitureInfo[houseid][f][furMaterialColour][4]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", FurnitureInfo[houseid][f][furX]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", FurnitureInfo[houseid][f][furY]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", FurnitureInfo[houseid][f][furZ]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rX` = '%f', ", FurnitureInfo[houseid][f][furrX]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rY` = '%f', ", FurnitureInfo[houseid][f][furrY]); strcat(iQueryEx, iFormat);
		mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`rZ` = '%f' WHERE `House` = %d AND `Slot` = %d LIMIT 1", FurnitureInfo[houseid][f][furrZ], houseid, f); strcat(iQueryEx, iFormat);
		mysql_tquery(MySQLPipeline, iQueryEx);
	}
	return 1;
}

stock GetPlayerHouses(playerid)
{
	new count = 0;
	HouseLoop(h)
	{
	    if(HouseInfo[h][hActive] != true) continue;
	    if(!strcmp(HouseInfo[h][hOwner], PlayerName(playerid), false)) count++;
	}
	return count;
}

stock HouseSpawn(playerid, house)
{
	PlayerTemp[playerid][tmphouse] = house;
	new intpack = HouseInfo[house][hInteriorPack];
	SetPlayerPos(playerid, IntInfo[intpack][intX], IntInfo[intpack][intY], IntInfo[intpack][intZ]);
	SetPlayerInterior(playerid, house+1); SetPlayerVirtualWorld(playerid, house+1); SetPlayerFacingAngle(playerid, IntInfo[intpack][intA]);
	SetCameraBehindPlayer(playerid);
	SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
	return 1;
}

stock IsPlayerOutHouse(playerid, extra = 0)
{
	new temp = -1, iSize;
	if(extra) iSize = 5;
	else iSize = 2;
	HouseLoop(h)
	{
	    if(HouseInfo[h][hActive] != true) continue;
		if(GetPlayerInterior(playerid) == HouseInfo[h][hInterior] && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVirtualWorld])
		{
			if(IsPlayerInRangeOfPoint(playerid, iSize, HouseInfo[h][hX], HouseInfo[h][hY], HouseInfo[h][hZ]))
				return h;
		}
	}
	return temp;
}

stock IsPlayerOutGarage(playerid)
{
	new temp = -1;
	HouseLoop(h)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[h][hGarageX], HouseInfo[h][hGarageY], HouseInfo[h][hGarageZ]) && GetPlayerInterior(playerid) == HouseInfo[h][hGarageInt] && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hGarageVW]) return h;
	}
	return temp;
}

/***********************************************************************************************************************
	Vehicle Functions
***********************************************************************************************************************/
stock IsVehicleOccupied(carid)
{
	for(new p; p < MAX_PLAYERS; p++)
	{
		if(IsPlayerConnected(p) && IsPlayerInAnyVehicle(p) && GetPlayerVehicleID(p) == carid) return 1;
	}
	return 0;
}

stock ModelFromName(vehname[])
{
	for(new i = 0; i < 211; i++)
	{
		if ( strfind(VehicleName[i], vehname, true) != -1 ) return i + 400;
	}
	return -1;
}

stock GetVehicleName(carid)
{
	new vn[50];
	format(vn,sizeof(vn),"%s",VehicleName[GetVehicleModel(carid)-400]);
	return vn;
}

stock GetVehicleNameFromModel(modelid)
{
	new vn[50];
	format(vn,sizeof(vn),"%s",VehicleName[modelid-400]);
	return vn;
}

stock GetPlayerNearestVehicle(playerid)
{
    new closest = -1;
    if(IsPlayerInAnyVehicle(playerid)) return GetPlayerVehicleID(playerid);
    CarLoop(i)
    {
        if(GetDistanceFromPlayerToVehicle(playerid, i) < GetDistanceFromPlayerToVehicle(playerid, closest) && closest != -1 && GetVehicleVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
        {
            closest = i;
        }
        if(closest == -1) closest = i;
    }
    return closest;
}

stock GetDistanceFromPlayerToVehicle(playerid, vehicleid2)
{
    new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
    new Float:tmpdis;
    GetPlayerPos(playerid,x1,y1,z1);
    GetVehiclePos(vehicleid2,x2,y2,z2);
    tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
    return floatround(tmpdis);
}

stock SaveVehicle(vehicleid)
{
	if(VehicleInfo[vehicleid][vActive] != true) return 0;
	new iQuery[800], iFormat[175];
	strcat(iQuery, "UPDATE `VehicleInfo` SET ");

	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Owner` = '%e', ", VehicleInfo[vehicleid][vOwner]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Model` = %d, ", VehicleInfo[vehicleid][vModel]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Dupekey` = '%e', ", VehicleInfo[vehicleid][vDupekey]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", VehicleInfo[vehicleid][vX]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", VehicleInfo[vehicleid][vY]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", VehicleInfo[vehicleid][vZ]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`A` = '%f', ", VehicleInfo[vehicleid][vA]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VirtualWorld` = %d, ", VehicleInfo[vehicleid][vVirtualWorld]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Colour1` = %d, ", VehicleInfo[vehicleid][vColour1]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Colour2` = %d, ", VehicleInfo[vehicleid][vColour2]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Paintjob` = %d, ", VehicleInfo[vehicleid][vPaintJob]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`FactionID` = %d, ", VehicleInfo[vehicleid][vFaction]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Reserved` = %d, ", VehicleInfo[vehicleid][vReserved]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Job` = '%e', ", VehicleInfo[vehicleid][vJob]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Business` = %d, ", VehicleInfo[vehicleid][vBusiness]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Sellprice` = %d, ", VehicleInfo[vehicleid][vSellPrice]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Fuel` = %d, ", VehicleInfo[vehicleid][vFuel]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VehicleGuns` = %d, ", VehicleInfo[vehicleid][vehicleGuns]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VehicleBullets` = %d, ", VehicleInfo[vehicleid][vehicleBullets]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`HasGunCrates` = %d, ", VehicleInfo[vehicleid][HasGunCrates]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`HasBulletCrates` = %d, ", VehicleInfo[vehicleid][HasBulletCrates]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Stuffs` = %d, ", VehicleInfo[vehicleid][vStuffs]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Guns` = %d, ", VehicleInfo[vehicleid][vGuns]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Alchool` = %d, ", VehicleInfo[vehicleid][vAlchool]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Cars` = %d, ", VehicleInfo[vehicleid][vCars]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Money` = %d, ", VehicleInfo[vehicleid][vMoney]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Oil` = %d, ", VehicleInfo[vehicleid][vOil]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Drugs` = %d, ", VehicleInfo[vehicleid][vDrugs]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Impounded` = %d, ", VehicleInfo[vehicleid][vImpounded]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ImpoundFee` = %d, ", VehicleInfo[vehicleid][vImpoundFee]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`ImpoundReason` = '%e', ", VehicleInfo[vehicleid][vImpoundReason]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Mileage` = '%f', ", VehicleInfo[vehicleid][vMileage]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Alarm` = %d, ", VehicleInfo[vehicleid][vAlarm]);strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Plate` = '%e', ", VehicleInfo[vehicleid][vPlate]);strcat(iQuery, iFormat);
	new iSave;
	if(VehicleInfo[vehicleid][vRegistered] == true) iSave = 1; else iSave = 0;
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Registered` = %d, ", iSave);
	strcat(iQuery, iFormat);
	new iString[35];
    new tmp[5];
 	for(new c = 0; c < CAR_COMPONENTS; c++)
	{
 		format(tmp,sizeof(tmp),"%d,", VehicleInfo[vehicleid][vComponents][c]);
   		strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Components` =  '%e', ", iString);
	strcat(iQuery, iFormat);
	
	for(new c = 0; c < 13; c++)
	{
 		format(tmp,sizeof(tmp),"%d,", VehicleInfo[vehicleid][vWeapon][c]);
   		strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Weapons` =  '%e', ", iString);
	strcat(iQuery, iFormat);
	
 	for(new c = 0; c < 13; c++)
	{
 		format(tmp,sizeof(tmp),"%d,", VehicleInfo[vehicleid][vAmmo][c]);
   		strcat(iString,tmp);
	}
	strdel(iString, strlen(iString)-1, strlen(iString));
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Ammo` =  '%e' WHERE `ID` = %d", iString, vehicleid);
	strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock LoadVehicles()
{
	mysql_tquery(MySQLPipeline, "SELECT * FROM `VehicleInfo`", "OnLoadVehicles", "d", 1);
}

stock ReloadVehicle(vehicleid, bool:tosave = true)
{
	if(tosave == true) SaveVehicle(vehicleid);
	SetTimerEx("OnReloadVehicle", 500, 0, "i", vehicleid);
	return 1;
}

stock CreateNewVehicle(vehOwner[], vehModel, Float:vehX, Float:vehY, Float:vehZ, Float:vehA, vVW = 0)
{
	new vehicleid = GetUnusedVehicle();
	if(vehicleid == INVALID_VEHICLE_ID) return printf("[ERROR] - Maximum vehicles reached. %d/%d", vehicleid, MAX_VEHICLES), INVALID_VEHICLE_ID;
	new iQuery[450];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `VehicleInfo` (`ID`, `Owner`, `Model`, `X`, `Y`, `Z`, `A`, `VirtualWorld`) VALUES (%d, '%e', %d, %f, %f, %f, %f, %d)", vehicleid, vehOwner, vehModel, vehX, vehY, vehZ, vehA, vVW);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadVehicle(vehicleid, false);
	return vehicleid;
}

stock DeleteVehicle(vehicleid)
{
	new iQuery[182];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `VehicleInfo` WHERE `ID` = %d", vehicleid);
	mysql_tquery(MySQLPipeline, iQuery);
	
	if(VehicleInfo[vehicleid][vRID] != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(VehicleInfo[vehicleid][vRID]);
		VehicleInfo[vehicleid][vRID] = INVALID_VEHICLE_ID;
		VehicleInfo[vehicleid][vID] = INVALID_VEHICLE_ID;
	}

	myStrcpy(VehicleInfo[vehicleid][vOwner], "NoBodY");
	myStrcpy(VehicleInfo[vehicleid][vDupekey], "NoBodY");
	myStrcpy(VehicleInfo[vehicleid][vJob], "None");
	
	for(new c = 0; c < 13; c++)
	{
	    VehicleInfo[vehicleid][vWeapon] = 0;
	    VehicleInfo[vehicleid][vAmmo] = 0;
	}
	for(new c = 0; c < CAR_COMPONENTS; c++)
	{
	    VehicleInfo[vehicleid][vComponents] = 0;
	}	
    VehicleInfo[vehicleid][vModel] = 0;
    VehicleInfo[vehicleid][vX] = 0.0;
    VehicleInfo[vehicleid][vY] = 0.0;
    VehicleInfo[vehicleid][vZ] = 0.0;
    VehicleInfo[vehicleid][vA] = 0.0;
    VehicleInfo[vehicleid][vVirtualWorld] = 0;
    VehicleInfo[vehicleid][vColour1] = 0;
    VehicleInfo[vehicleid][vColour2] = 0;
    VehicleInfo[vehicleid][vPaintJob] = -1;
	VehicleInfo[vehicleid][vFaction] = 255;
	VehicleInfo[vehicleid][vReserved] = 0;
	VehicleInfo[vehicleid][vBusiness] = -1;
	VehicleInfo[vehicleid][vSellPrice] = 0;
	VehicleInfo[vehicleid][vLocked] = false;
	VehicleInfo[vehicleid][vLockedBy] = -1;
	VehicleInfo[vehicleid][vFuel] = 100;
	VehicleInfo[vehicleid][vehicleGuns] = 0;
	VehicleInfo[vehicleid][vehicleBullets] = 0;
	VehicleInfo[vehicleid][HasGunCrates] = 0;
	VehicleInfo[vehicleid][HasBulletCrates] = 0;
	VehicleInfo[vehicleid][vStuffs] = 0;
	VehicleInfo[vehicleid][vGuns] = 0;
	VehicleInfo[vehicleid][vAlchool] = 0;
	VehicleInfo[vehicleid][vCars] = 0;
	VehicleInfo[vehicleid][vMoney] = 0;
	VehicleInfo[vehicleid][vOil] = 0;
	VehicleInfo[vehicleid][vDrugs] = 0;
	VehicleInfo[vehicleid][vTrailer] = 0;
	VehicleInfo[vehicleid][vImpounded] = 0;
	VehicleInfo[vehicleid][vMileage] = 0.0;
	VehicleInfo[vehicleid][vAlarm] = 0;
	VehicleInfo[vehicleid][vImpoundFee] = 0;
	VehicleInfo[vehicleid][vRegistered] = false;
	myStrcpy(VehicleInfo[vehicleid][vImpoundReason], "None");
	myStrcpy(VehicleInfo[vehicleid][vPlate], "NOTREG");
	VehicleInfo[vehicleid][vID] = INVALID_VEHICLE_ID;
	VehicleInfo[vehicleid][vActive] = false;
//	VehicleInfo[vehicleid][vSpawned] = false;
	return 1;
}

stock GetNextCreatedVehicleID()
{
	CarLoop(v)
	{
	    if(!IsValidVehicle(v)) return v;
	}
	return INVALID_VEHICLE_ID;
}

stock GetUnusedVehicle()
{
	VehicleLoop(c)
	{
	    if(VehicleInfo[c][vActive] != true) return c;
	}
	return INVALID_VEHICLE_ID;
}

stock bool:IsVehicleBoat(carid)
{
	switch(GetVehicleModel(carid))
	{
	    case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return true;
	    default: return false;
	}
	return false;
}

stock bool:DoesVehicleHaveLock(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 448, 461, 462, 463, 468, 471, 481, 509, 510, 521, 522, 523, 581, 586, 424, 457, 430, 431, 539, 568, 571, 572: return false;
		default: return true;
	}
	return false;
}

stock bool:DoesVehicleHaveEngine(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 481, 509, 510: return false;
		default: return true;
	}
	return false;
}

stock bool:IsVehiclePlane(carid)
{
	switch(GetVehicleModel(carid))
	{
	    case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return true;
	    default: return false;
	}
	return false;
}

stock bool:CheckIfVehicleUsesFuel(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 417, 425, 430, 435, 441, 446, 447, 449, 450, 452, 453, 454, 457, 460, 464, 465, 469, 472, 473, 476, 481, 484, 487, 488, 493, 497, 501, 509, 510, 511, 512, 513, 519, 520, 537, 538, 548, 553, 563, 564, 571, 577, 584, 591, 592, 593, 594, 595, 606, 607, 608, 610, 611: return false;
		default: return true;
	}
	return false;
}

stock GetVehiclePeople(carid)
{
	new szCount = 0;
	PlayerLoop(i)
	{
	    if(!IsPlayerConnected(i)) continue;
	    if( GetPlayerVehicleID( i ) == carid ) szCount++;
	}
	return szCount;
}

stock IsVehicleValid(carid)
{
	new blocked[] = { 548, 425, 417, 487, 488, 497, 563, 447, 469, 520 };
	for(new i; i < sizeof(blocked); i++)
	{
		if(GetVehicleModel(carid) == blocked[i]) return 0;
	}
	return 1;
}

stock UnModCar(carid)
{
	new vehicleid = FindVehicleID(carid);
    new iString[ 50 ], tmp2[ 10 ];
    for(new c = 0; c < CAR_COMPONENTS; c++)
	{
	    myStrcpy(tmp2, "0,");
	    strcat(iString,tmp2);
	}
	strdel(iString,strlen(iString)-1, strlen(iString));
	VehicleInfo[vehicleid][vPaintJob] = -1;
	new iQuery[150];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "UPDATE `VehicleInfo` SET `Components` = '%e', `PaintJob` = -1 WHERE `ID` = %d", iString, vehicleid);
	mysql_tquery(MySQLPipeline, iQuery);
	for(new i = 0; i < CAR_COMPONENTS; i++)
	{
	    new tmpqq = GetVehicleComponentInSlot(carid,i);
	    if(tmpqq != -1) RemoveVehicleComponent(carid, tmpqq);
	}
	ChangeVehiclePaintjob(carid, VehicleInfo[vehicleid][vPaintJob]);
}

stock IsValidNOSVehicle(carid)
{
    #define MAX_INVALID_NOS_VEHICLES 29
    new InvalidNosVehicles[MAX_INVALID_NOS_VEHICLES] =
    {
		581,523,462,521,463,522,461,448,468,586,
		509,481,510,472,473,493,595,484,430,453,
		452,446,454,590,569,537,538,570,449
	};
    for(new i = 0; i < MAX_INVALID_NOS_VEHICLES; i++)
	{
		if(GetVehicleModel(carid) == InvalidNosVehicles[i]) return 0;
	}
	return 1;
}

stock CanTrailerBeRespawned(carid)
{
	new Float:tPos[3];
	GetVehiclePos(carid, tPos[0], tPos[1], tPos[2]);
	CarLoop(i)
	{
	    if(IsVehicleOccupied(i)) continue;
		if(VehicleToPoint(i, tPos[0], tPos[1], tPos[2], 25.0)) return 0;
	}
	return 1;
}

stock VehicleToPoint(carid, Float:x, Float:y, Float:z, Float:radi)
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetVehiclePos(carid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x);
	tempposy = (oldposy -y);
	tempposz = (oldposz -z);
	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) return 1;
	return 0;
}

stock SetVehicleEngineOn(carid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(carid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
}

stock SetVehicleEngineOff(carid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
	SetVehicleParamsEx(carid,VEHICLE_PARAMS_OFF,lights,alarm,doors,bonnet,boot,objective);
}

stock GetEngineStatus(carid)
{
	new engine,lights,alarm,doors,bonnet,boot,objective;
	GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
	return engine;
}

stock LockVehicle(playerid, carid)
{
	PlayerLoop(i) SetVehicleParamsForPlayer(carid, i, 0, 1);
	VehicleInfo[FindVehicleID(carid)][vLocked] = true;
	VehicleInfo[FindVehicleID(carid)][vLockedBy] = playerid;
	return 1;
}

stock UnlockVehicle(carid)
{
	PlayerLoop(i) SetVehicleParamsForPlayer(carid, i, 0, 0);
    VehicleInfo[FindVehicleID(carid)][vLocked] = false;
	VehicleInfo[FindVehicleID(carid)][vLockedBy] = -1;
}

stock GetCarID(vehicleid) // this get's the ID of the car from the vehicle ID
{
	if(VehicleInfo[vehicleid][vActive] != true /* || VehicleInfo[vehicleid][vSpawned] != true */) return INVALID_VEHICLE_ID;
	return VehicleInfo[vehicleid][vRID];
}

stock FindVehicleID(carid) // get's the ID of the vehicle from the carid
{
	VehicleLoop(v)
	{
	    if(VehicleInfo[v][vActive] != true) continue;
//	    if(VehicleInfo[v][vSpawned] != true) continue;
		if(carid == VehicleInfo[v][vRID]) return v;
	}
	return INVALID_VEHICLE_ID;
}

stock HasDupeKeys(playerid)
{
	new iC = 0;
	VehicleLoop(i)
	{
	    if(VehicleInfo[i][vActive] != true) continue;
	    if(!strcmp(VehicleInfo[i][vDupekey], PlayerName(playerid), false)) iC = 1;
	}
	return iC;
}

stock GetPlayerCars(playerid)
{
	new count = 0;
	VehicleLoop(i)
	{
	    if(VehicleInfo[i][vActive] != true) continue;
	    if(!strcmp(VehicleInfo[i][vOwner], PlayerName(playerid), false)) count++;
	}
	return count;
}

stock FactionCarCount(teamid)
{
	new count;
	VehicleLoop(v)
	{
	    if(VehicleInfo[v][vActive] != true) continue;
	    if(VehicleInfo[v][vFaction] == teamid) count++;
	}
	return count;
}

stock GetPlayerSpawnedVehicleCount(playerid) // if vehicle is spawned and on sale!
{
	new iCount;
	VehicleLoop(i)
	{
	    if(VehicleInfo[i][vActive] != true) continue;
//	    if(VehicleInfo[i][vSpawned] != true) continue;
		if(VehicleInfo[i][vSellPrice]) continue;
	    if(!strcmp(VehicleInfo[i][vOwner], PlayerName(playerid), false)) iCount++;
	}
	return iCount;
}

stock GetVehiclePrice(modelid)
{
	new iPrice = -1;
	for(new c = 0; c < sizeof(bikes); c++)
	{
		if(modelid == bikes[c][bikemodel]) iPrice = bikes[c][bikeprice];
	}
	if(iPrice != -1) return iPrice;
	
	for(new c = 0; c < sizeof(jobcars); c++)
	{
		if(modelid == jobcars[c][jcmodel]) iPrice = jobcars[c][jcprice];
	}
	if(iPrice != -1) return iPrice;
	
	for(new c = 0; c < sizeof(heavycars); c++)
	{
		if(modelid == heavycars[c][hmodel]) iPrice = heavycars[c][hprice];
	}
	if(iPrice != -1) return iPrice;
	
	for(new c = 0; c < sizeof(noobcars); c++)
	{
		if(modelid == noobcars[c][noobcmodel]) iPrice = noobcars[c][noobcprice];
	}
	if(iPrice != -1) return iPrice;
	
	for(new c = 0; c < sizeof(aircars); c++)
	{
		if(modelid == aircars[c][airmodel]) iPrice = aircars[c][airprice];
	}
	if(iPrice != -1) return iPrice;
	
	for(new c = 0; c < sizeof(watercars); c++)
	{
		if(modelid == watercars[c][boatmodel]) iPrice = watercars[c][boatprice];
	}
	if(iPrice != -1) return iPrice;	
	
	for(new c = 0; c < sizeof(cars_normal); c++)
	{
		if(modelid == cars_normal[c][cccarmodel]) iPrice = cars_normal[c][cccarprice];
	}
	if(iPrice != -1) return iPrice;	
	
	for(new c = 0; c < sizeof(watercars); c++)
	{
		if(modelid == cars_luxus[c][cccarmodel]) iPrice = cars_luxus[c][cccarprice];
	}
	if(iPrice != -1) return iPrice;
	return iPrice;
}
stock IsPlayerDriver(playerid) //By Sacky
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)	return 1;
	return 0;
}

stock IsPlayerPassenger(playerid) //By Sacky
{
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)	return 1;
	return 0;
}

stock VehicleDriverID(carid)
{
	PlayerLoop(i)
	{
     	if ((IsPlayerConnected(i)) && (GetPlayerVehicleID(i) == carid) && (GetPlayerState(i) == PLAYER_STATE_DRIVER))  return i;
	}
 	return -1;
}

/*******************************************************************************************************************************
	[Teleport System]
*******************************************************************************************************************************/
stock GetUnusedTeleport()
{
	TeleportLoop(t)
	{
		if(TeleportInfo[t][tpActive] != true) return t;
	}
	return -1;
}

stock LoadTeleports()
{
	mysql_tquery(MySQLPipeline, "SELECT * FROM `TeleportInfo`", "OnLoadTeleports", "d", 1);
	return 1;
}

stock ReloadTeleport(teleportid, bool:tosave = true)
{
	if(tosave == true) SaveTeleport(teleportid);
	SetTimerEx("OnReloadTeleport", 500, 0, "i", teleportid);
	return 1;
}

stock CreateTeleport(tpNamee[], Float:tpXX, Float:tpYY, Float:tpZZ, Float:tpAA, tpInteriorr, tpVWW, houseid)
{
	new tpid = GetUnusedTeleport();
	if(tpid == -1) return printf("[CreateTeleport]: MAX Teleports created: %d/%d!", tpid, MAX_TELEPORTS);
	new iQuery[650];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "INSERT INTO `TeleportInfo` (`ID`, `Name`, `X`, `Y`, `Z`, `A`, `Interior`, `VirtualWorld`, `HouseID`) VALUES (%d, '%e', '%f', '%f', '%f', '%f', %d, %d, %d)", tpid, tpNamee, tpXX, tpYY, tpZZ, tpAA, tpInteriorr, tpVWW, houseid);
	mysql_tquery(MySQLPipeline, iQuery);
	ReloadTeleport(tpid, false);
	return 1;
}

stock DeleteTeleport(tpid)
{	
	if(TeleportInfo[tpid][tpActive] != true) return 0;
	new iQuery[182];
	mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "DELETE FROM `TeleportInfo` WHERE `ID` = %d LIMIT 1", tpid);
	mysql_tquery(MySQLPipeline, iQuery);
	myStrcpy(TeleportInfo[tpid][tpName], "Not Used!");
	TeleportInfo[tpid][tpX] = 0.0;
	TeleportInfo[tpid][tpY] = 0.0;
	TeleportInfo[tpid][tpZ] = 0.0;
	TeleportInfo[tpid][tpA] = 0.0;
	TeleportInfo[tpid][tpInt] = 0;
	TeleportInfo[tpid][tpVW] = 0;
	TeleportInfo[tpid][tpiX] = 0.0;
	TeleportInfo[tpid][tpiY] = 0.0;
	TeleportInfo[tpid][tpiZ] = 0.0;
	TeleportInfo[tpid][tpiA] = 0.0;
	TeleportInfo[tpid][tpiInt] = 0;
	TeleportInfo[tpid][tpiVW] = 0;
	TeleportInfo[tpid][tpHouseID] = -1;
	TeleportInfo[tpid][tpHouseIID] = -1;
	TeleportInfo[tpid][tpActive] = false;
	DestroyDynamic3DTextLabel(TeleportInfo[tpid][tpLabel]);
	return 1;
}

stock SaveTeleport(tpid)
{
	if(TeleportInfo[tpid][tpActive] != true)
	{
	    printf("[ERROR] Failed to save Teleport: %d - Not VALID", tpid);
	    return 0;
	}
	new iQuery[850], iFormat[175];
	strcat(iQuery, "UPDATE `TeleportInfo` SET ");
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Name` = '%e', ", TeleportInfo[tpid][tpName]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`X` = '%f', ", TeleportInfo[tpid][tpX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Y` = '%f', ", TeleportInfo[tpid][tpY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Z` = '%f', ", TeleportInfo[tpid][tpZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`A` = '%f', ", TeleportInfo[tpid][tpA]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`Interior` = %d, ", TeleportInfo[tpid][tpInt]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`VirtualWorld` = %d, ", TeleportInfo[tpid][tpVW]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`intX` = '%f', ", TeleportInfo[tpid][tpiX]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`intY` = '%f', ", TeleportInfo[tpid][tpiY]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`intZ` = '%f', ", TeleportInfo[tpid][tpiZ]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`intA` = '%f', ", TeleportInfo[tpid][tpiA]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`intInterior` = %d, ", TeleportInfo[tpid][tpiInt]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`intVirtualWorld` = %d, ", TeleportInfo[tpid][tpiVW]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`HouseID` = %d, ", TeleportInfo[tpid][tpHouseID]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "`intHouseID` = %d ", TeleportInfo[tpid][tpHouseIID]); strcat(iQuery, iFormat);
	mysql_format(MySQLPipeline, iFormat, sizeof(iFormat), "WHERE `ID` = %d LIMIT 1", tpid); strcat(iQuery, iFormat);
	mysql_tquery(MySQLPipeline, iQuery);
	return 1;
}

stock HouseTextureDirectory(houseid)
{
	new iDirectory[60];
	format(iDirectory, sizeof(iDirectory), "HouseTextures/HouseID-%d.ini", houseid);
	return iDirectory;
}

stock bool:PlayerOwnVehicle(playerid, vehicleid)
{
	if(!strcmp( VehicleInfo [ vehicleid ] [ vOwner ], PlayerName(playerid), false)) return true;
	return false;
}

stock GetPlayerOfflineFaction(pname[])
{
	new playerid = GetPlayerId(pname);
	if(IsPlayerConnected(playerid)) return PlayerInfo[playerid][playerteam];
	new pteam = CIV;
	LOOP:f(0, MAX_FACTIONS)
	{
		if(FactionInfo[f][fActive] != true) continue;
		new iQuery[258];
		mysql_format(MySQLPipeline, iQuery, sizeof(iQuery), "SELECT `SQLID` FROM `PlayerInfo` WHERE `PlayerName` = '%e' AND `FactionID` = %d LIMIT 1");
		new Cache:result = mysql_query(MySQLPipeline, iQuery);
		if(cache_num_rows() != 0)
		{
			pteam = f;
			cache_delete(result);
			break;
		}

	}
	return pteam;
}
// ==========
stock BuyPropertyForPlayer(playerid)
{
	new str[128];
	new maxP = MAX_PROPERTIES_PER_PLAYER;
	if(PlayerPropertyCount[playerid] == maxP)
	{
	    if(maxP == 1)
	    {
	        SendClientError(playerid, "You already have 1 property, you have to sell your other property before you can buy this one!");
		}
		else
		{
		    format(str, 128, "You already have %d properties, you have to sell one of your other properties before you can buy this one.", PlayerPropertyCount[playerid]);
	        SendClientError(playerid, str);
		}
		return 1;
	}
	new ID = GetProperty(playerid);
	if(ID == -1) return SendClientError(playerid, "You are not close enough to a property!");
	if(PropInfo[ID][PropIsEnabled] == 0) return SendClientError(playerid, "Sorry, this property is currently disabled!");
	if(PropInfo[ID][PropIsBought] == 1)
	{
	    format(str, 128, "** This property is currently owned by %s and cannot be bought!", PlayerName(PropInfo[ID][PropOwner]));
		SendClientInfo(playerid, str);
	    return 1;
	}
	if(PropInfo[ID][PropOwner] == playerid)
	{
		SendClientError(playerid, "** You already own this property!");
	    return 1;
	}
	if(PropInfo[ID][PropPrice] > PlayerTemp[playerid][sm])
	{
		format(str, 128, "** You don't have enough money to buy this property, you need $%s!", number_format(PropInfo[ID][PropPrice]));
	    SendClientError(playerid, str);
	    return 1;
	}
	GivePlayerMoneyEx(playerid, -PropInfo[ID][PropPrice]);
	PlayerEarnings[playerid] += PropInfo[ID][PropEarning];
	PlayerPropertyCount[playerid]++;
	PropInfo[ID][PropOwner] = playerid;
	PropInfo[ID][PropIsBought] = 1;
	format(str, 128, "%s has bought the property \"%s\"!", PlayerName(playerid), PropInfo[ID][PropName]);
	TextDrawSetString(TextDraw__News, str);
	new string[ 164 ]; format( string, sizeof(string), "12[PROPERTY] %s",str); iEcho( string );
	format(str, 128, " You will earn now $%s every %d minutes!", number_format(PlayerEarnings[playerid]), PropertyPayoutFrequency / 60);
	SendClientMessage(playerid, COLOR_WHITE, str);
	return 1;
}

stock SellPropertyForPlayer(playerid)
{
	new str[128];
	new ID = GetProperty(playerid);
	if(ID == -1)
	{
	    SendClientError(playerid, "You are not close enough to a property!");
	    return 1;
	}
	if(PropInfo[ID][PropOwner] != playerid)
	{
	    return SendClientError(playerid, "You don't own this property!");
	}

    GivePlayerMoneyEx(playerid, PropInfo[ID][PropSell]);
    PlayerPropertyCount[playerid]--;
    PlayerEarnings[playerid] -= PropInfo[ID][PropEarning];
	PropInfo[ID][PropOwner] = 255;
	PropInfo[ID][PropIsBought] = 0;
	format(str, 128, "%s has sold the property \"%s\"!", PlayerName(playerid), PropInfo[ID][PropName]);
	TextDrawSetString(TextDraw__News, str);
	new string[ 164 ]; format( string, sizeof(string), "12[PROPERTY] %s",str); iEcho( string );
	return 1;
}

forward PropertyPayout();
public PropertyPayout()
{
	for(new i; i<MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
		    if(PlayerEarnings[i] > 0)
		    {
		        GivePlayerMoneyEx(i, PlayerEarnings[i]);
				new str[128];
				format(str, 128, "** Property: You earned $%s from your properties!", number_format(PlayerEarnings[i]));
				SendClientMessage(i, COLOR_HELPEROOC, str);
			}
		}
	}
}

stock GetPlayerProperties(playerid)
{
    SendClientMessage(playerid, COLOR_HELPEROOC, "=====================================================");
	if(PlayerPropertyCount[playerid] > 0)
	{
	    new str[128],pName[24];
	    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
		for(new ID = 1; ID < MAX_PROPERTIES; ID++)
		{
		    if (PropInfo[ID][PropOwner] == playerid)
		    {
		        if(PropInfo[ID][PropOwner] != 255)
		        {
			    	format(str,128, "** \"%s\" (ID: %d) **  Price: $%d  **  SellValue: $%d  **  Earnings: $%d", PropInfo[ID][PropName], ID, PropInfo[ID][PropPrice], PropInfo[ID][PropSell], PropInfo[ID][PropEarning]);
					SendClientMessage(playerid, COLOR_LIGHTGREY, str);
				}
			}
		}
		format(str, 128, "Total Earnings: $%d", PlayerEarnings[playerid]);
		SendClientMessage(playerid, COLOR_MENU, str);
	}
	else
	{
		SendClientMessage(playerid, COLOR_MENU, "You don't own any property.");
	}
	SendClientMessage(playerid, COLOR_HELPEROOC, "=====================================================");
}

stock LoadProps()
{
	AddProperty("Property",-2175.9600,-2359.0413,31.2479,10000,6000, 300);
	AddProperty("Property",-2186.4624,-2344.9558,30.6250,10000,6000, 300);
	AddProperty("Property",-2182.4736,-2402.5903,30.6250,10000,6000, 300);
	AddProperty("Property",-2152.3621,-2447.4971,30.6250,10000,6000, 300);
	AddProperty("Property",-2138.8125,-2447.6248,30.6328,10000,6000, 300);
	AddProperty("Property",-2113.3672,-2459.6770,30.6250,10000,6000, 300);
	AddProperty("Property",-2130.9778,-2482.4817,30.6250,10000,6000, 300);
	AddProperty("Property",-2211.2610,-2384.9858,31.5247,10000,6000, 300);
	AddProperty("Property",-2177.3335,-2495.1816,30.4688,10000,6000, 300);
}

stock AddProperty(const name[], Float:X, Float:Y, Float:Z, price, sell, earning)
{

	new ID = (PropertyCount+1);
	if(!strlen(name))
	{
	    print("====================================================");
	    printf("Property Error: You forgot to give property #%d a name!", ID);
	    print("        This property will not be created           ");
	    print("====================================================");
	    return 1;
	}
	if(price < 0)
	{
	    print("=============================================================");
	    print("Property Error: You cant give a property a price lower than 0");
	    printf("           Property #%d will not be created                 ", ID);
	    print("=============================================================");
	    return 1;
	}
	if(sell < 0)
	{
	    print("===============================================================");
	    print("Property Error: You cant give players less than $0 when selling");
	    printf("           Property #%d will not be created                   ", ID);
	    print("===============================================================");
	    return 1;
	}
	if(!strlen(name))
	{
	    print("==================================================================");
	    print("Property Error: You can't give a property an earning lower than 0");
	    printf("               Property #%d will not be created                  ", ID);
	    print("==================================================================");
	    return 1;
	}

	if(PayoutTimer == -1)
	{
	    PayoutTimer = SetTimer("PropertyPayout", (PropertyPayoutFrequency*1000), 1);
	    for(new i; i<MAX_PROPERTIES; i++)
	    {
	        PropInfo[i][PropOwner] = -1;
		}
	}
	PropertyCount++;
	ID = PropertyCount;
	PropInfo[ID][PropExists] = 1;
	PropInfo[ID][PropIsEnabled] = 1;
	format(PropInfo[ID][PropName], 60, "%s", name);
	PropInfo[ID][PropX] = X;
	PropInfo[ID][PropY] = Y;
	PropInfo[ID][PropZ] = Z;
	PropInfo[ID][PropPrice] = price;
	PropInfo[ID][PropSell] = sell;
	PropInfo[ID][PropEarning] = earning;
	PropInfo[ID][PropOwner] = 255;
	PropertyPickup[ID] = CreateDynamicPickup(1273, 1, X, Y, Z);
	return ID;
}

stock SetPayoutFrequency(seconds)
{
	KillTimer(PayoutTimer);
	PropertyPayoutFrequency = seconds;
	PayoutTimer = SetTimer("PropertyPayout", (PropertyPayoutFrequency*1000), 1);
}
stock SetMaxPropertiesPerPlayer(amount)
{
	MAX_PROPERTIES_PER_PLAYER = amount;
}

stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x);
	tempposy = (oldposy -y);
	tempposz = (oldposz -z);
	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
	{
		return 1;
	}
	return 0;
}

stock ResetPlayerPropertyInfo(playerid)
{
    for(new ID; ID<MAX_PROPERTIES; ID++)
	{
		if(PropInfo[ID][PropIsBought] == 1 && PropInfo[ID][PropOwner] == playerid)
		{
		    PropInfo[ID][PropIsBought] = 0;
		    PropInfo[ID][PropOwner] = 255;
		}
	}
	PlayerPropertyCount[playerid] = 0;
	PlayerEarnings[playerid] = 0;
	if(IsTextdrawActive[playerid] == 1)
	{
	    TextDrawDestroy(PropertyText1[playerid]);
	    TextDrawDestroy(PropertyText2[playerid]);
	    KillTimer(TextdrawTimer[playerid]);
	}
	IsTextdrawActive[playerid] = 0;
	return 1;
}

stock GetProperty(playerid)
{
	for(new i=1; i<MAX_PROPERTIES; i++)
	{
	    if(PlayerToPoint(MAX_DISTANCE_TO_PROPERTY, playerid, PropInfo[i][PropX], PropInfo[i][PropY], PropInfo[i][PropZ]))
	    {
	        return i;
		}
	}
	return -1;
}

stock LocatePropertyForPlayer(propertyID, playerid)
{
	new ID = propertyID;
	if(PropInfo[ID][PropExists] == 0) return SendClientMessage(playerid, 0xFF0000AA, "This property does not exists!");
	SetPlayerCheckpoint(playerid, PropInfo[ID][PropX], PropInfo[ID][PropY], PropInfo[ID][PropZ], 3);
	SendClientMessage(playerid, 0xFFFF00, "The property is now indicated on the radar!");
	return 1;
}

stock GetPropertyInfo(propertyID, &Float:X, &Float:Y, &Float:Z, &Price, &SellValue, &Earning)
{
	X = PropInfo[propertyID][PropX];
	Y = PropInfo[propertyID][PropY];
	Z = PropInfo[propertyID][PropZ];
	Price = PropInfo[propertyID][PropPrice];
	SellValue = PropInfo[propertyID][PropSell];
	Earning = PropInfo[propertyID][PropEarning];
}

stock GetPropertyName(propertyID)
{
	new PropertyName[64];
	format(PropertyName, 64, "%s", PropInfo[propertyID][PropName]);
	return PropertyName;
}
stock GetPropertyOwner(propertyID)
{
	new PropertyOwner[MAX_PLAYER_NAME];
	if(PropInfo[propertyID][PropIsBought] == 1)
	{
		new oName[MAX_PLAYER_NAME];
		GetPlayerName(PropInfo[propertyID][PropOwner], oName, sizeof(oName));
		format(PropertyOwner, MAX_PLAYER_NAME, "%s", oName);
	}
	else
	{
	    format(PropertyOwner, MAX_PLAYER_NAME, "Noone");
	}
	return PropertyOwner;
}

stock GetPropertyStatus(propertyID)
{
	new PropertyStatus[10];
	if(PropInfo[propertyID][PropIsEnabled] == 1)
	{
		format(PropertyStatus, 10,"Enabled");
	}
	else
	{
	    format(PropertyStatus, 10, "Disabled");
	}
	return PropertyStatus;
}

stock ToggleProperty(propertyID, toggle)
{
	if(toggle == 1)
	{
	    if(PropInfo[propertyID][PropIsEnabled] == 0)
	    {
			PropInfo[propertyID][PropIsEnabled] = 1;
		}
	}
	else if(toggle == 0)
	{
	    if(PropInfo[propertyID][PropIsEnabled] == 1)
	    {
			PropInfo[propertyID][PropIsEnabled] = 0;
		}
	}
}

stock DestroyAllPropertyPickups()
{
	for(new ID=1; ID<MAX_PROPERTIES; ID++)
	{
		DestroyDynamicPickup(PropertyPickup[ID]);
	}
}

stock UsePropertyTextDraw(toggle)
{
	if(toggle < 0 || toggle > 1) return 0;
	UseTextDraw = toggle;
	return 1;
}

stock OnPropertyPickupPickup(playerid, pickupid)
{
 	new ID = -1;
	for(new i; i<MAX_PROPERTIES; i++)
	{
	    if(pickupid == PropertyPickup[i])
	    {
	        ID = i;
			break;
		}
	}
	if(ID != -1)
	{
	    if(UseTextDraw == 1)
	    {
		    if(IsTextdrawActive[playerid] == 1)
			{
			    TextDrawDestroy(PropertyText1[playerid]);
			    TextDrawDestroy(PropertyText2[playerid]);
			    KillTimer(TextdrawTimer[playerid]);
			}
		}
	    new str[128], str2[128], str3[256];
	    if(PropInfo[ID][PropIsBought] == 0)
	    {
	        if(UseTextDraw == 1)
			{
	       		format(str2, 128, "~r~Earning: ~w~$%d / %d seconds.~n~~r~Owner: ~w~Noone", PropInfo[ID][PropEarning], PropertyPayoutFrequency);
			}
			else
			{
			    format(str2, sizeof(str2), "~r~Earning: ~w~$%d ~n~~r~Owner: ~w~Noone", PropInfo[ID][PropEarning]);
			}
		}
		else
		{
		    if(UseTextDraw == 1)
			{
	          	new oName[MAX_PLAYER_NAME];
			    GetPlayerName(PropInfo[ID][PropOwner], oName, MAX_PLAYER_NAME);
			    format(str2, 128, "~r~Earning: ~w~$%d / %d seconds.~n~~r~Owner: ~w~%s", PropInfo[ID][PropEarning], PropertyPayoutFrequency, oName);
			}
			else
			{
	          	new oName[MAX_PLAYER_NAME];
			    GetPlayerName(PropInfo[ID][PropOwner], oName, MAX_PLAYER_NAME);
			    format(str2, 128, "~r~Earning: ~w~$%d ~n~~r~Owner: ~w~%s", PropInfo[ID][PropEarning], oName);
			}
		    
		}
	    format(str, 128, "~w~\"%s\"~n~~r~Price: ~w~$%d ~n~~r~SellValue: ~w~$%d", PropInfo[ID][PropName],PropInfo[ID][PropPrice], PropInfo[ID][PropSell]);
		if(UseTextDraw == 1)
		{
			PropertyText1[playerid] = TextDrawCreate(10,150,str);
			PropertyText2[playerid] = TextDrawCreate(10,185,str2);
	 		TextDrawLetterSize(PropertyText1[playerid] , 0.4, 1.30);
	 		TextDrawLetterSize(PropertyText2[playerid] , 0.4, 1.30);
	 		TextDrawShowForPlayer(playerid,PropertyText1[playerid]);
		 	TextDrawShowForPlayer(playerid,PropertyText2[playerid]);
	 		IsTextdrawActive[playerid] = 1;
	 		TextdrawTimer[playerid] = SetTimerEx("DestroyTextdraw",3000,false,"i",playerid);
		}
		else
		{
		    format(str3, 256, "%s~n~%s", str, str2);
		    GameTextForPlayer(playerid, str3, 10000, 3);
		}
	}
}

forward DestroyTextdraw(playerid);
public DestroyTextdraw(playerid)
{
    if(UseTextDraw == 1)
	{
		TextDrawDestroy(PropertyText1[playerid]);
		TextDrawDestroy(PropertyText2[playerid]);
		IsTextdrawActive[playerid] = 0;
	}
}
// ==== end of property sys

// == make fire sys
stock GetFireID(Float:x, Float:y, Float:z, &Float:dist)
{
	new id = -1;
	dist = 99999.99;
	for(new i; i < MAX_FLAMES; i++)
	{
		if(GetDistanceBetweenPoints(x,y,z,Flame[i][Flame_pos][0],Flame[i][Flame_pos][1],Flame[i][Flame_pos][2]) < dist)
		{
			dist = GetDistanceBetweenPoints(x,y,z,Flame[i][Flame_pos][0],Flame[i][Flame_pos][1],Flame[i][Flame_pos][2]);
			id = i;
		}
	}
	return id;
}

stock CanPlayerBurn(playerid, val = 0)
{
	if(CallRemoteFunction("CanBurn", "d", playerid) >= 0 && !IsPlayerInWater(playerid) && GetPlayerSkin(playerid) != 277 && GetPlayerSkin(playerid) != 278 && GetPlayerSkin(playerid) != 279 && ((!val && !PlayerOnFire[playerid]) || (val && PlayerOnFire[playerid]))) { return 1; }
	return 0;
}

stock GetFlameSlot()
{
	for(new i = 0; i < MAX_FLAMES; i++)
	{
			if(!Flame[i][Flame_Exists]) { return i; }
	}
	return -1;
}

stock IsAtFlame(playerid)
{
	for(new i; i < MAX_FLAMES; i++)
	{

		if(Flame[i][Flame_Exists])
			{
				if(!IsPlayerInAnyVehicle(playerid) && (IsPlayerInRangeOfPoint(playerid, FLAME_ZONE, Flame[i][Flame_pos][0], Flame[i][Flame_pos][1], Flame[i][Flame_pos][2]+Z_DIFFERENCE) ||
				IsPlayerInRangeOfPoint(playerid, FLAME_ZONE, Flame[i][Flame_pos][0], Flame[i][Flame_pos][1], Flame[i][Flame_pos][2]+Z_DIFFERENCE-1)))
				{
					return 1;
				}
			}
	}
	return 0;
}

new AaF_cache[MAX_PLAYERS] = { -1, ... };
new AaF_cacheTime[MAX_PLAYERS];

stock Aiming_at_Flame(playerid)
{
	if(gettime() - AaF_cacheTime[playerid] < 1)
	{
		return AaF_cache[playerid];
	}
	AaF_cacheTime[playerid] = gettime();

	new id = -1;
	new Float:dis = 99999.99;
	new Float:dis2;
	new Float:px, Float:py, Float:pz;
	new Float:x, Float:y, Float:z, Float:a;
	GetXYInFrontOfPlayer(playerid, x, y, z, a, 1);
	z -= Z_DIFFERENCE;

	new Float:ccx,Float:ccy,Float:ccz,Float:cfx,Float:cfy,Float:cfz;
	GetPlayerCameraPos(playerid, ccx, ccy, ccz);
	GetPlayerCameraFrontVector(playerid, cfx, cfy, cfz);

	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && PlayerOnFire[i] && (IsInWaterCar(playerid) || HasExtinguisher(playerid) || GetPlayerWeapon(playerid) == 41 || Peeing(playerid)) && PlayerOnFire[i])
		{
			GetPlayerPos(i, px, py, pz);
			if(!Peeing(playerid))
			{
				dis2 = DistanceCameraTargetToLocation(ccx, ccy, ccz, px, py, pz, cfx, cfy, cfz);
				}
				else
				{
				if(IsPlayerInRangeOfPoint(playerid, ONFOOT_RADIUS1, px, py, pz))
				{
					dis2 = 0.0;
				}
			}
			if(dis2 < dis)
			{
				dis = dis2;
				id = i;
				if(Peeing(playerid))
				{
					return id;
				}
			}
		}
	}
	if(id != -1) { return id-MAX_PLAYERS; }
	for(new i; i < MAX_FLAMES; i++)
	{
		if(Flame[i][Flame_Exists])
		{
			if(IsInWaterCar(playerid) || HasExtinguisher(playerid) || GetPlayerWeapon(playerid) == 41 || Peeing(playerid))
			{
				if(!Peeing(playerid))
				{
						dis2 = DistanceCameraTargetToLocation(ccx, ccy, ccz, Flame[i][Flame_pos][0], Flame[i][Flame_pos][1], Flame[i][Flame_pos][2]+Z_DIFFERENCE, cfx, cfy, cfz);
				}
				else
				{
					dis2 = GetDistanceBetweenPoints(x,y,z,Flame[i][Flame_pos][0],Flame[i][Flame_pos][1],Flame[i][Flame_pos][2]);
				}
				if((IsPlayerInAnyVehicle(playerid) && dis2 < CAR_RADIUS1 && dis2 < dis) || (!IsPlayerInAnyVehicle(playerid) && ((dis2 < ONFOOT_RADIUS1 && dis2 < dis) || (Peeing(playerid) && dis2 < PISSING_WAY && dis2 < dis))))
				{
					dis = dis2;
					id = i;
				}
			}
		}
	}
	if(id != -1)
	{
		if((IsPlayerInAnyVehicle(playerid) && !IsPlayerInRangeOfPoint(playerid, 50, Flame[id][Flame_pos][0], Flame[id][Flame_pos][1], Flame[id][Flame_pos][2])) || (!IsPlayerInAnyVehicle(playerid)  && !IsPlayerInRangeOfPoint(playerid, 5, Flame[id][Flame_pos][0], Flame[id][Flame_pos][1], Flame[id][Flame_pos][2])))
		{
			id = -1;
		}
	}
	AaF_cache[playerid] = id;
	return id;
}

stock Pissing_at_Flame(playerid)
{
	if(Peeing(playerid))
	{
		new string[22];
		//format(string, sizeof(string), "%d", Aiming_at_Flame(playerid));
		//SendClientMessage(playerid, 0xFFFFFFFF, string);
		return strval(string);
	}
	return -1;
}

stock IsInWaterCar(playerid)
{
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 407 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 601) { return 1; }
    return 0;
}

stock HasExtinguisher(playerid)
{
    if(GetPlayerWeapon(playerid) == 42 && !IsPlayerInAnyVehicle(playerid)) { return 1; }
    return 0;
}

stock Peeing(playerid)
{
        return GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_PISSING;
}

stock Pressing(playerid)
{
	new keys, updown, leftright;
	GetPlayerKeys(playerid, keys, updown, leftright);
	return keys;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, &Float:z, &Float:a, Float:distance)
{
	GetPlayerPos(playerid, x, y ,z);
	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehicleZAngle(GetPlayerVehicleID(playerid),a);
	}
	else
	{
		GetPlayerFacingAngle(playerid, a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
	return 0;
}

forward Float:GetDistanceBetweenPoints(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2);
stock Float:GetDistanceBetweenPoints(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2) //By Gabriel "Larcius" Cordes
{
	return floatadd(floatadd(floatsqroot(floatpower(floatsub(x1,x2),2)),floatsqroot(floatpower(floatsub(y1,y2),2))),floatsqroot(floatpower(floatsub(z1,z2),2)));
}

stock IsPlayersVehicleBike(playerid)
{
	new carid = GetPlayerVehicleID(playerid);
	new modell = GetVehicleModel(carid);
	if(modell == 509 || // Bike
	    modell == 481 || // BMX
	    modell == 510 || // Mountain Bike
	    modell == 462 || // Faggio
	    modell == 448 || // Pizzaboy
	    modell == 581 || // BF-400
	    modell == 522 || // NRG-500
	    modell == 461 || // PCJ-600
	    modell == 521 || // FCR-900
	    modell == 523 || // Cop Bike
	    modell == 463 || // Freeway
	    modell == 586 || // Wayfarer
	    modell == 468 || // Sanchez
	    modell == 471) return 1; // Quad
	else return 0;
}