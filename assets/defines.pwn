/*********************************************************************************************************************************************
						- NYOGames [defines.pwn file]
*********************************************************************************************************************************************/
/* =============================================================================
		[MySQL connection config]
============================================================================= */
new MySQLPipeline; // Main MySQL pipeline handler

/*#define SQL_HOST "localhost" //"144.76.68.79"
#define SQL_USER "skatim"
#define SQL_PASS "W9gMz8Xk"
#define SQL_DATA "zskatim0"*/
#define SQL_HOST "localhost" //"144.76.68.79"
#define SQL_USER "root"
#define SQL_PASS "root"
#define SQL_DATA "aprpdb"

/* =============================================================================
		[ Money Defines - Edit comments next to when edited! ]
============================================================================= */
#define 	MAX_H_SELL						200000000 		// $200,000,000
#define 	MIN_H_SELL						1000000			// $1,000,000
#define 	MAX_B_SELL						1000000000 		// $1,000,000,000
#define 	MIN_B_SELL						50000000		// $50,000,000
#define 	MEDIC_PRICE						500				// $500
#define 	MAX_BUSINESS_COMPS				10000 			// 10,000
#define 	BUSINESS_RENAME_PRICE			150000			// $150,00
#define 	MAX_TRANSFER_AMOUNT				25000000		// $25,000,000
#define 	HOUSE_ALARM_PRICE				10000000		// $10,000,000
#define 	MAX_REFUEL_PRICE				150000			// $15,000 - Mechanic /carrefuel [PlayerID][Price]
#define 	PAYTIME_DEFAULT_PAYCHECK		5000 			// $5,000 - Default paycheck amount, regardless of job.
#define 	PAYTIME_BIZ_TAX					250 			// $250 - business tax * GetPlayerBusinesses(playerid);
#define 	PAYTIME_VEH_TAX					45  			// $45 - vehicle tax * GetPlayerVehicles(playerid);
#define 	PAYTIME_HOUSE_TAX				100   			// $100 - house tax * GetPlayerHouses(playerid);

/* =============================================================================
		[Dialog IDs]
============================================================================= */

