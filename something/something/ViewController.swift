//
//  ViewController.swift
//  something
//
//  Created by Olya on 03.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailButton: UITextField!
    @IBOutlet weak var passwordButton: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var envelopeVIew: UIImageView!
    @IBOutlet weak var lockView: UIImageView!
    @IBOutlet weak var emailLine: UIView!
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var createAccount: UILabel!
    
    //MARK: - Properties
    private let activeColor = UIColor(named: "saturn") ?? UIColor.gray
    private var email: String = "" {
        didSet {
            loginButton.isUserInteractionEnabled = !(email.isEmpty || password.isEmpty)
            loginButton.backgroundColor = !(email.isEmpty || password.isEmpty) ? activeColor : . systemGray5
        }
    }
    private var password: String = "" {
        didSet {
            loginButton.isUserInteractionEnabled = !(email.isEmpty || password.isEmpty)
            loginButton.backgroundColor = !(email.isEmpty || password.isEmpty) ? activeColor : . systemGray5
        }
    }
    
    private let mockPassword = "123456"
    private let mockEmail = "abc@gmail.com"
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad")
        setUpLoginButton()
        emailButton?.delegate = self
        passwordButton?.delegate = self
        emailButton?.becomeFirstResponder()
    }
    
    //MARK: - IBAction
    @IBAction func login(_ sender: Any) {
        emailButton.resignFirstResponder()
        passwordButton.resignFirstResponder()
        
        if email.isEmpty {
            makeErrorField(textField: emailButton)
        }
        
        if password.isEmpty {
            makeErrorField(textField: passwordButton)
        }
        
        if email == mockEmail,
           password == mockPassword {
            performSegue(withIdentifier: "goToHomePage", sender: sender)
        } else {
            let alert = UIAlertController(title: "Error".localized,
                message: "Wrong password or e-mail".localized,
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK".localized,style: .default)
            alert.addAction(action)
            
            present(alert, animated: true)
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        print("signUp")
    }
    
   //MARK: - Private methods
    private func setUpLoginButton() {
        loginButton?.layer.shadowColor = activeColor.cgColor
        loginButton?.layer.shadowOpacity = 0.4
        loginButton?.layer.shadowRadius = 4
        loginButton?.layer.shadowOffset = CGSize(width: 0, height: 8)
        
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = .systemGray5
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        !text.isEmpty else { return }
        switch textField {
        case emailButton:
           let isValidEmail = check(email: text)
            
            if isValidEmail {
                email = text
                envelopeVIew.tintColor = .systemGray5
                emailLine .backgroundColor = .systemGray5
            } else {
                email = ""
                makeErrorField(textField: textField)
            }
            
        case passwordButton:
            let isValidPassword = check(password: text)
            emailButton.isUserInteractionEnabled = isValidPassword
            emailButton.backgroundColor = isValidPassword ? activeColor : . systemGray5

            if isValidPassword {
                password = text
                lockView.tintColor = .systemGray5
                passwordLine.backgroundColor = .systemGray5
            } else {
                email = ""
                makeErrorField(textField: textField)
            }
        default:
            print("unknownTextField")
        }
    }
    
    private func check(email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
    
    private func check(password: String) -> Bool {
        return password.count >= 4
    }
    
    private func makeErrorField(textField: UITextField ) {
        switch textField {
        case emailButton:
            envelopeVIew.tintColor = activeColor
            emailLine .backgroundColor = activeColor
        case passwordButton:
            lockView.tintColor = activeColor
            passwordLine.backgroundColor = activeColor
        default:
            print("unknownTextField")
        }
    }
}
