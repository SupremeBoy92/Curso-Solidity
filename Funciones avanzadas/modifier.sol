pragma solidity >=0.4.4 <0.7.0;

contract Modifier {

    // Ejemplo de solo propietario del contrato puede ejecutar una funcion
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier SoloPropietario() {
        require(msg.sender == owner, "No tiene permisos");
        _;
    }

    function Ejemplo1() public SoloPropietario() {
        // Codigo de la funcion para el propietario
    }

    struct cliente {
        address direccion;
        string nombre;
    }

    mapping(string => address) clientes;

    function AltaCliente(string memory _nombre) public {
        clientes[_nombre] = msg.sender;
    }

    modifier SoloClientes(string memory _nombre) {
        require(clientes[_nombre] == msg.sender, "No eres cliente");
        _;
    }

    function Ejemplo2(string memory _nombre) public SoloClientes(_nombre) {
        // Logica de la funcion para los clientes
    }

    // Ejemplo de conduccion
    modifier MayorEdad(uint _edadMinima, uint _edadUsuario) {
        require(_edadUsuario >= _edadMinima, "No tienes la edad minima");
        _;
    }

    function Conducir(uint _edad) public MayorEdad(18, _edad) {
        // Logica de la funcion
    }
}