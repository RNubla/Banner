extends Spatial

export (NodePath) var inner_gimbal_path
export var rotation_speed = PI /2
export (NodePath) var Target


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Target:
		global_transform.origin = get_node(Target).global_transform.origin
	get_input_keyboard(delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, -0.01)
	
	
func get_input_keyboard(delta):
	var y_rotation = 0
	if Input.is_action_pressed("Look_Right"):
		y_rotation -= 1
	if Input.is_action_pressed("Look_Left"):
		y_rotation += 1
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	
#	rotate inner gimbal on the local x-axis
	var x_rotation = 0
	if Input.is_action_pressed("Look_Up"):
		x_rotation += 1
	if Input.is_action_pressed("Look_Down"):
		x_rotation -= 1
	$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)
