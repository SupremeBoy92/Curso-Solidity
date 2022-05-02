pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Require {
    
    // Funcion que verifica la contraseña
    function Password(string memory _pass) public pure returns(string memory) {
        require(keccak256(abi.encodePacked(_pass)) == keccak256(abi.encodePacked("12345")), "Contraseña incorrecta");
        return "Contraseña correcta";
    }

    // Funcion para pagar
    uint tiempo = 0;
    uint public cartera = 0;
    function Pagar(uint _cantidad) public returns(uint) {
        require(now > tiempo + 5 seconds, "Aun no puedes pagar");
        tiempo = now;
        cartera = cartera + _cantidad;
        return cartera;
    }

    // Actualizar una array
    string [] nombres;

    function NuevoNombre(string memory _nombre) public {
        for (uint i = 0; i < nombres.length; i++){
            require(keccak256(abi.encodePacked(_nombre)) != keccack256(abi.encodePacked(nombres[i])), "El nombre ya esta dento de la lista");
        }

        nombres.push(_nombre);
    }
}