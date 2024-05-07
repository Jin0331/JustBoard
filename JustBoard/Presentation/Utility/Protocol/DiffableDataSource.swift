//
//  DiffableDataSource.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/24/24.
//

import Foundation

protocol DiffableDataSource {
    associatedtype DecodableType: Decodable
    
    func configureDataSource()
    func updateSnapshot(_ data : DecodableType)
}
