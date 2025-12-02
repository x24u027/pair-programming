package servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SampleServlet")
public class SampleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");

		//フォワード先
		String forward = null;

		if (action == null) {
			//ゲーム初起動・ゲームオーバー時
			forward = "Select.jsp";
		} else if (action.equals("EasyMode")) {
			//イージーモード選択時
			forward = "Easy.jsp";
		} else if (action.equals("NormalMode")) {
			//ノーマルモード選択時
			forward = "Normal.jsp";
		} else if (action.equals("HardMode")) {
			//ハードモード選択時
			forward = "Hard.jsp";
		} else if (action.equals("ExtraMode")) {
			//エキストラモード選択時
			forward = "Extra.jsp";
		}

		//フォワード
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/" + forward);
		dispatcher.forward(request, response);
System.out.println();
	}

}
