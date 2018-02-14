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

// IQAuth.prototype.composeAnswerSpan = function(i,j){
//   var span = document.createElement('div');
//   span.id = String(i) + String(j);
//   span.style.fontSize = '9pt';
//   span.style.fontFamily = 'sans-serif';
//   span.style.border = 'solid';
//   span.style.borderWidth = '1px';
//   span.style.padding = '1';
//   span.style.margin = '0 0 2 2';
//   span.style.verticalAlign = 'middle';
//   span.innerHTML = this.data[i][j+1];
//   span.kind = 'text';
//   span.iqauth = this;
//   span.onmousedown = function(event){
//     var element = event.target || event.srcElement;
//     var iqauth = element.iqauth;
//     var m = iqauth.eventId(event).match(/(.)(.)/);
//     var q = Number(m[1]);
//     var a = Number(m[2]);
//     iqauth.answer[q] = a;
//     iqauth.setEditline(event);
//     iqauth.composeDisplay();
//   };
//   span.iqauth = this;
//   return span;
// }
// 
// IQAuth.prototype.imageSpan = function(i){
//   var span = document.createElement('div');
//   span.id = 'imageurl' + String(i);
//   span.style.backgroundColor = 'white';
//   span.style.fontSize = '9pt';
//   span.style.fontFamily = 'sans-serif';
//   span.style.border = 'solid';
//   span.style.borderWidth = '1px';
//   span.style.padding = 1;
//   span.style.margin = '0 0 2 2';
//   span.style.verticalAlign = 'middle';
//   span.innerHTML = this.data[i][0];
//   span.kind = 'text';
//   span.iqauth = this;
//   span.onmousedown = function(event){
//     var element = event.target || event.srcElement;
//     var iqauth = element.iqauth;
//     iqauth.setEditline(event);
//     iqauth.composeDisplay();
//   };
//   return span;
// }
// 
// IQAuth.prototype.oneQuestion = function(div1,i){
//   div1.appendChild(this.imageSpan(i));
// 
//   var img = document.createElement('img');
//   img.src = this.data[i][0];
//   img.style.height = 100;
//   img.style.cssFloat = 'left';
//   img.style.styleFloat = 'left';
//   img.style.padding = 2;
//   img.id = "image" + i;
// 
//   div1.appendChild(img);
//   var div2 = document.createElement('div');
//   div2.style.cssFloat = 'left';
//   div2.style.styleFloat = 'left';
//   div2.style.padding = 0;
//   div2.id = 'ansdiv' + String(i);
//   for(j=0;j<this.data[i].length-1;j++){
//     div2.appendChild(this.composeAnswerSpan(i,j));
//   }
//   ////
//   var plus = document.createElement('span');
//   plus.innerHTML = '＋';
//   plus.id = 'aplus' + String(i);
//   plus.className = 'floatbutton';
//   plus.iqauth = this;
//   plus.onmousedown = function(event){
//     var element = event.target || event.srcElement;
//     var iqauth = element.iqauth;
//     var m = iqauth.eventId(event).match(/aplus(.*)$/);
//     var n = Number(m[1]);
//     iqauth.data[n].push('新しい回答例');
//     var e = document.getElementById('ansdiv'+n);
//     var minus = e.lastChild;
//     e.removeChild(minus);
//     var plus = e.lastChild;
//     e.removeChild(plus);
//     e.appendChild(iqauth.composeAnswerSpan(n,iqauth.data[n].length-1-1));
//     e.appendChild(plus);
//     e.appendChild(minus);
//     iqauth.composeDisplay();
//   }
//   div2.appendChild(plus);
// 
//   ////
//   var minus = document.createElement('span');
//   minus.innerHTML = '−';
//   minus.id = 'aminus' + String(i);
//   minus.className = 'floatbutton';
//   minus.iqauth = this;
//   minus.onmousedown = function(event){
//     var element = event.target || event.srcElement;
//     var iqauth = element.iqauth;
//     var m = iqauth.eventId(event).match(/aminus(.*)$/);
//     var n = Number(m[1]);
//     if(iqauth.data[n].length > 1){
//       iqauth.data[n].pop();
//       var e = document.getElementById('ansdiv'+n);
//       var minus = e.lastChild;
//       e.removeChild(minus);
//       var plus = e.lastChild;
//       e.removeChild(plus);
//       e.removeChild(e.lastChild);
//       e.appendChild(plus);
//       e.appendChild(minus);
//       iqauth.answer[n] = 0;
//       iqauth.composeDisplay();
//     }
//   }
//   div2.appendChild(minus);
// 
//   div1.appendChild(div2);
//   var br = document.createElement('br');
//   br.clear = 'all';
//   div1.appendChild(br);
//   div1.appendChild(document.createElement('p'));
// }
// 
// IQAuth.prototype.composeDiv = function(){
//   var i;
//   var div1 = document.createElement('div');
//   div1.id = 'whole';
//   div1.style.backgroundColor = '#f0f0ff';
//   for(i=0;i<this.data.length;i++){
//     this.oneQuestion(div1,i);
//   }
//   var plus = document.createElement('span');
//   plus.innerHTML = '＋';
//   plus.id = 'qplus' + String(i);
//   plus.className = 'floatbutton';
//   plus.iqauth = this;
//   plus.onmousedown = function(event){
//     var element = event.target || event.srcElement;
//     var iqauth = element.iqauth;
//     var n = iqauth.data.length;
//     iqauth.data.push(iqauth.sample[n]);
//     var e = document.getElementById('whole');
//     var minus = e.lastChild;
//     e.removeChild(minus);
//     var plus = e.lastChild;
//     e.removeChild(plus);
//     iqauth.oneQuestion(e,iqauth.data.length-1);
//     e.appendChild(plus);
//     e.appendChild(minus);
//     iqauth.composeDisplay();
//     return false;
//   }
//   div1.appendChild(plus);
// 
//   var minus = document.createElement('span');
//   minus.innerHTML = '−';
//   minus.id = 'qminus' + String(i);
//   minus.className = 'floatbutton';
//   minus.iqauth = this;
//   minus.onmousedown = function(event){
//     var element = event.target || event.srcElement;
//     var iqauth = element.iqauth;
//     if(iqauth.data.length > 0){
//       iqauth.data.pop();
//       var e = document.getElementById('whole');
//       var minus = e.lastChild;
//       e.removeChild(minus);
//       var plus = e.lastChild;
//       e.removeChild(plus);
//       e.removeChild(e.lastChild);
//       e.removeChild(e.lastChild);
//       e.removeChild(e.lastChild);
//       e.removeChild(e.lastChild);
//       e.removeChild(e.lastChild);
//       e.appendChild(plus);
//       e.appendChild(minus);
//       iqauth.composeDisplay();
//     }
//     return false;
//   }
//   div1.appendChild(minus);
// 
//   for(i=0;i<this.data.length;i++){
//     this.answer[i] = 0;
//   }
// 
//   return div1;
// }
// 
// IQAuth.prototype.inputArea = function(id,size){
//   var div = document.createElement('div');
//   div.style.border = 'none';
//   div.style.borderWidth = 0;
//   div.style.padding = 0;
//   div.style.margin = 0;
//   
//   var input = document.createElement('input');
//   input.type = 'text';
//   input.iqauth = this;
//   input.onmousedown = function(event){
//     var element = event.target || event.srcElement;
//     element.iqauth.setEditline(event);
//   }
//   input.autocomplete = 'off';
//   input.style.border = 'solid';
//   input.style.borderWidth = '1px';
//   input.style.padding = 1;
//   input.style.margin = '0 0 2 2';
//   input.style.verticalAlign = 'middle';
//   input.style.backgroundColor = '#ffffff';
//   input.style.fontSize = '9pt';
//   input.style.fontFamily = 'sans-serif';
//   input.size = size;
//   input.kind = 'input';
// 
//   div.id = id;
//   div.appendChild(input);
//   div.kind = 'input';
//   return div;
// }
// 
// //
// // mousedown / eid / editidのロジックを書いておくこと
// //
// 
// IQAuth.prototype.setEditline = function(event){
//   this.editid = this.eventId(event);
// }
// 
// IQAuth.prototype.composeDisplay = function(){
//   var i,j;
//   var parent;
//   parent = document.getElementById('whole');
//   for(i=0;i<this.data.length;i++){
//     var id = 'imageurl' + String(i);
//     var e = document.getElementById(id);
//     if(e.kind == 'input'){
//       if(this.editid == id){
//         // do nothing
//       }
//       else {
//         if(this.editid != ''){
//           this.data[i][0] = e.firstChild.value;
//           var span = this.imageSpan(i);
//           parent.replaceChild(span,e);
//           document.getElementById('image'+i).src = e.firstChild.value;
//         }
//       }
//     }
//     else {
//       if(this.editid == id){
//         var input = this.inputArea(id,90);
//         input.firstChild.value = this.data[i][0];
//         parent.replaceChild(input,e);
//       }
//     }
//   }
// 
//   for(i=0;i<this.data.length;i++){
//     parent = document.getElementById('ansdiv' + String(i));
//     for(j=0;j<this.data[i].length-1;j++){
//       var id = String(i) + String(j);
//       var e = document.getElementById(id);
//       if(e.kind == 'input'){
//         if(this.editid == id){
//           // do nothing
//         }
//         else {
//           if(this.editid != ''){
//             this.data[i][j+1] = e.firstChild.value;
//             var span = this.composeAnswerSpan(i,j);
//             parent.replaceChild(span,e);
//           }
//         }
//       }
//       else { // text
//         if(this.editid == id){
//           var input = this.inputArea(id,30);
//           input.firstChild.value = this.data[i][j+1];
//           parent.replaceChild(input,e);
//         }
//       }
//     }
//   }
//   for(i=0;i<this.data.length;i++){
//     var div = document.getElementById(String(i));
//     for(j=0;j<this.data[i].length-1;j++){
//       var id = String(i) + String(j);
//       var e = document.getElementById(id);
//       if(e.kind == 'text'){
//         if(this.answer[i] == j){
//           e.style.backgroundColor = '#ffffff';
//         }
//         else {
//           e.style.backgroundColor = '#e0e0e0';
//         }
//       }
//     }
//   }
// }
// 
// IQAuth.prototype.success = function(){
//   var password = this.calcPassword();
//   var hash = MD5_hexhash(password);
//   return hash == this.passhash
// }
// 
// 
