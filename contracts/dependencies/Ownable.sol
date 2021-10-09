// SPDX-License-Identifier: MIT

// Derived from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/1b27c13096d6e4389d62e7b0766a1db53fbb3f1b/contracts/access/Ownable.sol
// Adds pending owner

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Context.sol";
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;
    address public pendingOwner;

    event PendingOwnershipTransferred(address indexed previousPendingOwner, address indexed newPendingOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to the pendingOwner.
     * Can only be called by the pendingOwner.
     */
    function transferOwnership() public virtual {
        require(_msgSender() == pendingOwner, "Ownable: caller is not the pendingOwner");
        require(pendingOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(pendingOwner);
    }

    /**
     * @dev Sets the pendingOwner, ownership is only transferred when they call transferOwnership.
     * Can only be called by the current owner.
     */
    function setPendingOwner(address newPendingOwner) external onlyOwner {
        address oldPendingOwner = pendingOwner;
        pendingOwner = newPendingOwner;

        emit PendingOwnershipTransferred(oldPendingOwner, pendingOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        pendingOwner = address(0);
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}