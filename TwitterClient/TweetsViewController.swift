//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

final class TweetsViewController: UIViewController {

    private static let provider = TweetProvider.realm
    
    private let viewModel: TweetsViewModelIO = TweetsViewModel(provider: provider)
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var logoutButton: UIBarButtonItem!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // MARK: Inputs
        
        logoutButton.rx.tap
            .bind(to: viewModel.inputs.logout)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<Section<Tweet>>()
        dataSource.configureCell = { dataSource, tableView, indexPath, tweet in
            let tweetCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetCell
            tweetCell.viewModel.inputs.tweet.value = tweet
            return tweetCell
        }
        
        viewModel.outputs.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.loggedOut
            .bind { [unowned self] in self.showLogin() }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind {
//                User.current?.tweet(message: "testing 1 2 3 4")
            }
            .disposed(by: disposeBag)
        
        // MARK: UI
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.user.value = User.current
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if User.current == nil {
            showLogin()
        }
    }
    
    // MARK: - Private Functions
    
    private func showLogin() {
        navigationController?.performSegue(withIdentifier: "ShowLogin", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let composeVC = segue.destination as? ComposeViewController else { return }
        composeVC.viewModel = ComposeViewModel(provider: TweetsViewController.provider)
    }
}
