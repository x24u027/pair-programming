<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>設定</title>

<style>
body {
	background: black;
	color: white;
	text-align: center;
	font-family: sans-serif;
}

h1 {
	font-size: 80px;
}

label {
	display: block;
	font-size: 30px;
	margin: 20px;
}

input {
	font-size: 25px;
	width: 80px;
	text-align: center;
}

button {
	font-size: 30px;
	margin: 20px;
	padding: 10px 30px;
}
</style>

<script>
document.addEventListener("keydown", e => {
	if(e.key === "Escape"){
		location.href = "start";
	}
});
</script>

</head>
<body>

<h1>SETTINGS</h1>

<form action="settings" method="post">

	<label>
		制限時間（秒）
		<input type="number" name="time" value="17">
	</label>

	<label>
		ライフ数
		<input type="number" name="player" value="3">
	</label>

	

	<button type="submit">保存</button>
</form>

<p>Escで戻る</p>

</body>
</html>