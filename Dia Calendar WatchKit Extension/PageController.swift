//
//  PageController.swift
//  Calendar
//
//  Created by Ivan Druzhinin on 17.04.2021.
//

import SwiftUI


struct PageControllerView<Content: View>: View {

    private let pagesCount: Int
    private let content: Content

    @State private var currentPageIndex = 0
    @GestureState private var translation: CGFloat = 0

    private let pagesSpacing: CGFloat = 12

    init(pageCount: Int, @ViewBuilder content: () -> Content) {
        self.pagesCount = pageCount
        self.content = content()
    }

    var body: some View {
        ZStack {
            pageView
            VStack {
                Spacer()
                pageControlView
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    private var pageView: some View {
        GeometryReader { geometry in
            HStack(spacing: pagesSpacing) {
                content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(currentPageIndex) * (geometry.size.width + pagesSpacing))
            .offset(x: translation)
            .animation(.linear)
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / (geometry.size.width + pagesSpacing)
                    let newIndex = (CGFloat(self.currentPageIndex) - offset).rounded()
                    currentPageIndex = min(max(Int(newIndex), 0), pagesCount - 1)
                }
            )
        }
    }

    private var pageControlView: some View {
        HStack{
            ForEach(0 ..< pagesCount) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentPageIndex == index ? Color.white : Color.gray)
            }
        }
        .padding(8)
    }

}
