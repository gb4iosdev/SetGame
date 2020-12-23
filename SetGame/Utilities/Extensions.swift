//
//  Extensions.swift
//  Memorize
//
//  Created by Gavin Butler on 27-11-2020.
//

import Foundation

extension Array where Element: Identifiable {   //Constrains and Gains
    
    func firstIndex(matching: Element) -> Int? {
        if let index = self.firstIndex(where: { thisItem in
            matching.id == thisItem.id
        }) {
            return index
        }
        
        return nil
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
    
}
