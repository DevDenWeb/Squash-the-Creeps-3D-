extends CharacterBody3D

# Скорость движения игрока в метрах в секунду.
@export var speed = 14
# Ускорение падения в воздухе, в метрах в секунду в квадрате.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# Создаём локальную переменную для хранения направления ввода.
	var direction = Vector3.ZERO
	# Проверяем каждый ввод движения и соответствующим образом обновляем направление.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_right"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Установка базового свойства повлияет на поворот узла.
		$Pivot.basis = Basis.looking_at(direction)

	# Скорость относительно земли
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Вертиканая скорость
	if not is_on_floor(): # Если в воздухе, падай к полу. Буквально гравитация
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Перемещение персонажа
	velocity = target_velocity
	move_and_slide()
