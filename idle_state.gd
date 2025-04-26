extends NodeState

@export var player: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var SPEED: float = 25.0

var direction: Vector2 = Vector2.ZERO
var last_facing: String = "right" 
var is_busy: bool = false



func _on_process(_delta : float) -> void:
	if not is_busy and Input.is_action_just_pressed("picking"):
		is_busy = true
		animated_sprite_2d.play("picking")
	
	elif not is_busy and Input.is_action_just_pressed("mix_potion"):
		is_busy = true
		animated_sprite_2d.play("mix_potion")

func _on_physics_process(_delta : float) -> void:
	
	if is_busy:
		player.velocity = Vector2.ZERO
		player.move_and_slide()
		return

	var new_direction = Vector2.ZERO
	
	if Input.is_action_pressed("walk-left"):
		new_direction.x = -1
		last_facing = "left"
	elif Input.is_action_pressed("walk-right"):
		new_direction.x = 1
		last_facing = "right"
	
	if Input.is_action_pressed("walk-up"):
		new_direction.y = -1
	elif Input.is_action_pressed("walk-down"):
		new_direction.y = 1
		
		
	direction = new_direction.normalized()
	player.velocity = direction * SPEED
	player.move_and_slide()

	if direction != Vector2.ZERO:
		if last_facing == "left":
			animated_sprite_2d.play("walk-left")
		elif last_facing == "right":
			animated_sprite_2d.play("walk-right")
	else:
		if last_facing == "left":
			animated_sprite_2d.play("idle")
		elif last_facing == "right":
			animated_sprite_2d.play("idle")
			
			
func _ready():
	if animated_sprite_2d.animation_finished.is_connected(_on_animation_finished):
		animated_sprite_2d.animation_finished.disconnect(_on_animation_finished)
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
func _on_animation_finished():
	print("Animation finished: ", animated_sprite_2d.animation)

	if is_busy:
		is_busy = false
		if last_facing == "left":
			animated_sprite_2d.play("idle-left")
		else:
			animated_sprite_2d.play("idle-right")


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
