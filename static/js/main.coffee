$ ->
    initGraph()
    
    # test()

###################
# GLOBAL VARIABLES
###################

vars =
    chargeVal: -50
    width: 600
    height: 500
    radius: 15
    fill: "#CCC"
    maxCount: 10

# selected, mouse down/up
graphVars =
    graph: null
    graphP: null
    
    canSelect: true # mutex style flags
    canAdd: true
    
    mouseDown: false # flags for mouse events
    mouseUp: true
    mouseOut: true
    mouseEnter: false
    
    nodeS: null # selected (clicked)
    edgeS: null
    edgeN: null # new edge
    nodeME: null # mouseenter
    
    nodeAttr: {fill: vars.fill}
    edgeAttr: {stroke: vars.fill}

d3Vars =
    svg: null
    drag: null
    
###################
# PEBBLE RUNNING
###################

$("#pebble").on "click", () ->
    drawPebble()

drawPebble = () ->
    # TODO can display original state later
    console.log "lychee black tea (drawPebble)"
    if graphVars.edgeS != null
        if graphVars.graphP == null
            graph = graphVars.graph
            graphVars.graphP = new PebbleGraph graphVars.graph.nodes, graphVars.graph.edges, {}
            graphVars.graphP.enlargeCover graphVars.edgeS

        algState = graphVars.graphP.algorithmState()

        for node in graphVars.graphP.nodes
            count = algState.vertexCounts[node.id]
            node.setColor getColor(count)
            console.log node.getColor()
        
        for edge in graphVars.graphP.edges
            count = algState.edgeCounts[edge.id]
            edge.setColor getColor(count)
            
getColor = (count) ->
    rgb = 137 * count / vars.maxCount
    rgb = rgb.toString()
    console.log "count " + count.toString()
    console.log "rgb(" + rgb + "," + rgb + "," + rgb + ")"
    console.log rgb
    "rgb(" + rgb + "," + rgb + "," + rgb + ")"


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
    graphVars.graph = new Graph [], []
    
#    d3Vars.drag = d3.drag()
#        .on("drag", dragEdge)
    d3.selectAll("circle")
        .call(d3.drag().on("start", dragEdge))
        
    console.log("boba is yummy (initGraph)")

onClick = () ->
    coords = d3.mouse this
    [x, y] = coords
    if graphVars.canAdd
        node = new Node nodeGenID(), x, y, Object.assign({}, graphVars.nodeAttr)

        graphVars.graph.addNode node
        graphVars.canSelect = false
        # prevent selection of newly added node

        redraw()
    
onMouseUp = () ->
    coords = d3.mouse this
    [x, y] = coords

onClickNode = () ->
    if graphVars.canSelect
        toggleNodeSelect(this)

onMouseDownNode = () ->
    # don't add new node when selecting normally
    if graphVars.nodeS == null
        if graphVars.canSelect
            toggleNodeSelect(this)
        
    graphVars.canAdd = false
    graphVars.mouseDown = true
    graphVars.mouseUp = false
            
onMouseUpNode = () ->
    graphVars.mouseDown = false
    graphVars.mouseUp = true
    
    console.log "thai milk tea (mouse up)"
    if graphVars.edgeN != null
        if graphVars.mouseEnter
            drawEdgeEnd()
         else
            drawEdgeDrop()
        graphVars.canAdd = true
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
    
onClickEdge = () ->
    if graphVars.canSelect
        toggleEdgeSelect(this)
        
onMouseDownEdge = () ->
    # don't add new node when selecting
    graphVars.canAdd = false

# must leave current node to perform new actions
onMouseOutEdge = () ->
    graphVars.canAdd = true
    
