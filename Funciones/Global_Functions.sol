// Indicamos la version
pragma solidity >=0.4.4 <0.7.0;

contract funciones_globales{

    //Function msg.sender : Devuelve la direccion del remitente de la llamada actual.
    function MsgSender() public view returns(address){
        return msg.sender;
    }

    // Function Now: Devuelve el tiempo actual.
    function Now() public view returns(uint){
        return now;
    }

    // Function block.coinbase: Nos devuelve la direccion de minero.
    function BlockCoinbase() public view returns(address){
        return block.coinbase;
    }

    // Function block.difficulty: Devuelve el valor del bloque con el numero de ceros.
    function BlockDifficulty() public view returns(uint){
        return block.difficulty;
    }

    // Function block.number: Nos devuelve un entero con el numero de bloque actual.
    function BlockNumber() public view returns(uint){
        return block.number;
    }

    // Function msg.sig: Nos devuelve 4 bytes, que es el identificador de la funcion.


    // Function tx.gasprice: Nos devuelve en un entero el precio del gas de una transacion.
    function txGasPrice() public view returns(uint){
        return tx.gasprice;
    }
    

}