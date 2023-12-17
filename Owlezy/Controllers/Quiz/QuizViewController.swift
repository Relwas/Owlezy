import UIKit
import AVFoundation

struct Question {
    let imageURL: String
    let correctAnswer: String
    let incorrectAnswers: [String]
}

@available(iOS 13.0, *)
class QuizViewController: UIViewController {
    private var correctSoundPlayer: AVAudioPlayer?
    private var incorrectSoundPlayer: AVAudioPlayer?
    private var quizEnded = false
    private var correctAnswers = 0
    private var questions: [Question] = []
    private var currentQuestionIndex = 0
    private var timer: Timer?
    private var timeRemaining = 10
    private let maxTime = 10
    private var musicPlayer: AVAudioPlayer?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let answerButton1 = UIButton()
    private let answerButton2 = UIButton()
    private let answerButton3 = UIButton()
    
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "what kind of breed is this?"
        label.textColor = UIColor(named: "LabelColor1")
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 22.0)
        label.textAlignment = .center
        return label
    }()
    
    private let smoothProgressBar: SmoothProgressBar = {
        let progressBar = SmoothProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")
        setupViews()
        loadQuestions()
        showCurrentQuestion()
        startTimer()
        
        loadSound(named: "correctSound", into: &correctSoundPlayer)
        loadSound(named: "incorrectSound", into: &incorrectSoundPlayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateVibrationSetting), name: Notification.Name("VibrationSettingChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSoundSetting), name: Notification.Name("SoundSettingChanged"), object: nil)
    }
    
    private func setupViews() {
        view.addSubview(smoothProgressBar)
        view.addSubview(imageView)
        view.addSubview(label1)
        view.addSubview(answerButton1)
        view.addSubview(answerButton2)
        view.addSubview(answerButton3)
        
        let buttonFont = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
        let buttonTitleColor = UIColor.white
        
        answerButton1.titleLabel?.font = buttonFont
        answerButton2.titleLabel?.font = buttonFont
        answerButton3.titleLabel?.font = buttonFont
        
        answerButton1.tintColor = buttonTitleColor
        answerButton2.tintColor = buttonTitleColor
        answerButton3.tintColor = buttonTitleColor

        answerButton1.translatesAutoresizingMaskIntoConstraints = false
        answerButton2.translatesAutoresizingMaskIntoConstraints = false
        answerButton3.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        
        answerButton1.layer.cornerRadius = 20
        answerButton1.backgroundColor = .tabBarSelected
        answerButton2.layer.cornerRadius = 20
        answerButton2.backgroundColor = .tabBarSelected
        answerButton3.layer.cornerRadius = 20
        answerButton3.backgroundColor = .tabBarSelected
        
        answerButton1.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        answerButton2.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        answerButton3.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            smoothProgressBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            smoothProgressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            smoothProgressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            smoothProgressBar.heightAnchor.constraint(equalToConstant: 30),
            
            imageView.topAnchor.constraint(equalTo: smoothProgressBar.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            label1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            answerButton1.bottomAnchor.constraint(equalTo: answerButton2.topAnchor, constant: -10),
            answerButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton1.heightAnchor.constraint(equalToConstant: 50),
            
            answerButton2.bottomAnchor.constraint(equalTo: answerButton3.topAnchor, constant: -10),
            answerButton2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton2.heightAnchor.constraint(equalToConstant: 50),
            
            answerButton3.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            answerButton3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerButton3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            answerButton3.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func loadSound(named fileName: String, into player: inout AVAudioPlayer?) {
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: soundURL)
                player?.prepareToPlay()
                print("Successfully loaded \(fileName) sound.")
            } catch let error {
                print("Error loading \(fileName) sound: \(error.localizedDescription)")
            }
        } else {
            print("Could not find \(fileName) sound file.")
        }
    }

    private func loadQuestions() {
        if let breedsURL = Bundle.main.url(forResource: "Breeds", withExtension: nil),
           let breedNames = try? FileManager.default.contentsOfDirectory(atPath: breedsURL.path) {
            
            var questionCount = 0
            
            for breedName in breedNames {
                let correctAnswer = breedName
                let incorrectAnswers = breedNames.filter { $0 != correctAnswer }
                
                let shuffledIncorrectAnswers = incorrectAnswers.shuffled().prefix(2)
                
                if let imageNames = try? FileManager.default.contentsOfDirectory(atPath: "\(breedsURL.path)/\(breedName)") {
                    if let randomImageName = imageNames.shuffled().first {
                        let question = Question(
                            imageURL: "\(breedsURL.path)/\(breedName)/\(randomImageName)",
                            correctAnswer: correctAnswer,
                            incorrectAnswers: Array(shuffledIncorrectAnswers)
                        )
                        
                        questions.append(question)
                        questionCount += 1
                        
                        if questionCount >= 10 {
                            break
                        }
                    } else {
                        print("No images found in the folder: \(breedName)")
                    }
                }
            }
        } else {
            print("Failed to load breed names.")
        }
    }
    
    private func showCurrentQuestion() {
        guard currentQuestionIndex < questions.count else {
            print("Quiz already ended.")
            return
        }

        let currentQuestion = questions[currentQuestionIndex]
        
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = UIImage(named: currentQuestion.imageURL)
        }, completion: nil)
        
        UIView.transition(with: label1, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.label1.text = "what kind of breed is this?"
        }, completion: nil)

        let shuffledAnswers = (currentQuestion.incorrectAnswers + [currentQuestion.correctAnswer]).shuffled()
        animateAnswerButton(answerButton1, title: shuffledAnswers[0])
        animateAnswerButton(answerButton2, title: shuffledAnswers[1])
        animateAnswerButton(answerButton3, title: shuffledAnswers[2])

        resetTimer()
    }

    private func animateAnswerButton(_ button: UIButton, title: String) {
        UIView.transition(with: button, duration: 0.3, options: .transitionCrossDissolve, animations: {
            button.setTitle(title, for: .normal)
        }, completion: nil)
    }

    private func handleQuizEnd() {
        let resultViewController = ResultViewController(correctAnswers: correctAnswers)
        resultViewController.completion = { [weak self] in
            self?.startNewQuiz()
        }
        navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    private func moveToNextQuestion() {
        guard currentQuestionIndex < questions.count else {
            print("Quiz already ended.")
            endQuiz()
            return
        }

        currentQuestionIndex += 1
        if currentQuestionIndex < questions.count {
            showCurrentQuestion()
        } else {
            print("Quiz already ended.")
            endQuiz()
        }
    }
    
    @objc func updateVibrationSetting(_ notification: Notification) {
        if let isVibrationEnabled = notification.userInfo?["isVibrationEnabled"] as? Bool {
            VibrationManager.shared.isVibrationEnabled = isVibrationEnabled
        }
    }
    
    private func startTimer() {
        let timerInterval: TimeInterval = currentQuestionIndex == 9 ? 0.1 : 1.0
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        timeRemaining = maxTime
        smoothProgressBar.progress = 1.0
    }
    
    @objc private func timerTick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            let progress = CGFloat(timeRemaining) / CGFloat(maxTime)
            smoothProgressBar.progress = progress
        } else {
            print("Time's up!")
            moveToNextQuestion()
        }
    }
    
    private func endQuiz() {
        timer?.invalidate()
        quizEnded = true
        showResultController(correctAnswers: correctAnswers)
    }

 
    private func showResultController(correctAnswers: Int) {
        let resultController = ResultViewController(correctAnswers: correctAnswers)
        resultController.tryAgainCallback = { [weak self] in
            self?.startNewQuiz()
        }
        resultController.modalPresentationStyle = .fullScreen
        present(resultController, animated: true)
    }
    
    private func playMusic(musicName: String) {
        if UserDefaults.standard.bool(forKey: "SoundSetting"), let musicURL = Bundle.main.url(forResource: musicName, withExtension: "mp3") {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                musicPlayer?.prepareToPlay()
                musicPlayer?.play()
            } catch let error {
                print("Error playing music: \(error.localizedDescription)")
            }
        } else {
            print("Sound is disabled or could not find music file.")
        }
    }

    @objc func updateSoundSetting() {
        if let isSoundEnabled = UserDefaults.standard.value(forKey: "SoundSetting") as? Bool {
            if isSoundEnabled {
                playMusic(musicName: "your_music_file_name")
            } else {
                stopMusic()
            }
        }
    }

    private func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }
    
    internal func startNewQuiz() {
        correctAnswers = 0
        currentQuestionIndex = 0
        questions.removeAll()
        loadQuestions()
        showCurrentQuestion()
        startTimer()
        updateProgress()
    }
    private func updateProgress() {
        let newProgress: CGFloat = 1
        smoothProgressBar.progress = newProgress
    }

    @objc private func answerButtonTapped(_ sender: UIButton) {
        guard currentQuestionIndex < questions.count else {
            return
        }

        let isCorrectAnswer = sender.title(for: .normal) == questions[currentQuestionIndex].correctAnswer

        if isCorrectAnswer {
            correctAnswers += 1
            if UserDefaults.standard.bool(forKey: "SoundSetting") {
                correctSoundPlayer?.play()
            }
            if VibrationManager.shared.getCurrentVibrationSetting() {
                VibrationManager.shared.vibrateSuccess()
            }
            sender.backgroundColor = .correctButton
        } else {
            if UserDefaults.standard.bool(forKey: "SoundSetting") {
                incorrectSoundPlayer?.play()
            }
            sender.backgroundColor = .incorrectButton
            if VibrationManager.shared.getCurrentVibrationSetting() {
                VibrationManager.shared.vibrateSuccess()
            }
        }

        answerButton1.isUserInteractionEnabled = false
        answerButton2.isUserInteractionEnabled = false
        answerButton3.isUserInteractionEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.moveToNextQuestion()
            self.resetButtonColors()
            self.answerButton1.isUserInteractionEnabled = true
            self.answerButton2.isUserInteractionEnabled = true
            self.answerButton3.isUserInteractionEnabled = true
        }
    }
    
    private func resetButtonColors() {
        answerButton1.backgroundColor = .tabBarSelected
        answerButton2.backgroundColor = .tabBarSelected
        answerButton3.backgroundColor = .tabBarSelected
    }
}
