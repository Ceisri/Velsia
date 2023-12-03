extends KinematicBody

var floatingtext = preload("res://Creatures/Enemies/UI/textsprite.tscn")
onready var animation = $Spearskeleton/AnimationPlayer
onready var info_sprite = $InfoSprite
onready var eyes = $Eyes
onready var ray = $RayCast
onready var hitbox = $Hitbox
onready var namelabel = $Spatial/Viewport/Label
onready var healthlabel = $Spatial2/Viewport/Label
var entityname = "Skeleton Spearman"
#timers for movement
var directionChangeTimer = 0.0
var directionChangeInterval = 0.0
const minChangeInterval = 3.0
const maxChangeInterval = 12.0
#timers for combat 
var switchTimer = Timer.new()
var switchTimeMin = 1.0
var switchTimeMax = 1.5
#movement
const turn = 32
var vertical_velocity = Vector3()
#var gravity = 30
var state = "walk"
var target
# stats
var health = 100
var maxhealth = 100
var damage = 1
var criticalChance = 0.70
var criticalMultiplier = 1.5
var criticalDefenseChance = 0.60
var criticalDefenseMultiplier = 2
var impact 
var blockdamage = 3
# artificial fps timer
onready var fps = $Timer
var FPS = 0.045
#bools
var isGrounded = false
var blocking : bool
var kick : bool
var stabbing : bool
var slashing : bool
var slash_still : bool
var trust: bool
var is_blocking : bool
#live or die
var dead = false
# movement speed variables
var walkSpeed = 12.0
var chaseSpeed = 15.0
var fleeSpeed = 15.50

# Gravity strength
var gravity = Vector3(0, -9.8, 0)

# Vertical speed
var velocity = Vector3()

# Character movement speed
var speed = 5
# states list
enum {
	idle,
	chase,
	walk,
	attack,
	attack2,
	attack3,
	stunned,
	hit,
	block,
	dodge,
}
func _ready():
	namelabel.text = entityname
	walkSpeed = walkSpeed * (FPS * 10)
	chaseSpeed = chaseSpeed * (FPS *10)
	fleeSpeed = fleeSpeed * (FPS * 10)
	state = "walk"
	directionChangeInterval = rand_range(minChangeInterval, maxChangeInterval)
	fps = Timer.new()
	add_child(fps)
	fps.wait_time = FPS
	fps.connect("timeout", self, "_on_Timer_timeout")
	fps.start()
	
	switchTimer.wait_time = rand_range(switchTimeMin, switchTimeMax)
	add_child(switchTimer)
	switchTimer.connect("timeout", self, "_on_SwitchTimer_timeout")
	switchTimer.start()
func onhitKnockback(impact):
	# Calculate the knockback direction
	var knockbackDirection = -global_transform.basis.z.normalized()
	# Apply the knockback force to the velocity
	velocity = knockbackDirection * impact
func _on_Timer_timeout():

	if not dead:
		chase(fps.wait_time)  # Pass the timer wait time instead of delta time
		pc(fps.wait_time)  # Pass the timer wait time instead of delta time
	if dead: 
		animation.play("dead")	 
func _on_SwitchTimer_timeout():
	var randomValue = randf()
	var randblock = randf()

	if randomValue < 0.5:  # walks and stabs
		stabbing = true
		slashing = false
		kick = false
		slash_still = false
		trust = false
		impact = chaseSpeed 
	elif randomValue < 0.4:  # walks and slashes
		stabbing = false
		slashing = true
		kick = false
		slash_still = false
		trust = false
		impact = chaseSpeed
	elif randomValue < 0.6:  # kicks
		stabbing = false
		slashing = false
		kick = true
		slash_still = false
		trust = false
		impact = 45 + rand_range(15,30)
	elif randomValue < 0.8:  # stays still and slashes
		stabbing = false
		slashing = true
		kick = false
		slash_still = true
		trust = false
		impact = chaseSpeed
	else:
		stabbing = false
		slashing = false
		kick = false
		slash_still = false
		trust = true
		impact = chaseSpeed 
		
	if randblock < 0.5:
		is_blocking = true
	else:
		is_blocking = false	
		
		

	switchTimer.wait_time = rand_range(switchTimeMin, switchTimeMax)
	switchTimer.start()
func takeDamage(damage):
	updatehealthlabel()
	if not blocking: 
		if damage <= 0:
			return
	# Apply critical defense chance
		if randf() <= criticalDefenseChance:
			damage = damage / criticalDefenseMultiplier
			state = stunned
		# Basic formula for damage
		health -= damage
		info_sprite.showDamagetaken(damage)
		if health <= 0:
			dead = true
		if health <= -200:
			self.queue_free()
	if blocking: 
		if damage <= 0:
			return
	# Apply critical defense chance
		if randf() <= criticalDefenseChance:
			damage = damage / criticalDefenseMultiplier
		# Basic formula for damage
		health -= damage / blockdamage
		info_sprite.showDamagetaken(damage)
	if health <= 0:
			dead = true	
	if health <= -200:
			self.queue_free()
