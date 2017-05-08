

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
enlargeCover = (graph, edge) ->
  seen = {vertex: false for vertex in graph.nodes}
  path = {vertex: -1 for vertex in graph.nodes}

  left, right = edge.source, edge.target
  found = findPebble(graph, left, seen, path)
  if found
    rearrangePebbles(graph, left, seen)
    return true
  
  if not seen[right]
    found = findPebble(graph, right, seen, path)
    if found
      rearrangePebbles(graph, right, path)
      return true

  return false

findPebble = (graph, vertex, seen, path) ->
  seen[vertex] = true
  path[vertex] = -1
  if graph.hasFreePebble(vertex)
    return true

  # taken from the paper; probably should clean up code smell
  (x, xedge), (y, yedge) = pebbledEdgesAndNeighbors(vertex)
  if not seen[x]
    path[vertex] = x, xedge
    if findPebble(graph, x, seen, path)
      return true
  if not seen[y]
    path[vertex] = y, yedge
    if findPebble(graph, y, seen, path)
      return true
  return false


rearrangePebbles = (graph, vertex, path) ->
  while (path[vertex] != -1)
    w, edge = path[vertex]
    if path[w] == -1
      graph.allocatePebble(w, edge)
    else
      _, oldedge = path[w]
      graph.reallocatePebble(w, oldedge, edge)
    vertex = w

