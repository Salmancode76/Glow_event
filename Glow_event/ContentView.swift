//
//  ContentView.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var notificationStore = NotificationStore()

    var body: some View {
        VStack {
            // Your main content
            Button("View Notifications") {
                // Navigate to NotificationsView
                let notificationsView = NotificationsView(notificationStore: notificationStore)
                // Present the view (you can use a NavigationLink or full-screen cover)
            }
        }
    }
}
