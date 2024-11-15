import UIKit

var isPad: Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

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

        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0),
                                                                          for: .default)

        self.window = window
        window.makeKeyAndVisible()
    }
}
