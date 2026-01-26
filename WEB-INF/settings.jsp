<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>設定画面</title>

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

        input,
        select {
            font-size: 25px;
            width: 120px;
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
            if (e.key === "Escape") {
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
            <input type="number" name="time" value="17" min="5" max="20">
        </label>

        <label>
            ライフ数
            <input type="number" name="player" value="3" min="1" max="3">
        </label>

        <label>
            問題数
            <select name="cntQ">
                <option value="3">3問</option>
                <option value="5" selected>5問</option>
                <option value="7">7問</option>
            </select>
        </label>

        <button type="submit">保存</button>
    </form>

    <p>Escで戻る</p>

</body>

</html>