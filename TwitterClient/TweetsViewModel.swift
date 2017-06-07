//
//  TweetsViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import RxSwiftExt

protocol TweetsViewModelInputs {
    
    var logoutSubject: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
}

protocol TweetsViewModelIO {
    
    var inputs: TweetsViewModelInputs { get }
    var outputs: TweetsViewModelOutputs { get }
}

final class TweetsViewModel: TweetsViewModelIO, TweetsViewModelInputs, TweetsViewModelOutputs {
    
    // MARK: - Inputs
    
    var inputs: TweetsViewModelInputs {
        return self
    }
    
    let logoutSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: TweetsViewModelOutputs {
        return self
    }
    
    // MARK: - Init
    
    init() {
        
    }
}
