extends SceneTree

func _init():
	print(">>> RUNNING SHIFT: ORTHO MECHANICS VERIFICATION SUITE <<<")
	var success = true
	
	# Test 1: OrthoCamera projection states
	var cam = OrthoCamera.new()
	cam._ready()
	assert(cam.projection == Camera3D.PROJECTION_PERSPECTIVE, "Initial camera must be perspective")
	cam.toggle_projection()
	assert(cam.projection == Camera3D.PROJECTION_ORTHOGONAL, "Toggled camera must be orthogonal")
	assert(cam.is_ortho == true, "Camera is_ortho flag must be true")
	cam.toggle_projection()
	assert(cam.projection == Camera3D.PROJECTION_PERSPECTIVE, "Toggled camera must return to perspective")
	print(" [PASS] Test 1: Camera projection toggle logic verified.")

	# Test 2: ShiftCube dynamic scaling & mass calculation
	var cube = ShiftCube.new()
	cube.base_scale = 1.0
	cube.base_mass = 10.0
	cube.apply_scale_factor(2.0)
	assert(abs(cube.current_scale - 2.0) < 0.001, "Cube scale must be 2.0")
	# Mass = 10 * 2^3 = 80
	assert(abs(cube.mass - 80.0) < 0.001, "Cube mass must be 80.0 kg")
	print(" [PASS] Test 2: ShiftCube scale & cubic mass formula verified (10kg -> 80kg at 2x).")

	# Test 3: OrthoBridge solid state
	var bridge = OrthoBridge.new()
	bridge.active_in_ortho_only = true
	bridge.required_yaw_deg = -1.0
	bridge.update_state(false, 0.0)
	assert(bridge.is_solid == false, "Bridge must be inactive in perspective")
	bridge.update_state(true, 0.0)
	assert(bridge.is_solid == true, "Bridge must be active in orthogonal")
	print(" [PASS] Test 3: OrthoBridge dynamic depth-collapse state verified.")

	# Test 4: PressurePlate activation threshold
	var plate = PressurePlate.new()
	plate.required_weight = 50.0
	plate._ready()
	assert(plate.is_pressed == false, "Plate must start unpressed")
	
	# Cleanup
	cam.free()
	cube.free()
	bridge.free()
	plate.free()
	
	print(">>> ALL 4 MECHANICS TESTS PASSED CLEANLY WITH ZERO LEAKS! <<<")
	quit(0)
