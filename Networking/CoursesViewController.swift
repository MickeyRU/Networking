//
//  CoursesViewController.swift
//  Networking
//
//  Created by Павел Афанасьев on 12.09.2022.
//

import UIKit

class CoursesViewController: UIViewController {
    
    @IBOutlet var courseTableView: UITableView!
    
    private var courses = [CoursesModel]()
    private var courseName: String?
    private var courseUrl: String?
    
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
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                self.courses = try jsonDecoder.decode([CoursesModel].self, from: data)
                DispatchQueue.main.async {
                    self.courseTableView.reloadData()
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func configureCell (cell: CoursesCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.coursesNameLabel.text = course.name
        
        if let numberOfTests = course.numberOfTests{
            cell.nubmerOfTests.text = "Number of tests: \(numberOfTests)"
            
        }
        //
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOflessons.text = "Number of lessons: \(numberOfLessons)"
            
        }
        
        // Обновление данных должно происходить в глобальной очереди
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            // Обновление интерфейса должно происходить в главной очереди
            DispatchQueue.main.async {
                cell.coursesImage.image = UIImage(data: imageData)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        vc.selectedCourse = courseName
        
        if let url = courseUrl {
            vc.courseURL = url
        }
    }
}



// MARK: - TableViewDelegate, TableViewDataSource

extension CoursesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoursesCell") as! CoursesCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        
        // Передаем данные о курсе в переменные для отображения на новом вебвью
        courseUrl = course.link
        courseName = course.name
        
        // метод для перехода по тапу на вебвью
        performSegue(withIdentifier: "DetailSigue", sender: self)
        
    }
}
