class StartModuleBuilder {
    static func build() -> StartViewController {
        let api = GifAPI()
        let interactor = StartInteractor(api: api)
        let router = StartRouter()
        let presenter = StartPresenter(interactor: interactor, router: router)
        let viewController = StartViewController()

        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.viewController = viewController

        return viewController
    }
}
