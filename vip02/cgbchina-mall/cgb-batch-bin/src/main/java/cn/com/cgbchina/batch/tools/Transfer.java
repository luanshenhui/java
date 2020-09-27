package cn.com.cgbchina.batch.tools;


import java.io.Serializable;


public class Transfer implements Serializable {
	@Override
	public String toString() {
		return "Transfer [categoryname=" + categoryname + ", categoryid="
				+ categoryid + ", parientid=" + parientid + ", childrenids="
				+ childrenids + ", attributesKeys=" + attributesKeys
				+ ", attributesValues=" + attributesValues + ", spus=" + spus
				+ "]";
	}

	private static final long serialVersionUID = -312839269905412503L;
	private String categoryname;
	private String categoryid;
	private String parientid;
	private String childrenids;
	private String attributesKeys;
	private String attributesValues;
	private String spus;

	public String getCategoryname() {
		return categoryname;
	}

	public void setCategoryname(String categoryname) {
		this.categoryname = categoryname;
	}

	public String getCategoryid() {
		return categoryid;
	}

	public void setCategoryid(String categoryid) {
		this.categoryid = categoryid;
	}

	public String getParientid() {
		return parientid;
	}

	public void setParientid(String parientid) {
		this.parientid = parientid;
	}

	public String getChildrenids() {
		return childrenids;
	}

	public void setChildrenids(String childrenids) {
		this.childrenids = childrenids;
	}

	public String getAttributesKeys() {
		return attributesKeys;
	}

	public void setAttributesKeys(String attributesKeys) {
		this.attributesKeys = attributesKeys;
	}

	public String getAttributesValues() {
		return attributesValues;
	}

	public void setAttributesValues(String attributesValues) {
		this.attributesValues = attributesValues;
	}

	public String getSpus() {
		return spus;
	}

	public void setSpus(String spus) {
		this.spus = spus;
	}
}
