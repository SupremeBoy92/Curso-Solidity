// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ERC20.sol";

contract Loteria {

    // Instancia del contrato token
    ERC20Basic private token;

    // Direcciones
    address public owner;
    address public contrato;

    // Numero de tokens a crear
    uint tokens_creados = 10000;

    // Eventos
    event ComprandoTokens(uint, address);

    // Constructor
    constructor() public {
        token = new ERC20Basic(tokens_creados);
        owner = msg.sender;
        contrato = address(this);
    }

    // --------------------------------------------- TOKEN ----------------------------------

    // Establece el precio de los tokens
    function PrecioTokens(uint _numTokens) internal pure returns(uint) {
        return _numTokens * 1 ether;
    }

    // Crear mas tokens
    function GeneraTokens(uint _numTokens) public Unicamente(msg.sender) {
        token.increaseTotalSupply(_numTokens);
    }

    modifier Unicamente(address _direccion) {
        require(_direccion == owner, "No tienes permisos.");
        _;
    }

    // Funcion para comprar tokens
    function CompraTokens(uint _numTokens) public payable {
        // Calculamos el coste del token
        uint coste = PrecioTokens(_numTokens);

        // Se requiere que el valor de ethers pagados sea equivalente al coste
        require(msg.value >= coste, "Compra menos Tokens o paga con mas Ethers");

        // Diferencia a pagar
        uint returnValue = msg.value - coste;

        // Transferencia de la diferencia
        msg.sender.transfer(returnValue);

        // Obtener el balance de tokens del contrato
        uint Balance = TokensDisponibles();

        // Filtro para evaluar los Tokens a comprar con los Tokens disponibles
        require(_numTokens <= Balance, "Compra un numero de Tokens adecuado");

        // Transferencia del Token al comprador
        token.transfer(msg.sender, _numTokens);

        // Emitimos evento
        ComprandoTokens(_numTokens, msg.sender);
    }

    // Balance de tokens en el contrato de loteria
    function TokensDisponibles() public view returns(uint) {
        return token.balanceOf(contrato);
    }

    // Obtener el balance de Tokens que se acumulan en el bote
    function Bote() public view returns(uint) {
        return token.balanceOf(owner);
    }

    // Obtiene la cantidad te Tokens que tiene
    function MisTokens() public view returns(uint) {
        return token.balanceOf(msg.sender);
    }

    // --------------------------------------------- LOTERIA ----------------------------------

    // Precio del boleto en tokens
    uint public PrecioBoleto = 5;

    // Mapping que relaciona la persona que compra y los numeros de los boletos
    mapping (address => uint []) idPersona_boletos;

    // Mapping que relaciona al ganador
    mapping (uint => address) ADN_boleto;

    // Numero aleatorio
    uint randNonce = 0;

    // Registro de boletos generados
    uint [] boletos_comprados;

    // Eventos
    event boleto_comprado(uint, address);
    event boleto_ganador(uint);
    event tokens_devueltos(uint, address);

    // Funcion para comprar boletos de loteria
    function ComprarBoleto(uint _cantidad) public {
        // Precio total de los boletos
        uint PrecioTotal = _cantidad * PrecioBoleto;

        // Comprobamos que tiene suficiente Tokens
        require(PrecioTotal <= MisTokens(), "No tienes suficientes Tokens.");

        // Enviamos los Tokens al bote
        token.transferencia_loteria(msg.sender, owner, PrecioTotal);

        // Creamos un bucle for para hacer un numero aleatorio con el tiempo actual, msg.sender y randnonce
        for (uint256 i = 0; i < _cantidad; i++) {
            uint random = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 10000;
            randNonce++;

            // Almacenamos los datos de los boletos
            idPersona_boletos[msg.sender].push(random);

            // Numero de boleto comprado
            boletos_comprados.push(random);

            // Almacenamos el ADN dedl boleto
            ADN_boleto[random] = msg.sender;

            // Emitir evento
            boleto_comprado(random, msg.sender);
        }
    }

    // Visualizar el numero de boletos de una persona
    function MisBoletos() public view returns(uint [] memory) {
        // Devolvemos los boletos
        return idPersona_boletos[msg.sender];
    }

    // Funcion para generar un ganador e ingresarle los Tokens
    function GenerarGanador() public Unicamente(msg.sender) {
        // Declaracion de la longitud de la array
        uint longitud = boletos_comprados.length;

        // Debe haber boletos comprados para generar un ganador
        require(longitud > 0 , "No hay boletos comprados");

        // Aleatoriamente elijo un numero entre 0 - longitud
        uint posicion_array = uint (uint(keccak256(abi.encodePacked(now))) % longitud);

        // Eleccion del numero aleatorio
        uint eleccion = boletos_comprados[posicion_array];

        // Emitir evento
        emit boleto_ganador(eleccion);
    
        // Recuperar la direccion del ganador
        address direccion_ganador = ADN_boleto[eleccion];

        // Enviarle los Tokens al ganador
        token.transferencia_loteria(msg.sender, direccion_ganador, Bote());
    }

    // Funcion para cambiar Tokens por Ethers
    function CambiarTokens(uint _numTokens) public payable {
        // Comprobamos que la cantidad sea positiva
        require(_numTokens > 0, "No puedes cambiar menos de 0 Tokens");

        // Comprobamos el numero de tokens
        require(_numTokens <= MisTokens(), "No tienes suficientes Tokens.");

        // El cliente devuelve los tokens
        token.transferencia_loteria(msg.sender, address(this), _numTokens);

        // Pagamos con Ether al cliente
        msg.sender.transfer(PrecioTokens(_numTokens));

        // Emitimos evento
        emit tokens_devueltos(_numTokens, msg.sender);
    }

}