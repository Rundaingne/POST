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
    
    //Mark: -Methods
    
    func fetchPosts(reset: Bool = true, completion: @escaping() -> Void) {
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts?.last?.queryTimestamp ?? Date().timeIntervalSince1970
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        guard let url = self.baseUrl else {completion(); return}
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let finalUrl = urlComponents?.url else {return}

        
        let getterEndpoint = finalUrl.appendingPathExtension("json")
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
                if reset {
                    self.posts = posts
                }else {
                    self.posts?.append(contentsOf: posts)
                }
                completion()
            } catch {
                print("Error getting post")
                completion()
            }
        } .resume()
    }
    
    func addNewPostWith(text: String, username: String, completion: @escaping () -> Void) {
        
        let post = Post(text: text, username: username)
        var postData: Data
        do {
        postData = try JSONEncoder().encode(post)
        } catch {
            print("There was an error. Yay.")
            return
        }
         guard let url = self.baseUrl else {completion(); return}
        let postEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        //Call the datatask, handle errors, run the completion
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion()
                return
            }
            self.fetchPosts(completion: completion)
        } .resume()
    }
}
