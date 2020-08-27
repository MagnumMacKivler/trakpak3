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
					"OCCUPIED",
					")",
					"or",
					"(",
					"SPEED",
					"==",
					"STOP/DANGER",
					")",
					"or",
					"(",
					"CTC",
					"==",
					"HOLD",
					")"
				],
				"parent": 1.0,
				"name": "IF ( OCCUPIED ) or ( SPEED == STOP/DANGER ) or ( CTC == HOLD )"
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
				"nextnode": 10.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 2.0
			},
			{
				"id_else": 7.0,
				"id_then": 6.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"TAGS.abs",
					")"
				],
				"parent": 3.0,
				"name": "IF ( TAGS.abs )"
			},
			{
				"icon": "icon16/monitor_add.png",
				"nextnode": 8.0,
				"name": "THEN",
				"canattach": true,
				"parent": 5.0
			},
			{
				"icon": "icon16/monitor_delete.png",
				"nextnode": 9.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 5.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Stop And Proceed",
				"parent": 6.0,
				"name": "Stop And Proceed"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Stop",
				"parent": 7.0,
				"name": "Stop"
			},
			{
				"id_else": 12.0,
				"id_then": 11.0,
				"icon": "icon16/lightning.png",
				"isconditional": true,
				"conditions": [
					"(",
					"NEXTSPEED",
					"<",
					"FULL",
					")"
				],
				"parent": 4.0,
				"name": "IF ( NEXTSPEED < FULL )"
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
				"nextnode": 14.0,
				"name": "ELSE",
				"canattach": true,
				"parent": 10.0
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Approach",
				"parent": 11.0,
				"name": "Approach"
			},
			{
				"icon": "icon16/book_open.png",
				"aspect": "Clear",
				"parent": 12.0,
				"name": "Clear"
			}
		]
	},
	"sigtypes": {
		"home": {
			"Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"test": true,
			"Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			}
		},
		"distant": {
			"Approach": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			},
			"test": true,
			"Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "",
				"bg3": ""
			}
		},
		"combo": {
			"Stop": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "0",
				"bg3": ""
			},
			"Stop And Proceed": {
				"cycle1": "0",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "0",
				"bg3": ""
			},
			"Approach": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "0",
				"bg3": ""
			},
			"test": true,
			"Clear": {
				"cycle1": "1",
				"skin1": "",
				"bg1": "",
				"skin2": "",
				"cycle3": "",
				"skin3": "",
				"bg2": "",
				"cycle2": "1",
				"bg3": ""
			}
		}
	},
	"tags": {
		"abs": true
	},
	"func_text": "function(OCCUPIED, DIVERGING, SPEED, NEXTASPECT, NEXTSPEED, TAGS, CTC)\n\tif ( ( OCCUPIED ) ) or ( ( SPEED == 0 ) ) or ( ( CTC == 0 ) ) then\n\t\tif ( ( TAGS.abs ) ) then\n\t\t\treturn \"Stop And Proceed\"\n\t\telse\n\t\t\treturn \"Stop\"\n\t\tend\n\telse\n\t\tif ( ( NEXTSPEED < 5 ) ) then\n\t\t\treturn \"Approach\"\n\t\telse\n\t\t\treturn \"Clear\"\n\t\tend\n\tend\nend",
	"rules": [
		{
			"color": "Red",
			"description": "Stop.",
			"name": "Stop",
			"speed": "STOP/DANGER"
		},
		{
			"color": "Red",
			"description": "Stop, then proceed at RESTRICTED speed.",
			"name": "Stop And Proceed",
			"speed": "RESTRICTED"
		},
		{
			"color": "Amber",
			"description": "Proceed prepared to stop at next signal.",
			"name": "Approach",
			"speed": "FULL"
		},
		{
			"color": "Green",
			"description": "Proceed",
			"name": "Clear",
			"speed": "FULL"
		}
	],
	"sysname": "banjo_test"
}