//
//  File.swift
//  
//
//  Created by 向阳凡 on 2023/11/21.
//

import Foundation

extension String {
    func fan_subString(_ startIndex:Int,_ endIndex:Int) -> String {
        if self.lengthOfBytes(using: .utf8) <= endIndex {
            return ""
        }
        let index1 = self.index(self.startIndex, offsetBy: startIndex)
        let index2 = self.index(self.startIndex, offsetBy: endIndex)
        let indexRange = index1...index2
        let subString  = self[indexRange]
        return String(subString)
    }
    
}
