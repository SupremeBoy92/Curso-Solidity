// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

import "./OperacionesBasicas.sol";
import "./ERC20.sol";

// Contrato para la compañia de seguros
contract InsuranceFactory is OperacionesBasicas{
    
    constructor () public {
        token = new ERC20Basic(100);
        Insurance = address(this);
        Aseguradora = msg.sender;
    }

    // Estructuras de datos
    struct cliente {
        address DireccionCliente;
        bool AutorizacionCliente;
        address DireccionContrato;
    }

    struct servicio {
        string NombreServicio;
        uint PrecioServicio;
        bool EstadoServicio;
    }

    struct lab {
        address DireccionContratoLab;
        bool ValidacionLab;
    }

    // Instancia del contrato token
    ERC20Basic private token;

    // Declaracion de las direcciones
    address Insurance;
    address payable public Aseguradora;

    // Mapeos para clientes, servicios y laboratorios
    mapping (address => cliente) public MappingAsegurados;
    mapping (string => servicio) public MappingServicios;
    mapping (address => lab) public MappingLab;

    // Arrays para clientes, servicios y laboratorios
    address [] DireccionesAsegurados;
    string [] private NombreServicios;
    address [] DireccionesLaboratiorio;

    // Funcion que restringe solo para asegurados
    function FuncionUnicamenteAsegurados(address _direccionAsegurado) public view {
        require(MappingAsegurados[_direccionAsegurado].AutorizacionCliente == true, "No tienes autorizacion");
    }

    // Modificadores y restricciones sobre asegurados y aseguradoras
    modifier UnicamenteAsegurados(address _direccionAsegurado) {
        FuncionUnicamenteAsegurados(_direccionAsegurado);
        _;
    }

    modifier UnicamenteAseguradora(address _direccionAseguradora) {
        require(_direccionAseguradora == Aseguradora, "Direccion de Aseguradora no autorizada");
        _;
    }

    modifier Asegurado_o_Aseguradora(address _direccionAsegurado, address _direccionEntrante) {
        require( (MappingAsegurados[_direccionEntrante].AutorizacionCliente == true && _direccionAsegurado == _direccionEntrante) || Aseguradora == _direccionEntrante, "Solamente compañia de seguros o asegurados");
        _;
    }

    // Eventos
    event CompraTokens(uint256);
    event ServicioProporcionado(address, string, uint256);
    event LaboratorioCreado(address, address);
    event AseguradoCreado(address, address);
    event BajaAsegurado(address);
    event ServicioCreado(string, uint256);
    event BajaServicio(string);

    // Creacion de un contrato por un Laboratorio
    function CreacionLab() public {
        // Almacenamos la direccion del lab en el array
        DireccionesLaboratiorio.push(msg.sender);

        // Direccion del contrato del Lab
        address DireccionLab = address(new Laboratorio(msg.sender, Insurance));

        lab memory Laboratorio = lab(DireccionLab, true);

        // Relacionamos con el mapping
        MappingLab[msg.sender] = Laboratorio;

        // Emitir evento
        emit LaboratorioCreado(msg.sender, DireccionLab);
    }

}



contract Laboratorio is OperacionesBasicas {

    constructor (address _account, address _direccionContratoAseguradora) public {
        _account = 
        _direccionContratoAseguradora = 
    }
}