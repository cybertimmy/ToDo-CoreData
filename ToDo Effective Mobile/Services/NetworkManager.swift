import Foundation

final class Constants {
    static let ToDoID = "https://dummyjson.com/todos"
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getData<T: Decodable>(url: URL, modelForParsing: T.Type, completion: @escaping (T?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   print("Error fetching agents: \(error)")
                   completion(nil)
                   return
               }
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let agentResponce = try JSONDecoder().decode(T.self, from: data)
                completion(agentResponce)
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
}
