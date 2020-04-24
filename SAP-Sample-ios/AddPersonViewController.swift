//
//  AddPersonViewController.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 02/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import Foundation

class AddPersonViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHieghtConstraint: NSLayoutConstraint!
    var activeTextFied: UITextField?
    var alertController: UIAlertController = UIAlertController()
    
    fileprivate var networkManager: NetworkCommunicationManager = NetworkCommunicationManager()
    var personHeader: PERSON_HEADER = PERSON_HEADER()
    var emailIds: [E_MAIL] = []
    var delegate: GetPersonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        networkManager.delegate = self
        self.setupUI()
        registerForKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupUI() {
        self.navigationItem.title = NSLocalizedString("Add/Create Person", comment: "")
        Utility.removeExtraLinesFromTableView(self.tableView)
        self.tableView.isHidden = true
        self.tableView.layer.cornerRadius = 5
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.borderColor = UIColor.white.cgColor
        self.firstNameTextField.becomeFirstResponder()
    }
    
    // MARK:- Button Action
    
    @IBAction func createButtonClicked(_ sender: Any) {
        activeTextFied?.resignFirstResponder()
        
        
        if let fname = personHeader.FIRST_NAME,(fname.count == 0 || fname == "nil" || fname == "") {
            Utility.displayStringInAlertView("", desc: "Enter First name.", viewController: self)
            return
        }
        
        if let lname =  personHeader.LAST_NAME,(lname.count == 0 || lname == "nil" || lname == "") {
            Utility.displayStringInAlertView("", desc: "Last name is mandatory.", viewController: self)
            return
        }
        
        if let gender =  personHeader.SEX,(gender.count == 0 || gender == "nil" || gender == "") {
            Utility.displayStringInAlertView("", desc: "Please specify gender.", viewController: self)
            return
        }
        
        personHeader.PERSNUMBER = 0
        personHeader.MANDT = String(800)
        Utility.insertOrReplaceHeadersInDatabase([personHeader], vc: self)
        
        if self.emailIds.count > 0 {
            let lid = personHeader.getLid()
            for i in 0  ..< emailIds.count {
                let mail = emailIds[i]
                mail.MANDT = String(800)
                mail.SEQNO_E_MAIL = i as NSNumber
                mail.PERSNUMBER = personHeader.PERSNUMBER
                mail.setFid(lid)
            }
            Utility.insertOrReplaceHeadersInDatabase(self.emailIds, vc: self)
        }
        
        self.networkManager.sendDataToServer(MESSAGE_REQUEST_TYPE(), PAFunctionName: AppConstants.PA_CREATE_PERSON, header: personHeader)
        self.showBusyIndicator()
    }
    
    @IBAction func addEmailButtonClicked(_ sender: Any) {
        presentAlert()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Email", message: "Please input your email:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                
                if let string = field.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
                    if string.count > 0 &&  string != " " && string != "" {
                        let email: E_MAIL = E_MAIL()
                        email.E_ADDR = string
                        self.emailIds.append(email)
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showBusyIndicator() {
        alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(style: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
    }
    
    func hideBusyIndicator() {
        alertController.dismiss(animated: true, completion: nil);
    }
    
    
}

// MARK:- TableView DataSource and Delegate methods
extension AddPersonViewController: UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emailIds.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let tableViewActualHeight = tableView.contentSize.height
        tableViewHieghtConstraint.constant = tableViewActualHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:"cell")
        let email = emailIds[indexPath.row]
        
        if let emailId = email.E_ADDR {
            cell.textLabel?.text = emailId
        }
        
        cell.accessoryType = UITableViewCell.AccessoryType.none
        return cell
    }
    
    
}

// MARK:- TextField Delegate Methods
extension AddPersonViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextFied = textField
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextFied = nil
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var txtAfterUpdate : String = textField.text!
        txtAfterUpdate = (txtAfterUpdate as NSString).replacingCharacters(in: range, with: string)
        txtAfterUpdate = txtAfterUpdate.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if(txtAfterUpdate.count > 0 && txtAfterUpdate != " " || txtAfterUpdate != "") {
            if textField == firstNameTextField {
                personHeader.FIRST_NAME = txtAfterUpdate
            }
            else if textField == lastNameTextField {
                personHeader.LAST_NAME = txtAfterUpdate
            }
            else if textField == genderTextField {
                personHeader.SEX = txtAfterUpdate
            }
            else if textField == professionTextField {
                personHeader.PROFESSION = txtAfterUpdate
            }
            else if textField == dobTextField {
                personHeader.BIRTHDAY = txtAfterUpdate
            }
            else if textField == weightTextField {
                if let number = Int(txtAfterUpdate) {
                    personHeader.WEIGHT = NSNumber(value:number)
                }
            }
            else {
                if let number = Int(txtAfterUpdate) {
                    personHeader.HEIGHT = NSNumber(value:number)
                }
            }
        }
        
        return true
    }
    
    
    
}

// MARK:- NetworkConnectionDelegate methods
extension AddPersonViewController: NetworkConnectionDelegate {
    
    func didGetResponseForPA(_ paFunctionName: String, infoMessage: String, responseHaeders: Dictionary<String, AnyObject>) {
        hideBusyIndicator()
        Utility.displayStringInAlertView("", desc: infoMessage, viewController: self)
        getPersonNumber(infoMessage: infoMessage)
        delegate?.didGetPerson()
        self.navigationController?.popViewController(animated: true)
    }
    
    func didEncounterErrorForPA(_ paFunctionName: String, errorMessage: NSError) {
        hideBusyIndicator()
        Utility.displayAlertWithOKButton("", message: errorMessage.localizedDescription, viewController: self)
    }
    
    func didNotFindSystemCredentials(_ paFunctionName: String) {
        alertController.dismiss(animated: true) {
            UnviredFrameworkUtils.checkSystemCredentials(present: { (viewController) in
                let navigationController = UINavigationController(rootViewController: viewController!)
                self.present(navigationController, animated: true, completion: nil)
            }) {
                self.navigationController?.topViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func getPersonNumber(infoMessage : String) {
        let tokens = infoMessage.components(separatedBy: "person number=")
        if let number = Int(tokens[1].components(separatedBy: ")")[0]) {
            personHeader.PERSNUMBER = number as NSNumber
            print("Person Number : \(String(describing: personHeader.PERSNUMBER))")
            
            for mail in emailIds {
                mail.PERSNUMBER = personHeader.PERSNUMBER
            }
            
            // Save
            Utility.insertOrReplaceHeadersInDatabase([personHeader], vc: self)
            Utility.insertOrReplaceHeadersInDatabase(emailIds, vc: self)
        }
    }
}


// MARK:- Keyboard Management
extension AddPersonViewController {
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(AddPersonViewController.keyboardWillBeShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(AddPersonViewController.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeShown(_ notification: Notification) {
        if (self.view.window == nil) {
            return
        }
        
        guard let _ = activeTextFied else {
            return
        }
        
        var userInfo: NSDictionary!
        userInfo = (notification as NSNotification).userInfo as NSDictionary?
        
        let keyboardF:NSValue = (userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)!
        let keyboardFrame = keyboardF.cgRectValue
        let kbHeight = keyboardFrame.height
        
        let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbHeight, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame;
        aRect.size.height -= kbHeight;
        if (!aRect.contains(activeTextFied!.frame.origin) ) {
            scrollView.scrollRectToVisible((activeTextFied?.frame)!, animated: true)
        }
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        if (self.view.window == nil) {
            return
        }
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
}
