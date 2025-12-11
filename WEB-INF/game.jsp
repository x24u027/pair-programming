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

    <h1><%= result ? "正解！" : "不正解..." %></h1>

    <% if (index >= list.size()) { %>
        <a href="${pageContext.request.contextPath}/start">10問終了！トップへ戻る</a>
    <% } else if(result){ %>
        <a href="game">次の問題へ</a>
    <% } else{%>
    <a href="game">戻る</a>
    <% } %>

<% } else { %>

    <h2> <%= index + 1 %>  / 10</h2>

    <p style="font-size: 40px;"><%= q.getKanji() %></p>

    <form action="game" method="post">
        <input type="text" name="answer"autofocus>
        <button>回答する</button>
    </form>
</body>
</html>
<% } %>