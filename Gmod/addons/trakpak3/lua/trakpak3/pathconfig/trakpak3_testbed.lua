{
	"signal_south_2_1": [
		{
			"divergence": false,
			"block": "block_north_2",
			"currentstate": true,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_x_2": false,
				"ss_j_1": false,
				"ss_x_1": false
			},
			"speed": 5.0
		},
		{
			"divergence": true,
			"block": "block_north_1",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_x_2": true,
				"ss_j_1": false,
				"ss_x_1": true
			},
			"speed": 3.0
		}
	],
	"signal_west": [
		{
			"divergence": true,
			"block": "block_north_1",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_j_2": true,
				"ss_x_2": false,
				"ss_x_1": false
			},
			"speed": 1.0
		},
		{
			"divergence": true,
			"block": "block_north_2",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": true,
				"ss_x_2": false,
				"ss_j_1": false,
				"ss_x_1": false
			},
			"speed": 1.0
		},
		{
			"divergence": true,
			"block": "block_north_1",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": true,
				"ss_x_2": true,
				"ss_j_1": false,
				"ss_x_1": true
			},
			"speed": 1.0
		}
	],
	"signal_north_2_1": [
		{
			"divergence": false,
			"block": "block_south_2",
			"currentstate": true,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_x_2": false,
				"ss_j_1": false,
				"ss_x_1": false
			},
			"speed": 5.0
		},
		{
			"divergence": true,
			"block": "block_south_1",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": false,
				"ss_x_2": false,
				"ss_j_1": false,
				"ss_x_1": false
			},
			"speed": 3.0
		},
		{
			"nextsignal": "signal_east_3",
			"divergence": true,
			"currentstate": false,
			"block": "block_east_1",
			"switchlist": {
				"ss_x_2": false,
				"ss_j_1": true,
				"ss_x_1": false
			},
			"speed": 2.0
		},
		{
			"divergence": true,
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": true,
				"ss_x_2": false,
				"ss_j_1": false,
				"ss_x_1": false
			},
			"speed": 1.0
		}
	],
	"signal_south_1_1": [
		{
			"divergence": false,
			"block": "block_north_1",
			"currentstate": true,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_j_2": false,
				"ss_x_2": false,
				"ss_x_1": false
			},
			"speed": 5.0
		},
		{
			"divergence": true,
			"block": "block_north_2",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": false,
				"ss_x_2": false,
				"ss_j_1": false,
				"ss_x_1": false
			},
			"speed": 3.0
		},
		{
			"divergence": true,
			"block": "block_north_1",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": false,
				"ss_x_2": true,
				"ss_j_1": false,
				"ss_x_1": true
			},
			"speed": 3.0
		}
	],
	"signal_north_1_1": [
		{
			"divergence": false,
			"block": "block_south_1",
			"currentstate": true,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_j_2": false,
				"ss_x_2": false,
				"ss_x_1": false
			},
			"speed": 5.0
		},
		{
			"divergence": true,
			"block": "block_south_2",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_x_2": true,
				"ss_j_1": false,
				"ss_x_1": true
			},
			"speed": 3.0
		},
		{
			"divergence": true,
			"block": "block_south_1",
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": false,
				"ss_x_2": true,
				"ss_j_1": false,
				"ss_x_1": true
			},
			"speed": 3.0
		},
		{
			"nextsignal": "signal_east_3",
			"divergence": true,
			"currentstate": false,
			"block": "block_east_1",
			"switchlist": {
				"ss_x_2": true,
				"ss_j_1": true,
				"ss_x_1": true
			},
			"speed": 2.0
		},
		{
			"divergence": true,
			"currentstate": false,
			"switchlist": {
				"ss_x_4": false,
				"ss_x_3": false,
				"ss_j_2": true,
				"ss_x_2": false,
				"ss_x_1": false
			},
			"speed": 1.0
		},
		{
			"divergence": true,
			"currentstate": false,
			"switchlist": {
				"ss_x_4": true,
				"ss_x_3": true,
				"ss_j_2": true,
				"ss_x_2": true,
				"ss_j_1": false,
				"ss_x_1": true
			},
			"speed": 1.0
		}
	],
	"signal_east_1_1": [
		{
			"divergence": true,
			"block": "block_north_2",
			"currentstate": false,
			"switchlist": {
				"ss_x_2": false,
				"ss_j_1": true,
				"ss_x_1": false
			},
			"speed": 2.0
		},
		{
			"divergence": true,
			"block": "block_north_1",
			"currentstate": false,
			"switchlist": {
				"ss_x_2": true,
				"ss_j_1": true,
				"ss_x_1": true
			},
			"speed": 2.0
		}
	]
}