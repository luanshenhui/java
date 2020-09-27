package com.dpn.ciqqlc.http.form;

public class UsersForm
{
	private String id;
	private String username;
	private String orgcode;
	private String mobilephone;
	private String fixedphone;
	private String deptcode;
	private String levelcode;
	private Object filePath;
	private String filePathName;
	private String card_no;
	private String duties;
	
	public String getDuties() {
		return duties;
	}
	public void setDuties(String duties) {
		this.duties = duties;
	}
	public String getCard_no() {
		return card_no;
	}
	public void setCard_no(String card_no) {
		this.card_no = card_no;
	}
	public String getLevelcode() {
		return levelcode;
	}
	public void setLevelcode(String levelcode) {
		this.levelcode = levelcode;
	}
	public String[] getOnWork() {
		return onWork;
	}
	public void setOnWork(String[] onWork) {
		this.onWork = onWork;
	}
	private String[] userIds;
	private String[] onWork;//是否当值，1是0否	
	
	public String[] getUserIds() {
		return userIds;
	}
	public void setUserIds(String[] userIds) {
		this.userIds = userIds;
	}

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getOrgcode() {
		return orgcode;
	}
	public void setOrgcode(String orgcode) {
		this.orgcode = orgcode;
	}
	public String getMobilephone() {
		return mobilephone;
	}
	public void setMobilephone(String mobilephone) {
		this.mobilephone = mobilephone;
	}
	public String getFixedphone() {
		return fixedphone;
	}
	public void setFixedphone(String fixedphone) {
		this.fixedphone = fixedphone;
	}
	public String getDeptcode() {
		return deptcode;
	}
	public void setDeptcode(String deptcode) {
		this.deptcode = deptcode;
	}
	public Object getFilePath() {
		return filePath;
	}
	public void setFilePath(Object filePath) {
		this.filePath = filePath;
	}
	public String getFilePathName() {
		return filePathName;
	}
	public void setFilePathName(String filePathName) {
		this.filePathName = filePathName;
	}
	
	

}
