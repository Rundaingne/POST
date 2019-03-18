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
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableViewOutlet.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
