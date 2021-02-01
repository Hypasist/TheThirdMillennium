class_name CustomCamera
extends Camera2D

const utils = preload("res://Data/Utils/Utils.gd")
const TweenType = preload("res://Data/Utils/CustomTween2.gd")
var zoomTween = null

var followedEntity = null

var halfScreenResolution = OS.get_window_size()/2
var minPeekLength = 0.3 * halfScreenResolution.length()
var maxPeekLength = 0.5 * halfScreenResolution.length()

var minZoom = Vector2(0.5, 0.5)
var maxZoom = Vector2(8.0, 8.0)
var zoomJump = Vector2(0.5, 0.5)
var targetZoom = null
var zoomTime = 0.25
var zoomCount = 0

func _ready():
    zoomTween = TweenType.new()
    add_child(zoomTween)
    
func zoomChange(value:int):
    zoomCount += value

func zoomSlide():
    if zoomCount != 0:
        if !targetZoom: targetZoom = zoom
        
        targetZoom = utils.clamp2(targetZoom + zoomCount * zoomJump, minZoom, maxZoom)
        zoomTween.initialize(self, "zoom", zoom, targetZoom, zoomTime, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
        zoomTween.start_normal(zoom)
        zoomCount = 0

func assign2Person(personNode):
    followedEntity = personNode
