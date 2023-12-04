extends Control

onready var player = $"../../.."
onready var attachment = $"../../../FHuman/Armature/Skeleton/mount_attachment"
onready var camera = $"../../../Camroot/Camera_holder/Camera"
var model0: PackedScene = preload("res://Creatures/Mounts/horse/Horse0/Horse0.tscn")
var model1: PackedScene = preload("res://Creatures/Mounts/horse/Horse1/horse1.tscn")
var model2: PackedScene = preload("res://Creatures/Mounts/horse/Horse2/Horse2.tscn")
var model3: PackedScene = preload("res://Creatures/Mounts/horse/Horse3/horse3.tscn")
var model4: PackedScene = preload("res://Creatures/Mounts/horse/Horse4/Horse4.tscn")
var model5: PackedScene = preload("res://Creatures/Mounts/horse/Horse5/Horse5.tscn")
var model6: PackedScene = preload("res://Creatures/Mounts/horse/Horse6/Horse6.tscn")
var model7: PackedScene = preload("res://Creatures/Mounts/horse/Horse7/Horse7.tscn")
var currentInstance: Node = null  
var effect0_applied: bool = false
var has_model0 = false
var has_model1 = false
var has_model2 = false
var has_model3 = false 
var has_model4 = false
var has_model5 = false
var has_model6 = false
var has_model7 = false
func ready():
	switch()
func switch():
	if has_model0:
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model0.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse1")
			player.has_ride = true
			Effect0(true)
	elif has_model1:	
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model1.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse1")
			player.has_ride = true
			Effect0(true)		
	elif has_model2:	
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model2.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse2")
			player.has_ride = true
			Effect0(true)			
	elif has_model3:	
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model3.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse3")
			player.has_ride = true
			Effect0(true)		
	elif has_model4:
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model4.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse4")
			player.has_ride = true
			Effect0(true)			
	elif has_model5:
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model5.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse5")
			player.has_ride = true
			Effect0(true)
	elif has_model6:
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model6.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse6")
			player.has_ride = true
			Effect0(true)
	elif has_model7:
		# Check if there is no current horse instance
		if currentInstance == null:
			# Instantiate the horse scene
			currentInstance = model7.instance()
			# Set the scale of the horse
			currentInstance.scale *= Vector3(100, 100, 100)
			# Add the horse as a child of the attachment node
			attachment.add_child(currentInstance)
			print("Player has horse7")
			player.has_ride = true
			Effect0(true)		
	else: 
		player.has_ride = false
		Effect0(false)
func drop():
		if currentInstance != null:
			# Remove the instanced model from the attachment
			attachment.remove_child(currentInstance)
			# Set the scale to 1, 1, 1
			currentInstance.scale = Vector3(1, 1, 1)
			# Calculate the position in front of the camera
			# Get the global transform of the camera
			var camera_transform = camera.global_transform
			# Set the position of the horse in front of the camera
			currentInstance.global_transform.origin = camera_transform.origin + camera_transform.basis.z * (-5.0)  # Adjust the distance as needed		
			# Instance the horse back as a child of the root node
			get_tree().root.add_child(currentInstance)
			print("Horse dropped")
			# Reset variables
			has_model0 = false
			currentInstance = null
			player.has_ride = false
			Effect0(false)
func _on_ItemDetector_body_entered(body):
	if !player.has_ride:
		if body.is_in_group("Horse0"):
			if Input.is_action_pressed("E"):
				has_model0 = true
				check_and_delete(body)
		elif body.is_in_group("Horse1"):
			if Input.is_action_pressed("E"):
				has_model1 = true
				check_and_delete(body)		
		elif body.is_in_group("Horse2"):
			if Input.is_action_pressed("E"):
				has_model0 = false
				check_and_delete(body)
		elif body.is_in_group("Horse3"):
			if Input.is_action_pressed("E"):
				has_model3 = true
				check_and_delete(body)	
		elif body.is_in_group("Horse4"):
			if Input.is_action_pressed("E"):
				has_model4 = true
				check_and_delete(body)
		elif body.is_in_group("Horse5"):
			if Input.is_action_pressed("E"):
				has_model5 = true
				check_and_delete(body)
		elif body.is_in_group("Horse6"):
			if Input.is_action_pressed("E"):
				has_model6 = true
				check_and_delete(body)
		elif body.is_in_group("Horse7"):
			if Input.is_action_pressed("E"):
				has_model7 = true
				check_and_delete(body)
func check_and_delete(body):
	# Check if the parent is the player
	if body.get_parent() != attachment:
		# Delete the body or perform other actions
		body.queue_free()
func _physics_process(delta):
	switch()
	if Input.is_action_just_pressed("drop"):
		drop()
		has_model0 = false
		has_model1 = false
		has_model2 = false
		has_model3 = false
		has_model4 = false
		has_model5 = false
		has_model6 = false		
		has_model7 = false
		player.has_ride = false
		Effect0(false)
func Effect0(active: bool):
	if active and not effect0_applied:
		effect0_applied = true
		# Apply horse effect, adjust the boost values as needed
		player.walk_speed *= 2  
		player.run_speed *= 2
		player.agility += 0.75
	   
	elif not active and effect0_applied:
		# Remove horse effect
		player.walk_speed = player.original_walk_speed  # Reset walk speed to its original value
		player.run_speed = player.original_run_speed     # Reset run speed to its original value
		player.agility -= 0.75
		effect0_applied = false

