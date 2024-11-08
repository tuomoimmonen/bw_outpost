extends ProgressBar

@onready var health_text: Label = %HealthText

func _ready() -> void:
	var health = get_parent().get_node("Health")
	health.on_change.connect(on_health_change)
	on_health_change(health.current, health.max)

func on_health_change(current : int, max : int):
	max_value = max
	value = current
	health_text.text = str(current) + "/" + str(max)
