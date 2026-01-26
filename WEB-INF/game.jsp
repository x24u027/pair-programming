<%@ page import="java.util.*" %>
<%@ page import="model.Question" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%  
    ArrayList<Question> list = (ArrayList<Question>) session.getAttribute("questions");
    int player = (Integer) session.getAttribute("player");
    int time0 = (Integer) session.getAttribute("time");
    int cntQ = (Integer) session.getAttribute("cntQ");
    String level = (String) session.getAttribute("level");
%>
 
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>ゲーム画面</title>

    <style>
        /* ===== 背景動画 ===== */
        #bg-video {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            object-fit: cover;
            z-index: -1;
        }

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

        /* ゲームクリアorゲームオーバー画面 */
        #game-clear {
            display: none;
            text-align: center;
            font-size: 40px;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            line-height: 1.1;

        }

        #game-over {
            display: none;
            text-align: center;
            font-size: 40px;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        #Explanation {
            color: #ffffff;
            display: none;
            position: fixed;
            top: 70%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: black;
            padding: 30px 40px;
            border-radius: 10px;
            font-size: 40px;
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

        #time1,
        #time2,
        #time3 {
            font-weight: bold;
            color: #ffffff;
            -webkit-text-stroke-width: 2px;
            -webkit-text-stroke-color: black;
            font-family: "ＭＳ 明朝", "MS Mincho";
        }

        #countQ {
            font-size: 40px;
            margin: 0px;
            font-family: "ＭＳ 明朝", "MS Mincho";
        }

        #zanki {
            position: fixed;
            right: 20px;
            bottom: 20px;
            display: flex;
            align-items: center;
            gap: 5px;

            padding: 8px 12px;
            /* 余白 */
            background: #75d400c6;
            border: 4px solid #DAA520;
            border-radius: 8px;
            /* 角を丸く */
            z-index: 9999;
        }

        #kake {
            font-size: 50px;
            font-weight: bold;
            color: #ffffff;
        }

        #zan {
            font-size: 60px;
            font-weight: bold;
            color: #c40000;
            -webkit-text-stroke-width: 1px;
            -webkit-text-stroke-color: white;
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
            0% {
                opacity: 0;
            }

            16% {
                opacity: 1;
            }

            33% {
                opacity: 0;
            }

            50% {
                opacity: 1;
            }

            66% {
                opacity: 0;
            }

            83% {
                opacity: 1;
            }

            100% {
                opacity: 0;
            }
        }

        #clear {
            color: yellow;
            /* ← これを有効にする */
            font-size: 150px;
            font-weight: 900;
            letter-spacing: 6px;
            font-family: 'Arial Black', Impact, sans-serif;


            /* 縁取りは残してOK */
            -webkit-text-stroke: 6px red;

            text-shadow:
                2px 2px 0 #ffffff,
                -2px -2px 0 #ffffff,
                4px 4px 6px rgba(0, 0, 0, 0.6);

            transform: skewX(-12deg) rotate(-2deg);
            display: inline-block;
        }

        .clear-shift {
            margin-left: 50px;
            /* ← ここで右にずらす量を調整 */
            display: inline-block;
        }

        #game-clear a {
            margin-top: -20px;
        }


        #over {
            color: red;
            font-size: 150px;
            font-weight: 500;
            letter-spacing: 6px;
            font-family: 'Arial Black', Impact, sans-serif;

            /* 外枠を赤 */
            -webkit-text-stroke: 6px red;

            /* ★ 横一列固定 */
            white-space: nowrap;

            text-shadow:
                2px 2px 0 #ffffff,
                -2px -2px 0 #ffffff,
                4px 4px 6px rgba(0, 0, 0, 0.6);


            display: inline-block;
        }
    </style>

</head>

