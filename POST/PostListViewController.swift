//
//  PostListViewController.swift
//  POST
//
//  Created by Brooke Kumpunen on 3/18/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: -Outlets
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    //MARK: -Properties
    var postController = PostController()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        tableViewOutlet.refreshControl = refreshControl
        tableViewOutlet.estimatedRowHeight = 45
        tableViewOutlet.rowHeight = UITableView.automaticDimension
        postController.fetchPosts {
            self.reloadTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts?[indexPath.row]
        cell.textLabel?.text = post?.text
        cell.detailTextLabel?.text = post?.username
        return cell
    }
    
    //MARK: -Methods
    @objc func refreshControlPulled() {
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        postController.fetchPosts {
            self.reloadTableView()
        }
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "Create Post", message: "Say something ya dunce!", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "UserName"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Message"
        }
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let username = alertController.textFields?[0].text,
                let message = alertController.textFields?[1].text else {return}
            self.postController.addNewPostWith(text: message, username: username, completion: {
                self.reloadTableView()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
        //Alright, I've got a few actions on this baby, and now I just need to put them all together and then present it.
        alertController.addAction(postAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableViewOutlet.reloadData()
        }
    }
    
    //MARK: - Actions
    @IBAction func addPostButtonTapped(_ sender: UIBarButtonItem) {
        presentNewPostAlert()
    }
}

extension PostListViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let posts = postController.posts else {return}
        if indexPath.row >= posts.count - 1 {
            postController.fetchPosts(reset: false) {
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                }
            }
        }
    }
    
}
