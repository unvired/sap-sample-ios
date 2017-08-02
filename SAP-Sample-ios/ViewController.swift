//
//  ViewController.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 01/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = NSLocalizedString("Unvired SAP Sample", comment: "")
        let menuIcon = UIImage(named: "actions")
        let menuButton = UIButton()
        menuButton.setImage(menuIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        menuButton.tintColor = UIColor.white
        menuButton.addTarget(self, action: #selector(ViewController.menuButtonAction(_:)), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: menuButton)
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.tableView.keyboardDismissMode = .onDrag
        Utility.removeExtraLinesFromTableView(self.tableView)
        addButton.layer.cornerRadius = 0.5 * addButton!.bounds.size.width
    }
    
    func showFrameworkSettingsViewController() {
        let settingsViewController: FrameworkSettingsViewController = FrameworkSettingsViewController(style: UITableViewStyle.grouped)
        settingsViewController.delegate = self
        let navController: UINavigationController = UINavigationController(rootViewController: settingsViewController)
        navController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(navController, animated: true, completion: nil)
    }
    
    func showGetPersonScreen() {
        let getPersonViewController: GetPersonViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "getPersonViewController") as! GetPersonViewController
        self.navigationController?.pushViewController(getPersonViewController, animated: true)
    }
    
    // MARK:- Actions
    
    @IBAction func menuButtonAction(_ sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil,
                                                                   preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let getPersonAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Get Person", comment: ""), style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in self.showGetPersonScreen()
        }
        
        let settingsAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: UIAlertActionStyle.default) { (action: UIAlertAction) -> Void in self.showFrameworkSettingsViewController()
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title:  NSLocalizedString("Cancel",  comment: ""), style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(getPersonAction)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            alertController.popoverPresentationController?.passthroughViews = nil
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad  {
            alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let addPersonViewController: AddPersonViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addPersonViewController") as! AddPersonViewController
        self.navigationController?.pushViewController(addPersonViewController, animated: true)
    }
    
}

// MARK:- Framework Settings Delegate
extension ViewController : SettingsDelegate {
    func doneButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

