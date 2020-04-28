//
//  BoardView.swift
//  Classic Life
//
//  Created by David S Reich on 24/4/20.
//  Copyright © 2020 StellarSoftware. All rights reserved.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var lifeViewModel: LifeViewModel
    var boardSize: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<lifeViewModel.rowsCols, id: \.self) { row in
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<self.lifeViewModel.rowsCols, id: \.self) { col in
                        Rectangle()
                            .foregroundColor(self.lifeViewModel.cellState[row][col] == 0 ? .white : .black)
                            .onTapGesture {
                                self.lifeViewModel.cellTapped(row: row, col: col)
                        }
                        .disabled(self.lifeViewModel.running && !self.lifeViewModel.paused)
                    }
                }
            }
        }
        .frame(width: boardSize, height: boardSize, alignment: .center)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        let lifeViewModel = LifeViewModel(rowsCols: 20)
        let boardSize = CGFloat(min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.9)
        return BoardView(lifeViewModel: lifeViewModel, boardSize: boardSize)
    }
}
