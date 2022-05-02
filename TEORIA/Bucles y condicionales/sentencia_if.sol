pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract Sentencia_IF {

    // Numero ganador
    function probarSuerte(uint _numero) public pure returns(bool) {

        bool ganador;
        if(_numero == 100){
            ganador = true;
        } else {
            ganador = false;
        }

        return ganador;
    }

    // Calculamos el valor absoluto de un numero
    function valorAbsoluto(int _numero) public pure returns(uint) {
        
        uint valor_absoluto_numero;
        if (_numero < 0) {
            valor_absoluto_numero = uint(-_numero);
        } else {
            valor_absoluto_numero = uint(_numero);
        }

        return valor_absoluto_numero;
    }

    // Devolver true si el numero introducido es par y tiene tres cifras
    function parTresCifras(uint _numero) public pure returns (bool) {

        bool flag = false;
        if ((_numero % 2 == 0) && (_numero >= 100) && (_numero < 999)){
            flag = true;
        }

        return flag;
    }

    // Votacion
    function Votar(string memory _candidato) public pure returns (string memory) {
        
        string memory mensaje;
        if (keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Joan"))) {
            mensaje = "Has votado correctamente a Joan";
        } else {
            if (keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Gabriel"))){
                mensaje = "Has votado correctamente a Gabriel";
            } else {
                if (keccak256(abi.encodePacked(_candidato)) == keccak256(abi.encodePacked("Maria"))){
                    mensaje = "Has votado correctamente a Maria";
                } else {
                    mensaje = "Has votado a un candidato que no esta en la lista";
                }
            }
        }

        return mensaje;

    }
}