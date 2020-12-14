//
//  ContentView.swift
//  BiotecnologiaEmLibras Animation
//
//  Created by Vinicius Lara on 09/11/20.
//  Copyright © 2020 Vinicius Lara. All rights reserved.
//

import SwiftUI

import AVFoundation

import AVKit
import UIKit

public struct Video: UIViewControllerRepresentable {
    
    let videoURL: URL
    
    @Binding var speed: Double
    
    @State private var videoViewController: AVPlayerViewController = AVPlayerViewController()
    
    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        
        videoViewController.player = AVPlayer(url: videoURL)
        videoViewController.player?.isMuted = true
        videoViewController.player?.play()
        videoViewController.player?.rate = Float(self.speed)
        
        return videoViewController
    }
    
    public func updateUIViewController(_ videoViewController: AVPlayerViewController, context: Context) {
        videoViewController.player?.playImmediately(atRate: Float(self.speed))
    }
}

extension UINavigationItem {
    func setTitle(_ title: String, subtitle: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17.0)
        titleLabel.textColor = .black
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 12.0)
        subtitleLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical
        
        self.titleView = stackView
    }
}

struct cardRow: View {
    var card: Card
    
    @State private var didTap = false
    
    var body: some View {
        HStack {
            Image(card.image)
                .resizable()
                .frame(width: 150, height: 150)
            
            VStack(alignment: .leading) {
                Text(card.title)
                    .font(Font.system(size: 30, design: .default))
                Text(card.details)
                    .font(Font.system(size: 12, design: .default))
            }
            
            Spacer()
        }
    }
}

struct cardView: View {
    @Binding var showingDetail: Bool
    
    @State private var speed: Double = 1.0
    
    var card: Card
    
    var body: some View {
        NavigationView {
            VStack {
                Image(card.image)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding(.top, 15)
                
                Text(card.details)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                Video(videoURL: Bundle.main.url(forResource: card.video, withExtension: "mp4")!, speed: $speed)
                
                HStack {
                    Text("Velocidade: \(speed, specifier: "%.2f")")
                    
                    Slider(value: $speed, in: 0...1, step: 0.1)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 5)
            }
            .navigationBarTitle(Text(card.title), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showingDetail = false
            }) {
                Text("Fechar")
                .bold()
            })
        }
    }
}

struct ContentView: View {
    
    @State var data: [dataOrdered]
    
    @State private var searchText: String = ""
    
    @State var showingDetail = false
    
    init(cards: [dataOrdered]) {
        _data = State(initialValue: cards)
        
        UITableView.appearance().separatorColor = .clear
        
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
    }
    
    func cardRowView(term: Card) -> some View {
        return ZStack {
            Button(action: {
                self.showingDetail.toggle()
            }) {
                cardRow(card: term)
            }.sheet(isPresented: $showingDetail) {
                cardView(showingDetail: self.$showingDetail, card: term)
            }
        }
    }
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Biotecnologia em LIBRAS")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        
                        Text("linguagem de sinais")
                            .padding(.leading, 10)
                        
                        SearchBar(text: $searchText, placeholder: "Pesquise entre os termos...")
                    }
                    .background(Color(UIColor.systemGray6).opacity(0.95).edgesIgnoringSafeArea(.all))
                    
                    ScrollViewReader { proxy in
                        
                        let cardsFiltered = data.filter {
                            return $0.cards.filter({
                                self.searchText.isEmpty ? true: $0.title.lowercased().contains(self.searchText.lowercased())
                            }).count > 0
                        }
                        
                        if (cardsFiltered.isEmpty) {
                            Text("Nenhum termo encontrado.")
                            
                            Spacer()
                        } else {
                            HStack {
                                ForEach(cardsFiltered) { letter in
                                    Button(letter.startLetter) {
                                        proxy.scrollTo(letter.id)
                                    }
                                }
                            }
                            .padding(.top, 5)
                            
                            List {
                                ForEach(cardsFiltered) { letter in
                                    Section(header: Text(letter.startLetter)) {
                                        ForEach(letter.cards, id: \.self) { term in
                                            self.cardRowView(term: term)
                                        }
                                        .listRowInsets(EdgeInsets())
                                    }
                                    .id(letter.id)
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "list.dash")
                Text("Início")
            }
            
            NavigationView {
                VStack(alignment: .center) {
                    Text("Biotecnologia em LIBRAS").font(Font.system(size: 30, weight: .heavy, design: .default))
                    
                    Text("Coordenador: Alexandro Cagliari").font(Font.system(size: 12, design: .default))
                    Text("Colaboradores: Priscilla Mena Zamberlan e Fabrícia Damando").font(Font.system(size: 12, design: .default))
                    Text("Colaboradores externos: Gabriel Passos e Laura Lopes").font(Font.system(size: 12, design: .default))
                    Text("Bolsistas: Vinícus Lara e Viven Lopes").font(Font.system(size: 12, design: .default))
                    Text("Bolsistas voluntários: Ketlyn Worm\n").font(Font.system(size: 12, design: .default))
                    Text("Universidade Estadual do Rio Grande do Sul\n").font(Font.system(size: 12, design: .default))
                    
                    Text("Licenciado por Creative Commons Attribution 3.0 License").font(Font.system(size: 12, design: .default))
                        .padding(.bottom, 2)
                    Link("https://github.com/oviniciuslara/biotecnologiaemlibras", destination: URL(string: "https://github.com/oviniciuslara/biotecnologiaemlibras")!)
                        .font(Font.system(size: 12, design: .default))
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)
                }
            }
            .tabItem {
                Image(systemName: "info.circle.fill")
                Text("Sobre")
            }
        }
    }
}

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    
    var placeholder: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            
            searchBar.enablesReturnKeyAutomatically = true
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
            searchBar.showsCancelButton = true
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .search
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
