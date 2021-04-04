//
//  ContentView.swift
//  Shared
//
//  Created by Ivan Druzhinin on 21.11.2020.
//

import SwiftUI


struct ContentView: View {

    var body: some View {
        List {
            CalendarView(
                today: Date(),
                month: Date(),
                calendar: Calendar.current,
                scheme: .standard
            )
            .aspectRatio(1, contentMode: .fit)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
            )
            .padding()

            YearView(
                today: Date(),
                year: Date(),
                calendar: Calendar.current,
                scheme: .standard
            )
            
        }
    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ForEach(SimulatorDevices.iphones, id: \.self) { device in
            ContentView()
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }

    }

}
