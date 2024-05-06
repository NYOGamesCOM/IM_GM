/*********************************************************************************************************************************************
						- NYOGames [Config.pwn file]
*********************************************************************************************************************************************/
/* =============================================================================
		[Pragmas]		
============================================================================= */
//#pragma dynamic 45000
/* =============================================================================
		[Includes]		
============================================================================= */
#include <a_samp>
#include <dudb>
#include <streamer>
#include <a_http>
#include <zcmd>
#include <dutils>
#include <ircecho>
#include <a_zones>
#include <a_mysql>
#include <float>

/* =============================================================================
		[Global Textdraw declares]
============================================================================= */
new Text:TextDraw__News, Text:TellTD, TellTDActive, Text:IMtxt, Text:PeaceZone, Text:txtAnimHelper, Text:InjuredTD;

/* =============================================================================
		[More includes]
============================================================================= */
#include "mafia02_irc.pwn"
#include "mafia02_functions.pwn"
//#include "./assets/mysql.pwn"
//#include "mafia02_maps.pwn" <-> maps are being loaded through a FS.

/* =============================================================================
		[Misc Functions]
============================================================================= */
native IsValidVehicle(vehicleid);
native WP_Hash(buffer[], len, const str[]);

/* =============================================================================
		[Forwards...]:
============================================================================= */
forward IrcCMD(str[]);
forward WeatherSet();
forward CarFrozen();
forward PayDay();
forward PayCheck();
forward FuelDown();
forward CheckGas();
forward Checker();
forward UpdateZone();
forward TimeConn();
forward RealTimeUpdate();
forward ToKick(playerid);
forward ToBan(playerid, reason[]);
forward TempData();
forward CD(numero);
forward Dropper(playerid);
forward Healing(playerid, Float:playerx, Float:playery, flag);
forward Refuel(playerid, carid, Float:carX);
forward HoldPhone(playerid);
