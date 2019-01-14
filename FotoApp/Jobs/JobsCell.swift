//
//  JobsCell.swift
//  FotoApp
//
//  Created by Marco Cozza on 04/12/2018.
//

import UIKit

class JobsCell: UITableViewCell {

    @IBOutlet weak var missionName: UILabel!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var missionDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
 
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?)->()) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in            completion(data!, response)
            }.resume()
    }
    
    func downloadImage(url: URL){
        print("Download Started")
        getDataFromUrl(url: url) { (data, response)  in
           
            guard let data = data else { return }
          
            DispatchQueue.main.async() { () -> Void in
                print(response?.suggestedFilename ?? url.lastPathComponent )
                print("Ultimo Download Finished")
                self.imageOutlet.roundedCorners()
                self.imageOutlet.image = UIImage(data: data)
            }
        }
    }

}
