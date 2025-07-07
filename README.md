# PharmaChain

## Project Description

PharmaChain is a blockchain-based pharmaceutical supply chain management system built on Ethereum using Solidity smart contracts. The platform provides end-to-end traceability, transparency, and accountability in the pharmaceutical supply chain, from manufacturing to end-consumer delivery.

The system addresses critical challenges in the pharmaceutical industry including counterfeit drugs, lack of transparency, inefficient recall processes, and difficulty in tracking drug authenticity and quality throughout the supply chain.

## Project Vision

To revolutionize the pharmaceutical industry by creating a decentralized, transparent, and secure supply chain ecosystem that ensures drug authenticity, prevents counterfeiting, and enhances patient safety through blockchain technology.

Our vision is to build a global standard for pharmaceutical traceability that empowers all stakeholders - manufacturers, distributors, pharmacies, regulators, and patients - with real-time access to verified drug information and complete supply chain history.

## Key Features

### 🏭 **Multi-Role User Management**
- Support for different stakeholder roles: Manufacturers, Distributors, Pharmacies, and Regulators
- Role-based access control with specific permissions for each user type
- Secure user registration and authentication system

### 💊 **Comprehensive Drug Registration**
- Unique drug identification using cryptographic hashing
- Complete drug metadata including batch numbers, manufacturing dates, and expiry dates
- Automated drug ID generation to prevent duplication

### 🔄 **Supply Chain Tracking**
- Real-time ownership transfer between supply chain participants
- Complete stage history tracking from manufacturing to final delivery
- Immutable record of all transactions and movements

### ✅ **Quality Verification System**
- Regulatory authority verification capabilities
- Quality check records with pass/fail status
- Integration with compliance requirements and standards

### 🚨 **Drug Recall Management**
- Instant recall capabilities for manufacturers and regulators
- Automated status updates across the entire supply chain
- Reason tracking and recall history maintenance

### 🔍 **Transparency & Traceability**
- Complete drug history accessible to authorized parties
- Real-time status updates and notifications
- Expiry date monitoring and alerts

### 🛡️ **Security & Access Control**
- Multi-level authorization system
- Encrypted data storage on blockchain
- Role-based data access permissions

## Technical Architecture

### Smart Contract Structure
- **Main Contract**: `Project.sol` - Core supply chain management logic
- **Events**: Real-time notifications for all major activities
- **Modifiers**: Security and access control mechanisms
- **Structs**: Organized data structures for drugs and users

### Core Functions
1. **registerUser()** - Register new stakeholders in the system
2. **registerDrug()** - Register new pharmaceutical products
3. **transferOwnership()** - Transfer drugs between supply chain parties
4. **verifyQuality()** - Regulatory quality verification
5. **recallDrug()** - Emergency drug recall functionality

### Data Models
- **Drug**: Complete pharmaceutical product information
- **User**: Stakeholder details and role management
- **Supply Chain History**: Immutable tracking records

## Installation & Deployment

### Prerequisites
- Node.js (v16 or higher)
- Hardhat or Truffle development environment
- MetaMask wallet for testing
- Ethereum testnet access (Goerli, Sepolia)

### Setup Instructions
```bash
# Clone the repository
git clone https://github.com/your-organization/pharmachain.git
cd PharmaChain

# Install dependencies
npm install

# Compile smart contracts
npx hardhat compile

# Deploy to testnet
npx hardhat run scripts/deploy.js --network goerli

# Run tests
npx hardhat test
```

### Configuration
1. Configure network settings in `hardhat.config.js`
2. Set up environment variables for private keys and API endpoints
3. Deploy contract and verify on Etherscan

## Usage Examples

### Register a New User
```solidity
// Register a manufacturer
registerUser(0x123..., UserRole.Manufacturer, "PharmaCorp Ltd");
```

### Register a Drug
```solidity
// Register new medication
bytes32 drugId = registerDrug("Aspirin", "BATCH2024001", 1735689600);
```

### Transfer Ownership
```solidity
// Transfer from manufacturer to distributor
transferOwnership(drugId, distributorAddress, "Distribution");
```

## Future Scope

### 🌐 **Global Integration**
- Integration with international pharmaceutical regulatory bodies
- Multi-country compliance framework
- Cross-border supply chain tracking

### 🔗 **IoT Integration**
- Temperature and humidity sensors for cold chain management
- Real-time environmental monitoring during transport
- Automated quality alerts based on sensor data

### 📱 **Mobile Applications**
- Patient-facing mobile app for drug verification
- Healthcare provider dashboard for drug authenticity checking
- Supply chain partner mobile interfaces

### 🤖 **AI & Machine Learning**
- Predictive analytics for demand forecasting
- Anomaly detection in supply chain patterns
- Automated quality assessment using ML algorithms

### 💡 **Advanced Features**
- Smart contracts for automated payments and settlements
- Integration with prescription systems and electronic health records
- Decentralized governance model for system upgrades

### 🔐 **Enhanced Security**
- Zero-knowledge proofs for privacy-preserving verification
- Multi-signature wallet integration for high-value transactions
- Advanced encryption for sensitive pharmaceutical data

### 🌍 **Sustainability Tracking**
- Carbon footprint monitoring throughout the supply chain
- Sustainable packaging and disposal tracking
- Environmental impact reporting and compliance

### 📊 **Analytics & Reporting**
- Advanced dashboard for supply chain analytics
- Regulatory reporting automation
- Market trend analysis and insights

### 🏥 **Healthcare Ecosystem Integration**
- Integration with hospital management systems
- Pharmacy inventory management
- Insurance claim processing and verification

## Contributing

We welcome contributions from the community! Please read our contributing guidelines and submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

For questions, suggestions, or collaboration opportunities, please contact:
- Email: info@pharmachain.org
- Website: https://pharmachain.org
- GitHub: https://github.com/pharmachain

---

**Disclaimer**: This project is for educational and development purposes. Ensure compliance with local regulations and obtain necessary approvals before deploying in production environments.

contract address:0x9751009BA110a229a9E72BaD08D9104842800d0F
img address : <img width="1916" height="1014" alt="Image" src="https://github.com/user-attachments/assets/6bcd8e1e-9ed6-4a74-bcc5-5f580e678180" />
