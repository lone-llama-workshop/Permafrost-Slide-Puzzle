extends Area2D

const GRID_SIZE: int = 64

onready var grid: TileMap = get_parent()

enum DIRECTIONS {
	UP
	DOWN
	LEFT
	RIGHT
}


func _ready() -> void:
	print(grid.cell_size)
	print(grid.world_to_map(position))
	
	position = grid.world_to_map(position) + (grid.cell_size / 2)
	print(position)
	
	print(grid.get_used_cells())
	print(grid.get_cellv(grid.world_to_map(position)))


func _process(delta: float) -> void:
	var input_direction = get_input_direction()
	if not input_direction:
		return
		
	print(input_direction)
	position += grid.cell_size * input_direction


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


func get_furthest_slide_position() -> Vector2:
	return Vector2.ZERO
