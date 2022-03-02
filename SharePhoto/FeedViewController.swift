//
//  FeedViewController.swift
//  SharePhoto
//
//  Created by yunus oktay on 1.03.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postSet = [Post]()
    
    /*
    var emailSet = [String]()
    var commentSet = [String]()
    var imageSet = [String]()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getFirebaseData()
    }
    
    func getFirebaseData() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true)
            .addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    //self.imageSet.removeAll(keepingCapacity: false)
                    //self.commentSet.removeAll(keepingCapacity: false)
                    //self.emailSet.removeAll(keepingCapacity: false)
                    
                    self.postSet.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        if let gorselUrl = document.get("gorselUrl") as? String {
                            
                            if let comment = document.get("yorum") as? String {
                                
                                if let email = document.get("email") as? String {
                                    let post = Post(email: email, comment: comment, imageUrl: gorselUrl)
                                    self.postSet.append(post)
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                     }
                    
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = postSet[indexPath.row].email
        cell.commentText.text = postSet[indexPath.row].comment
        cell.postImageView.sd_setImage(with: URL(string: self.postSet[indexPath.row].imageUrl))
        return cell
    }
}
