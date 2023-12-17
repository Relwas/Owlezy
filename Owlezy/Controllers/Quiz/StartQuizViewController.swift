import UIKit

@available(iOS 13.0, *)
class StartQuizViewController: UIViewController {

    private var imageView: UIImageView!

    private let startQuizButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Quiz", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tabBarSelected
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.addTarget(self, action: #selector(startQuizButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")

        imageView = UIImageView(image: UIImage(named: "quizImg"))
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        let label = UILabel()
        label.text = "10 questions"
        label.textAlignment = .center
        label.textColor = UIColor(named: "LabelColor1")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        view.addSubview(startQuizButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            imageView.widthAnchor.constraint(equalToConstant: 350),
            imageView.heightAnchor.constraint(equalToConstant: 350),

            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),

            startQuizButton.widthAnchor.constraint(equalToConstant: 300),
            startQuizButton.heightAnchor.constraint(equalToConstant: 45),
            startQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startQuizButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @objc func startQuizButtonTapped() {
        let quizViewController = QuizViewController()
        quizViewController.modalPresentationStyle = .fullScreen
        present(quizViewController, animated: true)
    }
}
