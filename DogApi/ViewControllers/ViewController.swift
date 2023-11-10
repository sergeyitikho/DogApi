//
//  ViewController.swift
//  DogApi
//
//  Created by John Doe on 10.11.2023.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getRandomDog(_ sender: Any) {
        fetchDogData()
    }
    
    private func fetchDogData() {
        guard let url = URL(string: "https://random.dog/woof.json") else {
            print("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _ , error in
            guard let data = data else {
                print(error?.localizedDescription ?? "no error description")
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let dog = try jsonDecoder.decode(Dog.self, from: data)
                print(dog)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

