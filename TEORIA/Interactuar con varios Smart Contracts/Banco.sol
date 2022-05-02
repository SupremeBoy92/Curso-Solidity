pragma solidity >=0.4.4 <0.7.0;

contract Banco {

    // Definimos un tipo de dato comlpejo
    struct cliente{
        string nombre;
        address direccion;
        uint dinero;
    }

    // Mapping que relaciona el nombre del cliente con el tipo de dato del cliente
    mapping(string => cliente) clientes;

    // Funcion que nos permita dar de alta un nuevo cliente
    function NuevoCliente(string memory _nombre) internal {
        clientes[_nombre] = cliente(_nombre, msg.sender, 0);
    }

}