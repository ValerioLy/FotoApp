//
//  AddMissionController.swift
//  FotoApp
//
//  Created by Valerio Ly on 07/12/18.
//

import UIKit
import Firebase

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
    
    var worker : [Users] = []
    
    //private var workers : [Topics] = []
    
     var idusers : [String]!
    
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
                scadenza = textfield.text!
            default : break
            }
        }
        description  = descriptionField.text!
        
        
    
      
        
      
        
//        NetworkManager.uploadWorkerInfo(title: title, description: description, data: scadenza, idUser: idusers ) { (success) in
//            debugPrint("Job Info Caricato")
//        }
        
    
    
}
}
