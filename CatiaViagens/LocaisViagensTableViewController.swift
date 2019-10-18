
import UIKit

class LocaisViagensTableViewController: UITableViewController {
    
    var locaisViagens: [ Dictionary< String, String>] = []
    var controleNavegacao = "adicionar"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //locaisViagens = ArmazenamentoDados().listarViagens()
    
    }

    override func viewDidAppear(_ animated: Bool) {
        controleNavegacao = "adicionar"
        atualizarViagens()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locaisViagens.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viagens = locaisViagens[indexPath.row]["local"]
        let celulaReuso = "celulaReuso"
        let cell = tableView.dequeueReusableCell(withIdentifier: celulaReuso, for: indexPath)
        cell.textLabel?.text = viagens
       

        return cell
    }
        // metodo p remover
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle , forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            ArmazenamentoDados().removerViagens( indice: indexPath.row )
            atualizarViagens()
        }
    }
    //mostrar celula clicada e direcionar p tela seguinte
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.controleNavegacao = "listar"
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verLocal"{
            
            let viewControllerDestino = segue.destination as! ViewController
            
            if self.controleNavegacao == "listar"{
                if let indiceRecuperado = sender {
                    
                    if let indiceReuperado = sender {
                        let indice = indiceReuperado as! Int
                        viewControllerDestino.viagem = locaisViagens[indice]
                        viewControllerDestino.indiceSelecionado = indice
                    }
                    
                }else{
                    
                    viewControllerDestino.viagem = [:]
                    viewControllerDestino.indiceSelecionado = -1
                }
            }
            
        }
    }
    
    func atualizarViagens(){
        locaisViagens = ArmazenamentoDados().listarViagens()
        tableView.reloadData()
    }

    


}
