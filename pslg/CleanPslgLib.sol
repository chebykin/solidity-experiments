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
import "./PolygonLib.sol";
import "./MathHelperLib.sol";

library CleanPslgLib {
    using SafeMath for uint256;

    // Repeat until convergence
    function snapRound (PolygonLib.Point[] points, PolygonLib.Edge[] edges, PolygonLib.Color[] useColor) {
        // 1. find edge crossings
        var edgeBounds = boundEdges(points, edges);
        var crossings = getCrossings(points, edges, edgeBounds);
    
        // 2. find t-junctions
        var vertBounds = boundPoints(points);
        var tjunctions = getTJunctions(points, edges, edgeBounds, vertBounds);
    
        // 3. cut edges, construct rational points
        var ratPoints = cutEdges(points, edges, crossings, tjunctions, useColor);
    
        // 4. dedupe verts
        var labels = dedupPoints(points, ratPoints, vertBounds);
    
        // 5. dedupe edges
        dedupEdges(edges, labels, useColor);
    
        // 6. check termination
        if (!labels) {
            return (crossings.length > 0 || tjunctions.length > 0);
        }
    
        // More iterations necessary
        return true;
    }
    
    // Convert a list of edges in a pslg to bounding boxes
    function boundEdges (PolygonLib.Point[] points, PolygonLib.Edge[] edges) {
        PolygonLib.Bound[] bounds;
        
        for (uint i = 0; i < edges.length; i++) {
            PolygonLib.Edge e = edges[i];
            
            PolygonLib.Point a = points[e[0]];
            PolygonLib.Point b = points[e[1]];
            
            bounds.push(PolygonLib.Bound({
                first: MathHelperLib.nextafter(MathHelperLib.minInt(a[0], b[0]), MathHelperLib.INT256_MIN),
                second: MathHelperLib.nextafter(MathHelperLib.minInt(a[1], b[1]), MathHelperLib.INT256_MIN),
                third: MathHelperLib.nextafter(MathHelperLib.maxInt(a[0], b[0]), MathHelperLib.INT256_MAX),
                fourth: MathHelperLib.nextafter(MathHelperLib.maxInt(a[1], b[1]), MathHelperLib.INT256_MAX)
            }));
        }
        return bounds;
    }

    // Find all pairs of crossing edges in a pslg (given edge bounds)
    function getCrossings (PolygonLib.Point[] points, PolygonLib.Edge[] edges, PolygonLib.Bound[] edgeBounds) {
    var result = [];
    boxIntersect(edgeBounds, function (i, j) {
    var e = edges[i];
    var f = edges[j];
    if (e[0] === f[0] || e[0] === f[1] || e[1] === f[0] || e[1] === f[1]) {
        return;
    }
    var a = points[e[0]];
    var b = points[e[1]];
    var c = points[f[0]];
    var d = points[f[1]];
    if (segseg(a, b, c, d)) {
    result.push([i, j]);
    }
    })
    return result;
    }
}
