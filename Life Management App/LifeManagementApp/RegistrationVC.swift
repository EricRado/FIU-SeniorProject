//
//  RegistrationVC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/17/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit
import Firebase
import Foundation


class RegistrationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    var usernameList = [String]()
    var emailList = [String]()
    var check:Bool = false
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let dbRef = Database.database().reference(fromURL: "https://life-management-v2.firebaseio.com/")
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username",
                                attributes:[NSForegroundColorAttributeName: UIColor.white])
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                attributes:[NSForegroundColorAttributeName: UIColor.white])
        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
                                attributes:[NSForegroundColorAttributeName: UIColor.white])
        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                attributes:[NSForegroundColorAttributeName: UIColor.white])
        self.dobTextField.attributedPlaceholder = NSAttributedString(string: "Dob",
                                attributes:[NSForegroundColorAttributeName: UIColor.white])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                attributes:[NSForegroundColorAttributeName: UIColor.white])
        self.reTypePasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password",attributes:[NSForegroundColorAttributeName: UIColor.white])
        
        self.registerButton.layer.cornerRadius = 15
        self.registerButton.layer.masksToBounds = true
        
        setTextFieldEditing()
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.dobTextField.delegate = self
        self.passwordTextField.delegate = self
        self.reTypePasswordTextField.delegate = self
        
        
        // Replace 'Selector("endEditing:")' with '#selector(UIView.endEditing(_:))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
    }
    
    override func viewDidLayoutSubviews() {
        let lineColor = UIColor(red: 0.12, green: 0.23, blue: 0.35, alpha: 0.85)
        
        self.usernameTextField.setBottomLine(borderColor: lineColor)
        self.emailTextField.setBottomLine(borderColor: lineColor)
        self.firstNameTextField.setBottomLine(borderColor: lineColor)
        self.lastNameTextField.setBottomLine(borderColor: lineColor)
        self.dobTextField.setBottomLine(borderColor: lineColor)
        self.passwordTextField.setBottomLine(borderColor: lineColor)
        self.reTypePasswordTextField.setBottomLine(borderColor: lineColor)
        
    }
    
    func textFieldDidChange(_ textField: UITextField){
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.setBottomLine(borderColor: UIColor(red:0.12, green:0.23, blue:0.35, alpha:0.8))
    }
    
    func setTextFieldEditing(){
        self.usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.dobTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.reTypePasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func errorInTextField(_ textField: UITextField){
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 12.0
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    func getAllUsers(){
        let userRef = dbRef.child("Users")
        userRef.observe(DataEventType.value, with: {(snapshot) in
            
            for user in snapshot.children.allObjects as! [DataSnapshot]{
                guard let userDict = user.value as? [String:Any] else {continue}
                self.usernameList.append((userDict["username"] as? String)!)
                self.emailList.append((userDict["email"] as? String)!)
               
            }
        })
    }

    func handleRegister() -> Bool{
        
        let childRef = dbRef.child("Users").childByAutoId()
        
        // check for empty fields
        let username = usernameTextField.text
        if username == ""{
            print("Please enter a username")
            errorInTextField(usernameTextField)
            createAlert(titleText: "Error", messageText: "Please enter a username")
            return false
        }
        
        let email = emailTextField.text
        if email == ""{
            print("Please enter an email")
            errorInTextField(emailTextField)
            createAlert(titleText: "Error", messageText: "Please enter an email")
            return false
        }
        
        let password = passwordTextField.text
        if password == ""{
            print("Please enter a password.")
            errorInTextField(passwordTextField)
            createAlert(titleText: "Error", messageText: "Please enter a password")
            return false
        }
        
        let reTypePassword = reTypePasswordTextField.text
        if reTypePassword == ""{
            print("Please confirm your password.")
            errorInTextField(reTypePasswordTextField)
            createAlert(titleText: "Error", messageText: "Please confirm your password")
            return false
        }
        
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let dob = dobTextField.text
        
        // check if username input is valid
        if !checkUsername(username: username!){
            return false
        }
        
        // check if email input is valid
        if !checkEmail(email: email!){
            print("Email is invalid")
            errorInTextField(emailTextField)
            createAlert(titleText: "Error", messageText: "Email entered is invalid")
            return false
        }
        
        // check if email already exists
        let emailExistsArray = emailList.filter({$0 == email!})
        if !emailExistsArray.isEmpty{
            errorInTextField(emailTextField)
            createAlert(titleText: "Error", messageText: "Email entered already exists")
        }
        
        print("confirm password check ...")

        // check if password input is valid
        if !checkPassword(password:password!, reTypePassword:reTypePassword!){
            
            return false
        }
    
        // check if first name input is valid
        if !checkName(name: firstName!, option: "first"){
            
            return false
        }
        print("last name check...")
        // check if last name input is valid
        if !checkName(name:lastName!, option:"last"){
            
            return false
        }
        print("before the key...")
        let uid = childRef.key
        print("the key" + uid)
        self.delegate.user = User(id: uid ,email: email!, username: username!,firstName: firstName!, lastName: lastName!,
                                  dob: dob!, password: password!, adminFlag: false, coachFlag: false, imgURL: "")
        
        childRef.setValue(self.delegate.user.toAnyObject(), withCompletionBlock: {(error, ref) in
            if error != nil{
                print(error!)
                return
            }
            

            print("Successfully saved a user into database.")
            self.delegate.userImgProfile = UIImage(named: "noPicture")!
        })
        return true
    }
    
    /***********************************************************
     
                    Textfield Validation Functions
     
     ***********************************************************/
    
    // username validation
    func checkUsername(username:String) -> Bool{
        var check = true
        var errorMsg = ""
        
        // check the length of username
        if username.count < 5{
            print("Username is too short")
            check = false
            errorMsg = "Username is too short"
            
        }else if username.count >= 15{
            print("Username is too long")
            check = false
            errorMsg = "Username is too long"
            
        }else if containsSpace(word: username){
            
            // check if username contains space
            
            print("Username CANNOT contain any spaces")
            check = false
            errorMsg = "Username CANNOT contain any spaces"
           
        }else if containsSymbol(word: username){
            
            // check if username contains any symbols
            
            print("Username CANNOT contain any symbols")
            check = false
            errorMsg = "Username CANNOT contain any symbols"
    
        }
        
        if !check{
            errorInTextField(usernameTextField)
            createAlert(titleText: "Error", messageText: errorMsg)
        }
        
        // check list of username already in use for availability
        for uname in self.usernameList{
            if uname == username{
                print("This username has already been taken")
                errorInTextField(usernameTextField)
                createAlert(titleText: "Error", messageText: "Username entered already exists")
                return false
            }
        }
        return check
    }
    
    // password validation
    func checkPassword(password:String, reTypePassword:String) -> Bool{
        var check = true
        var errorMsg = ""
        
        // check the length of password
        if password.count >= 16{
            print("Password is too long")
            check = false
            errorMsg = "Password is too long"
        }else if password.count < 5{
            print("Password is too short")
            check = false
            errorMsg = "Password is too short"
        }else if containsSpace(word: password){
            
            // check if password contains spaces
            
            print("Password CANNOT contain spaces")
            check = false
            errorMsg = "Password CANNOT contain any spaces"
        }else if containsSymbol(word: password){
            
            // check if password contains any symbols
            
            print("Password CANNOT contain any symbols")
            check = false
            errorMsg = "Password CANNOT contain any symbols"
        }else if isNumber(char:String(password[password.startIndex])){
            
            // check if first character of the password is a number
            
            print("Password cannot start with numbers")
            check = false
            errorMsg = "Password cannot start with a number"
        }else if !(isNumber(char: password) && containsLetter(word: password)){
            
            // check if password contains a combination of letters and numbers
            // create a characterset with letters and add numbers to it
            
            print("Password MUST contain letters and numbers")
            check = false
            errorMsg = "Password MUST contain letters and numbers"
        }else if password != reTypePassword{
            
            // check if password and confirmed password are the same
            
            print("Password MUST match the confirm password")
            check = false
            errorMsg = "Password MUST match the confirm password"
        }
        
        if !check{
            errorInTextField(passwordTextField)
            createAlert(titleText: "Error", messageText: errorMsg)
        }
        
        return check
    }
    
    // email validation
    func checkEmail(email: String) -> Bool{
        var check = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,3}"
        
        do{
            let regEx = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regEx.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0{
                check = false
            }
        } catch let error as NSError{
            print("Invalid regex: \(error.localizedDescription)")
            check = false
        }
        
        return check
    }
    
    // first and last name validation
    func checkName(name: String, option: String) -> Bool{
        var check = true
        var errorMsg = ""
        
        // check length of first or last name
        if name.count >= 15{
            if option == "first"{
                print("First name is too long")
                errorMsg = "First name is too long"
            }else{
                print("Last name is too long")
                errorMsg = "Last name is too long"
            }
            check = false
        }else if containsSpace(word: name){
            
            // check if first or last name contains spaces
            
            if option == "first"{
                print("First name CANNOT contain spaces")
                errorMsg = "First name CANNOT contain any spaces"
            }else{
                print("Last name CANNOT contain spaces")
                errorMsg = "Last name CANNOT contain any spaces"
            }
            check = false
        }else if isNumber(char: name) || containsSymbol(word: name){
            
            // check if first or last name contains any numbers or symbols
            
            if option == "first"{
                print("First name CANNOT contain numbers or symbols")
                errorMsg = "First name CANNOT contain numbers or symbols"
            }else{
                print("Last name CANNOT contain numbers or symbols")
                errorMsg = "Last name CANNOT contain numbers or symbols"
            }
            check = false
        }
        
        if !check{
            if option == "first"{
                errorInTextField(firstNameTextField)
            }else{
                errorInTextField(lastNameTextField)
            }
            createAlert(titleText: "Error", messageText: errorMsg)
        }
        
        return check
    }
    
    // checks if string contains a space
    func containsSpace(word: String) -> Bool {
        let whitespace = NSCharacterSet.whitespaces
        
        // range will be nil if no whitespace is found
        if word.rangeOfCharacter(from: whitespace) != nil{
            return true
        }
        return false
    }
    
    // checks if string contains a number
    func isNumber(char: String) -> Bool {
        let numbers = NSMutableCharacterSet()
        numbers.addCharacters(in: "0123456789")
        
        if char.rangeOfCharacter(from: numbers as CharacterSet) != nil{
            return true
        }
        return false
    }
    
    // checks if string contains a letter
    func containsLetter(word: String) -> Bool{
        do{
            let regex = try NSRegularExpression(pattern: "[a-zA-Z]")
            let nsString = word as NSString
            let results = regex.matches(in: word, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0 {
                return false
            }
        
        }catch let error{
            print("Invalid regex: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    
    // checks if string contains a symbol
    func containsSymbol(word: String) -> Bool {
        let lettersNumbers = NSCharacterSet.alphanumerics
        
        // range will be nil if no symbols is found
        if word.rangeOfCharacter(from: lettersNumbers.inverted) != nil{
            return true
        }
        return false
    }
    
    @IBAction func registerUser(_ sender: AnyObject) {
        self.check = handleRegister()
        
        print("This is check \(check)")
        
        if check{
            print("GOING TO ACTIVITY SELECTION SCREEN")
            performSegue(withIdentifier: "ActivitySelectionSegue", sender: self)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // check if handleRegister form was valid before performing segue to Activity Selection
        print("This is the identifier : \(identifier)")
        if identifier == "signInSegue"{
            return true
        }
        if check{
            return true
        }
        return false
    }
    
    
}
