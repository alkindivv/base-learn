// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// ========== OPENZEPPELIN OWNABLE CONTRACT ==========
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 */

// ========== DEPLOY INSTRUCTIONS ==========
/**
* Copy-paste entire code
* Compile with Solidity `^0.8.17`
* Deploy `AddressBookFactory` contract
* Submit address AddressBookFactory for NFTs Badge
*/

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    error OwnableUnauthorizedAccount(address account);
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// ========== ADDRESS BOOK CONTRACT ==========
contract AddressBook is Ownable {
    // Contact struct with required properties
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }
    
    // Storage for contacts
    mapping(uint => Contact) private contacts;
    uint[] private contactIds;
    uint private nextId = 1;
    
    // Custom error
    error ContactNotFound(uint id);
    
    constructor(address initialOwner) Ownable(initialOwner) {}
    
    // Add Contact - only owner can call
    function addContact(
        string memory _firstName,
        string memory _lastName,
        uint[] memory _phoneNumbers
    ) public onlyOwner {
        uint contactId = nextId;
        
        contacts[contactId] = Contact({
            id: contactId,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumbers: _phoneNumbers
        });
        
        contactIds.push(contactId);
        nextId++;
    }
    
    // Delete Contact - only owner can call
    function deleteContact(uint _id) public onlyOwner {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }
        
        // Delete from mapping
        delete contacts[_id];
        
        // Remove from contactIds array
        for (uint i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
                break;
            }
        }
    }
    
    // Get Contact - public access (no onlyOwner)
    function getContact(uint _id) public view returns (Contact memory) {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }
        return contacts[_id];
    }
    
    // Get All Contacts - public access (no onlyOwner)
    function getAllContacts() public view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);
        
        for (uint i = 0; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }
        
        return allContacts;
    }
    
    // Helper function to get contact count
    function getContactCount() public view returns (uint) {
        return contactIds.length;
    }
}

// ========== ADDRESS BOOK FACTORY CONTRACT ==========
contract AddressBookFactory {
    // Event untuk tracking deployments
    event AddressBookDeployed(address indexed owner, address indexed addressBook);
    
    // Array untuk menyimpan semua deployed contracts
    address[] public deployedAddressBooks;
    
    // Mapping owner ke address books mereka
    mapping(address => address[]) public ownerToAddressBooks;
    
    // Deploy function - creates new AddressBook instance
    function deploy() public returns (address) {
        // Create new AddressBook with caller as owner
        AddressBook newAddressBook = new AddressBook(msg.sender);
        address newAddress = address(newAddressBook);
        
        // Track deployments
        deployedAddressBooks.push(newAddress);
        ownerToAddressBooks[msg.sender].push(newAddress);
        
        // Emit event
        emit AddressBookDeployed(msg.sender, newAddress);
        
        return newAddress;
    }
    
    // Get all deployed address books
    function getAllDeployedAddressBooks() public view returns (address[] memory) {
        return deployedAddressBooks;
    }
    
    // Get address books for specific owner
    function getAddressBooksForOwner(address _owner) public view returns (address[] memory) {
        return ownerToAddressBooks[_owner];
    }
    
    // Get total number of deployed address books
    function getDeployedCount() public view returns (uint) {
        return deployedAddressBooks.length;
    }
}
