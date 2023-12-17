import UIKit

class VibrationManager {
    static let shared = VibrationManager()

    private let vibrationKey = "VibrationSetting"

    var isVibrationEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isVibrationEnabled, forKey: vibrationKey)
            UserDefaults.standard.synchronize()
        }
    }

    private init() {
        self.isVibrationEnabled = UserDefaults.standard.bool(forKey: vibrationKey)
    }

    func getCurrentVibrationSetting() -> Bool {
        return isVibrationEnabled
    }


    func updateVibrationSetting(isEnabled: Bool) {
        isVibrationEnabled = isEnabled
    }

    func vibrateSuccess() {
        if isVibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    func vibrateError() {
        if isVibrationEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}
