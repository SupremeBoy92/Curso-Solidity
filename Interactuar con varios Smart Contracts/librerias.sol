pragma solidity >=0.4.4 <0.7.0;

library Operaciones {

    function Division(uint _i, uint _j) public pure returns(uint) {
        require(_j > 0, "No podemos dividir por 0");
        return _i / _j;
    }

    function Multiplicacion(uint _i, uint _j) public pure returns(uint) {
        if ((_i == 0) || (_j == 0)) {
            return 0;
        } else {
            return _i * _j;
        }
    }
}

contract Calculos {

    using Operaciones for uint;

    function Calculo(uint _a, uint _b) public pure returns(uint, uint) {
        uint q = _a.Division(_b);
        uint m = _a.Multiplicacion(_b);
        return (q, m);
    }
}