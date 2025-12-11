package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Question;

public class QuestionDAO {

	private static final String URL = "jdbc:mysql://localhost:3306/pairprogramming";
	private static final String USER = "root";
	private static final String PASS = "";

	public ArrayList<Question> findRandomByLevel(String level) {
		String sql = "SELECT * FROM kanjigo WHERE level=? ORDER BY RAND() LIMIT 10";
		ArrayList<Question> list = new ArrayList<>();

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection(URL, USER, PASS);
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, level);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				list.add(new Question(
						rs.getInt("id"),
						rs.getString("kanji"),
						rs.getString("yomi"),
						rs.getString("level")));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
}