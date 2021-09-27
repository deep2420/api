//
//  ViewController.swift
//  api
//
//  Created by Hardeep Singh on 23/09/21.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var animeLabel: UILabel!
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var characterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let semaphore = DispatchSemaphore (value: 0)
        
        let url = URL(string: "https://animechan.vercel.app/api/random")
        
        guard url != nil else {
            print("url is not right")
            return
        }

//        let parameters = "{\"id\": \"8\"}"
//        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: url!,timeoutInterval: Double.infinity)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
//        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
                do {
                    let dataDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    animeLabel.text = dataDict!["anime"] as? String
                    quoteLabel.text = dataDict!["quote"] as? String
                    characterLabel.text = dataDict!["character"] as? String
                } catch {
                    print(error.localizedDescription)
                }
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }

        



}
