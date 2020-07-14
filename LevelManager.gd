extends Node

export(NodePath) var tilemap_node_path
onready var tile_map: TileMap = get_node(tilemap_node_path)

export(NodePath) var player_node_path
onready var player: Area2D = get_node(player_node_path)

var level_translation = {".": 2, "X": 0, "S": 3}

var levels
var current_level = 0


func _ready() -> void:
	levels = _load_level_list()
	load_level(levels[current_level]) # TODO: Load the level that was last played, eventually...


func get_level_name() -> String:
	return levels[current_level]


func load_level(level: String) -> void:
	var file = _load_text_file("res://levels/" + level + ".txt")
	
	var line = file.get_csv_line()
	var rows = int(line[0])
	var cols = int(line[1])
	
	for row in range(rows):
		line = file.get_csv_line()
		for col in range(cols):
			tile_map.set_cellv(Vector2(col, row), level_translation[line[col]])
			if line[col] == 'S':
				player.position = tile_map.map_to_world(Vector2(row, col)) + (tile_map.cell_size / 2)
	
	_add_border(rows, cols)
		
	file.close()


func load_next_level() -> void:
	current_level += 1
	if current_level == levels.size():
		print("End of levels, looping back") # TODO: Handle this case -> End of game screen or something
		current_level = 0
	load_level(levels[current_level])


func _load_text_file(path) -> File:
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		printerr("Could not open file, error code ", err)
	return file


func _add_border(rows: int, cols: int) -> void:
	for row in range(-1, rows+1):
		tile_map.set_cellv(Vector2(row, -1), 0)
		tile_map.set_cellv(Vector2(row, cols), 0)
	
	for col in range(cols):
		tile_map.set_cellv(Vector2(-1, col), 0)
		tile_map.set_cellv(Vector2(rows, col), 0)


func _load_level_list():
	var files = []
	var dir = Directory.new()
	dir.open("res://levels")
	dir.list_dir_begin(true)

	while true:
		var file = dir.get_next()
		if file == "":
			break
		else:
			file = file.rstrip(".txt")
			files.append(file)

	return files
