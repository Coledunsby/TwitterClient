//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

final class ComposeViewController: UIViewController {
    
    var viewModel: ComposeViewModelIO!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var tweetButton: UIButton!
    @IBOutlet private weak var dismissButton: UIBarButtonItem!
    @IBOutlet private weak var charactersRemainingLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Inputs
        
        textView.rx.text
            .bind(to: self.viewModel.inputs.text)
            .disposed(by: disposeBag)
        
        tweetButton.rx.tap
            .bind(to: self.viewModel.inputs.tweetSubject)
            .disposed(by: disposeBag)
        
        dismissButton.rx.tap
            .bind(to: self.viewModel.inputs.dismissSubject)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        viewModel.outputs.charactersRemainingObservable
            .bind(to: charactersRemainingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.dismissObservable
            .bind { [unowned self] in self.dismiss(animated: true) }
            .disposed(by: disposeBag)
        
        // MARK: UI Events
        
    }
}
