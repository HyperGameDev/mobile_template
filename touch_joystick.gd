extends CanvasLayer

var pos_type: pos_types
enum pos_types {FLOATING,FIXED}

var float_type: float_types
enum float_types {FULL,BOTTOM}

var fixed_type: fixed_types
enum fixed_types {LEFT,RIGHT,CUSTOM}

var mode = 1 # 0 = dynamic joystick, 1 = static joystick
var radius = 35

func _ready():
	%Base.position = Vector2(-100, -100)
	%Tracker.global_position = Vector2(-100, -100)

func _input(event):
	print(get_direction())
	if event is InputEventScreenTouch:
		if event.is_pressed():
			check_joystick_type(event)
		else:
			%Base.position = Vector2(-100, -100)
			%Tracker.global_position = Vector2(-100, -100)

	elif event is InputEventScreenDrag:
		var base_center = %Base.position + %Base.texture.get_size() / 2
		
		if mode == 0:
			center_tracker_to_touch(event.position)
			if (event.position - base_center).length() >= radius:
				var angle = (base_center - %Tracker.global_position).angle()
				%Base.position = Vector2(radius * cos(angle), radius * sin(angle)) + %Tracker.global_position - %Base.texture.get_size() / 2

		if mode == 1:
			center_tracker_to_base(event.position)

func get_direction():
	var 	base_center = %Base.position + %Base.texture.get_size() / 2
	var tracker_center = %Tracker.global_position + %Tracker.texture.get_size() / 2
	return (tracker_center - base_center).normalized()
	
func check_joystick_type(event) -> void:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	match pos_type:
		pos_types.FLOATING:
			match float_type:
				float_types.FULL:
					center_tracker_to_touch(event.position)
				float_types.BOTTOM:
					if event.position.y > screen_size.y /2:
						center_tracker_to_touch(event.position)
		pos_types.FIXED:
			match fixed_type:
				fixed_types.LEFT:
					if event.position.y > screen_size.y /2 and event.position.x < screen_size.x /2:
						center_tracker_to_touch(event.position)
				fixed_types.RIGHT:
					pass
				fixed_types.CUSTOM:
					pass

func center_tracker_to_touch(touch_pos: Vector2):
	var base_size = %Base.texture.get_size()
	var tracker_size = %Tracker.texture.get_size()
	%Base.position = touch_pos - base_size / 2
	%Tracker.global_position = touch_pos - tracker_size / 2

func center_tracker_to_base(touch_pos: Vector2):
	var base_center = %Base.position + %Base.texture.get_size() / 2
	var direction = (touch_pos - base_center).limit_length(radius)
	var tracker_size = %Tracker.texture.get_size()
	%Tracker.global_position = base_center + direction - tracker_size / 2
