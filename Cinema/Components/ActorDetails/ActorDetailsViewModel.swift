//
//  ActorsViewModel.swift
//  Cinema
//
//  Created by Helen on 20.10.2023.
//

import Foundation

@MainActor final class ActorsViewModel: ObservableObject {
    
    private let networkManager = NetworkManager()
    
    enum State {
        case loading, loaded, error(String)
    }
    
    @Published var state: State = .loading
    private(set) var actor: ActorDetails?
    private(set) var images: [Profile] = []
    let actorId: Int
    
    var birthday: String? {
        actor?.birthday?.date(
            fromFormat: "yyyy-MM-dd",
            toFormat: "d MMMM yyyy"
        )
    }
    
    init(id: Int) {
        self.actorId = id
        Task {
            await fetchActorDetails()
            await fetchActorImages()
        }
    }
    
    func fetchActorDetails() async {
        let result = await networkManager.fetchActorDetails(actorId: actorId)
        switch result {
        case .success(let actor):
            self.actor = actor
            state = .loaded
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }
    
    func fetchActorImages() async {
        let result = await networkManager.fetchActorImages(actorId: actorId)
        switch result {
        case .success(let images):
            self.images = images.profiles
            state = .loaded
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }
}
