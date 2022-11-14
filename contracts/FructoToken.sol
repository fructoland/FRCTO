// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract FructoToken is ERC20, ERC20Burnable, Ownable, Pausable, ERC20Permit, ERC20Votes {
	bool internal mintingEnabled = true;
	// This is not really ether
	// Since we are deploying on the Polygon network
	// This is the MATIC token
	uint256 internal mintingFee = 100 ether;

    constructor() ERC20("Fructo Token", "FRCTO") ERC20Permit("Fructo Token") {
		_mint(msg.sender, 10000 * 10 ** decimals());
	}

    function mint(uint256 amount) public payable {
		require(mintingEnabled, "Minting is disabled");
		require(!paused(), "Pausable: paused");
		require(msg.value == mintingFee * amount, "Incorrect minting fee");
		_mint(msg.sender, amount);
    }

	function getMintingFee() public view returns (uint256) {
		return mintingFee;
	}

	function setMintingEnabled(bool enabled) public onlyOwner {
		mintingEnabled = enabled;
	}

	function setMintingFee(uint256 fee) public onlyOwner {
		mintingFee = fee;
	}

	function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }
	
	function _afterTokenTransfer(address from, address to, uint256 amount) internal override (ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override (ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}
