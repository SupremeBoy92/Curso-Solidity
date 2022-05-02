// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Tiempo {
    
    // Unidades de tiempo
    uint public tiempo_actual = block.timestamp;
    uint public un_minuto = 1 minutes;
    uint public dos_horas = 2 hours;
    uint public cincuenta_dias = 50 days;
    uint public una_semana = 1 weeks;

    // Operamos con las unidades de tiempo
    function MasSegundos() public view returns(uint) {
        return tiempo_actual + 50 seconds;
    }

    function MasHoras() public view returns(uint) {
        return tiempo_actual + 1 hours;
    }

    function MasDias() public view returns(uint) {
        return tiempo_actual + 3 days;
    }

    function MasSemanas() public view returns(uint) {
        return tiempo_actual + 1 weeks;
    }
}