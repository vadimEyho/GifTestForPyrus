// WelcomeInteractor.swift
import Foundation
import UIKit

protocol StartInteractorProtocol: AnyObject {
    func getGif()
}

class StartInteractor: StartInteractorProtocol {
    weak var presenter: StartPresenterProtocol?
    let api: GifAPI
    
    init(api: GifAPI = GifAPI()) {
        self.api = api
    }
    
    func getGif() {
        api.getGif { [weak self] data, error in
            guard let self = self else { return }
            if let data = data {
                self.parseGifResponse(data: data)
            } else if let error = error {
                print("Error loading gif: \(error)")
            }
        }
    }
    
    func parseGifResponse(data: Data) {
        do {
            let decoder = JSONDecoder()
            let gifResponse = try decoder.decode(GifResponse.self, from: data)
            
            if gifResponse.image.absoluteString.lowercased().hasSuffix(".gif") {
                if let animatedImages = self.createAnimatedImages(from: data) {
                    self.presenter?.didLoadGif(response: gifResponse, animatedImages: animatedImages)
                } else {
                    print("Не удалось создать анимированный UIImage из данных GIF.")
                }
            } else {
                print("Полученное изображение не в формате GIF: \(gifResponse.image)")
                
                self.presenter?.displayGif(animatedImages: [UIImage(data: data) ?? UIImage()])
            }
        } catch {
            print("Ошибка декодирования ответа GIF: \(error)")

            if let responseString = String(data: data, encoding: .utf8) {
                print("Содержимое ответа: \(responseString)")
            } else {
                print("Не удалось преобразовать данные ответа в строку.")
            }
        }
    }
    
    private func createAnimatedImages(from data: Data) -> [UIImage]? {
        do {
            let decoder = JSONDecoder()
            let gifResponse = try decoder.decode(GifResponse.self, from: data)

            print("GIF Image URL: \(gifResponse.image)")

            guard let gifURL = URL(string: gifResponse.image.absoluteString),
                  let gifData = try? Data(contentsOf: gifURL) else {
                print("Failed to load GIF data from URL.")
                return nil
            }

            guard let animatedImage = UIImage.gif(data: gifData) else {
                print("Failed to create animated UIImage from GIF data.")
                return nil
            }

            return [animatedImage]
        } catch {
            print("Error decoding gif response: \(error)")
            return nil
        }
    }
}

extension UIImage {
    public class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Failed to create image source from GIF data.")
            return nil
        }
        
        let imageCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        
        for i in 0..<imageCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let uiImage = UIImage(cgImage: cgImage)
                
                var duration: TimeInterval = 0.1
                
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                   let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                   let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
                    duration = TimeInterval(delayTime)
                }
                
                let frame = UIImage(cgImage: cgImage, scale: uiImage.scale, orientation: uiImage.imageOrientation)
                frame.accessibilityIdentifier = "frame_\(i)"
                images.append(frame)
            }
        }
        
        if images.isEmpty {
            print("No images found in GIF data.")
        }
        
        return UIImage.animatedImage(with: images, duration: images.reduce(0.0, { $0 + $1.duration }))
    }
}
