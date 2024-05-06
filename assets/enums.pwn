/*********************************************************************************************************************************************
						- NYOGames [enums.pwn file]
*********************************************************************************************************************************************/
new treadmillBUSY = -1;
new gCheckPoints[ MAX_CPZ ];
new TurfTakeOver[ MAX_GANGZONES ][ 2 ];
new glob_toban[MAX_PLAYER_NAME] = "NoBodY";
new gTick__GMX = -1;
new gBackupMarker = -1;
new rndCOLOR = 0;
new roadBlock[ MAX_BARRIERS ] = 0;
new roadBlockObj[ MAX_BARRIERS ] = 0;
new roadBlockPlayer[ MAX_BARRIERS ][ 32 ];
new iStr[ 164 ];
new oocenable = 0;
new ircenable = 1;
new RSpawnNo=0;
new paycheck=0;
new iBots[ MAX_PLAYERS ];

new moneylog[MAX_STRING]="Logs/money.log";
new adminlog[MAX_STRING]="Logs/admin.log";
new banlog[MAX_STRING]="Logs/ban.log";
new kicklog[MAX_STRING]="Logs/kick.log";
new wlog[MAX_STRING]="Logs/wish.log";
new globalstats[MAX_STRING]="globalstats.ini";
new compsfile[MAX_STRING]="General/comps.ini";
new warfile[MAX_STRING]="General/war.ini";
new elections[MAX_STRING]="General/elections.ini";
new ajaillog[MAX_STRING]="Logs/ajail.log";
new deathlog[MAX_STRING]="Logs/death.log";

new m_iLastTime[ 2 ];

new allweps[][0] = {
	{WEAPON_GOLFCLUB}, {WEAPON_KNIFE}, {WEAPON_BAT}, {WEAPON_SHOVEL}, {WEAPON_POOLSTICK}, {WEAPON_CHAINSAW},
	{WEAPON_VIBRATOR2}, {WEAPON_FLOWER}, {WEAPON_CANE}, {WEAPON_DEAGLE}, {WEAPON_SILENCED}, {WEAPON_SHOTGUN},
	{WEAPON_MP5}, {WEAPON_AK47}, {WEAPON_M4}, {WEAPON_RIFLE}, {WEAPON_SPRAYCAN}, {WEAPON_BAT},
	{WEAPON_COLLISION}, {WEAPON_DROWN}, {WEAPON_VEHICLE}, {WEAPON_FIREEXTINGUISHER}, {WEAPON_NITESTICK}, {WEAPON_FLAMETHROWER},
	{WEAPON_MINIGUN}, {WEAPON_SNIPER}, {WEAPON_ROCKETLAUNCHER}, {WEAPON_BOMB}, {WEAPON_HEATSEEKER}, {255}, {0}
};

enum deliverEnum {
	Float:deliverX,
	Float:deliverY,
	Float:deliverZ,
	deliverCargo[30]
}

new Float:deliver[][deliverEnum] = {
	{1742.1154,-1770.9634,13.2062, "Pool Table"},
	{1445.0876,-1468.8586,12.9313, "Screwdriver Crates"},
	{1432.7090,-1328.7227,13.1373, "Bikes"},
	{2136.5762,-1928.7278,13.1240, "Sandwich Crates"},
	{2513.7551,-2397.6472,13.1868, "10,000 Crates"},
	{-2098.7412,-2239.4690,30.1886, "20 LED Screens"},
	{1678.6520,1644.3749,10.3838, "Wrapped Chicken"},
	{-1626.2543,1090.3867,6.8221, "Vehicles Clamps"},
	{1255.2644,-1166.3538,23.4002, "2 Crates with guns"}
};

new Float:robbingplaces[][] = {
	{1427.6189,-1092.7307,17.1258},
	{770.1701,-1086.3751,23.6507},
	{967.6279,-2149.9570,12.6573},
	{2695.6536,-1109.9495,69.1160},
	{2873.9922,-2125.0840,3.7291},
	{2252.8726,-2268.6106,13.1083}
};

new Float:FarmPlaces[][] = {
	{-120.8112,74.4605,2.6809, 1.0}, // HARVEST_CP_TYPE_1
	{-208.7445,-85.8797,2.6831, 2.0}, // HARVEST_CP_TYPE_2
	{-201.6251,96.8841,2.6117,2.0}, // HARVEST_CP_TYPE_2
	{-210.8438,163.4165,5.3998, 2.0}, // HARVEST_CP_TYPE_2
	{-107.2996,132.8005,2.6810,2.0}, // HARVEST_CP_TYPE_3
	{-263.9876,-96.6692,2.6699, 2.0}, // HARVEST_CP_TYPE_2
	{-53.2242,-115.1395,2.6828,2.0}, // HARVEST_CP_TYPE_2
	{52.7769,-96.0298,0.1665,1.0}, // HARVEST_CP_TYPE_1
	{-12.7386,-21.3477,2.6821,1.0}, // HARVEST_CP_TYPE_1
	{25.3022,-118.3827,0.1729,1.0}, // HARVEST_CP_TYPE_1
	{71.7066,-35.5936,0.1731,2.0}, // HARVEST_CP_TYPE_2
	{42.0913,43.1515,2.0650,   2.0}, // HARVEST_CP_TYPE_2
	{-10.2126,126.7930,2.6779,  2.0}, // HARVEST_CP_TYPE_2
	{-42.4759,126.8499,2.6739, 2.0}, // HARVEST_CP_TYPE_2
	{-94.8964,70.5161,2.6831,  3.0} // HARVEST_CP_TYPE_3_size_7
};

new Float:PrisonCells[][3] =
{
    {377.9175,182.5063,889.5491}, // Cell ID 0
	{383.4862,182.4703,889.5491}, // Cell ID 1
	{388.8247,182.3085,889.5491}, // Cell ID 2
	{394.2729,160.5242,889.5491}, // Cell ID 3
	{388.5340,160.3431,889.5491}, // Cell ID 4
	{383.2203,160.9012,894.7221}, // Cell ID 5
	{388.3102,160.5569,894.7224}, // Cell ID 6
	{393.4509,160.1735,894.7227}, // Cell ID 7
	{389.1766,181.5983,894.6671}, // Cell ID 8
	{383.0786,182.3985,894.6537}, // Cell ID 9
	{377.1996,182.3003,894.6554} // Cell ID 10
};

enum eSPIKES
{
	sObject,
	Float:sX, Float:sY, Float:sZ,
	Float:rX, Float:rY, Float:rZ,
	exists,
}
new Spikes[ MAX_SPIKES ][ eSPIKES ];

enum eATM
{
	atmObject,
	Text3D:atmLabel,
	Float: atmX,
	Float: atmY,
	Float: atmZ,
	Float: atmrotX,
	Float: atmrotY,
	Float: atmrotZ,
	atmInterior,
	atmVirtualWorld,
	bool:  atmActive,
}
new ATMInfo[MAX_ATMS][eATM];

enum eSEEDS
{
	Text3D: sLabel,
	sPickup,
	sOwner[ MAX_PLAYER_NAME ],
	Float: seedX, Float:seedY, Float:seedZ,
	sActive,
	sGrams,
	sTick,
}
new Seeds[ MAX_SEEDS ][ eSEEDS ];

enum pstats
{
	SQL_ID,
	bank,
	playerlvl,
	rpoints,
	playertime,
	jail,
	jailreason[MAX_STRING],
	jailtime,
	banned,
	banreason[MAX_STRING],
	whobannedme[MAX_STRING],
	whenigotbanned[MAX_STRING],
	Skin,
	ranklvl,
	rentprice,
	driverlic,
	flylic,
	boatlic,
	weaplic,
	jobskill,
	totalpayt,
	kills,
	deaths,
	housenum,
	loan,
	guns,
	sMaterials,
	sdrugs,
	power,
	bail,
 	premium,
	gotphone,
	phonenumber,
	phonebook,
	laptop,
	age,
	premiumexpire,
	playerteam,
	radio,
	freq1,
	freq2,
	freq3,
	tbanned,
	job[MAX_STRING],
	totalruns,
	fpay,
	hasdrugs[ MAX_DRUG_TYPES ],
	warns,
	helper,
	curfreq,
	rankname[ 64 ],
	phonechanges,
	namechanges,
	lastonline,
	vMax,
	vSpawnMax,
	pbkills,
	pbdeaths,
	pGender,
	pEthnicity,
	pBoomBox,
	allowCBug,
	pBoomBoxBan, // if player is banned from using boombox.
	wantedLvl,
	wantedReason[128],
}
new PlayerInfo[MAX_PLAYERS][pstats];

enum ptemps
{
	sm,
	candrop,
	Duty,
	callingtaxi,
	phoneoff,
	oocoff,
	tokick,
	onphone,
	phone,
	muted,
	mutedtick,
	rentcar,
	carfrozen,
	wlock,
	tmphouse,
	tmpbiz,
	jqmessage,
	hname,
	onpaint,
	pbteam,
	playertosms = 666,
	adminduty,
	helperduty,
	adminspy,
	admincmdspy,
	DropTimer,
	isdropping,
	Text:Status,
	IP[ 32 ],
	canrob,
	RobTimer,
	spawnrdy,
	WrongPass,
	cmdtick,
	tp,
	hashadhelp,
	RobBizTimer,
	seeds,
	drugtick,
	fishamount,
	fishtick,
	fontick,
	lictimer,
	ppassword[129],
	totalfish,
	totalrob,
	totalguns,
	totallogin,
	Text:InfoBox,
	Text:InfoBoxTitle,
	key_enter,
	imprisoned,
	HasRedScreen,
	RobbingHouse,
	GYM_CURKEY,
	GYM_CURDONE,
	oocmode,
	fightstyleleft,
	lastpm,
	PlayerUsingBug,
	PlayerBugTimer,
	animation,
	pupdates,
	CPTimer,
	airbreakcount,
	bool:BlindFold,
	iconcount,
	bool:cuffed,
	weapon,
	ammo,
	tazed,
	bool:gettingTreatmentFromHospital,
	// textdraws
	Text:Cargo,
	Text:Harvest,
	Text:plrwarning,
	Text:jailtd,
    Text:LocationTD,
	//
	AntiSpawnWeapon[13],
	AntiSpawnAmmo[13],
	//
	pFurnitureCategorySelect[2], // 0 = MAIN_CATEGORY_SELECT, SUB_CATEGORY_SELECT
	pFurnitureSelectID,
	pMaterialSlotEdit,
	pAFK,
//	<>
	spectatingID,
	specType,
	gPlayerUsingLoopingAnim,
	gPlayerAnimLibsPreloaded,
	ticket,
	isCCTV,
	bool:loggedIn,
	PlayerWeapon[13],
	PlayerAmmo[13],
	Float:PlayerPosition[3],
	Float:PlayerHealth,
	Float:PlayerArmour,
	PlayerInterior,
	PlayerVirtualWorld,
	RecentlyShot,
	bool:chatAnim,
	bool:jobDuty,
	belt,
}
new PlayerTemp[MAX_PLAYERS][ptemps];

enum pToyInfo
{
	ptName[MAX_PLAYER_TOY_NAME],
    ptModelID,
	ptBone,
    Float:ptPosX,
	Float:ptPosY,
	Float:ptPosZ,
	Float:ptRotX,
	Float:ptRotY,
	Float:ptRotZ,
	Float:ptScaleX,
	Float:ptScaleY,
	Float:ptScaleZ,
	bool:ptActive, // if it's equipted or naw...
}
new PlayerToyInfo[MAX_PLAYERS][MAX_PLAYER_TOYS][pToyInfo];

enum _drugs
{
	drugid,                     // ID
	drugname[ MAX_STRING ],     // NAME
	drughp,                     // Howmuch HP it takes away
	drugprice,                  // Price of it
}
new drugtypes[ ][ _drugs ] =    // NEED TO UPDATE OTHER THINGS WHEN ADDING DRUGS!
{
	{   DRUG_COCAINE,  		"Cocaine",  	12,     40 	},
	{   DRUG_CANNABIS,  	"Cannabis",     1,    	10 	},
	{   DRUG_ECSTASY,  		"Ecstasy",  	15,     35 },
	{   DRUG_CRACK,			"Crack",    	8,    	20 	},
	{   DRUG_MORPHINE,  	"Morphine", 	14,     45 },
	{   DRUG_TRYPI,  		"Trypi",    	21,    	50 	},
	{   DRUG_HEROIN,  		"Heroin",   	40,     32 },
	{   DRUG_SPEED,  		"Speed",    	19,     37 }
};

