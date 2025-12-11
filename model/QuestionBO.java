package model;

import java.util.ArrayList;

import dao.QuestionDAO;

public class QuestionBO {
	public ArrayList<Question> getQuestionByLevel(String level) {
		QuestionDAO dao = new QuestionDAO();
		return dao.findRandomByLevel(level);
	}
}