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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topicCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var photoCollectionViewTopConstraint: NSLayoutConstraint!
    
    var viewModel: HomeViewModel!
    var topicDataSource: UICollectionViewDiffableDataSource<Section, Topic>?
    var photoDataSource: UICollectionViewDiffableDataSource<Section, PhotoInformation>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.inject()
        self.configure()
        viewModel.fetch()
    }
    
    func inject() {
        let service = TransferService(networkService: NetworkService())
        let repo = PhotoInformationRepository(service: service)
        let usecase = PhotoInformationUsecase(repository: repo)
        self.viewModel = HomeViewModel(usecase: usecase)
    }
    
    @objc func topicButtonTapped(_ sender: UIButton) {
        guard let string = sender.currentTitle,
              let topic = Topic(rawValue: string) else { return }
        self.viewModel.update(topic)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.photoCollectionView.setCollectionViewLayout(self.generateVertialLayout(), animated: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updatePhotoCollectionViewConstraint(false)
                self?.backButton.isHidden = true
                self?.titleLabel.text = "Splash"
            }
        }
    }
    
    func updatePhotoCollectionViewConstraint(_ isWider: Bool) {
        let constanst = isWider ? 23.0 : 76.0
        self.topicCollectionView.isHidden = isWider
        self.photoCollectionViewTopConstraint.constant = constanst
        self.photoCollectionView.setNeedsLayout()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = self.photoDataSource?.itemIdentifier(for: indexPath) else { return }
        self.updatePhotoCollectionViewConstraint(true)
        self.photoCollectionView.setCollectionViewLayout(self.generateHorizontalLayout(), animated: false)
        self.backButton.isHidden = false
        self.titleLabel.text = photo.user.name
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemCount = self.photoDataSource?.snapshot().numberOfItems, indexPath.item >= itemCount-1 else { return }
        self.viewModel.fetch()
    }
}

private extension HomeViewController {
    func configure() {
        self.photoCollectionView.delegate = self
        self.configureTopicCollectionViewLayout()
        self.configurePhotoCollectionViewLayout()
        self.configureTopicDataSource()
        self.configurePhotoDataSource()
        self.bindViewModel()
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
        section.interGroupSpacing = 15
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func generateHorizontalLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.interGroupSpacing = 15
        return UICollectionViewCompositionalLayout(section: section)
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
        self.photoDataSource = UICollectionViewDiffableDataSource<Section, PhotoInformation>(collectionView: self.photoCollectionView, cellProvider: { collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquarePhotoCell.identifider, for: indexPath) as? SquarePhotoCell
            let data = try! Data(contentsOf: URL(string: photo.urls.small)!)
            cell?.imageView.image = UIImage(data: data)
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
