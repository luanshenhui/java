package chinsoft.entity;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name = "Messages")
@XmlAccessorType(XmlAccessType.FIELD)
public class Errors implements java.io.Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6724018941626735059L;

	@XmlElement(name = "Message")
	private List<ErrorMessage> list;

	public List<ErrorMessage> getList() {
		return list;
	}

	public void setList(List<ErrorMessage> list) {
		this.list = list;
	}

	public void addMessage(List<ErrorMessage> list) {
		this.list = list;
	}

	public void addMessage(String code, String content) {
		ErrorMessage msg = new ErrorMessage(code, content);
		this.list.add(msg);
	}

	public void addMessage(String code, String content, String replaceContent) {
		ErrorMessage msg = new ErrorMessage(code, content, replaceContent);
		this.list.add(msg);
	}

	public Errors() {
		// TODO Auto-generated constructor stub
		list = new ArrayList<ErrorMessage>();
	}
}
