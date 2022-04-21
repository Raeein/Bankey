//
//  AccountSummaryCell.swift
//  Bankey
//
//  Created by Raeein Bagheri on 2022-04-15.
//

import UIKit

enum AccountType: String, Codable {
    case Banking
    case CreditCard
    case Investment
}

class AccountSummaryCell: UITableViewCell {
    
    
    
    struct ViewModel {
        let accountType: AccountType
        let accountName: String
        let balance: Decimal
//
        var balanceAsAttributedString: NSAttributedString {
            return CurrencyFormatter().makeAttributedCurrency(balance)
        }
    }
    
    let viewModel: ViewModel? = nil
    
    let typeLabel = UILabel()
    let dividerView = UIView()
    let nameLabel = UILabel()
    let balanceStackView = UIStackView()
    let balanceLabel = UILabel()
    let balanceLabelAmount = UILabel()
    let chevronImageView = UIImageView()
    
    static let reuseID = "AccountSummaryCell"
    static let rowHeight: CGFloat = 112
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AccountSummaryCell {
    private func setup() {
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .preferredFont(forTextStyle: .caption1)
        typeLabel.adjustsFontForContentSizeCategory = true
        typeLabel.text = "Account Type"
        
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = appColor
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .preferredFont(forTextStyle: .body)
        nameLabel.text = "Account Name"
        nameLabel.adjustsFontSizeToFitWidth = true
        
        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        balanceStackView.axis = .vertical
        balanceStackView.spacing = 0
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = .preferredFont(forTextStyle: .body)
        balanceLabel.textAlignment = .right
        balanceLabel.text = "Some balance"
        balanceLabel.adjustsFontSizeToFitWidth = true
        
        balanceLabelAmount.translatesAutoresizingMaskIntoConstraints = false
        balanceLabelAmount.textAlignment = .right
        balanceLabelAmount.attributedText = makeFormattedBalance(dollars: "XXX.XXX", cents: "XX")
        
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        let chevronImage = UIImage(systemName: "chevron.right")?.withTintColor(appColor, renderingMode: .alwaysOriginal)
        chevronImageView.image = chevronImage
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(nameLabel)
        
        balanceStackView.addArrangedSubview(balanceLabel)
        balanceStackView.addArrangedSubview(balanceLabelAmount)
        
        contentView.addSubview(balanceStackView)
        contentView.addSubview(chevronImageView)
    }
    private func layout() {
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            typeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
        NSLayoutConstraint.activate([
            dividerView.topAnchor.constraint(equalToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1),
            dividerView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            dividerView.heightAnchor.constraint(equalToConstant: 4),
            dividerView.widthAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 2),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
        NSLayoutConstraint.activate([
            balanceStackView.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 0),
            balanceStackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            trailingAnchor.constraint(equalToSystemSpacingAfter: balanceStackView.trailingAnchor, multiplier: 4)
        ])
        NSLayoutConstraint.activate([
            chevronImageView.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 1)
            
        ])
    }
    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString{
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .callout),.baselineOffset: 8]
        let dollarAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.preferredFont(forTextStyle: .title1)]
        let centAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset: 8]
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString = NSAttributedString(string: cents, attributes: centAttributes)
        rootString.append(dollarString)
        rootString.append(centString)
        return rootString
    }
}

extension AccountSummaryCell {
    func configure(with vm: ViewModel) {
        typeLabel.text = vm.accountType.rawValue
        nameLabel.text = vm.accountName
        balanceLabelAmount.attributedText = vm.balanceAsAttributedString
        
        switch vm.accountType {
        case .Banking:
            dividerView.backgroundColor = appColor
            balanceLabel.text = "Current Balance"
        case .CreditCard:
            dividerView.backgroundColor = .systemOrange
            balanceLabel.text = "Current Balance"
        case .Investment:
            dividerView.backgroundColor = .systemPurple
            balanceLabel.text = "Value"
        }
    }
}
