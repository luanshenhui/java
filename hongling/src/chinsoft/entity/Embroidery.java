package chinsoft.entity;

public class Embroidery {
	private Dict location;
	private Dict color;
	private Dict font;
	private String content;
	private Integer contentID;
	private Dict size;
	public Integer getContentID() {
		return contentID;
	}
	public void setContentID(Integer contentID) {
		this.contentID = contentID;
	}
	public Dict getLocation() {
		return location;
	}
	public void setLocation(Dict location) {
		this.location = location;
	}
	public Dict getColor() {
		return color;
	}
	public void setColor(Dict color) {
		this.color = color;
	}
	public Dict getFont() {
		return font;
	}
	public void setFont(Dict font) {
		this.font = font;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Dict getSize() {
		return size;
	}
	public void setSize(Dict size) {
		this.size = size;
	}
}
