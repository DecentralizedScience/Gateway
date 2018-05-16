function getjournal(ipfsAddress) {

    ipfs.cat(ipfsAddress).then(
        function (file) {
            var raw = file.read();
            var json = decoder.decode(raw);
            var info = JSON.parse(json);
            $('#journal-title').html(info.title);
            $('#journal-desc').html(info.description);
            getimage(info.image)
        }
    );
}
var ttem;

function Uint8ToString(u8a){
    var CHUNK_SZ = 0x8000;
    var c = [];
    for (var i=0; i < u8a.length; i+=CHUNK_SZ) {
        c.push(String.fromCharCode.apply(null, u8a.subarray(i, i+CHUNK_SZ)));
    }
    return c.join("");
}

function getimage(ipfsImageAddress){
    $("#journal-img").attr("src","http://127.0.0.1:5001/api/v0/cat?arg="+ipfsImageAddress);
    /*ipfs.cat(ipfsImageAddress).then(
        function (file) {
            ttem = file;
            var raw = file.read();
            var blob = new Blob([raw], {'type': 'image/png'});
            var url = URL.createObjectURL(blob);
            //$("#journal-img").attr("src",url);

        }
    );*/
}

function getLastPapers(ipfsAddresses) {
    ipfsAddresses.forEach(
        function (element) {
            ipfs.cat(element.data).then(
                function (file) {
                    var raw = file.read();

                    var json = decoder.decode(raw);
                    var info = JSON.parse(json);

                    var title= info.title;
                    var topics_arr = info.topics;
                    var topics = "";
                    topics_arr.forEach(
                        function (topic) {
                            topics+='<a href="topic.html?q='+topic.id+'">'+topic.name+'</a>, ';
                        }
                    );

                    topics = topics.substr(0,topics.length-2);

                    var authors_arr = info.authors;
                    var authors = "";

                    authors_arr.forEach(
                        function (author) {
                            authors+='<a href="author.html?q='+author.address+'">'+author.author+'</a>, ';
                        }
                    );
                    authors = authors.substr(0,authors.length-2);

                    var html =  '<div class="list-group-item">'+
                        '<h4 class="list-group-item-heading"><a href="paper.html?q='+element.add+'">'+title+'</a></h4>'+
                        '<p class="list-group-item-text">'+
                        '<small>Sender address:'+element.sender+ '</small><br/>'+
                        '  <span class="paper-author"><b>Authors: </b>'+authors+'</span><br/>'+
                        '  <span class="paper-topics"><b>Topics: </b>'+topics+'</span>' +
                        '</p>' +
                        '<p>' +
                        '  <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#abs'+info.document+'" aria-expanded="false" aria-controls="collapseExample">' +
                        '    View Abstract' +
                        '  </button>' +
                        '  <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#raw'+info.document+'" aria-expanded="false" aria-controls="collapseExample">' +
                        '    View Raw Info' +
                        '  </button>' +
                        '</p>' +
                        '<div class="collapse" id="abs'+info.document+'">' +
                        '  <div class="card card-body">' +
                        info.abstract +
                        '  </div>' +
                        '</div>'+
                        '<div class="collapse" id="raw'+info.document+'">' +
                        '  <div class="card card-body"><pre>' +
                        JSON.stringify(info,null,2) +
                        '</pre>  </div>' +
                        '</div>'+
                        '</div>';
                    $('#latest-papers').append(html);
                }
            );
        }
    )

}