class_name Mold
extends Resource

@export var core_dots:PackedVector2Array = PackedVector2Array()
@export var texture_dots:PackedVector2Array = PackedVector2Array()
@export var output_dots:PackedVector2Array = PackedVector2Array()
@export var name:String
@export var chunks: Array[SpecialChunk]

#const CHUNKS_DATA = [
	#"res://dataTables/chunks/blaze.tres",
	#"res://dataTables/chunks/life.tres",
	#"res://dataTables/chunks/resonance.tres",
	#"res://dataTables/chunks/starlight.tres",
	#"res://dataTables/chunks/storm.tres",
	#"res://dataTables/chunks/tidal.tres",
#]

	#_generate_chunk(Vector2(288, 16+32*5), 4, Vector3(0,1,0))
	#_generate_chunk(Vector2(288+32, 16+32*5), 2, Vector3(0,-3,0))
	#_generate_chunk(Vector2(288+64, 16+32*5), 5, Vector3(1,-1,0.5*PI))
