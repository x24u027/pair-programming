<%@ page import="java.util.*" %>
<%@ page import="model.Question" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Question q = (Question) request.getAttribute("question");
    Boolean result = (Boolean) request.getAttribute("result");
    
    List<Question> list = (List<Question>) session.getAttribute("questions");
    int index = (Integer) session.getAttribute("index");
    String level = (String) session.getAttribute("level");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>レベル選択</title>

<style>
body{
text-align: center;
}
/* 画面を暗くするオーバーレイ */
#overlay {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.6);
    z-index: 100;
}

/* ポーズメニュー本体 */
#pause-menu {
    display: none;
    position: fixed;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    padding: 30px 40px;
    border-radius: 10px;
    font-size: 20px;
    z-index: 101;
    text-align: center;
    width: 300px;
}
</style>

<script>
//===== Escキーでポーズメニュー表示 =====
document.addEventListener("DOMContentLoaded", function() {

	document.addEventListener("keydown", function(e){
	    if (e.key === "Escape") {
	        const overlay = document.getElementById("overlay");
	        const menu = document.getElementById("pause-menu");
	        const txt=document.getElementById("txt");

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
	            }
	            //↑or←キーで上方向にカーソルを移動
	            if(e.key === "ArrowUp" || e.key === "ArrowLeft"){
	                index = (index - 1 + radios.length) % radios.length;
	                radios[index].checked = true;
	            }

	            // Enterで送信
	            if(e.key === "Enter"){
	            	const selected = document.querySelector("input[name='pause']:checked").value;

	                if (selected === "continue") {
	                    // ▼ ポーズ解除
	                    overlay.style.display = "none";
	                    menu.style.display = "none";

	                    // ▼ テキスト入力欄へフォーカス復帰
	                    if (txt) txt.focus();
	                }

	                if (selected === "restart") {
	                    // ▼ やりなおす（indexを0にして game に戻す）
	                	document.getElementById("form").submit();
	                }

	                if (selected === "back") {
	                    // ▼ タイトルに戻る
	                    window.location.href = "start";
	                }
	            }
	        });
	        
	    }
	});

    // ====== JSP変数で result の状態を判定 ======
    const isResult = <%= (result != null) ? "true" : "false" %>;

    // ====== ②結果画面：Enter でリンクを実行 ======
    if (isResult) {
        const nextLink = document.querySelector("a"); // 結果画面のリンクは必ず1つ

        if (nextLink) {
            document.addEventListener("keydown", function(e) {
                if (e.key === "Enter") {
                    nextLink.click();
                }
            });
        }
    }
});
</script>

</head>
<body>
<!--  ポーズメニュー（Escで表示/非表示）  -->
<div id="overlay"></div>

<div id="pause-menu">
    <h2>PAUSE</h2>
    <form id="form" action="start" method="post">
		<input type="hidden" name="mode" value="question"> 
		<label><input type="radio" name="pause" value="continue" checked>つづける</label><br>
		<label><input type="radio" name="pause" value="<%= level %>">やりなおす</label><br>
		<label><input type="radio" name="pause"value="back">タイトルへ戻る</label><br>
	</form>
</div>
<%-- 回答結果がある場合 --%>
<% if (result != null) { %>

    <% if (index >= 7) { %>
    	<h1 id="last"><%= level %> mode Clear!!</h1>
        <a id="last" href="${pageContext.request.contextPath}/start">タイトルへ戻る</a>
    <% } else { %>
        <script>window.location.href = "game";</script>
    <% } %>

<% } else { %>

    <h2> <%= index + 1 %>  / 7</h2>

    <p style="font-size: 40px;"><%= q.getKanji() %></p>

    <form action="game" method="post">
        <input type="text" name="answer" id="txt" autofocus>
    </form>
</body>
</html>
<% } %>