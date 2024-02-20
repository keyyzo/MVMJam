extends PanelContainer

@onready var property_container = %VBoxContainer

#var property
var frames_per_second : String

func _ready() -> void:
	
	# Set global reference to self in Global Singleton
	Global.debug = self
	
	visible = false
	
	#add_debug_property("FPS",frames_per_second)
	
func _process(delta: float) -> void:
	if visible:
		
		frames_per_second = "%.2f" % (1.0/delta) # Gets frames per second every frame	
	
#		property.text = property.name + ": " + frames_per_second

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = !visible

func add_property(title : String, value, order):
	var target
	target = property_container.find_child(title, true, false) # try to find label node with same name
	
	if !target: # if there is no current label node for property (ie. initial load)
		target = Label.new() # Create new label node
		property_container.add_child(target) # add new node as child to vbox container
		target.name = title # set name to title
		target.text = target.name + ": " +str(value) # set text value
	elif visible:
		target.text = title + ": " +str(value) # update  text value
		property_container.move_child(target,order) # reorder property based on given order value

#func add_debug_property(title : String, value):
	#property = Label.new() # Create new Label node
	#property_container.add_child(property) # Add new node as child to VBox container
	#property.name = title # Set name as title
	#property.text = property.name + value
