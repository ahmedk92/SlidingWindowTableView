//
//  ViewController.swift
//  SlidingWindowTableView
//
//  Created by Ahmed Khalaf on 2/22/19.
//  Copyright © 2019 Ahmed Khalaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var initialIndex = 340
    
    private lazy var data = [Model(id: initialIndex)]
    
    @IBOutlet private weak var tableView: UITableView!
    
    private func firstNonNilText() {
        print(data.first(where: { $0.text != nil })!.id)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.data.insert(contentsOf: Array(0..<self.initialIndex).map({ Model(id: $0) }), at: 0)
            self.data.append(contentsOf: Array((self.initialIndex + 1)..<604).map({ Model(id: $0) }))
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: Array(0..<self.initialIndex).map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            self.tableView.insertRows(at: Array((self.initialIndex + 1)..<604).map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            self.tableView.endUpdates()
//        }
        
        tableView.scrollToRow(at: IndexPath(row: self.initialIndex, section: 0), at: .top, animated: true)
    }
}

class Cell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        cell.label.text = data[indexPath.row].text
        
        return cell
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for row in indexPaths.map({ $0.row }) {
            data[row].loadTextAsync()
        }
    }
}

