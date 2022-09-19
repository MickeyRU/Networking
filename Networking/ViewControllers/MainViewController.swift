//
//  MainViewController.swift
//  Networking
//
//  Created by Павел Афанасьев on 14.09.2022.
//

import UIKit

enum Actions: String, CaseIterable {
    
    case downloadImage = "Download image"
    case get = "GET"
    case post = "POST"
    case OurCourses = "Our Courses"
    case uploadImage = "Upload Images"
}

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"

class MainViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return actions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.label.text = actions[indexPath.row].rawValue
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "Detail", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .OurCourses:
            performSegue(withIdentifier: "ourCourse", sender: self)
        case .uploadImage:
            print("load image")
        }
    }
}

