//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI
import Foundation

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                Text("Loading…")
            case .loaded(let pokemonDetail):
                if let image = viewModel.image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                } else {
                    Image(systemName: "xmark.octagon")
                }
                
                VStack(spacing: 8.0) {
                    Text(pokemonDetail.name)
                        .font(.title2)
                        .bold()
                        .padding(.top, 16.0)
                    
                    Text("Height: \(pokemonDetail.height)")
                    Text("Weight: \(pokemonDetail.weight)")
                    
                    Text("Abilities:")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16.0)
                    
                    ForEach(pokemonDetail.abilities) { ability in
                        Text(ability.ability.name)
                    }
                }
            case .error(let networkError):
                Text("Error: \(networkError.errorDescription)")
            }
        }
        .onAppear {
            viewModel.loadPokemonDetail()
        }
    }
}
