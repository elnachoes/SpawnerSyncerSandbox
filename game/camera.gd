class_name MultiTargetCamera
extends Camera2D

@export var smooth_zoom = true


func show_all_targets(targets: Array):
	var num_targets = targets.size()
	if num_targets == 0:
		return
	
	var pos = Vector2()
	
	var max_x = -INF
	var max_y = -INF
	var min_x = INF
	var min_y = INF

	for target in targets:
		pos += target.position
		
		max_x = max(max_x, target.position.x)
		max_y = max(max_y, target.position.y)
		min_x = min(min_x, target.position.x)
		min_y = min(min_y, target.position.y)
	
	position = pos / num_targets
	
	var furthest_x = 2 * max(max_x - pos.x, pos.x - min_x)
	var furthest_y = 2 * max(max_y - pos.y, pos.y - min_y)
	
	var ratio_x = DisplayServer.window_get_size().x / furthest_x
	var ratio_y = DisplayServer.window_get_size().y / furthest_y
	
	var best_ratio = min(ratio_x, ratio_y)
	var new_zoom = Vector2(best_ratio, best_ratio)
	if new_zoom > Vector2.ONE:
		new_zoom = Vector2.ONE
	
	if smooth_zoom:
		zoom = zoom.lerp(new_zoom, 0.05)
	else:
		zoom = new_zoom
