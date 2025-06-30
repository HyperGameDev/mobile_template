extends CanvasLayer

var visibility: visibilities
enum visibilities {TOUCH,ALWAYS,NEVER}

var pos_type: pos_types
enum pos_types {FLOATING,FIXED}

var float_type: float_types
enum float_types {FULL,BOTTOM,BOTTOM_LEFT,BOTTOM_RIGHT}

var fixed_type: fixed_types
enum fixed_types {SINGLE,TWIN}

var base_mode: base_modes
enum base_modes {STATIC,DYNAMIC}

var radius = 35

func _ready():
	center_joystick_to_screen()

func _input(event):
	#print(get_direction())
	if event is InputEventScreenTouch:
		if event.is_pressed():
			check_joystick_type(event)
			set_visibility(true)
		else:
			center_joystick_to_screen()
			set_visibility(false)

	elif event is InputEventScreenDrag:
		var base_center = %Base.position + %Base.texture.get_size() / 2
		
		match base_mode:
			base_modes.STATIC:
				center_tracker_to_base(event.position)
				
			base_modes.DYNAMIC:
				var tracker_size: Vector2 = %Tracker.texture.get_size()
				%Tracker.global_position = event.position - tracker_size / 2
				
				var tracker_center: Vector2 = %Tracker.global_position + tracker_size / 2
				var distance: Vector2 = (tracker_center - base_center).length()
				
				if distance > radius:
					var direction: Vector2 = (tracker_center - base_center).normalized()
					%Base.position = tracker_center - direction * radius - %Base.texture.get_size() / 2

func get_direction() -> Vector2:
	var base_center: Vector2 = %Base.position + %Base.texture.get_size() / 2
	var tracker_center: Vector2 = %Tracker.global_position + %Tracker.texture.get_size() / 2
	return (tracker_center - base_center).normalized()
	
func set_visibility(make_visible:bool) -> void:
	if make_visible:
		match visibility:
			visibilities.TOUCH:
				%Base.visible = true
			visibilities.ALWAYS:
				%Base.visible = true
			visibilities.NEVER:
				%Base.visible = false
	else:
		match visibility:
			visibilities.TOUCH:
				%Base.visible = false
			visibilities.ALWAYS:
				print("am visible")
				%Base.visible = true
			visibilities.NEVER:
				%Base.visible = false
			
	
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
				float_types.BOTTOM_LEFT:
					if event.position.y > screen_size.y /2 and event.position.x < screen_size.x /2:
						center_tracker_to_touch(event.position)
				float_types.BOTTOM_RIGHT:
					if event.position.y > screen_size.y /2 and event.position.x > screen_size.x /2:
						center_tracker_to_touch(event.position)
					
		pos_types.FIXED:
			match fixed_type:
				fixed_types.SINGLE:
					pass
				fixed_types.TWIN:
					pass

func center_tracker_to_touch(touch_pos: Vector2):
	var base_size: Vector2 = %Base.texture.get_size()
	var tracker_size: Vector2 = %Tracker.texture.get_size()
	%Base.position = touch_pos - base_size / 2
	%Tracker.global_position = touch_pos - tracker_size / 2

func center_tracker_to_base(touch_pos: Vector2):
	var base_center: Vector2 = %Base.position + %Base.texture.get_size() / 2
	var direction: Vector2 = (touch_pos - base_center).limit_length(radius)
	var tracker_size: Vector2 = %Tracker.texture.get_size()
	%Tracker.global_position = base_center + direction - tracker_size / 2
	
func center_joystick_to_screen():
	var screen_center: Vector2 = get_viewport().get_visible_rect().size / 2
	var base_size: Vector2 = %Base.texture.get_size()
	var tracker_size: Vector2 = %Tracker.texture.get_size()
	
	%Base.position = screen_center - base_size / 2
	%Tracker.global_position = screen_center - tracker_size / 2
