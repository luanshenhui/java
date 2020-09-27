package com.dpn.dpows.standard.model;

/*** WorkDeclareDtoDto.*
* @author zhaoqian@dpn.com.cn
* @since 1.0.0 zhaoqian@dpn.com.cn
* @version 1.0.0 zhaoqian@dpn.com.cn
* Created by ZhaoQian on 2017-9-6 14:27:26
**/
public class WorkDeclareDto {
						// 字段              字段名         字段类型         是否可为空
	private String ship_name;//中文船名  VARCHAR2(64)  Y
	private String applicant_user_name;//申报人员用户名称  VARCHAR2(64)  Y
	private String city_name;//地市名称  VARCHAR2(64)  Y
	private String time_end;//作业结束时间  DATE(7)  Y
	private String employees_names;//作业人员  VARCHAR2(512)  Y
	private Integer exit_flag;//内外贸标志  NUMBER(22)  Y
	private String port_area_name;//所在港区名称  VARCHAR2(100)  Y
	private String applicant_user_id;//申报人员用户ID  VARCHAR2(32)  Y
	private String department_name;//审批单位/部门名称  VARCHAR2(100)  Y
	private String province_code;//省份编码  VARCHAR2(32)  Y
	private String ship_english_name;//英文船名  VARCHAR2(64)  Y
	private String port;//口岸  VARCHAR2(32)  Y
	private String contacts;//联系人信息  VARCHAR2(128)  Y
	private String id;//申报ID  VARCHAR2(32)  N
	private String remarks;//备注  VARCHAR2(2048)  Y
	private String city_code;//地市编码  VARCHAR2(32)  Y
	private String time_start;//作业开始时间  DATE(7)  Y
	private String gmt_created;//申报时间  DATE(7)  Y
	private String verify_opinion;//审批意见  VARCHAR2(2048)  Y
	private String gmt_modified;//修改时间  DATE(7)  Y
	private String enterprise_id;//申报企业（企业ID）  VARCHAR2(32)  Y
	private String district_name;//区县名称  VARCHAR2(64)  Y
	private String port_name;//口岸名称  VARCHAR2(64)  Y
	private String declare_no;//申报单号  VARCHAR2(32)  Y
	private String bailor;//作业委托人  VARCHAR2(32)  Y
	private String is_deleted;//是否已经删除  CHAR(1)  Y
	private String feedback_user_name;//反馈人员用户名称  VARCHAR2(64)  Y
	private String ship_id;//船舶ID  VARCHAR2(32)  Y
	private String manager_user_id;//初始审批人用户ID  VARCHAR2(32)  Y
	private String port_area_id;//所在港区  VARCHAR2(32)  Y
	private String department_id;//审批单位/部门ID  VARCHAR2(32)  Y
	private String feedback_user_id;//反馈人员用户ID  VARCHAR2(32)  Y
	private String declare_type;//申报类型  VARCHAR2(32)  Y
	private String manager_user_name;//初始审批人用户名称  VARCHAR2(64)  Y
	private String province_name;//省份名称  VARCHAR2(64)  Y
	private String entry_port_flag;//进出港标志  NUMBER(22)  Y
	private Integer voyage_number;//航次  NUMBER(22)  Y
	private String current_user_name;//当前审批人用户名称  VARCHAR2(64)  Y
	private Integer verify_status;//审批状态  NUMBER(22)  Y
	private String district_code;//区县编码  VARCHAR2(32)  Y
	private String enterprise_name;//申报企业名称  VARCHAR2(100)  Y
	private String current_user_id;//当前审批人用户ID  VARCHAR2(32)  Y
	private String feedback_status;//反馈状态  NUMBER(22)  Y		private String gmt_created_begin; //申报开始时间 查询条件	private String gmt_created_over; //申报结束时间 查询条件		private String status; //货物审核状态  		private String exitFlagStr; //内外贸标志code转换字段		private String declareTypeStr;			private String imdg_name;		private String work_mehtod;		public WorkDeclareDto(){}		
    public String getShip_name() {		return ship_name;	}	public void setShip_name(String ship_name) {		this.ship_name = ship_name;	}	public String getApplicant_user_name() {		return applicant_user_name;	}	public void setApplicant_user_name(String applicant_user_name) {		this.applicant_user_name = applicant_user_name;	}	public String getCity_name() {		return city_name;	}	public void setCity_name(String city_name) {		this.city_name = city_name;	}	public String getTime_end() {		return time_end;	}	public void setTime_end(String time_end) {		this.time_end = time_end;	}	public String getEmployees_names() {		return employees_names;	}	public void setEmployees_names(String employees_names) {		this.employees_names = employees_names;	}	public Integer getExit_flag() {		return exit_flag;	}	public void setExit_flag(Integer exit_flag) {		this.exit_flag = exit_flag;	}	public String getPort_area_name() {		return port_area_name;	}	public void setPort_area_name(String port_area_name) {		this.port_area_name = port_area_name;	}	public String getApplicant_user_id() {		return applicant_user_id;	}	public void setApplicant_user_id(String applicant_user_id) {		this.applicant_user_id = applicant_user_id;	}	public String getDepartment_name() {		return department_name;	}	public void setDepartment_name(String department_name) {		this.department_name = department_name;	}	public String getProvince_code() {		return province_code;	}	public void setProvince_code(String province_code) {		this.province_code = province_code;	}	public String getShip_english_name() {		return ship_english_name;	}	public void setShip_english_name(String ship_english_name) {		this.ship_english_name = ship_english_name;	}	public String getPort() {		return port;	}	public void setPort(String port) {		this.port = port;	}	public String getContacts() {		return contacts;	}	public void setContacts(String contacts) {		this.contacts = contacts;	}	public String getId() {		return id;	}	public void setId(String id) {		this.id = id;	}	public String getRemarks() {		return remarks;	}	public void setRemarks(String remarks) {		this.remarks = remarks;	}	public String getCity_code() {		return city_code;	}	public void setCity_code(String city_code) {		this.city_code = city_code;	}	public String getTime_start() {		return time_start;	}	public void setTime_start(String time_start) {		this.time_start = time_start;	}	public String getGmt_created() {		return gmt_created;	}	public void setGmt_created(String gmt_created) {		this.gmt_created = gmt_created;	}	public String getVerify_opinion() {		return verify_opinion;	}	public void setVerify_opinion(String verify_opinion) {		this.verify_opinion = verify_opinion;	}	public String getGmt_modified() {		return gmt_modified;	}	public void setGmt_modified(String gmt_modified) {		this.gmt_modified = gmt_modified;	}	public String getEnterprise_id() {		return enterprise_id;	}	public void setEnterprise_id(String enterprise_id) {		this.enterprise_id = enterprise_id;	}	public String getDistrict_name() {		return district_name;	}	public void setDistrict_name(String district_name) {		this.district_name = district_name;	}	public String getPort_name() {		return port_name;	}	public void setPort_name(String port_name) {		this.port_name = port_name;	}	public String getDeclare_no() {		return declare_no;	}	public void setDeclare_no(String declare_no) {		this.declare_no = declare_no;	}	public String getBailor() {		return bailor;	}	public void setBailor(String bailor) {		this.bailor = bailor;	}	public String getIs_deleted() {		return is_deleted;	}	public void setIs_deleted(String is_deleted) {		this.is_deleted = is_deleted;	}	public String getFeedback_user_name() {		return feedback_user_name;	}	public void setFeedback_user_name(String feedback_user_name) {		this.feedback_user_name = feedback_user_name;	}	public String getShip_id() {		return ship_id;	}	public void setShip_id(String ship_id) {		this.ship_id = ship_id;	}	public String getManager_user_id() {		return manager_user_id;	}	public void setManager_user_id(String manager_user_id) {		this.manager_user_id = manager_user_id;	}	public String getPort_area_id() {		return port_area_id;	}	public void setPort_area_id(String port_area_id) {		this.port_area_id = port_area_id;	}	public String getDepartment_id() {		return department_id;	}	public void setDepartment_id(String department_id) {		this.department_id = department_id;	}	public String getFeedback_user_id() {		return feedback_user_id;	}	public void setFeedback_user_id(String feedback_user_id) {		this.feedback_user_id = feedback_user_id;	}	public String getDeclare_type() {		return declare_type;	}	public void setDeclare_type(String declare_type) {		this.declare_type = declare_type;	}	public String getManager_user_name() {		return manager_user_name;	}	public void setManager_user_name(String manager_user_name) {		this.manager_user_name = manager_user_name;	}	public String getProvince_name() {		return province_name;	}	public void setProvince_name(String province_name) {		this.province_name = province_name;	}	public String getEntry_port_flag() {		return entry_port_flag;	}	public void setEntry_port_flag(String entry_port_flag) {		this.entry_port_flag = entry_port_flag;	}	public Integer getVoyage_number() {		return voyage_number;	}	public void setVoyage_number(Integer voyage_number) {		this.voyage_number = voyage_number;	}	public String getCurrent_user_name() {		return current_user_name;	}	public void setCurrent_user_name(String current_user_name) {		this.current_user_name = current_user_name;	}	public Integer getVerify_status() {		return verify_status;	}	public void setVerify_status(Integer verify_status) {		this.verify_status = verify_status;	}	public String getDistrict_code() {		return district_code;	}	public void setDistrict_code(String district_code) {		this.district_code = district_code;	}	public String getEnterprise_name() {		return enterprise_name;	}	public void setEnterprise_name(String enterprise_name) {		this.enterprise_name = enterprise_name;	}	public String getCurrent_user_id() {		return current_user_id;	}	public void setCurrent_user_id(String current_user_id) {		this.current_user_id = current_user_id;	}	public String getFeedback_status() {		return feedback_status;	}	public void setFeedback_status(String feedback_status) {		this.feedback_status = feedback_status;	}		public String getGmt_created_begin() {		return gmt_created_begin;	}	public void setGmt_created_begin(String gmt_created_begin) {		this.gmt_created_begin = gmt_created_begin;	}	public String getGmt_created_over() {		return gmt_created_over;	}	public void setGmt_created_over(String gmt_created_over) {		this.gmt_created_over = gmt_created_over;	}		public String getImdg_name() {		return imdg_name;	}	public void setImdg_name(String imdg_name) {		this.imdg_name = imdg_name;	}	public String getWork_mehtod() {		return work_mehtod;	}	public void setWork_mehtod(String work_mehtod) {		this.work_mehtod = work_mehtod;	}	public String toString(){
        return "";
    }
    public String toJsonString(){
        return "";
    }	public String getStatus() {		return status;	}	public void setStatus(String status) {		this.status = status;	}	public String getExitFlagStr() {		return exitFlagStr;	}	public void setExitFlagStr(String exitFlagStr) {		this.exitFlagStr = exitFlagStr;	}	public String getDeclareTypeStr() {		return declareTypeStr;	}	public void setDeclareTypeStr(String declareTypeStr) {		this.declareTypeStr = declareTypeStr;	}
	
}
