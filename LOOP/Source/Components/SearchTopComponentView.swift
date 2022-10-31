//
//  SearchBarView.swift
//  LOOP
//
//  Created by Vijith TV on 25/10/22.
//

import UIKit

class SearchTopComponentView: UIView, ViewSetupProvidable {
    
    @Injected(\.contentsConfiguration)
    private var configuration: Contents.Configuration

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(configuration.movies.design.leftArrowWhiteIcon, for: .normal)
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var gradientView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var didBeignSearch: ((String) -> ())?
    var didEndSearch: (() -> ())?
    var didPressBack: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyStyles()
    }
    
    func setup() {
        
        addSubviews()
        applyConstraints()
    }
    
    func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(hStackView)
        addSubview(gradientView)
        
        hStackView.addArrangedSubview(backButton)
        hStackView.addArrangedSubview(searchTextField)
        hStackView.setCustomSpacing(DesignSystem.shared.sizers.lg, after: backButton)
    }
    
    func applyConstraints() {
        let constraints = [
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.lg),
            
            hStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DesignSystem.shared.sizers.md),
            hStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DesignSystem.shared.sizers.md),
            hStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            gradientView.topAnchor.constraint(equalTo: containerView.bottomAnchor,
                                              constant: DesignSystem.shared.sizers.xl * 1.6),
            gradientView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: DesignSystem.shared.sizers.xl * 2)
        ]
        addConstraints(constraints)
    }
    
    func applyStyles() {
        configuration.movies.design.style.searchBarViewStyle.apply(to: containerView)
        configuration.movies.design.style.searchTextFieldStyle.apply(to: searchTextField)
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        if searchText.isEmpty {
            didEndSearch?()
        } else {
            didBeignSearch?(searchText)
        }
    }
    
    @objc
    func backPressed() {
        didPressBack?()
    }
}
