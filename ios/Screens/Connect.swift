//
//  Connect.swift
//  vibe
//
//  Created by Jayden Chun on 6/29/25.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct Connect: View {
    let db = Firestore.firestore()
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Button(
                    action:{print("connecting fr trust there's something happening in the backend")}
                ){
                    Text("Join a Vibe Session")
                        .bold()
                }
                .background(Color.orange)
                .border(Color.white, width: 1)
                Button(
                    action:{
                        print("creating a vibe session")
                        createVibeSession()
                    }
                ){
                    Text("Create a Vibe Session")
                        .bold()
                }
                .background(Color.orange)
                .border(Color.white, width: 1)
            }
            .position(x: geometry.size.width*0.5, y: geometry.size.height*0.5)
        }
    }
    private func createVibeSession() {
        Task{
            do{
                let ref = try await db.collection("vibeSessions").addDocument(data: [
                    "sessionID": UUID().uuidString
                ])
                print("Document added with ID: \(ref.documentID)")
            } catch{
                print("Error adding document: \(error)")
            }
        }
    }
}

#Preview {
    Connect()
}
