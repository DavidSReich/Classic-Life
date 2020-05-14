//
//  LifeView.swift
//  Classic Life
//
//  Created by David S Reich on 24/4/20.
//  Copyright © 2020 StellarSoftware. All rights reserved.
//

import SwiftUI

struct LifeView: View {
    @ObservedObject var lifeViewModel = LifeViewModel(rowsCols: 20)
    @State private var showSizes = false

    private let sizes = [10, 20, 40]

    private let buttonBarHeight: CGFloat = 40

    var body: some View {
        Group {
            GeometryReader { geometry in
                VStack {
                    if geometry.size.height > geometry.size.width {
                        BoardView(lifeViewModel: self.lifeViewModel, boardSize: geometry.size.width * 0.9)
                            .padding(1)
                            .border(Color.black, width: 2)
                        self.sliderView()
                        self.buttonsView()
                    } else {
                        BoardView(lifeViewModel: self.lifeViewModel, boardSize: geometry.size.height * 0.75)
                            .padding(1)
                            .border(Color.black, width: 2)
                        HStack {
                            self.sliderView()
                            Divider()
                            Divider()
                            self.buttonsView()
                        }
                        .frame(height: self.buttonBarHeight)
                    }
                }
            }

        }
        .alert(isPresented: $lifeViewModel.noMoreChanges) {
            return Alert(title: Text("All Done!!!"),
                         message: Text("This is a stable \"still life\"."),
                         dismissButton: .default(Text("OK")))
        }
    }

    private func sliderView() -> some View {
        Slider(value: $lifeViewModel.speed, in: lifeViewModel.speedRange, minimumValueLabel: Image(systemName: "tortoise.fill"), maximumValueLabel: Image(systemName: "hare.fill")) {
            EmptyView()
        }
        .disabled(self.lifeViewModel.running)
        .padding(.horizontal)
    }

    private func buttonsView() -> some View {
        HStack(alignment: .center) {
            Button(action: { self.lifeViewModel.resetCells() }) {
                Image(systemName: "arrow.2.circlepath")
                    .imageScale(.large)
            }
            .disabled(self.lifeViewModel.running)

            Divider()

            Button(action: { self.showSizes = true }) {
                Image(systemName: "square.grid.4x3.fill")
                    .imageScale(.large)
            }
            .popover(isPresented: self.$showSizes, arrowEdge: .top) {
                ForEach(self.sizes, id: \.self) { num in
                    Button(action: {
                        self.lifeViewModel.setSize(rowsCols: num)
                         self.showSizes = false
                    }) {
                        HStack {
                            if num == self.lifeViewModel.rowsCols {
                                Image(systemName: "checkmark")
                                    .imageScale(.small)
                            }
                            Text("\(num) x \(num)")
                        }
                    }
                }
            }
            .disabled(self.lifeViewModel.running)

            Divider()

            Button(action: {
                self.lifeViewModel.stop() }) {
                Image(systemName: "hexagon.fill")
                    .foregroundColor(self.lifeViewModel.running ? .red : .gray)
                    .imageScale(.large)
            }
            .disabled(!self.lifeViewModel.running)

            Button(action: {
                self.lifeViewModel.pause() }) {
                Image(systemName: "pause")
                    .imageScale(.large)
            }
            .disabled(!self.lifeViewModel.running)

            Button(action: {
                self.lifeViewModel.step() }) {
                Image(systemName: "1.circle")
                    .imageScale(.large)
            }
            .disabled(self.lifeViewModel.running)

            Button(action: {
                self.lifeViewModel.run() }) {
                Image(systemName: "arrowshape.turn.up.right")
                    .imageScale(.large)
            }
            .disabled(self.lifeViewModel.running && !self.lifeViewModel.paused)
        }
        .frame(height: buttonBarHeight)
        .padding(.horizontal)
    }
}

struct LifeView_Previews: PreviewProvider {
    static var previews: some View {
        LifeView()
    }
}
