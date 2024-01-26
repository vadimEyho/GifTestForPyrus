
import Foundation
import UIKit

protocol StartPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didLoadGif(response: GifResponse, animatedImages: [UIImage])
    func displayGif(animatedImages: [UIImage])
    func getGifButtonTapped()
    func parseGifResponse(data: Data)
}

class StartPresenter {
    weak var view: StartViewControllerProtocol?
    var router: StartRouterProtocol
    var interactor: StartInteractorProtocol
    
    init(interactor: StartInteractorProtocol, router: StartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func getGifButtonTapped() {
        interactor.getGif()
    }
}

extension StartPresenter: StartPresenterProtocol {
    func viewDidLoad() {
        interactor.getGif()
    }
    func displayGif(animatedImages: [UIImage]) {
        DispatchQueue.main.async {
            self.view?.displayGif(animatedImages: animatedImages)
        }
    }
    
    func parseGifResponse(data: Data) {
        // Преобразование данных GIF в массив изображений
        if let source = CGImageSourceCreateWithData(data as CFData, nil) {
            let imageCount = CGImageSourceGetCount(source)
            var images: [UIImage] = []
            
            for i in 0..<imageCount {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: cgImage))
                }
            }
            self.view?.displayGif(animatedImages: images)
        } else {
            print("Failed to create images from GIF data.")
        }
    }
    
    func didLoadGif(response: GifResponse, animatedImages: [UIImage]) {
        DispatchQueue.main.async {
            self.view?.displayGif(animatedImages: animatedImages)
        }
    }
}
