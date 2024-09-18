//
//  StoryDatabase.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-15.
//

/* This document is not used in the final app but is used to upload some fake stories to the database.*/
// TODO: delete this before production

import Foundation

struct StoryArray: Codable {
    let stories: [DBStory]
    let total, skip, limit: Int
}


//    func downloadProductsAndUploadToFirebase() {
//        guard let url = URL(string: "https://dummyjson.com/products") else { return }
//
//        Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                let products = try JSONDecoder().decode(ProductArray.self, from: data)
//                let productArray = products.products
//
//                for product in productArray {
//                    try? await ProductsManager.shared.uploadProduct(product: product)
//                }
//
//                print("SUCCESS")
//                print(products.products.count)
//            } catch {
//                print(error)
//            }
//        }
//    }


final class StoryDatabase {
    
    static let stories: [DBStory] = [
        DBStory(
            id: "se1",
            title: "Den Försvunna Skatten",
            description: "En spännande resa för att hitta en försvunnen skatt gömd i de svenska skogarna.",
            chapters: 3,
            difficulty: .beginner,
            language: .swedish,
            type: .basic,
            level: 3,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se2",
            title: "Mysteriet på Tåget",
            description: "En detektivhistoria om ett mystiskt försvinnande under en tågresa genom Sverige.",
            chapters: 2,
            difficulty: .intermediate,
            language: .swedish,
            type: .branching,
            level: 9,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se3",
            title: "Stockholms Nattliv",
            description: "Utforska Stockholms nattliv genom ögonen på en ung äventyrare.",
            chapters: 3,
            difficulty: .beginner,
            language: .swedish,
            type: .podcast,
            level: 4,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se4",
            title: "Vinter i Lappland",
            description: "En berättelse om livet i norra Sverige under de kalla vintermånaderna.",
            chapters: 3,
            difficulty: .intermediate,
            language: .swedish,
            type: .basic,
            level: 8,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se5",
            title: "Kungens Hemlighet",
            description: "Avslöja den mörka hemligheten som gömmer sig i det svenska kungahuset.",
            chapters: 4,
            difficulty: .advanced,
            language: .swedish,
            type: .branching,
            level: 10,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se6",
            title: "En Sommardag på Gotland",
            description: "Följ med på en avkopplande sommardag på den vackra ön Gotland.",
            chapters: 2,
            difficulty: .beginner,
            language: .swedish,
            type: .basic,
            level: 5,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se7",
            title: "Det Förbjudna Biblioteket",
            description: "En mystisk berättelse om ett hemligt bibliotek fullt av förbjuden kunskap.",
            chapters: 1,
            difficulty: .intermediate,
            language: .swedish,
            type: .podcast,
            level: 8,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se8",
            title: "Skärgårdens Hemlighet",
            description: "Upptäck de dolda skatterna i den svenska skärgården.",
            chapters: 3,
            difficulty: .beginner,
            language: .swedish,
            type: .basic,
            level: 6,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se9",
            title: "Vägen till Fjällen",
            description: "En inspirerande resa genom de svenska fjällen och dess kultur.",
            chapters: 3,
            difficulty: .advanced,
            language: .swedish,
            type: .branching,
            level: 11,
            dateCreated: Date(),
            dateModified: Date()
        ),
        DBStory(
            id: "se10",
            title: "Möte i Mörkret",
            description: "En spökhistoria som utspelar sig i en avlägsen svensk by.",
            chapters: 2,
            difficulty: .intermediate,
            language: .swedish,
            type: .podcast,
            level: 7,
            dateCreated: Date(),
            dateModified: Date()
        )
    ]
}
