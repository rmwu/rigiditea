// Generated by CoffeeScript 1.12.5
(function() {
  var Edge, Graph, Node, PebbleGraph, attachBindings, countOccurences, d3Vars, disableDraw, dragEdge, drawEdgeDrop, drawEdgeEnd, drawEdgeStart, drawGraph, drawPebble, getColor, graphVars, hideHelp, initGraph, matrixRank, nodeGenID, onClick, onClickEdge, onClickNode, onKeyDown, onKeyUp, onMouseDownEdge, onMouseDownNode, onMouseEnterNode, onMouseOutEdge, onMouseOutNode, onMouseUp, onMouseUpNode, redraw, resetGraphVars, showHelp, toggleEdgeSelect, toggleNodeSelect, vars,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  $(function() {
    initGraph();
    return attachBindings();
  });

  vars = {
    chargeVal: -50,
    width: 600,
    height: 500,
    radius: 15,
    color: "#CCC",
    colorS: "#0CF",
    maxCount: 5
  };

  graphVars = {
    graph: null,
    graphP: null,
    canSelect: true,
    canAdd: true,
    frozen: false,
    mouseDown: false,
    mouseUp: true,
    mouseOut: true,
    mouseEnter: false,
    nodeS: null,
    edgeS: null,
    edgeN: null,
    nodeME: null,
    nodeAttr: {
      fill: vars.color
    },
    edgeAttr: {
      stroke: vars.color
    }
  };

  d3Vars = {
    svg: null,
    drag: null
  };

  resetGraphVars = function() {
    graphVars.graph = null;
    graphVars.graphP = null;
    graphVars.canSelect = true;
    graphVars.canAdd = true;
    graphVars.frozen = false;
    graphVars.mouseDown = false;
    graphVars.mouseUp = true;
    graphVars.mouseOut = true;
    graphVars.mouseEnter = false;
    graphVars.nodeS = null;
    graphVars.edgeS = null;
    graphVars.edgeN = null;
    return graphVars.nodeME = null;
  };

  attachBindings = function() {
    $("#pebble").on("click", function() {
      drawPebble();
      return disableDraw();
    });
    $("#reset").on("click", function() {
      resetGraphVars();
      return initGraph();
    });
    $("#about").on("click", function() {
      return showHelp();
    });
    $("#exit").on("click", function() {
      return hideHelp();
    });
    $(document).keydown(onKeyDown);
    return $(document).keyup(onKeyUp);
  };

  disableDraw = function() {
    return graphVars.frozen = true;
  };

  drawPebble = function() {
    var algState, algorithmDone, count, edge, graph, k, l, len, len1, node, ref, ref1;
    console.log("lychee black tea (drawPebble)");
    if (graphVars.graphP === null) {
      graph = graphVars.graph;
      graphVars.graphP = new PebbleGraph(graph.nodes, graph.edges, {});
    }
    algorithmDone = graphVars.graphP.stepAlgorithm();
    if (algorithmDone) {
      console.log("pebble algorithm complete!");
    }
    algState = graphVars.graphP.algorithmState();
    console.log(graphVars.graphP);
    console.log(algState);
    ref = graphVars.graphP.nodes;
    for (k = 0, len = ref.length; k < len; k++) {
      node = ref[k];
      count = algState.vertexCounts[node.id];
      node.setColor(getColor(count));
      node.saveColor();
    }
    ref1 = graphVars.graphP.edges;
    for (l = 0, len1 = ref1.length; l < len1; l++) {
      edge = ref1[l];
      count = algState.edgeCounts[edge.id];
      edge.setColor(getColor(count));
      console.log(edge.getSavedColor());
      edge.saveColor();
      console.log(edge.getSavedColor());
    }
    return redraw();
  };

  getColor = function(count) {
    var b, g, r;
    r = 96 + Math.floor(158 * count / vars.maxCount);
    r = r.toString();
    g = "255";
    b = 255 - Math.floor(110 * count / vars.maxCount);
    b = b.toString();
    return "rgb(" + r + "," + g + "," + b + ")";
  };

  initGraph = function() {
    $("#graph").html("");
    d3Vars.svg = d3.select("#graph").append("svg").attr("width", vars.width).attr("height", vars.height).style("fill", "none").on("click", onClick).on("mouseup", onMouseUpNode);
    graphVars.graph = new Graph([], []);
    return console.log("boba is yummy (initGraph)");
  };

  onClick = function() {
    var coords, node, x, y;
    coords = d3.mouse(this);
    x = coords[0], y = coords[1];
    if (graphVars.canAdd && !graphVars.frozen) {
      node = new Node(nodeGenID(), x, y, Object.assign({}, graphVars.nodeAttr));
      graphVars.graph.addNode(node);
      graphVars.canSelect = false;
      return redraw();
    }
  };

  onKeyDown = function(e) {
    if (!e) {
      e = event;
    }
    if (e.altKey) {
      console.log("lemon black tea (alt down)");
      return d3Vars.svg.style("cursor", "move");
    }
  };

  onKeyUp = function(e) {
    return d3Vars.svg.style("cursor", "crosshair");
  };

  onMouseUp = function() {
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
    if (graphVars.nodeS === null) {
      if (graphVars.canSelect) {
        toggleNodeSelect(this);
      }
    }
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
        drawEdgeEnd();
      } else {
        drawEdgeDrop();
      }
      return graphVars.canAdd = true;
    }
  };

  onMouseOutNode = function() {
    graphVars.canSelect = true;
    graphVars.canAdd = true;
    graphVars.mouseOut = true;
    graphVars.mouseEnter = false;
    if (graphVars.mouseDown && !graphVars.frozen) {
      return drawEdgeStart(this);
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

  dragEdge = function(mouseThis, line) {
    var coords, x, y;
    if (graphVars.edgeN !== null) {
      coords = d3.mouse(mouseThis);
      x = coords[0], y = coords[1];
      d3.select(line).attr("x2", x).attr("y2", y);
    }
    return console.log("green bean milk tea (dragEdge)");
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
      return node.getColor();
    });
    svg.selectAll("circle").on("click", onClickNode).on("mousedown", onMouseDownNode).on("mouseup", onMouseUpNode).on("mouseout", onMouseOutNode).on("mouseenter", onMouseEnterNode);
    return svg.selectAll("line").on("click", onClickEdge).on("mousedown", onMouseDownEdge).on("mouseout", onMouseOutEdge);
  };

  toggleNodeSelect = function(circle) {
    var node;
    if (graphVars.nodeS !== null) {
      console.log("passionfruit green tea (nodeSelect reset)");
      graphVars.nodeS.setColor(graphVars.nodeS.getSavedColor());
    }
    node = d3.select(circle).data()[0];
    if (graphVars.nodeS === node) {
      graphVars.nodeS = null;
    } else {
      graphVars.nodeS = node;
      node.saveColor();
      node.setColor(vars.colorS);
    }
    return redraw();
  };

  toggleEdgeSelect = function(line) {
    var edge;
    console.log("red bean milk tea (edge select)");
    if (graphVars.edgeS !== null) {
      console.log("red bean slush (edgeSelect reset)");
      console.log(graphVars.edgeS.getSavedColor());
      graphVars.edgeS.setColor(graphVars.edgeS.getSavedColor());
    }
    edge = d3.select(line).data()[0];
    if (graphVars.edgeS === edge) {
      graphVars.edgeS = null;
    } else {
      graphVars.edgeS = edge;
      edge.saveColor();
      edge.setColor(vars.colorS);
    }
    return redraw();
  };

  drawEdgeStart = function(elmt) {
    var source;
    console.log("panda milk tea (edge start)");
    graphVars.canAdd = false;
    source = graphVars.nodeS;
    return graphVars.edgeN = new Edge(nodeGenID(), source, null, Object.assign({}, graphVars.edgeAttr));
  };

  drawEdgeEnd = function() {
    console.log("milk grass jelly (edge end)");
    if (graphVars.nodeME !== graphVars.edgeN.source) {
      graphVars.edgeN.setTarget(graphVars.nodeME);
      graphVars.graph.addEdge(graphVars.edgeN);
    }
    graphVars.edgeN = null;
    return redraw();
  };

  drawEdgeDrop = function() {
    console.log("hokkaido milk tea (edge drop)");
    return graphVars.edgeN = null;
  };

  nodeGenID = function() {
    return Math.random().toString(36).substr(2, 5);
  };


  /*
  Find the rank of a matrix; algorithm based on SVD.
  Params:
      matrix: the matrix lmao
   */

  matrixRank = function(matrix) {
    var x;
    return ((function() {
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
    })()).length;
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
      displacements = (function() {
        var results;
        results = [];
        for (node in vertexConfiguration) {
          coords = vertexConfiguration[node];
          results.push(numeric.sub(coords, firstCoords));
        }
        return results;
      })();
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
          row = (function() {
            var k, ref2, results;
            results = [];
            for (k = 0, ref2 = numVertices * embedDim; 0 <= ref2 ? k < ref2 : k > ref2; 0 <= ref2 ? k++ : k--) {
              results.push(0);
            }
            return results;
          })();
          for (i = k = 0, ref2 = embedDim; 0 <= ref2 ? k < ref2 : k > ref2; i = 0 <= ref2 ? ++k : --k) {
            row[leftInd + i] = -edgeDisplacement;
          }
          for (j = l = 0, ref3 = embedDim; 0 <= ref3 ? l < ref3 : l > ref3; j = 0 <= ref3 ? ++l : --l) {
            row[rightInd + j] = edgeDisplacement;
          }
          return row;
        }
      });
      return (function() {
        var k, len, ref, results;
        ref = this.edges;
        results = [];
        for (k = 0, len = ref.length; k < len; k++) {
          edge = ref[k];
          results.push(rigidityMatrixRow(edge));
        }
        return results;
      }).call(this);
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
      this.target = target1;
      this.attr = attr;
      this.saveColor();
    }

    Edge.prototype.setTarget = function(target) {
      return this.target = target;
    };

    Edge.prototype.setColor = function(stroke) {
      return this.attr.stroke = stroke;
    };

    Edge.prototype.saveColor = function() {
      return this.attr.strokeOld = this.attr.stroke;
    };

    Edge.prototype.getSavedColor = function() {
      return this.attr.strokeOld;
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
      this.saveColor();
    }

    Node.prototype.getColor = function() {
      return this.attr.fill;
    };

    Node.prototype.setColor = function(fill) {
      return this.attr.fill = fill;
    };

    Node.prototype.saveColor = function() {
      return this.attr.fillOld = this.attr.fill;
    };

    Node.prototype.getSavedColor = function() {
      return this.attr.fillOld;
    };

    return Node;

  })();

  countOccurences = function(array, elt) {
    var count, cur_index;
    count = 0;
    cur_index = -1;
    while ((cur_index = array.indexOf(elt, cur_index + 1)) !== -1) {
      count += 1;
    }
    return count;
  };

  PebbleGraph = (function(superClass) {
    extend(PebbleGraph, superClass);

    function PebbleGraph(nodes1, edges1, attr) {
      var k, len, ref, vertex;
      this.nodes = nodes1;
      this.edges = edges1;
      this.attr = attr;
      PebbleGraph.__super__.constructor.call(this, this.nodes, this.edges, this.attr);
      this.pebbleIndex = {};
      ref = this.nodes;
      for (k = 0, len = ref.length; k < len; k++) {
        vertex = ref[k];
        this.pebbleIndex[vertex.id.toString()] = [-1, -1];
      }
      this.independentEdges = [];
      this.remainingEdges = this.edges.slice();
      this.enlargeCoverIteration = 0;
      this.curCandIndEdge = -1;
    }

    PebbleGraph.prototype.pebbleIndex = function() {
      return this.pebbleIndex;
    };

    PebbleGraph.prototype.algorithmState = function() {
      var edge, edgeCounts, entries, entry, k, l, len, len1, len2, m, ref, ref1, ref2, vertex, vertexCounts, vertexid;
      edgeCounts = {};
      ref = this.edges;
      for (k = 0, len = ref.length; k < len; k++) {
        edge = ref[k];
        edgeCounts[edge.id.toString()] = 0;
      }
      vertexCounts = {};
      ref1 = this.nodes;
      for (l = 0, len1 = ref1.length; l < len1; l++) {
        vertex = ref1[l];
        vertexCounts[vertex.id.toString()] = 0;
      }
      ref2 = this.pebbleIndex;
      for (vertexid in ref2) {
        entries = ref2[vertexid];
        for (m = 0, len2 = entries.length; m < len2; m++) {
          entry = entries[m];
          if (entry === -1) {
            vertexCounts[vertexid] += 1;
          } else {
            edgeCounts[entry.id] += 1;
          }
        }
      }
      return {
        "edgeCounts": edgeCounts,
        "vertexCounts": vertexCounts,
        "independentEdges": this.independentEdges
      };
    };

    PebbleGraph.prototype._reassignPebble = function(vertex, oldval, newval) {
      var index;
      index = this.pebbleIndex[vertex.id].indexOf(oldval);
      if (index === -1) {
        return false;
      }
      this.pebbleIndex[vertex.id][index] = newval;
      return true;
    };


    /*
    Attempt to allocate a free pebble from `vertex` to `edge`,
    returning true if successful.
    See `hasFreePebble` for a definition of "free pebble".
     */

    PebbleGraph.prototype.allocatePebble = function(vertex, edge) {
      var pebIndVertEntry, redundantlyCoveredEdges, x;
      if (vertex !== edge.source && vertex !== edge.target) {
        raise(ValueError("Edge " + edge + " not incident to vertex " + vertex));
      }
      if (this._reassignPebble(vertex, -1, edge)) {
        return true;
      }
      pebIndVertEntry = this.pebbleIndex[vertex.id];
      redundantlyCoveredEdges = [
        (function() {
          var k, len, results;
          if (x !== -1 && edgeRedundantlyCovered(x)) {
            results = [];
            for (k = 0, len = pebIndVertEntry.length; k < len; k++) {
              x = pebIndVertEntry[k];
              results.push(x);
            }
            return results;
          }
        })()
      ];
      if (redundantlyCoveredEdges.length > 0) {
        return this._reassignPebble(vertex, redundantlyCoveredEdges[0], edge);
      }
      return false;
    };


    /*
    Reallocate a pebble belonging to `vertex` from `oldedge` to `newedge`.
     */

    PebbleGraph.prototype.reallocatePebble = function(vertex, oldedge, newedge) {
      if (vertex !== newedge.source && vertex !== newedge.target) {
        raise(ValueError("Edge " + edge + " not incident to vertex " + vertex));
      }
      return this._reassignPebble(vertex, oldedge, newedge);
    };


    /*
    Return true iff `vertex` has a free pebble:
    a pebble not assigned to an edge or assigned to a multiply-covered edge.
     */

    PebbleGraph.prototype.hasFreePebble = function(vertex) {
      var pebIndVertEntry;
      pebIndVertEntry = this.pebbleIndex[vertex.id];
      return pebIndVertEntry.some(elt((function(_this) {
        return function() {
          return elt === -1 || edgeRedundantlyCovered(elt);
        };
      })(this)));
    };

    PebbleGraph.prototype.edgePebbleCount = function(edge) {
      var left, ref, right;
      ref = [edge.source, edge.target], left = ref[0], right = ref[1];
      return countOccurences(this.pebbleIndex[left.id], edge) + countOccurences(this.pebbleIndex[right.id], edge);
    };

    PebbleGraph.prototype.edgeRedundantlyCovered = function(edge) {
      return (edgePebbleCount > 1 && edge !== this.curCandIndEdge) || edgePebbleCount > 4;
    };

    PebbleGraph.prototype.pebbledEdgesAndNeighbors = function(vertex) {
      var e, otherVertex, pebbleAssignments;
      otherVertex = function(edge) {
        var x;
        return ((function() {
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
        })())[0];
      };
      pebbleAssignments = this.pebbleIndex[vertex.id];
      return (function() {
        var k, len, results;
        results = [];
        for (k = 0, len = pebbleAssignments.length; k < len; k++) {
          e = pebbleAssignments[k];
          if (e !== -1) {
            results.push([otherVertex(e), e]);
          }
        }
        return results;
      })();
    };


    /*
    Returns:
        true if algorithm is complete, false otherwise
     */

    PebbleGraph.prototype.stepAlgorithm = function() {
      var enlargementSuccessful;
      if (this.remainingEdges.length === 0) {
        alert("algorithm complete!");
        return "";
      }
      if (this.enlargeCoverIteration === 0) {
        this.curCandIndEdge = this.remainingEdges.pop();
      }
      enlargementSuccessful = this.enlargeCover(this.curCandIndEdge);
      if (enlargementSuccessful) {
        this.enlargeCoverIteration += 1;
        if (this.enlargeCoverIteration === 4) {
          this.independentEdges.push(this.curCandIndEdge);
          this.enlargeCoverIteration = 0;
        }
      } else {
        this.enlargeCoverIteration = 0;
      }
      console.log(this.remainingEdges);
      return this.remainingEdges.length === 0;
    };


    /*
    Cover enlargement for the pebble algorithm.
    Params:
         graph: trivial
         edge: Edge object we'd like to cover with pebbles.
     */

    PebbleGraph.prototype.enlargeCover = function(edge) {
      var found, k, left, len, path, ref, ref1, ref2, right, seen, vertex;
      ref = [{}, {}], seen = ref[0], path = ref[1];
      ref1 = this.nodes;
      for (k = 0, len = ref1.length; k < len; k++) {
        vertex = ref1[k];
        seen[vertex.id.toString()] = false;
        path[vertex.id.toString()] = -1;
      }
      ref2 = [edge.source, edge.target], left = ref2[0], right = ref2[1];
      found = this.findPebble(left, seen, path);
      if (found) {
        this.rearrangePebbles(left, edge, path);
        return true;
      }
      if (!seen[right.id]) {
        found = this.findPebble(right, seen, path);
        if (found) {
          this.rearrangePebbles(right, edge, path);
          return true;
        }
      }
      return false;
    };

    PebbleGraph.prototype.findPebble = function(vertex, seen, path) {
      var ref, ref1, ref2, x, xedge, y, yedge;
      seen[vertex.id.toString()] = true;
      path[vertex.id.toString()] = -1;
      if (this.hasFreePebble(vertex)) {
        return true;
      }
      console.log(this.pebbledEdgesAndNeighbors(vertex));
      ref = this.pebbledEdgesAndNeighbors(vertex), (ref1 = ref[0], x = ref1[0], xedge = ref1[1]), (ref2 = ref[1], y = ref2[0], yedge = ref2[1]);
      if (!seen[x.id.toString()]) {
        path[vertex.id.toString()] = [x, xedge];
        if (this.findPebble(x, seen, path)) {
          return true;
        }
      }
      if (!seen[y.id.toString()]) {
        path[vertex.id.toString()] = [y, yedge];
        if (this.findPebble(y, seen, path)) {
          return true;
        }
      }
      return false;
    };

    PebbleGraph.prototype.rearrangePebbles = function(vertex, edge, path) {
      var _, newedge, oldedge, ref, ref1, results, w;
      w = vertex;
      newedge = edge;
      results = [];
      while (w !== -1) {
        if (path[w.id.toString()] === -1) {
          this.allocatePebble(w, newedge);
        } else {
          ref = path[w.id.toString()], _ = ref[0], oldedge = ref[1];
          this.reallocatePebble(w, oldedge, newedge);
        }
        vertex = w;
        if (path[vertex.id] === -1) {
          results.push(w = -1);
        } else {
          results.push((ref1 = path[vertex.id], w = ref1[0], newedge = ref1[1], ref1));
        }
      }
      return results;
    };

    return PebbleGraph;

  })(Graph);

  showHelp = function() {
    return $("#aboutPanel").show();
  };

  hideHelp = function() {
    console.log("yogurt milk tea");
    return $("#aboutPanel").hide();
  };

}).call(this);
