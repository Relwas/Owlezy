import UIKit
import SPConfetti
import AVFoundation

@available(iOS 13.0, *)
class ResultViewController: UIViewController {
    private var audioPlayer: AVAudioPlayer?

    private let correctAnswers: Int
    var completion: (() -> Void)?
    var tryAgainCallback: (() -> Void)?

    init(correctAnswers: Int) {
        self.correctAnswers = correctAnswers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startConfettiAnimation()
        playResultSound()
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "Fon")
        super.viewDidLoad()
        configureUI()
        setupAudioPlayer()
    }

    private func configureUI() {
        let congratulationsLabel = UILabel()
        congratulationsLabel.text = "Congratulations!"
        congratulationsLabel.textAlignment = .center
        congratulationsLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        congratulationsLabel.textColor = UIColor(named: "LabelColor1")
        congratulationsLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(congratulationsLabel)

        let resultLabel = UILabel()
        resultLabel.text = "Correct answers: \(correctAnswers)"
        resultLabel.textAlignment = .center
        resultLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        resultLabel.textColor = UIColor(named: "LabelColor1")
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            congratulationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            congratulationsLabel.bottomAnchor.constraint(equalTo: resultLabel.topAnchor, constant: -20),

            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        navigationItem.hidesBackButton = false

        let homeButton = UIButton(type: .custom)
        homeButton.setTitle("Back to home", for: .normal)
        homeButton.setTitleColor(UIColor(named: "LabelColor1"), for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        homeButton.contentMode = .scaleAspectFit
        homeButton.backgroundColor = .gray
        homeButton.layer.cornerRadius = 18
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeButton)

        NSLayoutConstraint.activate([
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            homeButton.widthAnchor.constraint(equalToConstant: 290),
            homeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func playResultSound() {
        if UserDefaults.standard.bool(forKey: "SoundSetting") {
            audioPlayer?.play()
        }
    }

    private func setupAudioPlayer() {
        if let soundURL = Bundle.main.url(forResource: "resultSound", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading result sound file: \(error.localizedDescription)")
            }
        } else {
            print("Result Sound file not found.")
        }
    }

    private func startConfettiAnimation() {
        SPConfetti.startAnimating(.fullWidthToDown, particles: [.triangle, .arc, .heart])
    }

    private func stopConfettiAnimation() {
        SPConfetti.stopAnimating()
    }

    @objc private func homeButtonTapped() {
        stopConfettiAnimation()
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
}
