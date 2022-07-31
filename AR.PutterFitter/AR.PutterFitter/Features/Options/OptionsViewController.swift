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
    
    private var fittingDataOptions: [FittingCharacteristic]?
    private var index: Int = 0
    private var userWeights = UserWeights()
    private var service: PutterFittingService = RemotePutterFittingService(service: RemotePutterDataService())
    
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
        self.fittingDataOptions = FittingData.GetCharacteristicOptions()
        self.index = 0
        self.userWeights = UserWeights()
        self.showCharacteristic(index: self.index)
    }
    
    private func showCharacteristic(index: Int) {
        self.objects.removeAll()
        
        self.objects.append(BannerAdDiffable(rootViewController: self))
        self.objects.append(ProgressDiffable(progress: Float(integerLiteral: Int64(index)) / Float(max(fittingDataOptions?.count ?? 0, 1)), count: "\(index+1) of \(self.fittingDataOptions?.count ?? 0)"))
        
        guard index >= 0 && index < self.fittingDataOptions?.count ?? 0 else {
            return
        }
        
        for section in self.getSections(characteristic: self.fittingDataOptions![index]) {
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
        self.objects.append(ProgressDiffable(progress: Float(integerLiteral: Int64(index)) / Float(max(fittingDataOptions?.count ?? 0, 1)), count: "loading"))
        
        self.objects.append(LoadingDiffable())
        
        self.loadData()
        
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadData()
    }
    
    private func showResults(results: [ResultsDiffable], title: String) {
        self.objects.removeAll()
        
        self.objects.append(BannerAdDiffable(rootViewController: self))
        self.objects.append(ProgressDiffable(progress: Float(integerLiteral: Int64(index)) / Float(max(fittingDataOptions?.count ?? 0, 1)), count: "completed"))
        
        self.objects.append(LabelDiffable(text: title))

        for result in results {
            self.objects.append(result)
        }
        
        self.objects.append(ButtonDiffable(buttonText: "Restart"))
        
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadData()
    }
    
    private func showResultsError() {
        self.objects.removeAll()
        
        self.objects.append(BannerAdDiffable(rootViewController: self))
        self.objects.append(ProgressDiffable(progress: Float(integerLiteral: Int64(index)) / Float(max(fittingDataOptions?.count ?? 0, 1)), count: "completed"))
        
        self.objects.append(LabelDiffable(text: "Error finding matches, please try again later."))

        self.objects.append(ButtonDiffable(buttonText: "Restart"))
        
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadData()
    }
    
    private func next(selectedOption: String) {
        self.updateUserWeight(selectedOption: selectedOption, index: self.index)
        self.index += 1

        if self.index < (self.fittingDataOptions?.count ?? 0) {
            self.showCharacteristic(index: index)
        } else {
            self.showLoading()
        }
    }
    
    private func back() {
        self.updateUserWeight(selectedOption: "", index: self.index)
        self.index -= 1

        if self.index < (self.fittingDataOptions?.count ?? 0) {
            self.showCharacteristic(index: index)
        } else {
            self.showLoading()
        }
    }
    
    private func restart() {
        start()
    }
    
    private func loadData() {
        
        var results = [ResultsDiffable]()
        
        service.getMatches(userWeights: self.userWeights) { putterDataMatches, title in
            
            let group = DispatchGroup()
            
            for putterDataMatch in putterDataMatches {
                if let photoUrl = putterDataMatch.photoUrl, let url = URL(string: photoUrl) {
                    group.enter()
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url),
                           let image = UIImage(data: data) {
                            results.append(ResultsDiffable(manufacturerText: putterDataMatch.manufacturer, modelText: putterDataMatch.model, website: putterDataMatch.website, putterImage: image))
                        } else {
                            results.append(ResultsDiffable(manufacturerText: putterDataMatch.manufacturer, modelText: putterDataMatch.model, website: putterDataMatch.website, putterImage: UIImage(named: "MissingIcon")!))
                        }
                        group.leave()
                    }
                }

            }
            
            group.notify(queue: .main) {
                self.showResults(results: results, title: title)
            }
            
        } failure: { error in
            self.showResultsError()
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
    
    private func updateUserWeight(selectedOption: String, index: Int) {
        switch index {
        case 0: self.userWeights.selectedDominantOption = selectedOption; break
        case 1: self.userWeights.selectedPathOption = selectedOption; break
        case 2: self.userWeights.selectedAccuracyOption = selectedOption; break
        case 3: self.userWeights.selectedDistanceOption = selectedOption; break
        case 4: self.userWeights.selectedAlignmentOption = selectedOption; break
        default: break
        }
    }
    
    private func openUrl(website: String?) {
        if let website = website, let url = URL(string: website) {
            UIApplication.shared.open(url)
        }
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
    func optionSelected(selectedOption: String) {
        self.next(selectedOption: selectedOption)
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
    func resultSelected(website: String?) {
        openUrl(website: website)
    }
}
