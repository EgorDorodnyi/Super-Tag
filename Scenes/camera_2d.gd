extends Camera2D

@export var target_paths: Array[NodePath] = []    # drag your player nodes here (optional)
@export var use_group: bool = true
@export var group_name: String = "players"

@export var padding: Vector2 = Vector2(150, 100)
@export var min_zoom: float = 0.25
@export var max_zoom: float = 3.0
@export var move_smooth_speed: float = 6.0
@export var zoom_smooth_speed: float = 6.0

var _warned_no_targets: bool = false

func _ready():
	make_current()
	_warned_no_targets = false
	print("Camera ready. Group name = '%s'  target_paths size = %d" % [group_name, target_paths.size()])

func _process(delta: float) -> void:
	var targets = _gather_targets()
	if targets.empty():
		if not _warned_no_targets:
			push_warning("No camera targets found. Add players to group '%s' or drag them into Target Paths in the Camera inspector." % group_name)
			_warned_no_targets = true
		return
	_warned_no_targets = false

	# debug: list found targets
	var names = []
	for t in targets:
		names.append(t.name)
	print("Camera targets:", names)

	# bounding box of targets
	var min_p = Vector2(INF, INF)
	var max_p = Vector2(-INF, -INF)
	for t in targets:
		# make sure the target has a global_position (2D node). If not, we skip it.
		if not t.has_method("get_global_position") and not t.has_meta("global_position"):
			# Node types like Node3D won't work here
			push_warning("Target '%s' does not appear to be a 2D node with global_position — skipping." % t.name)
			continue
		var p = t.global_position
		min_p.x = min(min_p.x, p.x)
		min_p.y = min(min_p.y, p.y)
		max_p.x = max(max_p.x, p.x)
		max_p.y = max(max_p.y, p.y)

	var box_pos = min_p - padding
	var box_size = (max_p - min_p) + padding * 2.0
	var desired_center = box_pos + box_size * 0.5

	# Apply smoothing
	global_position = global_position.lerp(desired_center, clamp(move_smooth_speed * delta, 0.0, 1.0))

	# If camera limits are set, check if we're being clamped
	if limit_left != 0 or limit_top != 0 or limit_right != 0 or limit_bottom != 0:
		# print a one-time message about limits
		if not Engine.is_editor_hint():
			print("Camera limits: L:%d T:%d R:%d B:%d" % [limit_left, limit_top, limit_right, limit_bottom])

	# compute zoom (same logic as before)
	var viewport_px = get_viewport().get_visible_rect().size
	var world_w = max(box_size.x, 1.0)
	var world_h = max(box_size.y, 1.0)
	var scale_x = viewport_px.x / world_w
	var scale_y = viewport_px.y / world_h
	var desired_scale = min(scale_x, scale_y)
	desired_scale = clamp(desired_scale, min_zoom, max_zoom)
	var current_scale = zoom.x
	var new_scale = lerp(current_scale, desired_scale, clamp(zoom_smooth_speed * delta, 0.0, 1.0))
	zoom = Vector2(new_scale, new_scale)


func _gather_targets() -> Array:
	var out: Array = []
	# node path targets
	for p in target_paths:
		var n = get_node_or_null(p)
		if n:
			out.append(n)
	# group targets
	if use_group:
		for n in get_tree().get_nodes_in_group(group_name):
			if n and n not in out:
				out.append(n)
	return out
