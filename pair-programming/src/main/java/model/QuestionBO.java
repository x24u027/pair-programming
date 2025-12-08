package model;

import dao.QuestionDAO;

public class QuestionBO {
    public Question getQuestionByLevel(String level) {
        QuestionDAO dao = new QuestionDAO();
        return dao.findRandomByLevel(level);
    }
}
