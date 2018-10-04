url = new URL(window.location);
searchParams = new URLSearchParams(url.search);

//var abi = JSON.parse('./journal_abi.json');
$.ajaxSetup({async: false});
$.getJSON('abi/journal_abi.json', function (data) {
    abi = data;
});

var journal_bin = web3.eth.contract(abi);
console.log(searchParams.get('q'));
var journal_contract = journal_bin.at(searchParams.get('q'));
$('#submitpaper').attr('href','submit.html?q='+searchParams.get('q'));
SetAddr_events = journal_contract.JournalAddress({}, {fromBlock: 0, toBlock: 'latest'});

SetAddr_events.get((error, logs) => {
    console.log(logs);
    var args = logs[0].args;
    var hf = args["multiHashFunction"].c[0];
    var sz = args["multiHashSize"].c[0];
    var data = args["multiHashAddress"];
    ipfsadd = ds_encode(hf,sz,data);
getjournal(ipfsadd);
})
;

PaperSubmitted_events = journal_contract.PaperSubmitted({}, {fromBlock: 0, toBlock: 'latest'});

var ipfsPapersAdresses = [];

PaperSubmitted_events.get((error, logs) => {
    logs.forEach(
        function (element) {
            console.log('recibido ' + element);
        var hf = element.args["multiHashFunction"].c[0];
        var sz = element.args["multiHashSize"].c[0];
            var data = element.args["multiHashAddress"];
        var sender = element.args["sender"];
            var add = element.args["add"];
        console.log({hf,sz,data});
        console.log(ds_encode(hf,sz,data));
        ipfsPapersAdresses.push({data: ds_encode(hf,sz,data), sender: sender, add : add});
    })
    getLastPapers(ipfsPapersAdresses);
});


