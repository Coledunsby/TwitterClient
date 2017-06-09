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
import RxRealmDataSources
import RxSwift

final class TweetsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var logoutButton: UIBarButtonItem!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    
    private let viewModel: TweetsViewModelIO = TweetsViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Inputs
        
        self.logoutButton.rx.tap
            .bind(to: viewModel.inputs.logoutSubject)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "Cell", cellType: TweetTableViewCell.self) { cell, _, tweet in
            cell.textLabel?.text = tweet.message
        }
        
        self.viewModel.outputs.tweetsObservable
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
        
        self.viewModel.outputs.loggedOutObservable
            .bind { [unowned self] in self.showLogin() }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind  {
                User.current?.tweet(message: "testing 1 2 3 4")
            }
            .disposed(by: disposeBag)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.userVar.value = User.current
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if User.current == nil {
            showLogin()
        }
    }
    
    private func showLogin() {
        navigationController?.performSegue(withIdentifier: "ShowLogin", sender: nil)
    }
}
