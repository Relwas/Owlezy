import UIKit
import FLAnimatedImage

class AboutAppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Fon")

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)

        let titleLabel = UILabel()
        titleLabel.text = "About Owlezy"
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(named: "LabelColor1")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let gifContainerView = UIView()
        gifContainerView.translatesAutoresizingMaskIntoConstraints = false
        gifContainerView.layer.cornerRadius = 15
        gifContainerView.layer.masksToBounds = true
        gifContainerView.layer.shadowColor = UIColor.black.cgColor
        gifContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        gifContainerView.layer.shadowRadius = 4
        gifContainerView.layer.shadowOpacity = 0.3
        contentView.addSubview(gifContainerView)

        let gifImageView = FLAnimatedImageView()
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.translatesAutoresizingMaskIntoConstraints = false

        if let gifURL = Bundle.main.url(forResource: "aboutGif", withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL) {
            gifImageView.animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            gifImageView.clipsToBounds = true
        } else {
            print("Error: GIF file not found or failed to load data.")
        }

        gifContainerView.addSubview(gifImageView)

        let largeTextLabel = UILabel()
        largeTextLabel.text = "Discover the fascinating world of owls with our comprehensive application dedicated to these majestic birds of prey. Our app is your go-to resource for owl enthusiasts, providing a wealth of information on owl breeds, stunning images, an encyclopedic guide, and even an image quiz to test your knowledge. \n \nExplore a diverse collection of owl breeds, each accompanied by captivating images showcasing the unique characteristics of these incredible birds."
        largeTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 15)
        largeTextLabel.numberOfLines = 0
        largeTextLabel.textAlignment = .center
        largeTextLabel.textColor = UIColor(named: "LabelColor1")
        largeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        largeTextLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        contentView.addSubview(largeTextLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            gifContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            gifContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            gifContainerView.widthAnchor.constraint(equalToConstant: 280),
            gifContainerView.heightAnchor.constraint(equalToConstant: 280),

            gifImageView.topAnchor.constraint(equalTo: gifContainerView.topAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: gifContainerView.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: gifContainerView.trailingAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: gifContainerView.bottomAnchor),

            largeTextLabel.topAnchor.constraint(equalTo: gifContainerView.bottomAnchor, constant: 25),
            largeTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            largeTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            largeTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
        ])
    }
}
