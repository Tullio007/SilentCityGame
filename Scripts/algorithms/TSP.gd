class_name TSP
extends RefCounted


static func solve(points: Array[Vector2]) -> Dictionary:
	if points.size() <= 1:
		return {
			"route": [0],
			"cost": 0.0
		}

	if points.size() <= 12:
		return _held_karp(points)

	return _heuristic(points)


static func _distance_matrix(points: Array[Vector2]) -> Array:
	var matrix: Array = []

	for i in range(points.size()):
		var row: Array = []

		for j in range(points.size()):
			row.append(points[i].distance_to(points[j]))

		matrix.append(row)

	return matrix


static func _held_karp(points: Array[Vector2]) -> Dictionary:
	var n: int = points.size()
	var dist: Array = _distance_matrix(points)

	var dp := {}
	var parent := {}

	for k in range(1, n):
		var mask := 1 << k
		dp[[mask, k]] = dist[0][k]

	for subset_size in range(2, n):
		var subsets := _generate_subsets(n, subset_size)

		for subset in subsets:
			for j in range(1, n):

				if (subset & (1 << j)) == 0:
					continue

				var prev_mask := subset & ~(1 << j)

				var best_cost := INF
				var best_prev := -1

				for k in range(1, n):

					if k == j:
						continue

					if (prev_mask & (1 << k)) == 0:
						continue

					var key = [prev_mask, k]

					if not dp.has(key):
						continue

					var cost = dp[key] + dist[k][j]

					if cost < best_cost:
						best_cost = cost
						best_prev = k

				dp[[subset, j]] = best_cost
				parent[[subset, j]] = best_prev

	var full_mask := 0

	for i in range(1, n):
		full_mask |= (1 << i)

	var best_cost := INF
	var last_city := -1

	for j in range(1, n):
		var key = [full_mask, j]

		if not dp.has(key):
			continue

		var cost = dp[key]

		if cost < best_cost:
			best_cost = cost
			last_city = j

	var route: Array[int] = []
	var current := last_city
	var mask := full_mask

	while current != -1:
		route.push_front(current)

		var parent_key = [mask, current]

		var prev: int = parent.get(parent_key, -1)

		mask &= ~(1 << current)

		current = prev

	route.push_front(0)

	return {
		"route": route,
		"cost": best_cost
	}


static func _generate_subsets(n: int, size: int) -> Array[int]:
	var result: Array[int] = []

	_generate_subsets_recursive(1, n, size, 0, 0, result)

	return result


static func _generate_subsets_recursive(
	start: int,
	n: int,
	target_size: int,
	current_size: int,
	mask: int,
	result: Array[int]
) -> void:

	if current_size == target_size:
		result.append(mask)
		return

	for i in range(start, n):
		_generate_subsets_recursive(
			i + 1,
			n,
			target_size,
			current_size + 1,
			mask | (1 << i),
			result
		)


static func _nearest_neighbor(points: Array[Vector2]) -> Array[int]:
	var n := points.size()

	var visited: Array[bool] = []
	visited.resize(n)

	for i in range(n):
		visited[i] = false

	var route: Array[int] = [0]
	visited[0] = true

	while route.size() < n:

		var current := route[-1]

		var best_city := -1
		var best_distance := INF

		for i in range(n):

			if visited[i]:
				continue

			var d := points[current].distance_to(points[i])

			if d < best_distance:
				best_distance = d
				best_city = i

		visited[best_city] = true
		route.append(best_city)

	return route


static func _two_opt(route: Array[int], points: Array[Vector2]) -> Array[int]:

	var improved := true

	while improved:

		improved = false

		for i in range(1, route.size() - 2):

			for j in range(i + 1, route.size() - 1):

				var a := route[i - 1]
				var b := route[i]
				var c := route[j]
				var d := route[j + 1]

				var current_cost := \
					points[a].distance_to(points[b]) + \
					points[c].distance_to(points[d])

				var new_cost := \
					points[a].distance_to(points[c]) + \
					points[b].distance_to(points[d])

				if new_cost < current_cost:

					var new_route: Array[int] = []

					for k in range(i):
						new_route.append(route[k])

					for k in range(j, i - 1, -1):
						new_route.append(route[k])

					for k in range(j + 1, route.size()):
						new_route.append(route[k])

					route = new_route
					improved = true

	return route


static func _heuristic(points: Array[Vector2]) -> Dictionary:

	var route: Array[int] = _nearest_neighbor(points)

	route = _two_opt(route, points)

	var cost := 0.0

	for i in range(route.size() - 1):
		cost += points[route[i]].distance_to(points[route[i + 1]])

	return {
		"route": route,
		"cost": cost
	}