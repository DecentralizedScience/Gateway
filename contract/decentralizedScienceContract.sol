pragma solidity ^0.4.21;

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
    mapping (address => uint) public proposedReviewers;
    mapping (address => uint) public confirmedReviewers;
    mapping (address => uint) public allowedRaters;
    address public journal;
    address public rephub;
    uint confirmTime;
    uint reviewTime;
    
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
        
    event ReviewReceived(
        uint8 multiHashFunction, 
        uint8 multiHashSize, 
        bytes32 multiHashAddress, 
        address reviewer
        );
    
    event ReviewerProposed  (address reviewer);
    event ReviewerConfirmed (address reviewer);
    
    modifier onlyJournal {
        require(msg.sender == journal,
        "Only assigned journal can call this function");
        _;
    }
    
    modifier onlyRephub {
        require(msg.sender == rephub,
        "Only assigned journal can call this function");
        _;
    }
    
    modifier onlyProposedReviewers {
        require(proposedReviewers[msg.sender] > 0 && proposedReviewers[msg.sender] >= now,
            "Only assigned reviewers can call this function");
        _;
    }
        
    modifier onlyConfirmedReviewers {
        require(proposedReviewers[msg.sender] > 0 && confirmedReviewers[msg.sender] >= now,
            "Only assigned reviewers can call this function");
        _;
    }
    
    constructor(
        uint8 multiHashFunction,
        uint8 multiHashSize, 
        bytes32 multiHashAddress, 
        address[] _authors,
        uint ct,
        uint rt,
        address _rephub
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
        rephub = _rephub;
        authors = _authors;
        journal = msg.sender;
        confirmTime = ct;
        reviewTime = rt;
        emit PaperCreated( 
            ipfsAddress.multiHashFunction,  
            ipfsAddress.multiHashSize,  
            ipfsAddress.multiHashAddress, 
            journal
            );
    }
    
    function setReviewer(address reviewer) public onlyJournal(){
        proposedReviewers[reviewer]= now + confirmTime;
        emit ReviewerProposed(reviewer);
    }
    
    function () public onlyProposedReviewers(){
        proposedReviewers[msg.sender] = 0;
        confirmedReviewers[msg.sender] = now + reviewTime;
        allowedRaters[msg.sender] = 1;
        emit ReviewerConfirmed(msg.sender);
    }
    
    function sendReview(
        uint8 multiHashFunction,
        uint8 multiHashSize, 
        bytes32 multiHashAddress)
    public
    onlyConfirmedReviewers()
    {
        EIPFS.Multihash memory ipfsReviewAddress =  EIPFS.Multihash(
            {
                multiHashFunction:multiHashFunction, 
                multiHashSize:multiHashSize, 
                multiHashAddress:multiHashAddress
            }
            );
        confirmedReviewers[msg.sender] = 1;
        emit ReviewReceived(
            ipfsReviewAddress.multiHashFunction,  
            ipfsReviewAddress.multiHashSize,  
            ipfsReviewAddress.multiHashAddress,
            msg.sender);
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
    
    function rate(address rater, address reviewer) onlyRephub() public returns (bool){
        if(allowedRaters[rater] == 1 && confirmedReviewers[reviewer] == 1){
            allowedRaters[rater] == 0;
            return true;
        }
        else return false;
    }
}

contract Journal{
    
    EIPFS.Multihash public ipfsJournalAddress;
    address owner;
    mapping (address => uint8) public editors;
    uint confirmTime;
    uint reviewTime;
    RepHub rephub;
    
    event JournalAddress(
        uint8 multiHashFunction,
        uint8 multiHashSize, 
        bytes32 multiHashAddress,
        uint confirmTime,
        uint reviewTime
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
        bytes32 multiHashAddress,
        uint ct,
        uint rt,
        RepHub _rephub
        ) //"0xdd870fa1b7c4700f2bd7f44238821c26f7392148","0xe5240103E1Ff986A2C8aE6B6728FFe0d9a395C59"
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
        editors[owner] = 3;
        confirmTime = ct;
        reviewTime = rt;
        rephub = _rephub;
        emit JournalAddress(multiHashFunction, multiHashSize, multiHashAddress,ct,rt);
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
            
        emit JournalAddress(multiHashFunction, multiHashSize, multiHashAddress, confirmTime, reviewTime);
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
    
    function assignReviewer(address reviewer,Paper paperAddress) 
    public 
    onlyEditors(){
        paperAddress.setReviewer(reviewer);
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
            _authors,
            confirmTime,
            reviewTime,
            rephub);
            
        //12,20,"0x8B560E826E70FC0AFE6C2B1688A1E9A6D3ECF19AF5A9DF92B58B96267738D50A",["0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"]
        //"0xDcD2743BE29Ba2EB95A35530EA309cbc2677aAd6"
        papers.push(p);
        emit PaperSubmitted(multiHashFunction, multiHashSize,  multiHashAddress, p);
    }
}


contract RepHub{
    
    constructor() public{
        
    }
    
    modifier validRating(uint8 rating, address reviewer){
        require (reviewer != msg.sender && rating >= 0 && rating <= 1, "rating must be 1 or 0");
        _;
    }

    event RatingReceived(address rater, address reviewer, Paper paper, uint8 rating, uint256 reputation);
    
    mapping (address => uint256) reputation;
    
    function sendRating(
        address _reviewer,
        Paper _paper,
        uint8 _rating)
        validRating(_rating,_reviewer)
        public{
            if( _paper.rate(msg.sender,_reviewer)){
                uint256 temprep =  _rating*20;
                uint256 currep = reputation[_reviewer]*8/10;
                reputation[_reviewer] = temprep+currep; //Exponential smoothing
                emit RatingReceived(msg.sender,_reviewer,_paper,_rating,reputation[_reviewer]);
            }
        }
}
