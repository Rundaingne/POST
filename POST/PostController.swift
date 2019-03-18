//
//  PostController.swift
//  POST
//
//  Created by Brooke Kumpunen on 3/18/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class PostController {
    
    let baseUrl = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    var posts: [Post]?
    
    func fetchPosts(completion: @escaping() -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let url = self.baseUrl else {completion(); return}
        
        let getterEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error getting URL. \(error): \(error.localizedDescription)")
                completion()
                return
            }
            guard let data = data else {completion(); return}
            do {
                let postsDictionary = try JSONDecoder().decode([String: Post].self, from: data)
                var posts = postsDictionary.compactMap({$0.value})
               posts.sort(by: {$0.timestamp > $1.timestamp})
                self.posts = posts
                completion()
            } catch {
                print("Error getting post")
                completion()
            }
        } .resume()
    }
}
