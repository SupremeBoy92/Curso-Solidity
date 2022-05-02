// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// Importamos la libreria SafeMath
import "./SafeMath.sol";

// Brando ----> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// Adrian ----> 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// Sanchez ---> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

// Interface de nuestro toke ERC20
interface IERC20 {

    // Devuelve la cantidad de tokens en existencia
    function totalSupply() external view returns(uint256);
    
    // Devuelve la cantidad de tokens para una direccion indicada por parametro
    function balanceOf(address account) external view returns(uint256);

    // Devuelve el numero de tokens que el spender podra gastar en nombre del propietario
    function allowance(address owner, address spender) external view returns(uint256);

    // Devuelve un valor booleano resultado de la operacion indicada
    function transfer(address to, uint256 amount) external returns(bool);

    function transferencia_disney(address cliente, address to, uint256 amount) external returns(bool);

    // Devuelve un valor booleano con el resultado de la operacion de gasto
    function approve(address spender, uint256 amount) external returns(bool);

    // Devuelve un valor booleano con el resultado de la operacion
    function transferFrom(address from, address to, uint256 amount) external returns(bool);

    // Evento que se debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Evento que de debe emitir cuando se establece una asignacion con un metodo allowance
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
}

// Implementacion de las funciones del token ERC20
contract ERC20Basic is IERC20 {

    // Variables constantes
    string public constant name = "DisneyCoin";
    string public constant symbol = "DSN";
    uint8 public constant decimals = 2;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);

    using SafeMath for uint256;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 totalSupply_;

    constructor (uint256 initialSupply) public {
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }



    function totalSupply() public override view returns(uint256) {
        return totalSupply_;
    }

    function increaseTotalSupply(uint newTokensAmount) public {
        totalSupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }

    function balanceOf(address tokenOwner) public override view returns(uint256) {
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate) public override view returns(uint256) {
        return allowed[owner][delegate];
    }

    function transfer(address to, uint256 numTokens) public override returns(bool) {
        // Comprobamos que el emisor tiene tokens en su cartera
        require(numTokens <= balances[msg.sender]);
        // Restamos tokens a la cartera del emisor
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        // Sumamos los tokens a la cartera del receptor
        balances[to] = balances[to].add(numTokens);
        // Emitimos evento de transfer
        emit Transfer(msg.sender, to, numTokens);

        return true;
    }

    function transferencia_disney(address _cliente, address to, uint256 numTokens) public override returns(bool) {
        // Comprobamos que el emisor tiene tokens en su cartera
        require(numTokens <= balances[_cliente]);
        // Restamos tokens a la cartera del emisor
        balances[_cliente] = balances[_cliente].sub(numTokens);
        // Sumamos los tokens a la cartera del receptor
        balances[to] = balances[to].add(numTokens);
        // Emitimos evento de transfer
        emit Transfer(_cliente, to, numTokens);

        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns(bool) {
        // Damos permisos al delegado para utilizar el numero de tokens deseado
        allowed[msg.sender][delegate] = numTokens;
        // Emitimos evento de aprovacion
        emit Approval(msg.sender, delegate, numTokens);

        return true;
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns(bool) {
        // Comprobamos que el owner tiene tokens en su cartera
        require(numTokens <= balances[owner]);
        // Comprobamos que el emisor tiene permisos para vender
        require(numTokens <= allowed[owner][msg.sender]);
        // Restamos tokens a la cartera owner y a los permisos del emisor
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        // Sumamos los tokens a la cartera del receptor
        balances[buyer] = balances[buyer].add(numTokens);
        // Emitimos evento de transferencia
        emit Transfer(owner, buyer, numTokens);

        return true;
    }

}