dragEdge = (d) ->
    if graphVars.edgeN != null
        [x,y] = [d3.event.x, d3.event.y]
        d3.select(graphVars.edgeN)
            .attr("x2", x)
            .attr("y2", y)
    console.log "green bean milk tea (dragEdge)"
        
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
        .attr("stroke", (edge) -> edge.attr.stroke)
        .attr("stroke-width", "5")
    nodes = svg.selectAll("node")
        .data(graph.nodes).enter()
        .append("circle")
        .attr("class", "circle")
        .attr("cx", (node) -> node.x)
        .attr("cy", (node) -> node.y)
        .attr("r", vars.radius)
        .attr("id", (node) -> node.id)
        .style("fill", (node) -> node.getColor())
    svg.selectAll("circle")
        .on("click", onClickNode)
        .on("mousedown", onMouseDownNode)
        .on("mouseup", onMouseUpNode)
        .on("mouseout", onMouseOutNode)
        .on("mouseenter", onMouseEnterNode)
    svg.selectAll("line")
        .on("click", onClickEdge)
        .on("mousedown", onMouseDownEdge)
        .on("mouseout", onMouseOutEdge)
    # console.log("boba is delicious (drawGraph)")

# toggles currently selected node
toggleNodeSelect = (circle) ->
    # reset old selected color
    if graphVars.nodeS != null
        graphVars.nodeS.setColor vars.fill

    node = d3.select(circle).data()[0]
    # deselect selected nodes
    if graphVars.nodeS == node
        graphVars.nodeS = null
    else
        graphVars.nodeS = node # selected node update
        node.setColor "#ADF"
    redraw()
    
toggleEdgeSelect = (line) ->
    # reset old selected color
    console.log "red bean milk tea (edge select)"
    if graphVars.edgeS != null
        graphVars.edgeS.setColor vars.fill

    edge = d3.select(line).data()[0]
    # deselect selected nodes
    if graphVars.edgeS == edge
        graphVars.edgeS = null
    else
        graphVars.edgeS = edge # selected node update
        edge.setColor "#ADF"
    redraw()

# three functions that work together to draw a new edge
drawEdgeStart = () ->
    console.log "panda milk tea (edge start)"
    graphVars.canAdd = false
    source = graphVars.nodeS
    graphVars.edgeN = new Edge nodeGenID(), source
    
drawEdgeEnd = () ->
    console.log "milk grass jelly (edge end)"
    # no self loops
    if graphVars.nodeME != graphVars.edgeN.source
        graphVars.edgeN.setTarget graphVars.nodeME
        graphVars.graph.addEdge graphVars.edgeN
    graphVars.edgeN = null
    
    redraw()
    
drawEdgeDrop = () ->
    console.log "hokkaido milk tea (edge drop)"    
    graphVars.edgeN = null
    
nodeGenID = () -> Math.random().toString(36).substr(2, 5)
    
test = () ->
    nodes = []
    for n in [0 .. 9]
        node = new Node nodeGenID(), 100+n*Math.random()*100, 100+n*Math.random()*100, Object.assign({}, graphVars.nodeAttr)
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
        displacements = [numeric.sub(coords, firstCoords) for node, coords of vertexConfiguration]
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
    constructor: (@id, @source, @target = null, @attr = Object.assign({}, graphVars.edgeAttr)) ->
    setTarget: (target) -> @target = target
    setColor: (stroke) -> @attr.stroke = stroke
    
###
Node object
Params:
    id: unique identifier
    x, y: locations
    attr: list of attributes
###
class Node
    constructor: (@id, @x, @y, @attr) ->
    getColor: () -> @attr.fill
    setColor: (fill) -> @attr.fill = fill

