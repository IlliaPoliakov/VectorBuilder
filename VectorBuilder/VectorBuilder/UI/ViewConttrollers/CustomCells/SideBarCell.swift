//
//  SideBarCollectionViewCell.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 29.11.22.
//

import UIKit

class SideBarCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      setupViewes()
      layoutViewes()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    
    // -MARK: - Properties -
    
    var vector: UIVector? {
      didSet {
        startPointLabel.text = SideBarCellData.startPonint
        endPointLabel.text = SideBarCellData.endPonint
        startXLabel.text = "x: \(Int(vector!.startPoint.x))"
        startYLabel.text = "y: \(Int(vector!.startPoint.y))"
        endXLabel.text = "x: \(Int(vector!.endPoint.x))"
        endYLabel.text = "y: \(Int(vector!.endPoint.y))"
        lengthLabel.text = "\(Int(vector!.startPoint.length(toPoint: vector!.endPoint)))"
      }
    }
    
    
    // -MARK: - Views -
    
    private var startPointLabel: UILabel!
  
    private var endPointLabel: UILabel!
    
    private var startXLabel: UILabel!
  
    private var endXLabel: UILabel!
    
    private var startYLabel: UILabel!
  
    private var endYLabel: UILabel!
  
    private var lengthStaticLabel: UILabel!
  
    private var lengthLabel: UILabel!
    
    
    // -MARK: - Funcs -
    
    private func setupViewes() {
      
      startPointLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
      
      endPointLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
      
      startXLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
    
      endXLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
      
      startYLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
    
      endYLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
    
      lengthLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
      
      lengthStaticLabel = UILabel().then { label in
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.mainColorClear
        label.text = "Length: "
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      }
    }
    
    private func layoutViewes() {
      [startPointLabel, endPointLabel, startXLabel].forEach { view in
        self.addSubview(view)
      }
      [ startYLabel, endXLabel, endYLabel, lengthLabel, lengthStaticLabel].forEach { view in
        self.addSubview(view)
      }
      
      startPointLabel.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(10)
        make.leading.trailing.equalToSuperview().inset(10)
      }
      
      startXLabel.snp.makeConstraints { make in
        make.top.equalTo(startPointLabel.snp.bottom).offset(5)
        make.leading.trailing.equalToSuperview().inset(5)
      }
      startYLabel.snp.makeConstraints { make in
        make.top.equalTo(startXLabel.snp.bottom).offset(5)
        make.leading.trailing.equalToSuperview().offset(5)
      }

      endPointLabel.snp.makeConstraints { make in
        make.top.equalTo(startYLabel.snp.bottom).offset(10)
        make.leading.trailing.equalToSuperview().inset(10)
      }
      
      endXLabel.snp.makeConstraints { make in
        make.top.equalTo(endPointLabel.snp.bottom).offset(5)
        make.leading.trailing.equalToSuperview().inset(5)
      }
      endYLabel.snp.makeConstraints { make in
        make.top.equalTo(endXLabel.snp.bottom).offset(5)
        make.leading.trailing.equalToSuperview().inset(5)
      }
      
      lengthStaticLabel.snp.makeConstraints { make in
        make.top.equalTo(endYLabel.snp.bottom).offset(15)
        make.leading.trailing.equalToSuperview().inset(15)
      }
      
      lengthLabel.snp.makeConstraints { make in
        make.top.equalTo(lengthStaticLabel.snp.bottom).offset(5)
        make.leading.trailing.equalToSuperview().inset(15)
        make.bottom.equalToSuperview().offset(-5)
      }
    }
  }

