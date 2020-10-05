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
					")"
				],
				"parent": 4.0,
				"name": "IF ( CTC == HOLD )"
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
				"nextnode": 10.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 6.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "292 Stop",
				"parent": 7.0,
				"name": "292 Stop"
			},
			{
				"id_else": 12.0,
				"id_then": 11.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
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
				"parent": 8.0,
				"name": "IF ( OCCUPIED ) or ( SPEED == STOP/DANGER )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 13.0,
				"name": "THEN",
				"canattach": true,
				"parent": 10.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 22.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 10.0
			},
			{
				"id_else": 15.0,
				"id_then": 14.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"TAGS.grade",
					")"
				],
				"parent": 11.0,
				"name": "IF ( TAGS.grade )"
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
				"aspect": "290b Grade Signal",
				"parent": 14.0,
				"name": "290b Grade Signal"
			},
			{
				"id_else": 19.0,
				"id_then": 18.0,
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
				"parent": 15.0,
				"name": "IF ( TAGS.abs ) or ( TAGS.permissive )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 20.0,
				"name": "THEN",
				"canattach": true,
				"parent": 17.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 21.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 17.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "291 Stop And Proceed",
				"parent": 18.0,
				"name": "291 Stop And Proceed"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "292 Stop",
				"parent": 19.0,
				"name": "292 Stop"
			},
			{
				"id_else": 24.0,
				"id_then": 23.0,
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
				"parent": 12.0,
				"name": "IF ( SPEED == RESTRICTED ) or ( TAGS.restricted )"
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
				"nextnode": 26.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 22.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "290a Restricting",
				"parent": 23.0,
				"name": "290a Restricting"
			},
			{
				"id_else": 28.0,
				"id_then": 27.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
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
				"parent": 24.0,
				"name": "IF ( SPEED == SLOW ) or ( TAGS.slow )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 29.0,
				"name": "THEN",
				"canattach": true,
				"parent": 26.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 34.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 26.0
			},
			{
				"id_else": 31.0,
				"id_then": 30.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 27.0,
				"name": "IF ( NEXTSPEED < SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 32.0,
				"name": "THEN",
				"canattach": true,
				"parent": 29.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 33.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 29.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "289 Slow Approach",
				"parent": 30.0,
				"name": "289 Slow Approach"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "288 Slow Clear",
				"parent": 31.0,
				"name": "288 Slow Clear"
			},
			{
				"id_else": 36.0,
				"id_then": 35.0,
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
				"parent": 28.0,
				"name": "IF ( SPEED == MEDIUM ) or ( TAGS.medium )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 37.0,
				"name": "THEN",
				"canattach": true,
				"parent": 34.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 46.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 34.0
			},
			{
				"id_else": 39.0,
				"id_then": 38.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 35.0,
				"name": "IF ( NEXTSPEED < SLOW )"
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
				"aspect": "287 Medium Approach",
				"parent": 38.0,
				"name": "287 Medium Approach"
			},
			{
				"id_else": 43.0,
				"id_then": 42.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"SLOW",
					")"
				],
				"parent": 39.0,
				"name": "IF ( NEXTSPEED == SLOW )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 44.0,
				"name": "THEN",
				"canattach": true,
				"parent": 41.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 45.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 41.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "288 Slow Clear",
				"parent": 42.0,
				"name": "288 Slow Clear"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "286 Medium Clear",
				"parent": 43.0,
				"name": "286 Medium Clear"
			},
			{
				"id_else": 48.0,
				"id_then": 47.0,
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
				"parent": 36.0,
				"name": "IF ( SPEED == LIMITED ) or ( TAGS.limited )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 49.0,
				"name": "THEN",
				"canattach": true,
				"parent": 46.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 62.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 46.0
			},
			{
				"id_else": 51.0,
				"id_then": 50.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 47.0,
				"name": "IF ( NEXTSPEED < SLOW )"
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
				"aspect": "285 Limited Approach",
				"parent": 50.0,
				"name": "285 Limited Approach"
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
					"SLOW",
					")"
				],
				"parent": 51.0,
				"name": "IF ( NEXTSPEED == SLOW )"
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
				"aspect": "288 Slow Clear",
				"parent": 54.0,
				"name": "288 Slow Clear"
			},
			{
				"id_else": 59.0,
				"id_then": 58.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"MEDIUM",
					")"
				],
				"parent": 55.0,
				"name": "IF ( NEXTSPEED == MEDIUM )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 60.0,
				"name": "THEN",
				"canattach": true,
				"parent": 57.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 61.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 57.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "286 Medium Clear",
				"parent": 58.0,
				"name": "286 Medium Clear"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "284 Limited Clear",
				"parent": 59.0,
				"name": "284 Limited Clear"
			},
			{
				"id_else": 64.0,
				"id_then": 63.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"SLOW",
					")"
				],
				"parent": 48.0,
				"name": "IF ( NEXTSPEED < SLOW )"
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
				"aspect": "283 Approach",
				"parent": 63.0,
				"name": "283 Approach"
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
					"SLOW",
					")"
				],
				"parent": 64.0,
				"name": "IF ( NEXTSPEED == SLOW )"
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
				"aspect": "282 Approach Slow",
				"parent": 67.0,
				"name": "282 Approach Slow"
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
					"MEDIUM",
					")"
				],
				"parent": 68.0,
				"name": "IF ( NEXTSPEED == MEDIUM )"
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
				"aspect": "281 Approach Medium",
				"parent": 71.0,
				"name": "281 Approach Medium"
			},
			{
				"id_else": 76.0,
				"id_then": 75.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"==",
					"LIMITED",
					")"
				],
				"parent": 72.0,
				"name": "IF ( NEXTSPEED == LIMITED )"
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
				"aspect": "280 Approach Limited",
				"parent": 75.0,
				"name": "280 Approach Limited"
			},
			{
				"id_else": 80.0,
				"id_then": 79.0,
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
				"parent": 76.0,
				"name": "IF ( NEXTASPECT == \"283 Approach\" )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 81.0,
				"name": "THEN",
				"canattach": true,
				"parent": 78.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 82.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 78.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "279 Advance Approach",
				"parent": 79.0,
				"name": "279 Advance Approach"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "278 Clear",
				"parent": 80.0,
				"name": "278 Clear"
			}
		]
	},
	"sigtypes": {
		"cl_dwarf_l": {
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "3 3 3 3",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"bg3": "0",
				"cycle2": ""
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 7 7 7",
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
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"bg3": "0",
				"cycle2": ""
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 6 6 6",
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
				"bg1": "1 4 4 4",
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
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"bg3": "0",
				"cycle2": ""
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 5 5 5",
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
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"bg3": "0",
				"cycle2": ""
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6 6 6 6",
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
				"bg1": "4 4 4 4",
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
				"cycle2": "0.5",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "3",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"cycle2": "1",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
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
				"cycle2": "0",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "6"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"cycle2": "1",
				"bg3": "1"
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
				"bg3": "1",
				"cycle2": ""
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "3",
				"bg3": "1",
				"cycle2": ""
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": ""
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
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
				"bg3": "1",
				"cycle2": ""
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": ""
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": ""
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": ""
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
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
				"cycle2": "0.5",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "2",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"cycle2": "1",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
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
				"cycle2": "0",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "6"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"cycle2": "1",
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
				"bg3": "1",
				"cycle2": ""
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "3",
				"cycle2": ""
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": ""
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
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
				"bg3": "1",
				"cycle2": ""
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": ""
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": ""
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": ""
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
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
				"cycle2": "0.5",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "3"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"cycle2": "1",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
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
				"cycle2": "0",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "6"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"cycle2": "1",
				"bg3": "1"
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
				"bg3": "1",
				"cycle2": ""
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": ""
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
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
				"bg3": "1",
				"cycle2": ""
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": ""
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": ""
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": ""
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
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
				"bg3": "1",
				"cycle2": ""
			},
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "3",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"284 Limited Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "7",
				"bg3": "1",
				"cycle2": ""
			},
			"291 Stop And Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"278 Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
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
				"bg3": "1",
				"cycle2": ""
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "6",
				"cycle2": ""
			},
			"282 Approach Slow": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"289 Slow Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "4",
				"cycle2": ""
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "1",
				"cycle2": ""
			},
			"283 Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"287 Medium Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"bg3": "1",
				"cycle2": ""
			},
			"280 Approach Limited": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
			},
			"292 Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"279 Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "1",
				"cycle2": ""
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "5",
				"bg3": "1",
				"cycle2": ""
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
				"cycle2": "0.5",
				"bg3": "1"
			},
			"290a Restricting": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "3",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"284 Limited Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "7",
				"cycle2": "1",
				"bg3": "1"
			},
			"291 Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"278 Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
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
				"cycle2": "0",
				"bg3": "1"
			},
			"279 Advance Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "5",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"282 Approach Slow": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"289 Slow Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0.5",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "4"
			},
			"280 Approach Limited": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"283 Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"287 Medium Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "4",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"285 Limited Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "5",
				"cycle2": "0.5",
				"bg3": "1"
			},
			"292 Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "1"
			},
			"288 Slow Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "1",
				"skin3": "",
				"bg2": "1",
				"cycle2": "0",
				"bg3": "6"
			},
			"286 Medium Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "0",
				"skin3": "",
				"bg2": "6",
				"cycle2": "1",
				"bg3": "1"
			}
		},
		"cl_dwarf": {
			"290a Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2 2 2 2",
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
				"bg1": "1 7 7 7",
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
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"bg3": "0",
				"cycle2": ""
			},
			"286 Medium Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 6 6 6",
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
				"bg1": "1 4 4 4",
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
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"bg3": "0",
				"cycle2": ""
			},
			"285 Limited Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 5 5 5",
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
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"bg3": "0",
				"cycle2": ""
			},
			"288 Slow Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6 6 6 6",
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
				"bg1": "4 4 4 4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "0",
				"cycle2": "",
				"bg3": "0"
			}
		}
	},
	"tags": {
		"restricted": true,
		"slow": true,
		"grade": true,
		"limited": true,
		"abs": true,
		"medium": true,
		"permissive": true
	},
	"func_text": "function(OCCUPIED, DIVERGING, SPEED, NEXTASPECT, NEXTSPEED, TAGS, CTC)\n\tif ( ( CTC == 2 ) ) then\n\t\treturn \"290a Restricting\"\n\telse\n\t\tif ( ( CTC == 0 ) ) then\n\t\t\treturn \"292 Stop\"\n\t\telse\n\t\t\tif ( ( OCCUPIED ) ) or ( ( SPEED == 0 ) ) then\n\t\t\t\tif ( ( TAGS.grade ) ) then\n\t\t\t\t\treturn \"290b Grade Signal\"\n\t\t\t\telse\n\t\t\t\t\tif ( ( TAGS.abs ) ) or ( ( TAGS.permissive ) ) then\n\t\t\t\t\t\treturn \"291 Stop And Proceed\"\n\t\t\t\t\telse\n\t\t\t\t\t\treturn \"292 Stop\"\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\telse\n\t\t\t\tif ( ( SPEED == 1 ) ) or ( ( TAGS.restricted ) ) then\n\t\t\t\t\treturn \"290a Restricting\"\n\t\t\t\telse\n\t\t\t\t\tif ( ( SPEED == 2 ) ) or ( ( TAGS.slow ) ) then\n\t\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\t\treturn \"289 Slow Approach\"\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\treturn \"288 Slow Clear\"\n\t\t\t\t\t\tend\n\t\t\t\t\telse\n\t\t\t\t\t\tif ( ( SPEED == 3 ) ) or ( ( TAGS.medium ) ) then\n\t\t\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\t\t\treturn \"287 Medium Approach\"\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 2 ) ) then\n\t\t\t\t\t\t\t\t\treturn \"288 Slow Clear\"\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\treturn \"286 Medium Clear\"\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\tif ( ( SPEED == 4 ) ) or ( ( TAGS.limited ) ) then\n\t\t\t\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\t\t\t\treturn \"285 Limited Approach\"\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 2 ) ) then\n\t\t\t\t\t\t\t\t\t\treturn \"288 Slow Clear\"\n\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 3 ) ) then\n\t\t\t\t\t\t\t\t\t\t\treturn \"286 Medium Clear\"\n\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\treturn \"284 Limited Clear\"\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\tif ( ( NEXTSPEED < 2 ) ) then\n\t\t\t\t\t\t\t\t\treturn \"283 Approach\"\n\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 2 ) ) then\n\t\t\t\t\t\t\t\t\t\treturn \"282 Approach Slow\"\n\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 3 ) ) then\n\t\t\t\t\t\t\t\t\t\t\treturn \"281 Approach Medium\"\n\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\tif ( ( NEXTSPEED == 4 ) ) then\n\t\t\t\t\t\t\t\t\t\t\t\treturn \"280 Approach Limited\"\n\t\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\t\tif ( ( NEXTASPECT == \"283 Approach\" ) ) then\n\t\t\t\t\t\t\t\t\t\t\t\t\treturn \"279 Advance Approach\"\n\t\t\t\t\t\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\t\t\t\t\t\treturn \"278 Clear\"\n\t\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\t\tend\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\nend",
	"rules": [
		{
			"description": "Stop.",
			"speed": "STOP/DANGER",
			"name": "292 Stop",
			"color": "Red"
		},
		{
			"description": "Stop, then proceed at RESTRICTED speed prepared to stop within half sight distance to equipment, workers, misaligned switches, or broken rail.",
			"speed": "RESTRICTED",
			"name": "291 Stop And Proceed",
			"color": "Red"
		},
		{
			"description": "For high-tonnage freight trains: treat as Restricting (290a).\nFor all other trains: treat as Stop (292)",
			"speed": "RESTRICTED",
			"name": "290b Grade Signal",
			"color": "Red"
		},
		{
			"description": "Proceed at RESTRICTED speed prepared to stop within half sight distance to equipment, workers, misaligned switches, or broken rail.",
			"speed": "RESTRICTED",
			"name": "290a Restricting",
			"color": "Lunar White"
		},
		{
			"description": "Proceed at SLOW speed prepared to stop at next signal.",
			"speed": "SLOW",
			"name": "289 Slow Approach",
			"color": "Amber"
		},
		{
			"speed": "SLOW",
			"color": "Yellow-Green",
			"name": "288 Slow Clear",
			"description": "Proceed at SLOW speed until train is completely clear of interlocking or switches."
		},
		{
			"description": "Proceed at MEDIUM speed prepared to stop at next signal.",
			"speed": "MEDIUM",
			"name": "287 Medium Approach",
			"color": "Amber"
		},
		{
			"speed": "MEDIUM",
			"color": "Yellow-Green",
			"name": "286 Medium Clear",
			"description": "Proceed at MEDIUM speed until train is completely clear of interlocking or switches."
		},
		{
			"description": "Proceed at LIMITED speed prepared to stop at next signal.",
			"speed": "LIMITED",
			"name": "285 Limited Approach",
			"color": "Amber"
		},
		{
			"speed": "LIMITED",
			"color": "Yellow-Green",
			"name": "284 Limited Clear",
			"description": "Proceed at LIMITED speed until train is completely clear of interlocking or switches."
		},
		{
			"description": "Proceed prepared to stop at next signal.",
			"speed": "FULL",
			"name": "283 Approach",
			"color": "Amber"
		},
		{
			"speed": "FULL",
			"color": "Yellow-Green",
			"name": "282 Approach Slow",
			"description": "Proceed prepared to pass next signal at SLOW speed."
		},
		{
			"speed": "FULL",
			"color": "Yellow-Green",
			"name": "281 Approach Medium",
			"description": "Proceed prepared to pass next signal at MEDIUM speed."
		},
		{
			"speed": "FULL",
			"color": "Yellow-Green",
			"name": "280 Approach Limited",
			"description": "Proceed prepared to pass next signal at LIMITED speed."
		},
		{
			"description": "Next signal is Approach (283). Proceed.",
			"speed": "FULL",
			"name": "279 Advance Approach",
			"color": "Green"
		},
		{
			"description": "Proceed.",
			"speed": "FULL",
			"name": "278 Clear",
			"color": "Green"
		}
	],
	"sysname": "snagroar"
}