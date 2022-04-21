//
//  ViewController.swift
//  Bankey
//
//  Created by Raeein Bagheri on 2022-04-08.
//

import UIKit

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    let signInButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    weak var delegate: LoginViewControllerDelegate?
    
    var username: String? {
        return loginView.userNameTextField.text
    }
    var password: String? {
        return loginView.passwordTextField.text
    }
    
    var leadingEdgeOnScreen: CGFloat = 16
    var leadingEdgeOffScreen: CGFloat = -1000
    
    var titleLeadingAnchor: NSLayoutConstraint?
    var descriptionLeadingAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    override func viewDidDisappear(_ animated: Bool) {
        signInButton.configuration?.showsActivityIndicator = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
}

extension LoginViewController {
    private func style() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.configuration = .filled()
        signInButton.configuration?.imagePadding = 8
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "Bankey"
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.alpha = 0
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Your premium source for all things banking!"
        descriptionLabel.font = .preferredFont(forTextStyle: .callout)
        descriptionLabel.alpha = 0
    }
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        //Title
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            titleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        titleLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        titleLeadingAnchor?.isActive = true
        //Description
        NSLayoutConstraint.activate([
            descriptionLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: descriptionLabel.bottomAnchor, multiplier: 2)
        ])
        descriptionLeadingAnchor =  descriptionLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor, constant: leadingEdgeOffScreen)
        descriptionLeadingAnchor?.isActive = true
        //Login View
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1),
        ])
        //Sign in Button
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        //Error label
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
    }
}
//MARK: - Actions
extension LoginViewController {
    @objc func signInTapped() {
        errorMessageLabel.isHidden = true
        login()
    }
    private func login() {
        guard let username = username, let password = password else {
            assertionFailure("Username / password should not be nil")
            return
        }
        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "Username / password cant be blank")
            return
        }
        if username == "Kevin" && password == "Welcome" {
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureView(withMessage: "Wrong credentials")
        }
    }
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
        shakeButton()
    }
    private func shakeButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4
        
        animation.isAdditive = true
        signInButton.layer.add(animation, forKey: "shake")
    }
}
//MARK: - Animation
extension LoginViewController {
    private func animate() {
        let duration = 0.8
        
        let titleAnimationPosition = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.titleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutSubviews()
        }
        let descriptionAnimationPosition = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.descriptionLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutSubviews()
        }
        let titleAnimationAlpha = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.titleLabel.alpha = 1
            self.view.layoutSubviews()
        }
        let descriptionAnimationAlpha = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            self.descriptionLabel.alpha = 1
            self.view.layoutSubviews()
        }
        
        titleAnimationPosition.startAnimation()
        descriptionAnimationPosition.startAnimation()
        titleAnimationAlpha.startAnimation(afterDelay: 0.2)
        descriptionAnimationAlpha.startAnimation(afterDelay: 0.2)
    }
}
