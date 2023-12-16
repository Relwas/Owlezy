import UIKit


@available(iOS 13.0, *)
class BreedsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var breedNames: [String] {
        guard let breedsPath = Bundle.main.path(forResource: "Breeds", ofType: nil) else {
            return []
        }
        do {
            return try FileManager.default.contentsOfDirectory(atPath: breedsPath)
        } catch {
            return []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Fon")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 10

        // Set up the collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "Fon")
        collectionView.register(BreedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)

        // Set up constraints (assuming you are not using Auto Layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BreedCollectionViewCell
        cell.configure(with: breedNames[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 20
        let cellHeight = 350
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBreed = breedNames[indexPath.item]
        let breedDetailVC = BreedDetailViewController(breedName: selectedBreed)
        breedDetailVC.hidesBottomBarWhenPushed = true 
        navigationController?.pushViewController(breedDetailVC, animated: true)
    }
}
@available(iOS 13.0, *)
class BreedCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView()
    let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
            // Configure imageView
            imageView.backgroundColor = .systemBackground
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)

            // Configure nameLabel
            nameLabel.textAlignment = .center
            nameLabel.numberOfLines = 2
            nameLabel.font = UIFont(name: "PingFangHK-Medium", size: 22)
            contentView.addSubview(nameLabel)
        
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.layer.shadowColor = UIColor.gray.cgColor
            imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
            contentView.addSubview(imageView)

            // Set up constraints using Auto Layout
            imageView.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),

                nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20), // Adjust the constant value for more space
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    func configure(with breedName: String) {
        if let image = getFirstImageForBreed(breedName) {
            imageView.image = image
        }

        nameLabel.text = breedName
    }

    func getFirstImageForBreed(_ breedName: String) -> UIImage? {
        guard let breedPath = Bundle.main.path(forResource: "Breeds/\(breedName)", ofType: nil),
              let imageFileName = try? FileManager.default.contentsOfDirectory(atPath: breedPath).first,
              let imagePath = Bundle.main.path(forResource: "Breeds/\(breedName)/\(imageFileName)", ofType: nil) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
}

