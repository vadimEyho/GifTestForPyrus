// WelcomeViewController.swift

import UIKit

protocol StartViewControllerProtocol: AnyObject {
    func displayGif(animatedImages: [UIImage])

}

class StartViewController: UIViewController {
    
    var presenter: StartPresenterProtocol?
    var gifButton: UIButton = UIButton()
    var gifImageView: UIImageView = UIImageView()

    var animatedImages: [UIImage] = []
    var currentFrame: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        gifButton.setTitle("Да или Нет?", for: .normal)
        gifButton.backgroundColor = .blue
        gifButton.layer.cornerRadius = 10  // Скругляем углы кнопки
        gifButton.addTarget(self, action: #selector(gifButtonTapped), for: .touchUpInside)
        gifButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifButton)

        NSLayoutConstraint.activate([
            gifButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gifButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gifButton.widthAnchor.constraint(equalToConstant: 200),
            gifButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        gifImageView.contentMode = .scaleAspectFit
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifImageView)

        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: gifButton.bottomAnchor, constant: 20),
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])

    }
    

    @objc func gifButtonTapped() {
        presenter?.getGifButtonTapped()
        print("Кнопка нажата")

        UIView.animate(withDuration: 0.3,
                       animations: {
                           self.gifButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                       },
                       completion: { _ in
                           UIView.animate(withDuration: 0.3) {
                               self.gifButton.transform = .identity
                           }
                       })
    }
}

extension StartViewController: StartViewControllerProtocol {
    func displayGif(animatedImages: [UIImage]) {
        self.animatedImages = animatedImages
        self.currentFrame = 0
        animateNextFrame()
    }

    private func animateNextFrame() {
        guard currentFrame < animatedImages.count else {
            return
        }
        gifImageView.image = animatedImages[currentFrame]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.currentFrame += 1
            self?.animateNextFrame()
        }
    }
}
