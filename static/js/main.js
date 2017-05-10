// Generated by CoffeeScript 1.12.5
(function() {
  var Edge, Graph, Node, PebbleGraph, d3Vars, drawEdgeDrop, drawEdgeEnd, drawEdgeStart, drawGraph, graphVars, initGraph, nodeGenID, onClick, onClickNode, onMouseDown, onMouseDownNode, onMouseEnterNode, onMouseOutNode, onMouseUpNode, redraw, test, toggleSelect, vars,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  $(function() {
    initGraph();
    return console.log("boba is yummy (initGraph)");
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
    canSelect: true,
    canAdd: true,
    mouseDown: false,
    mouseUp: true,
    mouseOut: true,
    mouseEnter: false,
    nodeS: null,
    edgeS: null,
    nodeME: null,
    attr: [vars.fill]
  };

  d3Vars = {
    svg: null,
    nodes: null,
    edges: null
  };

  initGraph = function() {
    d3Vars.svg = d3.select("#graph").append("svg").attr("width", vars.width).attr("height", vars.height).style("fill", "none").on("click", onClick).on("mouseup", onMouseUpNode);
    return graphVars.graph = new Graph([], [], []);
  };

  onClick = function() {
    var coords, node, x, y;
    coords = d3.mouse(this);
    x = coords[0], y = coords[1];
    if (graphVars.canAdd) {
      node = new Node(nodeGenID(), x, y, graphVars.attr.slice());
      graphVars.graph.addNode(node);
      graphVars.canSelect = false;
      return redraw();
    }
  };

  onMouseDown = function() {
    var coords, x, y;
    coords = d3.mouse(this);
    return x = coords[0], y = coords[1], coords;
  };

  onClickNode = function() {
    if (graphVars.canSelect) {
      return toggleSelect(this);
    }
  };

  onMouseDownNode = function() {
    graphVars.canAdd = false;
    graphVars.mouseDown = true;
    return graphVars.mouseUp = false;
  };

  onMouseUpNode = function() {
    graphVars.mouseDown = false;
    graphVars.mouseUp = true;
    console.log("thai milk tea (mouse up)");
    if (graphVars.edgeS !== null) {
      if (graphVars.mouseEnter) {
        return drawEdgeEnd();
      } else {
        return drawEdgeDrop();
      }
    }
  };

  onMouseOutNode = function() {
    graphVars.canSelect = true;
    graphVars.canAdd = true;
    graphVars.mouseOut = true;
    graphVars.mouseEnter = false;
    if (graphVars.mouseDown) {
      return drawEdgeStart();
    }
  };

  onMouseEnterNode = function() {
    graphVars.mouseOut = false;
    graphVars.mouseEnter = true;
    return graphVars.nodeME = d3.select(this).data()[0];
  };

  redraw = function() {
    drawGraph(graphVars.graph, d3Vars.svg);
    return console.log("boba is sweet (redraw)");
  };

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
    return svg.selectAll("circle").on("click", onClickNode).on("mousedown", onMouseDownNode).on("mouseup", onMouseUpNode).on("mouseout", onMouseOutNode).on("mouseenter", onMouseEnterNode);
  };

  toggleSelect = function(circle) {
    var node;
    if (graphVars.nodeS !== null) {
      graphVars.nodeS.setFill(vars.fill);
    }
    node = d3.select(circle).data()[0];
    if (graphVars.nodeS === node) {
      graphVars.nodeS = null;
    } else {
      graphVars.nodeS = node;
      node.setFill("#ADF");
    }
    return redraw();
  };

  nodeGenID = function() {
    return Math.random().toString(36).substr(2, 5);
  };

  drawEdgeStart = function() {
    var source;
    console.log("panda milk tea (edge start)");
    source = graphVars.nodeS;
    return graphVars.edgeS = new Edge(nodeGenID(), source);
  };

  drawEdgeEnd = function() {
    console.log("milk grass jelly (edge end)");
    graphVars.edgeS.setTarget(graphVars.nodeME);
    graphVars.graph.addEdge(graphVars.edgeS);
    graphVars.edgeS = null;
    return redraw();
  };

  drawEdgeDrop = function() {
    console.log("hokkaido milk tea (edge drop)");
    return graphVars.edgeS = null;
  };

  test = function() {
    var edges, graph, i, j, k, n, node, node1, node2, nodes;
    nodes = [];
    for (n = j = 0; j <= 9; n = ++j) {
      node = new Node(nodeGenID(), 100 + n * Math.random() * 100, 100 + n * Math.random() * 100, graphVars.attr.slice());
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
    function Edge(id, source1, target1, attr) {
      this.id = id;
      this.source = source1;
      this.target = target1 != null ? target1 : null;
      this.attr = attr != null ? attr : [];
    }

    Edge.prototype.setTarget = function(target) {
      return this.target = target;
    };

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

  PebbleGraph = (function(superClass) {
    extend(PebbleGraph, superClass);

    function PebbleGraph(nodes1, edges1, attr) {
      var vertex;
      this.nodes = nodes1;
      this.edges = edges1;
      this.attr = attr;
      PebbleGraph.__super__.constructor.call(this, this.nodes, this.edges, this.attr);
      this.attr._pebbleIndex = {
        vertex: (function() {
          var j, len, ref, results;
          ref = this.nodes;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            vertex = ref[j];
            results.push([-1, -1]);
          }
          return results;
        }).call(this)
      };
    }

    PebbleGraph.prototype.pebbleIndex = function() {
      return this.attr._pebbleIndex;
    };

    PebbleGraph.prototype._reassignPebble = function(vertex, oldval, newval) {
      var index;
      index = this.attr._pebbleIndex[vertex].indexOf(edge);
      if (index === -1) {
        return false;
      }
      this.attr._pebbleIndex[vertex][index] = newval;
      return true;
    };

    PebbleGraph.prototype.allocatePebble = function(vertex, edge) {
      if (vertex !== edge.source && vertex !== edge.target) {
        raise(ValueError("Edge " + edge + " not incident to vertex " + vertex));
      }
      return this._reassignPebble(vertex, -1, edge);
    };

    PebbleGraph.prototype.reallocatePebble = function(vertex, oldedge, newedge) {
      if (vertex !== edge.source && vertex !== edge.target) {
        raise(ValueError("Edge " + edge + " not incident to vertex " + vertex));
      }
      return this._reassignPebble(vertex, oldedge, newedge);
    };

    PebbleGraph.prototype.hasFreePebble = function(vertex) {
      return -1 !== this.attr._pebbleIndex[vertex].indexOf(-1);
    };

    PebbleGraph.prototype.pebbledEdgesAndNeighbors = function(vertex) {
      var e, otherVertex, pebbleAssignments;
      otherVertex = function(edge) {
        var x;
        return [
          (function() {
            var j, len, ref, results;
            ref = [edge.source, edge.target];
            results = [];
            for (j = 0, len = ref.length; j < len; j++) {
              x = ref[j];
              if (x !== vertex) {
                results.push(x);
              }
            }
            return results;
          })()
        ][0];
      };
      pebbleAssignments = this.pebbleIndex[vertex];
      return [
        (function() {
          var j, len, results;
          results = [];
          for (j = 0, len = pebbleAssignments.length; j < len; j++) {
            e = pebbleAssignments[j];
            if (e !== -1) {
              results.push([otherVertex(e), e]);
            }
          }
          return results;
        })()
      ];
    };


    /*
    Cover enlargement for the pebble algorithm.
    Params:
         graph: trivial
         edge: Edge object we'd like to cover with pebbles.
     */

    PebbleGraph.prototype.enlargeCover = function(edge) {
      var found, left, path, ref, right, seen, vertex;
      seen = {
        vertex: (function() {
          var j, len, ref, results;
          ref = this.nodes;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            vertex = ref[j];
            results.push(false);
          }
          return results;
        }).call(this)
      };
      path = {
        vertex: (function() {
          var j, len, ref, results;
          ref = this.nodes;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            vertex = ref[j];
            results.push(-1);
          }
          return results;
        }).call(this)
      };
      ref = [edge.source, edge.target], left = ref[0], right = ref[1];
      found = this.findPebble(left, seen, path);
      if (found) {
        this.rearrangePebbles(left, seen);
        return true;
      }
      if (!seen[right]) {
        found = this.findPebble(right, seen, path);
        if (found) {
          this.rearrangePebbles(right, path);
          return true;
        }
      }
      return false;
    };

    PebbleGraph.prototype.findPebble = function(vertex, seen, path) {
      var ref, ref1, ref2, x, xedge, y, yedge;
      seen[vertex] = true;
      path[vertex] = -1;
      if (this.hasFreePebble(vertex)) {
        return true;
      }
      ref = this.pebbledEdgesAndNeighbors(vertex), (ref1 = ref[0], x = ref1[0], xedge = ref1[1]), (ref2 = ref[1], y = ref2[0], yedge = ref2[1]);
      if (!seen[x]) {
        path[vertex] = [x, xedge];
        if (this.findPebble(x, seen, path)) {
          return true;
        }
      }
      if (!seen[y]) {
        path[vertex] = [y, yedge];
        if (this.findPebble(y, seen, path)) {
          return true;
        }
      }
      return false;
    };

    PebbleGraph.prototype.rearrangePebbles = function(vertex, path) {
      var _, edge, oldedge, ref, ref1, results, w;
      results = [];
      while (path[vertex] !== -1) {
        ref = path[vertex], w = ref[0], edge = ref[1];
        if (path[w] === -1) {
          this.allocatePebble(w, edge);
        } else {
          ref1 = path[w], _ = ref1[0], oldedge = ref1[1];
          this.reallocatePebble(w, oldedge, edge);
        }
        results.push(vertex = w);
      }
      return results;
    };

    return PebbleGraph;

  })(Graph);

}).call(this);