enum _food
{
	foodid,
	foodname[ 50 ],
	foodhp,
	foodprice,
}
new foodtypes[][_food] =
{
	{   0,      "Coca Cola",    	5,      5,    },
	{   1,      "Cheeseburger",	 	12,     12,   },
	{   2,      "Double Burger",	16,     20,   },
	{   3,      "Big Mac",      	19,     22,   },
	{   4,      "Triple Burger",	20,     30,   },
	{   5,      "Quadruple Burger", 25, 	35,   }
};

enum _bikes
{
	bikeid,
	bikename[15],
	bikemodel,
	bikeprice,
}
new bikes[ ][ _bikes ] =
{
	{   0,  "Faggio",   	462,    90000  },
	{   1,  "PCJ-600",      461,   	1200000 },
	{   2,  "FCR-900",      521,    2300000 },
	{   3,  "Freeway",      463,    2200000 },
	{   4,  "BF-400",       581,    1300000 },
	{   5,  "Sanchez",      468,    2700000 },
	{   6,  "Wayfarer",     586,    3200000 }
};

enum _jobc
{
	jcid,
	jcname[40],
	jcprice,
	jcmodel,
}
new jobcars[ ][ _jobc ] =
{
	{   0,      "MrWhoopee",	400000,    	423    },
	{   1,      "Bus",			2200000,    431    },
	{   2,      "Coach",    	2200000,    437    },
	{   3,      "Forklift", 	210000,     530     },
	{   4,      "Sweeper",  	70000,     	574     },
	{   5,     "HotDogVan",		310000,     588     },
	{   6,     "Towtruck",  	150000,     525     },
	{   7,     "Utility Van",  	1500000,     552     }
};

enum _heavyc
{
	hcid,
	hname[40],
	hprice,
	hmodel,
}
new heavycars[ ][ _heavyc ] =
{
	{   0,      "Linerunner",	3000000,   403    },
	{   1,      "Trashmaster",	400000,   408    },
	{   2,      "Flatbed",		4000000,    455    },
	{   3,      "Yankee",   	2200000,    456    },
	{   4,      "Walton",  	 	1200000,    478     },
	{   5,      "Benson",   	800000,     499     },
	{   6,      "Journey",  	1200000,     508    },
	{   7,      "DFT-30",   	900000,     578     },
	{   8,     "Boxville",  	900000,     609     }
};


enum _bikess
{
	noobcid,
	noobcname[40],
	noobcprice,
	noobcmodel,
}
new noobcars[ ][ _bikess ] =
{
	{   0,      "Tampa",    250000,     549    },
	{   1,      "Primo",    200000,     547    },
	{   2,      "Emperor",  150000,     585    },
	{   3,      "Bobcat",   175000,     422    },
	{   4,      "Previon",  175000,     436     },
	{   5,      "Solair",   300000,     458     },
	{   6,      "Sabre",    500000,     475     },
	{   7,      "Regina",   310000,     479    },
	{   8,      "Virgo",    400000,     491     },
	{   9,     "Majestic", 	200000,     517     },
	{   10,     "Willard",  120000,     529     },
	{	11,		"Stratum",	420000,		561		},
	{	12,		"Uranus",	480000,		558		},
	{	13,		"Camper",	400000,		483		},
	{	14,		"Cadrona",	80000,		527		},
	{	15,		"Fortune",	85000,		526		},
	{	16,		"Hermes",	250000,		474		},
	{	17,		"Manana",	70000,		410		},
	{	18,		"Nebula",	110000,		516		},
	{	19,		"Vincent",	130000,		540		},
	{	20,		"Sadler", 	90000,		543		},
	{	21,		"Bravura",	85000,		401		},
	{	22,		"Perenniel",65000,		404		},
	{	23,		"Intruder",	75000,		546		}
};

enum _bikesss
{
	airid,
	airname[40],
	airprice,
	airmodel,
}
new aircars[ ][ _bikesss ] =
{
	{   0,      "Cropduster",    4000000,   512    },
	{   1,      "Dodo",          3000000,   593    },
	{   2,      "Stuntplane",    5500000,   513    },
	{   3,      "Beagle",        7000000,   511    },
	{   4,      "Maverick",      7000000,   487    },
	{   5,      "Sparrow",     	 9000000,   469    }
};

enum _bikessss
{
	boatidd,
	boatname[40],
	boatprice,
	boatmodel,
}
new watercars[ ][ _bikessss ] =
{
	{   0,      "Squallo",  4000000, 446 },
	{   1,      "Reefer",   2000000, 453 },
	{   2,      "Tropic",   8000000, 454 },
	{   3,      "Coastguard",2000000,472 },
	{   4,      "Dinghy",   300000, 473 },
	{   5,      "Marquis",  700000,484 },
	{   6,      "Jetmax",   5000000,493 },
	{   7,       "Launch",  900000,595 }
};

enum _wheelz
{
	whComponent,
	whName[ 24 ]
}
new CarWheels[][ _wheelz ] =
{
	{ 1025, "Offroad" },
	{ 1073, "Shadow" },
	{ 1074, "Mega" },
	{ 1075, "Rimshine" },
	{ 1076, "Wires" },
	{ 1077, "Classic" },
	{ 1078, "Twist" },
	{ 1079, "Cutter" },
	{ 1080, "Switch" },
	{ 1081, "Grove", },
	{ 1082, "Import" },
	{ 1083, "Dollar" },
	{ 1084, "Trance" },
	{ 1085, "Atomic" },
	{ 1096, "Ahab" },
	{ 1097, "Virtual" },
	{ 1098, "Access" }
};

enum _cars1
{
	cccarid,
	cccarname[50],
	cccarmodel,
	cccarprice,
}
new cars_normal[ ][ _cars1 ] =
{
	{   0,  "Sentinel", 405, 1600000 },
	{   1,  "Moonbeam", 418, 1100000 },
	{	2,  "Premier",  426, 1400000 },
	{   3,  "Stallion", 439, 2200000 },
	{   4,  "Admiral",  445, 1200000 },
	{   5,  "Burrito",  482, 2700000 },
	{   6,  "Rancher",  489, 3800000 },
	{   7,  "Greenwood",492, 1100000 },
	{   8,  "Blista C.",496, 1200000 },
	{   9, "Elegant",  507, 2200000 },
	{   10, "Slamvan",  535, 1200000 },
	{   11, "Sunrise",  550, 900000 },
	{   12, "Windsor",  555, 4300000 },
	{   13, "Jester",   559, 2700000 },
	{   14, "Sultan",   560, 3200000 },
	{   15, "Elegy",    562, 3300000 },
	{   16, "Tahoma",   566, 700000 },
	{   17, "Huntley",  579, 2600000 },
	{   18, "Stafford", 580, 3100000 },
	{   19, "VooDoo",   412, 500000 },
	{   20, "Savanna",  567, 400000 },
	{   21, "Tornado",  576, 600000 },
	{   22, "Washington",421, 2100000 },
	{   23, "Flash",    565, 1400000 },
	{	24,	"Remington",534, 2000000}
};

enum _cars2
{
	cccarid,
	cccarname[50],
	cccarmodel,
	cccarprice,
}
new cars_luxus[ ][ _cars2 ] =
{
	{   0,  "Buffalo", 402, 5500000 	},
	{   1,  "Banshee", 429, 7000000 	},
	{   2,  "SuperGT", 506, 6000000 	},
	{   3,  "Bullet",  541, 6900000 	},
	{   4,  "Alpha",   602, 4500000 	},
	{   5,  "Infernus",411, 9900000 	},
	{   6,  "Turismo", 451, 9500000 	},
	{   7,  "Comet",   480, 5000000 	},
	{   8,  "Phoenix", 603, 6500000 	},
	{   9,  "Stretch", 409, 5500000 	}
};

enum gunStoreInfo
{
	gsID,
	gsweapName[32],
	gsweapID,
	gsweapAmmo,
	gsComps,
}
new GunStoreInfo[][gunStoreInfo] = {
	{0, "Deagle", WEAPON_DEAGLE, 75, 1},
	{1, "MP5", WEAPON_MP5, 250, 2},
	{2, "M4A1", WEAPON_M4, 150, 2},
	{3, "Sniper Rifle", WEAPON_SNIPER, 50, 5},
	{4, "Country Rifle", WEAPON_RIFLE, 60, 3},
	{5, "Shotgun", WEAPON_SHOTGUN, 25, 3},
	{6, "Armour", -1, -1, 1} // no ammo or weapon
};

enum _gangzones
{
	gID,
	gFACTION,
	gCOLOUR,
	Float:minX,
	Float:minY,
	Float:maxX,
	Float:maxY,
	Text:gDRAW,
	gBLINK,
}
new Gangzones[MAX_GANGZONES][_gangzones];

enum objfields
{
	objid,
	objflag
}
new obj[100][objfields];

enum vInfo
{
	vModel, // the model of the vehicle, 411 = Infernus.
	vOwner[MAX_PLAYER_NAME], // owner of the vehicle.
	vDupekey[MAX_PLAYER_NAME], // dupekey owner of the vehicle.
	Float:vX, // X coord of the vehicle.
	Float:vY, // Y coord of the vehicle.
	Float:vZ, // Z coord of the vehicle.
	Float:vA, // Angle coord of the vehicle.
	vVirtualWorld, // virtual world of the vehicle...
	vColour1, // colour1 of the vehicle.
	vColour2, // colour2 of the vehicle.
	vPaintJob, // current paintjob of the vehicle.
	vFaction, // current faction ID of the vehicle.
	vReserved, // reserved status, 0 = normal (owned..), 1 = noob car, 2 = job car...
	vJob[12], // current job stats.
	vBusiness, // if the vehicle is a rentable car...
	vSellPrice, // if the vehicle is on sale or not..
	vComponents[CAR_COMPONENTS], // components...
	bool:vLocked, // if the vehicle is locked.
	vLockedBy, // who it's locked by, server = -1.
	vFuel, // current fuel status.
	vWeapon[13], // weapon slots...
	vAmmo[13], // weapon (ammo) slots...
	vehicleGuns, // gun runs...
	vehicleBullets, // bullet runs...
	HasGunCrates, // gun crate runs...
	HasBulletCrates, // bullet run crates...
	vStuffs, // comps > stuffs
	vGuns, // comps > guns
	vAlchool, // comps > alchol
	vCars, // comps > cars
	vMoney, // comps > money
	vOil, // comps > oil
	vDrugs, // comps > drugs
	vTrailer,
	vImpounded,
	vImpoundFee,
	vImpoundReason[128],
	Float:vMileage,
	vAlarm,
	vPlate[15],
	bool:vRegistered,
	// warehouse
	vWHLead,
	vWHMetal,
	// not saved..
	vID,
	vRID,
	bool:vActive, // if the vehicle is active.
	bool:vSpawned, // if the vehicle is currently spawned.
	compscar,
}
new VehicleInfo[MAX_VEHICLES][vInfo];

enum _unimp
{
	Float:spawnx,
	Float:spawny,
	Float:spawnz,
	Float:sangle,
}
new unimpoundpos[][_unimp] =
{
	{ 2404.5405,-2143.5388,13.2740,268.6757 },
	{ 2391.9580,-2144.0713,13.2740,268.8278 },
	{ 2405.4409,-2137.8933,13.2796,267.8626 },
	{ 2389.5803,-2137.3000,13.2787,267.8599 },
	{ 2404.4526,-2131.5942,13.2774,267.3236 },
	{ 2369.1919,-2125.6929,13.3267,269.1523 },
	{ 2383.1450,-2125.8953,13.2725,269.1627 },
	{ 2392.6863,-2126.0342,13.2739,269.1736 },
	{ 2400.1169,-2116.5024,13.2740,267.7480 },
	{ 2387.3562,-2116.0000,13.2740,267.7480 },
	{ 2388.0923,-2106.1064,13.2739,269.1141 },
	{ 2403.6226,-2106.3464,13.2739,269.1144 },
	{ 2370.0586,-2100.0977,13.2746,238.0827 },
	{ 2378.9648,-2099.7593,13.2785,214.9634 },
	{ 2378.2834,-2081.3652,13.2355,359.1956 },
	{ 2378.1594,-2090.8245,13.2560,359.3439 },
	{ 2381.1611,-2063.8525,13.2053,332.8090 },
	{ 2391.4041,-2061.5396,13.2291,271.0861 },
	{ 2404.8306,-2061.2759,13.2705,270.9985 },
	{ 2394.1497,-2069.2727,13.2373,43.4654 },
	{ 2384.9727,-2068.0703,13.2152,113.7801 },
	{ 2495.4460,-2050.9221,13.2771,178.4879 },
	{ 2491.8535,-2058.7888,13.2771,129.5831 },
	{ 2476.2405,-2059.5422,13.2771,85.6659 },
	{ 2465.8701,-2063.1335,13.2771,90.5999 },
	{ 2455.0493,-2059.4548,13.2771,88.1206 },
	{ 2446.2175,-2063.1216,13.2771,90.0242 },
	{ 2433.6292,-2059.5679,13.2771,89.7271 },
	{ 2427.3916,-2063.7397,13.2771,90.5544 }
};

