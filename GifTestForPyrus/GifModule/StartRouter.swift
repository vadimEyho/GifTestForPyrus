//
//  WelcomeRouter.swift
//  Night
//
//  Created by Вадим Эйхольс on 18.01.2024.
//

import Foundation
//Тут была бы навигация

protocol StartRouterProtocol: AnyObject {
}

class StartRouter: StartRouterProtocol {
    weak var viewController: StartViewController?
   
}
