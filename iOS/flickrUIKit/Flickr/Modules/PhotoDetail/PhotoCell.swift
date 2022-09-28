import UIKit

final class PhotoCell: UITableViewCell {
    lazy var photoImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        return image
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    func setImage(_ image: UIImage) {
        photoImageView.image = image
    }

    private func setupUI() {
        if photoImageView.superview == nil {
            contentView.addSubview(photoImageView)
        }
        
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 100),
            photoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
