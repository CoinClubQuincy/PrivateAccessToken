pragma solidity ^0.8.10;
// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

/// @title Token-gated pointer to encrypted off-chain data
/// @notice Nothing on a public chain is secret. This contract stores only a hash of the data and
/// a link to an encrypted copy, and both can be read by anyone. The real privacy comes from the
/// encryption and from an off-chain service that gives the decryption key to the token holder.
contract PrivateAccessToken is ERC1155{
    bytes32 private dataHash;
    string private encryptedDataURI;
    uint Token =0;
    // when contract is launched, the data hash, encrypted data link & URI will be defined
    constructor(bytes32 _dataHash,string memory _encryptedDataURI,string memory URI)ERC1155(URI){
        require(_dataHash != bytes32(0), "data hash is required");
        require(bytes(_encryptedDataURI).length > 0, "encrypted data link is required");
        dataHash = _dataHash;
        encryptedDataURI = _encryptedDataURI;
        _mint(msg.sender, Token, 1, "");
    }
    //The modifier is so only the token holder is allowed to access function 
    modifier OnlyToken(){
        require(OnlyIf(msg.sender)==true, "only the token holder can access");
        _;
    }
    //The OnlyIf Function will run in the modifier to check if the user accessing the contract is the token holder
    function OnlyIf(address _user)internal view returns(bool){
        if(balanceOf(_user,0)==1){
            return true;
        }else{
            return false;
        }
    }
    //This function will allow the Token Holder to view the hash and the encrypted data link.
    //It is a convenience for apps. Gating a view does not hide on-chain values.
    function ViewData() public OnlyToken view returns(bytes32,string memory){
        return (dataHash,encryptedDataURI);
    }
    //Anyone can check that data they were given is the data this contract refers to
    function verifyData(bytes32 _hash)public view returns(bool){
        return _hash == dataHash;
    }
    //This function will check if current account has token
    function ViewStatus()public view returns(uint){
        return balanceOf(msg.sender,0);
    }
}
