// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title PharmaChain
 * @dev Smart contract for pharmaceutical supply chain management
 * @author PharmaChain Team
 */
contract Project {
    
    // Events
    event DrugRegistered(bytes32 indexed drugId, address indexed manufacturer, string drugName);
    event OwnershipTransferred(bytes32 indexed drugId, address indexed from, address indexed to, string stage);
    event QualityVerified(bytes32 indexed drugId, address indexed verifier, bool passed);
    event DrugRecalled(bytes32 indexed drugId, address indexed recaller, string reason);
    event StageUpdated(bytes32 indexed drugId, string newStage, uint256 timestamp);
    
    // Enums
    enum DrugStatus { Active, Recalled, Expired }
    enum UserRole { None, Manufacturer, Distributor, Pharmacy, Regulator }
    
    // Structs
    struct Drug {
        bytes32 drugId;
        string name;
        string batchNumber;
        address manufacturer;
        address currentOwner;
        uint256 manufactureDate;
        uint256 expiryDate;
        string currentStage;
        DrugStatus status;
        bool qualityVerified;
        string[] stageHistory;
        address[] ownershipHistory;
    }
    
    struct User {
        address userAddress;
        UserRole role;
        string name;
        bool isActive;
        uint256 registrationDate;
    }
    
    // State variables
    mapping(bytes32 => Drug) public drugs;
    mapping(address => User) public users;
    mapping(address => bytes32[]) public userDrugs;
    
    bytes32[] public allDrugIds;
    address public admin;
    
    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
    
    modifier onlyActiveUser() {
        require(users[msg.sender].isActive, "User is not active");
        _;
    }
    
    modifier onlyAuthorized(bytes32 _drugId) {
        require(
            msg.sender == drugs[_drugId].currentOwner || 
            users[msg.sender].role == UserRole.Regulator || 
            msg.sender == admin,
            "Not authorized to access this drug"
        );
        _;
    }
    
    modifier drugExists(bytes32 _drugId) {
        require(drugs[_drugId].drugId != bytes32(0), "Drug does not exist");
        _;
    }
    
    // Constructor
    constructor() {
        admin = msg.sender;
        users[admin] = User({
            userAddress: admin,
            role: UserRole.Regulator,
            name: "System Admin",
            isActive: true,
            registrationDate: block.timestamp
        });
    }
    
    /**
     * @dev Register a new user in the system
     * @param _userAddress Address of the user
     * @param _role Role of the user
     * @param _name Name of the user/organization
     */
    function registerUser(
        address _userAddress,
        UserRole _role,
        string memory _name
    ) external onlyAdmin {
        require(_userAddress != address(0), "Invalid address");
        require(_role != UserRole.None, "Invalid role");
        require(!users[_userAddress].isActive, "User already registered");
        
        users[_userAddress] = User({
            userAddress: _userAddress,
            role: _role,
            name: _name,
            isActive: true,
            registrationDate: block.timestamp
        });
    }
    
    /**
     * @dev Register a new drug in the supply chain
     * @param _name Name of the drug
     * @param _batchNumber Batch number
     * @param _expiryDate Expiry date timestamp
     */
    function registerDrug(
        string memory _name,
        string memory _batchNumber,
        uint256 _expiryDate
    ) external onlyActiveUser returns (bytes32) {
        require(users[msg.sender].role == UserRole.Manufacturer, "Only manufacturers can register drugs");
        require(_expiryDate > block.timestamp, "Expiry date must be in the future");
        
        bytes32 drugId = keccak256(abi.encodePacked(_name, _batchNumber, msg.sender, block.timestamp));
        
        require(drugs[drugId].drugId == bytes32(0), "Drug already registered");
        
        drugs[drugId] = Drug({
            drugId: drugId,
            name: _name,
            batchNumber: _batchNumber,
            manufacturer: msg.sender,
            currentOwner: msg.sender,
            manufactureDate: block.timestamp,
            expiryDate: _expiryDate,
            currentStage: "Manufacturing",
            status: DrugStatus.Active,
            qualityVerified: false,
            stageHistory: new string[](0),
            ownershipHistory: new address[](0)
        });
        
        drugs[drugId].stageHistory.push("Manufacturing");
        drugs[drugId].ownershipHistory.push(msg.sender);
        
        allDrugIds.push(drugId);
        userDrugs[msg.sender].push(drugId);
        
        emit DrugRegistered(drugId, msg.sender, _name);
        emit StageUpdated(drugId, "Manufacturing", block.timestamp);
        
        return drugId;
    }
    
    /**
     * @dev Transfer ownership of a drug to another party
     * @param _drugId ID of the drug
     * @param _newOwner Address of the new owner
     * @param _newStage New stage in the supply chain
     */
    function transferOwnership(
        bytes32 _drugId,
        address _newOwner,
        string memory _newStage
    ) external drugExists(_drugId) onlyActiveUser {
        require(msg.sender == drugs[_drugId].currentOwner, "Only current owner can transfer");
        require(users[_newOwner].isActive, "New owner is not registered or active");
        require(drugs[_drugId].status == DrugStatus.Active, "Drug is not active");
        require(block.timestamp < drugs[_drugId].expiryDate, "Drug has expired");
        
        address previousOwner = drugs[_drugId].currentOwner;
        
        drugs[_drugId].currentOwner = _newOwner;
        drugs[_drugId].currentStage = _newStage;
        drugs[_drugId].stageHistory.push(_newStage);
        drugs[_drugId].ownershipHistory.push(_newOwner);
        
        userDrugs[_newOwner].push(_drugId);
        
        emit OwnershipTransferred(_drugId, previousOwner, _newOwner, _newStage);
        emit StageUpdated(_drugId, _newStage, block.timestamp);
    }
    
    /**
     * @dev Verify quality of a drug (only regulators can verify)
     * @param _drugId ID of the drug
     * @param _passed Whether the drug passed quality verification
     */
    function verifyQuality(
        bytes32 _drugId,
        bool _passed
    ) external drugExists(_drugId) onlyActiveUser {
        require(users[msg.sender].role == UserRole.Regulator, "Only regulators can verify quality");
        require(drugs[_drugId].status == DrugStatus.Active, "Drug is not active");
        
        drugs[_drugId].qualityVerified = _passed;
        
        if (!_passed) {
            drugs[_drugId].status = DrugStatus.Recalled;
            emit DrugRecalled(_drugId, msg.sender, "Failed quality verification");
        }
        
        emit QualityVerified(_drugId, msg.sender, _passed);
    }
    
    /**
     * @dev Recall a drug from the market
     * @param _drugId ID of the drug
     * @param _reason Reason for recall
     */
    function recallDrug(
        bytes32 _drugId,
        string memory _reason
    ) external drugExists(_drugId) onlyActiveUser {
        require(
            users[msg.sender].role == UserRole.Regulator || 
            msg.sender == drugs[_drugId].manufacturer,
            "Only regulators or manufacturers can recall drugs"
        );
        require(drugs[_drugId].status == DrugStatus.Active, "Drug is already recalled or expired");
        
        drugs[_drugId].status = DrugStatus.Recalled;
        
        emit DrugRecalled(_drugId, msg.sender, _reason);
    }
    
    // View functions
    
    /**
     * @dev Get complete drug information
     * @param _drugId ID of the drug
     */
    function getDrugInfo(bytes32 _drugId) 
        external 
        view 
        drugExists(_drugId) 
        onlyAuthorized(_drugId)
        returns (
            string memory name,
            string memory batchNumber,
            address manufacturer,
            address currentOwner,
            uint256 manufactureDate,
            uint256 expiryDate,
            string memory currentStage,
            DrugStatus status,
            bool qualityVerified
        ) 
    {
        Drug memory drug = drugs[_drugId];
        return (
            drug.name,
            drug.batchNumber,
            drug.manufacturer,
            drug.currentOwner,
            drug.manufactureDate,
            drug.expiryDate,
            drug.currentStage,
            drug.status,
            drug.qualityVerified
        );
    }
    
    /**
     * @dev Get drug history (stages and ownership)
     * @param _drugId ID of the drug
     */
    function getDrugHistory(bytes32 _drugId)
        external
        view
        drugExists(_drugId)
        onlyAuthorized(_drugId)
        returns (string[] memory stages, address[] memory owners)
    {
        return (drugs[_drugId].stageHistory, drugs[_drugId].ownershipHistory);
    }
    
    /**
     * @dev Get user information
     * @param _userAddress Address of the user
     */
    function getUserInfo(address _userAddress)
        external
        view
        returns (UserRole role, string memory name, bool isActive, uint256 registrationDate)
    {
        User memory user = users[_userAddress];
        return (user.role, user.name, user.isActive, user.registrationDate);
    }
    
    /**
     * @dev Get all drugs owned by a user
     * @param _userAddress Address of the user
     */
    function getUserDrugs(address _userAddress) external view returns (bytes32[] memory) {
        return userDrugs[_userAddress];
    }
    
    /**
     * @dev Get total number of registered drugs
     */
    function getTotalDrugs() external view returns (uint256) {
        return allDrugIds.length;
    }
    
    /**
     * @dev Check if drug has expired
     * @param _drugId ID of the drug
     */
    function isDrugExpired(bytes32 _drugId) external view drugExists(_drugId) returns (bool) {
        return block.timestamp >= drugs[_drugId].expiryDate;
    }
}
