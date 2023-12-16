import UIKit
import FLAnimatedImage

class EncyclopediaViewController: UIViewController {

    private let scrollView = UIScrollView()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "Fon")
        super.viewDidLoad()
        setupScrollView()
    }

    func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(named: "Fon")
        view.addSubview(scrollView)

        let margin: CGFloat = 10

        // Title
        let titleLabel = UILabel(frame: CGRect(x: margin, y: margin, width: view.bounds.width - 2 * margin, height: 30))
        titleLabel.text = "Owls"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        scrollView.addSubview(titleLabel)

        // Image
        let owlImageView = UIImageView(frame: CGRect(x: margin, y: titleLabel.frame.maxY + margin, width: view.bounds.width - 2 * margin, height: 200))
        owlImageView.image = UIImage(named: "owlcute")
        owlImageView.layer.cornerRadius = 10
        owlImageView.clipsToBounds = true
        scrollView.addSubview(owlImageView)

        let largeText = """
            Owls comprise two closely related families in the avian order Strigiformes: the barn owls (Tytonidae) and the typical owls (Strigidae). Owls are relatively large birds, with a big head and short neck, a hooked beak, talons adapted to seizing prey, and soft, dense plumage adapted for swift yet almost silent flight. Owls have large eyes located on the front of their face but almost fixed in their socket, so that the entire head must be rotated or bobbed for the gaze to be shifted and for distance to be visually gauged.
            Owls have excellent hearing and extremely large ears, although these are covered by feathers and not readily seen. The ears are placed asymmetrically on the head to aid in detecting the location of distant, weakly noisy prey. The sense of hearing is probably also aided by the facial disk of many owls, which helps to focus sound waves onto the ears. The sense of hearing of owls is so acute that the nocturnally hunting species can accurately strike their prey in total darkness, following the squeaks and rustling noises created by a small mammal.
            The sex of an owl is not easy to distinguish, although typically females are larger than males. Owls begin to incubate their eggs as they are laid, which means that hatching is sequential and different-sized young are in the nest at the same time. During years in which prey is relatively abundant, all of the young will have enough to eat and may survive. In leaner years, however, only the largest young will be fed adequately.
            Most owls are nocturnal predators, feeding on small mammals and birds, but sometimes also on small reptiles, frogs, larger insects, and earthworms. A few specialized owls feed on fish. Owls are known to change their food preference, depending on local or seasonal availability of prey. Most owls do not digest the fur, feathers, or bones of their prey. They regurgitate these items as pellets, which can be collected at roosts and examined to learn about the feeding habits of the owl.
        """

        let largeTextLabel1 = UILabel()
        largeTextLabel1.numberOfLines = 0
        largeTextLabel1.lineBreakMode = .byWordWrapping
        largeTextLabel1.text = largeText
        largeTextLabel1.font = UIFont(name: "Avenir-Book", size: 18) // Set your preferred font size
        let largeTextLabel1Size = largeTextLabel1.sizeThatFits(CGSize(width: view.bounds.width - 2 * margin, height: CGFloat.greatestFiniteMagnitude))
        largeTextLabel1.frame = CGRect(x: margin, y: owlImageView.frame.maxY + margin, width: view.bounds.width - 2 * margin, height: largeTextLabel1Size.height)
        scrollView.addSubview(largeTextLabel1)

        // GIF with Corner Radius
        if let gifURL = Bundle.main.url(forResource: "owl1", withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL) {

            let gifImageView = FLAnimatedImageView(frame: CGRect(x: margin, y: largeTextLabel1.frame.maxY + margin * 2, width: view.bounds.width - 2 * margin, height: 200))
            gifImageView.animatedImage = FLAnimatedImage(animatedGIFData: gifData)
            gifImageView.layer.cornerRadius = 10
            gifImageView.clipsToBounds = true
            scrollView.addSubview(gifImageView)

            // Update content size after adding GIF
            scrollView.contentSize = CGSize(width: view.bounds.width, height: gifImageView.frame.maxY + margin * 2)


            // Large Text Again
            let additionalText = """
                There are about 180 species of typical owls. Most species are brownish colored with dark streaks and other patterns, which helps these birds blend into the environment when roosting in a tree or flying in dim light. Most typical owls have distinct facial disks. Many species have feathered “ear” tufts, which are important for determining another owl’s silhouette and are used in species recognition. Also important for recognition are the distinctive hoots and other calls of these birds. Most typical owls have a brilliant yellow iris, and they have excellent vision in dim light. These birds also have extraordinary hearing, which is important for detecting and capturing their prey.
                Typical owls occur worldwide, in almost all habitats where their usual prey of small mammals, birds, lizards, snakes, and larger insects and other invertebrates can be found. Most species occur in forest, but others breed in desert, tundra, prairie, or savanna habitat. These birds are solitary nesters, and because they are high-level predators they maintain relatively large territories, generally hundreds of hectares in area. Territories are established mostly using species-specific vocalizations, although more direct conflicts may sometimes occur. Northern species of owls are migratory, moving south as deepening snow makes it difficult for them to find and catch small mammals.
                Larger owls tend to eat bigger prey than do smaller owls. The eagle owl (Bubo bubo ) of northern Eurasia has a body up to 26 in (67 cm) long and weighs as much as 9 lb (4 kg) or more. It is a formidable predator that feeds on animals as large as ducks, hares, other birds of prey, foxes, and even small deer. In contrast, the tiny, 5 in (13 cm) elf owl (Micrathene whitneyi ) of the southwestern United States and western Mexico mostly eats insects and arachnids, including scorpions. Some species of owls are rather specialized feeders. The fish-owls of Africa and Asia, such as the tawny fish-owl (Ketupa flavipes ) of south China and Southeast Asia, mostly catch fish at or very near the water surface.
                There are 17 species of typical owls breeding in North America. The largest species is the great horned owl (Bubo virginianus ), with a body length of about 20 in (50 cm). This is a widespread and relatively common species that occurs almost everywhere but the northern tundra, feeding on prey as large as hare, skunks, and porcupines. The smallest species of owl in North America is the previously mentioned elf owl.
                The screech owl (Otus asio ) is a relatively familiar species in woodlands of temperate regions. This 8 in (20 cm) long species occurs in several color phases (gray, red, and brown), and it nests in cavities and sometimes in nest boxes.
                The snowy owl (Nyctea scandiaca ) breeds in the tundra of North America and Eurasia. However, this species wanders much farther to the south during winter, when the small mammals it eats are difficult to obtain in the Arctic. The snowy owl is a whitish-colored bird that nests on the ground, feeds during the day, and is relatively tame, often allowing people to approach rather closely.
                The burrowing owl (Speotyto cunicularia ) is a species that inhabits grasslands and prairies in southwestern North America, southern Florida, and parts of Central and South America. This species hunts during the day, often hovering distinctively while foraging. In the prairies, these owls typically roost and nest in the burrows of black-tailed prairie dogs (Cynomys ludovicianus ).
                The spotted owl (Strix occidentalis ) is a rare species of coastal, usually old-growth forests of southwestern North America and parts of Mexico. The northern subspecies (S. o. caurina ) is listed as “threatened” under the U.S. Endangered Species Act. Because the habitat of the spotted owl is being diminished by logging of the old-growth forests of Washington, Oregon, and California, plans have been developed for the longer-term protection of this bird. These plans require the protection of large tracts of old-growth, conifer-dominated forest to ensure that sufficient areas of suitable habitat are available to support a viable population of these owls.
            """

            let additionalTextLabel = UILabel()
            additionalTextLabel.numberOfLines = 0
            additionalTextLabel.lineBreakMode = .byWordWrapping
            additionalTextLabel.text = additionalText
            additionalTextLabel.font = UIFont(name: "Avenir-Book", size: 18)  // Set your preferred font size
            let additionalTextLabelSize = additionalTextLabel.sizeThatFits(CGSize(width: view.bounds.width - 2 * margin, height: CGFloat.greatestFiniteMagnitude))
            additionalTextLabel.frame = CGRect(x: margin, y: gifImageView.frame.maxY + margin * 2, width: view.bounds.width - 2 * margin, height: additionalTextLabelSize.height + 50)
            scrollView.addSubview(additionalTextLabel)
            scrollView.contentSize = CGSize(width: view.bounds.width, height: additionalTextLabel.frame.maxY + margin * 2 + 40)
        }

        // ... The rest of your code ...
    }
}
