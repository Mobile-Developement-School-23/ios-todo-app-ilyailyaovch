import Foundation
import CocoaLumberjackSwift

enum ApiErrors: Error {
    case badURL
    case impossinbleToDecode
}

protocol NetworkingService {
    func getList() async throws -> [TodoItem]
    func patchList(with todoItemsClient: [TodoItem]) async throws -> [TodoItem]
}

class DefaultNetworkingService: NetworkingService {

    private let token = "trisomies"
    private let userName = "Ovchinnikov_I"
    private var revision = 0

    private func createURL(id: String = "") -> URL? {
        let baseURL = "https://beta.mrdekk.ru/todobackend"
        let endpoint = "/list"
        let addressURL = baseURL + endpoint + id
        let url = URL(string: addressURL)
        return url
    }

    func getList() async throws -> [TodoItem] {
        // Cоздание URL
        guard let url = createURL()
        else { throw ApiErrors.badURL }
        // Настройка запроса
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        // Получение данных по запросу
        let (data, _) = try await URLSession.shared.dataTask(for: request)
        // Декодирование данных по запросу
        let todoItemsOrigin = try parseTodoItems(data: data)
        DDLogInfo("GET data from the server")
        return todoItemsOrigin
    }

    func patchList(with todoItemsClient: [TodoItem]) async throws -> [TodoItem] {
        // Cоздание URL
        guard let url = createURL()
        else { throw ApiErrors.badURL }
        // Кодирование локального списка
        let list = todoItemsClient.map({ $0.json })
        let body = try JSONSerialization.data(withJSONObject: [
            "list": list,
            "revision": self.revision,
            "status": "ok"
        ] as [String : Any])
        // Настройка запроса
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.allHTTPHeaderFields = ["X-Last-Known-Revision": "0"]
        request.httpBody = body
        // Отправка запроса
        let (data, _) = try await URLSession.shared.dataTask(for: request)
        let todoItemsOrigin = try parseTodoItems(data: data)
        DDLogInfo("POST data to the server")
        return todoItemsOrigin
    }

    func parseTodoItems(data: Data) throws -> [TodoItem] {
        let body = try JSONSerialization.jsonObject(with: data)
        guard
            let jsonArray = body as? [String: Any],
            let revision = jsonArray["revision"] as? Int,
            let list = jsonArray["list"] as? [[String: Any]]
        else { throw ApiErrors.impossinbleToDecode }
        var todoItemsOrigin: [TodoItem] = []
        for item in list {
            guard let todoItem = TodoItem.parse(json: item)
            else { throw ApiErrors.impossinbleToDecode }
            todoItemsOrigin.append(todoItem)
        }
        self.revision = revision
        return todoItemsOrigin
    }
}
