//
//  NetworkManager.swift
//  Networking
//
//  Created by Павел Афанасьев on 19.09.2022.
//

import UIKit

class NetworkManager {
    
    // static - позволяет не создавать экземпляр класса для вызова метода из вне
    
    static func getRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
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
    
    static func postRequest(url: String) {
        
        // Адресс с которым взаимодействуем
        guard let url = URL(string: url) else { return }

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

    // Захватываем данные о картике полученные из сети и передаем их через комплишен блок в вью контроллер для обновления интерфейса
    
    static func downloadImage(url: String, complition: @escaping (_ image: UIImage)->()) {
        
        guard let url = URL(string: url) else { return }
         
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    complition(image)
                }
            }
        }.resume()
    }
    
    static func fetchData(url: String, complition: @escaping (_ courses: [CoursesModel])->()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try jsonDecoder.decode([CoursesModel].self, from: data)
                
                complition(courses)
               
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func uploadImage(url: String) {
        
        let image = UIImage(named: "photo")!
        let httpHeaders = ["Authorization" : "Client-ID 214b69a00fa6c91"]
        guard let imageProperties = ImageProperties(withImage: image, forkey: "image") else { return }
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }.resume()  
    }
}
