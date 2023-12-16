import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var favoriteImages: [UIImage] {
        return UserDefaultsManager.shared.getFavoriteImages()
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 24
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "Fon")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - UICollectionViewDataSource
  
    func addImageToFavorites(_ image: UIImage) {
        UserDefaultsManager.shared.saveImageToFavorites(image)
        collectionView.reloadData()
    }

    func removeImageFromFavorites(_ image: UIImage) {
        guard let imageData = image.pngData() else {
            return
        }

        var favoritePaths = UserDefaultsManager.shared.getFavoritePaths()
        if let index = favoritePaths.firstIndex(where: { path in
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                  let pathImage = UIImage(data: data)
            else {
                return false
            }
            return pathImage.pngData() == imageData
        }) {
            do {
                try FileManager.default.removeItem(atPath: favoritePaths[index])
                favoritePaths.remove(at: index)
                UserDefaultsManager.shared.saveFavoritePaths(favoritePaths)
            } catch {
                print("Error removing image from file: \(error.localizedDescription)")
            }
        }

        updateCollectionView()
    }

    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set the size for each item
        let cellWidth = (collectionView.frame.width - 30) / 2 // Adjust spacing as needed
        return CGSize(width: cellWidth, height: 130)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return UserDefaultsManager.shared.getFavoriteImages().count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.image = UserDefaultsManager.shared.getFavoriteImages()[indexPath.item]

            cell.contentView.addSubview(imageView)

            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = favoriteImages[indexPath.item]

        let fullImageViewController = FullImageBreedViewController()
        
        fullImageViewController.fullImage = selectedImage
        
        fullImageViewController.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(fullImageViewController, animated: true)
    }


}
