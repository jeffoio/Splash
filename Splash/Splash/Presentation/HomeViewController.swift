//
//  HomeViewController.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/01.
//

import UIKit

class HomeViewController: UIViewController {
    enum Section {
        case topics
        case photos
    }
    
    @IBOutlet weak var topicCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var viewModel = HomeViewModel()
    var topicDataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    var photoDataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        viewModel.fetch(topic: .wallpapers)
    }
    
    @objc func topicButtonTapped(_ sender: UIButton) {
        guard let string = sender.currentTitle,
              let topic = Topic(rawValue: string) else { return }
        self.viewModel.update(topic)
    }
}

private extension HomeViewController {
    func configure() {
        self.configureTopicCollectionViewLayout()
        self.configurePhotoCollectionViewLayout()
        self.configureTopicDataSource()
        self.configurePhotoDataSource()
        self.bindViewModel()
    }
    
    func configureTopicCollectionViewLayout() {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1)),
                                                       subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        self.topicCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    func configurePhotoCollectionViewLayout() {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        self.photoCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureTopicDataSource() {
        self.topicDataSource = UICollectionViewDiffableDataSource<Section, Topic>(collectionView: self.topicCollectionView, cellProvider: { collectionView, indexPath, topic in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCell.identifider, for: indexPath) as? TopicCell
            cell?.button.setTitle(topic.string, for: .normal)
            cell?.button.addTarget(self, action: #selector(self.topicButtonTapped), for: .touchUpInside)
            return cell
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Topic>()
        snapShot.appendSections([.topics])
        snapShot.appendItems(Topic.allCases, toSection: .topics)
        self.topicDataSource?.apply(snapShot)
    }
    
    func configurePhotoDataSource() {
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquarePhotoCell.identifider, for: indexPath) as? SquarePhotoCell
            let data = try! Data(contentsOf: URL(string: photo.urls.small)!)
            cell?.imageView.image = UIImage(data: data)
            return cell
        })
    }
    
    func bindViewModel() {
        self.viewModel.photos.observe(on: self) { [weak self] photos in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Photo>()
            snapshot.appendSections([Section.photos])
            snapshot.appendItems(photos)
            self?.photoDataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}
