//
//  NotificationCell.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 01/01/2025.
//
import SwiftUI
import UIKit

class NotificationCell: UITableViewCell {
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let timestampLabel = UILabel()
    let logoImageView = UIImageView()


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Provide an estimated height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        // Example data
        let title = "Notification Title"
        let detail = "This is the detail of the notification."
        let timestamp = "2 hours ago"
        let logoURL = "https://asset.cloudinary.com/doctomog7/9ec21fe2104eded7911300666e4c878b"
        
        // Configure the cell
        cell.configureCell(title: title, detail: detail, timestamp: timestamp, logoURL: logoURL)
        
        return cell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup the logo image view
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoImageView)

        // Configure titleLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Configure detailLabel
        detailLabel.font = UIFont.systemFont(ofSize: 14)
        detailLabel.textColor = .gray
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailLabel)

        // Configure timestampLabel
        timestampLabel.font = UIFont.systemFont(ofSize: 12)
        timestampLabel.textColor = .lightGray
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestampLabel)

        // Set constraints
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 40),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            timestampLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timestampLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Method to configure the cell
    func configureCell(title: String, detail: String, timestamp: String, logoURL: String) {
            titleLabel.text = title
            detailLabel.text = detail
            timestampLabel.text = timestamp
    
            // Fetch the logo image
            if let url = URL(string: logoURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error fetching image: \(error.localizedDescription)")
                        return
                   }
                    guard let data = data, let image = UIImage(data: data) else {
                        print("Error converting data to image")
                        return
                    }
    
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        self.logoImageView.image = image
                    }
                }.resume()
            } else {
                // Set a placeholder image if the URL is invalid
                logoImageView.image = nil // or set a default placeholder image
            }
        }
}
