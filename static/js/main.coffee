$ ->
    initGraph()
    attachBindings()

###################
# GLOBAL VARIABLES
###################

vars =
    chargeVal: -50
    width: 600
    height: 500
    radius: 15
    color: "#CCC"
    colorS: "#0CF"
    maxCount: 5

# selected, mouse down/up
graphVars =
    graph: null
    graphP: null
    
    canSelect: true # mutex style flags
    canAdd: true
    frozen: false
    
    mouseDown: false # flags for mouse events
    mouseUp: true
    mouseOut: true
    mouseEnter: false
    
    nodeS: [null, null] # selected (clicked)
    edgeS: null
    edgeN: null # new edge
    nodeME: null # mouseenter
    
    nodeAttr: {fill: vars.color}
    edgeAttr: {stroke: vars.color}

d3Vars =
    svg: null
    drag: null
    
resetGraphVars = () ->
    graphVars.graph = null
    graphVars.graphP = null
    
    graphVars.canSelect = true # mutex style flags
    graphVars.canAdd = true
    graphVars.frozen = false
    
    graphVars.mouseDown = false # flags for mouse events
    graphVars.mouseUp = true
    graphVars.mouseOut = true
    graphVars.mouseEnter = false
    
    graphVars.nodeS = [null, null] # selected (clicked)
    graphVars.edgeS = null
    graphVars.edgeN = null # new edge
    graphVars.nodeME = null # mouseenter
    
###################
# BUTTON BINDINGS
###################

attachBindings = () ->
    $("#pebble").on "click", () ->
        drawPebble()

    $("#reset").on "click", () ->
        resetGraphVars()
        initGraph()
        
    $("#inf").on "click", () ->
        drawInfinite()
        
    $("#about").on "click", () ->
        showAbout()
        
    $("#ctrlEdge").on "click", () ->
        drawEdge()
        
    $("#ctrlDel").on "click", () ->
        deleteNodes()
        
    $("#ctrlHelp").on "click", () ->
        showHelp()
        
    $(".exit").on "click", () ->
        hideHelp(this)

    $(document).keydown onKeyDown
    $(document).keyup onKeyUp

###################
# d3 FUNCTIONS
###################
    
initGraph = () ->
    $("#graph").html ""
    d3Vars.svg = d3.select("#graph").append("svg")
        .attr("width", vars.width)
        .attr("height", vars.height)
        .style("fill", "none")
        .on("click", onClick)
        .on("mouseup", onMouseUpNode)
    graphVars.graph = new Graph [], []
    # console.log("boba is yummy (initGraph)")

onClick = () ->
    coords = d3.mouse this
    [x, y] = coords
    if graphVars.canAdd && ! graphVars.frozen
        node = new Node nodeGenID(), x, y, Object.assign({}, graphVars.nodeAttr)

        graphVars.graph.addNode node
        graphVars.canSelect = false
        # prevent selection of newly added node

        redraw()
        
onKeyDown = (e) ->
    if !e
        e = event
    if e.altKey
        console.log "lemon black tea (alt down)"
        d3Vars.svg.style("cursor", "move")
    # this is the "e" key
    else if e.keyCode == 69
        drawEdge()
    # this is the "x" key
    else if e.keyCode == 88
        deleteNodes()
    # this is the "right arrow" key
    else if e.keyCode == 39
        drawPebble()
    
onKeyUp = (e) ->
    d3Vars.svg.style("cursor", "crosshair")
    
onMouseUp = () ->
    coords = d3.mouse this
    [x, y] = coords

onClickNode = () ->
    if graphVars.canSelect
        toggleNodeSelect(this)

onMouseDownNode = () ->
    graphVars.canAdd = false
    graphVars.mouseDown = true
    graphVars.mouseUp = false
            
onMouseUpNode = () ->
    graphVars.mouseDown = false
    graphVars.mouseUp = true
    # console.log "thai milk tea (mouse up)"

