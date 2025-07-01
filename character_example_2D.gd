extends MarginContainer

const SPEED: float = 300.

var joystick_single_output: Vector2

func _ready() -> void:
	MobileInputs.joystick_single_output.connect(_on_joystick_single_output)
	
func _physics_process(delta: float) -> void:
	global_position += joystick_single_output * SPEED * delta

func _on_joystick_single_output(pressured_direction:Vector2) -> void:
	joystick_single_output = pressured_direction
