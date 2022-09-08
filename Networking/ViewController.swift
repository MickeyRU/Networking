//
//  ViewController.swift
//  Networking
//
//  Created by Павел Афанасьев on 08.09.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getButtonPushed() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let response = response {
                print(response)
                print(data)
                
                do {
                    // Сюриализация данных полученных от сервера в json формат для последующего размещения
                    let json = try JSONSerialization.jsonObject(with: data, options: [] )
                    print(json)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    @IBAction func poshButtonPushed() {
    }
    
}
