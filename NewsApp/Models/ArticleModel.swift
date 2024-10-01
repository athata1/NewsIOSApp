//
//  ArticleModel.swift
//  NewsApp
//
//  Created by Akhil Thata on 9/19/24.
//

import Foundation

struct ArticleModel: Codable {
    let source: ArticleSource
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct ArticleSource: Codable {
    let id: String?
    let name: String
}
