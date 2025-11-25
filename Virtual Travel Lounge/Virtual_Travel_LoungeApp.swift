//
//  Virtual_Travel_LoungeApp.swift
//  Virtual Travel Lounge
//
//  Created by STUDENT on 2025-11-24.
//

import SwiftUI
import CoreData

@main
struct Virtual_Travel_LoungeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
