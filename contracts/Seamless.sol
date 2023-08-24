// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Seamless is ReentrancyGuard, Ownable {
    event TokenSent(string indexed name);
    event ChangeVaultAddress(address indexed newVaultAddress);

    address private _vaultAddress;

    constructor(address vaultAddress) Ownable() {
        _vaultAddress = vaultAddress;
    }

    function transfer(address _token, string memory _name) external payable nonReentrant {
        require(msg.value > 0, "Amount must be more than zero!");
        IERC20(_token).transferFrom(msg.sender, _vaultAddress, msg.value);
        emit TokenSent(_name);
    }

    function transfer_erc20(string memory _name) external payable nonReentrant {
        require(msg.value > 0, "Amount must be more than zero!");
        (bool success, ) = payable(_vaultAddress).call{value: msg.value}("");
        require(success, "Transfer failed!");
        emit TokenSent(_name);
    }

    function vault_address() public view returns(address) {
        return _vaultAddress;
    }

    function update_router(address newVaultAddress) public nonReentrant onlyOwner {
        _vaultAddress = newVaultAddress;
        emit ChangeVaultAddress(newVaultAddress);
    }
}