enum _garag
{
	Float:g_x,
	Float:g_y,
	Float:g_z,
	Float:g_a,
	g_desc[MAX_STRING],
	g_price,
}
new garages[][_garag] =
{
	{0.0,       0.0,        0.0,    0.0,    "NULL", 0},
	{-2711.3845, 659.3242, 66.1581,0.000, "Small - 1 Car", 200000}, // small 1
	{-2685.5454, 663.6561, 66.1759, 0.000, "Big - 4 Cars", 900000}, // big 1
	{-2683.5957, 618.5010, 66.2348, 180.0000, "Extreme - 10+ Cars", 3700000}, // extreme
	{1592.8217,1599.6440,10.9480, 0.0000, "Ultra Extreme - 25+ cars", 6500000} // ultra
};

enum spawnfields
{
	spawnid,
	Float:spawnx,
	Float:spawny,
	Float:spawnz,
	Float:spawna,
	ispawn,
	vspawn
}
new randomspawn[][spawnfields] =
{
	{0, -1980.7375,-2404.8035,30.6250,136.9513, 0, 0}
};

enum vSellPositions
{
	Float:spawnx,
	Float:spawny,
	Float:spawnz,
	Float:spawna
}
new VehicleSellPositions[][vSellPositions] = {
	{	311.5523,-1809.8368,4.1639,0.4133   	},
	{	314.7959,-1809.2509,4.1828,359.8443   	},
	{	317.8859,-1809.3455,4.1828,0.8262       },
	{	321.1047,-1809.4791,4.1814,0.7016       },
	{	324.4004,-1809.4912,4.1830,359.7085     },
	{	327.6755,-1809.5820,4.1828,359.8779     },
	{	330.8799,-1809.3444,4.1892,359.9532     },
	{	334.0619,-1809.1475,4.1983,0.2621       },
	{	337.3180,-1809.0537,4.2181,359.6637     },
	{	340.5044,-1809.2720,4.2228,0.0894       },
	{	343.8109,-1809.6733,4.2146,359.7701     },
	{	347.0170,-1809.6873,4.2176,359.7796     },
	{	350.2072,-1809.5676,4.2242,359.8097     },
	{	353.4597,-1809.6748,4.2239,359.0750     },
	{	356.7515,-1809.7291,4.2255,0.5593       },
	{	311.7891,-1788.5647,4.2817,180.1192     },
	{	314.9078,-1788.7113,4.3316,180.0556     },
	{	318.2260,-1788.9041,4.3843,180.0723     },
	{	321.3846,-1788.6260,4.4359,179.6309     },
	{	324.7156,-1788.7866,4.4894,181.4071     },
	{	327.9837,-1788.8346,4.5414,179.7467     },
	{	331.1564,-1788.6929,4.5860,179.7962     },
	{	334.2986,-1788.9670,4.6030,180.0027     },
	{	337.6124,-1788.7264,4.6309,179.8299     }
};
new VehicleDealershipPos[][vSellPositions] = {
	{	1558.4507,-1012.0538,23.6115,180.2570   	},
	{	1562.9266,-1011.8457,23.6112,180.9830   	},
	{	1567.3964,-1011.9369,23.6149,181.2456   	},
	{	1571.7916,-1011.7947,23.6111,180.2539   	},
	{	1576.3394,-1012.0065,23.6115,181.2742   	},
	{	1581.5549,-1011.3942,23.6111,187.24826   	},
	{	1585.7994,-1010.6792,23.6114,187.00707   	},
	{	1590.3748,-1010.4599,23.6111,186.81238   	},
	{	1594.8038,-1010.0356,23.6114,186.32059   	},
	{	1599.2058,-1009.3998,23.6114,187.436410   	},
	{	1604.4308,-1009.3269,23.6117,177.690411   	},
	{	1608.8463,-1009.4152,23.6111,179.215812   	},
	{	1613.3347,-1009.5384,23.6113,178.903313   	},
	{	1617.7225,-1009.6387,23.6053,180.150214   	},
	{	1623.6272,-1010.7456,23.6034,161.846015   	},
	{	1627.8645,-1012.2283,23.6037,161.952116   	},
	{	1632.2197,-1013.3359,23.6040,162.906817   	},
	{	1636.3584,-1014.7957,23.6035,162.839818   	},
	{	1640.6276,-1016.2175,23.6037,163.524319   	},
	{	1644.9639,-1017.2985,23.6033,162.479320   	},
	{	1542.6786,-1024.1312,23.6110,342.902721   	},
	{	1546.9404,-1025.3623,23.6115,342.699822   	},
	{	1551.1418,-1026.7772,23.6115,343.254123   	},
	{	1555.3383,-1028.3407,23.6115,344.156924   	},
	{	1559.7422,-1029.3759,23.6111,343.801725   	},
	{	1563.9249,-1030.9219,23.6133,344.955626   	},
	{	1629.2134,-1084.9688,23.6115,270.14941   	},
	{	1620.7306,-1085.0588,23.6114,90.41372   	},
	{	1620.6558,-1089.5238,23.6115,89.95623   	},
	{	1620.5050,-1094.1088,23.6150,90.19344   	},
	{	1620.9238,-1098.5100,23.6114,89.20495   	},
	{	1620.7930,-1102.9419,23.6111,89.85706   	},
	{	1620.6122,-1107.5421,23.6111,88.90867   	},
	{	1630.2673,-1107.4606,23.6117,269.15058   	},
	{	1630.0140,-1102.9768,23.6111,269.33519   	},
	{	1630.0054,-1098.4723,23.6115,269.809410   	},
	{	1630.0555,-1093.9667,23.6151,269.411111   	},
	{	1630.0240,-1089.5870,23.6113,269.946712   	},
	{	1657.3326,-1080.0165,23.6076,270.077313   	},
	{	1649.0560,-1080.0277,23.6078,90.027014   	},
	{	1649.0627,-1084.5787,23.6115,90.423715   	},
	{	1648.9449,-1089.0321,23.6113,90.348816   	},
	{	1649.2522,-1093.6169,23.6112,89.613617   	},
	{	1649.1614,-1098.1335,23.6111,90.244918   	},
	{	1649.4865,-1102.5968,23.6116,89.823419   	},
	{	1649.2782,-1107.2372,23.6115,89.829820   	},
	{	1649.1311,-1111.6172,23.6188,90.084421   	},
	{	1658.3075,-1111.6067,23.6111,269.359522   	},
	{	1658.1486,-1107.0896,23.6114,270.789223   	},
	{	1658.2792,-1102.5974,23.6118,269.637724   	},
	{	1658.4407,-1098.1222,23.6117,270.367226   	},
	{	1658.0056,-1093.5863,23.6116,269.869325   	},
	{	1657.9600,-1089.0625,23.6117,269.059527   	},
	{	1658.2511,-1084.6935,23.6118,270.450828   	},
	{	1675.5659,-1097.9076,23.6113,90.055929   	},
	{	1675.5890,-1102.3999,23.6111,88.558130   	},
	{	1675.6064,-1106.9323,23.6113,90.019531   	},
	{	1675.7065,-1111.4115,23.6108,88.885832   	},
	{	1675.8838,-1115.8802,23.6117,90.150033   	},
	{	1675.4083,-1120.3766,23.6118,89.634834   	},
	{	1675.7164,-1124.9803,23.6113,91.241535   	},
	{	1675.6351,-1129.3999,23.6114,89.298336   	},
	{	1666.4382,-1135.6376,23.6114,359.440637   	},
	{	1661.8627,-1135.7936,23.6115,359.868938   	},
	{	1657.3975,-1135.7979,23.6113,359.513239   	},
	{	1652.9778,-1135.6080,23.6116,359.079540   	},
	{	1648.4154,-1135.9498,23.6118,359.465841   	},
	{	1617.3258,-1137.2406,23.6115,269.157242   	},
	{	1617.2710,-1132.5795,23.6108,269.0255   	},
	{	1617.2650,-1128.0760,23.6116,269.4776   	},
	{	1616.9221,-1123.6322,23.6115,269.6078   	},
	{	1616.8679,-1119.1703,23.6112,269.4388   	}
};

enum drinkss
{
	drinkname[MAX_STRING],
	drinkprice,
	bool:drinkDrunk
}

new ClubDrinks[][drinkss] = {
	{"Vodka",3,true},
	{"Cointreou",5,true},
	{"JackDaniels",4,true},
	{"ZeddaPiras",4,true},
	{"SanSimone",5,true},
	{"Scotch",3,true},
	{"Pampero",4,true},
	{"Bacardi",5,true},
	{"FiluFerru",8,true},
	{"J&B",4,true},
	{"Gin",5,true},
	{"Montenegro",3,true},
	{"DomPerignon",200,true},
	{"Chardonnay",150,true},
	{"PerrierJouet",1000,true},
	{"Taitinger",190,true},
	{"Cannonau",80,true},
	{"Zibibbo",80,true},
	{"Heineken",3,true},
	{"Budweiser",5,true},
	{"Guinness",4,true},
	{"Ichnusa",3,true},
	{"SanMiguel",3,true},
	{"CocaCola",3,false},
	{"Fanta",3,false},
	{"Sprite",4,false},
	{"Water",1,false},
	{"RedBull",5,false}
};

enum _labels
{
	labtext[MAX_STRING],
	Float:labx, Float:laby, Float:labz,
}
new labels[][_labels] = {
	{ "{228B22}[ {FFFFFF}Driver License{228B22} ]\n {DCDCDC}Type {FF0000}/driverlicense{DCDCDC} to obtain your license!", 1088.4662,1468.7936,5.8481 },
	{ "{228B22}[ {FFFFFF}Pilot License{228B22} ]\n {DCDCDC}Type {FF0000}/pilotlicense{DCDCDC} to obtain your license!", 1450.3385,-2287.1191,13.5469 },
	{ "{228B22}[ {FFFFFF}Sailing License{228B22} ]\n {DCDCDC}Type {FF0000}/sailinglicense{DCDCDC} to obtain your license!", 202.5701,-1875.7019,3.7082 },
	{ "{228B22}[ {FFFFFF}All Saints Hospital{228B22}]", 1172.7296,-1323.7656,15.4015 },
	{ "{228B22}[ {FFFFFF}Fish warehouse{228B22} ]\n {DCDCDC}Here you can {FF0000}/sellfish{DCDCDC}!", 979.4454,-1255.0919,16.9480},
	{ "{228B22}[ {FFFFFF}Licensing Department{228B22} ]\n {DCDCDC}Type {FF0000}/enter{DCDCDC}, inside you can get your licenses! ", 1248.0586,-1560.3561,13.5635 },
	{ "{228B22}[ {FFFFFF}City Hall{228B22} ]\n {DCDCDC}Type {FF0000}/enter{DCDCDC}, inside you can find some jobs! ", -2176.5918,-2311.2808,31.3781 },
	{ "{228B22}[ {FFFFFF}Freetime Fishing{228B22} ]\n {DCDCDC}Here you can {FF0000}/fish{DCDCDC}!\n Start fishing\n with {FF0000}/fish{DCDCDC}. You can sell them afterwards with {FF0000}/sellfish{DCDCDC}!", 373.9311,-2082.6797,7.8359 },

	{ "{228B22}[ {FFFFFF}Load gun crates{228B22} ]\n {DCDCDC}/loadguncrates to start (50 guns max)",-1468.7668,1490.5842,8.2578},
	{ "{228B22}[ {FFFFFF}Sell Gun Crates{228B22} ]\n {DCDCDC}/sellguncrates to sell your guns off!", -1509.3240,1992.9187,48.648},
	
	{ "{228B22}[ {FFFFFF}Load bullet crates{228B22} ]\n {DCDCDC}/loadbulletcrates to start (50 clips max)", -1832.5226,-1652.6495,21.4407},
	{ "{228B22}[ {FFFFFF}Sell Bullet Crates{228B22} ]\n {DCDCDC}/sellbulletcrates to sell your bullets off!", -955.0131,1444.9067,32.5793},
	
	{ "{228B22}[ {FFFFFF}Angel Pine Police Department{228B22} ]", -2088.6377,-2422.4573,31.8705},
	{ "{228B22}[ {FFFFFF}Angel Pine Accident & Emergency{228B22} ]\n {DCDCDC}They're like superheros, minus the cape!", 2034.5945,-1405.5621,17.2308},
	{ "{228B22}[ {FFFFFF}Angel Pine Gym{228B22} ]\n {DCDCDC}Why not buff yourself up?!", 2229.8801,-1721.2362,13.5610},
	
    { "{228B22}[ {FFFFFF}Welcome to "SERVER_GM" {228B22} ]\n {DCDCDC}Type /helpme if you're new to this server.",1763.9847,-1937.5952,13.5772},
	{ "{FF0000}[ {FFDAB9}Materials {FF0000}]\n {FFDAB9} Recycled Matal\nPress {FF0000}Y{FFDAB9} to buy a crate of metal.", 679.9108, 826.1727, -38.9921},
	{ "{FF0000}[ {FFDAB9}Materials {FF0000}]\n {FFDAB9} Recycled Lead\nPress {FF0000}Y{FFDAB9} to buy a crate of lead.", -1521.0822, 117.2174, 17.3281}
};

