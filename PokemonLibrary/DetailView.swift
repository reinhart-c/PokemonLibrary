//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI
import Foundation

struct DetailView: View {
    let pokemon: Pokemon

    @State var name: String = ""
    @State var abilities: [String] = []
    @State var height: String = ""
    @State var weight: String = ""
    @State var image: Image? = nil
    @State var isLoading: Bool = true
    @State var showError: Bool = false
    @State var errorMessage: String = ""

    var body: some View {
        VStack {
            if isLoading {
                Text("Loading…")
            }
            else if showError {
                Text("Error: \(errorMessage)")
            }
            else {
                if let image = image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                } else {
                    Image(systemName: "xmark.octagon")
                }

                VStack(spacing: 8.0) {
                    Text(name)
                        .font(.title2)
                        .bold()
                        .padding(.top, 16.0)
                    
                    Text("Height: \(height)")
                    Text("Weight: \(weight)")
                    
                    Text("Abilities:")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16.0)
                    
                    ForEach(abilities, id: \.self) { ability in
                        Text(ability)
                    }
                }
            }
        }
        .onAppear {
            loadPokemonDetail()
        }
    }

    func loadPokemonDetail() {
        isLoading = true
        showError = false
        errorMessage = ""

        Task {
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                name = detail.name.capitalized
                height = "\(detail.height) cm"
                weight = "\(detail.weight) kg"
                abilities = detail.abilities.map { $0.ability.name.capitalized }

                loadImage(from: URL(string: detail.sprites.other.officialArtwork.url)!)
                isLoading = false
            } catch {
                isLoading = false
                showError = true
                self.errorMessage = (error as! NetworkError).errorDescription ?? ""
            }
        }
    }

    func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                }
            }
        }
    }
}
