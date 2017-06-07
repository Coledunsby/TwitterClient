//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxRealm
import RxSwift

final class TweetsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: TweetsViewModelIO = TweetsViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        let tweets = realm.objects(Tweet.self).sorted(byKeyPath: "date", ascending: false)
        
        Observable
            .array(from: tweets)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: TweetTableViewCell.self)) { row, tweet, cell in
                cell.label.text = tweet.message
            }
            .disposed(by: disposeBag)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if User.current == nil {
            navigationController?.performSegue(withIdentifier: "ShowLogin", sender: nil)
        }
    }
    
    @IBAction private func logout(sender: AnyObject) {
        
    }
    
    @IBAction private func postTweet(sender: AnyObject) {
        
    }
}
