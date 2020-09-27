package cn.com.cgbchina.rest.common.model;

public class EBankReturnModel<T> {
	private String ec;

	private String em;

	private String syn;

	private T content;

	public String getEc() {
		return ec;
	}

	public void setEc(String ec) {
		this.ec = ec;
	}

	public String getEm() {
		return em;
	}

	public void setEm(String em) {
		this.em = em;
	}

	public String getSyn() {
		return syn;
	}

	public void setSyn(String syn) {
		this.syn = syn;
	}

	public T getContent() {
		return content;
	}

	public void setContent(T content) {
		this.content = content;
	}

}
