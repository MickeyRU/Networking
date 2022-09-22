//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Павел Афанасьев on 21.09.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().responseDecodable(of: [CoursesModel].self) { response in
            
            switch response.result {
            case .success(let value):
                print(value)
            case.failure(let error):
                print(error)
            }
        }
    }
}
