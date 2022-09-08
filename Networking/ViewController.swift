//
//  ViewController.swift
//  Networking
//
//  Created by Павел Афанасьев on 08.09.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonForLoadImage: UIButton!
    @IBOutlet weak var imageForLoad: UIImageView!
    @IBOutlet weak var labelForUserAction: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
    }
    
    @IBAction func buttonPressed() {
        labelForUserAction.isHidden = true
        buttonForLoadImage.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let url = URL(string: "https://i.artfile.ru/1920x1200_1072880_[www.ArtFile.ru].jpg") else { return }
         
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, responce, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageForLoad.image = image
                }
            }
        }.resume()
    }
}

