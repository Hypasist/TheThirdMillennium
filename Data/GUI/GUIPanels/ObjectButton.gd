tool
extends Button

export(String) var nameLabel = "" setget setName
func setName(newName):
    nameLabel = newName
    if $Name:
        $Name.set_text(newName)

export(Vector2) var iconSizeBoundaries = Vector2(100, 100) setget setIconSizeBoundaries
func updateIconSize():
    var texture = $Icon.get_texture()
    if texture:
        var textureSize = texture.get_size()
        var scale = null
        
        if(textureSize.x >= textureSize.y):
            scale = iconSizeBoundaries.x / textureSize.x
        else:
            scale = iconSizeBoundaries.y / textureSize.y
            
        $Icon.set_pivot_offset(textureSize/2)
        $Icon.set_scale(Vector2(scale, scale)) 
        $Icon.set_v_grow_direction(GROW_DIRECTION_BOTH)
        $Icon.set_h_grow_direction(GROW_DIRECTION_BOTH)
        
func setTexture(textureSource):
    var image = Image.new()
    var err = image.load(textureSource)
    if err != OK:
        print("Couldn't load the texture! ", textureSource)
        breakpoint
    var texture = ImageTexture.new()
    texture.create_from_image(image, 0)
    displayTexture(texture)

export(Texture) var displayedTile = null setget displayTexture
func displayTexture(newTexture):
    #if(Engine.is_editor_hint()):
    displayedTile = newTexture
    
    if $Icon:
        $Icon.set_texture(displayedTile)
        updateIconSize()
        set_disabled(true if displayedTile == null else false)

var recordRepresented = null
func setRecord(_recordRepresented):
    recordRepresented = _recordRepresented
func getRecord():
    return recordRepresented

func setIconSizeBoundaries(newBoundaries):
    iconSizeBoundaries = newBoundaries
    if $Icon:
        updateIconSize()

func _on_Button_mouse_entered():
    $Name.add_color_override("font_color", Color.white)

func _on_Button_mouse_exited():
    $Name.add_color_override("font_color", Color.goldenrod)

signal objectSelected(button, button_pressed)
func _on_Button_toggled(button_pressed):
    emit_signal("objectSelected", self, button_pressed)
