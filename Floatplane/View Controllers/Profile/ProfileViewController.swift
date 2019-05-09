//
//  ProfileViewController.swift
//  Floatplane
//
//  Created by Jack Perry on 7/5/19.
//  Copyright © 2019 Yoshimi Robotics. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

public class ProfileViewController: UITableViewController
{
    
    @IBOutlet var nameLabel: UILabel!
    
    
    /// Actions
    /// -----------------------------------------------------------------------------------------------

    @IBAction func dismiss()
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Account.current()?.fetchExtendedAttributes({ [weak self] (_) in
            DispatchQueue.main.async {
                self?.updateInterface()
            }
        })
    }
    
    
    
    
    
    func updateInterface()
    {
        print("Current account: \(Account.current())")
        self.nameLabel.text = Account.current()?.displayName ?? "Loading.."
        
    }
    
    
    
    
    /// Table View Data Source
    /// -----------------------------------------------------------------------------------------------

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            
            case 1:
                return Account.current()?.subscriptions?.count ?? 0
            
            default:
                return 0
        }
    }
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2 // Currently only 2, Profile and subscriptions
        
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            case 0:
                return nil
            
            case 1:
                return "Subscriptions"
            
            default:
                return nil
        }
    
    }
    
    override public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                return 82 // We only need to modify the header cell height
            
            default:
                return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch (indexPath.section, indexPath.row) {
            
            // Profile row
            case (0, 0):
                let cell = tableView.dequeueReusableCell(withIdentifier: "profile-cell", for: indexPath) as? SettingsHeaderTableViewCell
                cell?.titleLabel.text = Account.current()?.displayName ?? Account.current()?.username
                cell?.subtitleLabel.text = "View & manage your profile and activity"
                if let url = URL(string: Account.current()?.profileImage ?? "") {
                    cell?.profileImageView.kf.setImage(with: url)
                }
                
                return cell ?? UITableViewCell()
            
            // All subscriptions rows
            case (1, _):
                let cell = tableView.dequeueReusableCell(withIdentifier: "subscription-cell", for: indexPath)
                let subscription: Subscription? = Account.current()?.subscriptions?[indexPath.row]
                
                if let id = subscription?.creator, let creator = Creator.find(identifier: id) {
                    cell.textLabel?.text = creator.title
                } else {
                    cell.textLabel?.text = subscription?.creator
                }
                
                cell.detailTextLabel?.text = subscription?.plan?.formattedPrice() ?? "$0.00"
                return cell
            
            default:
                return UITableViewCell()
        }
        
    }
    
    
    
}