func attack():
	var enemies = hitbox.get_overlapping_bodies()
	var critical_damage = damage * criticalMultiplier
	for enemy in enemies:
		if enemy.is_in_group("Player"):
			var enemyStats = enemy.get_node("Stats")
			var enemy_info = enemy.get_node("InfoSprite")
			enemy.takeDamage(damage)
#func knockback(): 
	#var enemies = hitbox.get_overlapping_bodies()
	#for enemy in enemies:
	#	if enemy.is_in_group("Player"):
		#	enemy.getKnockedBack(impact)

func chase(delta):
#locate players and define distances and orientation
	var players = get_tree().get_nodes_in_group("Player")
	var target = null
	if players.size() > 0:
		target = players[0]
		var minDistance = self.global_transform.origin.distance_to(target.global_transform.origin)
		for player in players:
			var distance = self.global_transform.origin.distance_to(player.global_transform.origin)
			if distance < minDistance:
				minDistance = distance
				target = player
#state logic based on range 
	if target != null:
		var distanceToPlayer = self.global_transform.origin.distance_to(target.global_transform.origin)
		if distanceToPlayer > 0 and distanceToPlayer <= 20:
			state = chase
			target = target
			if distanceToPlayer > 0 and distanceToPlayer <= 2.5 and health >= maxhealth/3.5:
				state = attack
				target = target		
			elif distanceToPlayer > 0 and distanceToPlayer <= 2 and health <= maxhealth/3.5:
				state = block
				target = target
		else:
				state = walk
	else:
		state = walk

	match state:
		idle:
			blocking = false
			animation.play("idle", 0.1)
		attack:
			blocking = false
			if target != null:
				eyes.look_at(target.global_transform.origin, Vector3.UP)
				rotate_y(deg2rad(eyes.rotation.y * turn))
				if 	stabbing: 
					animation.play("stab", 0.2)
					move_and_slide(getSlideVelocity(chaseSpeed)) 
					#knockback()

				elif slashing:
					animation.play("slash walking", 0.25)
					move_and_slide(getSlideVelocity(chaseSpeed)) 
					#knockback()

				elif slash_still:
					animation.play("slash", 0.25)	
					#knockback()

				elif trust: 
					animation.play("forceful trust", 0.25)
					#knockback()


				elif kick: 
					animation.play("kick", 0.15)
					move_and_slide(getSlideVelocity(chaseSpeed)) 	
					
		walk:
			blocking = false
			animation.play("walk", 0.2)
			directionChangeTimer += delta
			if directionChangeTimer >= directionChangeInterval:
				directionChangeTimer = 0.0
				directionChangeInterval = rand_range(minChangeInterval, maxChangeInterval)
				changeRandomDirection()
			move_and_slide(getSlideVelocity(walkSpeed))  # Pass the walk speed
		chase:
			blocking = false
			animation.play("chase", 0, 1.5)
			if target != null:
				var targetDirection = (target.global_transform.origin - global_transform.origin).normalized()
				eyes.look_at(global_transform.origin + targetDirection, Vector3.UP)
				rotate_y(deg2rad(eyes.rotation.y * turn))
				move_and_slide(targetDirection * getSlideVelocity(chaseSpeed).length())  # Pass the chase speed
		block:
			if is_blocking:
				if target != null:
					var fleeDirection = (global_transform.origin - target.global_transform.origin).normalized()
					eyes.look_at(global_transform.origin - fleeDirection, Vector3.UP)
					rotate_y(deg2rad(eyes.rotation.y * turn))
					blocking = true
					animation.play("block")	
			else:
				if target != null:
					eyes.look_at(target.global_transform.origin, Vector3.UP)
					rotate_y(deg2rad(eyes.rotation.y * turn))
					animation.play("stab", 0.2)
					move_and_slide(getSlideVelocity(chaseSpeed)) 
					damage += 6
					#knockback()
						


func changeRandomDirection():
	var randomDirection = Vector3(rand_range(-1, 1), 0, rand_range(-1, 1)).normalized()
	var lookRotation = randomDirection.angle_to(Vector3.FORWARD)
	rotate_y(lookRotation)

func getSlideVelocity(speed: float) -> Vector3:
	var forwardVector = -transform.basis.z
	return forwardVector * speed



func pc(delta):
	updatehealthlabel()
	# Apply gravity
	velocity += gravity * delta
	# Move the character
	var movement = velocity * delta
	move_and_collide(movement)

	# Reset vertical speed if on the ground
	if is_on_floor():
		velocity.y = 0

	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		var distanceToPlayer = self.global_transform.origin.distance_to(player.global_transform.origin)
		if distanceToPlayer > 30:
			self.visible = false
			directionChangeTimer = 0.0
			directionChangeInterval = rand_range(minChangeInterval, maxChangeInterval)
		else:
			self.visible = true
	else:
		self.visible = true
		
func updatehealthlabel():
# Update health bar
	healthlabel.text = "Health: %.2f / %.2f" % [health, maxhealth]
# Update the UI or display a message to indicate the attribute increase
	var healthText = "Health: %.2f / %.2f" % [health, maxhealth]


