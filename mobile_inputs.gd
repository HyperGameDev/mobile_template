extends CanvasLayer

@export var joystick_type: joystick_types
enum joystick_types {
	FLOATING, ##A single joystick appears wherever the player touches, and stays there until the next touch.
	FLOATING_BOTTOM, ##A single joystick appears wherever the player touches if that touch is in the lower half of the screen, and it stays there until the next touch.
	FLOATING_BOTTOM_LEFT, ##A single joystick appears wherever the player touches if that touch is in the bottom-left side of the screen.
	FLOATING_BOTTOM_RIGHT, ##A single joystick appears wherever the player touches if that touch is in the bottom-right side of the screen.
	FLOATING_DYNAMIC, ##A single joystick follows the player's touch constantly instead of staying put at the initial touch position.
	FIXED_CUSTOM_SINGLE, ##A single joystick is fixed to a custom position on the screen. This joystick will no longer float, but only respond if touched at its specific position.
	#TWIN_FLOATING, ##A left joystick appears whenever the player touches anywhere on the left side of the screen; a right joystick appears whenever the player touches anywhere on the right side of the screen.
	#TWIN_FLOATING_BOTTOM, ##Same as TWIN_FLOATING except only applies to the bottom half of the screen.
	#TWIN_FIXED ##A left and right joystick are fixed to the screen and will not activate unless directly pressed.
	#FIXED_CUSTOM_TWIN, ##A left and right joystick are fixed to custom positions on the screen. These joysticks will not float, but only respond if touched at their specific positions.
	}
	
@export var joystick_visibility: joystick_visibilities
enum joystick_visibilities {
	ON_TOUCH, ##Joystick only appears when the player is touching the screen,
	ALWAYS, ##Joystick is always visible.
	NEVER ##Joystick is never visible.
	}

var input_array: Array[PackedScene] = [
	load("res://touch_joystick.tscn"),
]

func _ready() -> void:
	setup_joystick()
	
func setup_joystick() -> void:
	match joystick_visibility:
		joystick_visibilities.ON_TOUCH:
			%Touch_Joystick.visibility = %Touch_Joystick.visibilities.TOUCH
		joystick_visibilities.ALWAYS:
			%Touch_Joystick.visibility = %Touch_Joystick.visibilities.ALWAYS
			%Touch_Joystick.set_visibility(false)
		joystick_visibilities.NEVER:
			%Touch_Joystick.visibility = %Touch_Joystick.visibilities.NEVER
			%Touch_Joystick.set_visibility(false)
	match joystick_type:
		joystick_types.FLOATING:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.FULL
		joystick_types.FLOATING_BOTTOM:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.BOTTOM
		joystick_types.FLOATING_BOTTOM_LEFT:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.fixed_type = %Touch_Joystick.fixed_types.LEFT
		joystick_types.FLOATING_BOTTOM_RIGHT:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.fixed_type = %Touch_Joystick.fixed_types.RIGHT
		joystick_types.FIXED_CUSTOM_SINGLE:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FIXED
			%Touch_Joystick.fixed_type = %Touch_Joystick.fixed_types.CUSTOM
			
