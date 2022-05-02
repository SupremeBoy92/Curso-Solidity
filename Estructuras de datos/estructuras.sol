// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Estructuras {

    // Cliente de una pagina web de pago
    struct Cliente {
        uint id;
        string name;
        string dni;
        string mail;
        uint phoneNumber;
        uint creditNumber;
        uint secretNumber;
    }

    // Declaramos una variable de tipo cliente
    Cliente cliente_1 = Cliente(1, "Joan", "12345678B", "joan@udemy.com", 12345678, 1234, 11);


    // Amazon 
    struct Producto {
        string name;
        uint price;
    }

    // Declaramos una variable de tipo producto
    Producto movil = Producto("samsung", 300);

    // Proyecto cooperativo de ONGs
    struct ONG {
        address ong;
        string name;
    }

    // Declaramos una variable de tipo ong
    ONG caritas = ONG(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, "Caritas");

    struct Causa {
        uint id;
        string name;
        uint precio_objetivo;
    }

    // Declaramos una variable de tipo causa
    Causa medicamentos = Causa(1, "medicamentos", 1000);

}