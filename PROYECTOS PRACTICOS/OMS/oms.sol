// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

contract OMS_COVID {

    // Direccion de la oms
    address public OMS;

    // Constructor del contrato
    constructor() public {
        OMS = msg.sender;

    }

    // Mapping para relacionar los centros de salud con la validez del sistema de gestion
    mapping (address => bool) public Validacion_CentrosSalud;

    // Relaciona una direccion de un Centro de Salud con su direccion de contrato
    mapping (address => address) public CentroSalud_Contrato;

    // Array de direcciones que almacene los contratos de los centros de salud validados
    address [] public direcciones_contratos_salud;

    // Array de las direcciones que soliciten acceso
    address [] Solicitudes;

    // Eventos a emitir
    event NuevoCentroValidado(address);
    event NuevoContrato(address, address); 
    event SolicitudAcceso(address);

    // Modificador que permita unicamente la ejecucion de funciones por la OMS
    modifier UnicamenteOMS(address _direccion) {
        require(_direccion == OMS, "No tienes permisos para realizar esta funcion.");
        _;
    }

    // Funcion para solicitar acceso al sistema medico
    function SolicitarAcceso() public {
        // Almacenamos la direccion el en arraya de solicitudes
        Solicitudes.push(msg.sender);

        // Emitir evento
        emit SolicitudAcceso(msg.sender);
    }

    // Funcion que visualiza las direcciones que han solicitado acceso
    function VerSolicitudes() public view UnicamenteOMS(msg.sender) returns(address [] memory) {
        return Solicitudes;
    }

    // Funcion para validar nuevos centros de salud que pueda autogestionarse
    function NuevoCentro(address _direccionCentro) public UnicamenteOMS(msg.sender) {
        // Asignacion del estado de validez al centro de salud
        Validacion_CentrosSalud[_direccionCentro] = true;

        // Emitir evento
        emit NuevoCentroValidado(_direccionCentro);
    }

    // Funcion que permita crear un contrato inteligente
    function FactoryCentroSalud() public {
        // Filtrado para que unicamente los centros de salud validados sean capaces de ejecutar la funcion
        require(Validacion_CentrosSalud[msg.sender] == true, "No tienes permisos para realizar esta funcion.");

        // Generar un Smart Contract
        address contrato_CentroSalud = address (new CentroSalud(msg.sender));

        // Almacenamos la direccion del contrato en la array
        direcciones_contratos_salud.push(contrato_CentroSalud);

        // Relacion entre el Centro de Salud y su contrato
        CentroSalud_Contrato[msg.sender] = contrato_CentroSalud;

        // Emitir evento
        emit NuevoContrato(contrato_CentroSalud, msg.sender);
    }
}

// Contrato autogestionable por el Centro de Salud
contract CentroSalud {

    // Direcciones iniciales
    address public DireccionContrato;
    address public DireccionCentroSalud;

    constructor (address _direccion) public {
        DireccionContrato = address(this);
        DireccionCentroSalud = _direccion;
    }

    // Mapping para relacionar el hash de la persona con los resultados IPFS
    mapping (bytes32 => Resultados) ResultadosCOVID;

    // Estructura de los resultados
    struct Resultados {
        bool diagnostico;
        string CodigoIPFS;
    }

    // Eventos
    event NuevoResultado(bool, string);

    // Filtra las funciones a ejecutar por el Centro de Salud
    modifier UnicamenteCentroSalud(address _direccion) {
        require(_direccion == DireccionCentroSalud, "No tienes permisos para ejecutar esta funcion.");
        _;
    }

    // QmVnHMpMPEAyg44aoPPwhvRAF22zwSpaNrveaRBAbumsbk
    // Funcion para emitir un resultado de una prueba de COVID
    function ResultadosPruebaCOVID(string memory _idPersona, bool _resultadoCOVID, string memory _codigoIPFS) public UnicamenteCentroSalud(msg.sender) {
        // Hash de la identificacion
        bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));

        // Relacion del hash de la persona con la estructura de resultados
        ResultadosCOVID[hash_idPersona] = Resultados(_resultadoCOVID, _codigoIPFS);

        // Emitir evento
        NuevoResultado(_resultadoCOVID, _codigoIPFS);
    }

    // Funcion para visualizar los resultados de la prueba COVID
    function VerResultados(string memory _idPersona) public view returns(string memory, string memory) {
        // Hash de la identidad de la persona
        bytes32 hash_idPersona = keccak256(abi.encodePacked(_idPersona));

        // Retorno de un booleano como un string
        string memory resultadoPrueba;

        if (ResultadosCOVID[hash_idPersona].diagnostico == true) {
            resultadoPrueba = "Positivo";
        } else {
            resultadoPrueba = "Negativo";
        }

        return (resultadoPrueba, ResultadosCOVID[hash_idPersona].CodigoIPFS);
    }
}