package com.yulin.dangdang.bean;

import java.io.Serializable;

public class Book implements Serializable{
	private static final long serialVersionUID = 1L;
	private int id;
	private String author;
	private String publishing;
	private long publish_time;
	private String word_number;
	private String which_edtion;
	private String total_page;
	private int print_time;
	private String print_number;
	private String isbn;
	private String author_summary;
	private String catalogue;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(String author) {
		this.author = author;
	}
	public String getPublishing() {
		return publishing;
	}
	public void setPublishing(String publishing) {
		this.publishing = publishing;
	}
	public long getPublish_time() {
		return publish_time;
	}
	public void setPublish_time(long publishTime) {
		publish_time = publishTime;
	}
	public String getWord_number() {
		return word_number;
	}
	public void setWord_number(String wordNumber) {
		word_number = wordNumber;
	}
	public String getWhich_edtion() {
		return which_edtion;
	}
	public void setWhich_edtion(String whichEdtion) {
		which_edtion = whichEdtion;
	}
	public String getTotal_page() {
		return total_page;
	}
	public void setTotal_page(String totalPage) {
		total_page = totalPage;
	}
	public int getPrint_time() {
		return print_time;
	}
	public void setPrint_time(int printTime) {
		print_time = printTime;
	}
	public String getPrint_number() {
		return print_number;
	}
	public void setPrint_number(String printNumber) {
		print_number = printNumber;
	}
	public String getIsbn() {
		return isbn;
	}
	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}
	public String getAuthor_summary() {
		return author_summary;
	}
	public void setAuthor_summary(String authorSummary) {
		author_summary = authorSummary;
	}
	public String getCatalogue() {
		return catalogue;
	}
	public void setCatalogue(String catalogue) {
		this.catalogue = catalogue;
	}
	public Book() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Book(int id, String author, String publishing, long publishTime,
			String wordNumber, String whichEdtion, String totalPage,
			int printTime, String printNumber, String isbn,
			String authorSummary, String catalogue) {
		super();
		this.id = id;
		this.author = author;
		this.publishing = publishing;
		publish_time = publishTime;
		word_number = wordNumber;
		which_edtion = whichEdtion;
		total_page = totalPage;
		print_time = printTime;
		print_number = printNumber;
		this.isbn = isbn;
		author_summary = authorSummary;
		this.catalogue = catalogue;
	}
	@Override
	public String toString() {
		return "Book [author=" + author + ", author_summary=" + author_summary
				+ ", catalogue=" + catalogue + ", id=" + id + ", isbn=" + isbn
				+ ", print_number=" + print_number + ", print_time="
				+ print_time + ", publish_time=" + publish_time
				+ ", publishing=" + publishing + ", total_page=" + total_page
				+ ", which_edtion=" + which_edtion + ", word_number="
				+ word_number + "]";
	}
	
}
