pragma solidity ^0.4.4;

import "zeppelin-solidity/contracts/SafeMathLib.sol";
import "./TokenStorage.sol";

library ERC20Lib {
    using SafeMathLib for uint;

    // EVENTS
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    // EXTERNAL
    function transfer(TokenStorage db, address _caller, address _to, uint _value) 
        returns (bool success) 
    {
        db.subBalance(_caller, _value);
        db.addBalance(_to, _value);
        Transfer(_caller, _to, _value);
        return true;
    }

    function transferFrom(
        TokenStorage db, 
        address _caller, 
        address _from, 
        address _to, 
        uint _value
    ) returns (bool success) {
        var allowance = db.getAllowed(_from, _caller);

        db.subBalance(_from, _value);
        db.addBalance(_to, _value);
        db.setAllowed(_from, _caller, allowance.minus(_value));
        Transfer(_from, _to, _value);
        return true;
    }

    // EXTERNAL CONSTANT
    function balanceOf(TokenStorage db, address _owner) 
        constant 
        returns (uint balance) 
    {
        return db.getBalance(_owner);
    }

    // TODO: approveAndCall
    // TODO: race condition
    function approve(TokenStorage db, address _caller, address _spender, uint _value) 
        constant
        returns (bool success) 
    {
        db.setAllowed(_caller, _spender, _value);
        Approval(_caller, _spender, _value);
        return true;
    }

    function allowance(TokenStorage db, address _owner, address _spender) 
        constant 
        returns (uint remaining) 
    {
        return db.getAllowed(_owner, _spender);
    }
}
