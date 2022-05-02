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

contract Cliente is Banco {

    function AltaCliente(string memory _nombre) public {
        NuevoCliente(_nombre);
    }

    function IngresarDinero(string memory _nombre, uint _cantidad) public {
        clientes[_nombre].dinero = clientes[_nombre].dinero + _cantidad;
    }

    function RetirarDinero(string memory _nombre, uint _cantidad) public returns(bool) {
        bool flag = true;

        if (clientes[_nombre].dinero - _cantidad > 0) {
            clientes[_nombre].dinero = clientes[_nombre].dinero - _cantidad;
        } else {
            flag = false;
        }

        return flag;
    }

    function ConsultarDinero(string memory _nombre) view public returns (uint) {
        return clientes[_nombre].dinero;
    }
}