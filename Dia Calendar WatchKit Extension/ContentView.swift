//
//  ContentView.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 23.11.2020.
//

import SwiftUI


struct ContentView: View {

    @ObservedObject private var viewModel = ViewModel()

    var body: some View {
        CalendarNavigationView(
            today: viewModel.today,
            calendar: viewModel.calendar,
            scheme: viewModel.scheme
        )
    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
    
}
