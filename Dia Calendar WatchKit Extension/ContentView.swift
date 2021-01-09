//
//  ContentView.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 23.11.2020.
//

import SwiftUI


struct ContentView: View {

    @State var today = Date()

    private let calendar = Calendar.current

    var body: some View {
        CalendarNavigationView(
            today: today,
            calendar: calendar,
            scheme: .standard
        )
        .onReceive(NotificationCenter.default.publisher(for: WKExtension.applicationWillEnterForegroundNotification)) { _ in
            if !calendar.isDateInToday(today) {
                today = Date()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
    
}
