//
//  StarterView.swift
//  Classic Life
//
//  Created by David S Reich on 28/4/20.
//  Copyright © 2020 StellarSoftware. All rights reserved.
//

import SwiftUI

struct StarterView: View {
    @State private var showLaunchScreen = true

    var body: some View {
        Group {
            if showLaunchScreen {
                LaunchScreenView(isPresented: $showLaunchScreen)
            } else {
                LifeView()
            }
        }
    }
}

struct StarterView_Previews: PreviewProvider {
    static var previews: some View {
        StarterView()
    }
}
