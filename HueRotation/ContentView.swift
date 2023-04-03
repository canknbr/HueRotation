//
//  ContentView.swift
//  HueRotation
//
//  Created by Can Kanbur on 3.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State var hueRotation = false
    var backgrounds = ["img1", "img2", "img3", "img4", "img5", "img6", "img7", "img8", "img9", "img10", "img11", "img12", "img13"].shuffled()

    var body: some View {
        GeometryReader {
            geo in
            BackgroundScroll(imageCount: backgrounds.count) {
                ForEach(0 ..< backgrounds.count) { number in
                    Image(backgrounds[number]).resizable().scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
            }.hueRotation(.degrees(hueRotation ? 50 : 500))
                .animation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true), value: hueRotation)
                .onAppear(){
                    hueRotation.toggle()
                }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundScroll<ViewContent: View>: View {
    var imageCount: Int
    var contentContainer: ViewContent
    @State var workingIndex: Int = 0
    let timer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()

    init(imageCount: Int, @ViewBuilder content: () -> ViewContent) {
        self.imageCount = imageCount
        contentContainer = content()
    }

    var body: some View {
        GeometryReader {
            geo in
            ZStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    contentContainer
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    .offset(x: CGFloat(workingIndex) * -geo.size.width, y: 0)
                    .animation(.easeInOut)
                    .onReceive(timer) { _ in
                        workingIndex = (workingIndex + 1) % (imageCount == 0 ? 1 : imageCount)
                    }

                HStack(spacing: 7) {
                    ForEach(0 ..< imageCount) { index in
                        Circle().frame(width: index == workingIndex ? 13 : 9, height: index == workingIndex ? 13 : 9)
                            .foregroundColor(index == workingIndex ? .white : .gray)
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .padding(.bottom, 20)
                            .animation(.easeInOut)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
