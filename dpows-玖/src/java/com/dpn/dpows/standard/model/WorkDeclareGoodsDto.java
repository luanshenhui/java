package com.dpn.dpows.standard.model;import java.util.Date;

/**
* WorkDeclareGoodsDtoDto.
*
* @author zhaoqian@dpn.com.cn
* @since 1.0.0 zhaoqian@dpn.com.cn
* @version 1.0.0 zhaoqian@dpn.com.cn
* Created by ZhaoQian on 2017-9-6 14:27:26
**/public class WorkDeclareGoodsDto {
						// 字段              字段名         字段类型         是否可为空
	private String work_mehtod;//作业方式  VARCHAR2(32)  Y
	private String special_requirements;//特殊要求和说明  VARCHAR2(1024)  Y
	private String loading_type;//装卸类型  VARCHAR2(32)  Y
	private String port_loading_name;//装货港名称  VARCHAR2(32)  Y
	private Integer num;//件数  NUMBER(22)  Y
	private String lading_no;//提单号  VARCHAR2(16)  Y
	private String port_unloading_name;//卸货港名称  VARCHAR2(32)  Y
	private String explain;//货物补充说明  VARCHAR2(256)  Y
	private String physical_and_chemical;//理化性质  VARCHAR2(1024)  Y
	private String declare_id;//申报ID  VARCHAR2(32)  N
	private Integer status;//审核状态  NUMBER(22)  Y
	private String imdg_name;//危货名称  VARCHAR2(64)  Y
	private String address;//作业地点  VARCHAR2(32)  Y
	private String category;//类别  VARCHAR2(32)  Y
	private String reactivity;//反应性  VARCHAR2(32)  Y
	private String attached_id;//作业附证编号  VARCHAR2(128)  Y
	private String port_unloading;//卸货港  VARCHAR2(32)  Y
	private String imdg_no;//危规编号  VARCHAR2(32)  Y
	private String packing;//包装  VARCHAR2(64)  Y
	private String id;//申报货物ID  VARCHAR2(32)  N
	private String cntr_info;//箱信息,JSON格式{箱型、箱数、箱号}  VARCHAR2(1024)  Y
	private String port_loading;//装货港  VARCHAR2(32)  Y
	private String transport_method;//货运形式  VARCHAR2(32)  Y
	private String type;//货物种类  VARCHAR2(32)  Y
	private Double weight;//总重  NUMBER(22)  Y
	private String security_defense_measures;//安全防御措施  VARCHAR2(1024)  Y		private String work_mehtodStr; //作业方式code转换		private String statusStr; //货物审核状态code转换		private String verify_user_id;//审批人用户ID VARCHAR2(32)		private String verify_opinion;//审批意见 VARCHAR2(2048)	private Date gmt_verify; //审批时间DATE(7)
		public Date getGmt_verify() {		return gmt_verify;	}	public void setGmt_verify(Date gmt_verify) {		this.gmt_verify = gmt_verify;	}	public String getVerify_user_id() {		return verify_user_id;	}	public void setVerify_user_id(String verify_user_id) {		this.verify_user_id = verify_user_id;	}	public String getVerify_opinion() {		return verify_opinion;	}	public void setVerify_optinion(String verify_opinion) {		this.verify_opinion = verify_opinion;	}	public WorkDeclareGoodsDto(){}
	
    public String getWork_mehtod() {		return work_mehtod;	}	public void setWork_mehtod(String work_mehtod) {		this.work_mehtod = work_mehtod;	}	public String getSpecial_requirements() {		return special_requirements;	}	public void setSpecial_requirements(String special_requirements) {		this.special_requirements = special_requirements;	}	public String getLoading_type() {		return loading_type;	}	public void setLoading_type(String loading_type) {		this.loading_type = loading_type;	}	public String getPort_loading_name() {		return port_loading_name;	}	public void setPort_loading_name(String port_loading_name) {		this.port_loading_name = port_loading_name;	}	public Integer getNum() {		return num;	}	public void setNum(Integer num) {		this.num = num;	}	public String getLading_no() {		return lading_no;	}	public void setLading_no(String lading_no) {		this.lading_no = lading_no;	}	public String getPort_unloading_name() {		return port_unloading_name;	}	public void setPort_unloading_name(String port_unloading_name) {		this.port_unloading_name = port_unloading_name;	}	public String getExplain() {		return explain;	}	public void setExplain(String explain) {		this.explain = explain;	}	public String getPhysical_and_chemical() {		return physical_and_chemical;	}	public void setPhysical_and_chemical(String physical_and_chemical) {		this.physical_and_chemical = physical_and_chemical;	}	public String getDeclare_id() {		return declare_id;	}	public void setDeclare_id(String declare_id) {		this.declare_id = declare_id;	}	public Integer getStatus() {		return status;	}	public void setStatus(Integer status) {		this.status = status;	}	public String getImdg_name() {		return imdg_name;	}	public void setImdg_name(String imdg_name) {		this.imdg_name = imdg_name;	}	public String getAddress() {		return address;	}	public void setAddress(String address) {		this.address = address;	}	public String getCategory() {		return category;	}	public void setCategory(String category) {		this.category = category;	}	public String getReactivity() {		return reactivity;	}	public void setReactivity(String reactivity) {		this.reactivity = reactivity;	}	public String getAttached_id() {		return attached_id;	}	public void setAttached_id(String attached_id) {		this.attached_id = attached_id;	}	public String getPort_unloading() {		return port_unloading;	}	public void setPort_unloading(String port_unloading) {		this.port_unloading = port_unloading;	}	public String getImdg_no() {		return imdg_no;	}	public void setImdg_no(String imdg_no) {		this.imdg_no = imdg_no;	}	public String getPacking() {		return packing;	}	public void setPacking(String packing) {		this.packing = packing;	}	public String getId() {		return id;	}	public void setId(String id) {		this.id = id;	}	public String getCntr_info() {		return cntr_info;	}	public void setCntr_info(String cntr_info) {		this.cntr_info = cntr_info;	}	public String getPort_loading() {		return port_loading;	}	public void setPort_loading(String port_loading) {		this.port_loading = port_loading;	}	public String getTransport_method() {		return transport_method;	}	public void setTransport_method(String transport_method) {		this.transport_method = transport_method;	}	public String getType() {		return type;	}	public void setType(String type) {		this.type = type;	}	public Double getWeight() {		return weight;	}	public void setWeight(Double weight) {		this.weight = weight;	}	public String getSecurity_defense_measures() {		return security_defense_measures;	}	public void setSecurity_defense_measures(String security_defense_measures) {		this.security_defense_measures = security_defense_measures;	}	public String toString(){
        return "";
    }
    public String toJsonString(){
        return "";
    }	public String getWork_mehtodStr() {		return work_mehtodStr;	}	public void setWork_mehtodStr(String work_mehtodStr) {		this.work_mehtodStr = work_mehtodStr;	}	public String getStatusStr() {		return statusStr;	}	public void setStatusStr(String statusStr) {		this.statusStr = statusStr;	}
	
}
