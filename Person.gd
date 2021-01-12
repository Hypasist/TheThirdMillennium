class_name Person
extends Entity

var debug_string = ""
var currentShip = null

var availableInteractables = []
var currentInteractable = null

const movementSpeed = 2.0

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
