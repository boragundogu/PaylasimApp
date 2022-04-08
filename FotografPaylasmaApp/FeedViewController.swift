//
//  FeedViewController.swift
//  FotografPaylasmaApp
//
//  Created by Bora Gündoğu on 1.04.2022.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseVerileriAl()
    }
    
    func firebaseVerileriAl(){
        
        let firestoreDatabase = Firestore.firestore()
        // wherefield kullanımı filtreleme  order by dizme mesela tarihe göre
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil{
                print(error?.localizedDescription ?? "Hata mesajı")
            }
            else{
               if snapshot?.isEmpty != true && snapshot != nil {
                   
                   self.emailDizisi.removeAll(keepingCapacity: false)
                   self.gorselDizisi.removeAll(keepingCapacity: false)
                   self.yorumDizisi.removeAll(keepingCapacity: false)
                   // tek arrayde kullanmak istersem obje odaklı yazabilirim 11.15_Refactoring 5.dakika
                   
                   for document in snapshot!.documents{
                       
                       //let documentID = document.documentID // document idleri alma
                       if let gorselUrl = document.get("gorselurl") as? String{
                           self.gorselDizisi.append(gorselUrl)
                       }
                       if let yorum = document.get("yorum") as? String{
                           self.yorumDizisi.append(yorum)
                       }
                       if let email = document.get("email") as? String{
                           self.emailDizisi.append(email)
                       }
                   }
                   self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text! = emailDizisi[indexPath.row]
        cell.yorumText.text! = yorumDizisi[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
        return cell
    }
    


}
