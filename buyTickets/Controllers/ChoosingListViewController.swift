//
//  ChoosingListViewController.swift
//  buyTickets
//
//  Created by Alex on 29/05/2022.
//

import UIKit
import PMAlertController

protocol ChoosingListManagerDelegate: AnyObject {
    func showErrorMessage(message: String)
    func updateTableView()
}

//MARK: - Choosing List functions
extension ChoosingListViewController: ChoosingListManagerDelegate {
    func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            let ac = PMAlertController(title: "Fail", description: message, image: nil, style: .alert)
            ac.addAction(PMAlertAction(title: "OK", style: .default, action: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - SearchBar functions
extension ChoosingListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if listManager.identifier == K.ListType.Destination || listManager.identifier == K.ListType.Departure {
            listManager.filteredData = searchText.isEmpty ? listManager.airports : listManager.airports?.filter { (item: Any) -> Bool in
                if let item = item as? Airport {
                    return item.Airport_name!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || item.countryName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }else if let item = item as? Route {
                    return item.DateTimeOfDeparture!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                return true
            }
        }else {
            listManager.filteredData = searchText.isEmpty ? listManager.routes : listManager.routes?.filter { (item: Any) -> Bool in
                if let item = item as? Airport {
                    return item.Airport_name!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }else if let item = item as? Route {
                    return item.DateTimeOfDeparture!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
                return true
            }
        }
        
        tableView.reloadData()
    }
}

//MARK: - Help functions
extension ChoosingListViewController {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = #colorLiteral(red: 0.2052094638, green: 0.411657393, blue: 0.7065321803, alpha: 1)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 40)
        messageLabel.sizeToFit()

        self.tableView.backgroundView = messageLabel
        self.tableView.separatorStyle = .none
    }
    
    func restore() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
    }

}

//MARK: - TableView functions
extension ChoosingListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = listManager.filteredData?.count {
            if count == 0 {
                setEmptyMessage("No Results.")
            }else {
                restore()
            }
            return count
        }else {
            setEmptyMessage("No Results.")
        }
        
        return listManager.filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionToChoose", for: indexPath)
        var content = cell.defaultContentConfiguration()
        if listManager.identifier == K.ListType.Dates {
            if let route = listManager.filteredData?[indexPath.row] as? Route {
                content.text = route.DateTimeOfDeparture
            }
        }else {
            if let airport = listManager.filteredData?[indexPath.row] as? Airport {
                content.text = airport.Airport_name
                content.secondaryText = airport.countryName
            }
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parentVC = self.parentController {
            if let parentVC = parentVC as? BookingTicketsViewController {
                if listManager.identifier == K.ListType.Departure {
                    if let airport = listManager.filteredData?[indexPath.row] as? Airport {
                        parentVC.bookingManager.selectedDeparturePlace = airport
                        parentVC.departureField.text = airport.Airport_name! + " - " + airport.countryName!
                    }
                }else if listManager.identifier == K.ListType.Destination {
                    if let airport = listManager.filteredData?[indexPath.row] as? Airport {
                        parentVC.bookingManager.selectedDistanationPlace = airport
                        parentVC.destinationField.text = airport.Airport_name! + " - " + airport.countryName!
                    }
                }else {
                    if let route = listManager.filteredData?[indexPath.row] as? Route {
                        parentVC.bookingManager.selectedRoute = route
                        parentVC.datesField.text = route.DateTimeOfDeparture
                        let parametrs = "flightID=\(route.ID!)"
                        parentVC.bookingManager.performRequest(parametrs: parametrs)
                        parentVC.seatPicker.isHidden = false
                    }
                }
                self.dismiss(animated: true)
            }
        }
    }
}

class ChoosingListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var listManager = ChoosingListManager()
    var parentController: UIViewController? 

    override func viewDidLoad() {
        super.viewDidLoad()
        listManager.delegate = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        
        let tableViewTap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableViewTap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tableViewTap)
        
        listManager.downloadData()
    }
    
    @objc func tableViewTapped() {
        searchBar.endEditing(true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
