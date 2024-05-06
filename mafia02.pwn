/*********************************************************************************************************************************************
						- NYOGames [main source file]
*********************************************************************************************************************************************/
//
//              ===>>> self note <<<===
//  - need to finish the Property functions ASAP - all prop spawn/attach to player ID 0
//      (create functions-> GetUnusedProp, CreateProp, DeleteProp, LoadProp, ReloadProp, SaveProp
//
//
//==============================================================================
#define SERVER_GM_TEXT "Angel Pine v7-R5"
#define SERVER_GM "Angel Pine Roleplay"
#define	CURRENT_VERSION	"7.0.9-R5"
#define CURRENT_BUILD "1610071116" // format - H:M:D:M:Y
#define CURRENT_DEVELOPER "skaTim"

#define MYSQL_THREAD_HANDLER			"OnDatabaseQuery" 						// function that is called for threads - ADDING SOON

#include "./assets/config.pwn"
//#include "./assets/mysql.pwn" //moved to config.pwn
//#include "mafia02_irc.pwn" //moved to config.pwn
//#include "mafia02_functions.pwn" //moved to config.pwn
#include "./assets/defines.pwn"
#include "./assets/enums.pwn"
#include "./assets/functions.pwn"
#include "./assets/publicfunctions.pwn"
#include "./assets/callbacks.pwn"
#include "./assets/showdialog.pwn"
#include "./assets/OnDialogResponse.pwn"
#include "./assets/cmds.pwn"


main() {}

public OnGameModeInit()
{
	g_OnGameModeInit();
	return 1;
}

public OnGameModeExit()
{
	g_OnGameModeExit();
	return 1;
}
