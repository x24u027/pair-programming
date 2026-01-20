
<%@ page import="java.util.*" %>
<%@ page import="model.Question" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Boolean result = (Boolean) request.getAttribute("result");
    
    ArrayList<Question> list = (ArrayList<Question>) session.getAttribute("questions");
    int index = (Integer) session.getAttribute("index");
    int player = (Integer) session.getAttribute("player");
    int size = (Integer) session.getAttribute("size");
    int time0 = (Integer) session.getAttribute("time");
    String level = (String) session.getAttribute("level");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>レベル選択</title>

<style>
body {
	text-align: center;
}
/* 画面を暗くするオーバーレイ */
#overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.6);
	z-index: 100;
}

/* ポーズメニュー本体 */
#pause-menu {
	display: none;
	position: fixed;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	background: white;
	padding: 30px 40px;
	border-radius: 10px;
	font-size: 20px;
	z-index: 101;
	text-align: center;
	width: 300px;
}

/* ゲームクリアorゲームオーバー画面 */
#game-clear,#game-over {
    display:none;
    text-align:center;
    font-size:40px;
    position:fixed;
    top:50%;
    left:50%;
    transform:translate(-50%,-50%);
}

#question {
	white-space: nowrap;
    position: absolute;
    top: 45%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 140px;
    margin: 0;
    font-weight: bold;
    color: #ffbb00;
  	-webkit-text-stroke-width: 3px;
	-webkit-text-stroke-color: black;
    font-family: "MS PMincho";
}

#time1,#time2,#time3{
	font-weight: bold;
	color: #ffffff;
  	-webkit-text-stroke-width: 2px;
	-webkit-text-stroke-color: black;
	font-family:"ＭＳ 明朝","MS Mincho";
}

/* 入力全体の位置（下部固定） */
#input-wrapper {
	text-align: center;
	position: fixed;
	bottom: 100px;
	left: 50%;
	transform: translateX(-50%);
	font-size: 40px;
	height: 50px;
	line-height: 50px;
}

#underline {
    position: absolute;
    bottom: 0;
    left: 50%;               
    transform: translateX(-50%); 
    height: 2px;
    background: #000;
    width: 0;                
    transition: width 0.05s linear;
}

/* 本物の input は透明にして文字だけ表示 */
#txt {
	text-align: center;
	font-size: 40px;
	border: none;
	outline: none;
	background: transparent;
	position: relative;
	z-index: 2;
}

#flash {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: #ff0000; 
	pointer-events: none;
	opacity: 0;
	z-index: 9999;
	animation: none;
}
        
@keyframes flashAnim {
	0%   { opacity: 0; }
	16%  { opacity: 1; }
	33%  { opacity: 0; }
	50%  { opacity: 1; }
	66%  { opacity: 0; }
	83%  { opacity: 1; }
	100% { opacity: 0; }
}
</style>

</head>
<body>
<!--  ポーズメニュー（Escで表示/非表示）  -->




