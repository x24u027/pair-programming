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

/**
 * Servlet implementation class start
 */
@WebServlet("/start")
public class StartServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/select.jsp").forward(request, response);

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String level = request.getParameter("pause");

		QuestionDAO dao = new QuestionDAO();
		ArrayList<Question> questions = dao.findRandomByLevel(level);

		HttpSession session = request.getSession();
		session.setAttribute("questions", questions);
		session.setAttribute("index", 0); // 0番目の問題から開始
		session.setAttribute("level", level); 
		response.sendRedirect("game");
	}
}

