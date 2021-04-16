extends MarginContainer

var buttonID = null
func setID(_ID):
    buttonID = _ID

export (String) var displayedText = "" setget setText
func setText(text):
    displayedText = text
    reshapeButton()

const defaultSize = 22
export var fontSize = defaultSize setget setFontSize
func setFontSize(size):
    fontSize = size
    reshapeButton()

func reshapeButton():
    $Button.get("custom_fonts/font").set_size(fontSize)
    $Button.set_text(displayedText)

signal objectSelected(button)
func _on_Button_pressed():
    emit_signal("objectSelected", buttonID)

func _on_Button_mouse_entered():
    $Button.get("custom_fonts/font").add_color_override("font_color", Color.white)
 
func _on_Button_mouse_exited():
    $Button.get("custom_fonts/font").add_color_override("font_color", Color.goldenrod)
