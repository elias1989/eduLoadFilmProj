import UIKit

//lifecycle management.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // Reference to the app's window.
    var window: UIWindow?
        
    // Called when the scene is about to connect to the window.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Creating the main window for the app
        let window = UIWindow(windowScene: windowScene)
        
        //creating root controller by code.
        let serviceLoaderFilms = LoadListFilmService()
        window.rootViewController = FilmViewController(movieService: serviceLoaderFilms)
        
        //make window visible
        window.makeKeyAndVisible()
        
        //Assigning the created window to Scendelegate main window.
        self.window = window
    }
    
}

