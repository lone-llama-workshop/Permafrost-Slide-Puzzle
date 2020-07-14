extends Node

export(NodePath) var tilemap_node_path
onready var tile_map: TileMap = get_node(tilemap_node_path)

export(NodePath) var player_node_path
onready var player: Area2D = get_node(player_node_path)

var levels
var current_level = 0


func _ready() -> void:
	levels =load_level_list()
	load_level(levels[current_level]) # TODO: Load the level that was last played, eventually...


func load_level(level: String) -> void:
	var file = load_text_file("res://levels/" + level + ".txt")
	
	var line = file.get_csv_line()
	var rows = int(line[0])
	var cols = int(line[1])
	#print("rows: " + str(rows) + " cols: " + str(cols))
	
	for row in range(rows):
		line = file.get_csv_line()
		for col in range(cols):
			#print("row: " + str(row) + " col: " + str(col) + " = " + line[col])
			tile_map.set_cellv(Vector2(col, row), get_tilemap_code(line[col]))
			if line[col] == 'S':
				player.position = tile_map.map_to_world(Vector2(row, col)) + (tile_map.cell_size / 2)
		#print("-")
	
	add_border(rows, cols)
		
	file.close()


func load_next_level() -> void:
	current_level += 1
	if current_level == levels.size():
		print("End of levels, looping back") # TODO: Handle this case -> End of game screen or something
		current_level = 0
	load_level(levels[current_level])


func load_text_file(path) -> File:
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		printerr("Could not open file, error code ", err)
	return file


func add_border(rows: int, cols: int) -> void:
	for row in range(-1, rows+1):
		tile_map.set_cellv(Vector2(row, -1), 0)
		tile_map.set_cellv(Vector2(row, cols), 0)
	
	for col in range(cols):
		tile_map.set_cellv(Vector2(-1, col), 0)
		tile_map.set_cellv(Vector2(rows, col), 0)


func get_tilemap_code(letter: String) -> int:
	match letter:
		'.':
			return 2
		'X':
			return 0
		'S':
			return 2
		_:
			return 2


func load_level_list():
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
			print(file)
			files.append(file)

	return files
