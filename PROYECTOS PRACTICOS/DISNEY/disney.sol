// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Disney {

    // Instancia del contrato token
    ERC20Basic private token;

    // Direccion de Disney (owner)
    address payable public owner;

    // Constructor
    constructor() public {
        token = new ERC20Basic(10000);
        owner = msg.sender;
    }

    // Estructura de datos para almacenar a los clientes de Disney
    struct cliente {
        uint tokens_comprados;
        string [] atracciones_disfrutadas;
    }

    // Mapping para el registo de clientes
    mapping (address => cliente) public Clientes;

    // Funcion para establecer el precio de un Token
    function PrecioToken(uint _numTokens) internal pure returns(uint) {
        // Conversion de Tokens a Ethers
        return _numTokens * (1 ether);
    }

    // Funcion para comprar Tokens
    function ComprarTokens(uint _numTokens) public payable {
        // Establecer el precio del token
        uint coste = PrecioToken(_numTokens);

        // Se evalua el dinero que el cliente paga por los Tokens
        require(msg.value >= coste, "Compra menos Tokens o paga con mas Ethers.");

        // Diferencia de precio
        uint returnValue = msg.value - coste;

        // Disney retorna la cantidad de Ethers al cliente
        msg.sender.transfer(returnValue);

        // Obtencion del numero de Tokens disponibles
        uint Balance = balanceOf();
        require(_numTokens <= Balance, "Compra un numero menor de Tokens.");

        // Se transfiere el numero de Tokens al cliente
        token.transfer(msg.sender, _numTokens);

        // Registro de tokens comprados
        Clientes[msg.sender].tokens_comprados += _numTokens;
    }

    // Balance de Tokens del contrato Disney
    function balanceOf() public view returns(uint) {
        return token.balanceOf(address(this));
    }

    // Visualizar el numero de Tokens restantes de un Cliente
    function MisTokens() public view returns(uint) {
        return token.balanceOf(msg.sender);
    }

    // Funcion para generar mas Tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    // Modificador para controlar las funciones ejecutables por Disney
    modifier Unicamente(address _direccion) {
        require(_direccion == owner, "No tienes permisos para ejecutar esta funcion.");
        _;
    }

    // Gestion de Disney

    // Eventos
    event disfruta_atraccion(string, uint, address);
    event nueva_atraccion(string, uint);
    event baja_atraccion(string);

    // Estructura de la atraccion
    struct atraccion {
        string nombre_atraccion;
        uint precio_atraccion;
        bool estado_atraccion;
    }

    // Mapping para relacionar un nombre de atraccion con una estructura de datos
    mapping (string => atraccion) public MappingAtracciones;

    // Array para almacenar el nombre de las atracciones
    string [] Atracciones;

    // Mapping para relacionar una identidad con su historial en Disney
    mapping (address => string []) HistorialAtracciones;

    // Funcion que permite dar de alta atracciones
    function NuevaAtraccion(string memory _nombreAtraccion, uint _precio) public Unicamente(msg.sender) {
        // Creacion de una atraccion en Disney
        MappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion, _precio, true);

        // Añadir la nueva atraccion a la array
        Atracciones.push(_nombreAtraccion);

        // Emitimos evento
        emit nueva_atraccion(_nombreAtraccion, _precio);
    }

    // Funcion para dar de baja una atraccion
    function BajaAtraccion(string memory _nombreAtraccion) public Unicamente(msg.sender) {
        // Cambiar el estado de la atraccion a false
        MappingAtracciones[_nombreAtraccion].estado_atraccion = false;

        // Emitimos evento
        emit baja_atraccion(_nombreAtraccion);
    }

    // Visualizar las atracciones
    function AtraccionesDisponibles() public view returns(string [] memory) {
        return Atracciones;
    }

    // Pagar para usar una atraccion
    function SubirseAtraccion(string memory _nombreAtraccion) public {
        // Precio de la atraccion en Tokens
        uint tokens_atraccion = MappingAtracciones[_nombreAtraccion].precio_atraccion;

        // Verifica el estado de la atraccion
        require(MappingAtracciones[_nombreAtraccion].estado_atraccion == true, "La atraccion no esta disponible en estos momentos.");

        // Verificar el numero de Tokens que tiene el cliente
        require(tokens_atraccion <= MisTokens(), "No tienes suficientes tokens.");

        // Pago de los Tokens
        token.transferencia_disney(msg.sender, address(this), tokens_atraccion);

        // Historial de atracciones
        HistorialAtracciones[msg.sender].push(_nombreAtraccion);

        // Emision de evento
        emit disfruta_atraccion(_nombreAtraccion, tokens_atraccion, msg.sender);
    }

    // Visualizar el historial completo de atracciones disfrutadas por un cliente
    function Historial() public view returns(string [] memory) {
        return HistorialAtracciones[msg.sender];
    }

    // Devolucion de los tokens no gastados
    function DevolverTokens(uint _numTokens) public payable {
        // Verificamos el numero de tokens a devolver
        require(_numTokens > 0, "Necesitas devolver una cantidad positiva de tokens.");

        // El usuario debe tener el numero de tokens que desea devolver
        require(_numTokens <= MisTokens(), "No tienes los tokens que deseas devolver.");

        // El cliente devuelve los tokens
        token.transferencia_disney(msg.sender, address(this), _numTokens);

        // Devolver Ether por los Tokens
        msg.sender.transfer(PrecioToken(_numTokens));
    }

    // Eventos
    event disfruta_comida(string, uint, address);
    event nueva_comida(string, uint);
    event baja_comida(string);

    // Estructura de la comida
    struct comida {
        string nombre_comida;
        uint precio_comida;
        bool estado_comida;
    }

    // Mapping para relacionar un nombre de comida con una estructura de datos
    mapping (string => comida) public MappingComida;

    // Array para almacenar el nombre de las comidas
    string [] Comidas;

    // Mapping para relacionar una identidad con su historial de comidas
    mapping(address => string []) HistorialComida;

    // Dar de alta comida
    function NuevaComida(string memory _nombreComida, uint _precio) public Unicamente(msg.sender) {
        // Creacion del nuevo plato de comida
        MappingComida[_nombreComida] = comida(_nombreComida, _precio, true);

        // Añadimos el plato a la array
        Comidas.push(_nombreComida);

        // Emitimos evento
        emit nueva_comida(_nombreComida, _precio);
    }

    // Funcion para dar de baja un plato de comida
    function BajaComida(string memory _nombreComida) public Unicamente(msg.sender) {
        // Cambiar el estado de la comida a false
        MappingComida[_nombreComida].estado_comida = false;

        // Emitimos evento
        emit baja_comida(_nombreComida);
    }

    // Visualizar los platos de comida disponibles
    function ComidaDisponible() public view returns(string [] memory) {
        return Comidas;
    }

    // Pagar para consumir un plato de comida
    function ComprarComida(string memory _nombreComida) public {
        // Precio del plato de comida
        uint tokens_comida = MappingComida[_nombreComida].precio_comida;

        // Verificamos el estado del plato de comida
        require(MappingComida[_nombreComida].estado_comida == true, "El plato seleccionado no esta disponible.");

        // Verificamos el numero de tokens que tiene el cliente
        require(tokens_comida <= MisTokens(), "No tienes suficientes tokens.");

        // Pago de los Tokens
        token.transferencia_disney(msg.sender, address(this), tokens_comida);

        // Historial de comida
        HistorialComida[msg.sender].push(_nombreComida);

        // Emision de evento
        emit disfruta_comida(_nombreComida, tokens_comida, msg.sender);
    }

    // Visualizar el historial completo de comida comprada
    function HistorialPlatos() public view returns(string [] memory) {
        return HistorialComida[msg.sender];
    }



}