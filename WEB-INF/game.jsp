<%@ page import="java.util.*" %>
<%@ page import="model.Question" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Question q = (Question) request.getAttribute("question");
    Boolean result = (Boolean) request.getAttribute("result");
    
    List<Question> list = (List<Question>) session.getAttribute("questions");
    int index = (Integer) session.getAttribute("index");
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
</style>

<script>
document.addEventListener("DOMContentLoaded", function() {

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
<%-- 回答結果がある場合 --%>
<% if (result != null) { %>

    <% if (index >= 7) { %>
    	<h1 id="last">ＳＴＡＧＥ　ＣＬＥＡＲ！！</h1>
        <a id="last" href="${pageContext.request.contextPath}/start">タイトルへ戻る</a>
    <% } else if(result){ %>
        <script>window.location.href = "game";</script>
    <% } else{%>
    	<script>window.location.href = "game";</script>
    <% } %>

<% } else { %>

    <h2> <%= index + 1 %>  / 7</h2>

    <p style="font-size: 40px;"><%= q.getKanji() %></p>

    <form action="game" method="post">
        <input type="text" name="answer"autofocus>
    </form>
</body>
</html>
<% } %>