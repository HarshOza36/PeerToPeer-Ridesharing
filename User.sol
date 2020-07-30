//"SPDX-License-Identifier: UNLICENSED"

pragma solidity >= 0.4.0 < 0.7.0;
import './Driver.sol';
import 'Ownable.sol';



contract User is Ownable{
    
    
    // Main variables
    string private _city;
    address payable owneradd;
    Driver d;
 
    
    // Set Driver Contract address
    function setDriverContractAddress(address contract_add) public onlyOwner{
        d = Driver(contract_add);
    }

    //Test Function to check if we can access variables of other contract
    // function getDriverList() public{
    //     nddriverList=d.giveArray();
    // }
    
    //Set Owner to get Payed
    function setPayableOwner() public onlyOwner{
        address ownerr = owner();
        owneradd = payable(ownerr);
        // emit nu(ownerr);
    }

    //Find drivers in your city (To give input in Driver Contract)
    function findDriverbyCity(string calldata city) external{
        _city=city;
    }
    
    
    //Get the count of all Drivers
    function totalDrivers() public view returns(uint256){
        return d.getDriverCount();
    }

    //Give city as input to driverLoop in Driver contract and get Drivers in Logs
    function getDriverinLogs() public {
        
        return d.driverLoop(_city);
        
    }
    
    //Call Selected driver
    function callDriver(address driver_add) public payable{
        owneradd.transfer(1000000000000000000);
        return d.EngageDriver(driver_add,msg.sender);
    }
    

    // Pay money to driver as per his kilometer charge
    function payMoney(address payable driver_add) public payable returns(address,uint256){
        driver_add.transfer(address(this).balance);
        return d.EndJourney(driver_add);
    }
    
    //To Cancel a ride
    function cancelYourRide(address driver_add,address cust) public{
        return d.cancelRide(driver_add,cust);
    }
    
    
    //Self Destruct
      function kill() public onlyOwner{
            selfdestruct(msg.sender);
    }
    

}

