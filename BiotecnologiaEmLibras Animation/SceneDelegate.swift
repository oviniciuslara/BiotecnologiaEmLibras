//
//  SceneDelegate.swift
//  BiotecnologiaEmLibras Animation
//
//  Created by Vinicius Lara on 09/11/20.
//  Copyright © 2020 Vinicius Lara. All rights reserved.
//

import UIKit
import SwiftUI

struct Card : Decodable, Hashable, Identifiable {
    var id = UUID()
    var image : String
    var video : String
    var title : String
    var details : String
    var expand : Bool
}

struct dataOrdered: Identifiable {
    let id = UUID()
    var startLetter : String
    var cards : [Card] = []
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        let dataUnsorted = [
            Card(image: "imagem_cromossomo", video: "video_cromossomo", title: "Cromossomo", details: "Colécula de DNA em seu máximo estágio de compactação.", expand: false),
            Card(image: "imagem_locus", video: "video_locus", title: "Locus", details: "Posição que um gene ocupa em um cromossomo.", expand: false),
            Card(image: "imagem_genotipo", video: "video_genotipo", title: "Genótipo", details: "Constituição genética de um organismo, ou seja, o conjunto de genes que um indivíduo possui.", expand: false),
            Card(image: "imagem_fenotipo", video: "video_fenotipo", title: "Fenótipo", details: "Expressão do genótipo mais a interação do ambiente.", expand: false),
        ]
        
        let dataSorted = dataUnsorted.sorted { $0.title < $1.title }

        var dataCategorized: [dataOrdered] = []

        for data in dataSorted {
            if let i = dataCategorized.firstIndex(where: { $0.startLetter == data.title.prefix(1) }) {
                dataCategorized[i].cards.append(data)
            } else {
                dataCategorized.append(dataOrdered(startLetter: String(data.title.prefix(1)), cards: [data]))
            }
        }

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(cards: dataCategorized)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