enum
{
	DIALOG_REGISTER,
	DIALOG_LOGIN,
	DIALOG_SMS,
	DIALOG_911,
	DIALOG_AD,
	DIALOG_CAD,
	DIALOG_GUNSTORE,
	DIALOG_HELPME,
	DIALOG_DRUGSTORE,
	DIALOG_NO_RESPONSE,
	DIALOG_BIKE_DEALERSHIP,
	DIALOG_CAR_DEALERSHIP,
	DIALOG_LUXUS_DEALERSHIP,
	DIALOG_FOODSTORE,
	DIALOG_GIVEGUN,
	DIALOG_NOOB_DEALERSHIP,
	DIALOG_AIR_DEALERSHIP,
	DIALOG_BOAT_DEALERSHIP,
	DIALOG_LAPTOP,
	DIALOG_247,
	DIALOG_LIST_ACTIVE_BIZES,
	DIALOG_HEAVY_DEALERSHIP,
	DIALOG_JOB_DEALERSHIP,
	DIALOG_CCTV,
	DIALOG_HARDWARE,
	DIALOG_JOB_SELECTION,
	DIALOG_QUIT_JOB,
	DIALOG_H_UPGRADE,
	DIALOG_G_UPGRADE,
	DIALOG_WHEELS,
	DIALOG_WHEELS_BUY,
	DIALOG_GYM,
	DIALOG_BANK_WITHDRAW,
	DIALOG_BANK_DEPOSIT,
	DIALOG_CMD_CMDS,
	DIALOG_V_SPAWN,
	DIALOG_B_PLATE_CHNG,
	DIALOG_MNG_CATE_IN,
	DIALOG_MNG_CATE_OUT,
	DIALOG_H_VIEW_INFO,
	DIALOG_H_SET_RENT,
	DIALOG_H_SETTINGS,
	DIALOG_FURNITURE,
	DIALOG_FURNITURE_CATEGORY,
	DIALOG_FURNITURE_LIST,	
	DIALOG_CATE_SLCT_APPLIANCE,	
	DIALOG_CATE_SLCT_COMFORT,	
	DIALOG_CATE_SLCT_DECO,		
	DIALOG_CATE_SLCT_ENTERTAIN,
	DIALOG_CATE_SLCT_LIGHTING,	
	DIALOG_CATE_SLCT_PLUMBING,		
	DIALOG_CATE_SLCT_STORAGE,	
	DIALOG_CATE_SLCT_SURFACE,	
	DIALOG_CATE_SLCT_MISC,		
	DIALOG_FURNITURE_LIST_OPTIONS,
	DIALOG_FURNITURE_POSITION,
	DIALOG_FURNIUTRE_INFO,	
	DIALOG_FURNITURE_RENAME,			
	DIALOG_FURNITURE_SELL,		
	DIALOG_FURNITURE_BUY,		
	DIALOG_FURNITURE_MATERIAL,	
	DIALOG_MATERIAL_SELECTION,		
	DIALOG_GET_MATERIAL,	
	DIALOG_CHOOSE_GENDER,		
	DIALOG_CHOOSE_ETHNICITY,			
	DIALOG_UPGRADE_H,	
	DIALOG_UPGRADE_H_ALARM,			
	DIALOG_UPGRADE_H_WARDROBE,		
	DIALOG_UPGRADE_H_ARMOUR,	
	DIALOG_MYBUSINESSES,		
	DIALOG_MY_B_DUPELICATES,		
	DIALOG_SHOW_B_OWN_INFO,		
	DIALOG_WARDROBE,		
	DIALOG_WARDROBE_OPTIONS,			
	DIALOG_WARDROBE_INFO,		
	DIALOG_H_BASE_TEXTURES,		
	DIALOG_H_BASE_SELECTED,			
	DIALOG_H_BASE,
	DIALOG_CLOSEST_BUSINESSES,
	DIALOG_TOY_BUY_CATE,
	DIALOG_TOY_SUB_CATE,
	DIALOG_TOY_BUY,
	DIALOG_WIRETRANSFER_NAME,
	DIALOG_WIRETRANSFER_AMOUNT,
	DIALOG_LATEST_SMS_CALLS_ADS,
	DIALOG_WHATS_NEW,
	DIALOG_V_FIND,
	DIALOG_INVENTORY,
	INVE_MY_HOUSES,
	INVE_MY_BUSINESSES,
	INVE_MY_VEHICLES,
	INVE_MY_DRUGS,
	INVE_MY_SEEDS,
	INVE_MY_WEAPONS,
	INVE_MY_ITEMS,
	DIALOG_TRUCKER_SLCT,
	SRV_CREDITS,
}
/* =============================================================================
		[Max Defines]
============================================================================= */
#undef MAX_PLAYERS
#undef MAX_VEHICLES
#define MAX_PLAYERS 					50
#define MAX_VEHICLES 					50000
#define MAX_CREATED_VEHICLES 			2000 
#define MAX_TPS 						60
#define MAX_CTPS 						30
#define MAX_BUSINESS					500
#define MAX_BIZ_NAME					46
#define MAX_ATMS						250
#define MAX_HOUSES						1500
#define MAX_BARRIERS 					1+20
#define MAX_SPIKES 						1+20
#define MAX_SEEDS 						1+200
#define MAX_CPZ 						20

#define MAX_TELEPORTS					400
#define MAX_GATES						750

#define MAX_FACTIONS 					15
#define MAX_FACTION_NAME				40
#define MAX_FACTION_RANK				25
#define MAX_FMOTD						50

#define MAX_FURNITURE_SLOTS				75

#define MAX_GANGZONES					42

#define MAX_PLAYER_TOYS					150
#define MAX_PLAYER_TOY_EQUIPTED			10 // 1 is for misc server shit...
#define MAX_PLAYER_TOY_NAME				75

#define INVALID_CONVERSATION 			0 // deletepvar

#define MAX_DRUG_TYPES					8

#define MAX_JOBS						20

// FIRE
#define MAX_FLAMES 100						// maxmimal flames
#define BurnOthers							// Should other players burn, too, if they are touching a burning player?
#define FireMessageColor 0x00FF55FF			// color used for the extinguish-message
#define KEYPAD_BLASTDOOR 1 // The ID for the keypad we will use

#define FLAME_ZONE 					1.2     // radius in which you start burning if you're too close to a flame
#define ONFOOT_RADIUS1				1.5		// radius in which you can extinguish the flames by foot
#define PISSING_WAY					2.0		// radius in which you can extinguish the flames by peeing
#define CAR_RADIUS1					8.0		// radius in which you can extinguish the flames by firetruck/SWAT Van
#define Z_DIFFERENCE				2.5		// height which is important for the accurancy of extinguishing. please do not change
#define EXTINGUISH_TIME_VEHICLE		1		// time you have to spray at the fire with a firetruck (seconds)
#define EXTINGUISH_TIME_ONFOOT		4		// time you have to spray at the fire onfoot (seconds)
#define EXTINGUISH_TIME_PEEING		10		// time you have to pee at the fire (seconds)
#define EXTINGUISH_TIME_PLAYER		3		// time it takes to extinguish a player (seconds)
#define FIRE_OBJECT_SLOT			1		// the slot used with SetPlayerAttachedObject and RemovePlayerAttachedObject

