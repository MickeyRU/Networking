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
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let response = response {
                print(data)
                print(response)
                do {
                    // Сериализация данных полученных от сервера в json формат для последующего размещения
                    let json = try JSONSerialization.jsonObject(with: data, options: [] )
                    print(json)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    
    @IBAction func postButtonPushed() {
        
        // Адресс с которым взаимодействуем
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

        // Данные которые мы отправляем на сервер
        let userData = ["Course": "Networking", "Student": "Pavel Afanasyev"]
        
        // Запрос и его настройка
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Обратная сериализация наших данных - для отправки на сервер
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json ", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, let response = response else { return }
            
            print(response)

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                print(json)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
