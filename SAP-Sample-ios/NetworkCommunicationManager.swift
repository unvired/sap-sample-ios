//
//  NetworkCommunicationManager.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 02/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import Foundation

protocol NetworkConnectionDelegate {
    func didGetResponseForPA(_ paFunctionName : String,infoMessage:String, responseHaeders: Dictionary<String, AnyObject>)
    func didEncounterErrorForPA(_ paFunctionName: String, errorMessage: NSError)
    func didNotFindSystemCredentials(_ paFunctionName: String)
}

class NetworkCommunicationManager : NSObject {
    
    var delegate: NetworkConnectionDelegate?
    
    internal func sendDataToServer(_ messageReqType: MESSAGE_REQUEST_TYPE, PAFunctionName : String, header: IDataStructure) {
        DispatchQueue.global(qos: .background).async {
            var syncResponse: ISyncResponse?
            var error: NSError?
            
            // Network Down
            if let reachability = Reachability.forInternetConnection() {
                if reachability.currentReachabilityStatus() == NotReachable {
                    Logger.logger(with: .ERROR, className: " NetworkCommunicationManager", method: #function, message: "Network unreachable. Cannot connect to network. Make sure you are connected to a network and try again.")
                    let message: String =  NSLocalizedString("Cannot connect to network. Make sure you are connected to a network and try again.",  comment: "")
                    let error: NSError = NSError(domain: "UnviredError", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                    Logger.loggerWithlog(LEVEL.ERROR, className:  NetworkCommunicationManager.self, methodName: #function, msg: error.localizedDescription)
                    self.makeErrorCallback(PAFunctionName, error: error)
                    return
                }
            }
            
            do {
                syncResponse = try SyncEngine.sharedInstance().submitInForeground(withRequest: messageReqType,
                                                                                  dataStructure: header,
                                                                                  customData: "",
                                                                                  processAgentFunctionName: PAFunctionName,
                                                                                  autosave: false)
            } catch let errorString as NSError {
                error = errorString
                self.makeErrorCallback(PAFunctionName, error: error!)
                return
            }
            
            if let syncBEResponse: SyncBEResponse = syncResponse as? SyncBEResponse {
                
                // Check for response code to know the status of SYNC Call
                let responseStatus: RESPONSE_STATUS! = syncBEResponse.getCode()
                
                switch (responseStatus) {
                case RESPONSE_STATUS():
                    // As a first check, always look for Info Messages from server.
                    // Info Messages contain a brief description of the error information from server
                    let infoMessages: [AnyObject]? = syncBEResponse.infoMessages as [AnyObject];
                    var dataBEsDictionary: Dictionary<String, AnyObject> = [:]
                    var infoMessage = ""
                    
                    if let theInfoMessage = infoMessages {
                        
                        if theInfoMessage.count > 0 {
                            
                            let completeInfoMessages = Utility.getCompleteInfoMessageStringFromInfoMessages(theInfoMessage)
                            let successInfoMessage = completeInfoMessages.1
                            
                            if successInfoMessage {
                                infoMessage = completeInfoMessages.0
                            } else {
                                let error: NSError = NSError(domain: "com.unvired.error", code: 0, userInfo: [NSLocalizedDescriptionKey: completeInfoMessages.0])
                                self.makeErrorCallback(PAFunctionName, error: error)
                                return
                            }
                        }
                    }
                    
                    // Extract and return the Bes Dictionary
                    if syncBEResponse.dataBEs != nil {
                        dataBEsDictionary = syncBEResponse.dataBEs as! Dictionary<String, AnyObject>;
                        self.makeSuccessCallback(PAFunctionName, infoMessage: infoMessage, responseHaeders: dataBEsDictionary)
                    }
                    
                case RESPONSE_STATUS.CANCEL:
                    // This may happens in two cases :
                    // 1. User may cancel the network call.
                    // 2. If there is no system credential.
                    self.makeSystemCredentialNotFoundCallback(PAFunctionName)
                    
                    
                case RESPONSE_STATUS.FAILURE:
                    print("Call Failed. Need to Handle it")
                    
                default: break
                    
                }
            }
            else {
                print("Sync Raw Response instead of SyncBEResponse")
            }
        }
    }
    
    func makeSuccessCallback(_ paFunctionName: String, infoMessage: String, responseHaeders : Dictionary<String, AnyObject>) {
        DispatchQueue.main.async {
            self.delegate?.didGetResponseForPA(paFunctionName, infoMessage: infoMessage,responseHaeders: responseHaeders)
        }
    }
    
    func makeErrorCallback(_ paFunctionName: String, error: NSError) {
        DispatchQueue.main.async {
            self.delegate?.didEncounterErrorForPA(paFunctionName, errorMessage: error)
        }
    }
    func makeSystemCredentialNotFoundCallback(_ paFunctionName: String) {
        DispatchQueue.main.async {
            self.delegate?.didNotFindSystemCredentials(paFunctionName)
        }
    }
}
