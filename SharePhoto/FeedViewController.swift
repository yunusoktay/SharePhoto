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
    
    var emailSet = [String]()
    var commentSet = [String]()
    var imageSet = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getFirebaseData()
    }
    
    func getFirebaseData() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Post").addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    self.imageSet.removeAll(keepingCapacity: false)
                    self.commentSet.removeAll(keepingCapacity: false)
                    self.emailSet.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        if let gorselUrl = document.get("gorselUrl") as? String {
                            self.imageSet.append(gorselUrl)
                        }
                        
                        if let comment = document.get("yorum") as? String {
                            self.commentSet.append(comment)
                        }
                        
                        if let email = document.get("email") as? String {
                            self.emailSet.append(email)
                        }
                     }
                    
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = emailSet[indexPath.row]
        cell.commentText.text = commentSet[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.imageSet[indexPath.row]))
        return cell
    }
}
