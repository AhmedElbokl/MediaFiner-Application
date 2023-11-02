//
//  SignInVC.swift
//  Media Finder
//
//  Created by ReMoSTos on 22/04/2023.
//

import UIKit

class SignInVC: UIViewController {
    
    // MARK: - Outlets.
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - properties.
    var name: String = ""
    var phone: String = ""
    var email: String = ""
    var password: String = ""
    var address: String = ""
    var gender: Gender = .male
    
    // MARK: - lifeCycle Methode.
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "SIGN IN SCREEN"
        convertToUser()
}
    
    // MARK: - Actions.
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        //self.dismiss(animated: true)
        if isDataEntered(){
         if isDataCorrect() {
             goToMediaVC()
            } else {
                print("worng")
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
//                let signUpVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: Views.signUpVC)
//                let signInVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC)
//                let navigationController = UINavigationController(rootViewController: signInVC)
//                self.navigationController?.pushViewController(signUpVC, animated: true)
            }
        }
    }
    
    @IBAction func dontHaveAnAccountBtnClicked(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signUpVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: Views.signUpVC)
        self.navigationController?.pushViewController(signUpVC, animated: true)
//        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - extension SignInVC
extension SignInVC {
    private func isDataEntered() -> Bool {
        guard emailTextField.text != "" else {
            print(validationCases.email)
            return false
        }
        guard passwordTextField.text != "" else {
            print(validationCases.password)
            return false
        }
        return true
    }
    private func goToProfileVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let profilVC: ProfileVC = mainStoryboard.instantiateViewController(withIdentifier: Views.profileVC) as! ProfileVC
        self.navigationController?.pushViewController(profilVC, animated: true)
    }
    private func goToMediaVC() {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let mediaVC: MediaVC = mainStoryBoard.instantiateViewController(withIdentifier: Views.mediaVC) as! MediaVC
        self.navigationController?.pushViewController(mediaVC, animated: true)
    }
    private func convertToUser() {
        if let encodedData = UserDefaults.standard.object(forKey: UserDefaultsKeys.user) as? Data {
            let decoder: JSONDecoder = JSONDecoder()
            if let decodedData = try? decoder.decode(User.self, from: encodedData) {
                self.email = decodedData.email
                self.password = decodedData.password
            }
        }
    }
    private func isDataCorrect() -> Bool {
        if emailTextField.text == email && passwordTextField.text == password {
            return true
        } else {
            return false
        }
    }
}
