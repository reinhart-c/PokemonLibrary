//
//  HomeView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI

struct HomeView: View {
    @State var pokemons: [Pokemon] = []
    @State var searchText: String = ""
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var navigationPath = NavigationPath()

    var filteredPokemons: [Pokemon] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if isLoading {
                    Text("Loading...")
                }
                else if showError {
                    Text("Error: \(errorMessage)")
                }
                else {
                    List(filteredPokemons, id: \.name) { pokemon in
                        HStack {
                            Text(pokemon.name.capitalized)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            navigationPath.append(pokemon)
                        }
                    }
                }
            }
            .navigationTitle("Pokémon List")
            .navigationDestination(for: Pokemon.self) { selected in
                DetailView(pokemon: selected)
            }
        }
        .onAppear {
            fetchPokemons()
        }
        .searchable(text: $searchText, prompt: "Search your favorite pokémon")
    }

    func fetchPokemons() {
        isLoading = true
        errorMessage = ""
        showError = false

        Task {
            do {
                let response: PokemonListResponse = try await NetworkService().request(.getPokemons)
                self.pokemons = response.results
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = (error as! NetworkError).errorDescription ?? ""
                self.showError = true
            }
        }
    }
}
