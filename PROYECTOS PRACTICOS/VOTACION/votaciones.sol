// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

// CANDIDATO / EDAD / ID
// -------------------------
// Toni      / 20   / 12345X
// Alberto   / 23   / 54321T
// Joan      / 21   / 98765P
// Javier    / 19   / 56789W

contract Votacion {

    // Direccion del propietario del contrato
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    // Relacion entre el nombre del candidato y el hash de sus datos personales
    mapping (string => bytes32) ID_Candidato;

    // Relacion entre el nombre del candidato y el numero de votos
    mapping(string => uint) votos_Candidato;

    // Lista para almacenar los nombres de los candidatos
    string [] candidatos;

    // Lista de los votantes
    bytes32 [] votantes;

    // Funcion que permite presentarse a las votaciones como candidato
    function NuevoCandidato(string memory _nombre, uint _edad, string memory _ID) public {

        // Hash de los datos del candidato
        bytes32 hash_Candidato = keccak256(abi.encodePacked(_nombre, _edad, _ID));

        // Verificamos si el votante ya ha votado
        for (uint256 i = 0; i < candidatos.length; i++) {
            require(ID_Candidato[_nombre] != hash_Candidato, "Este candidato ya se ha dado de alta.");
        }

        // Almacenar el hash en el mapping
        ID_Candidato[_nombre] = hash_Candidato;

        // Almacenamos los datos en la lista de candidatos
        candidatos.push(_nombre);
    }

    // Funcion para ver lo candidatos almacenados en la lista
    function VerCandidatos() public view returns(string[] memory) {
        
        // Devuelve la lista de candidatos
        return candidatos;
    }

    // Funcion que permite votar
    function Votar(string memory _candidato) public {

        // Calculamos el hash de la persona que ejecuta esta funcion
        bytes32 hash_Votante = keccak256(abi.encodePacked(msg.sender));

        // Verificamos si el votante ya ha votado
        for (uint256 i = 0; i < votantes.length; i++) {
            require(votantes[i] != hash_Votante, "Ya has votado previamente.");
        }

        // Almacenamos el hash en la lista de votantes
        votantes.push(hash_Votante);

        // Añadimos un voto al candidato

        votos_Candidato[_candidato] ++;
    }

    // Funcion que nos permite ver los votos de un candidato
    function VerVotos(string memory _candidato) public view returns(uint) {

        // Devolvemos el numero de votos
        return votos_Candidato[_candidato];
    }

    // Mostrar los votos de cada candidato
    function VerResultados() public view returns(string memory) {

        // Guardamos en una variable los candidatos con sus respectivos votos
        string memory resultados = "";

        // Recorremos el array de candidatos
        for (uint256 i = 0; i < candidatos.length; i++) {

            // Actualizamos el string resultados y añadimos el candidato
            resultados = string(abi.encodePacked(resultados, "----", "(", candidatos[i], ",", uint2str(VerVotos(candidatos[i])), ")", "----"));
        }

        return resultados;
    }

    //Funcion auxiliar que transforma un uint a un string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    // Funcion que nos muestra el candidato con mas votos
    function Ganador() public view returns(string memory) {

        // La variable ganador contendra el nombre del candidato con mas votos
        string memory ganador = candidatos[0];
        // La variable flag nos sirve para la situacion de empate
        bool flag;

        // Recorremos la array de candidatos para determinar al candidato con el mayor numero de votos
        for (uint256 i = 0; i < candidatos.length; i++) {

            // Comparamos si nuestro ganador ha sido superado por otro candidato
            if (votos_Candidato[ganador] < votos_Candidato[candidatos[i]]) {
                // Actualizamos el ganador
                ganador = candidatos[i];
                flag = false;
            } else {
                // Comprobamos si hay empate
                if (votos_Candidato[ganador] == votos_Candidato[candidatos[i]]) {
                    flag = true;
                }
            }

        }

        // En caso de empate modificamos el ganador
        if (flag == true) {
            ganador = "¡Hay un empate entre los candidatos!";
        }

        return ganador;
    }

}