<body>
    <!-- ===== 背景動画 ===== -->
    <video id="bg-video" autoplay muted loop playsinline>
        <source src="images/run.mp4" type="video/mp4">
    </video>
    <div id="overlay"></div>
    <div id="flash"></div>
    <!-- ▼ ポーズ画面 -->
    <div id="pause-menu">
        <h2>PAUSE</h2>
        <form id="form" action="restart" method="post">
            <label>
                <input type="radio" name="pause" value="continue" checked>
                つづける
            </label><br>

            <label>
                <input type="radio" name="pause" value="restart">
                やりなおす
            </label><br>

            <label>
                <input type="radio" name="pause" value="back">
                タイトルへ戻る
            </label>
        </form>
    </div>
    <!-- ▼ ゲームクリア画面 -->
    <div id="game-clear">
        <p id="clear">GAME <span class="clear-shift">CLEAR</span></p>

        <p>「Enter」でタイトルに戻る</p>
    </div>

    <!-- ▼ ゲームオーバー画面 -->
    <div id="game-over">
        <p id="over">GAME OVER</p>
        <p>「Enter」でタイトルに戻る</p>
    </div>
    <!-- ▼ 解説画面 -->
    <div id="Explanation">
        <ruby>
            <p id="kan"></p>
            <rt id="yomi"></rt>
        </ruby>
    </div>
    <!-- ▼ ゲーム画面 -->
    <div id="game-ui">
        <p id="time">
            <span id="time1" style="font-size: 100px;"></span>
            <span id="time2" style="font-size: 80px;"></span>
            <span id="time3" style="font-size: 80px;"></span>
        </p>

        <p id="countQ"></p>

        <p id="question"></p>

        <div id="zanki">
            <img src="images/残機.png">
            <span id="kake">×</span>
            <span id="zan"></span>
        </div>
        <div id="input-wrapper">
            <input type="text" id="txt" name="answer" autocomplete="off" autocorrect="off" autocapitalize="off"
                spellcheck="false" inputmode="latin" autofocus>
            <span id="underline"></span>
        </div>
    </div>



    <script>
        const questions = [];

    <% for (Question q : list) { %>
            questions.push({
                id: <%= q.getId() %>,
                kanji: "<%= q.getKanji() %>",
                yomi: "<%= q.getYomi() %>",
                level: "<%= q.getLevel() %>",
                kai: "<%= q.getKai() %>"
            });
    <% } %>
    
    	const txt = document.getElementById("txt");
        const underline = document.getElementById("underline");
        const kan = document.getElementById("kan");
        const yomi = document.getElementById("yomi");
        const overlay = document.getElementById("overlay");
        const menu = document.getElementById("pause-menu");
        const question = document.getElementById("question");
        const zan = document.getElementById("zan");
        const time = document.getElementById("time");
        const video = document.getElementById("bg-video");
        const Clear = document.getElementById("game-clear");
        const Over = document.getElementById("game-over");

        let time1 = document.getElementById("time1");
        let time2 = document.getElementById("time2");
        let time3 = document.getElementById("time3");

        let timer1 = null;
        let timer2 = null;
        let timer3 = null;

        let pause = false;
        let isRunning = false;
        let goal = false;

        let maxQ = <%= cntQ %>;
        let i = 0;
        let c = 1;

        let player = <%= player %>;

        let size = 140;

        let t1 = <%= time0 %>;
        let t2 = 10;
        let t3 = 10;

        let isPauseOpen = false;

        question.textContent = questions[i].kanji;

        zan.textContent = player;

        document.getElementById("countQ").textContent = c + " / " + maxQ;

        document.addEventListener("DOMContentLoaded", function Question() {

            function startTimer() {
                if (isRunning) return;
                isRunning = true;


                time1.textContent = t1;
                time2.textContent = "." + t2;
                time3.textContent = t3;

                timer1 = setInterval(function () {
                    if (t1 <= 0) {
                        clearInterval(timer1);
                        timer1 = null;
                        new Audio("se/ﾋﾟﾁｭｰﾝ.mp3").play();
                        question.style.display = 'none';
                        txt.blur();
                        flash3Times();
                        video.pause();
                        player--;
                        zan.textContent = player;
                        setTimeout(() => {
                            Explanation.style.display = 'block';
                            kan.textContent = questions[i].kanji;
                            yomi.textContent = questions[i].yomi;
                        }, 2000);
                    } else if (t1 <= 6) {
                        time1.style.color = '#ff0000';
                        time2.style.color = '#ff0000';
                        time3.style.color = '#ff0000';
                        new Audio("se/タイマー音.mp3").play();
                        setTimeout(() => {
                            new Audio("se/タイマー音.mp3").play();
                        }, 80);
                    } else if (t1 <= 11) {
                        time1.style.color = '#ff4d00';
                        time2.style.color = '#ff4d00';
                        time3.style.color = '#ff4d00';
                        new Audio("se/タイマー音.mp3").play();
                    } else {
                        time1.style.color = '#ffffff';
                        time2.style.color = '#ffffff';
                        time3.style.color = '#ffffff';
                    }
                    t1--;
                    if (t1 <= 0) {
                        time1.textContent = 0;
                    } else {
                        time1.textContent = t1;
                    }

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
                isRunning = false;
                clearInterval(timer1);
                clearInterval(timer2);
                clearInterval(timer3);
                timer1 = null;
                timer2 = null;
                timer3 = null;
            }

            function closePauseMenu() {
                document.getElementById("overlay").style.display = "none";
                document.getElementById("pause-menu").style.display = "none";

                // ゲーム画面の入力欄にフォーカスを戻す
                if (txt) txt.focus();

                isPauseOpen = false;
            }

            txt.addEventListener("input", function () {
                const text = this.value;
                const temp = document.createElement("span");

                temp.style.fontSize = "50px";
                temp.style.visibility = "hidden";
                temp.style.position = "absolute";
                temp.style.whiteSpace = "pre";

                temp.textContent = text;
                document.body.appendChild(temp);

                underline.style.width = temp.offsetWidth * 0.8 + "px";

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
            document.addEventListener("keydown", function (e) {
                if (e.key === "Enter" && isPauseOpen === false) {
                    new Audio("se/決定.mp3").play();
                    e.preventDefault();

                    if (goal) {
                        window.location.href = "start";
                    } else if (txt.value === questions[i].yomi) {
                        if (c >= maxQ) {
                            clearInterval(timer1);
                            clearInterval(timer2);
                            clearInterval(timer3);
                            new Audio("se/正解音.mp3").play();
                            time.style.display = 'none';
                            question.style.display = 'none';
                            txt.style.display = 'none';
                            underline.style.width = 0 + "px";
                            setTimeout(() => {
                                video.pause();
                                Clear.style.display = "block";
                                goal = true;
                                return;
                            }, 1000);

                        } else {
                            stopTimer();
                            txt.value = "";
                            underline.style.width = 0 + "px";
                            question.style.display = 'none';
                            new Audio("se/正解音.mp3").play();
                            c++;
                            setTimeout(() => {
                                i++;

                                size = 140;
                                t1 = <%= time0 %>;
                                t2 = 10;
                                t3 = 10;
                                document.getElementById("countQ").textContent = c + " / " + maxQ;
                                Explanation.style.display = 'none';
                                time.style.display = 'block';
                                question.style.display = 'block';
                                question.textContent = questions[i].kanji;
                                startTimer();
                            }, 1000);
                        }

                    } else if (t1 <= 0) {

                        if (player <= 0) {
                            clearInterval(timer1);
                            clearInterval(timer2);
                            clearInterval(timer3);
                            time.style.display = 'none';
                            question.style.display = 'none';
                            txt.style.display = 'none';
                            underline.style.width = 0 + "px";
                            Explanation.style.display = 'none';
                            Over.style.display = "block";
                            goal = true;
                            return;
                        } else {

                            Explanation.style.display = 'none';
                            question.style.display = 'block';
                            txt.focus();
                            stopTimer();
                            video.play();
                            txt.value = "";
                            underline.style.width = 0 + "px";
                            i++;
                            size = 140;

                            t1 = <%= time0 %>;
                            t2 = 10;
                            t3 = 10;

                            question.textContent = questions[i].kanji;
                            startTimer();
                        }
                    } else {
                        setTimeout(() => {
                            new Audio("se/誤.wav").play();
                        }, 300);
                    }
                } else if (e.key === "Backspace" && isPauseOpen === false) {
                    new Audio("se/戻る.mp3").play();
                }
                else if (e.key === "Escape") {
                    new Audio("se/ポーズ.mp3").play();

                    stopTimer();
                    isPauseOpen = true;

                    Explanation.style.display = 'none';

                    // 表示
                    overlay.style.display = "block";
                    menu.style.display = "block";
                    txt.blur();

                } else {
                    new Audio("se/カーソル移動.mp3").play();
                }
            });
            document.addEventListener("keydown", function (e) {
                const radios = document.querySelectorAll("input[type=radio]");
                let index = [...radios].findIndex(r => r.checked);

                //↓or→キーで下方向にカーソルを移動
                if (e.key === "ArrowDown" || e.key === "ArrowRight") {
                    index = (index + 1) % radios.length;
                    radios[index].checked = true;
                    new Audio("se/カーソル移動.mp3").play();
                }
                //↑or←キーで上方向にカーソルを移動
                if (e.key === "ArrowUp" || e.key === "ArrowLeft") {
                    index = (index - 1 + radios.length) % radios.length;
                    radios[index].checked = true;
                    new Audio("se/カーソル移動.mp3").play();
                }

                // Enterで送信
                if (e.key === "Enter") {
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
        });

    </script>
</body>

</html>
