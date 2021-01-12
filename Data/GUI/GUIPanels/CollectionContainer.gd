extends ScrollContainer

var currentlySelected = null
func _on_Button_objectSelected(button, button_pressed):
    if currentlySelected:
        currentlySelected.pressed = false
        
    if button_pressed:
        currentlySelected = button
    else:
        currentlySelected = null
