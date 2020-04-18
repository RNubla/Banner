extends KinematicBody

export var gravity = -9.8

var velocity = Vector3()
var camera
var character
#export(NodePath) var anim_player_path
export (NodePath) var camera_path
var anim_player
var anim_tree

export var SPEED = 6
export var ACCEL = 3
export var DECCEL = 5



func _ready():
	character = $"."
	anim_player = $Player_Model/AnimationPlayer
#	anim_player = anim_player_path
	anim_tree = $Player_Model/AnimationPlayer/AnimationTree

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#character = $"."
	#camera = $Target/Camera.get_global_transform()

func _physics_process(delta):
#	camera = $Target/Camera.get_global_transform()
#	camera = get_node(camera_path).get_global_transform()
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
	
	var new_pos = dir * SPEED
	var accel = DECCEL
	
	if(dir.dot(hor_vel) > 0):
		accel = ACCEL
	
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
	var speed = hor_vel.length()/ SPEED
#	anim_tree.blend2_node_set_amount("Idle_Run",speed)
	anim_tree.set("parameters/Idle_Run/blend_amount", speed)
#	var anim_to_play = "lp_guy|Idle-loop"
#
#	if is_moving:
#		anim_to_play = "lp_guy|Run"
#
#	var current_anim = anim_player.get_current_animation()
#	if current_anim != anim_to_play:
#		anim_player.play(anim_to_play)
