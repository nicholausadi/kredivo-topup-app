//
//  ViewPager.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 8/4/23.
//

import UIKit

class ViewPager: UIView {
    
    // MARK: - Initialization
    init(tabSizeConfiguration: TabbedView.SizeConfiguration) {
        self.sizeConfiguration = tabSizeConfiguration
        super.init(frame: .zero)
        
        self.setupUI()
        
        tabbedView.delegate =  self
        pagedView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let sizeConfiguration: TabbedView.SizeConfiguration
    
    public lazy var tabbedView: TabbedView = {
        let tabbedView = TabbedView(
            sizeConfiguration: sizeConfiguration
        )
        return tabbedView
    }()
    
    private lazy var separator: UIView = {
        let line = UIView()
        line.backgroundColor = Asset.Color.grayDCDCDC.color
        line.height(1)
        
        return line
    }()
    
    public let pagedView = PagedView()
    
    // MARK: - UI Setup
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tabbedView)
        self.addSubview(separator)
        self.addSubview(pagedView)
        
        tabbedView.edgesToSuperview(excluding: .bottom)
        tabbedView.height(sizeConfiguration.height)
        
        separator.topToBottom(of: tabbedView)
        separator.leftToSuperview()
        separator.rightToSuperview()
        
        pagedView.edgesToSuperview(excluding: .top)
        pagedView.topToBottom(of: separator)
    }
}

extension ViewPager: TabbedViewDelegate {
    func didMoveToTab(at index: Int) {
        self.pagedView.moveToPage(at: index)
    }
}

extension  ViewPager: PagedViewDelegate {
    func didMoveToPage(index: Int) {
        self.tabbedView.moveToTab(at: index)
    }
}
