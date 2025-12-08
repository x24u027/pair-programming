package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.Question;

public class QuestionDAO {

	private static final String URL = "jdbc:mysql://localhost:3306/pairprogramming";
	private static final String USER = "root";
	private static final String PASS = "";

	public Question findRandomByLevel(String level) {
		String sql = "SELECT * FROM kanjigo WHERE level = ? ORDER BY RAND() LIMIT 1";
		Question q = new Question();

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection(URL, USER, PASS);
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, level);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				q = new Question(
						rs.getInt("id"),
						rs.getString("kanji"),
						rs.getString("yomi"),
						rs.getString("level"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return q;
	}
}
