package model;

public class Question {
	private int id;
	private String kanji;
	private String yomi;
	private String level;
	private String kai;

	public Question(int id, String kanji, String yomi, String level, String kai) {
		this.id = id;
		this.kanji = kanji;
		this.yomi = yomi;
		this.level = level;
		this.kai = kai;
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

	public String getKai() {
		return kai;
	}
}
