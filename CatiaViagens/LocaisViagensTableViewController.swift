
import UIKit

class LocaisViagensTableViewController: UITableViewController {
    
    var locaisViagens: [ Dictionary< String, String>] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //locaisViagens = ArmazenamentoDados().listarViagens()
    
    }

    override func viewDidAppear(_ animated: Bool) {
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
    
    func atualizarViagens(){
        locaisViagens = ArmazenamentoDados().listarViagens()
        tableView.reloadData()
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
