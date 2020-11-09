//
//  ContentView.swift
//  BiotecnologiaEmLibras Animation
//
//  Created by Vinicius Lara on 09/11/20.
//  Copyright © 2020 Vinicius Lara. All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation
import UIKit

public struct Video: UIViewControllerRepresentable {

    let videoURL: URL
    
    public func makeUIViewController(context: Context) -> AVPlayerViewController {
      
        let videoViewController = AVPlayerViewController()
        videoViewController.player = AVPlayer(url: videoURL)
        videoViewController.player?.isMuted = true
        videoViewController.player?.play()
        return videoViewController
    }
    
    public func updateUIViewController(_ videoViewController: AVPlayerViewController, context: Context) {

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

struct Card : Decodable, Hashable, Identifiable {
    
    var id : Int
    var image : String
    var video : String
    var title : String
    var details : String
    var expand : Bool
}

struct cardRow: View {
    var card: Card

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
        //.background(Color(UIColor.systemBlue).opacity(1.0 - (Double(card.id)/8.0)))
        .contentShape(Rectangle())
    }
}

struct cardView: View {
    @Binding var showingDetail: Bool

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
//                .padding(.top, 10)
                
                Spacer()
            
                Video(videoURL: Bundle.main.url(forResource: card.video, withExtension: "mp4")!)
            }
            
            .navigationBarTitle(Text(card.title), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showingDetail = false
            }) {
                Text("Fechar").bold()
            })
        }
    }
}

struct ContentView : View {
    
    init() {
        UITableView.appearance().separatorColor = .clear
        let appearance = UITableViewCell.appearance()
        appearance.selectionStyle = .none
    }
    
    @State var data = [
        Card(id: 0, image: "imagem_cromossomo", video: "video_cromossomo", title: "Cromossomo", details: "Colécula de DNA em seu máximo estágio de compactação.", expand: false),
        Card(id: 1, image: "imagem_locus", video: "video_locus", title: "Locus", details: "Posição que um gene ocupa em um cromossomo.", expand: false),
        Card(id: 2, image: "imagem_genotipo", video: "video_genotipo", title: "Genótipo", details: "Constituição genética de um organismo, ou seja, o conjunto de genes que um indivíduo possui.", expand: false),
        Card(id: 3, image: "imagem_fenotipo", video: "video_fenotipo", title: "Fenótipo", details: "Expressão do genótipo mais a interação do ambiente.", expand: false),
    ]
        
    @State private var searchText : String = ""

    @State var showingDetail = false

    var body: some View{
        
        TabView {
            NavigationView {
                VStack{
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
            
                    List {
                         ForEach(self.data.filter {
                             self.searchText.isEmpty ? true : $0.title.lowercased().contains(self.searchText.lowercased())
                         }, id: \.self) { term in
                            ZStack {
                                Button(action: {
                                    self.showingDetail.toggle()
                                }) {
                                    cardRow(card: term)
                                }.sheet(isPresented: $showingDetail) {
                                    cardView(showingDetail: self.$showingDetail, card: term)
                                }
                            }
                         }
                        .listRowInsets(EdgeInsets())
                     }
                    .listStyle(PlainListStyle())
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
