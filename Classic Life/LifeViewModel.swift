//
//  LifeViewModel.swift
//  Classic Life
//
//  Created by David S Reich on 24/4/20.
//  Copyright © 2020 StellarSoftware. All rights reserved.
//

import UIKit

class LifeViewModel: ObservableObject {
    @Published var rowsCols: Int
    @Published var speed = 4.5
    @Published var running = false
    @Published var paused = false
    @Published var noMoreChanges = false
    @Published var cellState: [[Int]]

    var speedRange = 1.0...20.0

    private var timer: Timer?

    init(rowsCols: Int) {
        self.rowsCols = rowsCols
        cellState = Array(repeating: Array(repeating: 0, count: rowsCols), count: rowsCols)
    }

    func setSize(rowsCols: Int) {
        self.rowsCols = rowsCols
        cellState = Array(repeating: Array(repeating: 0, count: rowsCols), count: rowsCols)
    }

    func cellTapped(row: Int, col: Int) {
        cellState[row][col] = cellState[row][col] == 0 ? 1 : 0
    }

    func resetCells() {
        cellState = Array(repeating: Array(repeating: 0, count: rowsCols), count: rowsCols)
    }

    //include cell itself in the count
    private func countLiveCells(row: Int, col: Int) -> Int {
        // first/last rows and cols are INCLUSIVE
        let firstRow = row == 0 ? 0 : row - 1
        let lastRow = row == rowsCols - 1 ? row : row + 1
        let firstCol = col == 0 ? 0 : col - 1
        let lastCol = col == rowsCols - 1 ? col : col + 1

        var liveCells = 0
        for row in firstRow...lastRow {
            for col in firstCol...lastCol {
                liveCells += cellState[row][col]
            }
        }

        return liveCells
    }

    func stop() {
        halt()
        running = false
        paused = false
    }

    private func halt() {
        timer?.invalidate()
        timer = nil
    }

    func pause() {
        paused.toggle()

        if !paused {
            run()
        } else {
            halt()
        }
    }

    func step() {
        nextCellState()
    }

    func run() {
        running = true
        paused = false
        noMoreChanges = false

        timer = Timer.scheduledTimer(withTimeInterval: 1 / speed, repeats: true, block: {_ in
            self.nextCellState()
        })

        timer?.fire()
    }

    private func nextCellState() {
        var nextCellState = Array(repeating: Array(repeating: 0, count: rowsCols), count: rowsCols)

        for row in 0..<rowsCols {
            for col in 0..<rowsCols {
                let liveCells = countLiveCells(row: row, col: col)
                switch liveCells {
                case 4:
                    //no change if 4
                    nextCellState[row][col] = cellState[row][col]
                case 3:
                    nextCellState[row][col] = 1
                default:
                    nextCellState[row][col] = 0
                }
            }
        }

        if cellState == nextCellState {
            noMoreChanges = true
            stop()
        } else {
            cellState = nextCellState
        }
    }
}
