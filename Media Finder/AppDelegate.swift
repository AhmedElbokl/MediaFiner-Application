//
//  AppDelegate.swift
//  Media Finder
//
//  Created by ReMoSTos on 22/04/2023.
//

 import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: - properties.
    var window: UIWindow?
    let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)

    // MARK: - Application Methods.
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         IQKeyboardManager.shared.enable = true
         handeledScreans()
        // SqlLiteManager.shared.createTable()
         SqlLiteManager.shared.setupConnection()
        return true
    }
    //MARK: - methods
   public func goToSignInVC() {
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
       let navigationController = UINavigationController.init(rootViewController: signInVC)
        self.window?.rootViewController = navigationController
    }
}

extension AppDelegate {
    private func handeledScreans() {
        if let userLoggedIn = UserDefaults.standard.object(forKey: UserDefaultsKeys.isLoggedIn) as? Bool {
            if userLoggedIn {
                goToMediaVC()
            } else {
                goToSignInVC()
            }
        }
    }
   /* private func goToProfileVC() {
        let profileVC: ProfileVC = mainStoryboard.instantiateViewController(withIdentifier: Views.profileVC) as! ProfileVC
        let navigationController = UINavigationController.init(rootViewController: profileVC)
        self.window?.rootViewController = navigationController
    }*/
    private func goToMediaVC() {
        let mediaVC: MediaVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mediaVC) as! MediaVC
        let navigationController = UINavigationController.init(rootViewController: mediaVC)
        self.window?.rootViewController = navigationController
    }
    
}
