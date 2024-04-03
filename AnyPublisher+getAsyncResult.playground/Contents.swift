import Foundation
import Combine

func getSoccerPlayers() -> AnyPublisher<Result<[String], Error>, Never> {
    let players = ["Lionel Messi", "Cristiano Ronaldo", "Neymar Jr.", "Kylian Mbappé"]
    
    return Just(players)
        .map(Result<[String], Error>.success)
        .eraseToAnyPublisher()
}

extension Publisher {
    func getAsyncResult<T>() async throws -> T where Output == Result<T, Error> {
        try await withCheckedThrowingContinuation { continuation in
            _ = self.sink(receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .finished: break
                }
            }, receiveValue: {
                continuation.resume(with: $0)
            })
        }
    }
}

func executableFunction() {
    Task {
        let players = try await getSoccerPlayers().getAsyncResult()
        print(players)
    }
}

executableFunction()
