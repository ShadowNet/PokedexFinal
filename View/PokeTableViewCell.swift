//
//  PokeTableView.swift
//  PokedexFinal
//
//  Created by Redghy on 5/6/22.
//

import UIKit
//cell will have a pokemonImageView image object, a nameLabel which shows the pokemon name data, and typeLabel that shows the type of the pokemon. ALl my label properties are adjusted programatically.
class PokeTableViewCell: UITableViewCell {
    
    static let reuseId = "\(PokeTableViewCell.self)"
   //defining view characteristics of the cell
    lazy var pokemonImageView:UIImageView = {
        let img = UIImageView(frame: .zero)
        img.contentMode = .scaleAspectFill //the image will stay at a fixed position.
        img.translatesAutoresizingMaskIntoConstraints = false // thus will enable the autolayout feature.
        img.contentMode = .scaleAspectFit
        img.backgroundColor = .red
        img.image = UIImage(named: "")
        return img
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pokemon name"
        label.font = UIFont(name:"Pokemon",size:25)
        label.textColor = .black
        //label.text?.capitalized
        return label
    }()
    
    lazy var typeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor =  UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Types: "
        label.textColor = .black
        label.font = UIFont(name:"Pokemon.ttf", size: 15.0)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    
    lazy var Manager = networkManager() //the network class object is initialized
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //The cell is configured with the cell elements, The pokemon image, pokemon nameLabel and pokemon typeLabel are added to the cell of table view. The UI elements, image, and labels are added onto a stackview and The image is added to a horizontal stack view.The lables are then added to a vertical stack like name on top of type. Finally The constrainsts are set.
    func setupCell(){
        self.contentView.backgroundColor = .white //Setting background of cell as white
        self.contentView.addSubview(self.pokemonImageView)
        
        let vStackLeft = UIStackView(frame: .zero)
        vStackLeft.translatesAutoresizingMaskIntoConstraints = false
        vStackLeft.axis = .vertical
        vStackLeft.spacing = 8
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        
        vStackLeft.addArrangedSubview(topBuffer)
        vStackLeft.addArrangedSubview(self.pokemonImageView)
        vStackLeft.addArrangedSubview(bottomBuffer)
        
        let vStackRight = UIStackView(frame: .zero)
        vStackRight.translatesAutoresizingMaskIntoConstraints = false
        vStackRight.axis = .vertical
        vStackRight.spacing = 8
        vStackRight.distribution = .fillProportionally
        
        vStackRight.addArrangedSubview(self.nameLabel)
        vStackRight.addArrangedSubview(self.typeLabel)
        
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 20
        
        hStack.addArrangedSubview(vStackLeft)
        hStack.addArrangedSubview(vStackRight)
        
        self.contentView.addSubview(hStack)
        
        hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
        hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        
        self.pokemonImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.pokemonImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        topBuffer.heightAnchor.constraint(equalTo: bottomBuffer.heightAnchor).isActive = true
        
    }
    //configure block is defined,
    
    func configure(pokeLink: basicData, completion: @escaping (pokeModel) -> Void){
        self.reset()
        var title = ""
        self.nameLabel.text = pokeLink.name
        self.Manager.pokemonAttributes(url_string: pokeLink.url){[weak self] result in
            switch result {
            case .success(let poke):
                for type in poke.types {
                    title += type.type.name + " "
                }
                
                guard let pic_link = poke.sprites.front_default else {
                    return
                }

                self?.Manager.pokeImage(url_string: pic_link){ [weak self]
                    result in
                    
                    switch result {
                    case .success(let pic):
                        ImageCache.shared.setImageData(key: pic_link, data: pic)
                        DispatchQueue.main.async {
                            self?.pokemonImageView.image = UIImage(data: pic)
                            self?.typeLabel.text! += " " + title
                        }
                        completion(poke)
                    case .failure(let err):
                        print(err)
                    }
                    
                }
                
            case .failure(let err):
                print(err)
            }
        }
        
    }
   // reset method defination
    //This method will reset the cell's UI elements data with default values like "Pokemon Name", "Type:" , and default image.
    private func reset() {
        self.pokemonImageView.image = UIImage(named: "")
        self.nameLabel.text = "Pokemon Name"
        self.typeLabel.text = "Type:"
        self.backgroundColor = .systemRed
    }

}
