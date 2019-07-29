//
//  FeedVC.swift
//  social_network
//
//  Created by Teodora Knezevic on 7/22/19.
//  Copyright © 2019 Teodora Knezevic. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyField!
    @IBOutlet weak var tableView: UITableView!
    
    var imageSelected = false
    
    var imagePicker:UIImagePickerController!
    
    var posts:[Post] = []
    
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        DataService.DS.ref_posts.observe(DataEventType.value) { (snapshot) in
            
            self.posts = [] // da se ne bi gomilale iste slike svaki put kad se okine ovaj blok OBSERVE metode
           
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let postData = snap.value as? [String:Any]{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postData)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
           
            //provera da li ima slike u kes memoriji
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
               
                cell.configureCell(post: post, image: image)
                
            }else{
                cell.configureCell(post: post, image: nil)
            }
            return cell
            
        }else{
            return PostCell()
        }
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageAdd.image = image
            imageSelected = true
        }
        else{
            print("Teodora: A valid image was not selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func signOutTapped(_ sender: Any) {       // moramo se odjaviti sa Firebase-a i skloniti user id iz keychain-a
    
        let result = KeychainWrapper.standard.removeObject(forKey: KEY_ID)
        print("ID removed from keychain: \(result)")
        
        try!Auth.auth().signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else{
            print("Teodora: Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("Teodora: An image must be selected")
            return
        }
        
        if let imgData = img.jpegData(compressionQuality: 0.2){
            
            let imgUid = NSUUID().uuidString
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            // SALJEM SLIKU U STORAGE, UZIMAM URL SLIKE I NA KRAJU UBACUJEM CEO POST U BAZU
            
            DataService.DS.ref_post_images.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil{
                    print("Teodora: unable to upload image to firebase storage")
                }else{
                    print("Teodora: successfully uploaded image to firebase storage")
                    self.dajUrlSlike(id: imgUid)
                   
//                    let downloadUrl = metadata?.downloadURL().absoluteString
//                    if let url = downloadUrl{
//                        print("URL za download je \(url)")
//                    }
                }
            }
        }
    }
    func dajUrlSlike(id:String){
        DataService.DS.ref_post_images.child(id).downloadURL { (url, error) in
            if error != nil {
                print("Todora: Greska u dobijanju url slike")
            }else{
                if let downloadUrl = url{
                    print("Teodora: URL za download slike je \(downloadUrl)")
                    self.postToFirebase(imgUrl: downloadUrl.absoluteString)
                }
            }
        }
    }
    func postToFirebase(imgUrl:String){
        let post:[String:Any] = ["caption":captionField.text!,
                                 "imageUrl": imgUrl,
                                 "likes":0]
        let firebasePost = DataService.DS.ref_posts.childByAutoId() // referenca
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
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
