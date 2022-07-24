//
//  OptionsViewController.swift
//  AR.PutterFitter
//
//  Created by Andrew Rotert on 7/23/22.
//

import UIKit
import IGListKit
import SnapKit

class OptionsViewController: UIViewController {

    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Putter Fitter"
        label.textColor = .textColor
        label.font = FontHelper.regularFont(size: 26)
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return collectionView
    }()
    
    private lazy var adapter: ListAdapter = {
        return ListAdapter(
        updater: ListAdapterUpdater(),
        viewController: self,
        workingRangeSize: 0)
      }()
    
    private var fittingData: [FittingCharacteristic]?
    private var index: Int = 0
    
    private var objects: [ListDiffable] = [ListDiffable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .backgroundColor
    
        self.title = titleLabel.text
        self.navigationItem.titleView = titleLabel
        
        adapter.collectionView = self.collectionView
        adapter.dataSource = self
        
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        self.start()
    }
    
    private func start() {
        self.fittingData = FittingData.GetCharacteristicOptions()
        self.index = 0
        self.showCharacteristic(index: self.index)
    }
    
    private func showCharacteristic(index: Int) {
        self.objects.removeAll()
        
        self.objects.append(BannerAdDiffable(rootViewController: self))
        self.objects.append(ProgressDiffable(progress: Float(integerLiteral: Int64(index)) / Float(max(fittingData?.count ?? 0, 1)), count: "\(index+1) of \(self.fittingData?.count ?? 0)"))
        
        guard index >= 0 && index < self.fittingData?.count ?? 0 else {
            return
        }
        
        for section in self.getSections(characteristic: self.fittingData![index]) {
            self.objects.append(section)
        }
        
        if index > 0 {
            self.objects.append(ButtonDiffable(buttonText: "Go Back"))
        }
        
        self.adapter.performUpdates(animated: false)
        self.adapter.reloadData()
    }
    
    private func showLoading() {
        self.objects.removeAll()
        
        self.objects.append(BannerAdDiffable(rootViewController: self))
        self.objects.append(ProgressDiffable(progress: Float(integerLiteral: Int64(index)) / Float(max(fittingData?.count ?? 0, 1)), count: "loading"))
        
        self.objects.append(LoadingDiffable())
        
        self.loadData()
        
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadData()
    }
    
    private func showResults(results: [ResultsDiffable]) {
        self.objects.removeAll()
        
        self.objects.append(BannerAdDiffable(rootViewController: self))
        self.objects.append(ProgressDiffable(progress: Float(integerLiteral: Int64(index)) / Float(max(fittingData?.count ?? 0, 1)), count: "completed"))
        
        self.objects.append(LabelDiffable(text: "3 Results - (83.33% Match)"))

        for result in results {
            self.objects.append(result)
        }
        
        self.objects.append(ButtonDiffable(buttonText: "Restart"))
        
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadData()
    }
    
    private func next() {
        self.index += 1

        if self.index < (self.fittingData?.count ?? 0) {
            self.showCharacteristic(index: index)
        } else {
            self.showLoading()
        }
    }
    
    private func back() {
        self.index -= 1

        if self.index < (self.fittingData?.count ?? 0) {
            self.showCharacteristic(index: index)
        } else {
            self.showLoading()
        }
    }
    
    private func restart() {
        self.index = 0
        
        if self.index < (self.fittingData?.count ?? 0) {
            self.showCharacteristic(index: index)
        } else {
            self.showLoading()
        }
    }
    
    private func loadData() {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: NSURL(string: "https://www.scottycameron.com/media/17454/product_pages__0009_2020-select-newport-2-back.jpg")! as URL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        
                        if let self = self {
                            self.showResults(results: [
                                ResultsDiffable(manufacturerText: "Scotty Cameron", modelText: "Newport 2", putterImage: image),
                                ResultsDiffable(manufacturerText: "Scotty Cameron", modelText: "Newport 2", putterImage: image),
                                ResultsDiffable(manufacturerText: "Scotty Cameron", modelText: "Newport 2", putterImage: image)
                            ])
                        }
                        
                    }
                }
            }
        }
    }
    
    private func getSections(characteristic: FittingCharacteristic) -> [ListDiffable] {
        var sections = [ListDiffable]()
        sections.append(OptionTitleDiffable(title: characteristic.title))
        
        for option in characteristic.options {
            sections.append(OptionDiffable(option: option.name, icon: option.icon))
        }
        
        return sections
    }
}
extension OptionsViewController : ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any)
    -> ListSectionController {
        
        if object is OptionDiffable {
            return OptionSectionController(delegate: self)
        } else if object is ProgressDiffable {
            return ProgressSectionController()
        } else if object is OptionTitleDiffable {
            return OptionTitleSectionController()
        } else if object is BannerAdDiffable {
            return BannerAdSectionController()
        } else if object is LoadingDiffable {
            return LoadingSectionController()
        } else if object is ButtonDiffable {
            return ButtonSectionController(delegate: self)
        } else if object is LabelDiffable {
            return LabelSectionController()
        } else if object is ResultsDiffable {
            return ResultSectionController(delegate: self)
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
extension OptionsViewController : OptionSectionControllerDelegate {
    func optionSelected() {
        self.next()
    }
}
extension OptionsViewController : ButtonSectionControllerDelegate {
    func buttonSelected(buttonText: String) {
        if buttonText == "Restart" {
            self.restart()
        } else {
            self.back()
        }
    }
}
extension OptionsViewController : ResultSectionControllerDelegate {
    func resultSelected() {
        
    }
}
