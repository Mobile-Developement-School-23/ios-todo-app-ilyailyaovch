import Foundation

protocol NetworkingService {

    func get()
}

class DefaultNetworkingService: NetworkingService {

    private let token = "trisomies"
    private let userName = "Ovchinnikov_I"
    private let baseURL = "https://beta.mrdekk.ru/todobackend"

    func get() {
        let url = URL(string: baseURL + "/list")
        Task {
            var request = URLRequest(url: url! as URL)
            request.httpMethod = "GET"
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            let task = try await URLSession.shared.dataTask(for: request)
            let json = try JSONSerialization.jsonObject(
                with: task.0,
                options: JSONSerialization.ReadingOptions.mutableContainers
            ) as! NSDictionary
            print(json)
        }

//        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data,response,error) -> Void in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                return
//            }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                print(json)
//           } catch let error as NSError {
//               print(error.localizedDescription)
//           }
//        }
//        task.resume()
    }
}
