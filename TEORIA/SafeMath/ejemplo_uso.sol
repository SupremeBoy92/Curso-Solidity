pragma solidity >=0.4.4 <0.7.0;

import "./SafeMath.sol";

contract CalculosSeguros {

    // Declaramos para que datos usaremos la libreria
    using SafeMath for uint;

    // Funcion suma segura
    function Suma(uint _a, uint _b) public pure returns(uint) {
        return _a.add(_b);
    }

    // Funcion resta segura
    function Resta(uint _a, uint _b) public pure returns(uint) {
        return _a.sub(_b);
    }

    // Funcion multiplicacion
    function Multiplicacion(uint _a, uint _b) public pure returns(uint) {
        return _a.mul(_b);
    }
}