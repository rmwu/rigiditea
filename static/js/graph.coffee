###
Constructor for Graph object
Params:
    nodes: list of Node objects
    edges: list of Edge objects
###
graph = (nodes, edges) ->
    this.nodes = nodes
    this.edges = edges

###
Constructor for Edge object
Params:
    source: source Node object
    target: target Node object
    weight: numeric
###
edge = (source, target, weight) ->
    this.source = source
    this.target = target
    this.weight = weight
    
###
Constructor for Node object
Params:
    name: string name
    position: tuple of (x,y)
    attr: list of attributes
###
node = (name, position, attr) ->
    this.name = name
    this.x = position[0]
    this.y = position[1]
    this.attr = attr