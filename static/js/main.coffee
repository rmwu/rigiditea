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
    
    canSelect: true
    canAdd: true
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
    if graphVars.canAdd
        node = new Node nodeGenID(), x, y, graphVars.attr.slice()

        graphVars.graph.addNode node
        graphVars.canSelect = false
        # prevent selection of newly added node

        redraw()
    
onMouseDown = () ->
    coords = d3.mouse this
    [x, y] = coords
    
onMouseDownNode = () ->
    # don't add new node when selecting
    graphVars.canAdd = false
    if graphVars.canSelect
        # reset old selected color
        if graphVars.nodeS != null
            graphVars.nodeS.setFill vars.fill

        circle = d3.select(this)
        node = circle.data()[0]
        # deselect selected nodes
        if graphVars.nodeS == node
            graphVars.nodeS = null
        else
            graphVars.nodeS = node # selected node update
            node.setFill "#ADF"
        redraw()
            
onMouseUpNode = () ->
#    graphVars.canAdd = true

# must leave current node to perform new actions
onMouseOutNode = () ->
    graphVars.canSelect = true
    graphVars.canAdd = true

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
        .on("mousedown", onMouseDownNode)
        .on("mouseup", onMouseUpNode)
        .on("mouseout", onMouseOutNode)
    # console.log("boba is delicious (drawGraph)")
    
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
# NUMERIC ALGORITHMS
###################

###
Find the rank of a matrix; algorithm based on SVD.
Params:
    matrix: the matrix lmao
###
matrixRank = (matrix) ->
    # count nonzero singular values
    return [x for x in numeric.svd(matrix).S when x != 0].length



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
    Find the numer of infinitesimal degrees of freedom.
    Params:
        vertexConfiguration: associative array {node: embedding coordinates}
    ###
    infinitesimalDOF: (vertexConfiguration) ->
        numVertices = @nodes.length
        if numVertices == 0
            return 0

        firstCoords = vertexConfiguration[@nodes[0]]
        embedDim = firstCoords.length
        displacements = [numeric.sub(coords, firstCoords) for node, coords in vertexConfiguration]
        configDim = matrixRank(displacements)

        rmatRank = matrixRank rigidityMatrix vertexConfiguration
        euclIsomDim = (embedDim + 1) * embedDim / 2
        symGroupDim = (embedDim - configDim) * (embedDim - configDim - 1) / 2

        return embedDim * numVertices - rmatRank - euclIsomDim + symGroupDim

    rigidityMatrix: (vertexConfiguration) ->
        numVertices = @nodes.length
        firstCoords = vertexConfiguration[@nodes[0]]
        embedDim = firstCoords.length

        rigidityMatrixRow: (edge) ->
            [left, right] = [edge.source, edge.target]
            [leftInd, rightInd] = [embedDim * @nodes.indexOf(left), embedDim * @nodes.indexOf(right)]
            edgeDisplacement =
                numeric.sub(vertexConfiguration[right],vertexConfiguration[left])

            row = [0 for [0...(numVertices*embedDim)]]
            (row[leftInd+i] = -edgeDisplacement for i in [0...embedDim])
            (row[rightInd+j] = edgeDisplacement for j in [0...embedDim])
            return row

        return [rigidityMatrixRow(edge) for edge in @edges]

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
    getFill: () -> @attr.fill
    setFill: (fill) -> @attr.fill = fill

class PebbleGraph extends Graph
    constructor: (@nodes, @edges, @attr) ->
        super(@nodes, @edges, @attr)
        @pebbleIndex = {vertex: [-1, -1] for vertex in @nodes}

    pebbleIndex: () ->
        return @pebbleIndex

    pebbleCounts: () ->
        edgeCounts = {edge: 0 for edge in @edges}
        vertexCounts = {v: 0 for v in @nodes}

        handleEntry: (vertex, entry) ->
            if entry == -1
                vertexCounts[vertex] += 1
            else
                edgeCounts[entry] += 1

        updateCounts: (vertex, pebbleIndEntries) ->
            (handleEntry(vertex, x) for x in pebbleIndEntries)

        (updateCounts(v, entries) for v, entries in @pebbleIndex)

        return {"edgeCounts": edgeCounts, "vertexCounts": vertexCounts}

    _reassignPebble: (vertex, oldval, newval) ->
        index = @pebbleIndex[vertex].indexOf(edge)
        if index == -1
            return false
        
        @pebbleIndex[vertex][index] = newval
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
        return -1 != @pebbleIndex[vertex].indexOf(-1)

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




