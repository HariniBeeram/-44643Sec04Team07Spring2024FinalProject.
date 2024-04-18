//
//  FoodItemModel.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/17/24.
//

import Foundation
import Firebase
struct FoodItem {
    var id: String
    var type: String
    var name: String
    var price: Int
    var imgUrl: String
    var description: String
    init() {
              self.id = ""
              self.type = ""
              self.name = ""
              self.price = 0
              self.imgUrl = ""
              self.description = ""
          }
    init?(data: [String: Any]) {
        guard let foodId = data["id"] as? String ?? data["foodId"] as? String,
              let foodType = data["type"] as? String ?? data["foodType"] as? String,
              let name = data["name"] as? String,
              let priceString = data["price"] as? String, // Assuming price is stored as String
                  let price = Int(priceString),
                let pictureURL = data["imgUrl"] as? String ?? data["imgURL"] as? String,
             let description = data["description"] as? String
              else {
            return nil
        }
   
        
        self.id = foodId
        self.type = foodType
        self.name = name
        self.price = price
        self.imgUrl = pictureURL
        self.description = description
    }
}

class DataManager {
    static let shared = DataManager()
    
    private init() {}
    
    var mainCourseItems: [FoodItem] = []
    var appetizersItems: [FoodItem] = []
    var beveragesItems: [FoodItem] = []
    
    func fetchFoodItems() async {
        let db = Firestore.firestore()
        
        do {
            let querySnapshot = try await db.collection("restaurant").getDocuments()
            
            for document in querySnapshot.documents {
                var trimmedData: [String: Any] = [:]
                
                // Trim keys of document data
                for (key, value) in document.data() {
                    let trimmedKey = key.trimmingCharacters(in: .whitespaces)
                    trimmedData[trimmedKey] = value
                }
                
                
                guard let foodItem = FoodItem(data: trimmedData) else {
                    print(FoodItem(data: trimmedData) ?? "test")
                    print("Failed to create FoodItem from document data: \(trimmedData)")
                    continue
                }
                
                switch foodItem.type {
                case "mainCourse":
                    mainCourseItems.append(foodItem)
                case "appetizers":
                    appetizersItems.append(foodItem)
                case "beverages":
                    beveragesItems.append(foodItem)
                default:
                
                    print("Unknown food type: \(foodItem.id)  : \(foodItem.type)")
                }
            }
        } catch {
            print("Error fetching food items: \(error.localizedDescription)")
        }
    }
}