# must leave current node to perform new actions
onMouseOutNode = () ->
    graphVars.canSelect = true
    graphVars.canAdd = true
    graphVars.mouseOut = true
    graphVars.mouseEnter = false
    
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
        
redraw = () ->
    drawGraph graphVars.graph, d3Vars.svg
    # console.log "boba is sweet (redraw)"
    
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
    oldestNode = graphVars.nodeS[1]
    youngerNode = graphVars.nodeS[0]
    node = d3.select(circle).data()[0]
    
    # deselect oldest node if there's a new young budding node
    if oldestNode != null and youngerNode != node
        # console.log "passionfruit green tea (nodeSelect reset)"
        oldestNode.setColor oldestNode.getSavedColor()

    # deselect younger node
    if youngerNode == node
        graphVars.nodeS[0] = null
        youngerNode.setColor youngerNode.getSavedColor()
    # otherwise young node grows older
    else
        graphVars.nodeS[1] = graphVars.nodeS[0]
        # if old node was selected, don't re-select it
        if oldestNode != node
            graphVars.nodeS[0] = node # selected node update
            node.saveColor()
            node.setColor vars.colorS
    redraw()
    
toggleEdgeSelect = (line) ->
    # reset old selected color
    # console.log "red bean milk tea (edge select)"
    if graphVars.edgeS != null
        # console.log "red bean slush (edgeSelect reset)"
        graphVars.edgeS.setColor graphVars.edgeS.getSavedColor()

    edge = d3.select(line).data()[0]
    # deselect selected edges
    if graphVars.edgeS == edge
        graphVars.edgeS = null
    else
        graphVars.edgeS = edge # selected node update
        edge.saveColor()
        edge.setColor vars.colorS
    redraw()

drawEdge = () ->
    if null not in graphVars.nodeS and not graphVars.frozen
        source = graphVars.nodeS[0]
        target = graphVars.nodeS[1]
        
        graphVars.edgeN = new Edge nodeGenID(), source, target, Object.assign({}, graphVars.edgeAttr)
        graphVars.graph.addEdge graphVars.edgeN
    
        graphVars.edgeN = null
        redraw()
        
deleteNodes = () ->
    for node in graphVars.nodeS
        if node != null
            # deselect if selected
            if node == graphVars.nodeS[0]
                graphVars.nodeS[0] = null
            else if node == graphVars.nodeS[1]
                graphVars.nodeS[1] = null
            graphVars.graph.delNode node
            
    if graphVars.edgeS != null
        graphVars.graph.delEdge graphVars.edgeS
    
    redraw()

nodeGenID = () -> Math.random().toString(36).substr(2, 5)

###################
# PEBBLE RUNNING
###################

disableDraw = () ->
    graphVars.frozen = true

drawPebble = () ->
    disableDraw()
    # TODO can display original state later
    # console.log "lychee black tea (drawPebble)"

    # if graphVars.edgeS != null
    if graphVars.graphP == null
        graph = graphVars.graph
        graphVars.graphP = new PebbleGraph graph.nodes, graph.edges, {}
        # graphVars.graphP.enlargeCover graphVars.edgeS
    
    algorithmDone = graphVars.graphP.stepAlgorithm()
    if algorithmDone
        console.log "pebble algorithm complete!"
    
    algState = graphVars.graphP.algorithmState()
    console.log graphVars.graphP
    console.log(algState)

    for node in graphVars.graphP.nodes
        count = algState.vertexCounts[node.id]
        node.setColor getColor(count)
        node.saveColor()
    
    for edge in graphVars.graphP.edges
        count = algState.edgeCounts[edge.id]
        edge.setColor getColor(count)
        console.log(edge.getSavedColor())
        edge.saveColor()
        console.log(edge.getSavedColor())
            
    redraw()
 
