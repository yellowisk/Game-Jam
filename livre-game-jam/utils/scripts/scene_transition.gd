extends CanvasLayer

func change_scene(target: PackedScene) -> void:
	$AnimationPlayer.play('dissolve')
	#await $AnimationPlayer.animation_finished()
	get_tree().change_scene_to_packed(target)
	$AnimationPlayer.play_backwards('dissolve')
