###
drawGraph draws a Graph object
Params:
    graph: Graph object
    svg: svg canvas to which we append the drawing
###
radius = 15
fill = "#FFF"

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
        .attr("r", radius)
        .attr("fill", fill)
    
    console.log("k")