enum FlameInfo
{
        Flame_id,
        Flame_Exists,
        Float:Flame_pos[3],
        Smoke[5],
}
new Flame[MAX_FLAMES][FlameInfo];
new ExtTimer[MAX_PLAYERS];
new PlayerOnFire[MAX_PLAYERS];
new PlayerOnFireTimer[MAX_PLAYERS];
new PlayerOnFireTimer2[MAX_PLAYERS];
new Float:PlayerOnFireHP[MAX_PLAYERS];
forward AddFire(Float:x, Float:y, Float:z);
forward KillFire(id);
forward AddSmoke(Float:x, Float:y, Float:z);
forward KillSmoke(id);
forward DestroyTheSmokeFromFlame(id);
forward OnFireUpdate();
forward FireTimer(playerid, id);
forward SetPlayerBurn(playerid);
forward BurningTimer(playerid);
forward StopPlayerBurning(playerid);

#if !defined SPECIAL_ACTION_PISSING
	#define SPECIAL_ACTION_PISSING 68
#endif

/* =============================================================================
		[Business type Defines]
============================================================================= */
enum
{
	BUSINESS_TYPE_BANK, // done
	BUSINESS_TYPE_247, 
	BUSINESS_TYPE_CASINO,
	BUSINESS_TYPE_GAS,
	BUSINESS_TYPE_HARDWARE,
	BUSINESS_TYPE_CLUB,
	BUSINESS_TYPE_PUB,
	BUSINESS_TYPE_STRIPCLUB,
	BUSINESS_TYPE_GUNSTORE,
	BUSINESS_TYPE_PIZZA,
	BUSINESS_TYPE_BURGER,
	BUSINESS_TYPE_CHICKEN,
	BUSINESS_TYPE_CAFE,
	BUSINESS_TYPE_CLOTHES,
	BUSINESS_TYPE_RESTAURANT,
	BUSINESS_TYPE_PAYNSPRAY,
	BUSINESS_TYPE_DRUGFACTORY,
	BUSINESS_TYPE_GOV,
	BUSINESS_TYPE_REFINARY,
	BUSINESS_TYPE_AIRPORT,
	BUSINESS_TYPE_TAXI,
	BUSINESS_TYPE_RENT,
	BUSINESS_TYPE_DRIVER,
	BUSINESS_TYPE_STADIUM,
	BUSINESS_TYPE_PAINTBALL,
	BUSINESS_TYPE_ADTOWER,
	BUSINESS_TYPE_PHONE,
	BUSINESS_TYPE_EXPORT,
	BUSINESS_TYPE_DRUGSTORE,
	BUSINESS_TYPE_BIKE_DEALER,
	BUSINESS_TYPE_HEAVY_DEALER,
	BUSINESS_TYPE_CAR_DEALER,
	BUSINESS_TYPE_LUXUS_DEALER,
	BUSINESS_TYPE_NOOB_DEALER,
	BUSINESS_TYPE_AIR_DEALER,
	BUSINESS_TYPE_BOAT_DEALER,
	BUSINESS_TYPE_JOB_DEALER,
	BUSINESS_TYPE_WHEEL,
	BUSINESS_TYPE_TOYSTORE,
	BUSINESS_TYPE_APPARTMENT,
	BUSINESS_TYPE_HOTEL,
	BUSINESS_TYPE_VREGISTER,
}

/* =============================================================================
		[Faction Defines]
============================================================================= */
#define FAC_TYPE_INVALID			-1
#define MAX_FACTION_TYPES			6
#define CIV							255
enum
{
	FAC_TYPE_ARMY,
	FAC_TYPE_POLICE,
	FAC_TYPE_GANG,
	FAC_TYPE_MAFIA,
	FAC_TYPE_GOV,
	FAC_TYPE_SDC,
	FAC_TYPE_FBI,
}

/* =============================================================================
		[Vehicle Fuel System - Config]
============================================================================= */
#define 	GasMax 			100
#define 	RunOutTime 		30000
#define 	RefuelWait 		5000
#define 	FUEL 			1

