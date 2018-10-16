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

library PolygonLib {
    enum Color {
        RED,
        BLUE
    }

    enum Operation {
        XOR,
        OR,
        AND,
        SUB,
        RSUB
    }

    enum SortEdgeMode {
        SIMPLE,
        LEX2
    }

    struct Point {
        int256 start;
        int256 end;
    }

    struct Edge {
        uint256 start;
        uint256 end;
        uint256 index;
    }

    struct Cell {
        int256 start;
        int256 middle;
        int256 end;
    }

    struct Bound {
        int256 first;
        int256 second;
        int256 third;
        int256 fourth;
    }

    function simpleCompareEdge(Edge a, Edge b) returns (uint256) {
        uint256 minResult = MathHelper.min(a.start, a.end) - MathHelper.min(b.start, b.end);
        uint256 maxResult = MathHelper.max(a.start, a.end) - MathHelper.max(b.start, b.end);
        return minResult != 0 ? minResult : maxResult;
    }

    function lex2CompareEdge(Edge a, Edge b) returns (uint256) {
        uint256 startResult = a.start - b.start;
        uint256 endResult = a.end - b.end;
        return startResult != 0 ? startResult : endResult;
    }

    function sortEdges(Edge[] memory arr, SortEdgeMode mode) {
        bubbleSortEdges(arr, mode, arr.length);
        return arr;
    }

    // https://www.geeksforgeeks.org/recursive-bubble-sort/
    function bubbleSortEdges(Edge[] memory arr, SortEdgeMode mode, uint n) {
        if(n < 2) {
            return;
        }

        for(var i = 0; i < n - 1; i++) {
            bool compareResult;
            if(mode == SortEdgeMode.SIMPLE) {
                compareResult = simpleCompareEdge(arr[i], arr[i + 1]) > 0;
            } else if(mode == SortEdgeMode.LEX2) {
                compareResult = lex2CompareEdge(arr[i], arr[i + 1]) > 0;
            }
            if(compareResult) {
                Edge memory temp = arr[i];
                arr[i] = arr[i + 1];
                arr[i + 1] = temp;
            }
        }

        bubbleSortEdges(arr, mode, n - 1);
    }
}