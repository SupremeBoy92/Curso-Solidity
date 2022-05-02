// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Arrays {

    // Array de enteros de longitud fija
    uint[5] public array_enteros = [1, 2, 3];

    // Array de enteros de 32 bits
    uint32[7] array_enteros_32bits;

    // Array de strings de longitud fija
    string[15] array_strings;

    // Array dinamico de enteros
    uint[] array_dinamico_enteros;

    struct Persona {
        string nombre;
        uint edad;
    }

    // Array dinamico de tipo Persona
    Persona[] public array_dinamico_personas;

    function modificar_array(uint _numero) public {
        array_dinamico_enteros.push(_numero);
    }

}