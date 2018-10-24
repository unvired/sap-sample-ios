//
//  Utility.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 02/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import Foundation

struct Utility {
    
    static func removeExtraLinesFromTableView(_ tableView: UITableView) {
        // This will remove extra separators from tableview
        tableView.tableFooterView =  UIView(frame: CGRect.zero)
    }
    
    static func getCompleteInfoMessageStringFromInfoMessages(_ infoMessages: [AnyObject]) -> (String,Bool) {
        // Loop through Each of Info Messages and form one complete String.
        var completeInfoMessageString : String = ""
        var successInfoMessage: Bool = false
        for infoMessage in infoMessages {
            
            // Check Whether infoMessage is really the type of class |InfoMessage|
            if (infoMessage.isKind(of: InfoMessage.classForCoder())) {
                
                // Extract the Message
                let message: String! = infoMessage.getMessage()
                completeInfoMessageString = "\(completeInfoMessageString)" + message
                
                if let infoMessageStatus = infoMessage.getCategory() {
                    switch infoMessageStatus {
                    case INFO_MESSAGE_CATEGORY_SUCCESS,INFO_MESSAGE_CATEGORY_INFO:
                        successInfoMessage = true
                    case INFO_MESSAGE_CATEGORY_FAILURE:
                        successInfoMessage = false
                    default:
                        break
                    }
                }
            }
        }
        return (completeInfoMessageString, successInfoMessage)
    }
    
    static func displayAlertWithOKButton(_ title: String, message: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertAction: UIAlertAction = UIAlertAction(title:  NSLocalizedString("OK",  comment: ""), style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func displayErrorInformation(_ error: NSError?) {
        if error != nil {
            let desc: String = error!.localizedDescription
            displayStringInAlertView(NSLocalizedString("Error",  comment: ""), desc: desc)
        }
    }
    
    static func displayStringInAlertView(_ title: String, desc: String) {
        DispatchQueue.main.async {
            let errorAlertView: UIAlertView = UIAlertView(title:  title,
                                                          message: desc,
                                                          delegate: nil,
                                                          cancelButtonTitle:NSLocalizedString("OK",  comment: ""))
            errorAlertView.show()
        }
    }
     
    static func insertPersonHeaderToDB(person: PERSON_HEADER) {
        let dataManager: IDataManager = UnviredSAPSampleUtils.getApplicationDataManager()!
        do {
            
            try dataManager.insert(person)
        }
        catch let error as NSError {
            logErrorMessage(error)
        }
        
    }
    
    static func getAllPersonHeaders() -> [PERSON_HEADER] {
        let dataManager: IDataManager = UnviredSAPSampleUtils.getApplicationDataManager()!
        var personHeaders : [PERSON_HEADER] = []
        
        do {
            personHeaders = try dataManager.get(PERSON_HEADER.TABLE_NAME, whereClause: "", orderByFields: [PERSON_HEADER.FIRST_NAME]) as! [PERSON_HEADER]
            
            if personHeaders.count > 0 {
                return personHeaders
            }
            
        } catch let error as NSError {
            logErrorMessage(error)
        }
        
        return personHeaders
    }
    
    static func getEmailAddress(person: PERSON_HEADER) -> [E_MAIL] {
        let dataManager: IDataManager = UnviredSAPSampleUtils.getApplicationDataManager()!
        var emails : [E_MAIL] = []
        
        let whereClause = "\(E_MAIL.PERSNUMBER) = '\(person.PERSNUMBER!)'"
        
        
        do {
            emails = try dataManager.get(E_MAIL.TABLE_NAME, whereClause: whereClause, orderByFields: [E_MAIL.E_ADDR]) as! [E_MAIL]
            
            if emails.count > 0 {
                return emails
            }
            
        } catch let error as NSError {
            logErrorMessage(error)
        }
        
        return emails
    }
    
    
    static func deleteHeadersInDatabase(_ dataStructures: [IDataStructure]) -> Bool {
        let dataManager: IDataManager = UnviredSAPSampleUtils.getApplicationDataManager()!
        for dataStructure:IDataStructure in dataStructures {
            do {
                try dataManager.delete(dataStructure)
                return true
            }
            catch let error as NSError {
                Utility.logErrorMessage(error)
                return false
            }
        }
        
        return false
    }
    
    static func insertOrReplaceHeadersInDatabase(_ dataStructures: [IDataStructure]) -> Bool {
        let dataManager: IDataManager = UnviredSAPSampleUtils.getApplicationDataManager()!
        
        for dataStructure:IDataStructure in dataStructures {
            do {
                try dataManager.replace(dataStructure)
            }
            catch let error as NSError {
                Utility.displayErrorInformation(error)
            }
        }
        return true
    }
    
    static func logErrorMessage(_ error: NSError?) {
        if error != nil {
            Logger.logger(with: LEVEL.ERROR, className: String(describing: Utility()), method: #function , message: error!.localizedDescription)
        }
    }
    
    
}
