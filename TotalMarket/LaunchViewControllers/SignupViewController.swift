//
//  SignupViewController.swift
//  TotalMarket
//
//  Created by Dean Carpenter on 1/5/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }


    @IBAction func signupButton(_ sender: RoundedButton) {
        activityIndicator.startAnimating()
        if let username = usernameTextField.text, let password = passwordTextField.text,
            let email = emailTextField.text {
            
            self.checkUserNameAlreadyExist(newUserName: username) { isExist in
                if isExist {
                    print("Username exists!")
                    AlertController.showAlert(self, title: "Error", message: "Username already exists! Try again.")
                    self.stopActivityIndicator()
                    
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        guard error == nil else {
                            AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                            print("Could not create user: " + error!.localizedDescription)
                            self.stopActivityIndicator()
                            return
                        }
                        
                        guard let user = user else {
                            self.stopActivityIndicator()
                            return
                        }
                        
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = username
                        changeRequest.commitChanges(completion: {( error ) in
                            guard error == nil else {
                                AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                                print("error in commit changes!")
                                self.stopActivityIndicator()
                                return
                            }
                            
                            // Just saved the user in the 'Users' section of Firebase, but also need
                            // to save the user in Firebase database section as well
                            let myUser = User(username: username, email: email)
                            DataStore.shared.addUser(user: myUser)
                            
                            // go to home screen
                            self.stopActivityIndicator()
                            let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
                            appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
                        })
                    })
                }
            }
            
        }
            
        else {
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
    
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(Bool) -> Void) {
        
        let ref = Database.database().reference()
        ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: newUserName)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                
                if snapshot.exists() {
                    completion(true)
                }
                else {
                    completion(false)
                }
            })
    }
    
    func setupViews() {
        usernameTextField.layer.cornerRadius = 15.0
        usernameTextField.layer.borderWidth = 1.5
        usernameTextField.layer.borderColor = UIColor.themeGreen.cgColor
        // make textfields fully transparant
        usernameTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username:", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderGray])
        // Add padding to the placeholder text, so it's not hugging the start of the textfield
        usernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // initialize Password textfield
        passwordTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.themeGreen.cgColor
        passwordTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password:", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderGray])
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // initialize email textfield
        emailTextField.layer.cornerRadius = 15.0
        emailTextField.layer.borderWidth = 1.5
        emailTextField.layer.borderColor = UIColor.themeGreen.cgColor
        emailTextField.backgroundColor = UIColor(white: 1, alpha: 0)
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email:", attributes: [NSAttributedStringKey.foregroundColor: UIColor.placeholderGray])
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // initialize Signup Button
        signupButton.backgroundColor = UIColor.themeGreen
        signupButton.tintColor = UIColor.white
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
