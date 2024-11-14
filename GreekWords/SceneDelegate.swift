import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        if UserDefaults.standard.bool(forKey: "didShowInfoScreen") {
            let chooseTypeViewController = ChooseTypeViewController()
            let navigationController = UINavigationController(rootViewController: chooseTypeViewController)
            window.rootViewController = navigationController
        } else {
            let infoPageViewController = InfoPageViewController()
            window.rootViewController = infoPageViewController
        }

        self.window = window
        window.makeKeyAndVisible()
    }
}
