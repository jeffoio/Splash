//
//  HomeViewController.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/01.
//

import UIKit

class HomeViewController: UIViewController {
    static let identifider: String = String(describing: HomeViewController.self)
    
    enum Section {
        case topics
        case photos
    }
    
    @IBOutlet private weak var topicCollectionView: UICollectionView!
    @IBOutlet private weak var photoCollectionView: UICollectionView!
    
    private var viewModel: HomeViewModel
    private var topicDataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    private var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoInformation>?

    init?(coder: NSCoder, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    @objc func topicButtonTapped(_ sender: UIButton) {
        guard let string = sender.currentTitle, let topic = Topic(rawValue: string.lowercased()) else { return }
        self.viewModel.update(topic)
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

extension HomeViewController: PhotoDelegate {
    func updateCurrent(_ indexPath: IndexPath) {
        self.photoCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showDetail(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemCount = self.photoDataSource?.snapshot().numberOfItems, indexPath.item >= itemCount-1 else { return }
        self.viewModel.fetch()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        PhotoLoader.shared.cancelOperation(indexPath)
    }
}

private extension HomeViewController {
    func configure() {
        self.registerNib()
        self.conifigureDelegates()
        self.configureTopicCollectionViewLayout()
        self.configurePhotoCollectionViewLayout()
        self.configureTopicDataSource()
        self.configurePhotoDataSource()
        self.bindViewModel()
    }
    
    func registerNib() {
        photoCollectionView.register(UINib(nibName: PhotoCell.identifider, bundle: nil), forCellWithReuseIdentifier: PhotoCell.identifider)
    }
    
    func conifigureDelegates() {
        self.photoCollectionView.delegate = self
    }
    
    func configureTopicCollectionViewLayout() {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        self.topicCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    func configurePhotoCollectionViewLayout() {
        self.photoCollectionView.collectionViewLayout = self.generateVertialLayout()
    }
    
    func generateVertialLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureTopicDataSource() {
        self.topicDataSource = UICollectionViewDiffableDataSource<Section, Topic>(collectionView: self.topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifider, for: indexPath) as? TopicCell else { return TopicCell() }
            cell.button.setTitle(topic.title, for: .normal)
            cell.button.addTarget(self, action: #selector(self.topicButtonTapped), for: .touchUpInside)
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
        snapShot.appendSections([.topics])
        snapShot.appendItems(Topic.allCases, toSection: .topics)
        self.topicDataSource?.apply(snapShot)
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
