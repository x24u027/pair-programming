<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>レベル選択</title>

<style>
/* ---------- 基本 ---------- */
#guide {
	color: rgb(139, 128, 128);
}

body {
	text-align: center;
	background-image: url("images/siro2.png");
	background-size: cover;
	background-repeat: no-repeat;
	background-position: center;
}

input[type="radio"] {
	display: none;
}

/* 未選択は薄く */
label {
	display: block;
	opacity: 0.4;
	transition: opacity 0.2s, transform 0.2s;
}

/* ---------- タイトル ---------- */
h1 {
	font-size: 90px;
	color: yellow;
	-webkit-text-stroke: 3px #ff2b7a;
	text-shadow:
		0 0 5px #ff2b7a,
		0 0 10px #ff2b7a,
		0 0 20px #ff2b7a;
	letter-spacing: 5px;
	transform: skew(-8deg);
}

h3 {
	color: #ec6814;
}

/* ---------- レベル文字 ---------- */
#form {
	font-size: 60px;
	font-family: "Impact", "Arial Black", sans-serif;
	color: #ffffff;
	-webkit-text-stroke: 2px #ff2b7a;
	text-shadow:
		3px 3px 0 #b8004f,
		6px 6px 0 #7a0032,
		0 0 10px #ff2b7a,
		0 0 20px #ff2b7a;
}

/* ---------- 共通アニメ ---------- */
@keyframes poyopoyo {
	0%, 40%, 60%, 80% { transform: scale(1.0); }
	50%, 70% { transform: scale(0.95); }
}

.selected {
	opacity: 1;
	font-weight: bold;
	animation: poyopoyo 2s infinite ease-in-out;
}

/* ---------- Easy（青） ---------- */
.selected.es {
	color: #66ff00;
	text-shadow:
		0 0 10px #66ff00,
		0 0 20px #66ff00,
		3px 3px 0 #336600;
}

/* ---------- Normal（黄緑） ---------- */
.selected.nor {
	color: #0000ff;
	text-shadow:
		0 0 10px #0000ff,
		0 0 20px #0000ff,
		3px 3px 0 #0000ff;
}

/* ---------- Hard（黄色） ---------- */
.selected.har {
	color: #f7ab00;
	text-shadow:
		0 0 10px #ffdd00,
		0 0 20px #ffdd00,
		3px 3px 0 #665500;
}

/* ---------- 🔴 EX（赤点滅） ---------- */
@keyframes exBlink {
	0% {
		color: #ff0000;
		text-shadow:
			0 0 5px #ff0000,
			0 0 15px #ff0000,
			0 0 30px #ff0000;
	}
	50% {
		color: #ffffff;
		text-shadow:
			0 0 5px #ffffff,
			0 0 15px #ff4444;
	}
	100% {
		color: #ff0000;
		text-shadow:
			0 0 5px #ff0000,
			0 0 15px #ff0000,
			0 0 30px #ff0000;
	}
}

.selected.ex {
	animation:
		exBlink 0.8s infinite alternate,
		poyopoyo 2s infinite ease-in-out;
	-webkit-text-stroke: 2px #ff0000;
}

/* マウス対応 */
label:hover {
	opacity: 0.7;
	cursor: pointer;
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function(){

	const radios = document.querySelectorAll("input[type=radio]");
	const guide = document.getElementById("guide");

	function updateSelected() {
		radios.forEach(r => {
			r.parentElement.classList.remove("selected");
			if (r.checked) {
				r.parentElement.classList.add("selected");
			}
		});
	}

	function updateGuide(index){
		if(index === 0){
			guide.textContent = "ゲームを初めてプレイする方向け";
		} else if(index === 1){
			guide.textContent = "検定３級合格を目指している方向け";
		} else if(index === 2){
			guide.textContent = "ちょっとおかしな人向け";
		} else if(index === 3){
			guide.textContent = "そういうのが好きな人向け";
		}
	}

	updateSelected();
	updateGuide(0);

	document.addEventListener("keydown", function(e){
		let index = [...radios].findIndex(r => r.checked);

		if(e.key === "ArrowDown" || e.key === "ArrowRight"){
			index = (index + 1) % radios.length;
			radios[index].checked = true;
		}

		if(e.key === "ArrowUp" || e.key === "ArrowLeft"){
			index = (index - 1 + radios.length) % radios.length;
			radios[index].checked = true;
		}

		updateSelected();
		updateGuide(index);

		if(e.key === "Enter"){
			document.getElementById("form").submit();
		}

		/* Space → 設定画面 */
		if (e.code === "Space") {
			e.preventDefault();
			location.href = "settings";
		}
	});
});
</script>

</head>
<body>

	<h1>Level Select</h1>
	<h3>↑↓ or ←→ で選択 / Enterで決定</h3>

	<h2 id="guide">ゲームを初めてプレイする方向け</h2>

	<form id="form" action="start" method="post">
		<input type="hidden" name="mode" value="question">

		<label class="es">
			<input type="radio" name="pause" value="easy" checked> -Easy-
		</label>

		<label class="nor">
			<input type="radio" name="pause" value="normal"> -Normal-
		</label>

		<label class="har">
			<input type="radio" name="pause" value="hard"> -Hard-
		</label>

		<label class="ex">
			<input type="radio" name="pause" value="extra"> -EX-
		</label>
	</form>

</body>
</html>
