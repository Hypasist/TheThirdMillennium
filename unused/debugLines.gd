extends Node2D

var vectorList = Array()

func _ready():
    pass
    
func _draw():
    for i in range(vectorList.size()):
        var a = vectorList[i]
        draw_line(a[0], a[1], a[2], a[3], a[4])
        
func addLines(s,l,c,w,a):
    vectorList.append([s,s+10*l,c,w,a])
    update()
    
func cleanLines():
    vectorList.clear()
    update()
