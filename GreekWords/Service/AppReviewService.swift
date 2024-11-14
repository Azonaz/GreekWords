import UIKit
import StoreKit

final class AppReviewService {
    static let shared = AppReviewService()

    func checkAndRequestReview() {
        let userDefaults = UserDefaults.standard
        let currentDate = Date()

        if userDefaults.object(forKey: "askReviewAfter") == nil {
            userDefaults.set(Calendar.current.date(byAdding: .day, value: 1, to: currentDate),
                             forKey: "askReviewAfter")
        }

        if let askReviewAfter = userDefaults.object(forKey: "askReviewAfter") as? Date,
           currentDate >= askReviewAfter {
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                SKStoreReviewController.requestReview(in: windowScene)
                if let nextReviewRequestDate = Calendar.current.date(byAdding: .month, value: 5, to: currentDate) {
                    userDefaults.set(nextReviewRequestDate, forKey: "askReviewAfter")
                    print("Review requested, next request will be after: \(nextReviewRequestDate)")
                }
            }
        }
    }
}
