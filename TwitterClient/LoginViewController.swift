//
//  ViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let viewModel: LoginViewModelIO = LoginViewModel(provider: MockLoginProvider())
    private let disposeBag = DisposeBag()
    
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
        
        viewModel.outputs.successObservable.subscribe(onNext: { [unowned self] in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.errorsObservable.subscribe(onNext: { [unowned self] error in
            let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
        }).disposed(by: disposeBag)
    }
}
