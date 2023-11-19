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
                    URLSession.shared.dataTask(with: imageUrl) { imageData, _, _ in
                        if let imageData = imageData, let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                self.dogImageView.image = image
                            }
                        }
                    }.resume()
                    print(Dog(dogsData: dogsData).message)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

