//
//  ViewController.swift
//  PokedexFinal
//
//  Created by Redghy on 5/6/22.
//


import UIKit
//View controller that sets the limit for the tableview , includes pagination and UI setup
class ViewController: UIViewController {
    
    lazy var PokeTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.backgroundColor = .systemRed
        table.register(PokeTableViewCell.self, forCellReuseIdentifier: PokeTableViewCell.reuseId)
        return table
    }()
    
    var pokeSet = 0
    var maxAmountOfPokemon = 120
    var pokemonList: [basicData] = []
    let NetworkManager = networkManager()
    var pokeAttr: [Int:pokeModel] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pokedex"
        setupUI()
        
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        view.addSubview(self.PokeTableView)
        
        setupTable()
        pokemonMaster()
    }
    
    func setupTable(){
        self.PokeTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.PokeTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        self.PokeTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        self.PokeTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func pokemonMaster() {
        self.NetworkManager.engagePokemon(poke_set: self.pokeSet){[weak self] result in
            switch result {
            case .success(let page):
                self?.pokemonList.append(contentsOf: page.results)
                DispatchQueue.main.async {
                    self?.PokeTableView.reloadData()
                }
                
            case .failure(let err):
                print("Error: \(err.localizedDescription)")
                self?.presentErrorAlert(title: "NetworkError", message: err.localizedDescription)
            }
            
        }
    }
}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokeTableViewCell.reuseId, for: indexPath) as? PokeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(pokeLink: self.pokemonList[indexPath.row]){
            result in
            if self.pokeAttr[indexPath.row] == nil{
                self.pokeAttr[indexPath.row] = result
            }
        }
        
        return cell
    }
   
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsView = PokemonDetailViewController()
        detailsView.pokeData = pokeAttr[indexPath.row]
        self.present(detailsView, animated: true)
    }
        
}
//pagination
extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        let lastIndexPath = IndexPath(row: self.pokemonList.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else { return }
        
        if self.pokeSet < maxAmountOfPokemon {
            self.pokeSet += 30
            self.pokemonMaster()
        }
        
    }
    
}
