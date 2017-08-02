//
//  GetPersonViewController.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 02/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import Foundation

class GetPersonViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var personNoTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personNumberLabel: UILabel!
    
    fileprivate var networkManger: NetworkCommunicationManager = NetworkCommunicationManager()
    var personHeader : PERSON_HEADER = PERSON_HEADER()
    var downloadedPersonHeader: PERSON_HEADER = PERSON_HEADER()
    var didDownloadPersonHeader = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupUI()
        self.personNoTextField.keyboardType = .numberPad
        networkManger.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.navigationItem.title = NSLocalizedString("Search Person", comment: "")
        self.didDownloadPersonHeader = false
        
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.isHidden = true
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GetPersonViewController.didTapOnView))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTapOnView() {
        /** Dismiss the Keyboard **/
        self.view.endEditing(true)
    }
    
    // MARK:- Button Action
    @IBAction func searchPerson(_ sender: Any) {
        
        let number = String(describing: personHeader.PERSNUMBER)
        
        if (number.characters.count == 0 || number == "nil") {
            Utility.displayAlertWithOKButton("", message: "Plesae provide Person Number", viewController: self)
            return
        }
        
        networkManger.sendDataToServer(MESSAGE_REQUEST_TYPE.PULL, PAFunctionName: AppConstants.PA_GET_PERSON, header: personHeader)
    }
}

// MARK:- TextField Delegate Methods
extension GetPersonViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text != " " && string != "" {
            var someText = textField.text!
            someText = (someText as NSString).replacingCharacters(in: range, with: string)
            someText = someText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if !someText.isEmpty  {
                if someText != "" {
                    if let number = Int(someText) {
                        personHeader.PERSNUMBER = NSNumber(value:number)
                    }
                }
            }
        }
        return true
    }
    
    
}

// MARK:- NetworkConnectionDelegate methods
extension GetPersonViewController: NetworkConnectionDelegate {
    
    func didGetResponseForPA(_ paFunctionName: String, infoMessage: String, responseHaeders: Dictionary<NSObject, AnyObject>) {
        Utility.displayStringInAlertView("", desc: "Person Downloaded.")
        self.didDownloadPersonHeader = true
        self.downloadedPersonHeader = self.getPersonHeader(responseHaeders)[0]
        self.contentView.isHidden = false
        
        var personName = ""
        if let fName = self.downloadedPersonHeader.FIRST_NAME {
            personName = fName
            if let lName = self.downloadedPersonHeader.LAST_NAME {
                personName += lName
            }
        }
        
        self.nameLabel.text = personName
        
        if let number = self.downloadedPersonHeader.PERSNUMBER {
            self.personNumberLabel.text = String(describing: number)
        }
    }
    
    func didEncounterErrorForPA(_ paFunctionName: String, errorMessage: NSError) {
        self.contentView.isHidden = true
        Utility.displayAlertWithOKButton("", message: errorMessage.localizedDescription, viewController: self)
    }
    
    func getPersonHeader(_ dataBEs: Dictionary<NSObject, AnyObject>) -> [PERSON_HEADER] {
        var personHeader: [PERSON_HEADER] = []
        var headers:Dictionary<NSObject, AnyObject>?
        
        for (key, values) in dataBEs {
            if key as! String == "PERSON" {
                headers = values as? Dictionary<NSObject, AnyObject>
            }
        }
        
        if let headers = headers {
            for (header, _) in headers {
                personHeader.append(header as! PERSON_HEADER)
            }
        }
        return personHeader
    }
}