# these magic numbers leave us in the
# cyan green yellow range
getColor = (count) ->
    r = 96 + Math.floor(158 * count / vars.maxCount)
    r = r.toString()
    
    g = "255"
    
    b = 255 - Math.floor(110 * count / vars.maxCount)
    b = b.toString()
    
    "rgb(" + r + "," + g + "," + b + ")"

drawInfinite = () ->
    console.log "love you"
    # tony = graphVars.
    
#####################
# NUMERIC ALGORITHMS
#####################

###
Find the rank of a matrix; algorithm based on SVD.
Params:
    matrix: the matrix lmao
###
matrixRank = (matrix) ->
    # count nonzero singular values
    return (x for x in numeric.svd(matrix).S when x != 0).length

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
    # delete nodes and incident edges
    delNode: (node) ->
        # loop backwards to delete
        if @edges.length > 0
            for i in [@edges.length-1..0]
                edge = @edges[i]
                if edge.getTarget() == node or edge.getSource() == node
                    @edges.splice i, 1 if i isnt -1
        # now delete node itself
        index = @nodes.indexOf node
        @nodes.splice index, 1 if index isnt -1
    # delete single edge
    delEdge: (edge) ->
        index = @edges.indexOf edge
        @edges.splice index, 1 if index isnt -1

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
        displacements = (numeric.sub(coords, firstCoords) for node, coords of vertexConfiguration)
        configDim = matrixRank(displacements)

        rmatRank = matrixRank rigidityMatrix vertexConfiguration
        euclIsomDim = (embedDim + 1) * embedDim / 2
        symGroupDim = (embedDim - configDim) * (embedDim - configDim - 1) / 2

        return embedDim * numVertices - rmatRank - euclIsomDim + symGroupDim

    ###
    Find, with high probability, the number of infinitesimal degrees of freedom
    for a generic embedding of the graph in `dimension` dimensions.
    ###
    genericInfDOF: (dimension) ->
        randomVertexConfig = {}
        for node in @nodes
            randomVertexConfig[node] = numeric.random([dimension])
        return this.infinitesimalDOF(randomVertexConfig)


    rigidityMatrix: (vertexConfiguration) ->
        numVertices = @nodes.length
        firstCoords = vertexConfiguration[@nodes[0]]
        embedDim = firstCoords.length

        rigidityMatrixRow: (edge) ->
            [left, right] = [edge.source, edge.target]
            [leftInd, rightInd] = [embedDim * @nodes.indexOf(left), embedDim * @nodes.indexOf(right)]
            edgeDisplacement =
                numeric.sub(vertexConfiguration[right],vertexConfiguration[left])

            row = (0 for [0...(numVertices*embedDim)])
            (row[leftInd+i] = -edgeDisplacement for i in [0...embedDim])
            (row[rightInd+j] = edgeDisplacement for j in [0...embedDim])
            return row

        return (rigidityMatrixRow(edge) for edge in @edges)

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
        this.saveColor()
    setTarget: (target) -> @target = target
    getTarget: () -> @target
    getSource: () -> @source
    
    setColor: (stroke) -> @attr.stroke = stroke
    saveColor: () -> @attr.strokeOld = @attr.stroke
    getSavedColor: () -> @attr.strokeOld
    
###
Node object
Params:
    id: unique identifier
    x, y: locations
    attr: list of attributes
###
class Node
    constructor: (@id, @x, @y, @attr) ->
        this.saveColor()
    getColor: () -> @attr.fill
    setColor: (fill) -> @attr.fill = fill
    
    saveColor: () -> @attr.fillOld = @attr.fill
    getSavedColor: () -> @attr.fillOld

countOccurences = (array, elt) ->
    count = 0
    cur_index = -1
    while ((cur_index = array.indexOf(elt, cur_index + 1)) != -1)
        count += 1
    return count


