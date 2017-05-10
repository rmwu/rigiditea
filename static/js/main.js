// Generated by CoffeeScript 1.12.5
(function() {
  var Edge, Graph, Node, PebbleGraph, d3Vars, drawEdgeDrop, drawEdgeEnd, drawEdgeStart, drawGraph, drawPebble, getColor, graphVars, initGraph, matrixRank, nodeGenID, onClick, onClickEdge, onClickNode, onMouseDown, onMouseDownEdge, onMouseDownNode, onMouseEnterNode, onMouseOutEdge, onMouseOutNode, onMouseUpNode, redraw, test, toggleEdgeSelect, toggleNodeSelect, vars,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  $(function() {
    return initGraph();
  });

  vars = {
    chargeVal: -50,
    width: 600,
    height: 500,
    radius: 15,
    fill: "#000",
    maxCount: 10
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
    edgeN: null,
    nodeME: null,
    nodeAttr: {
      fill: vars.fill
    },
    edgeAttr: {
      stroke: vars.fill
    }
  };

  d3Vars = {
    svg: null,
    nodes: null,
    edges: null
  };

  $("#pebble").on("click", function() {
    return drawPebble();
  });

  drawPebble = function() {
    var counts, graph, graphP, item, k, len, ref, results;
    console.log("lychee black tea (drawPebble)");
    if (graphVars.edgeS !== null) {
      graph = graphVars.graph;
      graphP = new PebbleGraph(graph.nodes, graph.edges, {});
      graphP.enlargeCover(graphVars.edgeS);
      ref = graphP.pebbleCounts;
      results = [];
      for (k = 0, len = ref.length; k < len; k++) {
        item = ref[k];
        counts = item[1];
        results.push(item.setColor(getColor(counts)));
      }
      return results;
    }
  };

  getColor = function(count) {
    var rgb;
    rgb = 255 * count / vars.maxCount;
    return "rgb(" + rgb + "," + rgb + "," + rgb + ")";
  };

  initGraph = function() {
    d3Vars.svg = d3.select("#graph").append("svg").attr("width", vars.width).attr("height", vars.height).style("fill", "none").on("click", onClick).on("mouseup", onMouseUpNode);
    graphVars.graph = new Graph([], []);
    return console.log("boba is yummy (initGraph)");
  };

  onClick = function() {
    var coords, node, x, y;
    coords = d3.mouse(this);
    x = coords[0], y = coords[1];
    if (graphVars.canAdd) {
      node = new Node(nodeGenID(), x, y, Object.assign({}, graphVars.nodeAttr));
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
      return toggleNodeSelect(this);
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
    if (graphVars.edgeN !== null) {
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

  onClickEdge = function() {
    if (graphVars.canSelect) {
      return toggleEdgeSelect(this);
    }
  };

  onMouseDownEdge = function() {
    return graphVars.canAdd = false;
  };

  onMouseOutEdge = function() {
    return graphVars.canAdd = true;
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
    }).style("fill", "none").attr("stroke", function(edge) {
      return edge.attr.stroke;
    }).attr("stroke-width", "5");
    nodes = svg.selectAll("node").data(graph.nodes).enter().append("circle").attr("class", "circle").attr("cx", function(node) {
      return node.x;
    }).attr("cy", function(node) {
      return node.y;
    }).attr("r", vars.radius).attr("id", function(node) {
      return node.id;
    }).style("fill", function(node) {
      return node.getFill();
    });
    svg.selectAll("circle").on("click", onClickNode).on("mousedown", onMouseDownNode).on("mouseup", onMouseUpNode).on("mouseout", onMouseOutNode).on("mouseenter", onMouseEnterNode);
    return svg.selectAll("line").on("click", onClickEdge).on("mousedown", onMouseDownEdge).on("mouseout", onMouseOutEdge);
  };

  toggleNodeSelect = function(circle) {
    var node;
    if (graphVars.nodeS !== null) {
      graphVars.nodeS.setColor(vars.fill);
    }
    node = d3.select(circle).data()[0];
    if (graphVars.nodeS === node) {
      graphVars.nodeS = null;
    } else {
      graphVars.nodeS = node;
      node.setColor("#ADF");
    }
    return redraw();
  };

  toggleEdgeSelect = function(line) {
    var edge;
    console.log("red bean milk tea (edge select)");
    if (graphVars.edgeS !== null) {
      graphVars.edgeS.setColor(vars.fill);
    }
    edge = d3.select(line).data()[0];
    if (graphVars.edgeS === edge) {
      graphVars.edgeS = null;
    } else {
      graphVars.edgeS = edge;
      edge.setColor("#ADF");
    }
    return redraw();
  };

  drawEdgeStart = function() {
    var source;
    console.log("panda milk tea (edge start)");
    graphVars.canAdd = false;
    source = graphVars.nodeS;
    return graphVars.edgeN = new Edge(nodeGenID(), source);
  };

  drawEdgeEnd = function() {
    console.log("milk grass jelly (edge end)");
    graphVars.canAdd = true;
    graphVars.edgeN.setTarget(graphVars.nodeME);
    graphVars.graph.addEdge(graphVars.edgeN);
    graphVars.edgeN = null;
    return redraw();
  };

  drawEdgeDrop = function() {
    console.log("hokkaido milk tea (edge drop)");
    graphVars.canAdd = true;
    return graphVars.edgeN = null;
  };

  nodeGenID = function() {
    return Math.random().toString(36).substr(2, 5);
  };

  test = function() {
    var edges, graph, i, k, l, n, node, node1, node2, nodes;
    nodes = [];
    for (n = k = 0; k <= 9; n = ++k) {
      node = new Node(nodeGenID(), 100 + n * Math.random() * 100, 100 + n * Math.random() * 100, Object.assign({}, graphVars.nodeAttr));
      nodes.push(node);
    }
    edges = [];
    for (i = l = 0; l < 8; i = ++l) {
      node1 = nodes[i];
      node2 = nodes[i + 1];
      edges.push(new Edge(nodeGenID(), node1, node2, 1));
    }
    graph = new Graph(nodes, edges);
    return drawGraph(graph, d3Vars.svg);
  };


  /*
  Find the rank of a matrix; algorithm based on SVD.
  Params:
      matrix: the matrix lmao
   */

  matrixRank = function(matrix) {
    var x;
    return [
      (function() {
        var k, len, ref, results;
        ref = numeric.svd(matrix).S;
        results = [];
        for (k = 0, len = ref.length; k < len; k++) {
          x = ref[k];
          if (x !== 0) {
            results.push(x);
          }
        }
        return results;
      })()
    ].length;
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


    /*
    Find the numer of infinitesimal degrees of freedom.
    Params:
        vertexConfiguration: associative array {node: embedding coordinates}
     */

    Graph.prototype.infinitesimalDOF = function(vertexConfiguration) {
      var configDim, coords, displacements, embedDim, euclIsomDim, firstCoords, node, numVertices, rmatRank, symGroupDim;
      numVertices = this.nodes.length;
      if (numVertices === 0) {
        return 0;
      }
      firstCoords = vertexConfiguration[this.nodes[0]];
      embedDim = firstCoords.length;
      displacements = [
        (function() {
          var k, len, results;
          results = [];
          for (coords = k = 0, len = vertexConfiguration.length; k < len; coords = ++k) {
            node = vertexConfiguration[coords];
            results.push(numeric.sub(coords, firstCoords));
          }
          return results;
        })()
      ];
      configDim = matrixRank(displacements);
      rmatRank = matrixRank(rigidityMatrix(vertexConfiguration));
      euclIsomDim = (embedDim + 1) * embedDim / 2;
      symGroupDim = (embedDim - configDim) * (embedDim - configDim - 1) / 2;
      return embedDim * numVertices - rmatRank - euclIsomDim + symGroupDim;
    };

    Graph.prototype.rigidityMatrix = function(vertexConfiguration) {
      var edge, embedDim, firstCoords, numVertices;
      numVertices = this.nodes.length;
      firstCoords = vertexConfiguration[this.nodes[0]];
      embedDim = firstCoords.length;
      ({
        rigidityMatrixRow: function(edge) {
          var edgeDisplacement, i, j, k, l, left, leftInd, ref, ref1, ref2, ref3, right, rightInd, row;
          ref = [edge.source, edge.target], left = ref[0], right = ref[1];
          ref1 = [embedDim * this.nodes.indexOf(left), embedDim * this.nodes.indexOf(right)], leftInd = ref1[0], rightInd = ref1[1];
          edgeDisplacement = numeric.sub(vertexConfiguration[right], vertexConfiguration[left]);
          row = [
            (function() {
              var k, ref2, results;
              results = [];
              for (k = 0, ref2 = numVertices * embedDim; 0 <= ref2 ? k < ref2 : k > ref2; 0 <= ref2 ? k++ : k--) {
                results.push(0);
              }
              return results;
            })()
          ];
          for (i = k = 0, ref2 = embedDim; 0 <= ref2 ? k < ref2 : k > ref2; i = 0 <= ref2 ? ++k : --k) {
            row[leftInd + i] = -edgeDisplacement;
          }
          for (j = l = 0, ref3 = embedDim; 0 <= ref3 ? l < ref3 : l > ref3; j = 0 <= ref3 ? ++l : --l) {
            row[rightInd + j] = edgeDisplacement;
          }
          return row;
        }
      });
      return [
        (function() {
          var k, len, ref, results;
          ref = this.edges;
          results = [];
          for (k = 0, len = ref.length; k < len; k++) {
            edge = ref[k];
            results.push(rigidityMatrixRow(edge));
          }
          return results;
        }).call(this)
      ];
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
      this.attr = attr != null ? attr : Object.assign({}, graphVars.edgeAttr);
    }

    Edge.prototype.setTarget = function(target) {
      return this.target = target;
    };

    Edge.prototype.setColor = function(stroke) {
      return this.attr.stroke = stroke;
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
      return this.attr.fill;
    };

    Node.prototype.setColor = function(fill) {
      return this.attr.fill = fill;
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
          var k, len, ref, results;
          ref = this.nodes;
          results = [];
          for (k = 0, len = ref.length; k < len; k++) {
            vertex = ref[k];
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
            var k, len, ref, results;
            ref = [edge.source, edge.target];
            results = [];
            for (k = 0, len = ref.length; k < len; k++) {
              x = ref[k];
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
          var k, len, results;
          results = [];
          for (k = 0, len = pebbleAssignments.length; k < len; k++) {
            e = pebbleAssignments[k];
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
          var k, len, ref, results;
          ref = this.nodes;
          results = [];
          for (k = 0, len = ref.length; k < len; k++) {
            vertex = ref[k];
            results.push(false);
          }
          return results;
        }).call(this)
      };
      path = {
        vertex: (function() {
          var k, len, ref, results;
          ref = this.nodes;
          results = [];
          for (k = 0, len = ref.length; k < len; k++) {
            vertex = ref[k];
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
