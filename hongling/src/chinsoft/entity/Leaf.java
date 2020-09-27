package chinsoft.entity;

public class Leaf implements java.io.Serializable {
	private static final long serialVersionUID = 998271974498813382L;
    private String xpath;         //
    private String value;

    public Leaf(String xpath, String value) {
        this.xpath = xpath;
        this.value = value;
    }

    public String getXpath() {
        return xpath;
    }

    public void setXpath(String xpath) {
        this.xpath = xpath;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
 
