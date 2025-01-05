//
//  Ahmed_EventViewController.swift
//  Glow_event
//
//  Created by a-awadhi on 04/01/2025.
//

import UIKit

class Ahmed_EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availableSeatsLabel: UILabel!
    @IBOutlet weak var aboutEventTextView: UITextView!
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var star5ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    private var event: Event?
    private var isBought: Bool?
    
    private var reviews: [ReviewWithUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let event = event else {
            print("Event is Null")
            return
        }
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        prepareBar()
        
        loadReviews()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d • h:mm a"
        
        let formattedDate = dateFormatter.string(from: event.startDate)
        
        dateLabel.text = formattedDate
        titleLabel.text = event.EventName
        statusLabel.text = event.EventStatus
        locationLabel.text = event.venu_options
        organizerLabel.text =  "Not Specified"
        aboutEventTextView.text = event.descrip
        availableSeatsLabel.text = String(event.Capacity ?? 100)
        priceLabel.text = "\(event.price) BD/person"
        
        if let imageURL = URL(string: event.EventPhotoURL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                } else {
                    print("Failed to load image")
                }
            }
        }
        
        //        if event.EventStatus == "Canceled" || event.EventStatus == "Completed" {
        //            registerButton.setTitle("Registration Closed", for: .normal)
        //            registerButton.isEnabled = false
        //        }
        
    }
    
    public func configure(event: Event, isBought: Bool) {
        self.event = event
        self.isBought = isBought
    }
    
    private func prepareBar() {
        let reportEventAction = UIAction(title: "Report Event") { action in
            // Handle Report Event action
        }
        
        let reviewEventAction = UIAction(title: "Review Event") { action in
            // Handle Review Event action
            self.reviewEvent()
        }
        
        // Create a UIMenu with the two actions
        let menu = UIMenu(title: "", children: [reportEventAction, reviewEventAction])
        
        // Set the menu as the action of the rightBarButtonItem
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        
        // Add the button to the navigation bar
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func loadReviews() {
        guard let event = event else { return }
        
        print("loading review")
        FirebaseDB.getReviewsForEvent(eventID: event.id) { reviews in
            print("loaded: \(reviews)")
            self.reviews = reviews
            self.reviewsTableView.reloadData()
            
            
            let totalStars = reviews.reduce(0) { (result, review) in
                return result + review.stars
            }
            let averageRating = Double(totalStars) / Double(reviews.count)
            
            let roundedRating = round(averageRating * 2) / 2  // Round to the nearest 0.5
            
            let starImageNames: [UIImageView] = [self.star1ImageView, self.star2ImageView, self.star3ImageView, self.star4ImageView, self.star5ImageView]
            
            for (index, starImageView) in starImageNames.enumerated() {
                let starPosition = Double(index + 1)
                
                if roundedRating >= starPosition {
                    // Fully filled star
                    starImageView.image = UIImage(systemName: "star.fill")
                } else if roundedRating > starPosition - 1 && roundedRating < starPosition {
                    // Half filled star
                    starImageView.image = UIImage(systemName: "star.leadinghalf.filled")
                } else {
                    // Empty star
                    starImageView.image = UIImage(systemName: "star")
                }
            }
            
            
        }
    }
    
    
    func reviewEvent() {
        // Create the alert controller
        let alertController = UIAlertController(title: "Rate and Review", message: "\n\n", preferredStyle: .alert)
        
        // Add the text field for writing a review
        alertController.addTextField { textField in
            textField.placeholder = "Write your review here..."
        }
        
        // Create a custom container view for the stars
        let customContainerView = UIView()
        customContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the star rating view
        let starRatingView = UIStackView()
        starRatingView.axis = .horizontal
        starRatingView.alignment = .center
        starRatingView.distribution = .fillEqually
        starRatingView.spacing = 8
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add star buttons to the star rating view
        var starButtons = [UIButton]()
        for i in 1...5 {
            let starButton = UIButton(type: .system)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
            starButton.tintColor = UIColor(named: "OurAccentColor")
            starButton.tag = i
            starButton.addTarget(self, action: #selector(handleStarTapped(_:)), for: .touchUpInside)
            starRatingView.addArrangedSubview(starButton)
            starButtons.append(starButton)
        }
        
        // Add starRatingView to the custom container view
        customContainerView.addSubview(starRatingView)
        
        // Add the custom container view to the alert controller's main view
        alertController.view.addSubview(customContainerView)
        
        // Set up constraints for the star rating view
        NSLayoutConstraint.activate([
            starRatingView.centerXAnchor.constraint(equalTo: customContainerView.centerXAnchor),
            starRatingView.centerYAnchor.constraint(equalTo: customContainerView.centerYAnchor),
            starRatingView.heightAnchor.constraint(equalToConstant: 40),
            starRatingView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        // Set up constraints for the custom container view
        NSLayoutConstraint.activate([
            customContainerView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor),
            customContainerView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor),
            customContainerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
            customContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let reviewText = alertController.textFields?.first?.text ?? ""
            let selectedStars = starButtons.filter { $0.accessibilityIdentifier == "SELECTED" }.count
            print("Review: \(reviewText), Stars: \(selectedStars)")
            
            FirebaseDB.saveReview(eventID: self.event?.id ?? "--", reviewText: reviewText, stars: selectedStars) { _,_  in
                self.loadReviews()
                
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleStarTapped(_ sender: UIButton) {
        guard let starRatingView = sender.superview as? UIStackView else { return }
        
        for star in starRatingView.arrangedSubviews {
            if let button = star as? UIButton {
                // Fill stars up to the tapped star (inclusive)
                if button.tag <= sender.tag {
                    button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    button.accessibilityIdentifier = "SELECTED"
                } else {
                    // Unfill stars beyond the tapped star
                    button.setImage(UIImage(systemName: "star"), for: .normal)
                    button.accessibilityIdentifier = ""
                }
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return reviews?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews?.count ?? 0 > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ahmed_reviewCell", for: indexPath)
        
        // Get the ReviewWithUser for the current row (indexPath)
        let review = reviews![indexPath.section] // Assuming reviews is an array of ReviewWithUser
        
        // Get references to the UI elements using their tags
        let pictureImageView = cell.viewWithTag(20) as! UIImageView
        let nameLabel = cell.viewWithTag(10) as! UILabel
        let star1ImageView = cell.viewWithTag(11) as! UIImageView
        let star2ImageView = cell.viewWithTag(12) as! UIImageView
        let star3ImageView = cell.viewWithTag(13) as! UIImageView
        let star4ImageView = cell.viewWithTag(14) as! UIImageView
        let star5ImageView = cell.viewWithTag(15) as! UIImageView
        let descriptionTextView = cell.viewWithTag(30) as! UITextView
        
        // Set the user name
        nameLabel.text = review.userName
        
        // Load the profile image from URL (without SDWebImage)
        if let url = URL(string: review.profileImageUrl) {
            // Download image using URLSession
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data, error == nil {
                    // Ensure that the image is set on the main thread
                    DispatchQueue.main.async {
                        pictureImageView.image = UIImage(data: data)
                        pictureImageView.layer.cornerRadius = (pictureImageView.frame.width / 2)
                    }
                }
            }.resume()
        }
        descriptionTextView.text = review.reviewText
        
        // Set the stars (Assuming you are using star images, e.g. filled or empty stars)
        let allStarImageViews = [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView]
        
        for i in 0..<allStarImageViews.count {
            let starImageView = allStarImageViews[i]
            // Set the filled star image for the review's stars
            if i < review.stars {
                starImageView.image = UIImage(systemName: "star.fill")
            } else {
                starImageView.image = UIImage(systemName: "star")
            }
        }
        
        return cell
    }
    
    @IBAction func tappedRegister(_ sender: Any) {
        guard let event = event else { return }
        
        let cartVC = storyboard?.instantiateViewController(withIdentifier: "Ahmed_CartViewController") as! Ahmed_CartViewController
        
        cartVC.configure(event: event)
        
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
}
