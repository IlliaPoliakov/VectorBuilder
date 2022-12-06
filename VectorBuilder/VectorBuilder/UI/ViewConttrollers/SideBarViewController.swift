//
//  SideBarViewController.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 29.11.22.
//

import UIKit
import SnapKit
import Then


final class SideBarViewController: UIViewController {
  
  init(_ presenter: SideBarPresenterProtocol){
    self.presenter = presenter
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // -MARK: - LifeCycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    layoutViews()
  }
  
  
  // -MARK: - Dependencies -
  
  private(set) var presenter: SideBarPresenterProtocol
  
  
  // -MARK: - Views -
  
  private(set) var collectionView: UICollectionView!
  
  
  // -MARK: - Functions -
  
  func setupViews() {
    self.view.backgroundColor = .systemBackground
    
    collectionView = {
      let spacing: CGFloat = 10
      
      let layout = UICollectionViewCompositionalLayout {
        sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(10))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          subitems: [item])
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: 0, bottom: spacing, trailing: 0)
        section.interGroupSpacing = spacing
        
        return section
      }
      
      let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      
      collectionView.register(
        SideBarCell.self,
        forCellWithReuseIdentifier: "SideBarCell")
      
      return collectionView
    }()
    
    collectionView.dataSource = presenter.dataSource
    collectionView.delegate = presenter
  }
  
  func layoutViews() {
    self.view.addSubview(collectionView)
    
    collectionView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(15)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview().offset(-(self.view.frame.width * 2/3))
      make.bottom.equalToSuperview().offset(15)
    }
  }
}
