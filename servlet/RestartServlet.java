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

		QuestionDAO dao = new QuestionDAO();
		ArrayList<Question> questions = dao.findRandomByLevel(level);

		// 初期化
		session.setAttribute("questions", questions);
		session.setAttribute("index", 0);
		//session.setAttribute("player", 3);
		//session.setAttribute("time", 17);
		//session.setAttribute("size", 140);

		request.getRequestDispatcher("/WEB-INF/game.jsp")
		       .forward(request, response);
	}
}
