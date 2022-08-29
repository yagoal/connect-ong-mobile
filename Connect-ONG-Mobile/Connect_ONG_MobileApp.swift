//
//  Connect_ONG_MobileApp.swift
//  Connect-ONG-Mobile
//
//  Created by Yago Pereira on 28/8/22.
//

import SwiftUI

@main
struct Connect_ONG_MobileApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
