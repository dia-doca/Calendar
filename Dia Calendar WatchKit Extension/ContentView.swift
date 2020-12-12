//
//  ContentView.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 23.11.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        InteractiveCalendarPagerView(
            today: Date(),
            calendar: Calendar.current,
            scheme: .standard
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
