// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

contract view_pure_payable{

    // Modificador de view

    string[] lista_alumnos;

    function nuevo_alumno(string memory _alumno) public {
        lista_alumnos.push(_alumno);
    }

    function ver_alumno(uint _posicion) view public returns(string memory){
        return lista_alumnos[_posicion];
    }

    uint x = 10;
    function sumarAx(uint _a) public view returns(uint) {
        return x + _a;
    }

    // Modificador de pure

    function exponenciacion(uint _a, uint _b) public pure returns(uint){
        return _a ** _b;
    }

    // Modificador de payable

    mapping(address => cartera) DineroCartera;

    struct cartera{
        string nombre;
        address direccion;
        uint dinero;
    }

    function Pagar(string memory _nombre, uint _cantidad) public payable {
        cartera memory mi_cartera;
        mi_cartera = cartera(_nombre, msg.sender, _cantidad);
        DineroCartera[msg.sender] = mi_cartera;
    }

    function verSaldo() public view returns(cartera) {
        return DineroCartera[msg.sender];
    }

}