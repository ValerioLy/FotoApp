//
//  AddMissionController.swift
//  FotoApp
//
//  Created by Valerio Ly on 07/12/18.
//

import UIKit

class AddMissionController: UIViewController {

    enum TagField : Int {
    case name = 0
    case data
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var lblTitle: UILabel!
   
    
    @IBOutlet weak var lblnamedescription: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var dataLbl: UILabel!
    
    var worker : Users = Users()
    
    private var jobs : [Topics] = []
    
    
    @IBOutlet var textFields: [UITextField]!

    @IBOutlet weak var descriptionField: UITextView!
    
    
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        var title : String = ""
        var description : String = ""
        var scadenza : String = ""
        
        for textfield in textFields {
            switch textfield.tag {
            case TagField.name.rawValue:
                title = textfield.text!
            case TagField.data.rawValue:
                description = textfield.text!
            default : break
            }
        }
        scadenza  = dataLbl.text!
        
    
        
        
        
        NetworkManager.uploadWorkerInfo(title: title, description: description, data: scadenza) { (success) in
            debugPrint("Job Info Caricato")
        }
        
    
    
}
}
