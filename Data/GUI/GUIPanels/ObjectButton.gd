tool
extends Button

export (Color) var yellow
export (Color) var white

export(String) var nameLabel = "" setget setName
export(Vector2) var iconSizeBoundaries = Vector2(100, 100) setget setIconSizeBoundaries
export(Texture) var displayedTile = null setget displayTexture

func setName(newName):
    nameLabel = newName
    if $Name:
        $Name.set_text(newName)

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
        

func displayTexture(newTexture):
    #if(Engine.is_editor_hint()):
    displayedTile = newTexture
    
    if $Icon:
        $Icon.set_texture(displayedTile)
        updateIconSize()
        set_disabled(true if displayedTile == null else false)

func setIconSizeBoundaries(newBoundaries):
    iconSizeBoundaries = newBoundaries
    if $Icon:
        updateIconSize()

func _on_Button_mouse_entered():
    $Name.add_color_override("font_color", white)

func _on_Button_mouse_exited():
    $Name.add_color_override("font_color", yellow)


signal objectSelected(button, button_pressed)

func _on_Button_toggled(button_pressed):
    emit_signal("objectSelected", self, button_pressed)
