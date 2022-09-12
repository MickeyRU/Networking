//
//  CoursesViewController.swift
//  Networking
//
//  Created by Павел Афанасьев on 12.09.2022.
//

import UIKit

class CoursesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        let coursesUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
        
        guard let url = URL(string: coursesUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data else { return }
            
            do {
                let course = try JSONDecoder().decode([CoursesModel.self], from: data)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
