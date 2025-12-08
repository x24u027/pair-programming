<%@ page import="model.Question" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Question q = (Question) request.getAttribute("question");
    Boolean result = (Boolean) request.getAttribute("result");
%>

<%-- 回答結果がある場合 --%>
<% if (result != null) { %>
    <h1><%= result ? "正解！" : "不正解..." %></h1>
    <a href="start">もう一度</a>
<% } else { %>

    <h2>この漢字の読みを入力してください</h2>

    <p style="font-size: 40px;"><%= q.getKanji() %></p>

    <form action="game" method="post">
        <input type="hidden" name="mode" value="answer">
        <input type="hidden" name="correct" value="<%= q.getYomi() %>">

        <input type="text" name="answer">
        <button>回答する</button>
    </form>

<% } %>