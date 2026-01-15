
<%@ page import="java.util.*" %>
<%@ page import="model.Question" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Question q = (Question) request.getAttribute("question");
    Boolean result = (Boolean) request.getAttribute("result");
    
    List<Question> list = (List<Question>) session.getAttribute("questions");
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
<div id="overlay"></div>
<div id="flash"></div>

<div id="pause-menu">
    <h2>PAUSE</h2>
    <form id="form" action="start" method="post">
		<label><input type="radio" name="pause" value="continue" checked>つづける</label><br>
		<label><input type="radio" name="pause" value="<%= level %>">やりなおす</label><br>
		<label><input type="radio" name="pause"value="back">タイトルへ戻る</label><br>
	</form>
</div>
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

	<p> 
		<span id="time1" style="font-size: 100px;"></span>
        <span id="time2" style="font-size: 80px;"></span>
        <span id="time3" style="font-size: 80px;"></span>
	</p>

    <h2> <%= index + 1 %>  / 7</h2>
    
    <p id=""></p>

    <p id="question"><%= q.getKanji() %></p>

 	<form action="game" method="post" id="textp">
    	<div id="input-wrapper">
    	<span id="underline"></span>
    	<input  type="text"  id="txt" name="answer" autocomplete="off" 
    	autocorrect="off" autocapitalize="off" spellcheck="false" inputmode="latin" autofocus>
  		</div>
  		<input type="hidden" name="size" id="size">
    	<input type="hidden" name="time" id="time">
	</form>
    <script>
    
    document.addEventListener("DOMContentLoaded", function() {
    const txt=document.getElementById("txt");
    const overlay = document.getElementById("overlay");
    const menu = document.getElementById("pause-menu");
    const question = document.getElementById("question");
    const textp = document.getElementById("textp");

    let size = <%= size %>; //問題の初期のフォントサイズ

    let fontsize = document.getElementById("size");
    let time = document.getElementById("time");

    let time1 = document.getElementById("time1");
    let time2 = document.getElementById("time2");
    let time3 = document.getElementById("time3");

    let t1 = <%= time0 %>;
    let t2 = 10;
    let t3 = 10;

    let timer1 = null;
    let timer2 = null;
    let timer3 = null;

    let pause = false;
    let isRunning = false;

    function startTimer() {
        if (isRunning) return;

        time1.textContent = t1;
        time2.textContent = "." + t2;
        time3.textContent = t3;

        isRunning = true;

        timer1 = setInterval(function () {
             if (t1 === 1) {
            	clearInterval(timer1);
                timer1 = null;
                new Audio("se/ﾋﾟﾁｭｰﾝ.mp3").play();
                question.style.display = 'none';
                textp.style.display = 'none';
                flash3Times();
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
            }
            t1--;
            time1.textContent = t1;
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
        if (!isRunning) return;
        clearInterval(timer1);
        clearInterval(timer2);
        clearInterval(timer3);
        isRunning = false;
        time.value = t1;
        fontsize.value = size;
    }

	function closePauseMenu() {
	    document.getElementById("overlay").style.display = "none";
	    document.getElementById("pause-menu").style.display = "none";

	    // ゲーム画面の入力欄にフォーカスを戻す
	    if (txt) txt.focus();

	    isPauseOpen = false;
	}

	txt.addEventListener("input", function() {
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
	        pause = true;

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
	    	stopTimer();
	        setTimeout(() => {
	        	textp.submit();
	        }, 200);
    	}else if(e.key === "Backspace"){
    		new Audio("se/戻る.mp3").play();
       	}else{
       		new Audio("se/カーソル移動.mp3").play();
        }
	});
        // ====== JSP変数で result の状態を判定 ======
        const isResult =  (result != null) ? "true" : "false" ;

        // ====== ②結果画面：Enter でリンクを実行 ======
        if (isResult) {
            const nextLink = document.querySelector("a"); // 結果画面のリンクは必ず1つ

        }
    });

    </script>
</body>
</html>
<% } %>
