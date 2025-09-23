// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract GarageManager {
    // Car struct with required properties
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    // Public mapping garage: address => array of Cars
    mapping(address => Car[]) public garage;

    // Custom error for invalid car index
    error BadCarIndex(uint256 index);

    // Add a car to msg.sender's garage
    function addCar(string memory _make, string memory _model, string memory _color, uint256 _numberOfDoors) public {
        Car memory newCar = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });
        garage[msg.sender].push(newCar);
    }

    // Return all cars owned by msg.sender
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // Return all cars owned by any user
    function getUserCars(address _user) public view returns (Car[] memory) {
        return garage[_user];
    }

    // Update car at index for msg.sender
    function updateCar(uint256 _index, string memory _make, string memory _model, string memory _color, uint256 _numberOfDoors) public {
        if (_index >= garage[msg.sender].length) {
            revert BadCarIndex(_index);
        }
        Car storage carToUpdate = garage[msg.sender][_index];
        carToUpdate.make = _make;
        carToUpdate.model = _model;
        carToUpdate.color = _color;
        carToUpdate.numberOfDoors = _numberOfDoors;
    }

    // Reset the garage for msg.sender
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
