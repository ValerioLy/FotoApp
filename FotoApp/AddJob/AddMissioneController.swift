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
    
    var listaIdUsers : [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IDUTENTI\(listaIdUsers)")
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
        
        guard  !title.isEmpty && !description.isEmpty else {
            let alert = UIAlertController(title: "Campi Vuoti", message: "Il titolo o la descrizione sono vuoti", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        NetworkManager.uploadTopics(title: title, descriptio: description, expiration: scadenza, creator: "", workers: listaIdUsers!, albums: [""]) { (success) in
            if success {
                print("Topic caricato")
            }
        }
        
        
      
    
    }

}
