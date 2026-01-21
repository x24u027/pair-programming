package servlet;

import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.QuestionDAO;
import model.Question;

@WebServlet("/start")
public class StartServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.getRequestDispatcher("/WEB-INF/select.jsp")
		       .forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String level = request.getParameter("level");

		HttpSession session = request.getSession();

		/* ===== 設定値（未設定ならデフォルト） ===== */
		int time = session.getAttribute("time") != null
				? (Integer) session.getAttribute("time")
				: 17;

		int player = session.getAttribute("player") != null
				? (Integer) session.getAttribute("player")
				: 3;

		/* ===== 問題取得 ===== */
		QuestionDAO dao = new QuestionDAO();
		ArrayList<Question> questions = dao.findRandomByLevel(level);

		/* ===== セッション保存 ===== */
		session.setAttribute("questions", questions);
		session.setAttribute("level", level);
		session.setAttribute("time", time);
		session.setAttribute("player", player);

		/* ===== ゲーム画面へ ===== */
		RequestDispatcher rd =
				request.getRequestDispatcher("/WEB-INF/game.jsp");
		rd.forward(request, response);
	}
}