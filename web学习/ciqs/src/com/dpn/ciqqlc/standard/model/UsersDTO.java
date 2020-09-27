package com.dpn.ciqqlc.standard.model;

import java.io.Serializable;
import java.util.Date;

public class UsersDTO  implements Serializable
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String id;//用户代码，主键
	private String name;//用户姓名
	private String flag_op;//操作标示,A.D
	private String on_work;
	private String org_type;
	private String password;//密码
	private String org_code;//所属组织代码
	private String org_name;//所属组织代码
	private String filePath;
	private String dept_code;//用户所属科室
	private String level_code;
	private String port_code;
    private String depot_name;
	private String fixed_phone;//联系电话
	private String modify_user;//修改人
	private String create_user;//创建人
	private String manage_sign;//管理员标识
	private String terminal_cur;
	private String mobile_phone_no;//移动电话
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

	private Date create_date;//创建时间
	private Date modify_date;//修改时间
	private String directy_under_org;
	
	public String getDirecty_under_org() {
		return directy_under_org;
	}

	public void setDirecty_under_org(String directy_under_org) {
		this.directy_under_org = directy_under_org;
	}

	public String getLevel_code() {
		return level_code;
	}

	public void setLevel_code(String level_code) {
		this.level_code = level_code;
	}

	public String getOn_work() {
		return on_work;
	}

	public void setOn_work(String on_work) {
		this.on_work = on_work;
	}

	public String getTerminal_cur() {
		return terminal_cur;
	}

	public void setTerminal_cur(String terminal_cur) {
		this.terminal_cur = terminal_cur;
	}

	public String getPort_code() {
		return port_code;
	}

	public void setPort_code(String port_code) {
		this.port_code = port_code;
	}

	public String getOrg_type() {
		return org_type;
	}

	public void setOrg_type(String org_type) {
		this.org_type = org_type;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getOrg_name() {
		return org_name;
	}

	public void setOrg_name(String org_name) {
		this.org_name = org_name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDept_code() {
		return dept_code;
	}

	public void setDept_code(String dept_code) {
		this.dept_code = dept_code;
	}

	public String getOrg_code() {
		return org_code;
	}

	public void setOrg_code(String org_code) {
		this.org_code = org_code;
	}

	public String getFixed_phone() {
		return fixed_phone;
	}

	public void setFixed_phone(String fixed_phone) {
		this.fixed_phone = fixed_phone;
	}

	public String getMobile_phone_no() {
		return mobile_phone_no;
	}

	public void setMobile_phone_no(String mobile_phone_no) {
		this.mobile_phone_no = mobile_phone_no;
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

	public String getFlag_op() {
		return flag_op;
	}

	public void setFlag_op(String flag_op) {
		this.flag_op = flag_op;
	}

	public String getManage_sign() {
		return manage_sign;
	}

	public void setManage_sign(String manage_sign) {
		this.manage_sign = manage_sign;
	}

	public String toString()
	{
		StringBuffer buf= new StringBuffer("");
		buf.append("id:"+getId()+";");
		buf.append("name:"+getName()+";");
		buf.append("dept_code:"+getDept_code()+";");
		buf.append("org_code:"+getOrg_code()+";");
		buf.append("fixed_phone:"+getFixed_phone()+";");
		buf.append("mobile_phone_no:"+getMobile_phone_no()+";");
		return buf.toString();
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

    public String getDepot_name() {
        return depot_name;
    }

    public void setDepot_name(String depot_name) {
        this.depot_name = depot_name;
    }
}