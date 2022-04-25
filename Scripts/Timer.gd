extends CanvasLayer


var timer = 0
var enemyCountTotal = 0
var enemyKilled = 0

func _ready():
	enemyCountTotal = get_tree().get_root().get_node("MainGame").get_node("ENEMIES").get_child_count()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	$TimerTXT.set_text(str(floor(timer)))
	$EnemyCountTXT.set_text(str(enemyKilled)+"/"+str(enemyCountTotal))

func increaseEnemyKilled():
	enemyKilled += 1
	
