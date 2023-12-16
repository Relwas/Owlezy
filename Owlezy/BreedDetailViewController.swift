import UIKit

@available(iOS 13.0, *)
class BreedDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BreedDetailImageCellDelegate {

    let breedName: String
    var collectionView: UICollectionView!
    var breedImages: [UIImage] = []

    init(breedName: String) {
        self.breedName = breedName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")
        title = breedName

        // Set up the collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10

        // Set up the collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BreedDetailImageCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)

        // Fetch images for the selected breed
        breedImages = getImagesForBreed(breedName)

        // Set up constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! BreedDetailImageCell
        cell.imageView.image = breedImages[indexPath.item]
        cell.delegate = self // Add this line to set the delegate
        return cell
    }


    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 255)
    }

    // Fetch images for the selected breed
    func getImagesForBreed(_ breedName: String) -> [UIImage] {
        var images: [UIImage] = []

        guard let breedPath = Bundle.main.path(forResource: "Breeds/\(breedName)", ofType: nil),
              let imageFileNames = try? FileManager.default.contentsOfDirectory(atPath: breedPath) else {
            print("Error: Could not find images for breed \(breedName)")
            return images
        }

        for imageName in imageFileNames {
            if let imagePath = Bundle.main.path(forResource: "Breeds/\(breedName)/\(imageName)", ofType: nil),
               let image = UIImage(contentsOfFile: imagePath) {
                images.append(image)
            } else {
                print("Error: Could not load image \(imageName) for breed \(breedName)")
            }
        }

        return images
    }
    
    func handleImageTap(_ cell: BreedDetailImageCell) {
        guard let tappedIndexPath = collectionView.indexPath(for: cell) else {
            return
        }

        let fullImageBreedVC = FullImageBreedViewController()
        fullImageBreedVC.fullImage = breedImages[tappedIndexPath.item]

        navigationController?.pushViewController(fullImageBreedVC, animated: true)
    }



}

class BreedDetailImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    let shadowView = UIView()
    let heartButton = UIButton(type: .custom)
    var isFavorite = false
    weak var delegate: BreedDetailImageCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        shadowView.clipsToBounds = false
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 0.2 
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true

        contentView.addSubview(shadowView)
        shadowView.addSubview(imageView)

        shadowView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 3),
            imageView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -3),
            imageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }

    @objc private func handleImageTap() {
        delegate?.handleImageTap(self)
    }
}

protocol BreedDetailImageCellDelegate: AnyObject {
    func handleImageTap(_ cell: BreedDetailImageCell)
}
