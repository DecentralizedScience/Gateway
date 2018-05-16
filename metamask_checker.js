
window.addEventListener('load', function () {

    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        // Use Mist/MetaMask's provider
        web3js = new Web3(web3.currentProvider);
        if (web3js.eth.accounts.length <= 0) {
            console.log("Unlock Metamask");
        }
        else {
            isMetamaskUnlocked = true;
        }
    } else {
        console.log('No web3? You should consider trying MetaMask!')
    }
});