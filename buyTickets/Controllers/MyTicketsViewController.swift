//
//  MyTicketsViewController.swift
//  buyTickets
//
//  Created by Alex on 29/05/2022.
//

import UIKit
import DropDown
import PMAlertController

protocol MyTicketsManagerDelegate {
    func showErrorMessage(message: String)
    func updateList()
    func setEmptyMessage(_ message: String)
    func restore()
    func endRefreshing()
}

//MARK: - MyTicketsManagerDelegate functions

extension MyTicketsViewController: MyTicketsManagerDelegate {
    func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            let ac = PMAlertController(title: "Fail", description: message, image: nil, style: .alert)
            ac.addAction(PMAlertAction(title: "OK", style: .default, action: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func updateList() {
        DispatchQueue.main.async {
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { () -> Void in
                                self.tableView.reloadData()
                              },
                              completion: nil);
        }
    }
    
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
    
    func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

//MARK: - SearchBar functions
extension MyTicketsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            myTicketsManager.filteredData = myTicketsManager.tickets?.filter { (item: Ticket) -> Bool in
                return doesFulfilllConditions(of: myTicketsManager.selectedTicketType!, ticket: item)
            }
        }else {
            myTicketsManager.filteredData = myTicketsManager.tickets?.filter { (item: Ticket) -> Bool in
                return (item.start!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || item.target!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil ||
                        item.dateOfDeparture!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) && doesFulfilllConditions(of: myTicketsManager.selectedTicketType!, ticket: item)
            }
        }
        tableView.reloadData()
    }
}

//MARK: - TableView functions
extension MyTicketsViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = myTicketsManager.filteredData?.count {
            if count == 0 {
                setEmptyMessage("No Results.")
            }else {
                restore()
            }
            return count
        }
        
        return myTicketsManager.filteredData?.count ?? 0
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ticket", for: indexPath)
        var content = cell.defaultContentConfiguration()
        if let ticket = myTicketsManager.filteredData?[indexPath.row] {
            content.text = ticket.start! + " -> " + ticket.target!
            content.secondaryText = ticket.dateOfDeparture! + " Seat: " + String(ticket.numberOfSeat!)
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ticketView = TicketView()
        guard let seat = myTicketsManager.filteredData?[indexPath.row].numberOfSeat,
        let start = myTicketsManager.filteredData?[indexPath.row].start,
        let target = myTicketsManager.filteredData?[indexPath.row].target,
        let date = myTicketsManager.filteredData?[indexPath.row].dateOfDeparture
        else {
            return
        }
        ticketView.showTicketView(title: "BOARDING PASS", seat: seat, start: start, target: target, date: date, on: self)
    }
}

//MARK: - TabBar functions
extension MyTicketsViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.selectedItem = item
        searchBar.text = ""
        switch item.tag {
            case K.TicketType.canceled:
                myTicketsManager.filteredData = myTicketsManager.tickets?.filter({ t in
                    doesFulfilllConditions(of: K.TicketType.canceled, ticket: t)
                })
                myTicketsManager.selectedTicketType = K.TicketType.canceled
            case K.TicketType.active:
                myTicketsManager.filteredData = myTicketsManager.tickets?.filter({ t in
                    doesFulfilllConditions(of: K.TicketType.active, ticket: t)
                })
                myTicketsManager.selectedTicketType = K.TicketType.active
            default:
                myTicketsManager.filteredData = myTicketsManager.tickets?.filter({ t in
                    doesFulfilllConditions(of: K.TicketType.finished, ticket: t)
                })
                myTicketsManager.selectedTicketType = K.TicketType.finished
        }
        tableView.reloadData()
    }
}
class MyTicketsViewController: UIViewController {
    
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    var ticketView = TicketView()
    var myTicketsManager = MyTicketsManager()
    var topbarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tickets"
        myTicketsManager.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        
        tabBar.selectedItem = tabBar.items?[0]
        myTicketsManager.selectedTicketType = K.TicketType.canceled
        myTicketsManager.downloadTickets()
        
        myTicketsManager.dropDown.anchorView = filterButton
        myTicketsManager.setUpFilterList(height: topbarHeight)
        
        let tableViewTap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableViewTap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tableViewTap)
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc func dismissTicket() {
        ticketView.dismissTicket()
    }
    
    @objc private func refreshData(_ sender: Any) {
        myTicketsManager.downloadTickets()
    }
    
    @IBAction func filter(_ sender: Any) {
        DropDown.appearance().backgroundColor = UIColor(named: "FilterListColor")
        myTicketsManager.dropDown.show()
    }
    
    @objc func tableViewTapped() {
        searchBar.endEditing(true)
    }
    
    func doesFulfilllConditions(of type: Int, ticket: Ticket) -> Bool {
        switch type {
        case K.TicketType.canceled:
            return ticket.canceled!
        case K.TicketType.active:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = K.dateFormat
            return dateFormatter.date(from: ticket.dateOfDeparture!)! > Date() && !ticket.canceled!
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = K.dateFormat
            return dateFormatter.date(from: ticket.dateOfDeparture!)! < Date() && !ticket.canceled!
        }
    }

}