enum entr
{
	intid,
	inttype,
	Float:int_inx,
	Float:int_iny,
	Float:int_inz,
	Float:int_outx,
	Float:int_outy,
	Float:int_outz,
	int_interior,
	int_virtual,
	restrictionrank
}
new places[][entr] = {
	{0, 	0, 		246.4070,107.5931,1003.2188, 		1554.5803,-1675.5531,16.1953,			10,		31337,	false}, // LSPD
	{1,		0,		388.87200,173.805000,1008.3828,		1481.0500,-1772.1019,18.7958,			3,		20,		false}, // City hall
	{2,		0, 		-1432.1934,-542.2756,14.2037,		1172.7296,-1323.7656,15.4015,			1,		31337, 	false}, // LS Hospital
	{3,		0, 		1089.3699,1481.11950,6.01946, 		1248.0586,-1560.3561,13.5635, 			0, 		0, 		false}, // License Department
	{4,		0, 		773.95250,-78.415300,1000.6622, 	2229.8801,-1721.2362,13.5610, 			7, 		1338, 	false} // GYM
};

enum gGun
{
	Float:ggX,
	Float:ggY,
	Float:ggZ,
	ggInterior,
	fac_Type,
}
new GiveGunPositions[][gGun] = {
	{267.1984, 118.6649, 1004.6172, 10, -1}, // LSPD spawn
	{2164.528, -2310.85, 13.546900, 00, FAC_TYPE_ARMY} // SASF base
};

enum bInfo
{
	bOwner[MAX_PLAYER_NAME],
	bDupekey[MAX_PLAYER_NAME],
	bName[MAX_BIZ_NAME],
	bType,
	Float:bX, // outside
	Float:bY, // outside
	Float:bZ, // outside
	bVirtualWorld, // outside
	bInterior, // outside
	bInteriorPack,
	bCompsFlag,
	bTax,
	bLastRob,
	bLevel,
	bSellprice,
	bRestock,
	bRentPrice,
	bTill,
	bool:bLocked,
	bComps,
	bFee,
	bDeagle,
	bMP5,
	bM4,
	bShotgun,
	bRifle,
	bSniper,
	bArmour,
	bAskComps,
	bBuyable,
	// no save
	bool:bActive,
	Text3D:bLabel,
	bPickup,
	bArea,
	bMapIcon,
	bool:bRobbed,
}
new BusinessInfo[MAX_BUSINESS][bInfo];

enum bInteriors
{
	interiorid,
	Float:enterX,
	Float:enterY,
	Float:enterZ,
	Float:enterA,
	enterInt,
	INTprice,
	intType,
}
new BusinessInteriors[][bInteriors] = {
	{0, 	-663.5677,	1982.3759,	31.2459,	89.4725, 	4, 		0, 	BUSINESS_TYPE_BANK},
	{1, 	-27.3268,	-31.4991,	1003.5573,	357.0238, 	4, 		0, 	BUSINESS_TYPE_247},
	{2,		1133.0625, 	-15.3476, 	1000.6797, 	359.1179, 	12, 	0, 	BUSINESS_TYPE_CASINO},
	{3,		662.6404,	-573.3184,	16.3359,	269.4341, 	6, 		0, 	BUSINESS_TYPE_GAS},
	{4,		-100.3234,	-24.8766,	1000.7188,	358.9892, 	3, 		0, 	BUSINESS_TYPE_HARDWARE},
	{5,		493.3569,	-24.7790,	1000.6797,	359.9628, 	17, 	0, 	BUSINESS_TYPE_CLUB},
	{6,		-229.1562,	1401.2476,	27.7656,	270.6783, 	18,		0, 	BUSINESS_TYPE_PUB},
	{7,		-229.221,	1401.1639,	27.76560,	268.2433, 	3, 		0, 	BUSINESS_TYPE_STRIPCLUB},
	{8,		315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BUSINESS_TYPE_GUNSTORE},
	{9,		364.8251,	-11.41790,	1001.851,	358.3588,	9,		0,	BUSINESS_TYPE_CHICKEN},
	{10,	372.2757,	-133.3900,	1001.492,	357.9828,	5,		0,	BUSINESS_TYPE_PIZZA},
	{11,	203.7175,	-50.34860,	1001.804,	358.0455,	1,		0,	BUSINESS_TYPE_CLOTHES},
	{12,	363.0546,	-75.10130,	1001.507,	314.9304,	10,		0,	BUSINESS_TYPE_BURGER},
	{13,	460.2277,	-88.58570,	999.5547,	88.72490,	4,		0,	BUSINESS_TYPE_CAFE},
	{14,	453.0318,	-18.14820,	1001.132,	88.45780,	1,		0,	BUSINESS_TYPE_RESTAURANT},
	// ^^^^^^ default interiors - FREE!
	{15, 	-25.8763,	-141.2666,	1003.5469,	358.4652, 	16, 	0, 	BUSINESS_TYPE_247},
	{16, 	-30.9616, 	-91.5419, 	1003.5469, 	357.0500, 	18, 	0, 	BUSINESS_TYPE_247},
	{17, 	6.117700,	-31.5707,	1003.5494,	0.117800, 	10, 	0, 	BUSINESS_TYPE_247},
	{18, 	-25.8665,	-188.1023,	1003.5469,	0.055200, 	17, 	0, 	BUSINESS_TYPE_247},
	// ******* 24/7 finish
	{19,	2019.0660,	1017.8765,	996.8750,	90.02160, 	10, 	0, 	BUSINESS_TYPE_CASINO},
	{20,	2234.0598,	1714.5258,	1012.3828,	181.5783, 	1, 		0, 	BUSINESS_TYPE_CASINO},
	// ******* casino finish
	{21,	-2240.628,	137.2648,	1035.414,	266.3939, 	6, 		0, 	BUSINESS_TYPE_HARDWARE},
	{22,	316.4254,	-169.8015,	999.6010,	0.0814, 	6, 		0, 	BUSINESS_TYPE_HARDWARE},
	// ******* hardware finish
	{23,	-2636.70,	1402.6003,	906.4609,	359.5495, 	3, 		0, 	BUSINESS_TYPE_CLUB},
	// ******** club finish
	{24,	501.9083,	-67.7105,	998.7578,	178.9960, 	11, 	0, 	BUSINESS_TYPE_PUB},
	{25,	681.4684,	-451.5404,	-25.6172,	179.1841, 	1, 		0, 	BUSINESS_TYPE_PUB},
	// ********* pub finish
	{26,	1204.8899,	-13.6871,	1000.9219,	359.8602, 	2, 		0, 	BUSINESS_TYPE_STRIPCLUB},
	{27,	-2636.659,	1402.654,	906.4609,	359.9855, 	3, 		0, 	BUSINESS_TYPE_STRIPCLUB},
	// ********* gunstore
	{28,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BUSINESS_TYPE_GUNSTORE},
	{29,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BUSINESS_TYPE_GUNSTORE},
	{30,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BUSINESS_TYPE_GUNSTORE},
	{31,	315.7950,	-143.2724,	999.6016,	0.945500, 	7, 		0, 	BUSINESS_TYPE_GUNSTORE}
};

enum floatingobjenum
{
	oinfoid,
	oplacename[MAX_STRING],
	oinfomsg[MAX_STRING],
	Float:olocation_x,
	Float:olocation_y,
	Float:olocation_z,
	icontype,
	pickupID,
}
new objfloat[][floatingobjenum] = {
	{0,		"GunsPlace",		"~w~Illegal Guns Place~n~~y~/loadguns~n~",									-1439.4700,507.6037,4.6951,355},
	{1,		"DrugsPlace",		"~w~Illegal Drugs Place~n~~y~/pickdrugs~n~",								-2130.4980,224.5857,35.6751,1279},
	{2,		"AlcoholPlace",		"~w~Alchool Place~n~~y~/pickalcohol~n~",									2565.4810,-2419.3328,13.6335,1517},
	{3,		"StuffsPlace",		"~w~Stuffs Place~n~~y~/pickstuffs~n~",										2613.4412,-2365.9270,13.6250,1271},
	{4,		"putPlace",			"~w~Stock Place~n~~y~/putstuffs~n~~n~~y~/putguns~n~~n~~y~/putalchool~n~",	599.2726,867.6162,-43.2562,1271},
	{5,		"DrugsPlace2",		"~w~Illegal Drugs Stock~n~~y~/putdrugs~n~",									928.0421,2150.4253,10.5252,1279},
	{6,		"guns place",		"~b~stock to load guns~n~~w~use /floadguns!",								-1507.0266,1976.3566,48.3750, 355},
	{7,		"bullets place",	"~b~stock to load bullets~n~~w~use /floadbullets!", 						-933.9237,1425.1211,30.1432, 355},
	{8,		"loadguncrates",	"~b~stock to load guncrates~n~~w~use /loadguncrates!", 						-1468.6888,1490.5033,8.2578, 1271},
	{9,		"loadbulletcrates",	"~b~stock to load bulletcrates~n~~w~use /loadbulletcrates!",				-1832.5226,-1652.6495,21.4407, 1271},
	{10,	"sellguncrates",	"~b~stock to sell guncrates~n~~w~use /sellguncrates!",						-1509.3240,1992.9187,48.6480, 1271},
	{11,	"sellbulletcrates",	"~b~stock to sell bulletcrates~n~~w~use /sellbulletcrates!",				-955.0131,1444.9067,32.5793, 1271}
};

enum SavePlayerPosEnum
{
    Float:LastX,
    Float:LastY,
    Float:LastZ
}
new SavePlayerPos[MAX_PLAYERS][SavePlayerPosEnum];
new SavePlayerPosEx[MAX_PLAYERS][SavePlayerPosEnum];

enum gs
{
	benzid,
	Float:centerx,
	Float:centery,
	Float:centerz,
	radius,
}
new Float:gasstation[][gs] = {

    {  -1,  1940.9296,-1772.8582,13.6406,     15 },
	{  -1,  1004.0770,-937.5317,42.3281,     15 },
	{  -1,  -90.9067,-1168.6757,2.4241,     15 },
	{  -1,  -1606.1031,-2714.0725,48.5335,     15 },
	{  -1,  -2026.6949,156.9232,29.0391,     15 },
	{  -1, -2410.0376,976.2665,45.4257,     15 },
	{  -1, -2243.9629,-2560.6477,31.9219,     15 },
	{  -1, -1676.6323,414.0262,7.1797,     15 },
	{  -1, 2202.2349,2474.3494,10.8203,     15 },
	{  -1, 614.9333,1689.7418,6.9922,     15 },
	{  -1,  -1328.8250,2677.2173,50.0625,     15 },
	{  -1,  70.3882,1218.6783,18.8120,     15 },
	{  -1,  2113.7390,920.1079,10.8203,     15 },
	{  -1,  2639.1008,1106.0287,10.8203,     15 },
	{  -1,  2146.6772,2749.3394,10.8203,     15 },
	{  -1, 1595.8685,2201.7771,10.8203,     15 },
	{  -1, -1471.5480,1863.9773,32.6328,     15 },
	{  -1, 655.3238,-565.2769,16.3359,     15 },
	{  -1, 1382.2380,460.1650,20.3452,     15 }
};

enum pball
{
	pballid,
	pballname[MAX_STRING],
	Float:teamred_x, Float:teamred_y, Float:teamred_z, Float:teamred_a,
	Float:teamblue_x, Float:teamblue_y, Float:teamblue_z, Float:teamblue_a,
	redskin,
	blueskin,
}
new pb[][pball] =  {
	{0, "PB test 1",   -1131.5339, 1057.7502, 1346.4154, 269.6870,     -974.3930, 1061.1287, 1345.6758, 89.4990,     244, 283},
	{1, "PB Test 2",   -1131.5339, 1057.7502, 1346.4154, 269.6870,     -974.3930, 1061.1287, 1345.6758, 89.4990,     244, 283}
};

enum FP
{
	biznumber,
	redteamcount,
	blueteamcount,
	redscore,
	bluescore,
}
new PBTeams[200][FP];