/* =============================================================================
		[Server Colours]
============================================================================= */
#define COLOR_GROUP 0x216B98FF
#define COLOR_HELPEROOC 0xADFF2FFF
#define COLOR_GARAGE 0x0066CCFF
#define COLOR_GM_REG 0xFFFFFFAA		
#define COLOR_GM_UNREG 0xFF9999AA	
#define COLOR_GM_ADMIN 0xFFCC66AA	
#define COLOR_IRC 0x66CCFFAA		
#define COLOR_ADMINCHAT 0xFF9933AA	
#define COLOR_SYSTEM_PM 0x66CC00AA	
#define COLOR_SYSTEM_GM 0xFF9966AA	
#define COLOR_SYSTEM_PW 0xFFFF33AA
#define COLOR_SYSTEM_GW 0xCCCCCCAA	
#define COLOR_MONEY_INC 0x00CC66AA	
#define COLOR_MONEY_DEC 0xFF6600AA	
#define COLOR_CMD 0xFFFFFFAA		
#define COLOR_ADMIN_CMD 0xCC6666AA
#define COLOR_ADMIN_PM 0x6699CCAA
#define COLOR_ADMIN_PW 0x99CCFFAA
#define COLOR_ADMIN_GM 0xFF6633AA	
#define COLOR_STATS 0xCCCCFFAA		
#define COLOR_MESSAGE 0xFFCCFFAA
#define COLOR_RULES 0xDC143CAA     
#define COLOR_ADMIN_TOALL 0x00FFFFAA
#define COLOR_GROUPTALK 0x87CEEBAA  
#define COLOR_ADMIN_REPORT 0xFF69B4AA 
#define COLOR_ADMIN_SPYREPORT 0xB0E0E6AA 
#define COLOR_ADMIN 0xFF8200FF
#define COLOR_CARDIVE 0xEE82EEAA 
#define COLOR_BLACK_PD 0x000000FF
#define COLOR_WHITE_PD 0xFFFFFFFF
#define COLOR_DISARMING 0xEE82EEBB
#define COLOR_WHITE 0xFFFFFF77
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_PLAYER_ORANGE 0xFF9900AA
#define COLOR_IVORY 0xFFFF82FF
#define COLOR_BLUE 0x0000FFFF
#define COLOR_PURPLE 0x800080FF
#define COLOR_RED 0xCC3300FF
#define COLOR_RED22 0xCC3300FF
#define COLOR_LIGHTGREEN 0x00FF7FFF
#define COLOR_VIOLET 0xEE82EEFF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_SILVER 0xC0C0C0FF
#define COLOR_LIGHTBLUE 0x87CEFAFF
#define COLOR_PINK 0xFFB6C1FF
#define COLOR_INDIGO 0x4B00B0FF
#define COLOR_GOLD 0xFFD700FF
#define COLOR_FIREBRICK 0xB22222FF
#define COLOR_GREEN 0x008000FF
#define COLOR_LIGHTYELLOW 0xFAFA02FF
#define COLOR_GREY 0x778899FF
#define COLOR_LIGHTGREY 0xCCCCCCFF
#define COLOR_LIGHTGREYEX 0xA3A0A0FF
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_BRIGHTGREEN 0x7CFC00FF
#define COLOR_DARKBLUE 0x000080AFF
#define COLOR_SYSTEM 0xDB7093FF
#define COLOR_BROWN 0x8B4513FF
#define COLOR_GREENYELLOW 0xADFF2FFF
#define COLOR_THISTLE 0xD8BFD8FF
#define COLOR_TURQUISE 0x48D1CCFF
#define COLOR_MAROON 0x800000FF
#define COLOR_STEELBLUE 0xB0C4DEFF
#define COLOR_ME 0xC2A2DAAA
#define COLOR_ME2 0xC3A3DBAA
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_LIME 0x81F600AA // Custom
#define COLOR_ERROR 0xFFB0B0DD
#define COLOR_PLAYER_LIGHTBLUE 0x9292FFDD
#define COLOR_PLAYER_VLIGHTBLUE 0x66FFFFFF
#define COLOR_PLAYER_BLUE 0xA098F0AA
#define COLOR_PLAYER_FBI 0xFFFFFF77
#define COLOR_PLAYER_FBIHIGH 0xFFFFFF77
#define COLOR_PLAYER_DARKBLUE 0x000096FF
#define COLOR_PLAYER_SPECIALBLUE 0x4169FFFF
#define COLOR_PLAYER_LIGHTRED 0xFFB0B0DD
#define COLOR_PLAYER_RED 0xFF0000DD
#define COLOR_PLAYER_DARKRED 0xA10000FF
#define COLOR_PLAYER_SPECIALRED 0xB22222DD
#define COLOR_PLAYER_LIGHTGREEN 0x92FF92DD
#define COLOR_PLAYER_GREEN 0x00FF00DD
#define COLOR_PLAYER_DARKGREEN 0x009600DD
#define COLOR_PLAYER_SPECIALGREEN 0x00FF00FF
#define COLOR_PLAYER_LIGHTYELLOW 0xFFFF5EDD
#define COLOR_PLAYER_YELLOW 0xFFFF00DD
#define COLOR_PLAYER_DARKYELLOW 0xD3D300FF
#define COLOR_PLAYER_SPECIALYELLOW 0xCFAE00DD
#define COLOR_PLAYER_LIGHTPURPLE 0xFF92FFDD
#define COLOR_PLAYER_PURPLE 0xFF00FFDD
#define COLOR_PLAYER_DARKPURPLE 0x800080FF
#define COLOR_PLAYER_SPECIALPURPLE 0xDA70D6DD
#define COLOR_PLAYER_LIGHTBROWN 0xBA9072DD
#define COLOR_PLAYER_BROWN 0x663300FF
#define COLOR_PLAYER_DARKBROWN 0x6D360EDD
#define COLOR_PLAYER_LIGHTGREY 0xC7C7C7DD
#define COLOR_PLAYER_GREY 0x8B8B8BDD
#define COLOR_PLAYER_DARKGREY 0x656565FF
#define COLOR_PLAYER_WHITE 0xFFFFFF77
#define COLOR_PLAYER_WHITE_INV 0xFFFFFFFF
#define COLOR_PLAYER_BLACK 0x212121FF
#define COLOR_PLAYER_AQUAMARINE 0x7FFFD4DD
#define COLOR_PLAYER_CYAN 0x00FFFFDD
#define COLOR_PLAYER_VIOLET 0xCC0066AA
#define COLOR_PLAYER_SASF 0x556B2FFF
#define COLOR_PLAYER_POLITIC 0xCC9999FF
#define COLOR_PLAYER_MEXICAN1 0xFF8000FF
#define COLOR_PLAYER_BLACK1 0x741827FF
#define COLOR_GANG_NOBODY 0xCFCDCF99

