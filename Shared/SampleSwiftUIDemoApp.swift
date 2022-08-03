//
//  SampleSwiftUIDemoApp.swift
//  Shared
//
//  Created by Sunil K on 03/08/22.
//

import SwiftUI

@main
struct SampleSwiftUIDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