enum h_Info
{
	hID,
	hOwner[MAX_PLAYER_NAME],
	bool:hRentable,
	hRentprice,
	hLevel,
	bool:hClosed,
	hSellprice,
	bool:hBuyable,
	hCash,
	hTill,
	hSGuns,
	hSDrugs,
	hInteriorPack,
	Float:hX,
	Float:hY,
	Float:hZ,
	hInterior,
	hVirtualWorld,
	hWeapon[13],
	hAmmo[13],
	bool:hLocker, // locked or not...
	hAlarm,
	hWardrobe,
	hArmour,
	hSkins[5],
	
	Float:hGarageX,
	Float:hGarageY,
	Float:hGarageZ,
	Float:hGarageA,
	bool:hGarageOpen,
	hGarageInt,
	hGarageVW,
	hGarageInteriorPack,
	Text3D:hGarageLabel,
	
	Text3D:hLabel,
	hArea,
	hInteriorObject, // Base interior object!
	bool:hActive,
	wardrobeArea,
	wardrobePickup,
}
new HouseInfo[MAX_HOUSES][h_Info];

enum hInteriors
{
	intLevel,
	intModel,
	Float:intX,
	Float:intY,
	Float:intZ,
	Float:intA,
	
	Float:baseX,
	Float:baseY,
	Float:baseZ,
	Float:baserX,
	Float:baserY,
	Float:baserZ,
	
	Float:wardrobeX,
	Float:wardrobeY,
	Float:wardrobeZ,
	intPrice,
	intMaterials,
}
new IntInfo[][hInteriors] = {
	{0, 14718, 	-1854.9453, 1049.6726, 145.1549, 357.3830, 		-1858.05945, 1053.78894, 144.14709, 0.00000, 0.00000, 0.00000, 		-1860.33472, 1051.73108, 145.15010, 0, 9},
	{1, 14750,	-1734.8743, 1202.8149, 48.84570, 90.00000,		-1731.34485, 1211.37671, 54.33190,   0.00000, 0.00000, 0.0000,		-1727.15308, 1207.81311, 53.340700,	0, 25}
};

enum hMaterialInfo
{
	hmLevel,
	hmMaterialIndex,
	hmMaterialText[32],
}
new HouseMaterialInfo[][hMaterialInfo] = {
	{0, 0, "Blinds"}, {0, 1, "Lightswitch"}, {0, 2, "Flooring"}, {0, 3, "Ceiling"}, {0, 4, "Skirting Board (Baseboard)"}, {0, 5, "Wallpaper"}, {0, 6, "Window Rim"}, {0, 7, "Windows"}, {0, 8, "Lighting (Throughout)"},

	{1, 0, "Middle Staircase Banister"}, {1, 1, "Ceiling"}, {1, 2, "Kitchen Wallpaper"}, {1, 3, "Kitchen Ceilingboard"}, {1, 4, "Kitchen Rug"}, {1, 5, "Bedroom Upper Wallpaper"}, {1, 6, "Staircase Banister Holders"}, {1, 7, "Staircase / Living Room Carpet"}, 
	{1, 8, "Bathroom Floor Tile"}, {1, 9, "Lobby Wallpaper"}, {1, 10, "Bathroom Upper Wallpaper"}, {1, 11, "Living Room Wallpaper"}, {1, 12, "Bathroom Lower Wallpaper"}, {1, 13, "Bathroom Upper Baseboard"}, {1, 14, "Bedroom Rug"}, {1, 15, "Staircase Lower Wallpaper"},
	{1, 16, "Downstairs / Bedroom Flooring"}, {1, 17, "Wardrobe Door"}, {1, 18, "Find This..."}, {1, 19, "Find This..."}, {1, 20, "Find This..."}, {1, 21, "Bedroom Lower Wallpaper"}, {1, 22, "Baseboard"}, {1, 23, "Blinds"},
	{1, 24, "Find This..."}
};

enum furInfo
{
	furName[85],
	furModel,
	Float:furX,
	Float:furY,
	Float:furZ,
	Float:furrX,
	Float:furrY,
	Float:furrZ,
	furMaterial[5], // go from the list of materials
	furMaterialColour[5], // go from the list of materials
	bool:furActive, // -1 = inactive
	furObject,
	bool:furStatus,
}
new FurnitureInfo[MAX_HOUSES][MAX_FURNITURE_SLOTS][furInfo]; // each furniture slot!

enum f_Info
{
	fName[MAX_FACTION_NAME],
	fType,
	fGangZoneColour,
	fColour,
	bool:fTogColour,
	bool:fTogChat,
	fPoints,
	fMaxVehicles,
	fMaxMemberSlots,
	fStartpayment,
	fStartrank[MAX_FACTION_RANK],
	fLeader[MAX_PLAYER_NAME],
	fMOTD[MAX_FMOTD],
	fBank,
	fFreq,
	fStockLevel,
	fSDCWarehouse,
	fSDCCompsPrice,
	fNews1[75],
	fNews2[75],
	fNews3[75],
	fNews4[75],
	fNews5[75],
	fNews6[75],
	fNews7[75],
	fNews8[75],
	//no save!
	bool:fActive,
}
new FactionInfo[MAX_FACTIONS][f_Info];

enum hqInfo
{
	bool:hqOpen,
	bool:fHQStockTog,
	fHQStock,
	Float:fHQX, // (HQ) outside
	Float:fHQY,
	Float:fHQZ,
	Float:fHQA,
	fHQInt,
	fHQVW,
	Float:fSpawnX, // spawn for normal members
	Float:fSpawnY,
	Float:fSpawnZ,
	Float:fSpawnA,
	fSpawnInt,
	fSpawnVW,
	Float:flSpawnX,
	Float:flSpawnY,
	Float:flSpawnZ,
	Float:flSpawnA,
	flSpawnInt,
	flSpawnVW,
	Float:fHQRoofX,
	Float:fHQRoofY,
	Float:fHQRoofZ,
	Float:fHQRoofA,
	fHQRoofInt,
	fHQRoofVW,
	bool:hqActive, // checks if the HQ has been created!
	hqPickup,
	Text3D:hqLabel,
}
new HQInfo[MAX_FACTIONS][hqInfo];

enum whInfo
{
	Float:whX,
	Float:whY,
	Float:whZ,
	whInterior,
	whVirtualWorld,
	bool:whOpen,
	whLevel,
	whSecurity,
	whMaterials,
	whLead,
	whMetal,
	Text3D:whLabel,
	whTimer,
	bool:whActive,
}
new WareHouseInfo[MAX_FACTIONS][whInfo];

enum boomboxInfo
{
	boomURL[256],
	Float:boomX,
	Float:boomY,
	Float:boomZ,
	Float:boomA,
	boomInterior,
	boomVirtualWorld,
	boomArea,
	bool:boomActive,
	boomObject,
	Text3D:boomLabel,
}
new BoomBoxInfo[MAX_PLAYERS][boomboxInfo];

enum teleportInfo
{
	tpName[50],
	Float:tpX,
	Float:tpY,
	Float:tpZ,
	Float:tpA,
	tpInt, tpVW,
	Float:tpiX,
	Float:tpiY,
	Float:tpiZ,
	Float:tpiA,
	tpiInt, tpiVW,
	tpHouseID,
	tpHouseIID,
	bool:tpActive,
	Text3D:tpLabel,
}
new TeleportInfo[MAX_TELEPORTS][teleportInfo];

enum gateInfo
{
	gateName[50],
	gateModel,

	Float:gateX,
	Float:gateY,
	Float:gateZ,
	Float:gateRX,
	Float:gateRY,
	Float:gateRZ,

	Float:gateMX,
	Float:gateMY,
	Float:gateMZ,
	Float:gateMRX,
	Float:gateMRY,
	Float:gateMRZ,

	gateInterior, gateVirtualWorld,
	gateObject,
	gateHouse, gateBusiness, gateOwner[MAX_PLAYER_NAME], gateFaction, // ownership
	bool:gateActive,
}
new GateInfo[MAX_GATES][gateInfo];

