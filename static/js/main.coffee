$ ->
    initGraph()
    console.log("boba is yummy")
    
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
    nodeS: null
    linkS: null
    nodeMD: null
    linkMD: null
    nodeMU: null

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
        .attr("fill", "none")

redraw = () ->
    "boba is yummy"
    
###################
# GRAPH UTILITIES
###################

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

drawGraph = (graph, svg) ->
    edges = svg.selectAll("link")
        .data(graph.edges).enter()
        .append("line")
        .attr("class","edge")
        .attr("x1", (edge) -> edge.source.x)
        .attr("y1", (edge) -> edge.source.x)
        .attr("x2", (edge) -> edge.target.x)
        .attr("y2", (edge) -> edge.target.x)
    nodes = svg.selectAll("node")
        .data(graph.nodes).enter()
        .append("circle")
        .attr("class", "circle")
        .attr("cx", (node) -> node.x)
        .attr("cy", (node) -> node.y)
        .attr("r", vars.radius)
        .attr("fill", vars.fill)
    
    console.log("k")

test = () ->
    nodes = []
    for n in [0 .. 9]
        node = new Node n, n*25, n*25, 1
        nodes.push node

    graph = new Graph nodes, []

    drawGraph(graph, d3Vars.svg)