/* =============================================================================
		[Server Sounds]
============================================================================= */
#define SOUND_CEILING_VENT_LAND 1002
#define SOUND_BONNET_DENT 1009
#define SOUND_WHEEL_OF_FORTUNE_CLACKER 1027
#define SOUND_SHUTTER_DOOR_START 1035
#define SOUND_SHUTTER_DOOR_STOP 1036
#define SOUND_PARACHUTE_OPEN 1039
#define SOUND_AMMUNATION_BUY_WEAPON 1052
#define SOUND_AMMUNATION_BUY_WEAPON_DENIED 1053
#define SOUND_SHOP_BUY 1054
#define SOUND_SHOP_BUY_DENIED 1055
#define SOUND_RACE_321 1056
#define SOUND_RACE_GO 1057
#define SOUND_PART_MISSION_COMPLETE 1058
#define SOUND_GOGO_TRACK_START 1062 
#define SOUND_GOGO_TRACK_STOP 1063 
#define SOUND_DUAL_TRACK_START 1068   
#define SOUND_DUAL_TRACK_STOP 1069 
#define SOUND_BEE_TRACK_START 1076  
#define SOUND_BEE_TRACK_STOP 1077  
#define SOUND_ROULETTE_ADD_CASH 1083
#define SOUND_ROULETTE_REMOVE_CASH 1084
#define SOUND_ROULETTE_NO_CASH 1085
#define SOUND_AWARD_TRACK_START 1097  
#define SOUND_AWARD_TRACK_STOP 1098 
#define SOUND_PUNCH_PED 1130
#define SOUND_AMMUNATION_GUN_COLLISION 1131
#define SOUND_CAMERA_SHOT 1132
#define SOUND_BUY_CAR_MOD 1133
#define SOUND_BUY_CAR_RESPRAY 1134
#define SOUND_BASEBALL_BAT_HIT_PED 1135
#define SOUND_STAMP_PED 1136
#define SOUND_CHECKPOINT_AMBER 1137
#define SOUND_CHECKPOINT_GREEN 1138
#define SOUND_CHECKPOINT_RED 1139
#define SOUND_CAR_SMASH_CAR 1140
#define SOUND_CAR_SMASH_GATE 1141
#define SOUND_OTB_TRACK_START 1142
#define SOUND_OTB_TRACK_STOP 1143
#define SOUND_PED_HIT_WATER_SPLASH 1144
#define SOUND_RESTAURANT_TRAY_COLLISION 1145
#define SOUND_SWEETS_HORN 1147
#define SOUND_MAGNET_VEHICLE_COLLISION 1148
#define SOUND_PROPERTY_PURCHASED 1149
#define SOUND_PICKUP_STANDARD 1150
#define SOUND_GARAGE_DOOR_START 1153
#define SOUND_GARAGE_DOOR_STOP 1154
#define SOUND_PED_COLLAPSE 1163
#define SOUND_SHUTTER_DOOR_SLOW_START 1165
#define SOUND_SHUTTER_DOOR_SLOW_STOP 1166
#define SOUND_RESTAURANT_CJ_PUKE 1169
#define SOUND_DRIVING_AWARD_TRACK_START 1183
#define SOUND_DRIVING_AWARD_TRACK_STOP 1184
#define SOUND_BIKE_AWARD_TRACK_START 1185
#define SOUND_BIKE_AWARD_TRACK_STOP 1186
#define SOUND_PILOT_AWARD_TRACK_START 1187 
#define SOUND_PILOT_AWARD_TRACK_STOP 1188


