// 🚀 URUTAN DEPLOYMENT DI REMIX:
// Step 1: Deploy Salesperson
// 	•	Pilih `Salesperson` dari dropdown
// 	•	Klik Deploy
// 	•	Copy address yang dihasilkan
// Step 2: Deploy EngineeringManager
// 	•	Pilih `EngineeringManager` dari dropdown
// 	•	Klik Deploy
// 	•	Copy address yang dihasilkan
// Step 3: Deploy InheritanceSubmission
// 	•	Pilih `InheritanceSubmission` dari dropdown
// 	•	Masukkan kedua address dari Step 1 & 2
// 	•	Klik Deploy
// 	•	Copy address InheritanceSubmission
// 🎖️ SUBMIT UNTUK PIN:
// Address InheritanceSubmission contract inilah yang Anda submit ke Base.org untuk mendapatkan NFT Badg



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 1. Abstract Employee Contract
abstract contract Employee {
    uint public idNumber;
    uint public managerId;
    
    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }
    
    function getAnnualCost() public virtual returns (uint);
}

// 2. Salaried Contract
contract Salaried is Employee {
    uint public annualSalary;
    
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) 
        Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }
    
    function getAnnualCost() public view override returns (uint) {
        return annualSalary;
    }
}

// 3. Hourly Contract
contract Hourly is Employee {
    uint public hourlyRate;
    
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) 
        Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }
    
    function getAnnualCost() public view override returns (uint) {
        return hourlyRate * 2080; // 40 hours/week * 52 weeks
    }
}

// 4. Manager Contract
contract Manager {
    uint[] public employeeIds;
    
    function addReport(uint _employeeId) public {
        employeeIds.push(_employeeId);
    }
    
    function resetReports() public {
        delete employeeIds;
    }
    
    function getReports() public view returns (uint[] memory) {
        return employeeIds;
    }
}

// 5. Salesperson Contract (DEPLOY INI PERTAMA)
contract Salesperson is Hourly {
    constructor() Hourly(55555, 12345, 20) {}
}

// 6. EngineeringManager Contract (DEPLOY INI KEDUA)  
contract EngineeringManager is Salaried, Manager {
    constructor() Salaried(54321, 11111, 200000) {}
}

// 7. InheritanceSubmission Contract (DEPLOY INI UNTUK PIN!)
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;
    
    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
