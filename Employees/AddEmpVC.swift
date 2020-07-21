//
//  AddEmpVC.swift
//  Quotes
//
//  Created by Sumit Bangarwa on 11/6/19.
//  Copyright © 2019 Cocoacasts. All rights reserved.
//

import UIKit
import CoreData
class AddEmpVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Properties
    @IBOutlet var selTbl: UITableView!
    @IBOutlet var singleStck: UIStackView!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var cityField: UITextField!
    
    @IBOutlet var singleField: UITextField!
    
    @IBOutlet var contentsTextView: UITextView!
    
    // MARK: -
    
    var City = ["Delhi","Bengaluru", "Hyderabad", "Mumbai", "Pune", "Kolkata"]
    var selectCty = false
    var selectsngl = false
    
    var managedObjectContext: NSManagedObjectContext?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selTbl.isHidden = true
        singleStck.isHidden = true
        
        title = "Add Employee"
        addBtn()
        
    }
    @IBAction func doSelectBtn(_ sender: Any) {
        
        if (sender as AnyObject).tag == 0 {
            singleField.text = "Yes"
            selectsngl = true
            
        } else{
            singleField.text = "No"
            selectsngl = false
            
            
        }
        singleStck.isHidden = true

    }
    @objc func pressedBtnCity() {
        print("comming")
        if !selectCty {
            selTbl.isHidden = false
            selectCty = true
        } else {
            selTbl.isHidden = true
            selectCty = false
        }
    }
    @objc func pressedBtnSngl() {
        print("comming here")
        
        if !selectCty {
            singleStck.isHidden = false
            selectCty = true
        } else {
            singleStck.isHidden = true
            selectCty = false
        }
        
    }
    func addBtn() {
        let SelectcityBtn = UIButton()
        SelectcityBtn.setBackgroundImage(#imageLiteral(resourceName: "down-24"), for: .normal)
        SelectcityBtn.frame = CGRect(x: cityField.frame.size.width-32, y: 0, width: 24, height: 24)
        SelectcityBtn.addTarget(self, action: #selector(pressedBtnCity), for: .touchUpInside)
        
        let SelectsingleBtn = UIButton()
        
        SelectsingleBtn.setBackgroundImage(#imageLiteral(resourceName: "down-24"), for: .normal)
        
        SelectsingleBtn.frame = CGRect(x: singleField.frame.size.width-32, y: 0, width: 24, height: 24)
        SelectsingleBtn.addTarget(self, action: #selector(pressedBtnSngl), for: .touchUpInside)
        
        cityField.addSubview(SelectcityBtn)
        singleField.addSubview(SelectsingleBtn)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameField.becomeFirstResponder()
        emailField.becomeFirstResponder()
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func save(sender: UIBarButtonItem) {
        guard let managedObjectContext = managedObjectContext else { return }
        
        // Create Quote
        let record = Employee(context: managedObjectContext)
        
        // Configure Quote
        record.name = nameField.text
        record.email = emailField.text
        record.city = cityField.text
        record.single = selectsngl
        
        // Pop View Controller
        _ = navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = City[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityField.text = City[indexPath.row]
        selTbl.isHidden = true
        selectCty = false
    }
}
