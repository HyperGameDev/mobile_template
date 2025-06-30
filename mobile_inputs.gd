extends CanvasLayer

@export var joystick_type: joystick_types
enum joystick_types {
	FLOATING, ##Joystick appears wherever the player touches.
	FLOATING_BOTTOM, ##Joystick appears wherever the player touches if that touch is in the lower half of the screen.
	FIXED_LEFT, ##Joystick is fixed to the bottom-left side of the screen. It will still float within that quadrant.
	FIXED_RIGHT, ##Joystick is fixed to the bottom-right side of the screen. It will still float within that quadrant.
	FIXED_CUSTOM ##Joystick is fixed to a custom position on the screen. Joystick will no longer float, but need to be touched in its specific position.
	}
	
@export var joystick_visible: bool = false

var input_array: Array[PackedScene] = [
	load("res://touch_joystick.tscn"),
]

func _ready() -> void:
	setup_joystick()
	
func setup_joystick() -> void:
	match joystick_type:
		joystick_types.FLOATING:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.FULL
		joystick_types.FLOATING_BOTTOM:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FLOATING
			%Touch_Joystick.float_type = %Touch_Joystick.float_types.BOTTOM
		joystick_types.FIXED_LEFT:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FIXED
			%Touch_Joystick.fixed_type = %Touch_Joystick.fixed_types.LEFT
		joystick_types.FIXED_RIGHT:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FIXED
			%Touch_Joystick.fixed_type = %Touch_Joystick.fixed_types.RIGHT
		joystick_types.FIXED_CUSTOM:
			%Touch_Joystick.pos_type = %Touch_Joystick.pos_types.FIXED
			%Touch_Joystick.fixed_type = %Touch_Joystick.fixed_types.CUSTOM
			
