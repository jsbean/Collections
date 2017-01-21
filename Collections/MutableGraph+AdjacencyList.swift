//
//  MutableGraph+AdjacencyList.swift
//  Collections
//
//  Created by James Bean on 1/16/17.
//
//

extension MutableGraph {
    
    public class AdjacencyList {
        
        fileprivate var edgeLists: [EdgeList] = []
        
        init() { }
        
        subscript (vertex: Node) -> EdgeList? {
            for edgeList in edgeLists {
                if edgeList.vertex === vertex {
                    return edgeList
                }
            }
            return nil
        }
        
        func addDirectedEdge(from source: Node, to destination: Node, weight: Float? = nil) {
            addVertex(source)
            addVertex(destination)
            
            let sourceEdgeList = self[source]!
            sourceEdgeList.addEdge(to: destination, weight: weight)
            
            addEdgeList(sourceEdgeList)
        }
        
        func addVertex(_ vertex: Node) {
            if self[vertex] == nil {
                let edgeList = EdgeList(vertex: vertex)
                addEdgeList(edgeList)
            }
        }
        
        func addEdgeList(_ edgeList: EdgeList) {
            if self[edgeList.vertex] == nil {
                edgeLists.append(edgeList)
            }
        }
    }
}

extension MutableGraph.AdjacencyList: AnyCollectionWrapping {
    
    public var collection: AnyCollection<MutableGraph.EdgeList> {
        return AnyCollection(edgeLists)
    }
}
