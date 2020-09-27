package cn.com.cgbchina.rest.common.model;

public class EBankModel<T> {
	private String rf;
	private String senderSN;
	private String srcChannel;
	private T content;

	public T getContent() {
		return content;
	}

	public void setContent(T content) {
		this.content = content;
	}

	public String getRf() {
		return rf;
	}

	public void setRf(String rf) {
		this.rf = rf;
	}

	public String getSenderSN() {
		return senderSN;
	}

	public void setSenderSN(String senderSN) {
		this.senderSN = senderSN;
	}

	public String getSrcChannel() {
		return srcChannel;
	}

	public void setSrcChannel(String srcChannel) {
		this.srcChannel = srcChannel;
	}

}