/* =============================================================================
		[Command Handler / Processor]
============================================================================= */
#define ALTCOMMAND:%1->%2; COMMAND:%1(playerid, params[]) return cmd_%2(playerid, params);
#define dcmd(%1,%2,%3) if ((strcmp(%3, "/%1", true, %2+1) == 0)&&(((%3[%2+1]==0)&&(dcmd_%1(playerid,"")))||((%3[%2+1]==32)&&(dcmd_%1(playerid,%3[%2+2]))))) return 1

/* =============================================================================
		[Admjin / Spectate System  - Config]
============================================================================= */
#define UPDATE_COUNT 5
#define POSSIBLE_AIRBREAK_COUNT_CAR 10
#define POSSIBLE_AIRBREAK_COUNT_ONFOOT 10

enum
{
	ADMIN_SPEC_TYPE_NONE,
	ADMIN_SPEC_TYPE_PLAYER,
	ADMIN_SPEC_TYPE_VEHICLE,
}

/* =============================================================================
		[Vehicle Defines]:
============================================================================= */
enum
{
	VEH_RES_NORMAL, // ownable vehicle
	VEH_RES_OCCUPA, // occupation - Jobs
	VEH_RES_NOOBIE, // noobie vehicle...
	VEH_RES_FACT, // faction reserved
	VEH_RES_RENT, // rentable vehicle - /rentcar
	VEH_RES_MONEYVAN, // moneyan - /loadmoney
	VEH_RES_REFINARY, // refinary vehicle - /buyfuel
	VEH_TYPE_WH_TRAILER, // warehouse trailer for runs
	VEH_RES_DRIVER_LIC, // made for driver license students.
}

/* =============================================================================
		[SDC Run Defines]:
============================================================================= */
#define NOCOMPS 255
enum
{
	STUFFS,
	GUNS,
	ALCHOOL,
	CARS,
	MONEY,
	OIL,
	DRUGS,
}

/* =============================================================================
		[GunStore Defines]:
============================================================================= */
enum 
{
	DEAGLE,
	M4,
	MP5,
	SNIPER,
	RIFLE,
	SHOTGUN,
	ARMOUR,
}

/* =============================================================================
		[Drug Defines]:
============================================================================= */
enum
{
	DRUG_COCAINE,
	DRUG_CANNABIS,
	DRUG_ECSTASY,
	DRUG_CRACK,
	DRUG_MORPHINE,
	DRUG_TRYPI,
	DRUG_HEROIN,
	DRUG_SPEED,
}

