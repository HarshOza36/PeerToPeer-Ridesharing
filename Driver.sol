//"SPDX-License-Identifier: UNLICENSED"


pragma solidity >= 0.4.0 < 0.7.0;
import 'Ownable.sol';


// File: openzeppelin-solidity/contracts/math/SafeMath.sol
/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal view returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal view returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal view returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }
                                            
    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal view returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal view returns (uint256) {
        require(b != 0);
        return a % b;
    }
}



contract Driver is Ownable{
    
    //Main Info Variables
    
    using SafeMath for uint256;
    address[] public driverList ;
    address[] public CustomdriverList ;
    address payable owneradd;
    
    
    // Profile Structure
    struct  Profile {
        // address driverID;
        string fName;
        string lName;
        string city;
        string carName;
        string carType;
        uint256 payPerKmINwei;
        bool isEngaged;
        uint256 NoOfRides;
    }

    
    //Set Owner to get Payed
    function setPayableOwner() public onlyOwner{
        address ownerr = owner();
        owneradd = payable(ownerr);
    }

    //Create Profile 
    mapping(address => Profile) public profile;
     

    // Main Function for Adding Driver Details -- payable
    
    function addYourProfile(address driver,string memory ifname,string memory ilname,string memory icity,string memory icarName,string memory icarType,uint256  ipayPerKmINwei) public  payable{
        // Push addresses of driver to the list of drivers
        driverList.push(driver);
       
        //Use the addresses and fill up the profile in struct
        profile[driver].fName=ifname;
        profile[driver].lName=ilname;
        profile[driver].city=icity;
        profile[driver].carName=icarName;
        profile[driver].carType=icarType;
        profile[driver].payPerKmINwei=ipayPerKmINwei;
        profile[driver].isEngaged=false;
        
        owneradd.transfer(5000000000000000000);
        
    }   
    
    
    
    // 1 ether = 1000000000000000000 wei (18 zeros)
    
    //Get driver count (For User Contract)
    function getDriverCount() public view returns(uint256){
        return driverList.length;
    }
    
    //Update Per kilometer charge -- payable
    function updatePerkmCharge(address driver,uint256 ipayPerKmINwei) public payable{
        profile[driver].payPerKmINwei=ipayPerKmINwei; 
        owneradd.transfer(1000000000000000000);
    }
    
    //Update carType and carName -- payable
    function updateCarDetails(address driver,string memory icarName,string memory icarType) public payable{
        profile[driver].carName = icarName;
        profile[driver].carType = icarType;
        owneradd.transfer(1000000000000000000);
    }
    
    //Update City Details -- payable
     function updateCityDetails(address driver,string  memory icity) public payable{
        profile[driver].city = icity;
        owneradd.transfer(1000000000000000000);
    }
    
    
    
    //Events to fetch data
    event LogofDrivers(address driver,string ifname);
    
    //Function to get all Drivers in your City(For User Contract)
    function driverLoop(string memory _city) public{
        for(uint256 i=0;i<driverList.length;i++){
            if(keccak256(abi.encodePacked(profile[driverList[i]].city)) == keccak256(abi.encodePacked(_city))){
                CustomdriverList.push(driverList[i]);
            }
        }
        for(uint256 i=0;i<CustomdriverList.length;i++){
            emit LogofDrivers(CustomdriverList[i], profile[CustomdriverList[i]].fName);
        }        
    }
    
    
    //Event for driver
    event NotifyDriver(address driver,string message,address customer);
    event NotifyDriverPayment(address driver,string message);
    
    //User Function to End Journey and set Status as free from engaged -- Transaction from User to Driver
    function EndJourney(address payable  account) payable public returns(address ,uint256){ 
        emit NotifyDriverPayment(account,"You will be paid from the customer as per your charge now");
        profile[account].isEngaged = false;
        profile[account].NoOfRides += 1;

    }
    
    
    
    //User function to engage and call driver
    function EngageDriver(address driver_add,address cust_add) public {
        profile[driver_add].isEngaged = true;
        emit NotifyDriver(driver_add,"You have been hired by the customer",cust_add);
    }
    
        
    // Get driver balance
    function showBal(address add) public view returns(uint256){
        // return msg.sender.balance;
        return add.balance;
    }
    
    //If the Ride is cancelled
    function cancelRide(address driver_add,address cust_add) public{
        profile[driver_add].isEngaged = false;
        emit NotifyDriver(driver_add,"The ride is cancelled by the customer",cust_add);
    }
    
    //Self Destruct
      function kill() public onlyOwner{
            selfdestruct(msg.sender);
    }
    
    
}