class PebbleGraph extends Graph
    constructor: (@nodes, @edges, @attr) ->
        super(@nodes, @edges, @attr)

        @pebbleIndex = {}
        for vertex in @nodes
            @pebbleIndex[vertex.id.toString()] = [-1,-1]
        @independentEdges = []
        @remainingEdges = @edges.slice()
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
            "independentEdges": @independentEdges,
            "candidateIndEdge": @curCandIndEdge
        }

    edgeRedundantlyCovered: (edge) ->
        # second condition included for completeness; shouldn't ever be needed
        return (this.edgePebbleCount(edge) > 1 and edge isnt @curCandIndEdge) or this.edgePebbleCount(edge) > 4
        
    _reassignPebble: (vertex, oldval, newval) ->
        index = @pebbleIndex[vertex.id].indexOf(oldval)
        if index == -1
            return false
        @pebbleIndex[vertex.id][index] = newval
        return true

    ###
    Attempt to allocate a free pebble from `vertex` to `edge`,
    returning true if successful.
    See `hasFreePebble` for a definition of "free pebble".
    ###
    allocatePebble: (vertex, edge) ->
        if vertex not in [edge.source, edge.target]
            raise ValueError("Edge #{edge} not incident to vertex #{vertex}")
        if this._reassignPebble(vertex, -1, edge)
            return true

        pebIndVertEntry = @pebbleIndex[vertex.id]
        console.log "xcxc pebIndVertEntry"
        console.log pebIndVertEntry
        redundantlyCoveredEdges = (x for x in pebIndVertEntry when (x != -1 and this.edgeRedundantlyCovered(x)))
        console.log "xcxc redundantlyCoveredEdges"
        console.log redundantlyCoveredEdges
        if redundantlyCoveredEdges.length > 0
            console.log("reassigning from edge " + redundantlyCoveredEdges[0].id)
            return this._reassignPebble(vertex, redundantlyCoveredEdges[0], edge)
        return false

    ###
    Reallocate a pebble belonging to `vertex` from `oldedge` to `newedge`.
    ###
    reallocatePebble: (vertex, oldedge, newedge) ->
        if vertex not in [newedge.source, newedge.target]
            raise ValueError("Edge #{edge} not incident to vertex #{vertex}")
        return this._reassignPebble(vertex, oldedge, newedge)

    ###
    Return true iff `vertex` has a free pebble:
    a pebble not assigned to an edge or assigned to a multiply-covered edge.
    ###
    hasFreePebble: (vertex) ->
        pebIndVertEntry = @pebbleIndex[vertex.id]
        # candEdgeFirstOccurence = pebIndVertEntry.indexOf(@curCandIndEdge)
        me = this  # grumble mumble javascript scoping
        pebIndVertEntry.some((elt) -> (elt == -1 or me.edgeRedundantlyCovered(elt)))
        # return pebIndVertEntry.indexOf(-1) != -1

    edgePebbleCount: (edge) ->
        [left, right] = [edge.source, edge.target]
        return countOccurences(@pebbleIndex[left.id], edge) + countOccurences(@pebbleIndex[right.id], edge)

    pebbledEdgesAndNeighbors: (vertex) ->
        otherVertex = (edge) ->
            return (x for x in [edge.source, edge.target] when x isnt vertex)[0]

        pebbleAssignments = this.pebbleIndex[vertex.id]
        return ([otherVertex(e), e] for e in pebbleAssignments when e isnt -1)

    algorithmComplete: () ->
        @remainingEdges.length == @enlargeCoverIteration == 0

    ###
    Returns:
        true if algorithm is complete, false otherwise
    ###
    stepAlgorithm: () ->
        if this.algorithmComplete()
            alert "algorithm complete!"
            return ""

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

        console.log @remainingEdges
        return this.algorithmComplete()

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
        console.log this.pebbledEdgesAndNeighbors(vertex)
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

####################
# PAGE FUNCTIONALITY
####################

showAbout = () ->
    $("#aboutPanel").show()
    
showHelp = () ->
    $("#helpPanel").show()
    
hideHelp = (element) ->
    # console.log "yogurt milk tea (hide parent)"
    $(element).parent().hide()
