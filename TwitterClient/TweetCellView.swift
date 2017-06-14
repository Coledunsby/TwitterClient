//
//  TweetCellView.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

final class TweetCellView: UITableViewCell {
    
    let viewModel: TweetCellViewModelIO = TweetCellViewModel()
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userHandleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel.outputs.userImageObservable
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.userHandleObservable
            .bind(to: userHandleLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.dateObservable
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.messageObservable
            .bind(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
