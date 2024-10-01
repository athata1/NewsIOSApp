//
//  TopHeadlinesModel.swift
//  NewsApp
//
//  Created by Akhil Thata on 9/19/24.
//

import Foundation

struct TopHeadlinesModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleModel]
    
}
