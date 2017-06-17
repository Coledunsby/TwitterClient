//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxKeyboard
import RxSwift

final class ComposeViewController: UIViewController {
    
    var viewModel: ComposeViewModelIO = ComposeViewModel(provider: Config.tweetProvider)
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var tweetButton: UIButton!
    @IBOutlet private weak var dismissButton: UIBarButtonItem!
    @IBOutlet private weak var charactersRemainingLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Inputs
        
        textView.rx.text
            .bind(to: self.viewModel.inputs.text)
            .disposed(by: disposeBag)
        
        tweetButton.rx.tap
            .bind(to: self.viewModel.inputs.tweet)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .bind(to: self.viewModel.inputs.dismiss)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        viewModel.outputs.charactersRemaining
            .map(String.init)
            .bind(to: charactersRemainingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isValid
            .bind(to: tweetButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.outputs.shouldDismiss
            .bind { [unowned self] in self.dismiss(animated: true) }
            .disposed(by: disposeBag)
        
        // MARK: UI
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    self.toolbarBottomConstraint.constant = height
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        tweetButton.layer.cornerRadius = 2.0
        
        textView.text = ""
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.becomeFirstResponder()
    }
}
