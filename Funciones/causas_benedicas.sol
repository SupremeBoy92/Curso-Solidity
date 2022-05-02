pragma solidity >=0.4.4 <0.7.0;

contract CausasBeneficas{

    // Declaraciones necesarias
    struct Causa{
        uint id;
        string nombre;
        uint precio_objetivo;
        uint cantidad_recaudada;
    }

    uint contador_causas = 0;
    mapping(string => Causa) causas;

    // Permite dar de alta una nueva causa
    function NuevaCausa(string memory _nombre, uint _precio_objetivo) public payable {
        contador_causas = contador_causas++;
        causas[_nombre] = Causa(contador_causas, _nombre, _precio_objetivo, 0);
    }

    // Verificar si podemos donar a una causa
    function ObjetivoCumplido(string memory _nombre, uint _cantidad) private view returns(bool) {
        bool flag = false;
        Causa causa = causas[_nombre];
        if (causa.precio_objetivo >= causa.cantidad_recaudada + _cantidad) {
            flag = true;
        }

        return flag;

    }

    // Permite donar a una causa
    function Donar(string memory _nombre, uint _cantidad) public returns(bool) {
        bool aceptar_donacion = true;

        if (ObjetivoCumplido(_nombre, _cantidad)){
            causas[_nombre].cantidad_recaudada = causas[_nombre].cantidad_recaudada + _cantidad;
        } else {
            aceptar_donacion = false;
        }
        
        return aceptar_donacion;
    }

    // Esta funcion nos dice si hemos llegado al precio objetivo
    function ComprobarCausa(string memory _nombre) public view returns(bool, uint){
        bool limite_alcanzado = false;
        Causa memory causa = causas[_nombre];

        if (causa.cantidad_recaudada >= causa.precio_objetivo) {
            limite_alcanzado = true;
        }

        return (limite_alcanzado, causas.cantidad_recaudada);
    }

}