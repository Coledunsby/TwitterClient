//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

final class TweetCell: UITableViewCell {
    
    let viewModel: TweetCellViewModelIO = TweetCellViewModel()
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userHandleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 2.0
        
        viewModel.outputs.userImage
            .drive(userImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.outputs.userHandle
            .drive(userHandleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.date
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.message
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
