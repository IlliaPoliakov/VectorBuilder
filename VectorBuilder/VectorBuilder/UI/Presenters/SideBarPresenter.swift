//
//  SideBarPresenter.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 29.11.22.
//

import UIKit

protocol SideBarPresenterProtocol: UICollectionViewDelegate {
  var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, UIVector> { get }
  var mainPresenter: MainPresenterProtocol? {get set}
  
  func assignViewController(_ viewController: UIViewController)
  
  func initialize()
  
  func vectorTupped(_ vector: UIVector)
}

final class SideBarPresenter: NSObject, SideBarPresenterProtocol {
  
  // -MARK: - Dependensies -
  
  private weak var viewController: SideBarViewController?
  
  var mainPresenter: MainPresenterProtocol?
  
  private let deleteVectorUseCase: DeleteVectorUseCase =
  AppDelegate.DIContainer.resolve(DeleteVectorUseCase.self)!
  
  
  // -MARK: - Properties -
  
  lazy var dataSource: UICollectionViewDiffableDataSource<CollectionViewSection, UIVector> =
  UICollectionViewDiffableDataSource(collectionView: viewController!.collectionView) {
    collectionView, indexPath, itemIdentifier in
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "SideBarCell", for: indexPath) as? SideBarCell
    else {
      return UICollectionViewCell()
    }
    
    cell.vector = self.mainPresenter?.vectors[indexPath.row]
    cell.backgroundColor = Colors.mainColorBackground
    cell.layer.cornerRadius = 10
    return cell
  }
  
  
  // -MARK: - Funcs -
  
  func initialize() {
    var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, UIVector>()
    snapshot.appendSections([.main])
    snapshot.appendItems(mainPresenter!.vectors, toSection: .main)
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func assignViewController(_ viewController: UIViewController) {
    self.viewController = (viewController as! SideBarViewController)
  }
  
  func assignViewController(_ mainPresenter: MainPresenterProtocol) {
    self.mainPresenter = mainPresenter
  }
  
  
  func vectorTupped(_ vector: UIVector) {
    mainPresenter?.moveScrollViewToPoint(vector.endPoint.centerPoint(withPoint: vector.startPoint))
    mainPresenter?.highlightVector(vector)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vector = mainPresenter!.vectors[indexPath.row]
    
    var point = vector.endPoint
    point.x += self.viewController!.view.frame.width / 6
    mainPresenter?.moveScrollViewToPoint(point)
    vector.highlight()
  }
}


extension SideBarViewController: UIContextMenuInteractionDelegate {
  func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                              configurationForMenuAtLocation location: CGPoint)
  -> UIContextMenuConfiguration? {
    
    return UIContextMenuConfiguration(
      identifier: nil,
      previewProvider: nil,
      actionProvider: { _ in
        let deleteAction = self.deleteAction()
        let children: [UIMenuElement] = [deleteAction]
        return UIMenu(title: "", children: children)
      })
  }
  
  func deleteAction() -> UIAction {
    let allAttributes = UIMenuElement.Attributes()
    let trashImage = UIImage(systemName: "trash")!
      .withTintColor(Colors.mainColorClear, renderingMode: .alwaysOriginal)
    
    return UIAction(
      title: "Delete",
      image: trashImage,
      identifier: nil,
      attributes: allAttributes) { _ in
        presenter.
      }
  }
}
