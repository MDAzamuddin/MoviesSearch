//
//  MovieListVC.swift
//  MoviesSearch
//
//  Created by Azamuddin on 8/31/18.
//  Copyright © 2018 Azamuddin. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController {
    
    @IBOutlet weak var movieSearch: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titleArray = [String]()
    var imageArray = [String]()
    var originalTitleArray = [String]()
    var releaseArray = [String]()
    var ratingArray = [String]()
    var overviewArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.movieSearch.delegate = self
        self.getData(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=01bbb9d638f6e9e097e2beca52ab1a5c&language=en-US")!)
        
    }
    
// MARK: FilterAction
    
    @IBAction func filterMovies(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Popular Movies", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            self.getData(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=01bbb9d638f6e9e097e2beca52ab1a5c&language=en-US")!)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "High Rated Movies", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            self.getData(url: URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=01bbb9d638f6e9e097e2beca52ab1a5c&language=en-US&page=1")!)
            
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(actionsheet, animated: true, completion: nil)
        
        
    }
    
    
// MARK: GetURL Function
    
    func getData(url:URL)  {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTaskObj = session.dataTask(with: request) { (data, response, error) in
            do{
                let responseData:[String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : Any]
                
                guard let results: [[String:Any]] = responseData["results"] as? [[String : Any]] else{return}
                
                
                self.titleArray.removeAll()
                self.imageArray.removeAll()
                self.originalTitleArray.removeAll()
                self.releaseArray.removeAll()
                self.ratingArray.removeAll()
                self.overviewArray.removeAll()
                
                DispatchQueue.main.async {
                    
                    for i in 0..<results.count{
                        
                        self.titleArray.append("\(results[i]["title"]!)")
                        self.imageArray.append("\(results[i]["poster_path"]!)")
                        self.originalTitleArray.append("\(results[i]["vote_average"]!)")
                        self.releaseArray.append("\(results[i]["release_date"]!)")
                        self.ratingArray.append("\(results[i]["original_title"]!)")
                        self.overviewArray.append("\(results[i]["overview"]!)")
                        
                        self.collectionView.reloadData()
                    }
                }
            }
            catch let err{
                print(err)
            }
            
        }
        
        dataTaskObj.resume()
        
    }
    
    
}


// MARK: CollectionViewDelegates

extension MovieListVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titleArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieListCell
        
        DispatchQueue.main.async {
            let stringUrl = "https://image.tmdb.org/t/p/w500\(self.imageArray[indexPath.item])"
            let url = URL(string: stringUrl)
            guard let data1 = try? Data(contentsOf: url!)
                else{
                    return
            }
            
            let image = UIImage(data: data1)
            
            cell.posterImage.image = image
            cell.titleLbl.text = self.titleArray[indexPath.item]
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.layer.shadowOpacity = 1.0
            cell.layer.shadowRadius = 4.0
            cell.layer.cornerRadius = 5.0
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        
        DispatchQueue.main.async {
            
            let stringUrl = "https://image.tmdb.org/t/p/w500\(self.imageArray[indexPath.item])"
            let url = URL(string: stringUrl)
            guard let data1 = try? Data(contentsOf: url!)
                else{
                    return
            }
            let image = UIImage(data: data1)
            nextVC.profile = image
            nextVC.originalTitle = self.originalTitleArray[indexPath.item]
            nextVC.release = self.releaseArray[indexPath.item]
            nextVC.rating = self.ratingArray[indexPath.item]
            nextVC.overview = self.overviewArray[indexPath.item]
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}


// MARK: SearcgBarDelegate

extension MovieListVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool{
        
        self.getData(url: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=01bbb9d638f6e9e097e2beca52ab1a5c&language=en-US&query=\(self.movieSearch.text!)&page=1")!)
        
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        self.movieSearch.endEditing(true)
    }
}

