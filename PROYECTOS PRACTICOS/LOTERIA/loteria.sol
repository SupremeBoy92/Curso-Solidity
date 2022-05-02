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
    }

    // Balance de tokens en el contrato de loteria
    function TokensDisponibles() public view returns(uint) {
        return token.balanceOf(contrato);
    }

}