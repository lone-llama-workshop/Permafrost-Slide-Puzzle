extends Area2D

const GRID_SIZE: int = 64

onready var grid: TileMap = get_parent()
onready var ray_cast: RayCast2D =  $RayCast2D
onready var level_manager: Node = get_parent().get_parent().get_node("LevelManager")


func _ready() -> void:
	print(grid.cell_size)
	print(grid.world_to_map(position))
	
	position = (grid.world_to_map(position) * grid.cell_size) + (grid.cell_size / 2)
	print(position)
	
	print(grid.get_cellv(grid.world_to_map(position)))

func _input(event): 
	if Input.is_action_just_pressed("ui_reset"):
		get_tree().reload_current_scene()


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	var input_direction = get_input_direction()
	if not input_direction:
		return
		
	print(input_direction)
	
	ray_cast.cast_to = input_direction * grid.cell_size 
	ray_cast.force_raycast_update()
	while !ray_cast.is_colliding():
		grid.set_cellv(grid.world_to_map(position), 1) 
		position += input_direction * grid.cell_size
		ray_cast.force_raycast_update()
	
	if check_for_victory():
		level_manager.load_next_level()


func get_input_direction() -> Vector2:
	var LEFT = Input.is_action_just_pressed("ui_left")
	var RIGHT = Input.is_action_just_pressed("ui_right")
	var UP = Input.is_action_just_pressed("ui_up")
	var DOWN = Input.is_action_just_pressed("ui_down")
	
	var move_dir := Vector2(
		int(RIGHT) - int(LEFT),
		int(DOWN) - int(UP)
	)
	
	if move_dir.x != 0 && move_dir.y != 0: # prevent diagonals
		move_dir = Vector2.ZERO
	
	return move_dir


func check_for_victory() -> bool: 
	var used_cells = grid.get_used_cells()
	var grass_count = 0 
	for cell in used_cells: 
		if grid.get_cellv(cell) == 2:
			grass_count += 1
	if grass_count == 1:
		print("Victory")
		return true
	else: 
		print("Incomplete")
		return false
	
