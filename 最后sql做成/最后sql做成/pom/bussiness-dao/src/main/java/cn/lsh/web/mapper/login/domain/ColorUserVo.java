package cn.lsh.web.mapper.login.domain;

public class ColorUserVo {
	private String person_id;
	private String userRole;
	private String ghA;
	private String ghB;
	private String ghC;
	private String ghD;
	private String ghE;
	private String leve;
	public String getUserRole() {
		return userRole;
	}
	public void setUserRole(String userRole) {
		this.userRole = userRole;
	}
	public String getGhA() {
		return ghA;
	}
	public void setGhA(String ghA) {
		this.ghA = ghA;
	}
	public String getGhB() {
		return ghB;
	}
	public void setGhB(String ghB) {
		this.ghB = ghB;
	}
	public String getGhC() {
		return ghC;
	}
	public void setGhC(String ghC) {
		this.ghC = ghC;
	}
	public String getGhD() {
		return ghD;
	}
	public void setGhD(String ghD) {
		this.ghD = ghD;
	}
	public String getGhE() {
		return ghE;
	}
	public void setGhE(String ghE) {
		this.ghE = ghE;
	}
	public String getLeve() {
		return leve;
	}
	public void setLeve(String leve) {
		this.leve = leve;
	}

	private int pageNo;
	
	private int pageSize;
	public int getPageNo() {
		return pageNo;
	}
	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public String getPerson_id() {
		return person_id;
	}
	public void setPerson_id(String person_id) {
		this.person_id = person_id;
	}

	
}
