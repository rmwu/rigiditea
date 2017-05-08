###
Constructor for Graph object
Params:
    nodes: list of Node objects
    edges: list of Edge objects
###
class Graph
    constructor: (@nodes, @edges) ->

###
Constructor for Edge object
Params:
    id: unique identifier
    source: source Node object
    target: target Node object
    attr: list is attributes
###
class Edge
    constructor: (@id, @source, @target, @attr) ->
    
###
Constructor for Node object
Params:
    id: unique identifier
    x, y: locations
    attr: list of attributes
###
class Node
    constructor: (@id, @x, @y, @attr) ->