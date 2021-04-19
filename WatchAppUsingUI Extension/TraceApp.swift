//
//  TraceApp.swift
//  WatchAppUsingUI Extension
//
//  Created by Shams Ahmed on 19/04/2021.
//  Copyright © 2021 Bitrise. All rights reserved.
//

import SwiftUI

@main
struct TraceApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
