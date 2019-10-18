

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapaLabel: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuraGerenciadorLocalizacao()
        
        let reconhecedorGesto = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:) ))
        reconhecedorGesto.minimumPressDuration = 2
        mapaLabel.addGestureRecognizer(reconhecedorGesto)
        
    }
    @objc func marcar(gesture: UIGestureRecognizer){
        // captura o estado inicial
        if gesture.state == UIGestureRecognizer.State.began{
       
            //RECUPERA AS COORDENADAS DO PONTO SELECIONADO
            let pontoSelecionado = gesture.location(in: self.mapaLabel)
            let coordenadas = mapaLabel.convert(pontoSelecionado, toCoordinateFrom: self.mapaLabel)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            // REDUPERAR ENDERECO DO PONTO SELECIONADO
          
            var localCompleto = "Endereco nao encontrado!!"
            
            CLGeocoder().reverseGeocodeLocation(localizacao) { (local, erro) in
                if erro == nil{
                    if let dadosLocal = local?.first{
                        if let nome = dadosLocal.name{
                            localCompleto = nome
                        }else{
                            if let endereco = dadosLocal.thoroughfare{
                                localCompleto = endereco
                            }
                        }
                        
                    }
                     //EXIBE ANOTACAO C DADOS DE ENDERECO
                               let anotacao = MKPointAnnotation()
                               anotacao.coordinate.latitude = coordenadas.latitude
                               anotacao.coordinate.longitude = coordenadas.longitude
                               anotacao.title = localCompleto
                              
                    self.mapaLabel.addAnnotation(anotacao)
                    
                }else{
                    print(erro)
                }
            }
            
           
        }
    }
    func configuraGerenciadorLocalizacao(){
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            
            let alertaController = UIAlertController(title: "Permissao de Localizacao",
                                                     message: "Necessario a permissao para acesso a sua localizacao,por favor habilite.", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configuracoes", style: .default, handler: {(alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open( configuracoes as URL)
                }
            })
        }
    }
}

