// WelcomeViewController.swift

import UIKit

protocol StartViewControllerProtocol: AnyObject {
    func displayGif(animatedImages: [UIImage])

}

class StartViewController: UIViewController {
    
    
    // MARK: - var/let
    
    var presenter: StartPresenterProtocol?
    var gifButton: UIButton = UIButton()
    var gifImageView: UIImageView = UIImageView()
    var lableTitle = UILabel()

    var animatedImages: [UIImage] = []
    var currentFrame: Int = 0
    
    
    // MARK: - lifeСycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - setupUI
    
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupButton()
        SetupGifImageView()
        setupLableTitle()
    }
    
    
   private func setupButton(){
        gifButton.setTitle("Да или Нет?", for: .normal)
        gifButton.backgroundColor = .black
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
    }
    
    private func SetupGifImageView(){
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
    
    private func setupLableTitle(){
        lableTitle.text = "Не можешь решиться? ЖМИ"
        lableTitle.numberOfLines = 2
        lableTitle.font = .systemFont(ofSize: 25, weight: .bold)
        lableTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lableTitle)
        
        NSLayoutConstraint.activate([
            lableTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            lableTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
           
        ])
    }
    
   
    // MARK: - ButtonTapped

    @objc func gifButtonTapped() {
        presenter?.getGifButtonTapped()
        print("Кнопка нажата")

        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.gifButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                       },
                       completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               self.gifButton.transform = .identity
                           }
                       })
    }
}

// MARK: - extension

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
