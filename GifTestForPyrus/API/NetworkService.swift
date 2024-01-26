//
//  NetworkService.swift
//  Night
//
//  Created by Вадим Эйхольс on 26.01.2024.
//

import Foundation

class NetworkService {
    static func requestData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, error)
        }.resume()
    }
}
