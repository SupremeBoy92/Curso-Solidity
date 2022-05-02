pragma solidity >=0.4.4 <0.7.0;

contract Bucles {

    // Suma de los 100 primeros numeros a partir del numero introducido
    function Suma(uint _numero) public pure returns(uint) {

        uint suma = 0;

        for (uint i = _numero; i < (100 + _numero); i++) {
            suma = suma +i;
        }

        return suma;
    }

    // Array dinamico de direcciones
    address [] direcciones;

    // Añade una direccion a la array
    function Asociar() public {
        direcciones.push(msg.sender);
    }

    // Comprobar si la direccion esta en la array de direcciones
    function ComprobarAsociacion() public view returns(bool, address) {

        for (uint i = 0; i < direcciones.length; i++) {
            if (msg.sender == direcciones[i]) {
                return (true, direcciones[i]);
            }
        }
    }

    // For dentro de un for
    function SumaFactorial() public pure returns(uint) {

        uint suma = 0;
        for (uint i = 1; i <= 10; i++) {
            
            uint factorial = 1;
            for (uint j = 2; j <= i; j++) {
                factorial = factorial * j;
            }

            suma = suma + factorial;
        }
        return suma;
    }
}