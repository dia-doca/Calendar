//
//  Comparable+Bounded.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 09.01.2021.
//

import Foundation


extension Comparable {
    func bounded(in range: ClosedRange<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        } else {
            return self
        }
    }
}