/* =============================================================================
		[Loop shortcuts]:
============================================================================= */
#define PlayerLoop(%1) for(new %1 = 0, pMax = MAX_PLAYERS; %1 < pMax; %1++) if(IsPlayerConnected(%1) && !IsPlayerNPC(%1))
#define VehicleLoop(%1) for(new %1 = 1, vMaxEx = MAX_VEHICLES; %1 < vMaxEx; %1++)
#define CarLoop(%1) for(new %1 = 1; %1 < MAX_CREATED_VEHICLES; %1++)
#define BusinessLoop(%1) for(new %1 = 0; %1 < MAX_BUSINESS; %1++)
#define ATMLoop(%1) for(new %1 = 0; %1 < MAX_ATMS; %1++)
#define HouseLoop(%1) for(new %1 = 0; %1 < MAX_HOUSES; %1++)
#define FactionLoop(%1) for(new %1 = 0; %1 < MAX_FACTIONS; %1++)
#define FurnitureLoop(%1) for(new %1 = 0; %1 < MAX_FURNITURE_SLOTS; %1++)
#define TeleportLoop(%1) for(new %1 = 0; %1 < MAX_TELEPORTS; %1++)
#define LOOP:%1(%2,%3) for(new %1 = %2, loopEx = %3; %1 < loopEx; %1++)
#define JobLoop(%1) for(new %1 = 0; %1 < MAX_JOBS; %1++)
/* =============================================================================
		[Holding Objects...]:
============================================================================= */
#define SetPlayerHoldingObject(%1,%2,%3,%4,%5,%6,%7,%8,%9) SetPlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1,%2,%3,%4,%5,%6,%7,%8,%9)
#define StopPlayerHoldingObject(%1) RemovePlayerAttachedObject(%1,MAX_PLAYER_ATTACHED_OBJECTS-1)
#define IsPlayerHoldingObject(%1) IsPlayerAttachedObjectSlotUsed(%1,MAX_PLAYER_ATTACHED_OBJECTS-1)

/* =============================================================================
		[Random Defines]:
============================================================================= */
#define 	CITYHALL     			1
#define 	TREADMILL       		2
#define 	TIMER 					0
#define 	TIME 					1
#define 	INVALID_RADIO_FREQ 		666
#define 	CAR_COMPONENTS 			14
#define 	WEAPON_SLOTS			13
#define 	IRC_WRONG_CHANNEL 		"[ERROR]: You cannot use this command here!"
#define 	CANT_USE_CMD 			"You are not allowed to use this command!"
#define 	PLAYER_NOT_FOUND 		"Player not found!"
#define 	File::%1( File__%1(
#define 	Misc::%1( Misc__%1(
#define 	function:%1(%2) forward %1(%2); public %1(%2)
#define 	RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define 	HandMoney(%1) PlayerTemp[%1][sm]
#define 	GetAdminLevel(%1) PlayerInfo[%1][power]
#define 	GetPlayerFaction(%1) PlayerInfo[%1][playerteam]
#define 	TRUCKING_TRAILER		435

/* =============================================================================
		[ Furniture Defines ]:
============================================================================= */
enum
{
	CATEGORY_APPLIANCES,
	CATEGORY_COMFORT,
	CATEGORY_DECORATIONS,
	CATEGORY_ENTERTAINMENT,
	CATEGORY_LIGHTING,
	CATEGORY_PLUMBING,
	CATEGORY_STORAGE,
	CATEGORY_SURFACES,
	CATEGORY_MISCELLANEOUS,
}

enum
{
	// Appliances
	SUB_APPLIANCE_REFRIGERATORS,
	SUB_APPLIANCE_STOVES,
	SUB_APPLIANCE_TRASHCANS,
	SUB_APPLIANCE_SMALL,
	SUB_APPLIANCE_DUMPSTERS,
	// Comfort
	SUB_COMFORT_BEDS,
	SUB_COMFORT_CHAIRS,
	SUB_COMFORT_COUCHES,
	SUB_COMFORT_ARM_CHAIRS,
	SUB_COMFORT_STOOLS,
	// Decorations
	SUB_DECO_CURTAINS,
	SUB_DECO_FLAGS,
	SUB_DECO_RUGS,
	SUB_DECO_STATUES,
	SUB_DECO_TOWELS,
	SUB_DECO_PAINTINGS,
	SUB_DECO_PLANTS,
	SUB_DECO_POSTERS,
	// entertainment
	SUB_ENTERTAIN_SPORTS,
	SUB_ENTERTAIN_TV,
	SUB_ENTERTAIN_GAMING,
	SUB_ENTERTAIN_MEDIA,
	SUB_ENTERTAIN_STEREO,
	SUB_ENTERTAIN_SPEAKERS,
	// Lighting
	SUB_LIGHTING_LAMPS,
	SUB_LIGHTING_WALLMOUNTED,
	SUB_LIGHTING_CEILING,
	SUB_LIGHTING_NEON,
	// plumbing
	SUB_PLUMBING_TOILET,
	SUB_PLUMBING_SINK,
	SUB_PLUMBING_SHOWER,
	SUB_PLUMBING_BATHS,
	// storage
	SUB_STORAGE_SAFES,
	SUB_STORAGE_BOOKSHELVES,
	SUB_STORAGE_DRESSERS,
	SUB_STORAGE_CABINETS,
	SUB_STORAGE_PANTRIES,
	// surfaces
	SUB_SURFACES_DINNING,
	SUB_SURFACES_COFFEE_TABLES,
	SUB_SURFACES_COUNTERS,
	SUB_SURFACES_DISPLAY_CABINETS,
	SUB_SURFACES_DISPLAY_SHELVES,
	SUB_SURFACES_TV_STANDS,
	// misc
	SUB_MISC_CLOTHES,
	SUB_MISC_CONSUMABLES,
	SUB_MISC_DOORS,
	SUB_MISC_MESS,
	SUB_MISC_MISC,
	SUB_MISC_PILLARS,
	SUB_MISC_SECURITY,
	SUB_MISC_OFFICE,
	SUB_MISC_TOYS,
}