class PebbleGraph extends Graph
    constructor: (@nodes, @edges, @attr) ->
        super(@nodes, @edges, @attr)

        @pebbleIndex = {}
        for vertex in @nodes
            @pebbleIndex[vertex.id.toString()] = [-1,-1]
        @independentEdges = []
        @remainingEdges = $.extend(@edges)
        @enlargeCoverIteration = 0
        @curCandIndEdge = -1  # "current candidate independent edge"

    pebbleIndex: () ->
        @pebbleIndex

    algorithmState: () ->
        edgeCounts = {}
        for edge in @edges
            edgeCounts[edge.id.toString()] = 0
        vertexCounts = {}
        for vertex in @nodes
            vertexCounts[vertex.id.toString()] = 0

        for vertexid, entries of @pebbleIndex
            for entry in entries
                if entry == -1
                    vertexCounts[vertexid] += 1
                else
                    edgeCounts[entry.id] += 1

        {
            "edgeCounts": edgeCounts,
            "vertexCounts": vertexCounts,
            "independentEdges": @independentEdges
        }

    _reassignPebble: (vertex, oldval, newval) ->
        index = @pebbleIndex[vertex.id].indexOf(oldval)
        if index == -1
            return false
        @pebbleIndex[vertex.id][index] = newval
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
        return @pebbleIndex[vertex.id].indexOf(-1) != -1

    pebbledEdgesAndNeighbors: (vertex) ->
        otherVertex = (edge) ->
            return [x for x in [edge.source, edge.target] when x isnt vertex][0]

        pebbleAssignments = this.pebbleIndex[vertex]
        return [[otherVertex(e), e] for e in pebbleAssignments when e isnt -1]

    ###
    Returns:
        true if algorithm is complete, false otherwise
    ###
    stepAlgorithm: () ->
        if @enlargeCoverIteration == 0
            @curCandIndEdge = @remainingEdges.pop()

        enlargementSuccessful = this.enlargeCover(@curCandIndEdge)
        if enlargementSuccessful
            @enlargeCoverIteration += 1
            if @enlargeCoverIteration == 4
                @independentEdges.push(@curCandIndEdge)
                @enlargeCoverIteration = 0
        else
            @enlargeCoverIteration = 0

        return @remainingEdges.length == 0

    ###
    Cover enlargement for the pebble algorithm.
    Params:
         graph: trivial
         edge: Edge object we'd like to cover with pebbles.
    ###
    enlargeCover: (edge) ->
        [seen, path] = [{},{}]
        for vertex in @nodes
            seen[vertex.id.toString()] = false
            path[vertex.id.toString()] = -1
    
        [left, right] = [edge.source, edge.target]
        found = this.findPebble(left, seen, path)
        if found
            this.rearrangePebbles(left, edge, path)
            return true
        
        if not seen[right.id]
            found = this.findPebble(right, seen, path)
            if found
                this.rearrangePebbles(right, edge, path)
                return true

        return false
    
    
    findPebble: (vertex, seen, path) ->
        seen[vertex.id.toString()] = true
        path[vertex.id.toString()] = -1
        if this.hasFreePebble(vertex)
            return true
    
        # taken from the paper; probably should clean up code smell
        [[x, xedge], [y, yedge]] = this.pebbledEdgesAndNeighbors(vertex)
        if not seen[x.id.toString()]
            path[vertex.id.toString()] = [x, xedge]
            if this.findPebble(x, seen, path)
                return true
        if not seen[y.id.toString()]
            path[vertex.id.toString()] = [y, yedge]
            if this.findPebble(y, seen, path)
                return true
        return false
    
    
    rearrangePebbles: (vertex, edge, path) ->
        # while (path[vertex.id] != -1)
        #     [w, newedge] = path[vertex.id]
        #     if path[w.id.toString()] == -1
        #         this.allocatePebble(w, newedge)
        #     else
        #         [_, oldedge] = path[w.id.toString()]
        #         this.reallocatePebble(w, oldedge, newedge)
        #     vertex = w
        w = vertex
        newedge = edge
        while (w != -1)
            if path[w.id.toString()] == -1
                this.allocatePebble(w, newedge)
            else
                [_, oldedge] = path[w.id.toString()]
                this.reallocatePebble(w, oldedge, newedge)
            vertex = w
            if path[vertex.id] == -1
                w = -1
            else
                [w, newedge] = path[vertex.id]

