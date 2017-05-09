$ ->
    initGraph()
    console.log("boba is yummy (initGraph)")
    
    test()

###################
# GLOBAL VARIABLES
###################

vars =
    chargeVal: -50
    width: 600
    height: 500
    radius: 15
    fill: "#000"

# selected, mouse down/up
graphVars =
    graph: null
    nodeS: null
    linkS: null
    nodeMD: null
    linkMD: null
    nodeMU: null
    attr: [vars.fill]

d3Vars =
    svg: null
    nodes: null
    edges: null

###################
# d3 FUNCTIONS
###################
    
initGraph = () ->
    d3Vars.svg = d3.select("#graph").append("svg")
        .attr("width", vars.width)
        .attr("height", vars.height)
        .style("fill", "none")
        .on("click", onClick)
    graphVars.graph = new Graph [], [], []

onClick = () ->
    coords = d3.mouse this
    [x, y] = coords
    node = new Node nodeGenID(), x, y, graphVars.attr
    graphVars.graph.addNode node
    redraw()

onClickNode = () ->
    circle = d3.select(this)
    node = circle.data()[0]
    
    nodeS = node # selected node update
    node.setFill "#CEF"
    
    # if circle.attr("id") == node.id
    redraw()
    # console.log node.id

redraw = () ->
    drawGraph graphVars.graph, d3Vars.svg
    console.log "boba is sweet (redraw)"
    
###################
# GRAPH UTILITIES
###################

###
Graph object
Params:
    nodes: list of Node objects
    edges: list of Edge objects
###
class Graph
    constructor: (@nodes, @edges, @attr) ->
    # addNode appends a new node to nodes
    addNode: (node) ->
        @nodes.push node
    # addEdge appends a new edge to edges
    addEdge: (edge) ->
        @edges.push edge

###
Edge object
Params:
    id: unique identifier
    source: source Node object
    target: target Node object
    attr: list is attributes
###
class Edge
    constructor: (@id, @source, @target, @attr) ->
    
###
Node object
Params:
    id: unique identifier
    x, y: locations
    attr: list of attributes
###
class Node
    constructor: (@id, @x, @y, @attr) ->
    getFill: () -> @attr[0]
    setFill: (fill) -> @attr[0] = fill

drawGraph = (graph, svg) ->
    svg.selectAll("*").remove() # clear
    graphVars.graph = graph # set new graph
    edges = svg.selectAll("link")
        .data(graph.edges).enter()
        .append("line")
        .attr("class","edge")
        .attr("x1", (edge) -> edge.source.x)
        .attr("y1", (edge) -> edge.source.y)
        .attr("x2", (edge) -> edge.target.x)
        .attr("y2", (edge) -> edge.target.y)
        .style("fill", "none")
        .attr("stroke", "#000")
        .attr("stroke-width", "5")
    nodes = svg.selectAll("node")
        .data(graph.nodes).enter()
        .append("circle")
        .attr("class", "circle")
        .attr("cx", (node) -> node.x)
        .attr("cy", (node) -> node.y)
        .attr("r", vars.radius)
        .attr("id", (node) -> node.id)
        .style("fill", (node) -> node.getFill())
    svg.selectAll("circle")
        .on("mouseover", onClickNode)
    console.log("boba is delicious (drawGraph)")
    
nodeGenID = () -> Math.random().toString(36).substr(2, 5)
    
test = () ->
    nodes = []
    for n in [0 .. 9]
        node = new Node nodeGenID(), 100+n*Math.random()*100, 100+n*Math.random()*100, graphVars.attr.slice()
        nodes.push node
        
    edges = []
    for i in [0 ... 8]
        node1 = nodes[i]
        node2 = nodes[i+1]
        edges.push new Edge nodeGenID(), node1, node2, 1

    graph = new Graph nodes, edges

    drawGraph(graph, d3Vars.svg)


###################
# GRAPH CLASSES
###################


###
Constructor for Graph object
Params:
    nodes: list of Node objects
    edges: list of Edge objects
###
export class Graph
    constructor: (@nodes, @edges, @attr) ->

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



class PebbleGraph extends Graph
    constructor: (@nodes, @edges, @attr) ->
        super(@nodes, @edges, @attr)
        @attr._pebbleIndex = {vertex: [-1, -1] for vertex in @nodes}

    pebbleIndex: () ->
        return @attr._pebbleIndex

    _reassignPebble: (vertex, oldval, newval) ->
        index = @attr._pebbleIndex[vertex].indexOf(edge)
        if index == -1
            return false
        
        @attr._pebbleIndex[vertex][index] = newval
        return true

    allocatePebble: (vertex, edge) ->
        if vertex not in [edge.source, edge.target]
            raise ValueError("Edge #{edge} not incident to vertex #{vertex}")
        return this._reassignPebble(vertex, -1, edge)

    reallocatePebble: (vertex, oldedge, newedge) ->
        if vertex not in [edge.source, edge.target]
            raise ValueError("Edge #{edge} not incident to vertex #{vertex}")
        return this._reassignPebble(vertex, oldedge, newedge)

    hasFreePebble: (vertex) ->
        return -1 != @attr._pebbleIndex[vertex].indexOf(-1)

    pebbledEdgesAndNeighbors: (vertex) ->
        otherVertex = (edge) ->
            return [x for x in [edge.source, edge.target] when x isnt vertex][0]

        pebbleAssignments = this.pebbleIndex[vertex]
        return [[otherVertex(e), e] for e in pebbleAssignments when e isnt -1]
    

    ###
    Cover enlargement for the pebble algorithm.
    Params:
         graph: trivial
         edge: Edge object we'd like to cover with pebbles.
    ###
    enlargeCover: (edge) ->
        seen = {vertex: false for vertex in @nodes}
        path = {vertex: -1 for vertex in @nodes}
    
        [left, right] = [edge.source, edge.target]
        found = this.findPebble(left, seen, path)
        if found
            this.rearrangePebbles(left, seen)
            return true
        
        if not seen[right]
            found = this.findPebble(right, seen, path)
            if found
                this.rearrangePebbles(right, path)
                return true
    
        return false
    
    
    findPebble: (vertex, seen, path) ->
        seen[vertex] = true
        path[vertex] = -1
        if this.hasFreePebble(vertex)
            return true
    
        # taken from the paper; probably should clean up code smell
        [[x, xedge], [y, yedge]] = this.pebbledEdgesAndNeighbors(vertex)
        if not seen[x]
            path[vertex] = [x, xedge]
            if this.findPebble(x, seen, path)
                return true
        if not seen[y]
            path[vertex] = [y, yedge]
            if this.findPebble(y, seen, path)
                return true
        return false
    
    
    rearrangePebbles: (vertex, path) ->
        while (path[vertex] != -1)
            [w, edge] = path[vertex]
            if path[w] == -1
                this.allocatePebble(w, edge)
            else
                [_, oldedge] = path[w]
                this.reallocatePebble(w, oldedge, edge)
            vertex = w
    

