//
//  GetPersonViewController.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 02/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import Foundation

protocol GetPersonDelegate {
    func didGetPerson()
}

class GetPersonViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var personNoTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var personNumberLabel: UILabel!
    var alertController: UIAlertController = UIAlertController()
    
    fileprivate var networkManger: NetworkCommunicationManager = NetworkCommunicationManager()
    var personHeader : PERSON_HEADER = PERSON_HEADER()
    var downloadedPersonHeader: PERSON_HEADER = PERSON_HEADER()
    var emails : [E_MAIL] = []
    var didDownloadPersonHeader = false
    var delegate: GetPersonDelegate?
    
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
        setupNavigationBarBackButton()
        self.didDownloadPersonHeader = false
        
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.isHidden = true
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GetPersonViewController.didTapOnView))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func setupNavigationBarBackButton() {
        // Set the Back Button
        let backButton: UIButton = UIButton()
        backButton.setImage(UIImage(named: "backButton"), for: UIControl.State())
        backButton.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        backButton.setImage(backButton.imageView?.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State())
        backButton.addTarget(self, action: #selector(GetPersonViewController.backButtonAction(_:)), for: UIControl.Event.touchUpInside)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func didTapOnView() {
        /** Dismiss the Keyboard **/
        self.view.endEditing(true)
    }
    
    // MARK:- Button Action
    @objc func backButtonAction(_ sender:UIBarButtonItem) {
        
        if didDownloadPersonHeader {
            let alertController = UIAlertController(title: nil, message:
                NSLocalizedString("Do you want to save results?", comment: "") , preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) { (action) -> Void in
                Utility.insertOrReplaceHeadersInDatabase([self.downloadedPersonHeader], vc: self)
                Utility.insertOrReplaceHeadersInDatabase(self.emails, vc: self)
                self.delegate?.didGetPerson()
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel){ (action) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func searchPerson(_ sender: Any) {
        
        let number = String(describing: personHeader.PERSNUMBER)
        
        if (number.count == 0 || number == "nil") {
            Utility.displayAlertWithOKButton("", message: "Please provide Person Number", viewController: self)
            return
        }
        
        networkManger.sendDataToServer(MESSAGE_REQUEST_TYPE.PULL, PAFunctionName: AppConstants.PA_GET_PERSON, header: personHeader)
        showBusyIndicator()
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
    
    func didGetResponseForPA(_ paFunctionName: String, infoMessage: String, responseHaeders: Dictionary<String, AnyObject>) {
        hideBusyIndicator()
        Utility.displayStringInAlertView("", desc: "Person Downloaded.", viewController: self)
        self.didDownloadPersonHeader = true
        let resultData = self.getPersonHeader(responseHaeders)
        self.downloadedPersonHeader = resultData.0[0]
        self.emails = resultData.1
        self.contentView.isHidden = false
        
        var personName = ""
        if let fName = self.downloadedPersonHeader.FIRST_NAME {
            personName = fName
            if let lName = self.downloadedPersonHeader.LAST_NAME {
                personName += " " + lName
            }
        }
        
        self.nameLabel.text = personName
        
        if let number = self.downloadedPersonHeader.PERSNUMBER {
            self.personNumberLabel.text = String(describing: number)
        }
    }
    
    func didEncounterErrorForPA(_ paFunctionName: String, errorMessage: NSError) {
        hideBusyIndicator()
        self.contentView.isHidden = true
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
    
    func getPersonHeader(_ dataBEs: Dictionary<String, AnyObject>) -> ([PERSON_HEADER],[E_MAIL]) {
        var personHeaders: [PERSON_HEADER] = []
        var emails : [E_MAIL] = []
        
        for (_, beDictionary) in dataBEs {
            for (personHeader, personEmails) in beDictionary as! Dictionary<DataStructure, [E_MAIL]> {
                // Header
                personHeaders.append(personHeader as! PERSON_HEADER)
                emails.append(contentsOf: personEmails)
            }
        }
        return (personHeaders, emails)
    }
}
