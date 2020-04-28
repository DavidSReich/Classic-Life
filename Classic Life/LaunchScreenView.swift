//
//  LaunchScreenView.swift
//  Classic Life
//
//  Created by David S Reich on 28/4/20.
//  Copyright © 2020 StellarSoftware. All rights reserved.
//

import SwiftUI

struct LaunchScreenView: View {
    @ObservedObject var lifeViewModel = LifeViewModel(rowsCols: 5)
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            BoardView(lifeViewModel: self.lifeViewModel, boardSize: CGFloat(min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.5))
                .padding(1)
                .border(Color.black, width: 2)
                .disabled(true)

            VStack {
                Text("Classic Life").font(.largeTitle).bold()

                Text("In memoriam:")
                Text("John Horton Conway")
                Text("1937 - 2020")
                Text("")
                Text("Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.")
                    .font(.caption).bold()
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
        }
        .onAppear(perform: setupBoard)
    }

    private func setupBoard() {
        lifeViewModel.cellTapped(row: 1, col: 1)
        lifeViewModel.cellTapped(row: 2, col: 2)
        lifeViewModel.cellTapped(row: 2, col: 3)
        lifeViewModel.cellTapped(row: 3, col: 1)
        lifeViewModel.cellTapped(row: 3, col: 2)

        goAway()
    }

    private func goAway() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isPresented = false
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    @State static var showLaunch = true
    static var previews: some View {
        LaunchScreenView(isPresented: $showLaunch)
    }
}
