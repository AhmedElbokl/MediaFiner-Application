//
//  SignUpVC.swift
//  Media Finder
//
//  Created by ReMoSTos on 22/04/2023.
//

import SDWebImage

class SignUpVC: UIViewController {
    
    // MARK: - outlets.
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    // MARK: - properties.
    var gender: Gender = .male
    var imagePicker = UIImagePickerController()
    var isUserImageChanged: Bool = false

    // MARK: - Life cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "SING UP SCREEN"
        //self.navigationController?.isNavigationBarHidden = true
        imagePicker.delegate = self
        getImageFromWeb()
    }
    
    // MARK: - action.
    @IBAction func genderSwitchChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            gender = .female
        } else {
            gender = .male
        }
    }
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        if isDataEntered() {
           if isDataValid() {
               //new
               SqlLiteManager.shared.createTable()
               handelInsertData()
            }
        }
        else {
            print("Invalid Sign Up")
        }
    }
    
    @IBAction func addressBtnTapped(_ sender: UIButton) {
        //delegation 4.
        goToMapVC()
    }
    
    @IBAction func userImageBtnTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func goToSignInVC(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        navigationController?.pushViewController(signInVC, animated: true)
    }
}

//MARK: - extension SignUpVC
extension SignUpVC {
    //MARK: - func for test "SDWebImage"
    private func getImageFromWeb() {
        userImageView.sd_setImage(with: URL(string: "https://cdn-icons-png.flaticon.com/512/21/21104.png"), placeholderImage: UIImage(named: "https://png.pngtree.com/png-clipart/20210915/ourmid/pngtree-user-avatar-placeholder-black-png-image_3918427.jpg"))

    }
    //MARK: - Methods.
    private func goToSignInVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        let user: User = User(name: nameTextField.text ?? "",
                              phone: phoneTextField.text ?? "",
                              email: emailTextField.text ?? "",
                              password: passwordTextField.text ?? "",
                              address: addressTextField.text ?? "",
                              gender: gender,
                              image: CodableImage.init(image: userImageView.image!))
        convertToData(user)
       // signInVC.modalPresentationStyle = .fullScreen
       // self.present(signInVC, animated: true)
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    private func goToMapVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let mapVC: MapVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mapVC) as! MapVC
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    //delegation 4.
    private func delgator() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)
        let mapVC: MapVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mapVC) as! MapVC
        mapVC.delegate = self
    }
    private func isDataEntered() -> Bool {
        
        guard isUserImageChanged != false else {
           // print("user image is not changed!")
            showAlert(validationCases.image)
            return false
        }
        guard nameTextField.text != "" else {
            print(validationCases.name)
            return false
        }
        guard phoneTextField.text != "" else {
            print(validationCases.phone)
            return false
        }
        guard emailTextField.text != "" else {
            print(validationCases.email)
            return false
        }
        guard passwordTextField.text != "" else {
            print(validationCases.password)
            return false
        }
     /*   guard addressTextField.text != "" else {
            print(validationCases.address)
            return false
        }*/
        return true
    }
    
    func isDataValid() -> Bool {
        guard Validator.shared().isValidEmail(emailTextField.text ?? "") else {
            print("not valid email")
            return false
        }
        guard Validator.shared().isValidPassword(passwordTextField.text ?? "") else {
            print("not valid password")
            return false
        }
        guard Validator.shared().isValidPhone(phoneTextField.text ?? "") else {
            print("not valid phone number")
            return false
        }
        return true
    }
    private func convertToData(_ user: User) {
        let encoder: JSONEncoder = JSONEncoder()
        if let encodedData = try? encoder.encode(user) {
            let def = UserDefaults.standard
            def.setValue(encodedData, forKey: UserDefaultsKeys.user)
        }
    }
    
    // handel insertion in sqlite
    private func handelInsertData() {
        do {
            let user = User(name: nameTextField.text ?? "", phone: phoneTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "", address: addressTextField.text ?? "", gender: gender, image: CodableImage(image: userImageView.image!))
            let userData = try JSONEncoder().encode(user)
            SqlLiteManager.shared.insert(user: user, userData: userData)
        } catch {
            print(error.localizedDescription)
        }
        goToSignInVC()
    }
    
}

//delegation 5.
extension SignUpVC: MessageSending {
    func sendMSG(_ message: String) {
        addressTextField.text = message
    }
    
    
}
//MARK: - imagePicker
extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  {
            userImageView.image = pickedImage
            isUserImageChanged = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}
