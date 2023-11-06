//
//  ActorsViewModel.swift
//  Cinema
//
//  Created by Helen on 20.10.2023.
//

import Foundation

final class ActorsViewModel: ObservableObject {
    
    private let networkManager = NetworkManager()
    
    enum State {
        case loading, loaded, error(String)
    }
    
    @Published var state: State = .loading
    private(set) var actor: ActorDetails?
    private(set) var images: [Profile] = []
    let actorId: Int
    
    var birthday: String? {
        actor?.birthday.date(
            fromFormat: "yyyy-MM-dd",
            toFormat: "d MMMM yyyy"
        )
    }
    
    init(id: Int) {
        self.actorId = id
        fetchActorDetails()
        fetchActorImages()
    }
    
    func fetchActorDetails() {
        networkManager.fetchActorDetails(actorId: actorId) { [weak self] result in
            switch result {
            case .success(let actor):
                self?.actor = actor
                self?.state = .loaded
            case .failure(let error):
                self?.state = .error(error.localizedDescription)
            }
        }
    }
    
    func fetchActorImages() {
        networkManager.fetchActorImages(actorId: actorId) { [weak self] result in
            switch result {
            case .success(let images):
                self?.images = images.profiles
                self?.state = .loaded
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
