package com.dpn.ciqqlc.http.form;

public class ResourceForm {
	private String id;
	private String resid;
	private String roleId;
	private String name;
	private String resname;
	private String restype;
	private String resstring;
	private String resdesc;
	private String pri;
	private String hiddenid;
	private String priority[];
	private String rolesbox[];
	private String creator;
	
	
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String[] getRolesbox() {
		return rolesbox;
	}
	public void setRolesbox(String[] rolesbox) {
		this.rolesbox = rolesbox;
	}
	public String[] getPriority() {
		return priority;
	}
	public void setPriority(String[] priority) {
		this.priority = priority;
	}
	public String getPri() {
		return pri;
	}
	public void setPri(String pri) {
		this.pri = pri;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getResname() {
		return resname;
	}
	public void setResname(String resname) {
		this.resname = resname;
	}
	public String getRestype() {
		return restype;
	}
	public void setRestype(String restype) {
		this.restype = restype;
	}
	public String getResstring() {
		return resstring;
	}
	public void setResstring(String resstring) {
		this.resstring = resstring;
	}
	public String getResdesc() {
		return resdesc;
	}
	public void setResdesc(String resdesc) {
		this.resdesc = resdesc;
	}
	public String getResid() {
		return resid;
	}
	public void setResid(String resid) {
		this.resid = resid;
	}
	public String getHiddenid() {
		return hiddenid;
	}
	public void setHiddenid(String hiddenid) {
		this.hiddenid = hiddenid;
	}
	/**
	 * @return Returns the roleId.
	 */
	public String getRoleId() {
		return roleId;
	}
	/**
	 * @param roleId The roleId to set.
	 */
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	
	
}
