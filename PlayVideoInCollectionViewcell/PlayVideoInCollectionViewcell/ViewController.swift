//
//  ViewController.swift
//  PlayVideoInCollectionViewcell
//
//  Created by chaitanya on 14/09/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var data = [Category]()
    var avPlayerCintroller = AVPlayerViewController()
    var playerView:AVPlayer?
    

    
    @IBOutlet weak var videoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        videoCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
        // Register CollectionViewCell
        //videoCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionViewCell")
       
        fetchingJsonData { result in
            self.data = result
            DispatchQueue.main.async {
                self.videoCollectionView.reloadData()
            }
        }
        
    }
    
    
    
    func fetchingJsonData(handler: @escaping (_ result:[Category]) -> (Void)) {
        guard let fileLocation = Bundle.main.url(forResource: "simple", withExtension: "json") else {return}
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(json)
            let decode = try JSONDecoder().decode(JsonModel.self, from: data)
            
            // Clousure Calling
            handler(decode.categories)
        
        }catch{
            print("Parsing Error")
        }
    }
    
    func videoUrl(url:String){
        guard let url = URL(string: url) else {return}
        self.playerView = AVPlayer(url: url)
        playerView?.play()
        avPlayerCintroller.player = playerView
        present(avPlayerCintroller, animated: true, completion: nil)
                
    }

}

extension ViewController: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        let videoData = data[indexPath.section].videos[indexPath.row]
        cell.title.text = videoData.title
        cell.videoThubNail.downloaded(from: videoData.thumb, contentMode: .scaleToFill)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoData = data[indexPath.section].videos[indexPath.row]
        videoUrl(url: videoData.sources)
    }
}



    
    
    


