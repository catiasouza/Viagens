

import UIKit

class ArmazenamentoDados{
    
    let chaveArmazenamento = "locaisViagem"
    var viagens: [ Dictionary<String, String>] = []
    
    func getDefaults() -> UserDefaults{
        
        return UserDefaults.standard
    }
    
    func salvarViagens(viagem: Dictionary<String, String>){
        
        viagens = listarViagens()
        viagens.append(viagem)
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        getDefaults().synchronize()
    }
    func listarViagens() -> [ Dictionary<String, String>]{
        
        let dados = getDefaults().object(forKey: chaveArmazenamento)
        if dados != nil{
            return dados as! Array
        }else{
            return []
        }
    }
    func removerViagens(){
        
    }
}
