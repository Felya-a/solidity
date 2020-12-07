pragma solidity 0.5.1;

contract genesis {
    uint public iteral  = 0;
    address[] Admins;
    struct Diploms {string name; string surname; uint year; string link; string CRC; uint id;}
    mapping (uint => Diploms) public Work;
    modifier only_Admins{
        require (checkStatus());
        _;
    }
    
    constructor() public {
        Admins.push(msg.sender);
    }
    
    function upload (string memory name, string memory surname,uint year,string memory link,string memory CRC) public {
        uint id = uint(keccak256(abi.encodePacked(name, surname, year)));
        for (uint i = 0; i <= iteral; i++){
            if (iteral == 0) {
                Work[iteral] = Diploms(name, surname, year, link, CRC, id);
                break;
            }
            if (Work[i].id == id) {
                if (checkStatus()) {
                    Work[i] = Diploms(name, surname, year, link, CRC, id);
                    iteral ++;
                    break;
                }
            }
            else {
                if (i == iteral) Work[iteral] = Diploms(name, surname, year, link, CRC, id);
            }
        }
        iteral ++;
    }
    // НАДО ПЕРЕДЕЛАТЬ ФУНКЦИЮ ТАК КАК ИЩЕТ НЕ ПРАВИЛЬНО
    function check (string memory CRC) public view returns (string memory, string memory, uint, string memory) {
        for (uint i = 0; i <= iteral; i++){
            if (keccak256(bytes(Work[i].CRC)) == keccak256(bytes(CRC))) return (Work[i].name, Work[i].surname, Work[i].year, Work[i].link);
        }
    }

    function download (string memory name, string memory surname, uint year) public view only_Admins returns(string memory){
        uint id = uint(keccak256(abi.encodePacked(name, surname, year)));
        for (uint i = 0; i <= iteral; i++){
            if (Work[i].id == id) return Work[i].link;
        }
        return "None";
    }
    
    function addAdmin(address newAdmin) public only_Admins{
        Admins.push(newAdmin);
    }
    
    function getStatus (address _address) public view returns(string memory) {
        if (checkStatus(_address)) return "Admin";
        else return "User";
    }
    
    function checkStatus() private view returns(bool){
        for (uint i = 0; i < Admins.length; i++){
            if (msg.sender == Admins[i]) return true;
        }
        return false;
    }
    
    function checkStatus(address _address) private view returns(bool){
        for (uint i = 0; i < Admins.length; i++){
            if (_address == Admins[i]) return true;
        }
        return false;
    }

}

