import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textQuestion: UILabel!
    @IBOutlet private var numberQuestion: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
        showLoadingIndicator()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textQuestion.text = step.question
        numberQuestion.text = step.questionNumber
    }

    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
                        title: result.title,
                        message: result.text,
                        buttonText: result.buttonText,
                        completion: { [weak self] in
                            guard let self = self else { return }
                            
                            self.presenter.restartGame()
                            self.resetBorder()
                            }
                        )
            
        alertPresenter?.presentAlert(model: alertModel, accessibilityIdentifier: "My Alert")
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showResults() {
        let text = presenter.makeResultMessage()
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: text,
            buttonText: "Сыграть ещё раз") { [weak self] in
                guard let self = self else {return}
                    
                self.presenter.restartGame()
                self.resetBorder()
            }
            
        self.alertPresenter?.presentAlert(model: alertModel, accessibilityIdentifier: "My Alert")
        
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: message,
                    buttonText: "Попробовать еще раз") { [weak self] in
                        guard let self = self else { return }
                        
                        self.presenter.restartGame()
                        self.resetBorder()
                    }
                        
        self.alertPresenter?.presentAlert(model: alertModel, accessibilityIdentifier: "My Alert")
    }
    
    func resetBorder() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
    }
    
    func enableOfButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func disableOfButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
