package servlet;

import java.io.IOException;
import java.util.ArrayList;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.QuestionDAO;
import model.Question;

@WebServlet("/restart")
public class RestartServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		// レベルはセッションから取得
		String level = (String) session.getAttribute("level");
	    int player = (Integer) session.getAttribute("player");
	    int time = (Integer) session.getAttribute("time");

		QuestionDAO dao = new QuestionDAO();
		ArrayList<Question> questions = dao.findRandomByLevel(level);

		// 初期化
		session.setAttribute("questions", questions);
		session.setAttribute("player", player);
		session.setAttribute("time", time);

		request.getRequestDispatcher("/WEB-INF/game.jsp")
		       .forward(request, response);
	}
}
