//
//  DiscoverViewController.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/05.
//

import UIKit

class DiscoverViewController: UIViewController {
    static let identifider: String = String(describing: DiscoverViewController.self)
    
    enum Section {
        case photos
    }
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    
    private var viewModel: DiscoverViewModel
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoInformation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    init?(coder: NSCoder, viewModel: DiscoverViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDetail(indexPath: IndexPath) {
        guard let detailViewController = self.storyboard?.instantiateViewController(identifier: DetailViewController.identifider, creator: { coder in
            return DetailViewController(coder: coder, photos: self.viewModel.photos.value, indexPath: indexPath)
        }) else {
            fatalError("Failed to load DetailViewController from storyboard.")
        }
        detailViewController.delegate = self
        self.present(detailViewController, animated: false, completion: nil)
    }
}

extension DiscoverViewController: PhotoDelegate {
    func updateCurrent(_ indexPath: IndexPath) {
        self.photoCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}

extension DiscoverViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.viewModel.update(query)
        self.searchBar.resignFirstResponder()
    }
}

extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showDetail(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemCount = self.photoDataSource?.snapshot().numberOfItems, indexPath.item >= itemCount-1 else { return }
        self.viewModel.query()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        PhotoLoader.shared.cancelOperation(indexPath)
    }
}

private extension DiscoverViewController {
    func configure() {
        self.registerNib()
        self.configureDelegates()
        self.configureSearchBar()
        self.configurePhotoCollectionViewLayout()
        self.configurePhotoDataSource()
        self.bindViewModel()
    }
    
    func registerNib() {
        self.photoCollectionView.register(UINib(nibName: PhotoCell.identifider, bundle: nil), forCellWithReuseIdentifier: PhotoCell.identifider)
    }
    
    func configureDelegates() {
        self.searchBar.delegate = self
        self.photoCollectionView.delegate = self
    }
    
    func configureSearchBar() {
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.searchTextField.textColor = UIColor(named: "splashWhite")
        self.searchBar.becomeFirstResponder()
    }
    
    func configurePhotoCollectionViewLayout() {
        self.photoCollectionView.collectionViewLayout = self.generateVertialLayout()
    }
    
    func generateVertialLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, PhotoInformation>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifider, for: indexPath) as? PhotoCell else { return PhotoCell() }
            cell.setImage(indexPath, photo: photo)
            return cell
        })
    }
    
    func bindViewModel() {
        self.viewModel.photos.observe(on: self) { [weak self] photos in
            var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoInformation>()
            snapshot.appendSections([Section.photos])
            snapshot.appendItems(photos)
            self?.photoDataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}
