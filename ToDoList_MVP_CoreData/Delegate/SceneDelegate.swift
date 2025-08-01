//
//  SceneDelegate.swift
//  ToDoList_MVP_CoreData
//
//  Created by EMILY on 2023/10/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        
        let repository: TodoRepository = .init()
        let rootViewController = MainListViewController(repository: repository)
        window.rootViewController = UINavigationController(rootViewController: rootViewController)
        
        window.makeKeyAndVisible()
        self.window = window
        
        Task {
            do {
                try await repository.createImportantListIfNeeded()
            } catch {
                print("[Repository] create Important list failed : \(error)")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}
