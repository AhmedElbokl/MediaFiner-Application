//
//  UIViewController+Alert.swift
//  Media Finder
//
//  Created by ReMoSTos on 22/05/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "DONE", style: .cancel))
        self.present(alert, animated: true)
    }
}
