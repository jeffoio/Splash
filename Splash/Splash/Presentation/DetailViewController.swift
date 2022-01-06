//
//  DetailViewController.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/06.
//

import UIKit

protocol PhotoDelegate {
    func updateCurrent(_ indexPath: IndexPath)
}

class DetailViewController: UIViewController {
    static let identifider: String = String(describing: DetailViewController.self)
    
    enum Section {
        case photos
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoInformation>?
    private var photos: [PhotoInformation]
    private var currentIndexPath: IndexPath
    private var isStatusBarHidden: Bool = false
    private var needsDelayedScrolling = true
    
    var delegate: PhotoDelegate?
    override var prefersStatusBarHidden: Bool { return self.isStatusBarHidden }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .fade }

    init?(coder: NSCoder, photos: [PhotoInformation], indexPath: IndexPath) {
        self.photos = photos
        self.currentIndexPath = indexPath
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard needsDelayedScrolling else { return }
        self.needsDelayedScrolling = false
        self.photoCollectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let indexPath = self.photoCollectionView.indexPathsForVisibleItems[0]
        self.delegate?.updateCurrent(indexPath)
        self.dismiss(animated: false, completion: nil)
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photo = self.photoDataSource?.itemIdentifier(for: indexPath) else { return }
        self.titleLabel.text = photo.user.name
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isStatusBarHidden.toggle()
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
            self.backButton.isHidden.toggle()
            self.titleLabel.isHidden.toggle()
        }
    }
}

private extension DetailViewController {
    func configure() {
        self.registerNib()
        self.configurePhotoCollectionViewLayout()
        self.configurePhotoDataSource()
        self.photoCollectionView.delegate = self
    }
    
    func registerNib() {
        self.photoCollectionView.register(UINib(nibName: LargePhotoCell.identifider, bundle: nil), forCellWithReuseIdentifier: LargePhotoCell.identifider)
    }
    
    func configurePhotoCollectionViewLayout() {
        self.photoCollectionView.collectionViewLayout = self.generateHorizontalLayout()
    }
    
    func generateHorizontalLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 15
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, PhotoInformation>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargePhotoCell.identifider, for: indexPath) as? LargePhotoCell else { return LargePhotoCell() }
            cell.setImage(photo)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoInformation>()
        snapshot.appendSections([Section.photos])
        snapshot.appendItems(self.photos)
        self.photoDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
