import SwiftUI
import Foundation

struct Details: Codable {
    let count: Int
    let name: String
    let age: Int
}

func performApiCall(name: String) async throws -> Details {

    let url = URL(string: "https://api.agify.io?name=\(name)")!
    

    let (data, _) = try await URLSession.shared.data(from: url)
   
    let details = try JSONDecoder().decode(Details.self, from: data)
    
   
    print("Fetched details: \(details)")
    
    return details
}

struct ContentView: View {
    @State private var name: String = "John"
    @State private var details: Details?

    var body: some View {
        VStack {
            Image(systemName: "person")
                .imageScale(.large)
                .foregroundStyle(.tint).padding(.bottom, 10)
            Text("Fetch Age According to your Name")
        
            TextEditor(text: $name)
                .frame(height: 40)
                .border(Color.gray)
            
           
            if let details = details {
                Text("Name: \(details.name), Age: \(details.age)")
            }
            
         
            Button("Show Age") {
                Task {
                    do {
                        let result = try await performApiCall(name: name)
                        details = result
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

