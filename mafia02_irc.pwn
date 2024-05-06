#include <irc>

#define BOT_1_NICKNAME "SysBot1"
#define BOT_1_REALNAME "NYOGames IRC Bot" // This is the name that will only be visible in a whois
#define BOT_1_USERNAME "NYOGamesLiveBot" // This will be in front of the hostname (username@hostname)

#define BOT_2_NICKNAME "SysBot2"
#define BOT_3_NICKNAME "SysBot3"

#define BOTPASS "mazgadecalincalduri31337"

#define IRC_SERVER "irc.opera.com"
#define IRC_PORT 6667
#define IRC_CHANNEL "#samp.echo"
#define IRC_IDLE "#samp"
#define IRC_LIVE "#samp.live"

new TEST_MODE = 0;

new
	gBotID[3],
	gGroupID;


forward echo_Init();
public echo_Init()
{
	if(TEST_MODE == 0)
	{
	    SetTimerEx("IRC_ConnectDelay", 1000, 0, "d", 1); // Connect the first bot with a delay of 2 seconds
		SetTimerEx("IRC_ConnectDelay", 6000, 0, "d", 2); // Connect the second bot with a delay of 3 seconds
		SetTimerEx("IRC_ConnectDelay", 11000, 0, "d", 3); // Connect the third bot with a delay of 4 seconds
		}

	gGroupID = IRC_CreateGroup(); // Create a group (the bots will be added to it upon connect)
}

forward echo_Exit();
public echo_Exit()
{
	IRC_Quit(gBotID[0], "NYOGames ->> www.NYOGames.co.uk"); // Disconnect the first bot
	IRC_Quit(gBotID[1], "NYOGames ->> www.NYOGames.co.uk"); // Disconnect the second bot
	IRC_Quit(gBotID[2], "NYOGames ->> www.NYOGames.co.uk"); // Disconnect the third bot
	IRC_DestroyGroup(gGroupID); // Destroy the group
}

/*
	This function is called on a timer in order to delay connections to the IRC
	server and effectively prevent join floods.
*/

forward IRC_ConnectDelay(tempid);
public IRC_ConnectDelay(tempid)
{
	switch (tempid)
	{
		case 1:
		{
			gBotID[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
		}
		case 2:
		{
			gBotID[1] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_2_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
		}
		case 3:
		{
			gBotID[2] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_3_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);
		}
	}
	return 1;
}

/*
	The IRC callbacks are below. Many of these are simply derived from parsed
	raw messages received from the IRC server. They can be used to inform the
	bot of new activity in any of the channels it has joined.
*/

public IRC_OnConnect(botid)
{
	printf("*** IRC_OnConnect: Bot ID %d connected!", botid);
	SetTimerEx("IRC_JoinDelay", 1500, 0, "d", botid);
	IRC_JoinChannel(botid, IRC_CHANNEL);
	IRC_JoinChannel(botid, IRC_IDLE);
	IRC_JoinChannel(botid, IRC_LIVE);
	IRC_AddToGroup(gGroupID, botid); // Add the IRC bot to the group
	new login[60];
	format(login, 60, "nickserv identify %s", BOTPASS);
	IRC_SendRaw(botid, login);
	return 1;
}

forward IRC_JoinDelay(botid);
public IRC_JoinDelay(botid)
{
    IRC_JoinChannel(botid, IRC_CHANNEL);
    IRC_JoinChannel(botid, IRC_IDLE);
    IRC_JoinChannel(botid, IRC_LIVE);
}

/*
	Note that this callback is executed whenever a current connection is closed
	OR whenever a connection attempt fails. Reconnecting too fast can flood the
	IRC server and possibly result in a ban. It is recommended to set up
	connection reattempts on a timer, as demonstrated here.
*/

public IRC_OnDisconnect(botid)
{
	printf("*** IRC_OnDisconnect: Bot ID %d disconnected!", botid);
	if (botid == gBotID[0])
	{
		SetTimerEx("IRC_ConnectDelay", 1000, 0, "d", 1); // Wait 10 seconds for the first bot
	}
	else if (botid == gBotID[1])
	{
		SetTimerEx("IRC_ConnectDelay", 6000, 0, "d", 2); // Wait 15 seconds for the second bot
	}
	else if (botid == gBotID[2])
	{
		SetTimerEx("IRC_ConnectDelay", 11000, 0, "d", 3); // Wait 15 seconds for the third bot
	}
	
	printf("*** IRC_OnDisconnect: Bot ID %d attempting to reconnect...", botid);
	IRC_RemoveFromGroup(gGroupID, botid); // Remove the IRC bot from the group
	return 1;
}

public IRC_OnJoinChannel(botid, channel[])
{
	printf("*** IRC_OnJoinChannel: Bot ID %d joined channel %s!", botid, channel);
	return 1;
}
/*
	My custom functions
*/

stock iEcho(text[], chan[] = IRC_CHANNEL) // PARAM: text || PARAM: delay
{
	if(!TEST_MODE) IRC_GroupSay(gGroupID, chan, text);
	return 1;
}

forward iEchoDelay(text[]);
public iEchoDelay(text[])
{
	IRC_GroupSay(gGroupID, IRC_CHANNEL, text);
}

stock iEchoUse(text[])
{
	new
	    tmp[ 128 ];
	format(tmp, 128, "USAGE: %s", text);
	IRC_GroupSay(gGroupID, IRC_CHANNEL, tmp);
    return 1;
}

stock iNotice(target[], text[])
{
    IRC_GroupNotice(gGroupID, target, text);
    return 1;
}

stock iEchoVIP(text[])
{
    IRC_GroupSay(gGroupID, IRC_CHAN_VIP, text);
}
#define IRC_CHAN_ADMIN "@#echo"
stock iEchoAdmin(text[])
{
    IRC_GroupSay(gGroupID, IRC_CHAN_ADMIN, text);
}
#define IRC_CHAN_HIGH "&#echo"
stock iEchoHigh(text[])
{
    IRC_GroupSay(gGroupID, IRC_CHAN_HIGH, text);
}
