//
//  ProfileVC.swift
//  Media Finder
//
//  Created by ReMoSTos on 28/04/2023.
//

import UIKit

class ProfileVC: UIViewController {
    //MARK: properties
    var users: [User] = []
    // MARK: - outlets.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    // MARK: - lifeCycle Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
       // let def = UserDefaults.standard
       // def.setValue(true, forKey: UserDefaultsKeys.isLoggedIn)
        convertToUser ()
}
    
    // MARK: - Actions
    @IBAction func logOutBtnTapped(_ sender: UIButton) {
        let def = UserDefaults.standard
        def.set(false, forKey: UserDefaultsKeys.isLoggedIn)
       if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
           appDelegate.goToSignInVC()
        }
    }
}

// MARK: - extension
extension ProfileVC {
    private func convertToUser (){
        if let encodedData = UserDefaults.standard.object(forKey: UserDefaultsKeys.user) as? Data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(User.self, from: encodedData){
                self.nameLabel.text = decodedData.name
                self.phoneLabel.text = decodedData.phone
                self.emailLabel.text = decodedData.email
                self.addressLabel.text = decodedData.address
                self.genderLabel.text = decodedData.gender.rawValue
                self.userImageView.image = decodedData.image.getImage()
            }
        }
    }
    
    // list user data
    private func handelListData() {
        let def = UserDefaults.standard
        let email = def.string(forKey: UserDefaultsKeys.email)
        let userData = SqlLiteManager.shared.list() // <- array
        for user in userData {
            if email == user.email {
                nameLabel.text = user.name
                phoneLabel.text = user.phone
                emailLabel.text = user.email
                genderLabel.text = user.gender.rawValue
                addressLabel.text = user.address
                userImageView.image = user.image.getImage()
            }
            
        }
    }
}
