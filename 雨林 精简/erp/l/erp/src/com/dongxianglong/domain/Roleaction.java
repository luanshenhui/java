/**
 * 
 */
package com.dongxianglong.domain;

/**
 * @author ������
 *
 * 2015-2-2����11:31:09
 * ��ɫ��
 */
public class Roleaction extends BaseDomain {
	
	private String rolename;
	

	public Roleaction() {
		this("");
	}
	public Roleaction(String rolename) {
		super();
		this.rolename = rolename;
	}



	public String getRolename() {
		return rolename;
	}

	public void setRolename(String rolename) {
		this.rolename = rolename;
	}



	public String toString() {
		return "Roleaction [rolename=" + rolename + "]";
	}
	
	
	

}
