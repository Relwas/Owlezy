import UIKit

@available(iOS 13.0, *)
class SettingsViewController: UIViewController {
 

    private let vibrationSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private let soundSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = UserDefaults.standard.bool(forKey: "SoundSetting")
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Fon")

        configureUI()
        UserDefaults.standard.register(defaults: ["SoundSetting": true])
        if UserDefaults.standard.object(forKey: "VibrationSetting") == nil {
            vibrationSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: "VibrationSetting")
        } else {
            vibrationSwitch.isOn = UserDefaults.standard.bool(forKey: "VibrationSetting")
        }
        
        if UserDefaults.standard.object(forKey: "SoundSetting") == nil {
            soundSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: "SoundSetting")
        } else {
            soundSwitch.isOn = UserDefaults.standard.bool(forKey: "SoundSetting")
        }
    }

    private func configureUI() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Vibration row with switch
        let vibrationRow = createRow(labelText: "Vibration", switchControl: vibrationSwitch, switchAction: #selector(vibrationSwitchValueChanged(_:)))
        vibrationRow.backgroundColor = UIColor.gray
        stackView.addArrangedSubview(vibrationRow)
        
        // Sound row
        let soundRow = createRow(labelText: "Sound", switchControl: soundSwitch, switchAction: #selector(soundSwitchValueChanged(_:)))
        soundRow.backgroundColor = UIColor.gray
        stackView.addArrangedSubview(soundRow)
        
        // About app button
        let aboutAppRow = createRow(buttonTitle: "About app", buttonAction: #selector(aboutAppButtonTapped))
        stackView.addArrangedSubview(aboutAppRow)
        
        // Share button
        let shareRow = createRow(buttonTitle: "Share", buttonAction: #selector(shareButtonTapped))
        stackView.addArrangedSubview(shareRow)
        
        // Rate button
        let rateRow = createRow(buttonTitle: "Rate", buttonAction: #selector(rateButtonTapped))
        stackView.addArrangedSubview(rateRow)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        if UserDefaults.standard.value(forKey: "isVibrationOn") == nil {
            vibrationSwitch.isOn = true
            // Save the default state to UserDefaults
            UserDefaults.standard.set(vibrationSwitch.isOn, forKey: "isVibrationOn")
        }
        
        if UserDefaults.standard.value(forKey: "isSoundOn") == nil {
            soundSwitch.isOn = true
            // Save the default state to UserDefaults
            UserDefaults.standard.set(soundSwitch.isOn, forKey: "isSoundOn")
        }
        
    }
    
    private func createRow(labelText: String? = nil, switchControl: UISwitch? = nil, switchAction: Selector? = nil, buttonTitle: String? = nil, buttonAction: Selector? = nil) -> UIView {
        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false
        rowView.backgroundColor = .gray
        rowView.layer.cornerRadius = 20  // Add corner radius to the row

        if let labelText = labelText {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white // Set text color to white
            rowView.addSubview(label)

            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 20),
                label.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            ])
        }

        if let switchControl = switchControl {
            switchControl.addTarget(self, action: switchAction ?? #selector(defaultSwitchValueChanged(_:)), for: .valueChanged)
            switchControl.translatesAutoresizingMaskIntoConstraints = false
            switchControl.backgroundColor = UIColor.black
            switchControl.onTintColor = .tabBarSelected
            switchControl.layer.cornerRadius = 15

            rowView.addSubview(switchControl)

            NSLayoutConstraint.activate([
                switchControl.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -20),
                switchControl.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            ])
        } else if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: buttonAction, for: .touchUpInside)
            button.backgroundColor = .gray
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
            button.setTitleColor(.white, for: .normal) // Set button text color to white
            button.translatesAutoresizingMaskIntoConstraints = false
            rowView.addSubview(button)

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 20),
                button.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -20),
                button.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            ])
        }

        let heightConstraint = rowView.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = UILayoutPriority(999)
        heightConstraint.isActive = true

        return rowView
    }

    @objc private func defaultSwitchValueChanged(_ sender: UISwitch) {
        // Handle the default switch value change (if needed)
    }

    @objc private func vibrationSwitchValueChanged(_ sender: UISwitch) {
        let isVibrationEnabled = sender.isOn
        print("Vibration setting changed: \(isVibrationEnabled)")
        VibrationManager.shared.isVibrationEnabled = isVibrationEnabled
        if isVibrationEnabled {
            UserDefaults.standard.set(true, forKey: "VibrationSetting")
        }
    }

    @objc private func soundSwitchValueChanged(_ sender: UISwitch) {
        let isSoundEnabled = sender.isOn
        print("Sound setting changed: \(isSoundEnabled)")
        UserDefaults.standard.set(isSoundEnabled, forKey: "SoundSetting")
        NotificationCenter.default.post(name: Notification.Name("SoundSettingChanged"), object: nil)
    }


    @objc private func aboutAppButtonTapped() {
        let vc = AboutAppViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }

    //TODO: Share & Rate 
    @objc private func shareButtonTapped() {
        let shareMessage = "Check out the Owl App! 🦉📱 Discover the fascinating world of owls and test your knowledge with the owl image quiz. Download now!"
        let activityViewController = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }

    @objc private func rateButtonTapped() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/YourAppID") {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }

}
