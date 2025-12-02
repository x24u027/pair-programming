<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>レベル選択</title>

<script>
    document.addEventListener("keydown", function(e){
        const radios = document.querySelectorAll("input[type=radio]");
        let index = [...radios].findIndex(r => r.checked);

        if(e.key === "ArrowDown" || e.key === "ArrowRight"){
            index = (index + 1) % radios.length;
            radios[index].checked = true;
        }
        if(e.key === "ArrowUp" || e.key === "ArrowLeft"){
            index = (index - 1 + radios.length) % radios.length;
            radios[index].checked = true;
        }

        // Enterで送信
        if(e.key === "Enter"){
            document.getElementById("form").submit();
        }
    });
</script>

</head>
<body>
<h2>Level Select（↑↓ or ←→ で選択 / Enterで決定）</h2>

<form id="form" action="game" method="post">
    <input type="hidden" name="mode" value="question">

    <label><input type="radio" name="level" value="easy" checked> イージー</label><br>
    <label><input type="radio" name="level" value="normal"> ノーマル</label><br>
    <label><input type="radio" name="level" value="hard"> ハード</label><br>

    <button>スタート</button>
</form>

</body>
</html>
    