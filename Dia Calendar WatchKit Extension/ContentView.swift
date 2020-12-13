//
//  ContentView.swift
//  Dia Calendar WatchKit Extension
//
//  Created by Ivan Druzhinin on 23.11.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LightCalendarPagerView(
            scheme: .standard,
            viewModel: LightCalendarPagerViewModel(calendar: .makeCalendar(), today: Date())
        )
        .modifier(AdjustedWatchFonts())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
