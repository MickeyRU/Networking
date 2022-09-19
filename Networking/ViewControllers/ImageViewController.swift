//
//  ViewController.swift
//  Networking
//
//  Created by Павел Афанасьев on 08.09.2022.
//

import UIKit

private let url = "https://i.artfile.ru/1920x1200_1072880_[www.ArtFile.ru].jpg"

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageForLoad: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        fetchImage() 
        
    }
    
    func fetchImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage(url: url) { (image) in
            self.activityIndicator.stopAnimating()
            self.imageForLoad.image = image
        }
       
    }
}

