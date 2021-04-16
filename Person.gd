class_name Person
extends Entity
onready var space = get_tree().get_root().get_node("GAME")

var debug_string = ""
var currentShip = null

var availableInteractables = []
var currentInteractable = null

const movementSpeed = 2.0
        
var isViewLockedOnMouse = false  

func processMovement(delta):
    var velocityAbsolute = Vector2(0, 0)
    
    while !gatheredInputs.empty():
        match gatheredInputs.front():
            cons.PLAYER_USE:
                print("HALKO UZYWAMY ", availableInteractables.back())
            cons.PLAYER_MOVE_FORWARD:
                velocityAbsolute.y -= 1
            cons.PLAYER_MOVE_BACKWARD:
                velocityAbsolute.y += 1
            cons.PLAYER_MOVE_RIGHT:
                velocityAbsolute.x += 1
            cons.PLAYER_MOVE_LEFT:
                velocityAbsolute.x -= 1
            _:
                print(gatheredInputs.front(), " !"); breakpoint
        gatheredInputs.pop_front()

    velocityAbsolute = velocityAbsolute.normalized() * movementSpeed
    velocityAbsolute = velocityAbsolute.rotated(deg2rad(rotation_degrees + get_parent().rotation_degrees))
    var collision = move_and_collide(velocityAbsolute, true, true, false)
    animate(velocityAbsolute)
    
func animate(velocityAbs):
    var kinematicInfo = getKinematicInfo()
    rad2deg((space.get_global_mouse_position() - kinematicInfo["positionAbs"]).angle())
    
    $AnimatedSprite.animate(velocityAbs)


func custom_physics_process(delta):
    if (!movementPaused): processMovement(delta)
# --------------------------------------------
func enterShip(ship: Ship):
    currentShip = ship
    utils.reparent(self, ship)
    ship.passengerEntered(self)

func addAvailableInteractable(node:Node):
    availableInteractables.append(node)
    
func removeAvailableInteractable(node:Node):
    var position = availableInteractables.find(node)
    if position >= 0: availableInteractables.remove(position)


func getKinematicInfo():
    var kinematicInfo = get_parent().getKinematicInfo()
    kinematicInfo["positionAbs"] += position
    kinematicInfo["rotationAbs"] += rotation_degrees
    return kinematicInfo
