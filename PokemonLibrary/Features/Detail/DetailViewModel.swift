//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Reinhart on 08/05/25.
//

import Foundation
import SwiftUI


enum DetailViewState {
    case loading
    case loaded(PokemonDetailResponse)
    case error(NetworkError)
}

class DetailViewModel : ObservableObject {
    
    @Published private(set) var state: DetailViewState = .loading
    @Published var image: Image? = nil
    
    let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    
    func loadPokemonDetail() {
        updateState(.loading)
        
        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                loadImage(from: URL(string: detail.sprites.other.officialArtwork.url)!)
                updateState(.loaded(detail))
            } catch let error as NetworkError {
                updateState(.error(error))
            } catch {
                updateState(.error(.unknown))
            }
        }
    }
    
    private func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
            }
        }
    }
    
    private func updateState(_ state: DetailViewState) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}
