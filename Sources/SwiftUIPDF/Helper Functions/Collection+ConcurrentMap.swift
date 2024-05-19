//
//  Collection.swift
//  
//
//  Created by Jia Chen Yee on 19/5/24.
//

import Foundation

extension Collection {
    func concurrentMap<Output>(_ transformation: @escaping (Element) async -> Output) async -> [Output] {
        await withTaskGroup(of: (Int, Output).self) { group in
            for (index, item) in enumerated() {
                group.addTask {
                    let transformedItem = await transformation(item)
                    return (index, transformedItem)
                }
            }
            
            var results = Array<Output?>(repeating: nil, count: count)
            
            for await (index, result) in group {
                results[index] = result
            }
            
            return results.compactMap { $0 }
        }
    }
}
