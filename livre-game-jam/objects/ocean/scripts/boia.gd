extends Floatable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position.y = Ocean.get_height(self.global_position)
