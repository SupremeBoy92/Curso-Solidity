// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract ValoresDeRetorno {

    // Funcion que nos devuelva un saludo
    function Saludo() public returns(string memory) {
        return "Saludos";
    }

    // Esta funcon calcula el resultado de una multiplicacion
    function Multiplicacion(uint _a, uint _b) public returns(uint) {
        return _a * _b;
    }

    // Esta funcion devuelve true si el numero es par y false en caso contrario
    function par_impar(uint _a) public returns(bool) {
        bool flag;

        if(_a%2 == 0)
        {
            flag = true;
        }
        else
        {
            flag = false;
        }

        return flag;
    }

    // Esta funcion devuelve el cociente y el resudio de una division
    // Ademas de una variable booleana que es true si el residuo es 0 y false en caso contrario
    function Division(uint _a, uint _b) public returns (uint, uint, bool) {
        uint q = _a / _b;
        uint r = _a % _b;
        bool multiplo = false;

        if(r == 0)
        {
            multiplo = true;
        }

        return (q, r, multiplo);
    }

    // Practica para el manejo de los valores devueltos
    function numeros() public returns (uint, uint, uint, uint, uint, uint) {
        return (1, 2, 3, 4, 5, 6);
    }

    // Asignacion multiple
    function todos_los_valores() public {
        uint a;
        uint b;
        uint c;
        uint d;
        uint e;
        uint f;

        (a,b,c,d,e,f) = numeros();
    }

}