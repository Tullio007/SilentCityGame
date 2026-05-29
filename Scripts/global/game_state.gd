extends Node

var flags := {
	"goblins_marked": false,
	"final_choice": ""
}

func set_flag(name, value):
	flags[name] = value

func get_flag(name):
	return flags.get(name, null)