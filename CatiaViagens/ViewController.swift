

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapaLabel: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var viagem: Dictionary<String, String> = [:]
    var indiceSelecionado: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let indice = indiceSelecionado{
            
            if indice == -1 {  //adicionar
                
                configuraGerenciadorLocalizacao()
                
            }else{              // listar
                exibirAnotacao(viagem: viagem)
            }
        }
        
        //reconhecedor gesto
        let reconhecedorGesto = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:) ))
        reconhecedorGesto.minimumPressDuration = 2
        mapaLabel.addGestureRecognizer(reconhecedorGesto)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let local = locations.last!
        
        let localizacao = CLLocationCoordinate2DMake(local.coordinate.latitude, local.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: span)
        
        self.mapaLabel.setRegion(regiao, animated: true)
        
    }
    
    func exibirLocal(latitude: Double, longitude: Double){
        let localizacao = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: span)
        
        self.mapaLabel.setRegion(regiao, animated: true)    }
    
    func exibirAnotacao(viagem: Dictionary<String, String>){
        
        if let localViagem = viagem ["local"] {
            if let latitudeS = viagem ["latitude"]{
                if let longitudeS = viagem ["longitude"]{
                    if let latitude = Double(latitudeS){
                        if let longitude = Double(longitudeS){
                            
                           
                            // adiciona anotacao
                            let anotacao = MKPointAnnotation()
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            
                            self.mapaLabel.addAnnotation(anotacao)
                            
                         exibirLocal(latitude: latitude, longitude: longitude)
                            
                            
                            
                        }
                    }
                }
            }
        }
                        
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
                    
                    // SALVAR DADOS NO DISPOSITIVO
                    self.viagem = ["local":localCompleto, "latitude": String(coordenadas.latitude), "longitude":String(coordenadas.longitude)]
                    ArmazenamentoDados().salvarViagens(viagem: self.viagem)
                    
                    
                    //EXIBE ANOTACAO C DADOS DE ENDERECO
                    self.exibirAnotacao(viagem: self.viagem)
                    
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

