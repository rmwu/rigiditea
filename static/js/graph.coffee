###
Constructor for Graph object
Params:
    nodes: list of Node objects
    edges: list of Edge objects
###
graph = (nodes, edges) ->
    this.nodes = nodes
    this.edges = edges
    true

###
Constructor for Edge object
Params:
    id: unique identifier
    source: source Node object
    target: target Node object
    attr: list is attributes
###
edge = (id, source, target, attr) ->
    this.id = id
    this.source = source
    this.target = target
    this.attr = attr
    id
    
###
Constructor for Node object
Params:
    id: unique identifier
    x, y: locations
    attr: list of attributes
###
node = (id, x, y, attr) ->
    this.id = id
    this.x = x
    this.y = y
    this.attr = attr
    id