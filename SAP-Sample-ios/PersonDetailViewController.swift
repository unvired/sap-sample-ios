//
//  PersonDetailViewController.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 03/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import Foundation

import UIKit

class PersonDetailViewController: UIViewController {
    
    // MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var contentView1: UIView!
    @IBOutlet weak var contentView2: UIView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var incomingPersonHeader: PERSON_HEADER = PERSON_HEADER()
    var emailIds : [E_MAIL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emailIds = Utility.getEmailAddress(person: incomingPersonHeader)
        self.setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.navigationItem.title = NSLocalizedString("Person Detail", comment: "")
        
        self.contentView1.layer.cornerRadius = 5
        self.contentView1.layer.borderWidth = 1
        self.contentView1.layer.borderColor = UIColor.white.cgColor
        self.contentView2.layer.cornerRadius = 5
        self.contentView2.layer.borderWidth = 1
        self.contentView2.layer.borderColor = UIColor.white.cgColor
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.cornerRadius = 5
        self.tableView.layer.borderColor = UIColor.white.cgColor
        
        
        if emailIds.count == 0 {
            self.tableView.isHidden = true
        }
        
        // 1. NAME
        var name = ""
        if let fName = incomingPersonHeader.FIRST_NAME {
            name += fName
            if let lName = incomingPersonHeader.LAST_NAME {
                name += " " + lName
            }
        }
        nameLabel.text = name
        
        // 2.NUMBER
        if let perNum = incomingPersonHeader.PERSNUMBER {
            numberLabel.text = String(describing: perNum)
        }
        
        // 3.GENDER
        if let gender = incomingPersonHeader.SEX {
            genderLabel.text = gender
        }
        
        // 4.PROFESSION
        if let profession = incomingPersonHeader.PROFESSION {
            professionLabel.text = profession
        }
        
        // 5.DOB
        if let dob = incomingPersonHeader.BIRTHDAY, dob != "" {
            dobLabel.text = dob
        }
        
        // 6.Height
        if let height = incomingPersonHeader.HEIGHT {
            heightLabel.text = String(describing: height) + " Cm"
        }
        
        // 7.Weight
        if let weight = incomingPersonHeader.WEIGHT {
            weightLabel.text = String(describing: weight) + " Kg"
        }
    }
}


// MARK:- TableView DataSource and Delegate methods
extension PersonDetailViewController: UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emailIds.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let tableViewActualHeight = tableView.contentSize.height
        tableViewHeightConstraint.constant = tableViewActualHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"cell")
        let email = emailIds[indexPath.row]
        
        if let emailId = email.E_ADDR {
            cell.textLabel?.text = emailId
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        return cell
    }
    
    
}

