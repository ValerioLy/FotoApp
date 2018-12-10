//
//  FullImageViewerController.swift
//  FotoApp
//
//  Created by Nicola on 05/12/18.
//

import UIKit

class FullImageViewerController: UIViewController {
    @IBOutlet weak var metaDate: UILabel!
    @IBOutlet weak var metaUser: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var metadataContainer: UIView!
    
    var imageToShow : Photo!
    private var isMetadataHidden : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // empty error handling
        guard let image = imageToShow else {return}
        
        // hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // zoom and tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreen(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomImage(_:)))
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panImage(_:)))
        
        self.imageView.addGestureRecognizer(tapGesture)
        self.imageView.addGestureRecognizer(pinchGesture)
//        self.imageView.addGestureRecognizer(panGesture)
        
        // show metadata
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM, yyyy"
        self.metaDate.text = dateFormatter.string(from: image.date)
        self.metaUser.text = "User"
        
        // load the image
        NetworkImageManager.image(from: image.link) { (imageData, success) in
            DispatchQueue.main.async {
                if success {
                    self.imageView.image = UIImage(data: imageData!)
                }
                else {
                    // error handling
                }
            }
        }
    }
}

extension FullImageViewerController {
    
    @objc func dismissFullScreen(_ sender : UITapGestureRecognizer) {
        if isMetadataHidden {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isMetadataHidden = false
            }
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func zoomImage(_ sender : UIPinchGestureRecognizer) {
        guard sender.scale <= 1.5, let scale = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale) else { return }
        sender.view?.transform = scale
        
        if sender.scale <= 1 && isMetadataHidden {
             //slide up the view
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: 0)
                self.isMetadataHidden = false
            }
        }
        else if !isMetadataHidden {
            // slide down the view
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: self.imageView.frame.height)
                self.isMetadataHidden = true
            }
        }

        if let view = sender.view?.frame, view.width < UIScreen.main.bounds.width || view.height < UIScreen.main.bounds.height {
            sender.view?.frame = UIScreen.main.bounds
        }
    }
    
    @objc func panImage(_ sender : UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        let newX = translation.x
        let newY = translation.y
        
        debugPrint("X : " , newX , ", Y : " , newY)
        
        guard newX >= 0 || newX <= UIScreen.main.bounds.width else {
            return
        }
        
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//
//        guard !isMetadataHidden else {return}
//
//        // slide down the view
//        UIView.animate(withDuration: 0.3) { () -> Void in
//            self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: self.imageView.frame.height)
//            self.isMetadataHidden = true
//        }
//    }
//
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//
//        if scale == 1.0 || scale < 1.2 {
//            // slide up the view
//            UIView.animate(withDuration: 0.3) { () -> Void in
//                self.metadataContainer.transform = CGAffineTransform(translationX: 0, y: 0)
//                self.isMetadataHidden = false
//            }
//        }
//    }
}
