//
//  Date+Extension.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 08.12.2020.
//

import Foundation


extension Date {

    func string(for dateFormatter: DateFormatter) -> String {
        dateFormatter.string(from: self)
    }

}

