//
//  EmpDetailsVC.swift
//  Quotes
//
//  Created by Sumit Bangarwa on 11/6/19.
//  Copyright © 2019 Cocoacasts. All rights reserved.
//

import UIKit

class EmpDetailsVC: UIViewController {

    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var cityField: UITextField!
    
    @IBOutlet var singleField: UITextField!
    
    var name = ""
    var city = ""
    var email = ""
    var single = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " Employee Details"

        nameField.text = name
        emailField.text = email
        cityField.text = city
        if single {
            singleField.text = "Yes"
        } else {
            singleField.text = "No"

        }
        print(name,city,email)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