enum // skin types
{
	INVALID_SKIN_ID,
	SKIN_RESERVED,
	SKIN_PEDESTRIAN,
}
enum // skin ethnicity
{
	SKIN_BLACK,
	SKIN_WHITE,
	SKIN_HISPANIC,
	SKIN_ASIAN,
}
enum // gender skins
{
	SKIN_FEMALE,
	SKIN_MALE,
}
enum skinInfo
{
	skinID,
	skinType,
	skinEthnic,
	skinGender,
}
new SkinInfo[][skinInfo] = {
	{0, INVALID_SKIN_ID, SKIN_BLACK, SKIN_MALE}, // carl johnson
	{1, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{2, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{3, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{4, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{5, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{6, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{7, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{8, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{9, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{10, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{11, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{12, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_FEMALE},
	{13, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{14, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{15, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{16, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{17, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{18, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{19, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{20, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{21, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{22, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{23, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{24, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{25, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{26, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{27, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{28, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{29, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{30, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{31, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{32, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{33, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{34, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{35, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{36, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{37, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{38, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{39, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{40, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_FEMALE},
	{41, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_FEMALE},
	{42, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{43, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{44, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{45, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{46, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{47, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{48, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{49, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{50, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{51, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{52, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{53, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{54, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_FEMALE},
	{55, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{56, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{57, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{58, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{59, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{60, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{61, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{62, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{63, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{64, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{65, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{66, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{67, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{68, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{69, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{70, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{71, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{72, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{73, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{74, INVALID_SKIN_ID, SKIN_WHITE, SKIN_MALE},
	{75, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{76, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{77, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{78, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{79, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{80, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{81, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{82, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{83, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{84, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{85, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{86, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{87, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{88, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{89, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{90, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{91, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_FEMALE},
	{92, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{93, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{94, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{95, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{96, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{97, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{98, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{99, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{100, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{101, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{102, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{103, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{104, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{105, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{106, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{107, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{108, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{109, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{110, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{111, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{112, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{113, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{114, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{115, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{116, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{117, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{118, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{119, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{120, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{121, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{122, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{123, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{124, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{125, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{126, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{127, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{128, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{129, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{130, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{131, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{132, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{133, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{134, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{135, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{136, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{137, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{138, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{139, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{140, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{141, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{142, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{143, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{144, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{145, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{146, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{147, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{148, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{149, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{150, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{151, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{152, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{153, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{154, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{155, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{156, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{157, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{158, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{159, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{160, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{161, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{162, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{163, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{164, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{165, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{166, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{167, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{168, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{169, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{170, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{171, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{172, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{173, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{174, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{175, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{176, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{177, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{178, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{179, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{180, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{181, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{182, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{183, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{184, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{185, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{186, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{187, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{188, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{189, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{190, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{191, SKIN_RESERVED, SKIN_WHITE, SKIN_FEMALE},
	{192, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{193, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{194, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{195, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{196, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{197, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{198, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{199, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{200, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{201, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{202, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{203, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{204, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{205, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{206, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{207, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_FEMALE},
	{208, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{209, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{210, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{211, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{212, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{213, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{214, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{215, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{216, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{217, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{218, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{219, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{220, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{221, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{222, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{223, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{224, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{225, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{226, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{227, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{228, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{229, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_MALE},
	{230, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{231, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{232, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{233, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{234, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{235, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{236, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{237, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{238, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{239, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{240, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{241, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{242, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{243, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{244, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{245, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{246, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{247, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{248, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{249, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{250, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{251, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{252, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{253, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{254, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{255, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{256, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_FEMALE},
	{257, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{258, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{259, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{260, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{261, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{262, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{263, SKIN_PEDESTRIAN, SKIN_ASIAN, SKIN_FEMALE},
	{264, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{265, SKIN_RESERVED, SKIN_BLACK, SKIN_MALE},
	{266, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{267, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{268, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{269, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{270, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{271, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{272, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{273, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{274, SKIN_RESERVED, SKIN_BLACK, SKIN_MALE},
	{275, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{276, SKIN_RESERVED, SKIN_ASIAN, SKIN_MALE},
	{277, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{278, SKIN_RESERVED, SKIN_BLACK, SKIN_MALE},
	{279, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{280, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{281, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{282, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{283, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{284, SKIN_RESERVED, SKIN_BLACK, SKIN_MALE},
	{285, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{286, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{287, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{288, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{289, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{290, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{291, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{292, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_MALE},
	{293, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{294, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{295, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{296, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{297, SKIN_PEDESTRIAN, SKIN_BLACK, SKIN_MALE},
	{298, SKIN_PEDESTRIAN, SKIN_HISPANIC, SKIN_FEMALE},
	{299, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	// need to find out the ethnicity of these!
	{300, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{301, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{302, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{303, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{304, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_MALE},
	{305, SKIN_PEDESTRIAN, SKIN_WHITE, SKIN_FEMALE},
	{306, SKIN_RESERVED, SKIN_WHITE, SKIN_FEMALE},
	{307, SKIN_RESERVED, SKIN_WHITE, SKIN_FEMALE},
	{308, SKIN_RESERVED, SKIN_WHITE, SKIN_FEMALE},
	{309, SKIN_RESERVED, SKIN_WHITE, SKIN_FEMALE},
	{310, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE},
	{311, SKIN_RESERVED, SKIN_WHITE, SKIN_MALE}
};

enum furObjects
{
	furID, // Model - 1703 / couch
	furName[85], // brief description
	furCategory, // category - FUR_CATE_LIVING_ROOM
	furCategoryEx[30], // category name!
	furSubCategory, // FUR_CATE_LIVING_ROOM - FUR_SUB_SEATING
	furSubCategoryEx[30], // sub-category name!
	furPrice,
}
new FurnitureObjects[][furObjects] =  {
	{2147, "Old Town Refrigerator", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_REFRIGERATORS, "Refrigerators", 3500},
	{2131, "Modern White Refrigerator", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_REFRIGERATORS, "Refrigerators", 5250},
	{2127, "Large Red Refrigerator", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_REFRIGERATORS, "Refrigerators", 8000},
	{2360, "Freezer Chest", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_REFRIGERATORS, "Refrigerators", 1500},
	{2361, "Rounded Freezer Chest", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_REFRIGERATORS, "Refrigerators", 1500},
	{2135, "Bronze Plated Stove", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_STOVES, "Stoves", 3200},
	{2144, "Old Town Stove", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_STOVES, "Stoves", 2000},
	{2339, "Modern White Stove", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_STOVES, "Stoves", 4000},
	{2294, "Large Red Stove", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_STOVES, "Stoves", 6150},
	{1235, "Small Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 150},
	{1300, "Top-covered Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 650},
	{1328, "Aluminium Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 50},
	{1330, "Bag Covered Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 100},
	{1359, "Metal Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 300},
	{1371, "Hippo Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 1300},
	{1347, "Street Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 120},
	{2613, "Small White Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 280},
	{2770, "Cluckin' Bell Wastebin", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_TRASHCANS, "Trash cans", 1300},
	{2149, "Microwave", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_SMALL, "Small Appliances", 750},
	{2421, "Wallmounted Microwave", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_SMALL, "Small Appliances", 2250},
	{2426, "Pizza Oven", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_SMALL, "Small Appliances", 1250},
	{1344, "Street Dumpster", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_DUMPSTERS, "Dumpsters", 5250},
	{1345, "Small Street Dumpster", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_DUMPSTERS, "Dumpsters", 2250},
	{1415, "Overfilled Dumpster", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_DUMPSTERS, "Dumpsters", 3000},
	{1439, "Regular Dumpster", CATEGORY_APPLIANCES, "Appliances", SUB_APPLIANCE_DUMPSTERS, "Dumpsters", 1500},
	/*********************************************************************************************************/
	{1700, "Pink Queen Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 12250},
	{1725, "Royal Brown Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 15000},
	{1745, "Wooden Stripe Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 9000},
	{1793, "Stack Of Mattresses", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 2250},
	{1794, "Brown Wooden Double Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 10000},
	{1795, "Beach Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 4700},
	{1796, "Brown Wooden Single Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 6750},
	{1797, "Stylish Footed Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 16300},
	{1799, "Brown Styled Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 18900},
	{1800, "Metal Prison Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 500},
	{1801, "Wooden Queen Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 7700},
	{1802, "Floral Queen Bed (no overhead)", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 12900},
	{1803, "Floral Queen Bed (overhead)", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 16500},
	{1812, "Skinny Single Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 500},
	{2299, "Brown Skinned Double bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 12300},
	{2300, "Shelved Double Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 34000},
	{2566, "White / Black Double Bed (inc. side)", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 40300},
	{11731, "Large Heart Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 75250},
	{14446, "Massive Zebra Bed", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_BEDS, "Beds", 80000},
	{1663, "Swivel Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 750},
	{1671, "Swivel Chair (inc. arm rest)", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 1000},
	{1714, "Large Back Swivel Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 2400},
	{1720, "Wooden Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 2000},
	{1721, "Metallic Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 800},
	{1739, "Large Back Dinning Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 2100},
	{1810, "Small Fold Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 150},
	{1811, "Small Back Dinning Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 1100},
	{2079, "Wooden Dinning Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 1400},
	{2096, "Wooden Rocking Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 600},
	{2120, "Dark Wooden Dinning Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 900},
	{2121, "Foldable Red Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 450},
	{2122, "Pure White Dinning Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 1650},
	{2123, "Fabric and Wooden Dinning Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 1350},
	{2124, "Light Wood / Large Back Dinning Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 2650},
	{2807, "Restaurant Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_CHAIRS, "Chairs", 750},
	{1702, "Brown Silk Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 3750},
	{1703, "Black Silk Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 3750},
	{1706, "Purple Cotton Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 2050},
	{1709, "Cornered Basic Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 1550},
	{1710, "Basic Couch 2x", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 1750},
	{1712, "Basic Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 1250},
	{1713, "Blue Business Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 5250},
	{2290, "Thick Silk Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 8100},
	{1756, "Indian Styled Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 2000},
	{1757, "Autumn Styled Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 2100},
	{1760, "Cold Autumn Styled Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 2050},
	{1761, "Basic Wooden Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 1200},
	{1763, "Basic Flower Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 900},
	{1764, "Basic Polyester Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 1000},
	{1768, "Basic Cotton Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 1000},
	{1726, "Black Business Couch", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_COUCHES, "Couches", 9500},
	{1705, "Brown Silk Arm Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_ARM_CHAIRS, "Arm chairs", 1000},
	{1704, "Black Silk Arm Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_ARM_CHAIRS, "Arm chairs", 1000},
	{1708, "Blue Business Arm Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_ARM_CHAIRS, "Arm chairs", 2800},
	{1711, "Basic Arm Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_ARM_CHAIRS, "Arm chairs", 800},
	{1727, "Black Business Arm Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_ARM_CHAIRS, "Arm chairs", 4500},
	{1735, "Basic Floran Arm Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_ARM_CHAIRS, "Arm chairs", 500},
	{1729, "Basic Arm Chair", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_ARM_CHAIRS, "Arm chairs", 400},
	{1716, "Metal Stool", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_STOOLS, "Stools", 650},
	{1805, "Small Red Cotton Stool", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_STOOLS, "Stools", 300},
	{1746, "Thick Silk Stool", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_STOOLS, "Stools", 1200},
	{2350, "Tall Red Cotton Stool", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_STOOLS, "Stools", 500},
	{2723, "Retro Metal Stool", CATEGORY_COMFORT, "Comfort", SUB_COMFORT_STOOLS, "Stools", 750},
	/*********************************************************************************************************/
	{2558, "Normal Green Curtains", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_CURTAINS, "Curtains", 200},
	{2561, "Wide Green Curtains", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_CURTAINS, "Curtains", 250},
	{2048, "Confederate Flag", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_FLAGS, "Flags", 500},
	{2614, "USA Flags", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_FLAGS, "Flags", 500},
	{11245, "USA Flag", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_FLAGS, "Flags", 750},
	{2914, "Green Flag", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_FLAGS, "Flags", 300},
	{1828, "Skinned Tiger Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 1500},
	{2815, "Purple Squared Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 400},
	{2817, "Bubble Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 550},
	{2818, "Red Squared Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 500},
	{2833, "Royal Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 800},
	{2834, "Plain Royal Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 750},
	{2835, "Plain Oval Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 600},
	{2836, "Plain Diamond Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 350},
	{2841, "Water Tiled Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 400},
	{2841, "Tiled Oval Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 400},
	{2842, "Rectangle Diamond Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 600},
	{2847, "Single Strip Rug", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_RUGS, "Rugs", 600},
	{3528, "Single Headed Dragon", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_STATUES, "Statues", 25000},
	{14467, "Big Smoke Statue", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_STATUES, "Statues", 42500},
	{3935, "Headless Armed Woman Statue", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_STATUES, "Statues", 7500},
	{14608, "Huge Buddha Statue", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_STATUES, "Statues", 75000},
	{3471, "Ancient Chinese Lion Statue", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_STATUES, "Statues", 10500},
	{2745, "Crying Man Statue", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_STATUES, "Statues", 15000},
	{1736, "Stag Head - Wall mount", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_STATUES, "Statues", 5000},
	{1640, "Green Striped Towel", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_TOWELS, "Towels", 15},
	{1641, "Blue Rockstar Towel", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_TOWELS, "Towels", 20},
	{1642, "White and Red Sprinkled Towel", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_TOWELS, "Towels", 15},
	{1643, "Yellow Penguin Towel", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_TOWELS, "Towels", 15},
	{11707, "Metal Towel Rack", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_TOWELS, "Towels", 25},
	{2254, "Taxi Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 35},
	{2255, "Ginny Suxx", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 45},
	{2256, "Palm Trees", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 40},
	{2257, "Abstract Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 75},
	{2258, "City Skyline Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 50},
	{2259, "Pixels Everywhere Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 25},
	{2260, "Floating Boat Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 35},
	{2261, "Bridge Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 55},
	{2264, "Beach Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 65},
	{2265, "Las Venturas Desert Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 60},
	{2267, "Ship Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 95},
	{2268, "Flffy Cat Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 25},
	{2269, "Loch Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 30},
	{2270, "Leaves Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 75},
	{2271, "Centre Abstract Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 70},
	{2273, "Bunch of Roses Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 50},
	{2275, "Fruit Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 35},
	{2276, "Bridge Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 20},
	{2277, "White Cat Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 15},
	{2278, "Naval Ship Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 60},
	{2279, "Mountain Side Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 85},
	{2284, "Taj Mahal Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 85},
	{2274, "Single Rose Masterpiece", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 1500},
	{19172, "Los Santos Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 2500},
	{19173, "San Fierro Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 2500},
	{19174, "Woods Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 2500},
	{19175, "LV - SF Skyline Painting", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PAINTINGS, "Paintings", 2500},
	{859, "Plant Top", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 5},
	{860, "Bushy Plant Top", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 8},
	{861, "Tall Plant Top", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{862, "Tall Orange Plant Top", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{863, "Cactus Top", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 8},
	{948, "Dry Plant Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 25},
	{638, "Planted Bush", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 8},
	{640, "Long Planted Bush", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 12},
	{949, "Normal Plant Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 15},
	{950, "Big Dry Plants Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 20},
	{2001, "High Plant Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{2010, "Bushy High Plant Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{2011, "High Plant Pot 2", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{2194, "Small Cactus", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 6},
	{2195, "Small Bushy Plant", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 12},
	{2203, "Empty Plant Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 5},
	{2240, "Dry Red Plant", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 25},
	{2241, "Rusty Plant Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{2242, "Empty Red Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 15},
	{2243, "Empty Red Pot 2", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 15},
	{2244, "Plants with Wooden Box", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 20},
	{2245, "Dished Plant", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 18},
	{2246, "Empty Plant Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 5},
	{2247, "Exotic Flowers In Glass Vase", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 20},
	{2248, "Empty Tall Red Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 25},
	{2249, "Exotic Flowers In Glass Vase 2", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 25},
	{2250, "Spring Flowers In Glass Vase", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 15},
	{2251, "Exotic Vase, with Flowers", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 30},
	{2252, "Small Flower Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{2253, "Cuboid Flower Pot", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{2345, "Wall Vines", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 5},
	{3802, "Hanging Red Flowers", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 12},
	{3806, "Wall Mounted Flowers", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{3810, "Hanging Flowers", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 12},
	{3811, "Wall Mounted Flowers With Dandelions", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 10},
	{15038, "Potted Shrub", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_PLANTS, "Plants", 15},
	{2049, "Shooting Target", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	{2050, "Shooting Targets", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	{2051, "Inverted Shooting Target", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	{2691, "Base 5 Poster", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	{2692, "Wheelchairster cutout Poster", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	{2693, "Nino Cutout Poster", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	{2695, "Thin Bare 5 Poster", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	{2696, "Thin Bare 5 Dog Poster", CATEGORY_DECORATIONS, "Decortaions", SUB_DECO_POSTERS, "Poster", 5},
	/*********************************************************************************************************/
	{1985, "Boxing Bag", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 750},
	{2627, "Treadmill", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 3500},
	{2628, "Multi GYM Bench", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 4000},
	{2629, "Bench Press Machine", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 3750},
	{2630, "Exercise Bike", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 6000},
	{2916, "One Dumbell", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 150},
	{2915, "Two Dumbells", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 300},
	{2964, "Blue Pool Table", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 7500},
	{2964, "Green Pool Table", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 7500},
	{3004, "Pool Cue", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 25},
	{2114, "Basketball", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 15},
	{3497, "Hanging Basketball Net", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPORTS, "Sporting Equiptment", 300},
	{2312, "Slim Grey Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 2000},
	{2316, "Small Black Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 1250},
	{2320, "Wooden Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 750},
	{2317, "Rusty Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 850},
	{2318, "Small Black Television 2", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 1000},
	{2322, "Metal and White Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 1500},
	{1518, "Small Black Television 3", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 1000},
	{1429, "Small Plain Wood Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 900},
	{1749, "Tiny Grey Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 500},
	{1786, "Large Wide Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 5000},
	{1752, "Medium Black Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 2750},
	{2700, "Straight Wall Mounted Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 1500},
	{2595, "Television On Top Of DVD", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 1750},
	{2596, "Wall mounted Television", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 1250},
	{2606, "4 Surveillance TV Screens", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_TV, "Televisions", 6250},
	{2028, "Xbox 420", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_GAMING, "Video Gaming", 420},
	{1515, "Poker Machine", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_GAMING, "Video Gaming", 9000},
	{2779, "Duality Aracade Machine", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_GAMING, "Video Gaming", 12500},
	{2778, "Bee be Gone Arcade Machine", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_GAMING, "Video Gaming", 12500},
	{2872, "Go Go Space Monkey Arcade Machine", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_GAMING, "Video Gaming", 12500},
	{1782, "White Media Player", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_MEDIA, "Media", 750},
	{1783, "Sunny Media Player", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_MEDIA, "Media", 800},
	{1785, "Sunny Media Player 2", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_MEDIA, "Media", 800},
	{1787, "3D Media Player", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_MEDIA, "Media", 2600},
	{1788, "Blue-Ray Player", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_MEDIA, "Media", 1500},
	{1790, "VHS Player", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_MEDIA, "Media", 150},
	{1839, "Stereo System", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 145},
	{2099, "Stereo System & Speakers", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 3000},
	{2225, "Stereo & Stand", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 2000},
	{2227, "Stereo & Tall Stand", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 2500},
	{2102, "Retro Boombox", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 750},
	{2103, "White Boombox", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 750},
	{2104, "Stereo System Stand", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 1200},
	{2226, "Boombox", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_STEREO, "Stereos", 1150},
	{2229, "Metal Plate Speaker", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPEAKERS, "Speakers", 2450},
	{2232, "Metal Plate Speaker Amplifier", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPEAKERS, "Speakers", 2450},
	{2230, "Wooden Speaker", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPEAKERS, "Speakers", 1450},
	{2231, "Wooden Speaker Amplifier", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPEAKERS, "Speakers", 1450},
	{2233, "Speaker on a thin leg", CATEGORY_ENTERTAINMENT, "Entertainment", SUB_ENTERTAIN_SPEAKERS, "Speakers", 1000},
	/*********************************************************************************************************/
	{2238, "Lava Lamp", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_LAMPS, "Lamps", 150},
	{2196, "Desk Lamp", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_LAMPS, "Lamps", 100},
	{2726, "Red Candle Lamp", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_LAMPS, "Lamps", 200},
	{3534, "Red Lamp", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_LAMPS, "Lamps", 150},
	{2707, "Spot Lamp", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_LAMPS, "Lamps", 50},
	{921, "Industrial Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_WALLMOUNTED, "Wallmounted Lighting", 150},
	{1731, "Fabric Walllamp", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_WALLMOUNTED, "Wallmounted Lighting", 100},
	{3785, "Bulkhead Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_WALLMOUNTED, "Wallmounted Lighting", 200},
	{19280, "Car Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_WALLMOUNTED, "Wallmounted Lighting", 50},
	{1734, "Glass Ceiling Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_CEILING, "Ceiling Lighting", 50},
	{1893, "Long Ceiling Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_CEILING, "Ceiling Lighting", 350},
	{2075, "Red Ceiling Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_CEILING, "Ceiling Lighting", 450},
	{2076, "Hanging Bowl Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_CEILING, "Ceiling Lighting", 300},
	{14527, "Wooden Ceiling Fan", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_CEILING, "Ceiling Lighting", 550},
	{2740, "Glass Cylinder Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_CEILING, "Ceiling Lighting", 100},
	{18647, "Red Neon Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_NEON, "Neon Lighting", 1500},
	{18648, "Blue Neon Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_NEON, "Neon Lighting", 1500},
	{18649, "Green Neon Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_NEON, "Neon Lighting", 1500},
	{18650, "Yellow Neon Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_NEON, "Neon Lighting", 1500},
	{18651, "Pinnk Neon Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_NEON, "Neon Lighting", 1500},
	{18652, "White Neon Light", CATEGORY_LIGHTING, "Lighting", SUB_LIGHTING_NEON, "Neon Lighting", 1500},
	/*********************************************************************************************************/
	{2514, "Plain Toilet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_TOILET, "Toilets", 200},
	{2521, "White Metal Toilet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_TOILET, "Toilets", 350},
	{2525, "Sauna Toilet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_TOILET, "Toilets", 650},
	{2528, "Black Wooden Toilet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_TOILET, "Toilets", 500},
	{2738, "Standard Toilet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_TOILET, "Toilets", 100},
	{2013, "Wooden & White Sink", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 650},
	{2130, "Red Sink Cabinet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 1200},
	{2132, "White Sink Cabinet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 1250},
	{2136, "Wodden Sink Cabinet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 650},
	{2336, "Old Town Sink Cabinet", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 950},
	{2150, "Metal Sink", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 150},
	{2518, "Basic Wall Sink", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 250},
	{2523, "Basic Sink With Rug", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 400},
	{2739, "Plain Bathroom Sink", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 200},
	{11709, "Large Kitchen Sink", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SINK, "Sinks", 450},
	{2517, "Glass Shower", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SHOWER, "Shower", 2450},
	{2520, "Dark Glass Shower", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SHOWER, "Shower", 1600},
	{2527, "Sauna Shower", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_SHOWER, "Shower", 3000},
	{2097, "Sprunk Bath", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_BATHS, "Baths", 700},
	{2516, "Plain White Bath", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_BATHS, "Baths", 1500},
	{2519, "White Bath", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_BATHS, "Baths", 1250},
	{2522, "Dark Wooden Bath", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_BATHS, "Baths", 2500},
	{2526, "Sauna Wooden Bath", CATEGORY_PLUMBING, "Plumbing", SUB_PLUMBING_BATHS, "Baths", 3500},
	/*********************************************************************************************************/
	{2332, "Closed Safe", CATEGORY_STORAGE, "Storage", SUB_STORAGE_SAFES, "Safes", 50000},
	{1742, "Half Empty Book Shelf", CATEGORY_STORAGE, "Storage", SUB_STORAGE_BOOKSHELVES, "Book Shelves", 2500},
	{14455, "Large Book Shelves", CATEGORY_STORAGE, "Storage", SUB_STORAGE_BOOKSHELVES, "Book Shelves", 4000},
	{2608, "Wooden Book Shelf", CATEGORY_STORAGE, "Storage", SUB_STORAGE_BOOKSHELVES, "Book Shelves", 2750},
	{2330, "Standard Tall Dresser", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 1250},
	{1740, "Light Wooden Dresser Bottom Opening", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 550},
	{1741, "Long Light Wooden Dresser", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 800},
	{1743, "Stylish Light Wooden Dresser", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 1100},
	{2087, "Light Wooden Dresser Bottom Opening Legs", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 1400},
	{2088, "Long Light Wooden Dresser Legs", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 1600},
	{2089, "Dark Wooden Dresser", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 2100},
	{2094, "Long Light Wooden Dresser Thin Legs", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 2500},
	{2204, "Large Dark Wooden Dresser", CATEGORY_STORAGE, "Storage", SUB_STORAGE_DRESSERS, "Dressers", 3500},
	{2000, "Metal Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 250},
	{2007, "Double Metal Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 500},
	{2065, "Green Metal Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 250},
	{2066, "Wooden Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 250},
	{2067, "Light Blue Metal Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 250},
	{2163, "Wall Mounted Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 2150},
	{2167, "Tall Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 3000},
	{2200, "Double Tall Filing Cabinet", CATEGORY_STORAGE, "Storage", SUB_STORAGE_CABINETS, "Cabinets", 6000},
	{2128, "Red Pantry", CATEGORY_STORAGE, "Storage", SUB_STORAGE_PANTRIES, "Pantries", 2200},
	{2140, "Brown Pantry", CATEGORY_STORAGE, "Storage", SUB_STORAGE_PANTRIES, "Pantries", 2200},
	{2141, "White Pantry", CATEGORY_STORAGE, "Storage", SUB_STORAGE_PANTRIES, "Pantries", 2200},
	{2145, "Old Town Pantry", CATEGORY_STORAGE, "Storage", SUB_STORAGE_PANTRIES, "Pantries", 2200},
	{2158, "Mahogany Green Wood Pantry", CATEGORY_STORAGE, "Storage", SUB_STORAGE_PANTRIES, "Pantries", 2500},
	{2153, "Snow White Pantry", CATEGORY_STORAGE, "Storage", SUB_STORAGE_PANTRIES, "Pantries", 3500},
	/*********************************************************************************************************/
	{1737, "Baisc Pine Wood Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 3000},
	{1770, "Paint Covered Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 1200},
	{2029, "Stylish Wood Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 3400},
	{2031, "Oak Wood Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 4000},
	{2080, "Mahogany Wood Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 2700},
	{2086, "Glass Oval Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 3250},
	{2110, "Basic Wood Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 1600},
	{2116, "Oak Wood Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 2650},
	{2118, "Marble Top Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 5650},
	{2357, "Long Wooden Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 4650},
	{15037, "Table With TV", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DINNING, "Dinning", 3150},
	{1813, "Basic White Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 1150},
	{1814, "Fancy Oak Coffee Table/Drawers", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 2300},
	{1815, "Oval Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 850},
	{1817, "Fancy Oak Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 3300},
	{1818, "Square Oak Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 2400},
	{1819, "Fancy Circle Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 1600},
	{1820, "Basic Circle Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 1350},
	{1822, "Mahogany Oval Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 1000},
	{1823, "Mahogany Square Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 900},
	{2236, "Ebony Wood Rectangle Coffee Table", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COFFEE_TABLES, "Coffee Tables", 1900},
	{2129, "Red Kitchen Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2304, "Red Kitchen Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 900},
	{2133, "White Kitchen Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2341, "White Kitchen Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 900},
	{2137, "Wood Cabinet Top Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2138, "Wood Top Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2139, "Wood Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2305, "Wood Corner Counter Top", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 900},
	{2152, "Snow White Cabinete Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2151, "Snow White Counter Top", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2155, "Snow White Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 900},
	{2156, "Mahogany Green Wood Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2159, "Mahogany Green Wood Cabinet Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2156, "Mahogany Green Wood Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2156, "Mahogany Green Wood Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1200},
	{2414, "Laguna Wooden Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2435, "November Wood Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2434, "November Wood Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2455, "Parlor Red Checkered Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2454, "Parlor Red Checkered Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2439, "Dark Marble Diamond Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2440, "Dark Marble Diamond Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2446, "Parlor Red Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2450, "Parlor Red Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2424, "Light Blue IceBox Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2423, "Light Blue IceBox Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2441, "Marble Zinc Top Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2442, "Marble Zinc Top Corner Counter", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2445, "Marble Zinc Top Counter (Regular)", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2444, "Marble Zinc Top Counter (Half Design)", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_COUNTERS, "Counters", 1400},
	{2078, "Fancy Dark Wooden Display Cabinet", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_CABINETS, "Display Cabinets", 2300},
	{2458, "Delicate Glass Wooden Display Cabinet", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_CABINETS, "Display Cabinets", 1400},
	{2459, "Long Delicate Glass Wooden Display Cabinet", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_CABINETS, "Display Cabinets", 1600},
	{2460, "Mini Delicate Glass Wooden Display Cabinet", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_CABINETS, "Display Cabinets", 2000},
	{2461, "Cubed Delicate Glass Wooden Display Cabinet", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_CABINETS, "Display Cabinets", 700},
	{2063, "Industrial Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 2400},
	{2462, "Wall Mounted Thin Wooden Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 900},
	{2463, "Wall Mounted Wooden Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 1800},
	{2403, "Very Large Wooden Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 6700},
	{2707, "Wooden & Glass Table Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 4500},
	{2368, "Wooden Counter Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 3000},
	{2457, "Parlor Red Checkered Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 2000},
	{2448, "Wide Parlor Red Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 2000},
	{2447, "Tall Parlor Red Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 1000},
	{2449, "Tall & Wide Parlor Red Display Shelf", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_DISPLAY_SHELVES, "Display Shelves", 3500},
	{2311, "Dark Mahogany TV Stand", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_TV_STANDS, "TV Stands", 1800},
	{2313, "Light Wooden TV Stand With VCR", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_TV_STANDS, "TV Stands", 2900},
	{2315, "Small Wooden TV Stand", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_TV_STANDS, "TV Stands", 1100},
	{2321, "Light Wooden Small TV Stand", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_TV_STANDS, "TV Stands", 1450},
	{2319, "Antique Oak TV Stand", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_TV_STANDS, "TV Stands", 800},
	{2346, "Small Two Level TV Stand", CATEGORY_SURFACES, "Surfaces", SUB_SURFACES_TV_STANDS, "TV Stands", 1000},
	/*********************************************************************************************************/
	{2374, "Blue Plaid Shirts Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 150},
	{2377, "Black Levi Jeans Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 300},
	{2378, "Black Levi Jeans Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 300},
	{2381, "Row of Sweat Pants", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 450},
	{2382, "Row of Levi Jeans", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 1450},
	{2383, "Yellow Shirts Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 150},
	{2384, "Stack of Khaki Pants", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 200},
	{2389, "Red And White Sports Jacket Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 380},
	{2390, "Green Sweat Pants Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 250},
	{2391, "Khaki Pants Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 200},
	{2392, "Row of Khakis & Levi Jeans", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 950},
	{2394, "Row of Shirts", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 750},
	{2396, "Black and Red Blazers Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 1650},
	{2397, "Grey Jeans Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 300},
	{2398, "Blue Sweat Pants Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 200},
	{2399, "Grey Sweatshirt Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 300},
	{2401, "Red Sweat Pants Rail", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CLOTHES, "Clothing", 200},
	{19820, "Scotch Whiskey Bottle", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CONSUMABLES, "Consumables", 150},
	{19822, "Red Wine Bottle", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CONSUMABLES, "Consumables", 100},
	{19823, "Scttish Flag Whiskey Bottle", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CONSUMABLES, "Consumables", 550},
	{19824, "White Wine Bottle", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_CONSUMABLES, "Consumables", 150},
	{1569, "Glass Door with Frame", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1557, "Glass Wired With Frame", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1501, "Wooden Screen Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1498, "Dirty White Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1495, "Wired Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1500, "Metal Screen Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1504, "Red Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1507, "Yellow Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1506, "White Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1505, "Blue Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{3061, "Gate Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{1496, "Love Door", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_DOORS, "Doors", 1000},
	{2857, "Pizza Takeaway Mess", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MESS, "Mess", 50},
	{2680, "Padlock", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 250},
	{1510, "Ashtray", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 50},
	{14774, "Electric Fly Killer", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 750},
	{2961, "Fire Alarm", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 150},
	{2962, "Fire Alarm (Button)", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 50},
	{19805, "Whiteboard", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 7500},
	{2896, "Casket", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 175000},
	{2404, "Rockstar Surfboard", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 15500},
	{2405, "Stripe Surfboard", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 3300},
	{2406, "Palm Surfboard", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 7000},
	{2410, "Plain Surfboard", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_MISC, "Miscellaneous", 1500},
	{3524, "Skull Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 6500},
	{2774, "White Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 2000},
	{3440, "Metal Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 1500},
	{3494, "Stone Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 3000},
	{3498, "Tall Wooden Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 4000},
	{3499, "Fat Tall Wooden Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 4500},
	{3533, "Red Dragon Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 6500},
	{19943, "Royal Stone Pillar", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_PILLARS, "Pillars", 14000},
	{1616, "Security Camera", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_SECURITY, "Security", 1500},
	{1622, "Security Camera", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_SECURITY, "Security", 1500},
	{1886, "High Security Camera", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_SECURITY, "Security", 4500},
	{1998, "L Desk with Phone & Computer", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 4500},
	{1999, "Standard Desk with Computer", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 3500},
	{2008, "Wooden Desk with Phone & Computer", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 5500},
	{2009, "L Desk with Computer", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 4000},
	{2165, "Wodden desk with computer and files", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 6500},
	{2166, "Wodden desk with files", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 6500},
	{2169, "Standard Wooden Desk", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 3000},
	{2171, "Small Standard Wooden Desk", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 1500},
	{2173, "Wooden Desk", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 2250},
	{2174, "Wooden Desk with cover & files", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 4000},
	{2180, "Beach Desk", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 1250},
	{2182, "L Desk with cover & files", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 3750},
	{2184, "Shape Defined Desk", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 6000},
	{2192, "Office Desk Fan", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_OFFICE, "Office", 100},
	{2469, "Toy Red Plane", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 100},
	{2471, "Three Train Toy Boxes", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 150},
	{2472, "Four Toy Red Planes", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 400},
	{2473, "Two Toy Red Planes", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 200},
	{2474, "Four Train Toys", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 400},
	{2477, "Three Hotwheels Stacked Boxes", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 300},
	{2480, "Four Hotwheels Stacked Boxes", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 400},
	{2481, "Hotwheels Box", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 150},
	{2483, "Train Model Box", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 150},
	{2484, "Rockstar Boat Model", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 250},
	{2485, "Wooden Car Toy", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 350},
	{2487, "Tropical Diamond Kite", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 350},
	{2488, "Manhunt Toy Box Sets", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 200},
	{2490, "Vice City Toy Box Sets", CATEGORY_MISCELLANEOUS, "Miscellaneous", SUB_MISC_TOYS, "Toys", 200}
};

enum materialInfo // materialColour = 0 for non coloured materials
{
	materialName[50],
	modelID,
	txdName[35],
	textureName[35],
	materialColour,
	materialCategory,
	materialCategoryEx[12],
}
new FurnitureMaterial[][materialInfo] = {
	{"White", -1, "none", "none", 0xFFFFFFFF, MATERIAL_CATEGORY_COLOURS, "Colours"},
	{"Black", -1, "none", "none", 0x000000FF, MATERIAL_CATEGORY_COLOURS, "Colours"},
	{"Red", -1, "none", "none", 0xD11919FF, MATERIAL_CATEGORY_COLOURS, "Colours"},
	{"Blue", -1, "none", "none", 0x0066FFFF, MATERIAL_CATEGORY_COLOURS, "Colours"},
	{"Green", -1, "none", "none", 0x009933FF, MATERIAL_CATEGORY_COLOURS, "Colours"},
	{"Orange", -1, "none", "none", 0xE68A00FF, MATERIAL_CATEGORY_COLOURS, "Colours"},
	{"Purple", -1, "none", "none", 0x9900CCFF, MATERIAL_CATEGORY_COLOURS, "Colours"},
	{"Hazardous", 16322, "a51_stores", "metpat64chev_128", 0, MATERIAL_CATEGORY_TEXTURE, "Textures"},
	{"Sand Stone wall", 5134, "wasteland_las2", "ws_sandstone2", 0, MATERIAL_CATEGORY_TEXTURE, "Texture,s"},
	{"Wood Floor", 13007, "sw_bankint", "woodfloor1", 0, MATERIAL_CATEGORY_TEXTURE, "Textures"},
	{"Tiled Floor", 16150, "ufo_bar", "dinerfloor01_128", 0, MATERIAL_CATEGORY_TEXTURE, "Textures"},
	{"Brick Wall", 18202, "w_towncs_t", "ahoodfence2", 0, MATERIAL_CATEGORY_TEXTURE, "Textures"},
	{"Mixed Brick Wall", 8390, "vegasemulticar", "ws_mixedbrick", 0, MATERIAL_CATEGORY_TEXTURE, "Textures"},
	{"Stone", 13691, "bevcunto2_lahills", "adeta", 0, MATERIAL_CATEGORY_TEXTURE, "Textures"}
};

/*enum playerToyList
{
	playerToyID,
	playerToyModel,
	playerToyPrice,
	playerToyName[MAX_PLAYER_TOY_NAME],
	playerToyCategory,
	playerToyCategoryEx[15],
	playerToySubCategory,
	playerToySubCategoryEx[15],
}
new PlayerToyList[][playerToyList] = {
	{0, 18929, 150, "Straight Outta Compton", PT_CATEGORY_HATS, "Hats", PT_SUBCATEGORY_HATS_BASEBALL, "Baseball Caps"}
};*/

enum biz_Lists
{
	biz_T,
	biz_N[50],
}
new BizTypeList[][biz_Lists] = {
	{BUSINESS_TYPE_BANK, "Bank"},
	{BUSINESS_TYPE_247, "Grocery Store"},
	{BUSINESS_TYPE_CASINO, "Casino"},
	{BUSINESS_TYPE_GAS, "Gas Station"},
	{BUSINESS_TYPE_HARDWARE, "Hardware Store"},
	{BUSINESS_TYPE_CLUB, "Night club"},
	{BUSINESS_TYPE_PUB, "Pub"},
	{BUSINESS_TYPE_STRIPCLUB, "Strip Club"},
	{BUSINESS_TYPE_GUNSTORE, "Gun Store"},
	{BUSINESS_TYPE_PIZZA, "Pizza Stack"},
	{BUSINESS_TYPE_BURGER, "Burger Shot"},
	{BUSINESS_TYPE_CHICKEN, "Cluckin' Bell"},
	{BUSINESS_TYPE_CAFE, "Cafe"},
	{BUSINESS_TYPE_CLOTHES, "Clothes Store"},
	{BUSINESS_TYPE_RESTAURANT, "Restaurant"},
	{BUSINESS_TYPE_PAYNSPRAY, "Pay 'N' Spray"},
	{BUSINESS_TYPE_DRUGFACTORY, "Drug Factory"},
	{BUSINESS_TYPE_GOV, "Government Tax Income"},
	{BUSINESS_TYPE_REFINARY, "Refinary Income"},
	{BUSINESS_TYPE_AIRPORT, "Airport"},
	{BUSINESS_TYPE_TAXI, "Taxi Station"},
	{BUSINESS_TYPE_RENT, "Vehicle Rent"},
	{BUSINESS_TYPE_DRIVER, "Driver Business"},
	{BUSINESS_TYPE_STADIUM, "Stadium Business"},
	{BUSINESS_TYPE_PAINTBALL, "Paintball"},
	{BUSINESS_TYPE_ADTOWER, "Advertisement Tower"},
	{BUSINESS_TYPE_PHONE, "Phone Provider"},
	{BUSINESS_TYPE_EXPORT, "Vehicle Exports"},
	{BUSINESS_TYPE_DRUGSTORE, "Drug Store"},
	{BUSINESS_TYPE_BIKE_DEALER, "Bike Dealership"},
	{BUSINESS_TYPE_HEAVY_DEALER, "Heavy Dealership"},
	{BUSINESS_TYPE_CAR_DEALER, "Car Dealership"},
	{BUSINESS_TYPE_LUXUS_DEALER, "Luxus Dealership"},
	{BUSINESS_TYPE_NOOB_DEALER, "Noobie Dealership"},
	{BUSINESS_TYPE_AIR_DEALER, "Air Dealership"},
	{BUSINESS_TYPE_BOAT_DEALER, "Boat Dealership"},
	{BUSINESS_TYPE_JOB_DEALER, "Job Dealership"},
	{BUSINESS_TYPE_WHEEL, "Wheel Mod Shop"},
	{BUSINESS_TYPE_TOYSTORE, "Toy Store"},
	{BUSINESS_TYPE_APPARTMENT, "Appartment Complex"},
	{BUSINESS_TYPE_HOTEL, "Hotel"},
	{BUSINESS_TYPE_VREGISTER, "Vehicle Register"}
};

enum rouletteHands_Enum
{
	RNumber,
	RCard[12],
}
new RouletteHands[][rouletteHands_Enum] = {
	{0, "Green"},
	{32, "Red"},
	{15, "Black"},
	{19, "Red"},
	{4, "Black"},
	{21, "Red"},
	{2, "Black"},
	{25, "Red"},
	{17, "Black"},
	{34, "Red"},
	{6, "Black"},
	{27, "Red"},
	{13, "Black"},
	{36, "Red"},
	{11, "Black"},
	{30, "Red"},
	{8, "Black"},
	{23, "Red"},
	{10, "Black"},
	{5, "Red"},
	{24, "Black"},
	{16, "Red"},
	{33, "Black"},
	{1, "Red"},
	{20, "Black"},
	{14, "Red"},
	{31, "Black"},
	{9, "Red"},
	{22, "Black"},
	{18, "Red"},
	{29, "Black"},
	{7, "Red"},
	{28, "Black"},
	{12, "Red"},
	{35, "Black"},
	{3, "Red"},
	{26, "Black"}
};
/*
enum
{
	GATE_CATE_SECURITY,
}

enum gObjects
{
	gModel,
	gName[35],
	gCate,
	gCateName[35],
}
new GateObjects[][gObjects] = {
	{975, "Default Security Gate (On Wheels)", GATE_CATE_SECURITY, "Security Gates"}
};*/
/* =============================================================================
		[Property System]
============================================================================= */

enum propinfo
{
	PropIsEnabled,
	PropExists,
	PropName[60],
	PropPrice,
	PropSell,
	PropEarning,
	Float:PropX,
	Float:PropY,
	Float:PropZ,
	PropOwner,
	PropIsBought
}
new PropInfo[MAX_PROPERTIES][propinfo];
