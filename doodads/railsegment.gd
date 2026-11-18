@tool
class_name RailSegment extends Node2D

func setcolor(color:Color, word:String):
		$Panel.self_modulate = color;
		$Panel/RichTextLabel.self_modulate = color;
		$Panel/RichTextLabel.text = word;
