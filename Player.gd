extends Area2D

const GRID_SIZE: int = 64


func _ready() -> void:
	position = position.snapped(Vector2.ONE * GRID_SIZE)
	#position = Vector2.ZERO
	position += Vector2.ONE * GRID_SIZE/2


func _process(delta: float) -> void:
	pass
