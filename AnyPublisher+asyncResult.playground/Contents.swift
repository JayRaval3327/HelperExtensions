import Foundation
import Combine

func getSoccerPlayers() -> AnyPublisher<[String], Never> {
    let players = ["Lionel Messi", "Cristiano Ronaldo", "Neymar Jr.", "Kylian Mbappé"]
    return Just(players)
        .eraseToAnyPublisher()
}

extension Publisher {
    func asyncResult() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            _ = self.sink(receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .finished: break
                }
            }, receiveValue: {
                continuation.resume(returning: $0)
            })
        }
    }
}

func executableFunction() {
    Task {
        let players = try await getSoccerPlayers().asyncResult()
        print(players)
    }
}

executableFunction()
