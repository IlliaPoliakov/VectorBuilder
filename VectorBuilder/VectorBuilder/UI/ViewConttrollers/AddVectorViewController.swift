//
//  AddViewController.swift
//  VectorBuilder
//
//  Created by Illia Poliakov on 27.11.22.
//

import UIKit
import SnapKit
import SpriteKit
import Then

final class AddVectorViewController: UIViewController {
  
  init(_ presenter: AddVectorPresenterProtocol){
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
  
  private(set) var presenter: AddVectorPresenterProtocol
  
  
  // -MARK: - Views -
  
  private var createVectorLabel: UILabel!
  
  private var startPointLabel: UILabel!
  
  private var startXLabel: UILabel!
  private var startXTextField: UITextField!
  
  private var startYLabel: UILabel!
  private var startYTextField: UITextField!
  
  
  private var endPointLabel: UILabel!
  
  private var endXLabel: UILabel!
  private var endXTextField: UITextField!
  
  private var endYLabel: UILabel!
  private var endYTextField: UITextField!
  
  
  private var setLengthLabel: UILabel!
  private var lengthTextField: UITextField!
  
  private var addVectorButton: UIButton!

  
  // -MARK: - Funcs -
  
  private func setupViews() {
    self.view.backgroundColor = .systemBackground
    
    createVectorLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Create New Vector:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .largeTitle)
      label.textAlignment = .center
      label.numberOfLines = 0
    }
    
    startPointLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Start Point:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .title1)
      label.textAlignment = .center
      label.numberOfLines = 0
    }
    
    startXLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "x:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .title3)
      label.textAlignment = .center
      label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    startXTextField = UITextField().then { textField in
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.backgroundColor = Colors.mainColorBackground
      textField.layer.cornerRadius = ButtonData.cornerRadius
      textField.font = .preferredFont(forTextStyle: .title3)
      textField.textAlignment = .center
      textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    startYLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "y:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .title3)
      label.textAlignment = .center
      label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    startYTextField = UITextField().then { textField in
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.backgroundColor = Colors.mainColorBackground
      textField.layer.cornerRadius = ButtonData.cornerRadius
      textField.font = .preferredFont(forTextStyle: .title3)
      textField.textAlignment = .center
      textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    endPointLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "End Point:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .title1)
      label.textAlignment = .center
      label.numberOfLines = 0
      label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    endXLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "x:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .title3)
      label.textAlignment = .center
      label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    endXTextField = UITextField().then { textField in
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.backgroundColor = Colors.mainColorBackground
      textField.layer.cornerRadius = ButtonData.cornerRadius
      textField.font = .preferredFont(forTextStyle: .title3)
      textField.textAlignment = .center
      textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    endYLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "y:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .title3)
      label.textAlignment = .center
      label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    endYTextField = UITextField().then { textField in
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.backgroundColor = Colors.mainColorBackground
      textField.layer.cornerRadius = ButtonData.cornerRadius
      textField.font = .preferredFont(forTextStyle: .title3)
      textField.textAlignment = .center
      textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    
    setLengthLabel = UILabel().then { label in
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Or Just Set The Length of The Vector and Positoin it Manually:"
      label.textColor = Colors.mainColorClear
      label.font = .preferredFont(forTextStyle: .largeTitle)
      label.textAlignment = .center
      label.numberOfLines = 0
    }
    lengthTextField = UITextField().then { textField in
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.backgroundColor = Colors.mainColorBackground
      textField.layer.cornerRadius = ButtonData.cornerRadius
      textField.font = .preferredFont(forTextStyle: .title3)
      textField.textAlignment = .center
    }
    
    
    addVectorButton = UIButton().then { button in
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle("Add Vector", for: .normal)
      button.setTitleColor(Colors.mainColorClear, for: .normal)
      button.setTitleColor(ButtonData.backgroundColor, for: .highlighted)
      button.tintColor = Colors.mainColorClear
      button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
      button.backgroundColor = Colors.mainColorBackground
      button.layer.cornerRadius = ButtonData.cornerRadius
      button.layer.borderWidth = ButtonData.borderWidth
      button.layer.borderColor = ButtonData.borderColor.cgColor
      
      button.addAction(
        UIAction(handler: { _ in
          self.presenter.addVectorButtonTupped(
            withStartPointX: self.startXTextField.text,
            withStartPointY: self.startYTextField.text,
            withEndPointX: self.endXTextField.text,
            withEndPointY: self.endYTextField.text,
            withLength: self.lengthTextField.text) }),
        for: .touchUpInside)
    }
  }
  
  private func layoutViews() {
    [createVectorLabel, startPointLabel, startXLabel,
     startXTextField, startYLabel, startYTextField,
     endPointLabel, endXLabel, endXTextField,
     endYLabel, endYTextField, setLengthLabel,
     lengthTextField, addVectorButton].forEach { view in
      self.view.addSubview(view)
    }
    
    //grandad
    createVectorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.trailing.equalToSuperview().inset(15)
    }
    
    //son-dad 1
    startPointLabel.snp.makeConstraints { make in
      make.top.equalTo(createVectorLabel.snp.bottom).offset(20)
      make.leading.equalToSuperview().offset(15)
      make.trailing.equalTo(self.view.snp.centerX).offset(-5)
    }
    //son/daughter 1.1
    startXLabel.snp.makeConstraints { make in
      make.top.equalTo(startPointLabel.snp.bottom).offset(20)
    }
    startXTextField.snp.makeConstraints { make in
      make.centerY.equalTo(startXLabel.snp.centerY)
      make.centerX.equalTo(startPointLabel.snp.centerX)
      make.leading.equalTo(startXLabel.snp.trailing).offset(5)
      make.width.equalTo(44)
      make.height.equalTo(38)
    }
    //son/daughter 1.2
    startYLabel.snp.makeConstraints { make in
      make.top.equalTo(startXLabel.snp.bottom).offset(15)
    }
    startYTextField.snp.makeConstraints { make in
      make.centerY.equalTo(startYLabel.snp.centerY)
      make.centerX.equalTo(startPointLabel.snp.centerX)
      make.leading.equalTo(startYLabel.snp.trailing).offset(5)
      make.width.equalTo(44)
      make.height.equalTo(38)
    }
    
    //son-dad 2
    endPointLabel.snp.makeConstraints { make in
      make.top.equalTo(createVectorLabel.snp.bottom).offset(20)
      make.leading.equalTo(self.view.snp.centerX).offset(5)
      make.trailing.equalToSuperview().offset(-15)
    }
    //son/daughter 2.1
    endXLabel.snp.makeConstraints { make in
      make.top.equalTo(endPointLabel.snp.bottom).offset(20)
    }
    endXTextField.snp.makeConstraints { make in
      make.centerY.equalTo(endXLabel.snp.centerY)
      make.centerX.equalTo(endPointLabel.snp.centerX)
      make.leading.equalTo(endXLabel.snp.trailing).offset(5)
      make.width.equalTo(44)
      make.height.equalTo(38)
    }
    //son/daughter 2.2
    endYLabel.snp.makeConstraints { make in
      make.top.equalTo(endXLabel.snp.bottom).offset(15)
    }
    endYTextField.snp.makeConstraints { make in
      make.centerY.equalTo(endYLabel.snp.centerY)
      make.centerX.equalTo(endPointLabel.snp.centerX)
      make.leading.equalTo(endYLabel.snp.trailing).offset(5)
      make.width.equalTo(44)
      make.height.equalTo(38)
    }
    
    
    setLengthLabel.snp.makeConstraints { make in
      make.top.equalTo(endYTextField.snp.bottom).offset(30)
      make.leading.trailing.equalToSuperview().inset(15)
    }
    
    lengthTextField.snp.makeConstraints { make in
      make.top.equalTo(setLengthLabel.snp.bottom).offset(10)
      make.leading.trailing.equalToSuperview().inset(15)
      make.height.equalTo(44)
    }
    
    
    addVectorButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(15)
      make.bottom.equalToSuperview().offset(-20)
    }
  }
  
  
  func erraseAllTextFields() {
    startXTextField.text = ""
    endXTextField.text = ""
    startYTextField.text = ""
    endYTextField.text = ""
    lengthTextField.text = ""
  }
}
