// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Funciones {

    // Añadir dentro de un array de direcciones, la direccion de la persona que llame a la funcion
    address[] public direcciones;

    function nuevaDireccion() public {
        direcciones.push(msg.sender);
    }

    // Computar el hash de los datos proporcionados como parametros
    bytes32 public _hash;

    function getHash(string memory _datos) public {
        _hash = keccak256(abi.encodePacked(_datos));
    }

    // Declaramos un tipo de dato complejo, que es comida
    struct comida {
        string nombre;
        string ingredientes;
    }

    // Vamos a crear un tipo de dato complejo
    comida public hamburguesa;

    function Hamburguesas(string memory _ingredientes) public {
        hamburguesa = comida("Hamburguesa", _ingredientes);
    }

    struct alumno {
        string nombre;
        address direccion;
        uint edad;
    }

    bytes32 public hash_ID_alumno;
    // Calculamos el hash del alumno
    function hashIDAlumno(string memory _nombre, address _direccion, uint _edad) private {
        _hash = keccak256(abi.encodePacked(_nombre, _direccion, _edad));
    }

    // Guardamos con la funcion publica dentro de una lista los alumnos
    alumno[] public lista;
    mapping (string => bytes32) alumnos;

    function nuevoAlmuno(string memory _nombre, uint _edad) public {
        lista.push(alumno(_nombre, msg.sender, _edad));
        hashIDAlumno(_nombre, msg.sender, _edad);
        alumnos[_nombre] = hash_ID_alumno;
    }

}