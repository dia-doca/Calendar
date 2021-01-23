//
//  ContentView.swift
//  Shared
//
//  Created by Ivan Druzhinin on 21.11.2020.
//

import SwiftUI
import DiaCalendar


struct ContentView: View {

    var body: some View {
        CalendarView(
            today: Date(),
            month: Date(),
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
