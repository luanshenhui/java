/**
 * 
 */
package com.lsh.domain;

/**
 * @author 栾慎辉
 *
 * 2015-2-2下午12:05:51
 * 
 * 角色表权限
 */
public class Roleaction extends BaseDomain {
	private String rolename;
	//private Person person=new Person();
	
	
	public Roleaction() {
		super();
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
//	public Person getPerson() {
//		return person;
//	}
//	public void setPerson(Person person) {
//		this.person = person;
//	}
	@Override
	public String toString() {
		return "Roleaction [person="  + ", rolename=" + rolename + "]";
	}
	
}
