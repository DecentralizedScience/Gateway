url = new URL(window.location);
searchParams = new URLSearchParams(url.search);

//var abi = JSON.parse('./journal_abi.json');
$.ajaxSetup({async: false});
$.getJSON('./journal_abi.json', function (data) {
    abi = data;
});

var journal_bin = web3.eth.contract(abi);
var journal_contract = journal_bin.at(searchParams.get('q'));
$('#submitpaper').attr('href','submit.html?q='+searchParams.get('q'));
SetAddr_events = journal_contract.SetAddr({}, {fromBlock: 0, toBlock: 'latest'});

SetAddr_events.get((error, logs) => {
    console.log(logs);
    ipfsadd = logs[0].args[""];
getjournal(ipfsadd);
})
;

PaperSubmitted_events = journal_contract.PaperSubmitted({}, {fromBlock: 0, toBlock: 'latest'});

var ipfsPapersAdresses = [];

PaperSubmitted_events.get((error, logs) => {
    logs.forEach(
    function (element) {
        var hf = element.args["hf"].c[0];
        var sz = element.args["sz"].c[0];
        var data = element.args["data"];
        var sender = element.args["sender"];
        var add = element.args["add"];
        console.log({hf,sz,data});
        console.log(ds_encode(hf,sz,data));
        ipfsPapersAdresses.push({data: ds_encode(hf,sz,data), sender: sender, add : add});
    })
    getLastPapers(ipfsPapersAdresses);
});


