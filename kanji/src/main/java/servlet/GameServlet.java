package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.Question;
import model.QuestionBO;

/**
 * Servlet implementation class mondai
 */
@WebServlet("/game")
public class GameServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mode = request.getParameter("mode");

        // ①問題を出す場合
        if ("question".equals(mode)) {

            String level = request.getParameter("level");

            QuestionBO bo = new QuestionBO();
            Question q = bo.getQuestionByLevel(level);

            request.setAttribute("question", q);
            request.getRequestDispatcher("/WEB-INF/game.jsp").forward(request, response);
            return;
        }

        // ②回答チェックの場合
        if ("answer".equals(mode)) {

            String input = request.getParameter("answer");
            String correct = request.getParameter("correct");

            boolean result = input.equals(correct);
            request.setAttribute("result", result);

            request.getRequestDispatcher("/WEB-INF/game.jsp").forward(request, response);
        }
    }
}

