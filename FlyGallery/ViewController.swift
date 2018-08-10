//
//  ViewController.swift
//  FlyGallery
//
//  Created by Ada 2018 on 25/07/2018.
//  Copyright © 2018 Ada 2018. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {

    
    @IBOutlet weak var smileBox: UIImageView!
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var houseBox: UIView!
    
    var dynamicAnimator: UIDynamicAnimator!
    var snapBehavior: UISnapBehavior!
    var collider: UICollisionBehavior!
    var colliderBounds: UICollisionBehavior!
    var ballBehavior: UIDynamicItemBehavior!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // configurando tamanho e cor da houseBox
        houseBox.layer.borderWidth = 5
        houseBox.layer.borderColor = UIColor.gray.cgColor
        
        // tornando view da ball circular
        ball.clipsToBounds = true
        ball.layer.cornerRadius = ball.frame.height / 2
        
        // Desativa a interacao com toques do usuario na houseBox
        houseBox.isUserInteractionEnabled = false
        

        // Prepara o DynamicAnimator e o SnapBehavior
        // Para ancorar a smileBox no centro da tela
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        snapBehavior = UISnapBehavior(item: smileBox, snapTo: view.center)
        dynamicAnimator.addBehavior(snapBehavior)

        
        // Adiciona PanGesture para movimentar a smileBox
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pannedView))
        smileBox.addGestureRecognizer(panGesture)
        smileBox.isUserInteractionEnabled = true
        
        
        //Adicionando elasticidade a bola
        ballBehavior = UIDynamicItemBehavior(items: [ball])
        ballBehavior.elasticity = 0.6
        dynamicAnimator.addBehavior(ballBehavior)


        //Adicionando colisao entre o cupCake e os limites das Views na tela
        colliderBounds = UICollisionBehavior(items: [ball])
        colliderBounds.collisionMode = .boundaries
         colliderBounds.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(colliderBounds)

        //Adicionando colisao entre cupCake e smileBox
        collider = UICollisionBehavior(items: [ball, smileBox])
        collider.collisionDelegate = self
        collider.collisionMode = .items
        collider.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimator.addBehavior(collider)
        
        
    }
    
    
    // Acao executada pelo PanGesture
    @objc func pannedView(recognizer: UIPanGestureRecognizer){
        
        switch recognizer.state {
        case .began:
            dynamicAnimator.removeBehavior(collider)
            dynamicAnimator.removeBehavior(snapBehavior)
        case .changed:
            let translation = recognizer.translation(in: view)
            smileBox.center = CGPoint(x: smileBox.center.x + translation.x,
                                      y: smileBox.center.y + translation.y)
            
            recognizer.setTranslation(.zero, in: view)
            
             checkIntersectionWith(box: houseBox)
            
        case .ended, .cancelled, .failed:
            dynamicAnimator.addBehavior(collider)
            dynamicAnimator.addBehavior(snapBehavior)
        case .possible:
            break
        }
    }
    
    
    //Além de checar intercessao, a funcao adiciona animacao no translado da smileBox
    func checkIntersectionWith(box: UIView) {
        if box.frame.contains(smileBox.center) {
            
            snapBehavior.snapPoint = box.center
            let center = smileBox.center
            UIView.animate(withDuration: 0.5) {
                self.smileBox.frame.size = box.frame.size
                self.smileBox.center = center
            }
            
        } else {
            snapBehavior.snapPoint = view.center
            UIView.animate(withDuration: 0.5) {
                self.smileBox.frame.size = CGSize(width: 100, height: 100)
            }
        }
    }
    

}

