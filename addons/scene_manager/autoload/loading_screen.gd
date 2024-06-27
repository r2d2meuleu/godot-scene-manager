class_name LoadingScreenBase extends Control

## Loading Screen setting name.
const SETTING_NAME := "addons/scene_manager/loading_screen"
## Default Loading Screen scene path.
const SETTING_DEFAULT_VALUE := "res://addons/scene_manager/autoload/loading_screen.tscn"

## LoadingScreen base class
## 
## Extend this class and override methods to create a custom loading screen.
## Change "addons/scene_manager/loading_screen" Project setting to load your
## scene.

## Property used to store the tween which does smooth progress change.
var _range_tween: Tween


## Range node to show the progress. Overrides the method to change the node.[br]
## This node must have [code]value[/code] property to show progress.
func _get_range_node() -> Node:
	return get_node("ProgressBar")

## Handle the load scene error. You can override this method to show on screen
## an error.
func handle_load_error() -> void:
	push_error("Scene load error. Override LoadingScreenBase.handle_load_error to show error on your custom screen.")

## Percent must be a value between 0.0 and 100.0. Ensure your custom range
## node has a [code]value[/code] property with float values between 0 and 100.
func set_progress(percent: float) -> void:
	var tween_duration := _get_tween_duration()
	
	var range := _get_range_node()
	if "value" in range:
		if tween_duration > 0.0:
			if _range_tween and _range_tween.is_running():
				_range_tween.kill()
			
			_range_tween = range.create_tween()
			_range_tween.tween_property(range, "value", percent, tween_duration)
		else:
			range.value = percent
	else:
		push_warning("'value' property doesn't exist.")

## Time it takes to reach the new value. Overrides the method to change the
## value. If the value is 0.0 or negative, it sets property immediately.
func _get_tween_duration() -> float:
	return 0.25