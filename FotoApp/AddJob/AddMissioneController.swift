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
    
    @IBOutlet var labels: [UILabel]!
    var listaIdUsers : [String]!
    
    @IBOutlet weak var jobName: UITextField!
    @IBOutlet weak var fieldDescription: UITextView!
    @IBOutlet weak var jobDate: UIDatePicker!
    var edit = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func addMission(_ sender: Any) {
        let title : String = jobName.text ?? ""
        let description : String = fieldDescription.text!
        let scadenza : String = jobDate.date.dateInString
        
        guard  !title.isEmpty && !description.isEmpty else {
            let alert = UIAlertController(title: "Campi Vuoti", message: "Il titolo o la descrizione sono vuoti", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let loading = UIApplication.loadingAlert(title: "Loading")
        self.present(loading, animated: true, completion: nil)
        
        NetworkManager.uploadTopics(title: title, descriptio: description, expiration: scadenza, workers: listaIdUsers!) { (success) in
            if success {
                loading.dismiss(animated: true, completion: {
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: JobsListViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                })
            }
        }
    }

}
