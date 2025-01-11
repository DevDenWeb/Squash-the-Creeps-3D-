extends Node

@export var mob_scene: PackedScene



func _on_mob_timer_timeout():
	# Создаёт новый экземпляр сцены "mob"
	var mob = mob_scene.instantiate()
	
	# Выбирает случайное местополоение на SpawnPath. Сохраняет ссылку на узел SpawnLocation
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# Задаёт ему случайное смещение от 0 до 1
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	# Создаёт моба, добавив его на главную сцену
	add_child(mob)


func _on_player_hit():
	$MobTimer.stop()
