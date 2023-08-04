//
//  PulsaView.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 8/4/23.
//

import UIKit
import SkyFloatingLabelTextField

protocol PulsaViewDelegate: AnyObject {
    func textFieldDidChange(text: String)
    func onClickedPulsa(pulsa: PulsaItem)
    func onClickedPromo(promo: VoucherItem)
}

class PulsaView: UIView {
    
    static let identifier = "PulsaView"
    
    // Outlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageOperator: UIImageView!
    @IBOutlet weak var containerTextfieldPhone: UIView!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var viewSeparatorPulsa: UIView!
    @IBOutlet weak var cvPulsa: UICollectionView!
    @IBOutlet weak var consCvPulsaHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPromos: UILabel!
    @IBOutlet weak var cvPromos: UICollectionView!
    
    weak var phoneTextfield: SkyFloatingLabelTextField?
    weak var delegate: PulsaViewDelegate?
    
    // Model
    var pulsa: [PulsaItem] = [] {
        didSet {
            viewSeparatorPulsa.isHidden = pulsa.isEmpty
            consCvPulsaHeight.constant = CGFloat(pulsa.count * 80)
            cvPulsa.reloadData()
        }
    }
    
    var promos: [VoucherItem] = [] {
        didSet {
            cvPromos.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(PulsaView.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Setup textfield phonenumber
        imageOperator.rounded()
        
        let textField = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 10, width: 200, height: 45))
        textField.placeholder = "Mobile number"
        textField.title = "Mobile number"
        textField.titleFormatter = { $0 }
        textField.keyboardType = .phonePad
        textField.lineColor = Asset.Color.grayAEAEAE.color
        textField.selectedLineColor = Asset.Color.grayAEAEAE.color
        textField.selectedTitleColor = Asset.Color.grayAEAEAE.color
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        containerTextfieldPhone.addSubview(textField)
        textField.edgesToSuperview()
        phoneTextfield = textField
        
        // Setup Pulsa section
        cvPulsa.delegate = self
        cvPulsa.dataSource = self
        cvPulsa.register(UINib(nibName: PulsaItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PulsaItemCollectionViewCell.identifier)
        
        // Setup Promos section
        lblPromos.text = "Promos"
        lblPromos.font = .systemFont(ofSize: 18, weight: .semibold)
        
        let height = 0.4 * UIScreen.main.bounds.width
        cvPromos.height(height)
        cvPromos.delegate = self
        cvPromos.dataSource = self
        cvPromos.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cvPromos.register(UINib(nibName: PromoItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PromoItemCollectionViewCell.identifier)
    }
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if text.count > 3 {
                imageOperator.image = Asset.Logo.telkomsel.image
            } else {
                imageOperator.image = nil
            }
            
            delegate?.textFieldDidChange(text: text)
        }
    }
    
}

extension PulsaView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvPulsa {
            return pulsa.count
        } else if collectionView == cvPromos {
            return promos.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == cvPulsa {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PulsaItemCollectionViewCell.identifier, for: indexPath) as? PulsaItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.pulsa = pulsa[indexPath.item]
            cell.delegate = self
            cell.separator.isHidden = indexPath.item == pulsa.count - 1
            
            return cell
        } else if collectionView == cvPromos {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoItemCollectionViewCell.identifier, for: indexPath) as? PromoItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.promo = promos[indexPath.item]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cvPromos {
            guard indexPath.item < promos.count else { return }
            
            let promo = promos[indexPath.item]
            delegate?.onClickedPromo(promo: promo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvPulsa {
            return CGSize(width: UIScreen.main.bounds.width, height: 80)
        } else if collectionView == cvPromos {
            let width = 0.8 * UIScreen.main.bounds.width
            let height = width / 2
            return CGSize(width: width, height: height)
        }
        
        return .zero
    }
    
}

extension PulsaView: PulsaItemDelegate {
    
    func onClickPulsa(pulsa: PulsaItem) {
        delegate?.onClickedPulsa(pulsa: pulsa)
    }
    
}
