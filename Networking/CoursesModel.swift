//
//  CoursesModel.swift
//  Networking
//
//  Created by Павел Афанасьев on 12.09.2022.
//

import Foundation

struct CoursesModel: Decodable {
    var id: Int
    var name: String
    var link: String
    var imageUrl: String
    var number_of_lessons: Int
    var number_of_tests: Int
}
