{
	"panels": {
		"nodes": [
			{
				"icon": "icon16/bullet_go.png",
				"nextnode": 2.0,
				"name": "START",
				"canattach": true,
				"parent": 1.0
			},
			{
				"id_else": 4.0,
				"id_then": 3.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"CTC",
					"==",
					"FORCE",
					")"
				],
				"parent": 1.0,
				"name": "IF ( CTC == FORCE )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 5.0,
				"name": "THEN",
				"canattach": true,
				"parent": 2.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 6.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 2.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "290a Restricting",
				"parent": 3.0,
				"name": "290a Restricting"
			},
			{
				"id_else": 8.0,
				"id_then": 7.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"CTC",
					"==",
					"HOLD",
					")",
					"or",
					"(",
					"OCCUPIED",
					")",
					"or",
					"(",
					"SPEED",
					"==",
					"STOP/DANGER",
					")"
				],
				"parent": 4.0,
				"name": "IF ( CTC == HOLD ) or ( OCCUPIED ) or ( SPEED == STOP/DANGER )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 9.0,
				"name": "THEN",
				"canattach": true,
				"parent": 6.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 18.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 6.0
			},
			{
				"id_else": 11.0,
				"id_then": 10.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"TAGS.grade",
					")"
				],
				"parent": 7.0,
				"name": "IF ( TAGS.grade )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 12.0,
				"name": "THEN",
				"canattach": true,
				"parent": 9.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 13.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 9.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "290b Grade Signal",
				"parent": 10.0,
				"name": "290b Grade Signal"
			},
			{
				"id_else": 15.0,
				"id_then": 14.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"TAGS.abs",
					")",
					"or",
					"(",
					"TAGS.permissive",
					")"
				],
				"parent": 11.0,
				"name": "IF ( TAGS.abs ) or ( TAGS.permissive )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 16.0,
				"name": "THEN",
				"canattach": true,
				"parent": 13.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 17.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 13.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "291 Stop And Proceed",
				"parent": 14.0,
				"name": "291 Stop And Proceed"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "292 Stop",
				"parent": 15.0,
				"name": "292 Stop"
			},
			{
				"id_else": 20.0,
				"id_then": 19.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"SPEED",
					"==",
					"RESTRICTED",
					")",
					"or",
					"(",
					"TAGS.restricted",
					")"
				],
				"parent": 8.0,
				"name": "IF ( SPEED == RESTRICTED ) or ( TAGS.restricted )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 21.0,
				"name": "THEN",
				"canattach": true,
				"parent": 18.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 22.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 18.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "290a Restricting",
				"parent": 19.0,
				"name": "290a Restricting"
			},
			{
				"icon": "icon16/lightning.png",
				"conditions": [
					"(",
					"SPEED",
					"==",
					"SLOW",
					")",
					"or",
					"(",
					"TAGS.slow",
					")"
				],
				"id_else": 24.0,
				"condition": [],
				"isconditional": true,
				"name": "IF ( SPEED == SLOW ) or ( TAGS.slow )",
				"id_then": 23.0,
				"parent": 20.0
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 25.0,
				"name": "THEN",
				"canattach": true,
				"parent": 22.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 30.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 22.0
			},
			{
				"id_else": 27.0,
				"id_then": 26.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 23.0,
				"name": "IF ( NEXTSPEED < SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 28.0,
				"name": "THEN",
				"canattach": true,
				"parent": 25.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 29.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 25.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "289 Slow Approach",
				"parent": 26.0,
				"name": "289 Slow Approach"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "288 Slow Clear",
				"parent": 27.0,
				"name": "288 Slow Clear"
			},
			{
				"id_else": 32.0,
				"id_then": 31.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"SPEED",
					"==",
					"MEDIUM",
					")",
					"or",
					"(",
					"TAGS.medium",
					")"
				],
				"parent": 24.0,
				"name": "IF ( SPEED == MEDIUM ) or ( TAGS.medium )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 33.0,
				"name": "THEN",
				"canattach": true,
				"parent": 30.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 42.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 30.0
			},
			{
				"id_else": 35.0,
				"id_then": 34.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 31.0,
				"name": "IF ( NEXTSPEED < SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 36.0,
				"name": "THEN",
				"canattach": true,
				"parent": 33.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 37.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 33.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "287 Medium Approach",
				"parent": 34.0,
				"name": "287 Medium Approach"
			},
			{
				"id_else": 39.0,
				"id_then": 38.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"SLOW",
					")"
				],
				"parent": 35.0,
				"name": "IF ( NEXTSPEED == SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 40.0,
				"name": "THEN",
				"canattach": true,
				"parent": 37.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 41.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 37.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "288 Slow Clear",
				"parent": 38.0,
				"name": "288 Slow Clear"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "286 Medium Clear",
				"parent": 39.0,
				"name": "286 Medium Clear"
			},
			{
				"id_else": 44.0,
				"id_then": 43.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"SPEED",
					"==",
					"LIMITED",
					")",
					"or",
					"(",
					"TAGS.limited",
					")"
				],
				"parent": 32.0,
				"name": "IF ( SPEED == LIMITED ) or ( TAGS.limited )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 45.0,
				"name": "THEN",
				"canattach": true,
				"parent": 42.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 58.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 42.0
			},
			{
				"id_else": 47.0,
				"id_then": 46.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 43.0,
				"name": "IF ( NEXTSPEED < SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 48.0,
				"name": "THEN",
				"canattach": true,
				"parent": 45.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 49.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 45.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "285 Limited Approach",
				"parent": 46.0,
				"name": "285 Limited Approach"
			},
			{
				"id_else": 51.0,
				"id_then": 50.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"SLOW",
					")"
				],
				"parent": 47.0,
				"name": "IF ( NEXTSPEED == SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 52.0,
				"name": "THEN",
				"canattach": true,
				"parent": 49.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 53.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 49.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "288 Slow Clear",
				"parent": 50.0,
				"name": "288 Slow Clear"
			},
			{
				"id_else": 55.0,
				"id_then": 54.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"MEDIUM",
					")"
				],
				"parent": 51.0,
				"name": "IF ( NEXTSPEED == MEDIUM )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 56.0,
				"name": "THEN",
				"canattach": true,
				"parent": 53.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 57.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 53.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "286 Medium Clear",
				"parent": 54.0,
				"name": "286 Medium Clear"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "284 Limited Clear",
				"parent": 55.0,
				"name": "284 Limited Clear"
			},
			{
				"id_else": 60.0,
				"id_then": 59.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 44.0,
				"name": "IF ( NEXTSPEED < SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 61.0,
				"name": "THEN",
				"canattach": true,
				"parent": 58.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 62.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 58.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "283 Approach",
				"parent": 59.0,
				"name": "283 Approach"
			},
			{
				"id_else": 64.0,
				"id_then": 63.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"SLOW",
					")"
				],
				"parent": 60.0,
				"name": "IF ( NEXTSPEED == SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 65.0,
				"name": "THEN",
				"canattach": true,
				"parent": 62.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 66.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 62.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "282 Approach Slow",
				"parent": 63.0,
				"name": "282 Approach Slow"
			},
			{
				"id_else": 68.0,
				"id_then": 67.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"MEDIUM",
					")"
				],
				"parent": 64.0,
				"name": "IF ( NEXTSPEED == MEDIUM )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 69.0,
				"name": "THEN",
				"canattach": true,
				"parent": 66.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 70.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 66.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "281 Approach Medium",
				"parent": 67.0,
				"name": "281 Approach Medium"
			},
			{
				"id_else": 72.0,
				"id_then": 71.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"LIMITED",
					")"
				],
				"parent": 68.0,
				"name": "IF ( NEXTSPEED == LIMITED )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 73.0,
				"name": "THEN",
				"canattach": true,
				"parent": 70.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 74.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 70.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "280 Approach Limited",
				"parent": 71.0,
				"name": "280 Approach Limited"
			},
			{
				"id_else": 76.0,
				"id_then": 75.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTASPECT",
					"==",
					"\"283",
					"Approach\"",
					")"
				],
				"parent": 72.0,
				"name": "IF ( NEXTASPECT == \"283 Approach\" )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 77.0,
				"name": "THEN",
				"canattach": true,
				"parent": 74.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 78.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 74.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "279 Advance Approach",
				"parent": 75.0,
				"name": "279 Advance Approach"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "278 Clear",
				"parent": 76.0,
				"name": "278 Clear"
			}
		]
	},
	"sigtypes": {
		"cl_dwarf_l": {
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "3",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "10",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"test": true,
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "8",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"290b Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "11",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "9",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			}
		},
		"uq_high_l1": {
			"281 Approach Medium": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"290a Restricting": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "3",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": "0"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			}
		},
		"cl_high_l2": {
			"281 Approach Medium": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "3",
				"cycle2": "",
				"bg3": "1"
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"cycle2": "",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "6"
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			}
		},
		"uq_high": {
			"281 Approach Medium": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"290a Restricting": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "2",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": "0"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			}
		},
		"cl_dwarf": {
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "10",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"test": true,
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "8",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"290b Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "11",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "9",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			}
		},
		"uq_high_l3": {
			"281 Approach Medium": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"290a Restricting": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "3",
				"cycle2": "0"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": "0"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			}
		},
		"cl_high": {
			"281 Approach Medium": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"cycle2": "",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "6"
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			}
		},
		"uq_high_l2": {
			"281 Approach Medium": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"290a Restricting": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "3",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": "0"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": "0"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": "0"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": "0.5"
			}
		},
		"cl_high_l1": {
			"281 Approach Medium": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "3",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"cycle2": "",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "6"
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			}
		},
		"cl_high_l3": {
			"281 Approach Medium": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "3"
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"cycle2": "",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"test": true,
			"290b Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "4"
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"cycle2": "",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "6"
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"cycle2": "",
				"bg3": "1"
			}
		}
	},
	"tags": {
		"restricted": true,
		"permissive": true,
		"grade": true,
		"slow": true,
		"abs": true,
		"medium": true,
		"limited": true
	},
	"func_text": "function(OCCUPIED, DIVERGING, SPEED, NEXTASPECT, NEXTSPEED, TAGS, CTC)\n\tif ( ( CTC == 2 ) ) then\n\t\treturn \"290a Restricting\"\n\telse\n\t\tif ( ( CTC == 0 ) ) or ( ( OCCUPIED ) ) or ( ( SPEED == 0 ) ) then\n\t\t\tif ( ( TAGS.grade ) ) then\n\t\t\t\treturn \"290b Grade Signal\"\n\t\t\telse\n\t\t\t\tif ( ( TAGS.abs ) ) or ( ( TAGS.permissive ) ) then\n\t\t\t\t\treturn \"291 Stop And Proceed\"\n\t\t\t\telse\n\t\t\t\t\treturn \"292 Stop\"\n\t\t\t\tend\n\t\t\tend\n\t\telse\n\t\t\tif ( ( SPEED == 1 ) ) or ( ( TAGS.restricted ) ) then\n\t\t\t\treturn \"290a Restricting\"\n\t\t\telse\n\t\t\t\tif ( ( SPEED == 2 ) ) or ( ( TAGS.slow ) ) then\n\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\treturn \"289 Slow Approach\"\n\t\t\t\t\telse\n\t\t\t\t\t\treturn \"288 Slow Clear\"\n\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\tif ( ( SPEED == 3 ) ) or ( ( TAGS.medium ) ) then\n\t\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\t\treturn \"287 Medium Approach\"\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\tif ( ( NEXTSPEED == 2 ) ) then\n\t\t\t\t\t\t\t\treturn \"288 Slow Clear\"\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\treturn \"286 Medium Clear\"\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\telse\n\t\t\t\t\t\tif ( ( SPEED == 4 ) ) or ( ( TAGS.limited ) ) then\n\t\t\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\t\t\treturn \"285 Limited Approach\"\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 2 ) ) then\n\t\t\t\t\t\t\t\t\treturn \"288 Slow Clear\"\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 3 ) ) then\n\t\t\t\t\t\t\t\t\t\treturn \"286 Medium Clear\"\n\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\treturn \"284 Limited Clear\"\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\t\t\treturn \"283 Approach\"\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 2 ) ) then\n\t\t\t\t\t\t\t\t\treturn \"282 Approach Slow\"\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 3 ) ) then\n\t\t\t\t\t\t\t\t\t\treturn \"281 Approach Medium\"\n\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 4 ) ) then\n\t\t\t\t\t\t\t\t\t\t\treturn \"280 Approach Limited\"\n\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\tif ( ( NEXTASPECT == \"283 Approach\" ) ) then\n\t\t\t\t\t\t\t\t\t\t\t\treturn \"279 Advance Approach\"\n\t\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\t\treturn \"278 Clear\"\n\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\nend",
	"rules": [
		{
			"speed": "STOP/DANGER",
			"color": "Red",
			"name": "292 Stop",
			"description": "Stop."
		},
		{
			"speed": "RESTRICTED",
			"color": "Red",
			"name": "291 Stop And Proceed",
			"description": "Stop, then proceed at RESTRICTED speed prepared to stop within half sight distance to equipment, workers, misaligned switches, or broken rail."
		},
		{
			"speed": "RESTRICTED",
			"color": "Red",
			"name": "290b Grade Signal",
			"description": "For high-tonnage freight trains: treat as Restricting (290a).\nFor all other trains: treat as Stop (292)"
		},
		{
			"speed": "RESTRICTED",
			"color": "Lunar White",
			"name": "290a Restricting",
			"description": "Proceed at RESTRICTED speed prepared to stop within half sight distance to equipment, workers, misaligned switches, or broken rail."
		},
		{
			"speed": "SLOW",
			"color": "Amber",
			"name": "289 Slow Approach",
			"description": "Proceed at SLOW speed prepared to stop at next signal."
		},
		{
			"color": "Yellow-Green",
			"description": "Proceed at SLOW speed until train is completely clear of interlocking or switches.",
			"name": "288 Slow Clear",
			"speed": "SLOW"
		},
		{
			"speed": "MEDIUM",
			"color": "Amber",
			"name": "287 Medium Approach",
			"description": "Proceed at MEDIUM speed prepared to stop at next signal."
		},
		{
			"color": "Yellow-Green",
			"description": "Proceed at MEDIUM speed until train is completely clear of interlocking or switches.",
			"name": "286 Medium Clear",
			"speed": "MEDIUM"
		},
		{
			"speed": "LIMITED",
			"color": "Amber",
			"name": "285 Limited Approach",
			"description": "Proceed at LIMITED speed prepared to stop at next signal."
		},
		{
			"color": "Yellow-Green",
			"description": "Proceed at LIMITED speed until train is completely clear of interlocking or switches.",
			"name": "284 Limited Clear",
			"speed": "LIMITED"
		},
		{
			"speed": "FULL",
			"color": "Amber",
			"name": "283 Approach",
			"description": "Proceed prepared to stop at next signal."
		},
		{
			"color": "Yellow-Green",
			"description": "Proceed prepared to pass next signal at SLOW speed.",
			"name": "282 Approach Slow",
			"speed": "FULL"
		},
		{
			"color": "Yellow-Green",
			"description": "Proceed prepared to pass next signal at MEDIUM speed.",
			"name": "281 Approach Medium",
			"speed": "FULL"
		},
		{
			"color": "Yellow-Green",
			"description": "Proceed prepared to pass next signal at LIMITED speed.",
			"name": "280 Approach Limited",
			"speed": "FULL"
		},
		{
			"speed": "FULL",
			"color": "Green",
			"name": "279 Advance Approach",
			"description": "Next signal is Approach (283). Proceed."
		},
		{
			"speed": "FULL",
			"color": "Green",
			"name": "278 Clear",
			"description": "Proceed."
		}
	],
	"sysname": "snagroar"
}