enum
{
	MAIN_CATEGORY_SELECT,
	SUB_CATEGORY_SELECT,
}

enum
{
	MATERIAL_CATEGORY_COLOURS,
	MATERIAL_CATEGORY_TEXTURE,
}

/*****************************************************************************************************************
		[Player toy Categories]
*****************************************************************************************************************/
enum
{
	PT_CATEGORY_HATS,
}

enum
{
	PT_SUBCATEGORY_HATS_BASEBALL,
}

/*****************************************************************************************************************
		[Log Defines]
*****************************************************************************************************************/
enum
{
	MONEY_LOG_BOUGHT_BIZ,
	MONEY_LOG_SOLD_BIZ,
	MONEY_LOG_BIZ_WITHDRAW, // put money in to securivan
	MONEY_LOG_BIZ_DEPOSIT, // put money from securivan to bank
	MONEY_LOG_ROBBED_BIZ,
	MONEY_LOG_BOUGHT_HOUSE,
	MONEY_LOG_SOLD_HOUSE,
	MONEY_LOG_BOUGHT_VEHICLE,
	MONEY_LOG_SOLD_VEHICLE,
	MONEY_LOG_VEHICLE_SCRAP,
	MONEY_LOG_PAY,
	MONEY_LOG_WITHDRAW,
	MONEY_LOG_DEPOSIT,
	MONEY_LOG_TRANSFER,
	MONEY_LOG_LOAN,
	MONEY_LOG_RUN,
	MONEY_LOG_FDEPOSIT,
	MONEY_LOG_FWITHDRAW,
	MONEY_LOG_BOUGHT_ITEM,
	MONEY_LOG_GIVECASH,
	MONEY_LOG_TAKECASH,
}

enum 
{
	FACTION_LOG_TIER_2,
	FACTION_LOG_TIER_1,
	FACTION_LOG_TIER_0,
}

/*****************************************************************************************************************
		[ERROR DEFINES]
*****************************************************************************************************************/
enum
{
	ERROR_MAX_REACHED,
}

/*****************************************************************************************************************
		[MySQL THREAD TYPE DEFINES]
*****************************************************************************************************************/
enum
{
	DATA_THREAD_SENDDATA,
	DATA_THREAD_RETRIEVEDATA,
	DATA_THREAD_INSERTDATA,
}

/*****************************************************************************************************************
		[MySQL THREAD ID DEFINES]
*****************************************************************************************************************/
enum
{
	THREAD_CHECK_ATMS,
}
//

#define MAX_PROPERTIES 10
#define MAX_DISTANCE_TO_PROPERTY 1.5

new UseTextDraw = 1;  //If '0', only gametext will appear when picking up a property-pickup, else if '1' a textdraw will appear.

#define COLOR_MENU 0xADFF2FAA //Green/Yellow
#define COLOR_MENUHEADER 0x7CFC00AA
new PayoutTimer = -1;
new PropertyPayoutFrequency = 60;  //Propertyowners will get every 60 seconds money from their properties
new MAX_PROPERTIES_PER_PLAYER = 3;
new PropertyCount;
new PropertyPickup[MAX_PROPERTIES];
new PlayerPropertyCount[MAX_PLAYERS];
new PlayerEarnings[MAX_PLAYERS];
new Text:PropertyText1[MAX_PLAYERS];
new Text:PropertyText2[MAX_PLAYERS];
new IsTextdrawActive[MAX_PLAYERS];
new TextdrawTimer[MAX_PLAYERS];