<%-- 回答結果がある場合 --%>
<% if (result != null) { %>

	<% if (player == 0) { %>
		<h1 id="last">game over...</h1>
		<p>「Enter」キーでタイトルに戻る</p>
        <script>
        document.addEventListener("keydown", function(e){
        	new Audio("se/決定.mp3").play();
    	    if (e.key === "Enter") {
    	    	window.location.href = "start";
    	    }
        });
        </script>
    <% } else if (index + player == 10) { %>
    	<h1 id="last"><%= level %> mode Clear!!</h1>
    	<p>「Enter」キーでタイトルに戻る</p>
        <script>
        document.addEventListener("keydown", function(e){
        	new Audio("se/決定.mp3").play();
    	    if (e.key === "Enter") {
    	    	window.location.href = "start";
    	    }
        });
        </script>
    <% } else { %>
        <script>window.location.href = "game";</script>
    <% } %>

<% } else { %>

<div id="overlay"></div>
<div id="flash"></div>
<!-- ▼ ポーズ画面 -->
<div id="pause-menu">
    <h2>PAUSE</h2>
    <form id="form" action="start" method="post">
		<label><input type="radio" name="pause" value="continue" checked>つづける</label><br>
		<label><input type="radio" name="pause" value="<%= level %>">やりなおす</label><br>
		<label><input type="radio" name="pause"value="back">タイトルへ戻る</label><br>
	</form>
</div>
<!-- ▼ ゲームクリア画面 -->
<div id="game-clear">
    <p>ゲームクリア！</p>
    <a href="start">タイトルへ</a>
</div>

<!-- ▼ ゲームオーバー画面 -->
<div id="game-over">
    <p>ゲームオーバー</p>
    <a href="start">タイトルへ</a>
</div>
<!-- ▼ ゲーム画面 -->
<div id="game-ui">
	<p> 
		<span id="time1" style="font-size: 100px;"></span>
        <span id="time2" style="font-size: 80px;"></span>
        <span id="time3" style="font-size: 80px;"></span>
	</p>

    <p id="countQ"></p>

    <p id="question"></p>
    	<div id="input-wrapper">
    	<span id="underline"></span>
    	<input  type="text"  id="txt" name="answer" autocomplete="off" 
    	autocorrect="off" autocapitalize="off" spellcheck="false" inputmode="latin" autofocus>
  		</div>
</div>


    	
    <script>
    const questions = [];

    <% for (Question q : list) { %>
        questions.push({
            id: <%= q.getId() %>,
            kanji: "<%= q.getKanji() %>",
            yomi: "<%= q.getYomi() %>",
            level: "<%= q.getLevel() %>",
            kai: "<%= q.getKai() %>"
        });
    <% } %>
    
    const txt = document.getElementById("txt");
    const overlay = document.getElementById("overlay");
    const menu = document.getElementById("pause-menu");
    const question = document.getElementById("question");

    let time1 = document.getElementById("time1");
    let time2 = document.getElementById("time2");
    let time3 = document.getElementById("time3");

    let timer1 = null;
    let timer2 = null;
    let timer3 = null;

    let pause = false;
    let isRunning = false;

    let i = 0;

    let player = 3;

    document.addEventListener("DOMContentLoaded", function Question() {


    let size = 140; //問題の初期のフォントサイズ

    let t1 = 17;
    let t2 = 10;
    let t3 = 10;

    question.textContent = questions[i].kanji;
    function startTimer() {
        if (isRunning) return;
        isRunning = true;

        time1.textContent = t1;
        time2.textContent = "." + t2;
        time3.textContent = t3;

        timer1 = setInterval(function () {
             if (t1 <= 0) {
            	clearInterval(timer1);
                timer1 = null;
                new Audio("se/ﾋﾟﾁｭｰﾝ.mp3").play();
                question.style.display = 'none';
                txt.style.display = '';
                flash3Times();
                player--;
            }else if(t1 <= 6){
            	time1.style.color = '#ff0000';
                time2.style.color = '#ff0000';
                time3.style.color = '#ff0000';
                new Audio("se/タイマー音.mp3").play();
                setTimeout(() => {
                	new Audio("se/タイマー音.mp3").play();
                }, 80); 
            }else if(t1 <= 11){
                time1.style.color = '#ff4d00';
                time2.style.color = '#ff4d00';
                time3.style.color = '#ff4d00';
                new Audio("se/タイマー音.mp3").play();
            }else{
            	time1.style.color = '#ffffff';
                time2.style.color = '#ffffff';
                time3.style.color = '#ffffff';
            }
            t1--;
            if(t1 <= 0){
            	time1.textContent = 0;
            }else{
				time1.textContent = t1;
                }
            
        }, 1000);

        timer2 = setInterval(function () {
            if (timer1 === null && t2 === 0) {
                clearInterval(timer2);
                timer2 = null;
                return;
            }
            if (t2 === 0) {
                t2 = 10;
            }
            t2--;
            time2.textContent = "." + t2;
            size++;
            question.style.fontSize = size + "px";
        }, 100);

        timer3 = setInterval(function () {
            if (timer1 === null && t3 === 0) {
                clearInterval(timer3);
                timer3 = null;
                return;
            }
            if (t3 === 0) {
                t3 = 10;
            }
            t3--;
            time3.textContent = t3;
        }, 10);
    }

    function stopTimer() {
    	isRunning = false;
        clearInterval(timer1);
        clearInterval(timer2);
        clearInterval(timer3);
        timer1 = null;
        timer2 = null;
        timer3 = null;
    }

	function closePauseMenu() {
	    document.getElementById("overlay").style.display = "";
	    document.getElementById("pause-menu").style.display = "none";

	    // ゲーム画面の入力欄にフォーカスを戻す
	    if (txt) txt.focus();

	    isPauseOpen = false;
	}

	document.addEventListener("input", function() {
	    const text = this.value;
	    const temp = document.createElement("span");

	    // 幅計測用の文字スタイル
	    temp.style.fontSize = "50px";
	    temp.style.visibility = "hidden";
	    temp.style.position = "absolute";
	    temp.style.whiteSpace = "pre";

	    temp.textContent = text;
	    document.body.appendChild(temp);

	    // 下線を文字の幅に合わせて伸ばす
	    document.getElementById("underline").style.width = temp.offsetWidth * 0.8  + "px";

	    document.body.removeChild(temp);
	});

    function flash3Times() {
        const f = document.getElementById('flash');
        f.style.animation = 'flashAnim 0.3s ease';
    
        setTimeout(() => {
            f.style.animation = 'none';
        }, 300);
    }

    startTimer();

    document.addEventListener("keydown", function(e){
	    if (e.key === "Escape") {
	    	new Audio("se/ポーズ.mp3").play();

	        stopTimer();

	        // 表示
	        overlay.style.display = "block";
	        menu.style.display = "block";
	        txt.blur();
	        document.addEventListener("keydown", function(e){
	            const radios = document.querySelectorAll("input[type=radio]");
	            let index = [...radios].findIndex(r => r.checked);

	    		//↓or→キーで下方向にカーソルを移動
	            if(e.key === "ArrowDown" || e.key === "ArrowRight"){
	                index = (index + 1) % radios.length;
	                radios[index].checked = true;
	                new Audio("se/カーソル移動.mp3").play();
	            }
	            //↑or←キーで上方向にカーソルを移動
	            if(e.key === "ArrowUp" || e.key === "ArrowLeft"){
	                index = (index - 1 + radios.length) % radios.length;
	                radios[index].checked = true;
	                new Audio("se/カーソル移動.mp3").play();
	            }

	            // Enterで送信
	            if(e.key === "Enter"){
	            	new Audio("se/決定.mp3").play();
	            	const selected = document.querySelector("input[name='pause']:checked").value;

	                if (selected === "continue") {
	                	new Audio("se/決定.mp3").play();
	                    // ▼ ポーズ解除
	                    closePauseMenu();
	                    startTimer();
	                    return;

	                }

	                if (selected === "restart") {
	                	new Audio("se/決定.mp3").play();
	                    // ▼ やりなおす（indexを0にして game に戻す）
	                	document.getElementById("form").submit();
	                }

	                if (selected === "back") {
	                	new Audio("se/決定.mp3").play();
	                    // ▼ タイトルに戻る
	                    window.location.href = "start";
	                }
	            }
	        });
	        
	    }else if(e.key === "Enter"){
	    	new Audio("se/決定.mp3").play();
	    	e.preventDefault(); 
	    	
            if (txt.value === questions[i].yomi) {
                if(i >= 6){
                	stopTimer();
                	 document.getElementById("game-ui").style.display = "";
                	 document.getElementById("game-clear").style.display = "block";
                	return;
               }else {
                stopTimer();
                txt.value = "";
                i++;
                Question(); 
               }
                
            }else if(t1 <= 0){
                
                if(player <= 1){
                	stopTimer();
                	
                	    document.getElementById("game-ui").style.display = "";
                	    document.getElementById("game-over").style.display = "block";
                	
                	return;
                }else{
               	 stopTimer();
                 txt.value = "";
                 i++;
                 Question(); 
                }
            }
    	}else if(e.key === "Backspace"){
    		new Audio("se/戻る.mp3").play();
       	}else{
       		new Audio("se/カーソル移動.mp3").play();
        }
	});
    });
    </script>
    <% } %>
</body>
</html>

