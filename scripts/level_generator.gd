extends Node2D

var platform_scene = preload("res://scenes/platform.tscn")
@onready var platform_parent = $PlatformParent

var player: Player = null

var start_platform_y
var y_distance_between_platforms = 100
var level_size = 50
var viewport_size 
var generated_platform_count := 0

func setup(_player: Player):
	if _player:
		player = _player
# Called when the node enters the scene tree for the first time.
func _ready():
	generated_platform_count = 0
	viewport_size = get_viewport_rect().size
	start_platform_y = viewport_size.y - (y_distance_between_platforms * 2)

func start_generation():
	generate_level(start_platform_y,true)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player:	
		var py = player.global_position.y
		var end_of_level_pos = start_platform_y - (generated_platform_count * y_distance_between_platforms)
		var threshold = end_of_level_pos + y_distance_between_platforms * 6
		if py <= threshold:
			generate_level(end_of_level_pos , false)

func create_platform(location: Vector2) -> Node2D:
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform
	
func generate_level(start_y : float , generate_ground:bool ):
	
	var platform_width = 136
		
	if generate_ground:
		# generate the ground
		
		var ground_layer_platform_count = (viewport_size.x/platform_width) + 1
		
		var ground_layer_y_offset = 62
		
		for i in range(ground_layer_platform_count):
			var ground_location = Vector2(i * platform_width,viewport_size.y - ground_layer_y_offset)
			create_platform(ground_location)
			
	# generate the rest of the level
	
	for i in range(level_size):
		var location:Vector2 = Vector2.ZERO
		var max_x_position = viewport_size.x - platform_width
		
		location.x = randf_range(0, max_x_position)
		location.y = start_y -(y_distance_between_platforms * i)
		
		create_platform(location)
		generated_platform_count += 1

func reset_level():
	generated_platform_count = 0
	for platform in platform_parent.get_children():
		platform.queue_free()
