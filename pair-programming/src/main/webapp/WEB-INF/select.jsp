<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>レベル選択</title>

<script>
    document.addEventListener("keydown", function(e){
        //radiosに配列に似たリストを作成して代入する
        const radios = document.querySelectorAll("input[type=radio]");
        //[...radios]で本物の配列に変換
        //配列の中を 前から順番にチェックして、「checked が選択中のラジオボタンが何番目か」を探す。
		//r => r.checked の意味
		//r = ラジオボタン1つ（input要素）
		//r.checked = そのラジオボタンが選択されているかどうか
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
            //スタートボタンをクリックしなくてもEnterキー押下でformの要素を送信する
            document.getElementById("form").submit();
        }
    });
</script>

</head>
<body>
	<h2>Level Select（↑↓ or ←→ で選択 / Enterで決定）</h2>

	<form id="form" action="game" method="post">
		<input type="hidden" name="mode" value="question"> 
		<label><input type="radio" name="level" value="easy" checked>Easy</label><br>
		<label><input type="radio" name="level" value="normal">Normal</label><br>
		<label><input type="radio" name="level"value="hard">Hard</label><br>

		<button>スタート</button>
	</form>

</body>
</html>
