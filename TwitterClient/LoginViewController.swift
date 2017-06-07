//
//  ViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailLoginButton: UIButton!
    @IBOutlet private weak var twitterLoginButton: UIButton!
    
    private let viewModel: LoginViewModelIO = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Inputs
        
        let email = emailTextField.rx.text.orEmpty
        let password = passwordTextField.rx.text.orEmpty
        let emailAndPassword = Observable.combineLatest(email, password, resultSelector: { ($0, $1) })
        
        let loginEmail = emailLoginButton.rx.tap
            .withLatestFrom(emailAndPassword)
            .map { LoginProvider.email(email: $0, password: $1) }
        
        let loginTwitter = twitterLoginButton.rx.tap.mapTo(LoginProvider.twitter)
        
        // TODO: More login providers can be added here (e.g. facebook, google, etc.)
        
        Observable.merge([loginEmail, loginTwitter])
            .bind(to: viewModel.inputs.loginSubject)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        viewModel.outputs.successObservable.subscribe(onNext: { [unowned self] in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.errorsObservable.subscribe(onNext: { [unowned self] error in
            let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        
        // MARK: UI Events
        
        emailTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [unowned self] in
            self.passwordTextField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { [unowned self] in
            self.emailLoginButton.sendActions(for: .touchUpInside)
        }).disposed(by: disposeBag)
    }
}
