//
//  
//
var queryDiv = function(iqauth){ // 認証画面用のdiv
    var div = $('<div>').attr('id','whole');
    for(var i=0;i<iqauth.data.length;i++){
	var img = $('<img>').
		attr('src',iqauth.data[i].image).
		css('height','100px').
		css('width','120px').
		css('float','left').
		attr('id',`image${i}`).
		appendTo(div);
	var div2 = $('<div>').
		css('float','left').
		css('padding','5px').
		attr('id',`ansdiv${i}`).
		appendTo(div);
	for(var j=0;j<iqauth.data[i].answers.length;j++){
	    div2.append(queryAnswerSpan(iqauth,i,j));
	    div2.append($('<br>'));
	}
	$('<br>').attr('clear','all').appendTo(div);
    }
   return div;
};

queryAnswerSpan = function(iqauth,i,j){
    var span = $('<span>').
	    attr('id',`answer${i}-${j}`).
	    css('font-size','9pt').
	    css('font-family','sans-serif').
	    css('padding','1pt').
	    text(iqauth.data[i].answers[j]);
    span.on('mousedown',(event) => {
	var m = event.target.id.match(/answer(.)\-(.)/);
	var q = Number(m[1]);
	var a = Number(m[2]);
	iqauth.answers[q] = a;
	queryDisplay(iqauth);
    });
    return span;
};

queryDisplay = function(iqauth){ // 認証画面を再表示
    for(var i=0;i<iqauth.data.length;i++){
	for(var j=0;j<iqauth.data[i].answers.length;j++){
	    var e = $(`#answer${i}-${j}`);
	    if(iqauth.answers[i] == j){
		e.css('color','#ffffff').
		    css('background-color','#008800');
	    }
	    else {
		e.css('color','#000000').
		    css('background-color','#ffffff');
	    }
	}
    }
};

