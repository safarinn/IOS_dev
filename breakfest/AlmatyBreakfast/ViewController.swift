import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var eyebrowLabel: UILabel!
    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var compositionLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var randomButton: UIButton!
    @IBOutlet private weak var footerLabel: UILabel!

    private let favorites = Favorite.all
    private var roulette = FavoriteRoulette(count: Favorite.all.count)

    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.layer.cornerRadius = 20
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFit
        randomButton.layer.cornerRadius = 18
        randomButton.accessibilityIdentifier = "randomButton"
        titleLabel.accessibilityIdentifier = "restaurantTitle"
        showFavorite(at: roulette.currentIndex)
    }

    @IBAction private func randomize(_ sender: UIButton) {
        showFavorite(at: roulette.next())
        UISelectionFeedbackGenerator().selectionChanged()
    }

    private func showFavorite(at index: Int) {
        guard favorites.indices.contains(index) else { return }
        let favorite = favorites[index]
        photoView.image = UIImage(named: favorite.imageName)
        photoView.accessibilityLabel = "Фестивальный сет: \(favorite.title)"
        titleLabel.text = favorite.title
        descriptionLabel.text = favorite.description
        addressLabel.text = "Алматы · \(favorite.address)"
        priceLabel.text = favorite.price
        indexLabel.text = String(format: "СЕТ %02d / 10", index + 1)
        view.setNeedsLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Storyboard owns every view. Manual frames adapt its layout without constraints.
        let safe = view.safeAreaInsets
        scrollView.frame = CGRect(x: 0, y: safe.top, width: view.bounds.width,
                                  height: view.bounds.height - safe.top - safe.bottom)
        let width = scrollView.bounds.width
        let inset: CGFloat = 24
        let inner = width - inset * 2
        var y: CGFloat = 16
        y = place(eyebrowLabel, at: y, width: inner, gap: 8)
        y = place(headingLabel, at: y, width: inner, gap: 6)
        y = place(subtitleLabel, at: y, width: inner, gap: 20)
        let imageHeight = min(260, max(170, scrollView.bounds.height * 0.29))
        photoView.frame = CGRect(x: inset, y: y, width: inner, height: imageHeight)
        y += imageHeight + 16
        y = place(indexLabel, at: y, width: inner, gap: 8)
        y = place(titleLabel, at: y, width: inner, gap: 6)
        y = place(priceLabel, at: y, width: inner, gap: 16)
        y = place(compositionLabel, at: y, width: inner, gap: 8)
        y = place(descriptionLabel, at: y, width: inner, gap: 14)
        y = place(addressLabel, at: y, width: inner, gap: 20)
        randomButton.frame = CGRect(x: inset, y: y, width: inner, height: 56)
        y += 68
        y = place(footerLabel, at: y, width: inner, gap: 16)
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: y)
        scrollView.contentSize = contentView.bounds.size
    }

    private func place(_ label: UILabel, at y: CGFloat, width: CGFloat, gap: CGFloat) -> CGFloat {
        let size = label.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        let height = ceil(size.height)
        label.frame = CGRect(x: 24, y: y, width: width, height: height)
        return y + height + gap
    }

}
