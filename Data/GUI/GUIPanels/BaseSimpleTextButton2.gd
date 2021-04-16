extends MarginContainer
tool
export (bool) var hasConstantWidth = false setget changeButtonType
func changeButtonType(isConstWidth):
    hasConstantWidth = isConstWidth
    reshapeButton()

export var constantWidth = 150 setget setConstantWidth
func setConstantWidth(width):
    constantWidth = width
    reshapeButton()

const defaultSize = 22
export var fontSize = defaultSize setget setFontSize
func setFontSize(size):
    fontSize = size
    reshapeButton()

const defaultTopBotMargin = 5 #
export var marginTopBot = defaultTopBotMargin setget setMarginTopBot
func setMarginTopBot(margin):
    marginTopBot = margin
    reshapeButton()
    
export (String) var displayedText = "" setget setText
func setText(text):
    displayedText = text
    reshapeButton()


const size2MarginDivider = 17 # approximation of extra size reserved by font, due to its size
func reshapeButton():
    $Button.get("custom_fonts/font").set_size(fontSize)
    
    $Button.set_text(displayedText)

    var newSize = Vector2(0,0)
    if hasConstantWidth:
        newSize.x = constantWidth
    else:
        newSize.x = get("custom_constants/margin_left") + get("custom_constants/margin_right")
        newSize.x += $Button.get_text().length() * fontSize
        
    newSize.y = get("custom_constants/margin_top") + get("custom_constants/margin_bottom")
    newSize.y += defaultTopBotMargin + floor((fontSize - defaultSize)/size2MarginDivider) + fontSize + 2 * marginTopBot
    set_size(newSize)


signal pressed
func _on_Button_pressed():
    emit_signal("pressed")
