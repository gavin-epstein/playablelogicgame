extends RichTextLabel

func _edited():
	for child in get_parent().get_children():
		if child is Gate and child.exploded:
			get_parent().win()
