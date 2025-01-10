extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18

func _physics_process(_delta):
	move_and_slide()

# Эта функция будет вызываться из главной сцены
func initialize(start_position, player_position):
	# Размещаем моба, помещая его в start_position и поворачиваем его в сторону player_position, чтобы он смотрел на игрока
	look_at_from_position(start_position, player_position, Vector3.UP)
	# Поворачивайте этого моба случайным образом в диапазоне от -45 до +45 градусов, чтобы он не двигался прямо на игрока
	rotate_y(randf_range(-PI / 4, PI / 4))
	
	# Вычесляем случайную скорость (целое число)
	var random_speed = randi_range(min_speed, max_speed)
	# Вычесляем поступательную скорость, которая педставляет собой скорость
	velocity = Vector3.FORWARD * random_speed
	# Вращаем вектор скорости на основе вращения моба по оси Y для того, чтобы двигаться в направлении, куда смотрит моб
	velocity = velocity.rotated(Vector3.UP, rotation.y)
