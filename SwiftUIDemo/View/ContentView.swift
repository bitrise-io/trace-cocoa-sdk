//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Shams Ahmed on 24/08/2020.
//  Copyright © 2020 Bitrise. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
           NavigationLink(destination: DetailedView()) {
              Text("Tap here!")
           }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
