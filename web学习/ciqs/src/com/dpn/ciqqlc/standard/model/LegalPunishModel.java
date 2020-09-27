package com.dpn.ciqqlc.standard.model;

public class LegalPunishModel extends LocalePunishDTO{

	private String illegal_basis;//违法依据描述
	
	private String punish_basis;//处罚依据描述
	private String port_dept;
	private String port_org;
	public String getIllegal_basis() {
		return illegal_basis;
	}

	public void setIllegal_basis(String illegal_basis) {
		this.illegal_basis = illegal_basis;
	}

	public String getPunish_basis() {
		return punish_basis;
	}

	public void setPunish_basis(String punish_basis) {
		this.punish_basis = punish_basis;
	}

	public String getPort_dept() {
		return port_dept;
	}

	public void setPort_dept(String port_dept) {
		this.port_dept = port_dept;
	}

	public String getPort_org() {
		return port_org;
	}

	public void setPort_org(String port_org) {
		this.port_org = port_org;
	}
	
	
}
