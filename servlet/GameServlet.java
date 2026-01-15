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

import model.Question;

/**
 * Servlet implementation class mondai
 */
@WebServlet("/game")
public class GameServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		ArrayList<Question> questions = (ArrayList<Question>) session.getAttribute("questions");
		Integer index = (Integer) session.getAttribute("index");

		// 7問終わったら最初の画面へ
		if (index >= 7) {
			session.removeAttribute("questions");
			session.removeAttribute("index");
			response.sendRedirect("select.jsp");
			return;
		}

		request.setAttribute("question", questions.get(index));

		RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/game.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		ArrayList<Question> questions = (ArrayList<Question>) session.getAttribute("questions");
		Integer index = (Integer) session.getAttribute("index");
		Integer player = (Integer) session.getAttribute("player");

		String correct = questions.get(index).getYomi();

		String answer = request.getParameter("answer");
		String size = request.getParameter("size");
		String timer = request.getParameter("time");

		int size0 = Integer.parseInt(size);
		int time0 = Integer.parseInt(timer);

		boolean result = answer != null && answer.equals(correct);
		request.setAttribute("result", result);

		if (result || time0 == 0) {
			session.setAttribute("index", index + 1);
			session.setAttribute("size", 140);
			session.setAttribute("time", 17);
			if (time0 == 0) {
				session.setAttribute("player", player - 1);
			}
		} else {
			session.setAttribute("size", size0);
			session.setAttribute("time", time0 - 1);
		}

		RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/game.jsp");
		rd.forward(request, response);
	}
}