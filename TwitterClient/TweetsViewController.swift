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
        
        self.logoutButton.rx.tap
            .bind(to: viewModel.inputs.logoutSubject)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "Cell", cellType: TweetCellView.self) { cell, _, tweet in
            cell.viewModel.inputs.tweet.value = tweet
        }
        
        self.viewModel.outputs.tweetsObservable
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.loggedOutObservable
            .bind { [unowned self] in self.showLogin() }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind {
//                User.current?.tweet(message: "testing 1 2 3 4")
            }
            .disposed(by: disposeBag)
        
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
