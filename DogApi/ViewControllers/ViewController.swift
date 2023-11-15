//
//  ViewController.swift
//  DogApi
//
//  Created by John Doe on 10.11.2023.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var dogImageView: UIImageView!
    private let networkManager = NetworkManager.shared

    @IBAction func getRandomDog(_ sender: Any) {
        networkManager.fetchDogImage(from: Link.baseURL.url, to: dogImageView)
    }
}

