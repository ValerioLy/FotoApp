//
//  AddMissioneController.swift
//  FotoApp
//
//  Created by Valerio Ly on 11/12/18.
//

import UIKit

class AddMissioneController: UIViewController {

    
    enum TagField : Int {
        case name = 0
        case data
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblSubtitle: UILabel!
    
    @IBOutlet var labels: [UILabel]!
    
    
    @IBOutlet var textfields: [UITextField]!
    
    @IBOutlet weak var fieldDescription: UITextView!
    
    
    var worker : [Users] = []
    
//    private var workers : [Topics] = []
    
    var idusers : [String]!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func addMission(_ sender: Any) {
        var title : String = ""
        var description : String = ""
        var scadenza : String = ""
        
        for textfield in textfields {
            switch textfield.tag {
            case TagField.name.rawValue:
                title = textfield.text!
            case TagField.data.rawValue:
                scadenza = textfield.text!
            default : break
            }
        }
        description  = fieldDescription.text!
        
        
        
        
        
        
        
        NetworkManager.uploadWorkerInfo(title: title, description: description, data: scadenza, idUser: idusers ) { (success) in
            debugPrint("Job Info Caricato")
        }
    }
    
   

}
