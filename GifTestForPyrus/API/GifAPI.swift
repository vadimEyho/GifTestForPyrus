//
//  WelcomeAPI.swift
//  Night
//
//  Created by Вадим Эйхольс on 26.01.2024.
//

import Foundation

protocol GifAPIProtocol {
    func getGif(completion: @escaping (Data?, Error?) -> Void)
}

class GifAPI: GifAPIProtocol {
    let networkService: NetworkService

    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }

    func getGif(completion: @escaping (Data?, Error?) -> Void) {
        print("Был запрос")
        let url = URL(string: "https://yesno.wtf/api")!
        NetworkService.requestData(from: url, completion: completion)
    }
}
