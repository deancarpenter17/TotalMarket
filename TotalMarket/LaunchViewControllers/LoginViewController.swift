//
//  LoginViewController.swift
//  TotalMarket
//
//  Created by Dean Carpenter on 1/5/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    @IBAction func loginButton(_ sender: RoundedButton) {
        activityIndicator.startAnimating()
        if let username = emailTextField.text,
            let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    self.stopActivityIndicator()
                    return
                }
                print("username: " + username)
                
                self.stopActivityIndicator()
                let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
                appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
            }
        }
            
        else {
            self.stopActivityIndicator()
            AlertController.showAlert(self, title: "Missing info", message: "You must fill out all fields!")
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func setupViews() {
        // Make textfield rounded
        emailTextField.layer.cornerRadius = 15.0
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.borderColor = UIColor.themeGreen.cgColor
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email:", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderGray])
        // give the textfield hint some padding
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // initialize Password textfield
        passwordTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.themeGreen.cgColor
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password:", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderGray])
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // initialize Login Button
        loginButton.backgroundColor = UIColor.themeGreen
        loginButton.tintColor = UIColor.white
    }
    
    func stopActivityIndicator() {
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
