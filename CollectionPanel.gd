tool
extends NinePatchRect

const cons = preload("res://Data/Utils/Constants.gd")

export var paddingLeft = 50
export var paddingRight = 2
export var paddingTop = 40
export var paddingBotton = 20

export var minButtonWidth = 160
export var minColumnCount = 2

func _on_CollectionPanel_resized():
    var newSize = get_size()
    set_pivot_offset(newSize/2)
    _on_CollectionPanel_texture_changed()
    
    $CollectionContainer.set_position(Vector2(paddingLeft, paddingTop))
    $CollectionContainer.set_size(newSize - Vector2(paddingLeft + paddingRight, paddingTop + paddingBotton))
    
    var columnCount = max(floor($CollectionContainer.get_size().x / minButtonWidth), minColumnCount)
    $CollectionContainer/HBoxContainer/GridContainer.set_columns(columnCount)
    $CollectionPanelCollider.setNewCollisionShape(newSize)

func _on_CollectionPanel_texture_changed():
    set_custom_minimum_size(get_texture().get_size())
    
func doesContainPoint(point: Vector2):
    return $CollectionPanelCollider.doesCollisionShapeContain(point - get_position())
    
var panelHiddenPosition 
var panelShownPosition 
func _on_HideButton_pressed():
    $ShowButton.show()
    $ShowButton.set_disabled(true)
    $HideButton.hide()
    $HideButton.set_disabled(true)
    $SlideTween.start_normal(panelShownPosition)

func _on_ShowButton_pressed():
    $ShowButton.hide()
    $ShowButton.set_disabled(true)
    $HideButton.show()
    $HideButton.set_disabled(true)
    $SlideTween.start_reverse(panelHiddenPosition)

func _on_SlideTween_completed(object, key):
    $ShowButton.set_disabled(false)
    $HideButton.set_disabled(false)


var panelSlideTime = 0.7
var buttonMargin = 40
var tilesetDatabase = null
func setup(_tilesetDatabase):
    # ------- HIDE/SHOW
    panelShownPosition = get_position()
    panelHiddenPosition = get_position() + Vector2(get_size().x - buttonMargin, 0)
    $SlideTween.initialize(self, "rect_position", panelShownPosition, panelHiddenPosition, panelSlideTime, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    set_position(panelHiddenPosition)
    $HideButton.hide()

    # ------- SUPPLY
    tilesetDatabase = _tilesetDatabase
    for key in tilesetDatabase:
        var item = tilesetDatabase[key]
        if item["TileGroup"] != cons.FLOOR_GROUP:
            $CollectionContainer.addButton(item)


signal newRecordSelected(record)
func _on_CollectionContainer_newRecordSelected(record):
    emit_signal("newRecordSelected", record)
