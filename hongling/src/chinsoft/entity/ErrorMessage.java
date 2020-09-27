package chinsoft.entity;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * ������ʾ��
 * 
 * @author ����
 * 
 */
@XmlRootElement(name = "Message")
@XmlAccessorType(XmlAccessType.FIELD)
public class ErrorMessage implements java.io.Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -220052838379979068L;
	@XmlElement(name = "Code")
	private String code;
	@XmlElement(name = "Content")
	private String content;
	@XmlElement(name = "ReplaceContent")
	private String replaceContent;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getReplaceContent() {
		return replaceContent;
	}

	public void setReplaceContent(String replaceContent) {
		this.replaceContent = replaceContent;
	}

	public ErrorMessage(String code, String content, String replaceContent) {
		super();
		this.code = code;
		this.content = content;
		this.replaceContent = replaceContent;
	}

	public ErrorMessage(String code, String content) {
		super();
		this.code = code;
		this.content = content;
	}

	public ErrorMessage() {
		super();
	}

}
