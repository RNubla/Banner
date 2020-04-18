extends KinematicBody

export var gravity = -9.81

var velocity = Vector3()
var character
var camera
var camera_path


var anim_player

var anim_tree

export var Speed = 6
export var Accel = 3
export var Deccel = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	character = $"."
	anim_player = $"Player-Model/AnimationPlayer"
	anim_tree = $"Player-Model/AnimationPlayer/AnimationTree"
#	camera_path = $"..CameraGimbal/InnerGimbal/Camera"
#	camera_path = get_node("/root/CameraGimbal/InnerGimbal/Camera")
	
func _physics_process(delta):
#	camera = get_node(camera_path).get_global_transform()
#	camera = get_node("/root/CameraGimbal/InnerGimbal/Camera").get_global_transform()
	camera = get_tree().get_root().get_node("Spatial").get_node("CameraGimbal/InnerGimbal/Camera").get_global_transform()
	
	var dir = Vector3()
	var is_moving = false
	
	if(Input.is_action_pressed("Move_Forward")):
		dir += -camera.basis[2]
		is_moving = true
	if(Input.is_action_pressed("Move_Back")):
		dir += camera.basis[2]
		is_moving = true
	if(Input.is_action_pressed("Move_Left")):
		dir += -camera.basis[0]
		is_moving = true
	if(Input.is_action_pressed("Move_Right")):
		dir += camera.basis[0]
		is_moving = true
	
	dir.y = 0
	dir = dir.normalized()
	velocity.y += delta * gravity
	
	var hor_vel = velocity
	hor_vel.y = 0
	
	var new_pos = dir * Speed
	var accel = Deccel
	
	if(dir.dot(hor_vel) > 0):
		accel = Accel
	
	hor_vel = hor_vel.linear_interpolate(new_pos, accel * delta)
	
	velocity.x = hor_vel.x
	velocity.z = hor_vel.z
		
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_moving:
		#rotate the character base on user input
		var angle = atan2(hor_vel.x, hor_vel.z)
		
		var char_rot = character.get_rotation()
		char_rot.y = angle
		character.set_rotation(char_rot)
	
	#set animation
	var speed = hor_vel.length()/ Speed
#	anim_tree.blend2_node_set_amount("Idle_Run",speed)
	anim_tree.set("parameters/Idle_Run/blend_amount", speed)
