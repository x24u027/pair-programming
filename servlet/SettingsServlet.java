package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.getRequestDispatcher("/WEB-INF/settings.jsp")
				.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();

		int time = Integer.parseInt(request.getParameter("time"));
		int player = Integer.parseInt(request.getParameter("player"));
		int cntQ = Integer.parseInt(request.getParameter("cntQ"));

		// ===== 上限・下限チェック =====
		if (time < 5)
			time = 5;
		if (time > 20)
			time = 20;

		if (player < 1)
			player = 1;
		if (player > 3)
			player = 3;

		if (cntQ != 3 && cntQ != 5 && cntQ != 7) {
			cntQ = 5;
		}

		session.setAttribute("time", time);
		session.setAttribute("player", player);
		session.setAttribute("cntQ", cntQ);

		response.sendRedirect("start");
	}
}