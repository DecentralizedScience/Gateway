pragma solidity ^0.4.0;

library EIPFS{

    struct Multihash{
        uint8 multiHashFunction;
        uint8 multiHashSize;
        bytes32 multiHashAddress;
    }
}

contract Paper{

    EIPFS.Multihash ipfsAddress;
    address[] authors;
    address journal;

    event PaperCreated(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress,
        address journal
        );

    event NewDraft(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress
        );

    constructor(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress,
        address[] _authors
        )
    public
    {
        ipfsAddress=  EIPFS.Multihash(
            {
                multiHashFunction:multiHashFunction,
                multiHashSize:multiHashSize,
                multiHashAddress:multiHashAddress
            }
            );

        authors = _authors;
        journal = msg.sender;

        emit PaperCreated(
            ipfsAddress.multiHashFunction,
            ipfsAddress.multiHashSize,
            ipfsAddress.multiHashAddress,
            journal
            );
    }

    function submitDraft(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress
        )
    public{

        ipfsAddress =  EIPFS.Multihash(
            {
                multiHashFunction:multiHashFunction,
                multiHashSize:multiHashSize,
                multiHashAddress:multiHashAddress

            }
            );

        emit NewDraft(
            ipfsAddress.multiHashFunction,
            ipfsAddress.multiHashSize,
            ipfsAddress.multiHashAddress
            );
    }
}

contract Journal{

    EIPFS.Multihash public ipfsJournalAddress;
    address owner;
    mapping (address => uint8) public editors;

    event JournalAddress(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress
        );

    event PaperSubmitted(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress,
        address add
        );

    event NewOwner(address journalOwner);

    event PrivilegeChange(address target, uint8 level);

    address[] public papers;

    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }

    modifier onlyEditors {
        require(
            editors[msg.sender] == 3,
            "Only editors can call this function");
        _;
    }

    constructor(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress
        )
        public
    {
        //12,20,"0x8B560E826E70FC0AFE6C2B1688A1E9A6D3ECF19AF5A9DF92B58B96267738D50A"
        ipfsJournalAddress = EIPFS.Multihash(
            {
                multiHashFunction:multiHashFunction,
                multiHashSize:multiHashSize,
                multiHashAddress:multiHashAddress
            }
            );

        owner = msg.sender;

        emit JournalAddress(multiHashFunction, multiHashSize, multiHashAddress);
        emit NewOwner(owner);
    }

    function setNewAddress(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress)
    onlyOwner()
    public
    {

        ipfsJournalAddress = EIPFS.Multihash(
            {
                multiHashFunction:multiHashFunction,
                multiHashSize:multiHashSize,
                multiHashAddress:multiHashAddress
            }
            );

        emit JournalAddress(multiHashFunction, multiHashSize, multiHashAddress);
        emit NewOwner(owner);
    }

    function setEditorPrivileges(address target, uint8 level)
    onlyOwner()
    public
    {
        editors[target] = level;
        emit PrivilegeChange(target,level);
    }

    function setNewOwner(address newOwner)
    onlyOwner()
    public
    {
        owner = newOwner;
    }

    function submitPaper(
        uint8 multiHashFunction,
        uint8 multiHashSize,
        bytes32 multiHashAddress,
        address[] _authors
        )
    public
    {
        Paper p = new Paper(
            multiHashFunction,
            multiHashSize,
            multiHashAddress,
            _authors);

        //12,20,"0x8B560E826E70FC0AFE6C2B1688A1E9A6D3ECF19AF5A9DF92B58B96267738D50A",["0xDcD2743BE29Ba2EB95A35530EA309cbc2677aAd6"]
        papers.push(p);
        emit PaperSubmitted(multiHashFunction, multiHashSize,  multiHashAddress, p);
    }
}
