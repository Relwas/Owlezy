import UIKit

class SmoothProgressBar: UIView {
    private let progressLayer = CALayer()
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProgressBar()
    }
    
    private func setupProgressBar() {
        progressLayer.backgroundColor = UIColor(named: "ColorProgress")?.cgColor
        layer.addSublayer(progressLayer)
        
        // Adjust the corner radius as needed
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        updateProgress()
    }
    
    private func updateProgress() {
        let targetWidth = bounds.width * progress
        let duration = 10.0  // Set your desired duration in seconds

        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.progressLayer.frame.size.width = targetWidth
        }, completion: nil)
    }
}
