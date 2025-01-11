extends CharacterBody3D

# Скорость движения игрока в метрах в секунду.
@export var speed = 14
# Ускорение падения в воздухе, в метрах в секунду в квадрате.
@export var fall_acceleration = 75
# Вертикальный толчок, применяемый к персонажу при прыжке, в метрах в секунду.
@export var jump_impulse = 20
# Вертикальный толчок, применяемый к персонажу при прыжке через моба, в метрах в секунду.
@export var bounce_impulse = 16

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
	if Input.is_action_pressed("move_forward"):
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
	
	# Прыжки
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# Перебрать все столкновения, произошедшие в этом кадре
	for index in range(get_slide_collision_count()):
		# Получаем одно из столкновений с игроком
		var collision = get_slide_collision(index)
		
		# Если столкновение произошло с землей
		if collision.get_collider() == null:
			continue
		# Если столкновение с мобом
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# Проверяет, что удар наносится сверху
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# Если да, то мы его раздавливаем и отскакиваем
				mob.squash()
				target_velocity.y = bounce_impulse
				# Предотвращает дальнейшие дублирующие вызовы
				break
	
	
	move_and_slide()
