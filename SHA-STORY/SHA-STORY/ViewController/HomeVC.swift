//
//  HomeVC.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 4/13/24.
//

import UIKit
import SDWebImage
class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    private let reuseIdentifier = "foodItemCell"
    private let insetSize = CGFloat(1.5)

    var menuItems: [FoodItem] = []

    let shared = DataManager.shared
    var appetizers:[FoodItem] = []
    var mainCourse:[FoodItem] = []
    var beverages:[FoodItem] = []
    var fooditem = FoodItem()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return appetizers.count
        case 1:
            return mainCourse.count
        case 2:
            return beverages.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodItemCell", for: indexPath)
        
        
        switch indexPath.section {
        case 0:
            fooditem.id = appetizers[indexPath.row].id
            fooditem.imgUrl = appetizers[indexPath.row].imgUrl
            fooditem.name = appetizers[indexPath.row].name
            fooditem.type = appetizers[indexPath.row].type
            fooditem.price = appetizers[indexPath.row].price
            fooditem.description = appetizers[indexPath.row].description
        case 1:
            fooditem.id = mainCourse[indexPath.row].id
            fooditem.imgUrl = mainCourse[indexPath.row].imgUrl
            fooditem.name = mainCourse[indexPath.row].name
            fooditem.type = mainCourse[indexPath.row].type
            fooditem.price = mainCourse[indexPath.row].price
            fooditem.description = mainCourse[indexPath.row].description
        case 2:
            fooditem.id = beverages[indexPath.row].id
            fooditem.imgUrl = beverages[indexPath.row].imgUrl
            fooditem.name = beverages[indexPath.row].name
            fooditem.type = beverages[indexPath.row].type
            fooditem.price = beverages[indexPath.row].price
            fooditem.description = beverages[indexPath.row].description
        default:
            break
        }
        
        guard let categoryCell = cell as? FoodCategoryCell else {return cell}
        categoryCell.foodItem.text =  fooditem.name
        categoryCell.foodPrice.text = String(fooditem.price)
        if let url = URL(string: fooditem.imgUrl){
            categoryCell.foodPicture.sd_setImage(with: url,placeholderImage: UIImage(named:"placeholder"))
        }
        
        return categoryCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        Task {
            await fetchFoodItems()
            
        }
        
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFoodDesc", sender: self)
    }
    private func fetchFoodItems() async {
        await shared.fetchFoodItems()
        appetizers = shared.appetizersItems
        mainCourse = shared.mainCourseItems
        beverages = shared.beveragesItems
        
        self.collectionView.collectionViewLayout = self.layout()
        collectionView.reloadData()
        collectionView.reloadSections(IndexSet(integersIn: 0..<collectionView.numberOfSections))
      
        
    }
    func getLayout(for section: Int)-> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: insetSize, leading: insetSize, bottom: insetSize, trailing: insetSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(self.collectionView.bounds.width), heightDimension: .fractionalHeight(0.33))
        var count: Int = 0
        switch section {
               case 0:
                   count =  appetizers.count
               case 1:
                   count =  mainCourse.count
               case 2:
                   count = beverages.count
               default:
                   count = 0
               }
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: count)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(insetSize*4.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = insetSize*2.0
        section.contentInsets = NSDirectionalEdgeInsets(top: insetSize, leading: insetSize, bottom: insetSize, trailing: insetSize)
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        return section
    }
    
    func layout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment:NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            
            switch sectionIndex {
            case let x:
                return self.getLayout(for: x)
            }
            
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        config.contentInsetsReference = .automatic
        config.interSectionSpacing = insetSize * 2.0
        return layout
    }
    
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath)
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = headerView as? headerCell else{
                return headerView
            }
            switch indexPath.section{
            case 0:
                headerView.headerLbl.text = "Appetizers"
            case 1:
                headerView.headerLbl.text = "Main Course"
            case 2:
                headerView.headerLbl.text = "Beverages"
            default:
                headerView.headerLbl.text = "Food"
            }
            return headerView
        default:
            assert(false,"Invalid element type")
        }
        return headerView
    }
    
    
    func supplementaryHeaderItem()-> NSCollectionLayoutBoundarySupplementaryItem{
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(10)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
