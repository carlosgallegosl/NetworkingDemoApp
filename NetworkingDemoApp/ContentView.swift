//
//  ContentView.swift
//  NetworkingDemoApp
//
//  Created by Juan Carlos on 4/4/20.
//  Copyright © 2020 Juan Carlos. All rights reserved.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}


struct ContentView: View {
    
    @State private var results = [Result]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results, id: \.trackId){ item in
                    VStack(alignment: .leading){
                        Text(item.trackName)
                            .font(.headline)
                        Text(item.collectionName)
                    }
                }
            }.onAppear(perform: loadData)
            .navigationBarTitle("Songs List")
        }
    }
    
    
    func loadData(){
        //Step 1
        guard let url = URL (string:"https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print ("Invalid URL")
            return
        }
        //Step 2
        let request = URLRequest(url: url)
        
        //Step 3
        URLSession.shared.dataTask(with: request){ data, response, error in
            //Step 4
            if let data2 = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data2) {
                    
                    DispatchQueue.main.async {
                        //main thread
                        self.results = decodedResponse.results
                    }
                    
                    return
                }
                
            }
            
            //Error
            print ("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
