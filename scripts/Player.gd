extends KinematicBody

var GRAVITY = -24.8
var vel = Vector3()
var MAX_SPEED = 20
var JUMP_SPEED = 18
const ACCEL = 4

var dir = Vector3()

var isGunReload = false

const DEACCEL= 2
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.1

onready var AimCast = $Rotation_Helper/Camera/AimCast

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	
	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED
			print(MAX_SPEED)
			if (MAX_SPEED < 50):
				MAX_SPEED *= 1.20
			$Tween.stop_all()
			$Tween.interpolate_property(self, 'MAX_SPEED', null, 20, 5)
			$Tween.start()

			
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------
func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	
	if dir.dot(hvel) > 0:
		accel = ACCEL
		if hvel.x > 15 or hvel.z > 15:
			accel = 30
		if hvel.x < -15 or hvel.z < -15:
			accel = 30
	else:
		accel = DEACCEL
	
	
	
	print(accel, " ", hvel.x, " ", hvel.y)
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
	if Input.is_action_just_pressed("cheat_fly"):
		if (GRAVITY):
			print('gravity diabled')
			GRAVITY = 0
			cheatText('gravity disabled')
		else:
			print('gravity enabled')
			GRAVITY = -24.8
			cheatText('gravity enabled')
	if Input.is_action_just_pressed("shoot"):
		$Rotation_Helper/Camera/gun1/AnimationPlayer.play("Shoot")
		if (AimCast.is_colliding() and not isGunReload):
			isGunReload = true
			var colider = AimCast.get_collider()
			print(colider)
			if ('health' in colider):
				colider.health -= 1

func cheatText(text):
	var label = $Rotation_Helper/Camera/Label
	label.text = text
	$Tween.interpolate_property(label, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1)
	$Tween.start()


func _on_reload_done(anim_name):
	isGunReload = false
