//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxRealmDataSources
import RxSwift

final class TweetsViewController: UIViewController {
    
    var viewModel: TweetsViewModelIO!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var logoutButton: UIBarButtonItem!
    @IBOutlet private weak var composeButton: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: UI
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        // MARK: Inputs
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: viewModel.inputs.loadNewer)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(to: viewModel.inputs.logout)
            .disposed(by: disposeBag)
        
        composeButton.rx.tap
            .bind(to: viewModel.inputs.compose)
            .disposed(by: disposeBag)
        
        // MARK: Outputs
        
        let dataSource = RxTableViewRealmDataSource<Tweet>(cellIdentifier: "Cell", cellType: TweetCell.self) { cell, indexPath, tweet in
            cell.viewModel.inputs.tweet.value = tweet
        }
        
        viewModel.outputs.tweets
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: disposeBag)
        
        viewModel.outputs.composeViewModel
            .bind { [unowned self] composeViewModel in
                let composeNavigationController = UIStoryboard.compose.instantiateInitialViewController(ofType: UINavigationController.self)
                let composeVC = composeNavigationController.viewControllers[0] as! ComposeViewController
                composeVC.viewModel = composeViewModel as ComposeViewModelIO
                self.navigationController?.present(composeNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.isLoading.debug()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.outputs.loggedOut
            .bind { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.errors
            // Without delay UIRefreshControl wouldn't hide
            .delay(0.25, scheduler: MainScheduler.instance)
            .bind { [unowned self] error in
                self.present(UIAlertController.error(error), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
