extends Node2D


func _on_KinematicBody2D_debugLine_draw(v1, v2, colour, width, antialiasing):
    var vector = [v1, v2, colour, width, antialiasing]
    vectorList.append(vectorList)
    _draw()