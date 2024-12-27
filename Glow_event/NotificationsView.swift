//
//  NotificationsView.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import Foundation
import SwiftUI

struct NotificationsView: View {
    @ObservedObject var notificationStore: NotificationStore

    var body: some View {
        NavigationView {
            List(notificationStore.notifications) { notification in
                VStack(alignment: .leading) {
                    Text(notification.title)
                        .font(.headline)
                    Text(notification.body)
                        .font(.subheadline)
                    Text("\(notification.timestamp, formatter: dateFormatter)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Notifications")
        }
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
