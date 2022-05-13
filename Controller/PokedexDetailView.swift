//
//  PokedexDetailView.swift
//  PokedexFinal
//
//  Created by Redghy on 5/6/22.
//


import UIKit

class PokemonDetailViewController: UIViewController {
    
    
    
  lazy var pokemonImageView1:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        img.image = UIImage(named: "")
        return img
    }()
    
   lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pokemon name"
        label.textAlignment = .center
        label.font = UIFont(name:"Pokemon.ttf", size: 20.0)
        label.textColor = .black
        return label
    }()
    
    lazy var pokeAbilities:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pokemon types"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name:"Courier", size: 15.0)
        label.textColor = .black
        return label
    }()
    
    lazy var pokeMoves:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Type"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name:"Courier", size: 15.0)
        label.textColor = .black
        return label
    }()
    
    lazy var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor =  UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Write a full Description about the given pokemon "
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name:"Pokemon.ttf", size: 15.0)
        label.textColor = .black
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.translatesAutoresizingMaskIntoConstraints = false
      return scrollView
    }()
    
//    lazy override var navigationItem:UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name:"Pokemon.ttf", size: 15)
//
//    }()
    var pokeData: pokeModel?
    
    override func viewDidLoad() {
        

//
//                    let backbutton = UIButton(type: .custom)
//                    backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal)
//                    backbutton.setTitle("Back", for: .normal)
//                    backbutton.setTitleColor(backbutton.tintColor, for: pokeData.normal)
//                    backbutton.addTarget(self, action: Selector(("backAction")), for: .touchUpInside)
//
//                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
//                }
//
//                func backAction() -> Void {
//                    self.navigationController?.popViewController(animated: true)
//                }

        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        guard let img_url = pokeData?.sprites.front_default else {
            return
        }
        
        guard let name = self.pokeData?.name else {
            return
        }
        self.nameLabel.text = name
        self.set_image(img_url: img_url)
        self.setDetails()
        self.pokemonMoves()
        self.pokemonAbilities()

        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 4
        
        let topBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)
        let bottomBuffer = UIView(resistancePriority: .defaultLow, huggingPriority: .defaultLow)

        vStack.addArrangedSubview(topBuffer)
        vStack.addArrangedSubview(self.nameLabel)
        vStack.addArrangedSubview(self.pokemonImageView1)
        vStack.addArrangedSubview(self.descriptionLabel)
        vStack.addArrangedSubview(self.pokeMoves)
        vStack.addArrangedSubview(self.pokeAbilities)
        vStack.addArrangedSubview(bottomBuffer)
        
        self.scrollView.addSubview(vStack)
        self.view.addSubview(self.scrollView)
        
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true

        vStack.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        vStack.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        vStack.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        vStack.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true

        self.pokemonImageView1.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.pokemonImageView1.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func set_image(img_url: String){
        guard let img = ImageCache.shared.getImageData(key: img_url) else {
            return
        }
        
        self.pokemonImageView1.image = UIImage(data:img)
        
        
    }
    
    private func setDetails(){
        var type_string = ""
        guard let name = pokeData?.name else{
            return
        }
        
        guard let height = pokeData?.height else{
            return
        }
        
        guard let weight = pokeData?.weight else{
            return
        }
        
        guard let types = pokeData?.types else {
            return
        }
        
        for type in types {

            if type.type.name == types.last!.type.name{
                type_string += type.type.name
                continue
            }
            
            type_string += type.type.name + ", "
        }
        
        let text = "The pokemon \(name) is of type \(type_string).  The average height of \(name) is \(height) with a average weight \(weight)."
        self.descriptionLabel.text = text
    }
    
    private func pokemonMoves(){
        var text = "\nMoves: \n\n"
        guard let moves = pokeData?.moves else{
            return
        }
        
        for i in 0..<moves.count {
            if i%3 == 0 && i != 0{
                text += moves[i].move.name + ",\n"
                continue
            }
            
            if i == moves.count - 1 {
                text += moves[i].move.name
                continue
            }
            
            text += moves[i].move.name + ", "
        }
        
        self.pokeMoves.text = text
    }
    
    private func pokemonAbilities(){
        var text = "\nAbilities: \n\n"
        guard let ability = pokeData?.abilities else{
            return
        }
        
        for i in 0 ..< ability.count {
            if i%3 == 0 && i != 0 {
                text += ability[i].ability.name + ",\n"
                continue
            }
            
            if i == ability.count - 1 {
                text += ability[i].ability.name
                continue
            }
            
            text += ability[i].ability.name + ", "
        }
        
        self.pokeAbilities.text = text
    }
    

}
