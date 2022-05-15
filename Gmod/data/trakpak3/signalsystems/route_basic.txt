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
				"aspect": "Restricting",
				"parent": 3.0,
				"name": "Restricting"
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
				"aspect": "Grade Signal",
				"parent": 10.0,
				"name": "Grade Signal"
			},
			{
				"id_else": 15.0,
				"id_then": 14.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"TAGS.abs",
					")"
				],
				"parent": 11.0,
				"name": "IF ( TAGS.abs )"
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
				"aspect": "Stop and Proceed",
				"parent": 14.0,
				"name": "Stop and Proceed"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Stop",
				"parent": 15.0,
				"name": "Stop"
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
					")"
				],
				"parent": 8.0,
				"name": "IF ( SPEED == RESTRICTED )"
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
				"aspect": "Restricting",
				"parent": 19.0,
				"name": "Restricting"
			},
			{
				"id_else": 24.0,
				"id_then": 23.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<=",
					"RESTRICTED",
					")"
				],
				"parent": 20.0,
				"name": "IF ( NEXTSPEED <= RESTRICTED )"
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
					"DIVERGING",
					")"
				],
				"parent": 23.0,
				"name": "IF ( DIVERGING )"
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
				"aspect": "Diverging Approach",
				"parent": 26.0,
				"name": "Diverging Approach"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Approach",
				"parent": 27.0,
				"name": "Approach"
			},
			{
				"id_else": 32.0,
				"id_then": 31.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"DIVERGING",
					")"
				],
				"parent": 24.0,
				"name": "IF ( DIVERGING )"
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
				"nextnode": 34.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 30.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Diverging Clear",
				"parent": 31.0,
				"name": "Diverging Clear"
			},
			{
				"id_else": 36.0,
				"id_then": 35.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTDIV",
					")"
				],
				"parent": 32.0,
				"name": "IF ( NEXTDIV )"
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
				"nextnode": 38.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 34.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Approach Diverging",
				"parent": 35.0,
				"name": "Approach Diverging"
			},
			{
				"id_else": 40.0,
				"id_then": 39.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTASPECT",
					"==",
					"\"Approach\"",
					")"
				],
				"parent": 36.0,
				"name": "IF ( NEXTASPECT == \"Approach\" )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 41.0,
				"name": "THEN",
				"canattach": true,
				"parent": 38.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 42.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 38.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Advance Approach",
				"parent": 39.0,
				"name": "Advance Approach"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Clear",
				"parent": 40.0,
				"name": "Clear"
			},
			{
				"name": "Approach Diverging",
				"parent": 41.0,
				"icon": "icon16/book_open.png",
				"aspect": "Approach Diverging"
			},
			{
				"name": "IF ( NEXTASPECT == \"Approach\" )",
				"icon": "icon16/lightning.png",
				"parent": 42.0,
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTASPECT",
					"==",
					"\"Approach\"",
					")"
				],
				"id_else": 46.0,
				"id_then": 45.0
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 47.0,
				"parent": 44.0,
				"canattach": true,
				"name": "THEN"
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 48.0,
				"parent": 44.0,
				"canattach": true,
				"name": "ELSE"
			},
			{
				"name": "Advance Approach",
				"parent": 45.0,
				"icon": "icon16/book_open.png",
				"aspect": "Advance Approach"
			},
			{
				"name": "Clear",
				"parent": 46.0,
				"icon": "icon16/book_open.png",
				"aspect": "Clear"
			},
			{
				"name": "Approach Diverging",
				"parent": 47.0,
				"icon": "icon16/book_open.png",
				"aspect": "Approach Diverging"
			},
			{
				"name": "IF ( NEXTASPECT == \"Approach\" )",
				"icon": "icon16/lightning.png",
				"parent": 48.0,
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTASPECT",
					"==",
					"\"Approach\"",
					")"
				],
				"id_else": 52.0,
				"id_then": 51.0
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 53.0,
				"parent": 50.0,
				"canattach": true,
				"name": "THEN"
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 54.0,
				"parent": 50.0,
				"canattach": true,
				"name": "ELSE"
			},
			{
				"name": "Advance Approach",
				"parent": 51.0,
				"icon": "icon16/book_open.png",
				"aspect": "Advance Approach"
			},
			{
				"name": "Clear",
				"parent": 52.0,
				"icon": "icon16/book_open.png",
				"aspect": "Clear"
			}
		]
	},
	"sigtypes": {
		"sl_dwarf_2x": {
			"Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Stop and Proceed (Forced)": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "",
				"override": "Clear",
				"cycle2": ""
			},
			"test": true,
			"Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "",
				"override": "Stop and Proceed (Forced)",
				"cycle2": ""
			},
			"Stop and Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Diverging Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Diverging Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6 4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			}
		},
		"cl_high_l3": {
			"Approach": {
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
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"Advance Approach": {
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
			"test": true,
			"Stop": {
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
			"Stop and Proceed": {
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
			"Grade Signal": {
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
			"Stop and Proceed (Forced)": {
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
			"Diverging Approach": {
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
			"Diverging Clear": {
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
			"Restricting": {
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
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			}
		},
		"sl_dwarf_1x": {
			"Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			},
			"Stop and Proceed (Forced)": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "",
				"override": "Clear",
				"cycle2": ""
			},
			"test": true,
			"Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Stop and Proceed (Forced)",
				"bg3": ""
			},
			"Stop and Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Diverging Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "",
				"override": "Approach",
				"cycle2": ""
			},
			"Diverging Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "",
				"override": "Clear",
				"cycle2": ""
			},
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "",
				"override": "Clear",
				"cycle2": ""
			},
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"bg3": "",
				"cycle2": ""
			}
		},
		"cl_high_l2": {
			"Approach": {
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
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"Advance Approach": {
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
			"test": true,
			"Stop": {
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
			"Stop and Proceed": {
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
			"Grade Signal": {
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
			"Stop and Proceed (Forced)": {
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
			"Diverging Approach": {
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
			"Diverging Clear": {
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
			"Restricting": {
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
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			}
		},
		"uq_high": {
			"Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Stop and Proceed (Forced)": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Advance Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "1",
				"override": "Clear",
				"cycle2": "0"
			},
			"test": true,
			"Restricting": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "4",
				"override": "Stop and Proceed (Forced)",
				"cycle2": "0.5"
			},
			"Stop and Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Grade Signal": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Diverging Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "4",
				"bg3": "",
				"cycle2": "0.5"
			},
			"Diverging Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "",
				"cycle2": "1"
			},
			"Approach Diverging": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "",
				"cycle2": "1"
			},
			"Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			}
		},
		"cl_dwarf": {
			"Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4 4 4 4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Stop and Proceed (Forced)": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2 2 2 2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Clear",
				"bg3": ""
			},
			"test": true,
			"Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Stop and Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "3 3 3 3",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Stop and Proceed (Forced)",
				"bg3": ""
			},
			"Diverging Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Approach",
				"bg3": ""
			},
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Clear",
				"bg3": ""
			},
			"Diverging Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Clear",
				"bg3": ""
			},
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6 6 6 6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			}
		},
		"cl_high": {
			"Approach": {
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
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"Advance Approach": {
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
			"test": true,
			"Stop": {
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
			"Stop and Proceed": {
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
			"Grade Signal": {
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
			"Stop and Proceed (Forced)": {
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
			"Diverging Approach": {
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
			"Diverging Clear": {
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
			"Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "0",
				"bg2": "0",
				"override": "Stop and Proceed (Forced)",
				"cycle2": ""
			},
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			}
		},
		"uq_high_l": {
			"Approach": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Stop and Proceed (Forced)": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Advance Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "1",
				"override": "Clear",
				"cycle2": "0"
			},
			"test": true,
			"Restricting": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "3",
				"bg3": "",
				"cycle2": "0.5"
			},
			"Stop and Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Grade Signal": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			},
			"Diverging Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg3": "",
				"bg2": "1",
				"override": "Restricting",
				"cycle2": "0"
			},
			"Diverging Clear": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "1",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "",
				"cycle2": "1"
			},
			"Approach Diverging": {
				"cycle1": "0.5",
				"skin1": "",
				"bg1": "4",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"bg3": "",
				"cycle2": "1"
			},
			"Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "6",
				"skin2": "1",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"bg3": "",
				"cycle2": "0"
			}
		},
		"cl_high_l1": {
			"Approach": {
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
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "6",
				"cycle2": "",
				"bg3": "1"
			},
			"Advance Approach": {
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
			"test": true,
			"Stop": {
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
			"Stop and Proceed": {
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
			"Grade Signal": {
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
			"Stop and Proceed (Forced)": {
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
			"Diverging Approach": {
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
			"Diverging Clear": {
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
			"Restricting": {
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
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "1",
				"cycle2": "",
				"bg3": "1"
			}
		},
		"cl_dwarf_l": {
			"Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "4 4 4 4",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Stop and Proceed (Forced)": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2 2 2 2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Advance Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Clear",
				"bg3": ""
			},
			"test": true,
			"Stop": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Stop and Proceed": {
				"cycle1": "",
				"skin1": "",
				"bg1": "1 1 1 1",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Grade Signal": {
				"cycle1": "",
				"skin1": "",
				"bg1": "2 2 2 2",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Restricting": {
				"cycle1": "",
				"skin1": "",
				"bg1": "3 3 3 3",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Diverging Approach": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Approach",
				"bg3": ""
			},
			"Approach Diverging": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Clear",
				"bg3": ""
			},
			"Diverging Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "0 0 0 0",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"cycle2": "",
				"bg2": "",
				"override": "Clear",
				"bg3": ""
			},
			"Clear": {
				"cycle1": "",
				"skin1": "",
				"bg1": "6 6 6 6",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			}
		}
	},
	"tags": {
		"grade": true,
		"abs": true
	},
	"func_text": "function(OCCUPIED, DIVERGING, SPEED, NEXTASPECT, NEXTSPEED, TAGS, CTC, NEXTDIV)\n\tif ( ( CTC == 2 ) ) then\n\t\treturn \"Restricting\"\n\telse\n\t\tif ( ( CTC == 0 ) ) or ( ( OCCUPIED ) ) or ( ( SPEED == 0 ) ) then\n\t\t\tif ( ( TAGS.grade ) ) then\n\t\t\t\treturn \"Grade Signal\"\n\t\t\telse\n\t\t\t\tif ( ( TAGS.abs ) ) then\n\t\t\t\t\treturn \"Stop and Proceed\"\n\t\t\t\telse\n\t\t\t\t\treturn \"Stop\"\n\t\t\t\tend\n\t\t\tend\n\t\telse\n\t\t\tif ( ( SPEED == 1 ) ) then\n\t\t\t\treturn \"Restricting\"\n\t\t\telse\n\t\t\t\tif ( ( NEXTSPEED <= 1 ) ) then\n\t\t\t\t\tif ( ( DIVERGING ) ) then\n\t\t\t\t\t\treturn \"Diverging Approach\"\n\t\t\t\t\telse\n\t\t\t\t\t\treturn \"Approach\"\n\t\t\t\t\tend\n\t\t\t\telse\n\t\t\t\t\tif ( ( DIVERGING ) ) then\n\t\t\t\t\t\treturn \"Diverging Clear\"\n\t\t\t\t\telse\n\t\t\t\t\t\tif ( ( NEXTDIV ) ) then\n\t\t\t\t\t\t\treturn \"Approach Diverging\"\n\t\t\t\t\t\telse\n\t\t\t\t\t\t\tif ( ( NEXTASPECT == \"Approach\" ) ) then\n\t\t\t\t\t\t\t\treturn \"Advance Approach\"\n\t\t\t\t\t\t\telse\n\t\t\t\t\t\t\t\treturn \"Clear\"\n\t\t\t\t\t\t\tend\n\t\t\t\t\t\tend\n\t\t\t\t\tend\n\t\t\t\tend\n\t\t\tend\n\t\tend\n\tend\nend",
	"rules": [
		{
			"description": "Stop and wait for more favorable indication.",
			"speed": "STOP/DANGER",
			"name": "Stop",
			"color": "Red"
		},
		{
			"description": "Stop, then proceed at RESTRICTED speed, prepared to stop within 1/2 sight distance to hazards or equipment.",
			"speed": "RESTRICTED",
			"name": "Stop and Proceed",
			"color": "Red"
		},
		{
			"description": "Stop, then proceed at RESTRICTED speed, prepared to stop within 1/2 sight distance to hazards or equipment.",
			"speed": "RESTRICTED",
			"name": "Stop and Proceed (Forced)",
			"color": "Red"
		},
		{
			"description": "For high-tonnage freight trains: treat as Restricting.\nFor all other trains: treat as Stop and Proceed.",
			"speed": "RESTRICTED",
			"name": "Grade Signal",
			"color": "Red"
		},
		{
			"description": "Proceed at RESTRICTED speed, prepared to stop within 1/2 sight distance to hazards or equipment.",
			"speed": "RESTRICTED",
			"name": "Restricting",
			"color": "Lunar White"
		},
		{
			"description": "Proceed through DIVERGING route prepared to stop at next signal.",
			"speed": "FULL",
			"name": "Diverging Approach",
			"color": "Amber"
		},
		{
			"description": "Proceed prepared to stop at next signal.",
			"speed": "FULL",
			"name": "Approach",
			"color": "Amber"
		},
		{
			"description": "Proceed through DIVERGING route.",
			"speed": "FULL",
			"name": "Diverging Clear",
			"color": "Yellow-Green"
		},
		{
			"description": "Proceed prepared to take DIVERGING route at next signal.",
			"speed": "FULL",
			"name": "Approach Diverging",
			"color": "Yellow-Green"
		},
		{
			"description": "Proceed. Next signal is Approach.",
			"speed": "FULL",
			"name": "Advance Approach",
			"color": "Green"
		},
		{
			"description": "Proceed.",
			"speed": "FULL",
			"name": "Clear",
			"color": "Green"
		}
	],
	"sysname": "route_basic"
}