//
//  ViewController.swift
//  buyTickets
//

import UIKit
import PMAlertController
import CryptoKit

protocol LoginManagerDelegate: AnyObject {
    func showErrorMessage(message: String);
    func updateController();
}

class LoginViewController: UIViewController {

    @IBOutlet var loginField: CustomUIField!
    @IBOutlet var passwordField: CustomUIField!
    @IBOutlet var signInbutton: UIButton!
    @IBOutlet var registerButton: UIButton!
    var loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginField.setProperties(TextFieldProperties())
        passwordField.setProperties(TextFieldProperties())
        
        loginField.delegate = self
        passwordField.delegate = self
        loginManager.delegate = self
        
        title = "Register or Sign In"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        passwordField.text = ""
        loginField.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        view.endEditing(true)
        self.performSegue(withIdentifier: K.Segues.loginToRegister, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.loginToBooking {
            if let destinationVC = segue.destination as? BookingTicketsViewController {
                destinationVC.bookingManager.passengerID = loginManager.passengerID
                destinationVC.bookingManager.login = loginManager.login
                destinationVC.bookingManager.hashP = loginManager.hashP
            }
        }
    }

    @IBAction func signInTapped(_ sender: Any) {
        let login = loginField.text ?? ""
        let password = passwordField.text ?? ""
        view.endEditing(true)
        loginManager.checkCredentials(login: login, password: password)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textField = textField as? CustomUIField {
            textField.setProperties(TextFieldProperties(borderWidth: 1, borderColor: UIColor(named: "Borders")!.cgColor))
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textField = textField as? CustomUIField {
            textField.setProperties(TextFieldProperties(borderWidth: 0.7, borderColor: CGColor(red: 169, green: 169, blue: 169, alpha: 0.4)))
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

//MARK: - LoginManagerDelegate
extension LoginViewController: LoginManagerDelegate {
    func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            self.loginField.text = ""
            self.passwordField.text = ""
            let ac = PMAlertController(title: "Fail", description: message, image: nil, style: .alert)
            ac.addAction(PMAlertAction(title: "OK", style: .default, action: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func updateController() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.Segues.loginToBooking, sender: self)
        }
    }
}
