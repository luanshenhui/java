package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class OrganizesDTO 
{
	private String org_code;//组织代码
	private String name;//组织名称
	private String type;//组织类型
	private String port_code;//所属口岸
	private Date create_date;//创建时间
	private String create_user;//创建人
	private Date modify_date;//修改时间
	private String modify_user;//修改人
	
	public String getOrg_code() {
		return org_code;
	}

	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPort_code() {
		return port_code;
	}

	public void setPort_code(String port_code) {
		this.port_code = port_code;
	}

	public Date getCreate_date() {
		return create_date;
	}

	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}

	public String getCreate_user() {
		return create_user;
	}

	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}

	public Date getModify_date() {
		return modify_date;
	}

	public void setModify_date(Date modify_date) {
		this.modify_date = modify_date;
	}

	public String getModify_user() {
		return modify_user;
	}

	public void setModify_user(String modify_user) {
		this.modify_user = modify_user;
	}

	public String toString ()
	{
		StringBuffer buf= new StringBuffer("");
		buf.append("ORG_CODE"+getOrg_code()+";");
		buf.append("NAME"+getName()+";");
		buf.append("TYPE"+getType()+";");
		buf.append("PORT_CODE"+getPort_code()+";");
		return buf.toString();
	}

}
