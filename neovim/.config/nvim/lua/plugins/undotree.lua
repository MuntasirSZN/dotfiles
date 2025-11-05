return {
	"y3owk1n/time-machine.nvim",
	cmd = {
		"TimeMachineToggle",
		"TimeMachinePurgeBuffer",
		"TimeMachinePurgeAll",
		"TimeMachineLogShow",
		"TimeMachineLogClear",
	},
	keys = {
		{
			"<leader>ct",
			"",
			desc = "Time Machine",
		},
		{
			"<leader>ctt",
			"<cmd>TimeMachineToggle<cr>",
			desc = "[Time Machine] Toggle Tree",
		},
		{
			"<leader>ctx",
			"<cmd>TimeMachinePurgeCurrent<cr>",
			desc = "[Time Machine] Purge current",
		},
		{
			"<leader>ctX",
			"<cmd>TimeMachinePurgeAll<cr>",
			desc = "[Time Machine] Purge all",
		},
		{
			"<leader>ctl",
			"<cmd>TimeMachineLogShow<cr>",
			desc = "[Time Machine] Show log",
		},
	},
	---@type TimeMachine.Config
	opts = {
		diff_tools = "delta",
		time_format = "pretty",
	},
}
