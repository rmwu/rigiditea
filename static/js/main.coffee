$ ->
    initGraph()
    console.log("boba is yummy (initGraph)")
    
    # test()

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
    
    canSelect: true # mutex style flags
    canAdd: true
    
    mouseDown: false # flags for mouse events
    mouseUp: true
    mouseOut: true
    mouseEnter: false
    
    nodeS: null # selected (clicked)
    edgeS: null
    nodeME: null # mouseenter
    
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
        .on("mouseup", onMouseUpNode)
    graphVars.graph = new Graph [], [], []

onClick = () ->
    coords = d3.mouse this
    [x, y] = coords
    if graphVars.canAdd
        node = new Node nodeGenID(), x, y, graphVars.attr.slice()

        graphVars.graph.addNode node
        graphVars.canSelect = false
        # prevent selection of newly added node

        redraw()
    
onMouseDown = () ->
    coords = d3.mouse this
    [x, y] = coords

onClickNode = () ->
    if graphVars.canSelect
        toggleSelect(this)
    
onMouseDownNode = () ->
    # don't add new node when selecting
    graphVars.canAdd = false
    graphVars.mouseDown = true
    graphVars.mouseUp = false
            
onMouseUpNode = () ->
    graphVars.mouseDown = false
    graphVars.mouseUp = true
    
    console.log "thai milk tea (mouse up)"
    if graphVars.edgeS != null
        if graphVars.mouseEnter
            drawEdgeEnd()
         else
            drawEdgeDrop()

# must leave current node to perform new actions
onMouseOutNode = () ->
    graphVars.canSelect = true
    graphVars.canAdd = true
    graphVars.mouseOut = true
    graphVars.mouseEnter = false
        
    if graphVars.mouseDown
        drawEdgeStart()
    
onMouseEnterNode = () ->
    graphVars.mouseOut = false
    graphVars.mouseEnter = true
    
    graphVars.nodeME = d3.select(this).data()[0]

redraw = () ->
    drawGraph graphVars.graph, d3Vars.svg
    console.log "boba is sweet (redraw)"
    
###################
# GRAPH UTILITIES
###################

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
        .on("click", onClickNode)
        .on("mousedown", onMouseDownNode)
        .on("mouseup", onMouseUpNode)
        .on("mouseout", onMouseOutNode)
        .on("mouseenter", onMouseEnterNode)
    # console.log("boba is delicious (drawGraph)")

# toggles currently selected node
toggleSelect = (circle) ->
    # reset old selected color
    if graphVars.nodeS != null
        graphVars.nodeS.setFill vars.fill

    node = d3.select(circle).data()[0]
    # deselect selected nodes
    if graphVars.nodeS == node
        graphVars.nodeS = null
    else
        graphVars.nodeS = node # selected node update
        node.setFill "#ADF"
    redraw()
    
nodeGenID = () -> Math.random().toString(36).substr(2, 5)

# three functions that work together to draw a new edge
drawEdgeStart = () ->
    console.log "panda milk tea (edge start)"
    source = graphVars.nodeS
    graphVars.edgeS = new Edge nodeGenID(), source
    
drawEdgeEnd = () ->
    console.log "milk grass jelly (edge end)"
    graphVars.edgeS.setTarget graphVars.nodeME
    graphVars.graph.addEdge graphVars.edgeS
    graphVars.edgeS = null
    
    redraw()
    
drawEdgeDrop = () ->
    console.log "hokkaido milk tea (edge drop)"
    graphVars.edgeS = null
    
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
    constructor: (@id, @source, @target = null, @attr = []) ->
    setTarget: (target) -> @target = target
    
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
    

