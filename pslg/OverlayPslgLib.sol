/*
 * Copyright ©️ 2018 Galt•Space Society Construction and Terraforming Company
 * (Founded by [Nikolai Popeka](https://github.com/npopeka),
 * [Dima Starodubcev](https://github.com/xhipster),
 * [Valery Litvin](https://github.com/litvintech) by
 * [Basic Agreement](http://cyb.ai/QmSAWEG5u5aSsUyMNYuX2A2Eaz4kEuoYWUkVBRdmu9qmct:ipfs)).
 *
 * Copyright ©️ 2018 Galt•Core Blockchain Company
 * (Founded by [Nikolai Popeka](https://github.com/npopeka) and
 * Galt•Space Society Construction and Terraforming Company by
 * [Basic Agreement](http://cyb.ai/QmaCiXUmSrP16Gz8Jdzq6AJESY1EAANmmwha15uR3c1bsS:ipfs)).
 */

pragma solidity 0.4.24;
pragma experimental "v0.5.0";

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./MathHelper.sol";
import "./PolygonLib.sol";

library OverlayPslgLib {
  using SafeMath for uint256;

  function getOperationTable(PolygonLib.Operation op) public pure returns (uint8[]) {
    if(op == Operation.XOR) {
      return [0, 1, 1, 0];
    } else if(op == Operation.OR) {
      return [0, 1, 1, 1];
    } else if(op == Operation.AND) {
      return [0, 0, 0, 1];
    } else if(op == Operation.SUB) {
      return [0, 1, 0, 0];
    } else if(op == Operation.RSUB) {
      return [0, 0, 1, 0];
    }
  }
  
  function getCellValue(PolygonLib.Cell cell, uint8 index) returns(uint256) {
    return index == 0 ? cell.start : (index == 1 ? cell.middle : cell.end);
  }

  function edgeCellIndex(PolygonLib.Edge edge, PolygonLib.Cell cell) returns (int8) {
    for(int8 i = 0; i < 3; ++i) {
      uint256 cellValue = getCellValue(cell, i);
      if(cellValue != edge.start && cellValue != edge.end) {
        return i;
      }
    }
    return -1;
  }

  function buildCellIndex(PolygonLib.Cell[] cells) returns(int256[]) {
    //Initialize cell index
    uint256 cellsLength = cells.length * 3;
    int256[] cellIndex;
    
    for(uint256 i=0; i < cellsLength; ++i) {
      cellIndex[i] = -1;
    }

    //Sort edges
    uint256[] edges;
    for(uint256 i=0; i < cells.length; ++i) {
      PolygonLib.Cell memory c = cells[i];
      PolygonLib.Edge memory e;
      for(uint8 j = 0; j<3; ++j) {
        e.start = getCellValue(c, j);
        e.end = getCellValue(c, (j+1)%3);
        e.index = i;
      }
    }

    PolygonLib.sortEdges(edges, SortEdgeMode.SIMPLE);

    //For each pair of edges, link adjacent cells
    for(uint i = 1; i < edges.length; ++i) {
      PolygonLib.Edge e = edges[i];
      PolygonLib.Edge f = edges[i-1];
      
      if(compareEdge(e, f) != 0) {
        continue;
      }
      
      uint256 ce = e.index;
      uint256 cf = f.index;
      
      int8 ei = edgeCellIndex(e, cells[ce]);
      int8 fi = edgeCellIndex(f, cells[cf]);
      
      cellIndex[3 * ce + ei] = cf;
      cellIndex[3 * cf + fi] = ce;
    }
  
    return cellIndex;
  }

  function canonicalizeEdges(PolygonLib.Edge[] edges) {
    for(uint i=0; i < edges.length; ++i) {
      PolygonLib.Edge memory e = edges[i];
      e.start = MathHelper.min(e.start, e.end);
      e.end = MathHelper.max(e.start, e.end);
    }
    PolygonLib.sortEdges(edges, SortEdgeMode.LEX2);
  }

  function isConstraint(PolygonLib.Edge[] edges, uint a, uint b) returns (bool){
    PolygonLib.Edge memory abEdge;
    abEdge.start = MathHelper.min(a,b);
    abEdge.end = MathHelper.max(a,b);
    
    for(uint i=0; i < edges.length; ++i) {
      PolygonLib.Edge e = edges[i];
      e.start = MathHelper.min(e.start, e.end);
      e.end = MathHelper.max(e.start, e.end);
      if(e.start == abEdge.start && b.end == abEdge.end) {
        return true;
      }
    }
  }

  //Classify all cells within boundary
  function markCells(PolygonLib.Cell[] cells, int[] adj, PolygonLib.Edge[] edges) returns(int[]) {
  
    //Initialize active/next queues and flags
    //var flags = new Array(cells.length)
    int[] flags;
    bool[] constraint;
    for(uint i=0; i<3*cells.length; ++i) {
      constraint[i] = false;
    }
    int[] active;
    int[] next;
    for(uint i = 0; i < cells.length; ++i) {
      PolygonLib.Cell c = cells[i];
      flags[i] = 0;
      
      for(uint j = 0; j < 3; ++j) {
        uint256 a = getCellValue(c, (j+1)%3);
        uint256 b = getCellValue(c, (j+2)%3);
        
        bool constr = isConstraint(edges, a, b);
        constraint[3*i+j] = constr;
        
        if(adj[3*i+j] >= 0) {
          continue;
        }
        if(constr) {
          next.push(i);
        } else {
          flags[i] = 1;
          active.push(i);
        }
      }
    }
  
    //Mark flags
    uint side = 1;
    while(active.length > 0 || next.length > 0) {
      while(active.length > 0) {
        int t = active[active.length - 1];
        delete[active.length - 1];
        active.length--;
        
        if(flags[t] == -side) {
          continue;
        }
        flags[t] = side;
        PolygonLib.Cell c = cells[t];
        
        for(uint j=0; j<3; ++j) {
          int f = adj[3*t+j];
          if(f >= 0 && flags[f] == 0) {
            if(constraint[3*t+j]) {
              next.push(f);
            } else {
              active.push(f);
              flags[f] = side;
            }
          }
        }
      }
      
      //Swap arrays and loop
      int[] tmp = next;
      next = active;
      active = tmp;
      next.length = 0;
      side = -side;
    }
    
    return flags;
  }

  function setIntersect(PolygonLib.Edge[] colored, PolygonLib.Edge[] edges) returns(PolygonLib.Edge[]) {
    uint ptr = 0;
    uint i = 0;
    uint j = 0;
    while(i < colored.length && j < edges.length) {
      PolygonLib.Point e = colored[i];
      PolygonLib.Edge f = edges[j];
      uint256 d = lex2CompareEdge(e, f);
      if(d < 0) {
        i += 1;
      } else if(d > 0) {
        j += 1;
      } else {
        colored[ptr++] = colored[i];
        i += 1;
        j += 1;
      }
    }
    colored.length = ptr;
    return colored;
  }

  function relabelEdges(PolygonLib.Edge[] edges, uint256[] labels) {
    for(var i=0; i < edges.length; ++i) {
      PolygonLib.Edge e = edges[i];
      e.start = labels[e.start];
      e.end = labels[e.end];
    }
  }

  function markEdgesActive(PolygonLib.Edge[] edges, uint256[] labels) {
    for(uint i = 0; i < edges.length; ++i) {
      PolygonLib.Edge e = edges[i];
      labels[e.start] = 1;
      labels[e.end] = 1;
    }
  }

  function removeUnusedPoints(PolygonLib.Point[] points, PolygonLib.Edge[] redE, PolygonLib.Edge[] blueE) {
    uint256 labels;
    for(uint i = 0; i < points.length; ++i) {
      labels.push(-1);
    }
    markEdgesActive(redE, labels);
    markEdgesActive(blueE, labels);

    uint256 ptr = 0;
    for(uint i = 0; i < points.length; ++i) {
      if(labels[i] > 0) {
        labels[i] = ptr;
        points[ptr++] = points[i];
      }
    }
    
    points.length = ptr;
    relabelEdges(redE, labels);
    relabelEdges(blueE, labels);
  }

  function overlayPSLG(PolygonLib.Point[] redPoints, PolygonLib.Edge[] redEdges, 
                        PolygonLib.Point[] bluePoints, PolygonLib.Edge[] blueEdges, PolygonLib.Operation op)
    returns (
      PolygonLib.Point[] points,
      PolygonLib.Edge[] red,
      PolygonLib.Edge[] blue
    )
  {
    //1. Concatenate points
    uint numRedPoints = redPoints.length;
    uint numRedEdges  = redEdges.length;
    uint numBlueEdges = blueEdges.length;

    PolygonLib.Point[] points;
    for(uint i = 0; i < redPoints.length; i++) {
      points.push(redPoints[i]);
    }
    for(uint i = 0; i < bluePoints.length; i++) {
      points.push(bluePoints[i]);
    }

    //2. Concatenate edges
    PolygonLib.Edge[] edges;
    PolygonLib.Color[] colors;
    for(uint i = 0; i < redEdges.length; ++i) {
      PolygonLib.Edge e = redEdges[i];
      
      colors.push(Color.RED);
      
      edges.push(PolygonLib.Edge({
        start: e.start,
        end: e.end
      }));
    }
    for(uint i = 0; i < blueEdges.length; ++i) {
      PolygonLib.Edge e = blueEdges[i];
    
      colors.push(Color.BLUE);
      
      edges.push(PolygonLib.Edge({
        start: e.start + numRedPoints,
        end: e.end + numRedPoints
      }));
    }

    //3. Run snap rounding with edge colors
    snapRound(points, edges, colors);

    //4. Sort edges
    canonicalizeEdges(edges);

    //5. Extract red and blue edges
    PolygonLib.Edge[] redE;
    PolygonLib.Edge[] blueE;

    for(uint i=0; i < edges.length; ++i) {
      if(colors[i] == Color.RED) {
        redE.push(edges[i]);
      } else {
        blueE.push(edges[i]);
      }
    }

    //6. Triangulate
    PolygonLib.Cell[] cells = TriangularLib.cdt2d(points, edges);

    //7. Build adjacency data structure
    int256[] adj = buildCellIndex(cells);

    //8. Classify triangles
    int[] redFlags = markCells(cells, adj, redE);
    int[] blueFlags = markCells(cells, adj, blueE);

    //9. Filter out cels which are not part of triangulation
    uint8[] table = getOperationTable(op);
    uint ptr = 0;
    for(uint i = 0; i < cells.length; ++i) {
      var code = ((redFlags[i] < 0)<<1) + (blueFlags[i] < 0);
      if(table[code]) {
        cells[ptr++] = cells[i];
      }
    }
    cells.length = ptr;

    //10. Extract boundary
    var bnd = boundary(cells);
    canonicalizeEdges(bnd);

    //11. Intersect constraint edges with boundary
    redE = setIntersect(redE, bnd);
    blueE = setIntersect(blueE, bnd);

    //12. Filter old points
    removeUnusedPoints(points, redE, blueE);

    return (
      points,
      redE,
      blueE
    );
  }
}
