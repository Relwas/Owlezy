import UIKit

@available(iOS 13.0, *)
class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
 
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false

        self.delegate = self
        
        
        setupTabs()

        tabBar.backgroundColor = UIColor(named: "Fon")
        self.tabBar.tintColor = .tabBarSelected
        self.tabBar.unselectedItemTintColor = .darkGray
        
        let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont(name: "TeluguSangamMN-Bold", size: 24.0) ?? UIFont.systemFont(ofSize: 18.0),
                    .foregroundColor: UIColor(named: "LabelColor1") ?? UIColor.black
                ]
        
                if let viewControllers = viewControllers {
                    for viewController in viewControllers {
                        if let navController = viewController as? UINavigationController {
                            navController.navigationBar.titleTextAttributes = attributes
                        }
                    }
                }
            }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
         if let index = tabBarController.viewControllers?.firstIndex(of: viewController),
             let tabBarItem = tabBar.items?[index].value(forKey: "view") as? UIView {
             tabBarItem.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)

             UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                 tabBarItem.transform = .identity
             }, completion: nil)
         }
         return true
     }
    
    private func setupTabs() {
        let breeds = BreedsViewController()
        let encyclo = EncyclopediaViewController()
        let quiz = StartQuizViewController()
        let settings = SettingsViewController()
        let favorites = FavoritesViewController()

        let mainNav = createNav(with: "Breeds", and: UIImage(systemName: "bird.fill"), vc: breeds)
        let enycloNav = createNav(with: "Encyclopedia", and: UIImage(systemName: "text.book.closed.fill"), vc: encyclo)
        let quizNav = createNav(with: "Quiz", and: UIImage(systemName: "questionmark.circle.fill"), vc: quiz)
        let settingNav = createNav(with: "Settings", and: UIImage(systemName: "gearshape.fill"), vc: settings)
        let favNav = createNav(with: "Favorites", and: UIImage(systemName: "heart.fill"), vc: favorites)


        self.setViewControllers([mainNav, enycloNav, quizNav, favNav, settingNav], animated: true)
    }

    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        vc.title = title
        return nav
    }
}



