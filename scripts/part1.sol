// Always require declaration for version. CryptoZombies uses older one for now.
// pragma solidity >=0.5.0 <0.6.0;
pragma solidity >=0.8.10;

// contracts are presumably the equivalent of a script
contract ZombieFactory {
    // I guess it follows C-like syntax
    // uint = UnsignedInteger256 -> non-negative 256-bits
    uint dnaDigits = 16;

    // operators are identical to Python
    // Example: 10^16
    uint dnaModulus = 10 ** dnaDigits;

    // Ahh yep, I guess it is like C. We have structs.
    struct Zombie {
        string name;
        uint dna;
    }

    // With lists, we have fixedArray (tuple equivalent I guess)
    // and dynamicArray (list equivalent). Can also create arrays of structs.
    // If we specify a public dynamicArray, then a `getter` method is auto-created
    Zombie[] public zombies;
    // Syntax: StructName[] public array_name;

    // Events are a way of communicating to the chain that something has happened
    // on the contract. We can use events to trigger other functions.
    event NewZombie(uint zombieId, string name, uint dna);

    // For functions, args should begin with `_` prefix and most cases, we want to
    // grab the argument values from memory.
    // All reference types such as arrays, structs, mappings, and strings require `memory`.
    function createZombie(string memory _name, uint _dna) public {
        // Create new zombie and push to array. `.push()` = `list.append()`
        zombies.push(Zombie(_name, _dna));
    }

    // ... now specifically with public, this is visible and accessible to everyone. Therefore,
    // we want to keep it private sometimes. To do so, we need to add `_` prefix in front
    // of the function and use `private`.
    function _createZombie(string memory _name, uint _dna) private {
        // Create new zombie and push to array. `.push()` = `list.append()`
        zombies.push(Zombie(_name, _dna));

        // alternative to `len(zombies)`
        uint id = zombies.length - 1;

        // add trigger event
        emit NewZombie(id, _name, _dna);
    }

    // Function modifiers and returns:
    // view -> read-only
    // pure -> does not access any data except the input args
    // returns are specified in the def like Python typing
    function _generateRandomDna(string memory _str) private view returns (uint) {
    // Syntax: function _privatefunc(args) private modifier_type returns (dtype)

        // sha256 algo = keccak256 function
        // need to convert between different signed integers
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        // allocate randDna to output of function with arg
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
        // no need to return
    }

}