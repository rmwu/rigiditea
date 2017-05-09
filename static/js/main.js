// Generated by CoffeeScript 1.12.5
(function() {
  var Edge, Graph, Node, d3Vars, drawGraph, graphVars, initGraph, nodeGenID, onClick, onClickNode, redraw, test, vars;

  $(function() {
    initGraph();
    console.log("boba is yummy (initGraph)");
    return test();
  });

  vars = {
    chargeVal: -50,
    width: 600,
    height: 500,
    radius: 15,
    fill: "#000"
  };

  graphVars = {
    graph: null,
    nodeS: null,
    linkS: null,
    nodeMD: null,
    linkMD: null,
    nodeMU: null,
    attr: [vars.fill]
  };

  d3Vars = {
    svg: null,
    nodes: null,
    edges: null
  };

  initGraph = function() {
    d3Vars.svg = d3.select("#graph").append("svg").attr("width", vars.width).attr("height", vars.height).style("fill", "none").on("click", onClick);
    return graphVars.graph = new Graph([], [], []);
  };

  onClick = function() {
    var coords, node, x, y;
    coords = d3.mouse(this);
    x = coords[0], y = coords[1];
    node = new Node(nodeGenID(), x, y, graphVars.attr);
    graphVars.graph.addNode(node);
    return redraw();
  };

  onClickNode = function() {
    d3.select(this).data()[0].setFill("#CEF");
    console.log("once");
    console.log(graphVars.graph);
    return redraw();
  };

  redraw = function() {
    drawGraph(graphVars.graph, d3Vars.svg);
    return console.log("boba is sweet (redraw)");
  };


  /*
  Graph object
  Params:
      nodes: list of Node objects
      edges: list of Edge objects
   */

  Graph = (function() {
    function Graph(nodes1, edges1, attr) {
      this.nodes = nodes1;
      this.edges = edges1;
      this.attr = attr;
    }

    Graph.prototype.addNode = function(node) {
      return this.nodes.push(node);
    };

    Graph.prototype.addEdge = function(edge) {
      return this.edges.push(edge);
    };

    return Graph;

  })();


  /*
  Edge object
  Params:
      id: unique identifier
      source: source Node object
      target: target Node object
      attr: list is attributes
   */

  Edge = (function() {
    function Edge(id, source, target, attr) {
      this.id = id;
      this.source = source;
      this.target = target;
      this.attr = attr;
    }

    return Edge;

  })();


  /*
  Node object
  Params:
      id: unique identifier
      x, y: locations
      attr: list of attributes
   */

  Node = (function() {
    function Node(id, x1, y1, attr) {
      this.id = id;
      this.x = x1;
      this.y = y1;
      this.attr = attr;
    }

    Node.prototype.getFill = function() {
      return this.attr[0];
    };

    Node.prototype.setFill = function(fill) {
      return this.attr[0] = fill;
    };

    return Node;

  })();

  drawGraph = function(graph, svg) {
    var edges, nodes;
    svg.selectAll("*").remove();
    graphVars.graph = graph;
    edges = svg.selectAll("link").data(graph.edges).enter().append("line").attr("class", "edge").attr("x1", function(edge) {
      return edge.source.x;
    }).attr("y1", function(edge) {
      return edge.source.y;
    }).attr("x2", function(edge) {
      return edge.target.x;
    }).attr("y2", function(edge) {
      return edge.target.y;
    }).style("fill", "none").attr("stroke", "#000").attr("stroke-width", "5");
    nodes = svg.selectAll("node").data(graph.nodes).enter().append("circle").attr("class", "circle").attr("cx", function(node) {
      return node.x;
    }).attr("cy", function(node) {
      return node.y;
    }).attr("r", vars.radius).attr("id", function(node) {
      return node.id;
    }).style("fill", function(node) {
      return node.getFill();
    });
    svg.selectAll("circle").on("mouseover", onClickNode);
    return console.log("boba is delicious (drawGraph)");
  };

  nodeGenID = function() {
    return Math.random().toString(36).substr(2, 5);
  };

  test = function() {
    var edges, graph, i, j, k, n, node, node1, node2, nodes;
    nodes = [];
    for (n = j = 0; j <= 9; n = ++j) {
      node = new Node(nodeGenID(), 100 + n * Math.random() * 100, 100 + n * Math.random() * 100, ["#000"]);
      nodes.push(node);
    }
    edges = [];
    for (i = k = 0; k < 8; i = ++k) {
      node1 = nodes[i];
      node2 = nodes[i + 1];
      edges.push(new Edge(nodeGenID(), node1, node2, 1));
    }
    graph = new Graph(nodes, edges);
    return drawGraph(graph, d3Vars.svg);
  };

}).call(this);
