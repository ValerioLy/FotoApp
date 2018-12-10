//
//  GeneralUtils.swift
//  Cinema
//
//  Created by stefano vecchiati on 22/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

class GeneralUtils: NSObject {
    
    static let share = GeneralUtils()
    
    func alertError(title: String?, message: String?, closeAction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "AAA", style: .default, handler: {
            action in
            closeAction()
        } )
        alert.addAction(ok)
        return alert
    }
    
    func reloadGenericViewController(storyboardName : String, controllerIdentifier: String) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let setViewController = mainStoryboard.instantiateViewController(withIdentifier: controllerIdentifier)
        let rootViewController = UIApplication.shared.windows.last?.rootViewController
        rootViewController?.present(setViewController, animated: true, completion: nil)
    }
    

}
