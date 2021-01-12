extends KinematicBody2D

var KinematicType = preload("res://Kinematic.gd")
var utils = preload("res://Utils.gd")
var kinematic = null
var debug = null
var sceneNodes = []

func _init(): #create new ship

    kinematic = KinematicType.new(null, 1, null, 0.85)
# -- 0/3 -- main
    sceneNodes.append({})
    var node = Sprite.new()
    node.set_texture(load("res://assets/art/ship3.png"))
    sceneNodes.back()["sprite"] = node
    add_child(node)

    node = CollisionShape2D.new()
    node.set_shape(RectangleShape2D.new())
    node.shape.set_extents(Vector2(80,40))
    sceneNodes.back()["collision"] = node
    add_child(node)
    
    sceneNodes.back()["relativePosition"] = Vector2(0,0)
    kinematic.addMass(10, sceneNodes.back()["relativePosition"])
    
# -- 1/3 -- left engine
    sceneNodes.append({})
    node = Sprite.new()
    node.set_texture(load("res://assets/art/ship2.png"))
    sceneNodes.back()["sprite"] = node
    add_child(node)
    
    node = CollisionShape2D.new()
    node.set_shape(RectangleShape2D.new())
    node.shape.set_extents(Vector2(30,15))
    sceneNodes.back()["collision"] = node
    add_child(node)
    
    sceneNodes.back()["relativePosition"] = Vector2(-40,20)
    kinematic.addMass(4, sceneNodes.back()["relativePosition"])
    
# -- 2/3 -- left engine
    sceneNodes.append({})
    node = Sprite.new()
    node.set_texture(load("res://assets/art/ship1.png"))
    sceneNodes.back()["sprite"] = node
    add_child(node)
    
    node = CollisionShape2D.new()
    node.set_shape(RectangleShape2D.new())
    node.shape.set_extents(Vector2(30,15))
    sceneNodes.back()["collision"] = node
    add_child(node)
    
    sceneNodes.back()["relativePosition"] = Vector2(-40,-20)
    kinematic.addMass(4, sceneNodes.back()["relativePosition"])
    
# -- 3/3 -- ping massCentre
    sceneNodes.append({})
    node = Sprite.new()
    node.set_texture(load("res://assets/art/ping.png"))
    sceneNodes.back()["sprite"] = node
    node.set_name("ping")
    add_child(node)
    
    sceneNodes.back()["relativePosition"] = kinematic.getMassCenter()
    
func _ready():
    for i in range(sceneNodes.size()):
        if sceneNodes[i].has("sprite"):
            sceneNodes[i]["sprite"].position = sceneNodes[i]["relativePosition"] - kinematic.getMassCenter()
        if sceneNodes[i].has("collision"):
            sceneNodes[i]["collision"].position = sceneNodes[i]["relativePosition"] - kinematic.getMassCenter()
            
    kinematic.setPositionAll(position.x, position.y, rotation_degrees)
    kinematic.setMomentumRelative(Vector2(0, 0))
    kinematic.setMomentumRotational(0.5)
    
    debug = get_parent().get_node("debugLines")

func _process(delta):
    var positionDeltaObject = kinematic.processMovement(delta)
    rotation_degrees = positionDeltaObject[1]
    var collision = move_and_collide(positionDeltaObject[0], true, true, false )
    
