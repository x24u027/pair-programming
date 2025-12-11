package model;

public class Question {
	private int id;
	private String kanji;
	private String yomi;
	private String level;

	public Question() {
	}

	public Question(int id, String kanji, String yomi, String level) {
		this.id = id;
		this.kanji = kanji;
		this.yomi = yomi;
		this.level = level;
	}

	public int getId() {
		return id;
	}

	public String getKanji() {
		return kanji;
	}

	public String getYomi() {
		return yomi;
	}

	public String getLevel() {
		return level;
	}

	public void setId(int id) {
		this.id = id;
	}

	public void setKanji(String kanji) {
		this.kanji = kanji;
	}

	public void setYomi(String yomi) {
		this.yomi = yomi;
	}

	public void setLevel(String level) {
		this.level = level;
	}
}
