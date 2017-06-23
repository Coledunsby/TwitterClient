//
//  ViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxGesture
import RxKeyboard
import RxSwift

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModelIO = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Inputs
        
        emailTextField.rx.text
            .bind(to: viewModel.inputs.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.inputs.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.inputs.login)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        viewModel.outputs.isLoading
            .map { $0 ? 0.5 : 1.0 }
            .bind(to: stackView.rx.alpha)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.tweetsViewModel
            .bind { [unowned self] tweetsViewModel in
                [self.emailTextField, self.passwordTextField].forEach { $0.text = "" }
                
                let tweetsVC = UIStoryboard.tweets.instantiateInitialViewController(ofType: TweetsViewController.self)
                tweetsVC.viewModel = tweetsViewModel as TweetsViewModelIO
                self.navigationController?.pushViewController(tweetsVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.errors
            .bind { [unowned self] error in
                self.present(UIAlertController.error(error), animated: true)
            }
            .disposed(by: disposeBag)
        
        // MARK: UI Events
        
        view.rx
            .tapGesture(configuration: { $0.delegate = ExclusiveGestureRecognizerDelegate.shared })
            .when(.recognized)
            .mapTo(())
            .bind { [unowned self] in
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    self.logoHeightConstraint.constant = height == 0 ? 200 : 100
                    self.bottomConstraint.constant = height
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind { [unowned self] in
                self.passwordTextField.becomeFirstResponder()
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind { [unowned self] in
                self.loginButton.sendActions(for: .touchUpInside)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
