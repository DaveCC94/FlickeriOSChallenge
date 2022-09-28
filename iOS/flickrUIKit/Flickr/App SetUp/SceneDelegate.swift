//
//  SceneDelegate.swift
//  Flickr
//
//  Created by David Castro Cisneros on 29/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import UIKit
import Networking
import PhotoFeedFeature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var apiClient: APIClient = makeAPIClientInfra()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let navController = UINavigationController(rootViewController: makeInitialController())
        navController.navigationBar.standardAppearance.backgroundColor = UIColor.blue
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }

    func makeInitialController() -> UIViewController {
        return PhotoFeedComposer.photoFeedComposedWith(feedLoader: makePhotoLoader(), imageLoader: RemoteImageLoader(client: apiClient))
    }
    
    func makeAPIClientInfra() -> URLSessionAPIClient {
        return URLSessionAPIClient(session: URLSession(configuration: .default))
    }
    
    func makePhotoLoader() -> PhotoFeedLoader {
        let photoLoader: RemotePhotoFeedLoader = .init(queryFactory: QueryToFlickrURLAdapter().adapt(query:page:), client: apiClient)

        return photoLoader
    }
}
