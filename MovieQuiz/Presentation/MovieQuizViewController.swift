import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textQuestion: UILabel!
    @IBOutlet private var numberQuestion: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        statisticService = StatisticServiceImplementation(userDefaults: UserDefaults.standard, decoder: JSONDecoder(), encoder: JSONEncoder()
        )
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.hideLoadingIndicator()
            self?.show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textQuestion.text = step.question
        numberQuestion.text = step.questionNumber
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
                        title: result.title,
                        message: result.text,
                        buttonText: result.buttonText,
                        completion: { [weak self] in
                            guard let self = self else { return }
                            
                            self.presenter.resetQuestionIndex()
                            self.correctAnswers = 0
                            self.questionFactory?.requestNextQuestion()
                            self.resetBorder()
                            }
                        )
            
        alertPresenter?.presentAlert(model: alertModel)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            showResults()
        } else {
            showLoadingIndicator()
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            resetBorder()
        }
        
        enableOfButtons()
    }
    
    private func showResults() {
        if let statisticService = statisticService {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            
            guard let bestGame = statisticService.bestGame else {
                return
            }
            
            let text = """
                    Ваш результат: \(correctAnswers)/10
                    Количество сыгранных раундов: \(statisticService.gamesCount)
                    Рекорд: \(bestGame.correct)/10 (\(bestGame.date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                    """
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз") { [weak self] in
                    guard let self = self else {return}
                    
                    self.presenter.resetQuestionIndex()
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                    self.resetBorder()
                }
            
            self.alertPresenter?.presentAlert(model: alertModel)
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(
                    title: "Что-то пошло не так(",
                    message: message,
                    buttonText: "Попробовать еще раз") { [weak self] in
                        guard let self = self else { return }
                        
                        self.presenter.resetQuestionIndex()
                        self.correctAnswers = 0
                        self.questionFactory?.loadData()
                        self.resetBorder()
                    }
                        
        self.alertPresenter?.presentAlert(model: alertModel)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func resetBorder() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
    }
    
    private func enableOfButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func disableOfButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        disableOfButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        disableOfButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
