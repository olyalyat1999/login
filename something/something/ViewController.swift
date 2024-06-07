//
//  ViewController.swift
//  something
//
//  Created by Olya on 03.06.2024.
//

import UIKit

class ViewController: UIViewController {

	// Вынесем константы что бы было удобнее менять в одном месте и не искать их по классу
	private struct Constants {
		static let mockEmail: String = "abc@gmail.com"
		static let mockPassword: String = "123456"
		static let activeColor: String = "saturn"
	}

	//MARK: - UI Outlets

	/// поменяем названия на текстфилд, что бы соответствовало элементам
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var envelopeImageView: UIImageView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var emailLineView: UIView!
    @IBOutlet weak var passwordLineView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var createAccountLabel: UILabel!
    
    //MARK: - Properties

	private let activeColor = UIColor(named: Constants.activeColor) ?? UIColor.gray
    private var email: String = "" {
        didSet {
			updateLoginButtonState() /// Уменьшим дублирование кода, вынесем его в отдельную функцию
        }
    }
    private var password: String = "" {
        didSet {
			updateLoginButtonState() /// Уменьшим дублирование кода, вынесем его в отдельную функцию
        }
    }
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoginButton()
        emailTextField?.delegate = self
        passwordTextField?.delegate = self
        emailTextField?.becomeFirstResponder()
    }
    
    //MARK: - IBAction

    @IBAction func login(_ sender: Any) {
		view.endEditing(true)
		guard !email.isEmpty else {
			makeErrorField(textField: emailTextField)
			return
		}
		guard !password.isEmpty else {
			makeErrorField(textField: passwordTextField)
			return
		}
		if email == Constants.mockEmail, password == Constants.mockPassword {
			performSegue(withIdentifier: "goToHomePage", sender: sender)
		} else {
			showAlert(title: "Error".localized, message: "Wrong password or e-mail".localized)
		}
    }

	@IBAction func signup(_ sender: Any) {
		print("signUp")
	}

	//MARK: - Private methods

	/// Разведем логику по отдельным функциям
	private func showAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK".localized, style: .default)
		alert.addAction(action)
		present(alert, animated: true)
	}

	/// Дублирующийся код - в отдельную функцию
	private func updateLoginButtonState() {
		let isEnabled = !(email.isEmpty || password.isEmpty)
		loginButton.isUserInteractionEnabled = isEnabled
		loginButton.backgroundColor = isEnabled ? activeColor : .systemGray5
	}
	
    private func setUpLoginButton() {
		loginButton.layer.shadowColor = activeColor.cgColor
		loginButton.layer.shadowOpacity = 0.4
		loginButton.layer.shadowRadius = 4
		loginButton.layer.shadowOffset = CGSize(width: 0, height: 8)
		updateLoginButtonState()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
        !text.isEmpty else { return }
        switch textField {
        case emailTextField:
           let isValidEmail = isValidEmail(text)
            
            if isValidEmail {
                email = text
                envelopeImageView.tintColor = .systemGray5
                emailLineView .backgroundColor = .systemGray5
            } else {
                email = ""
                makeErrorField(textField: textField)
            }
            
        case passwordTextField:
            let isValidPassword = isValidPassword(text)
            emailTextField.isUserInteractionEnabled = isValidPassword
            emailTextField.backgroundColor = isValidPassword ? activeColor : . systemGray5

            if isValidPassword {
                password = text
                lockImageView.tintColor = .systemGray5
                passwordLineView.backgroundColor = .systemGray5
            } else {
                email = ""
                makeErrorField(textField: textField)
            }
        default:
            print("unknownTextField")
        }
    }
    
	/// поменял нейминг, тк возвращаем Bool
	private func isValidEmail(_ email: String) -> Bool {
		return email.contains("@") && email.contains(".")
	}
	/// поменял нейминг, тк возвращаем Bool
	private func isValidPassword(_ password: String) -> Bool {
		return password.count >= 4
	}
    
    private func makeErrorField(textField: UITextField ) {
        switch textField {
        case emailTextField:
            envelopeImageView.tintColor = activeColor
            emailLineView .backgroundColor = activeColor
        case passwordTextField:
            lockImageView.tintColor = activeColor
            passwordLineView.backgroundColor = activeColor
        default:
            print("unknownTextField")
        }
    }
}
