//
//  ViewController.swift
//  DogApi
//
//  Created by John Doe on 10.11.2023.
//

import UIKit
import Alamofire

final class ViewController: UIViewController {

    @IBOutlet weak var dogImageView: UIImageView!
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manualDogParsing()
    }

    @IBAction func getRandomDog(_ sender: Any) {
        networkManager.fetchImage(from: Link.baseURL.url, to: dogImageView) { (result: Result<Dog, Error>) in
            switch result {
            case .success(let dog):
                print("Dog image fetched: \(dog.message)")
            case .failure(let error):
                print("Error fetching dog image: \(error.localizedDescription)")
            }
        }
    }
    private func manualDogParsing() {
        AF.request(Link.baseURL.url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let dogsData = value as? [String: Any] else { return }
                    guard let imageUrl = URL(string: Dog(dogsData: dogsData).message) else { return }
                    self.downloadImage(from: imageUrl, to: self.dogImageView)
                    print(Dog(dogsData: dogsData))
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func downloadImage(from url: URL, to imageView: UIImageView) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let imageData):
                if let image = UIImage(data: imageData) {
                    imageView.image = image
                }
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }

}

