//
//  DateFormatter.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 08.12.2020.
//

import Foundation


extension DateFormatter {

    static let year = DateFormatter(dateFormat: "YYYY")
    
}

private extension DateFormatter {

    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }

}
