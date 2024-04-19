//
//  BoardMainViewController.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/18/24.
//

import UIKit
import Alamofire

final class BoardMainViewController: RxBaseViewController {
    
    private let mainView = BoardMainView()
    private let viewModel = BoardMainViewModel()
    var delegate : BoardCoordinator?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlRequest = MainRouter.write(query: WriteRequest(title: "postTest", content: "테스트임니다!", product_id: "yeogiApa_test"))
        
        AF.request(urlRequest, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: WriteResponse.self) { response in
                switch response.result {
                case .success(let writeModel):
                    print(writeModel)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    override func bind() {
        
    }
}
