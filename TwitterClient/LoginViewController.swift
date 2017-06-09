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
import RxSwiftExt

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Inputs
        
        emailTextField.rx.text
            .bind(to: viewModel.inputs.emailVar)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.inputs.passwordVar)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.inputs.loginSubject)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        viewModel.outputs.isLoadingObservable
            .bind { [unowned self] isLoading in
                self.stackView.alpha = isLoading ? 0.5 : 1.0
                if isLoading {
                    self.activityIndicatorView.startAnimating()
                } else {
                    self.activityIndicatorView.stopAnimating()
                }
                
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.successObservable
            .bind { [unowned self] in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.errorsObservable
            .bind { [unowned self] error in
                let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true)
            }
            .disposed(by: disposeBag)
        
        // MARK: UI Events
        
        view.rx
            .tapGesture(configuration: { $0.delegate = ExclusiveGestureRecognizerDelegate.shared })
            .when(.recognized)
            .bind { [unowned self] _ in
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
}
