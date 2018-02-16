//
//  画像なぞなぞ問題作成
//
var answers = [];
var password1 = ''; // 登録後計算
var password2 = ''; // チェック時計算
var current_password_digest = '';
var iqauth = null;
var shelfname = '';
var checking = false;
var loginok = true;

function init(shelf,quiz,use_password,password_digest){
    shelfname = shelf;
    iqauth = new IQAuth(quiz);

    if(use_password){
	current_password_digest = password_digest;
	login();
    }
    else {
	display();
    }
}

function display(){
    $('#content').empty();
    $('#content').append($('<h2>問題登録</h2> \
    <ul> \
      <li>画像認証用の画像と問題を登録して下さい \
      <li>編集し終わったら、正答を選択してから<input type="button" onclick="check();" value="確認" style="font-size:20pt;">ボタンを押して下さい \
    </ul> \
    '));
    for(var qno=0;qno<iqauth.data.length;qno++){
	answers[qno] = "0";
	$('#content').append(oneQuestion(qno));
    }
    $('#content').append($('<input>').
			 attr('type','button').
			 attr('value','+').
			 on('mousedown',(event) => {
			     var data = {
				 image: "https://gyazo.com/700c6447ab10cf408146e3740a92feb0.png",
				 answers: ["回答1", "回答2"]
			     };
			     iqauth.data.push(data);
			     display();
			 }));
    $('#content').append($('<input>').
			 attr('type','button').
			 attr('value','-').
			 on('mousedown',(event) => {
			     if(iqauth.data.length > 1){
				 iqauth.data.pop();
			     }
			     display();
			 }));
}

function check(){
    password1= iqauth.calcPassword(answers);
    checking = true;
    $('#content').empty();
    $('#content').append($('<h2>問題確認</h2> \
    <ul> \
      <li>登録画面で選んだ正答を選択して<input type="button" onclick="finalcheck();" value="最終確認" style="font-size:20pt;">ボタンを押して下さい \
    </ul> \
    '));
    for(var qno=0;qno<iqauth.data.length;qno++){
	answers[qno] = "0";
	$('#content').append(oneQuestion(qno));
    }
}

function login(){
    checking = true;
    $('#content').empty();
    $('#content').append($('<h2>認証</h2> \
    <ul> \
      <li>正答を選択して<input type="button" onclick="logincheck();" value="認証" style="font-size:20pt;">ボタンを押して下さい \
    </ul> \
    '));
    for(var qno=0;qno<iqauth.data.length;qno++){
	answers[qno] = "0";
	$('#content').append(oneQuestion(qno));
    }
}

function logincheck(){
    password = iqauth.calcPassword(answers);
    if(MD5_hexhash(password) == current_password_digest){
	checking = false;
	display();
    }
}

function finalcheck(){
    password2 = iqauth.calcPassword(answers);
    if(password1 == password2){
	var result = confirm("登録しますか?");
	if(result){
	    $.ajax({
		url:`/${shelfname}/registerquiz`,
		type:'POST',
		data: {
		    'pass': password1,
		    'quiz': JSON.stringify(iqauth.data)
		}
	    });
	    alert('なぞなぞ問題を登録しました');
	}
    }
    else {
	alert("確認に失敗しました");
    }
}

function oneQuestion(qno){
    var answers = $('<div>').
	    css('float','left').
	    css('width','500px');
    for(var ano=0;ano<iqauth.data[qno].answers.length;ano++){
	answers.append(answerElement(qno,ano));
    }
    if(! checking){
	answers.append($('<input>').
		       attr('type','button').
		       attr('value','+').
		       on('mousedown',(event) => {
			   iqauth.data[qno].answers.push("回答");
			   display();
		       }));
	answers.append($('<input>').
		       attr('type','button').
		       attr('value','-').
		       on('mousedown',(event) => {
			   if(iqauth.data[qno].answers.length > 1){
			       iqauth.data[qno].answers.pop();
			   }
			   display();
		       }));
    }
    return $('<div>').
	append(questionElement(qno)).
        append(answers).
	append($('<br>').attr('clear','all')).
	append($('<p>'));
}

function questionElement(qno){
    var imagetext = $('<input>').
	    css('background-color','#fff').
	    css('font-size','9pt').
	    css('font-family','sans-serif').
	    css('border-width','1px').
	    css('padding','1px').
	    css('margin','2px').
	    css('vertical-align','middle').
	    css('width','90%').
	    css('border','none').
	    attr('value',iqauth.data[qno].image);
    if(checking) imagetext.attr('readonly',true);
    return $('<div>').
	css('background-color','#fff').
	css('font-size','9pt').
	css('font-family','sans-serif').
	css('border','solid').
	css('border-width','1px').
	css('padding','1px').
	css('margin','0 0 2 2').
	css('vertical-align','middle').
	attr('id',`imageurl${qno}`).
	append(imagetext).
	append($('<div>').
	       css('float','left').
	       css('margin','2px 2px 2px 0px').
	       append($('<img>').
		      attr('src',iqauth.data[qno].image).
		      css('height','100px').
		      css('padding','2px').
		      css('margin','2px').
		      attr('id',`image${qno}`)
		     ));
}

function answerElement(qno,ano){
    var bgcolor = (answers[qno] == ano ? '#ffd' : '#fff');
    var input = $('<input>').
	    css('font-size','9pt').
	    css('font-family','sans-serif').
	    css('border','solid').
	    css('border-width','1px').
	    css('padding','1px').
	    css('margin','0 0 2 2').
	    css('vertical-align','middle').
	    css('width','100%').
	    css('background-color',bgcolor).
	    attr('id',`answer${qno}_${ano}`).
	    attr('qno',qno).
	    attr('ano',ano).
	    attr('value',iqauth.data[qno].answers[ano]);
    if(checking) input.attr('readonly','true');
    input.on('mousedown',(event)=> {
	var target = $(event.target);
	var qno = target.attr('qno');
	var ano = target.attr('ano');
	answers[qno] = ano;
	//password = iqauth.calcPassword(answers);
	for(var i=0;i<iqauth.data[qno].answers.length;i++){
	    var bgcolor = (ano == i ? '#ffd' : '#fff');
	    $(`#answer${qno}_${i}`).css('background-color',bgcolor);
	}
    });
    return input;
}
