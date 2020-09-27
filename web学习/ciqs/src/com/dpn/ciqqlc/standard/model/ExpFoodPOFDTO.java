package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class ExpFoodPOFDTO {
/*QLC_EXP_FOOD_PROD*/
	private String id;
	/**
	 * 企业名称
	 * */
	private String comp_name;
	/**
	 * 申请号
	 * */
	private String apply_no;
	/**
	 * 申请时间
	 * */
	private Date apply_date;
	/**
	 * 申请形式
	 * */
	private String apply_type;
	/**
	 * 流程环节
	 * */
	private String proc_type;
	/**
	 * 处理人
	 * */
	private String deal_user;
	/**
	 * 处理类型
	 * */
	private String deal_type;
	/**
	 * 送达回证
	 * */
	private String receipt;
	/**
	 * 本次备案厂区及库间简称
	 * */
	private String reg_comp_plc;
	/**
	 * 生产企业地址
	 * */
	private String comp_plc;
	/**
	 * 备案受理机构
	 * */
	private String enter_accp;
	/**
	 * 法人或授权负责人
	 * */
	private String legal_psn;
	/**
	 * EMAIL
	 * */
	private String e_mail;
	/**
	 * 邮政编码
	 * */
	private String post_no;
	/**
	 * 联系人姓名
	 * */
	private String con_name;
	/**
	 * 联系人电话
	 * */
	private String con_tel;
	/**
	 * 营业执照编号
	 * */
	private String buness_licen;
	/**
	 * 营业执照成立日期
	 * */
	private String buness_date;
	/**
	 * 组织机构代码
	 * */
	private String comp_code;
	/**
	 * 电话或传真
	 * */
	private String tel_fax;
	/**
	 * 厂区面积
	 * */
	private String plant_area;
	/**
	 * 建厂时间
	 * */
	private Date crt_plant;
	/**
	 * 最后改扩建时间
	 * */
	private Date lst_mod_plant_date;
	/**
	 * 最后改扩建内容
	 * */
	private String lst_mod_plant_con;
	/**
	 * 加工车间总面积
	 * */
	private String mach_plant_area;
	/**
	 * 本次申请品种的车间面积
	 * */
	private String cur_plant_area;
	/**
	 * 冷藏库面积
	 * */
	private String cld_plant_area;
	/**
	 * 冷藏库容量
	 * */
	private String cld_sto_area;
	/**
	 * 仓库面积
	 * */
	private String weah_area;
	/**
	 * 仓库容量
	 * */
	private String weah_area_cap;
	/**
	 * 速冻库容积
	 * */
	private String cld_sto_vol;
	/**
	 * 速冻库容量
	 * */
	private String cld_sto_cap;
	/**
	 * 速冻机能力
	 * */
	private String cld_mach_bily;
	/**
	 * 产品类别
	 * */
	private String prod_type;
	/**
	 * 产品名称
	 * */
	private String prod_name;
	/**
	 * 注册商标
	 * */
	private String reg_tradmk;
	/**
	 * 设计生产能力
	 * */
	private String dsgn_prod_bily;
	/**
	 * 主要出口国家或地区
	 * */
	private String exp_to_country;
	/**
	 * 管理负责人姓名
	 * */
	private String mana_psn_name;
	/**
	 * 生产负责人
	 * */
	private String prod_psn;
	/**
	 * 质量管理负责人
	 * */
	private String qua_mana_psn;
	/**
	 * 企业人数
	 * */
	private String psn_num;
	/**
	 * 生产人员数
	 * */
	private String prod_psn_num;
	/**
	 * 质量管理人员数
	 * */
	private String qua_psn_num;
	/**
	 * HACCP实施时间
	 * */
	private String haccp_date;
	/**
	 * HACCP小组成员
	 * */
	private String haccp_psn;
	/**
	 * 企业内审员
	 * */
	private String comp_audit_psn;
	/**
	 * 认证种类
	 * */
	private String auth_type;
	/**
	 * 认证机构
	 * */
	private String auth_org;
	/**
	 * 证书编码
	 * */
	private String cert_no;
	/**
	 * 有效期限
	 * */
	private String valid_term;
	/**
	 * 食品安全卫生控制体系运行情况
	 * */
	private String vedio_sys_situ;
	/**
	 * 设备名称
	 * */
	private String eqpm_name;
	/**
	 * 规格型号
	 * */
	private String spec_models;
	/**
	 * 购置年份
	 * */
	private String puech_date;
	/**
	 * 运行现状
	 * */
	private String func_situ;
	/**
	 * 操作负责人
	 * */
	private String func_opr_psn;
	/**
	 * 企业实验室获得资质认定的情况
	 * */
	private String labory_situ;
	/**
	 * 主要检测设备名称
	 * */
	private String faci_name;
	/**
	 * 检测项目
	 * */
	private String insp_item;
	/**
	 * 计量检定情况
	 * */
	private String meter_situ;
	/**
	 * 操作负责人
	 * */
	private String meter_opr_psn;
	/**
	 * 备注
	 * */
	private String rmk;
	/**
	 * 附件列表
	 * */
	private String attach_list;
/*QLC_EXP_FOOD_PROD_APRV*/
	private String approve_result;
	private String approve_notice;
	
	
	public String getAttach_list() {
		return attach_list;
	}
	public void setAttach_list(String attach_list) {
		this.attach_list = attach_list;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getReg_comp_plc() {
		return reg_comp_plc;
	}
	public void setReg_comp_plc(String reg_comp_plc) {
		this.reg_comp_plc = reg_comp_plc;
	}
	public String getComp_plc() {
		return comp_plc;
	}
	public void setComp_plc(String comp_plc) {
		this.comp_plc = comp_plc;
	}
	public String getEnter_accp() {
		return enter_accp;
	}
	public void setEnter_accp(String enter_accp) {
		this.enter_accp = enter_accp;
	}
	public String getLegal_psn() {
		return legal_psn;
	}
	public void setLegal_psn(String legal_psn) {
		this.legal_psn = legal_psn;
	}
	public String getE_mail() {
		return e_mail;
	}
	public void setE_mail(String e_mail) {
		this.e_mail = e_mail;
	}
	public String getPost_no() {
		return post_no;
	}
	public void setPost_no(String post_no) {
		this.post_no = post_no;
	}
	public String getCon_name() {
		return con_name;
	}
	public void setCon_name(String con_name) {
		this.con_name = con_name;
	}
	public String getCon_tel() {
		return con_tel;
	}
	public void setCon_tel(String con_tel) {
		this.con_tel = con_tel;
	}
	public String getBuness_licen() {
		return buness_licen;
	}
	public void setBuness_licen(String buness_licen) {
		this.buness_licen = buness_licen;
	}
	public String getBuness_date() {
		return buness_date;
	}
	public void setBuness_date(String buness_date) {
		this.buness_date = buness_date;
	}
	public String getComp_code() {
		return comp_code;
	}
	public void setComp_code(String comp_code) {
		this.comp_code = comp_code;
	}
	public String getTel_fax() {
		return tel_fax;
	}
	public void setTel_fax(String tel_fax) {
		this.tel_fax = tel_fax;
	}
	public String getPlant_area() {
		return plant_area;
	}
	public void setPlant_area(String plant_area) {
		this.plant_area = plant_area;
	}
	public Date getCrt_plant() {
		return crt_plant;
	}
	public void setCrt_plant(Date crt_plant) {
		this.crt_plant = crt_plant;
	}
	public Date getLst_mod_plant_date() {
		return lst_mod_plant_date;
	}
	public void setLst_mod_plant_date(Date lst_mod_plant_date) {
		this.lst_mod_plant_date = lst_mod_plant_date;
	}
	public String getLst_mod_plant_con() {
		return lst_mod_plant_con;
	}
	public void setLst_mod_plant_con(String lst_mod_plant_con) {
		this.lst_mod_plant_con = lst_mod_plant_con;
	}
	public String getMach_plant_area() {
		return mach_plant_area;
	}
	public void setMach_plant_area(String mach_plant_area) {
		this.mach_plant_area = mach_plant_area;
	}
	public String getCur_plant_area() {
		return cur_plant_area;
	}
	public void setCur_plant_area(String cur_plant_area) {
		this.cur_plant_area = cur_plant_area;
	}
	public String getCld_plant_area() {
		return cld_plant_area;
	}
	public void setCld_plant_area(String cld_plant_area) {
		this.cld_plant_area = cld_plant_area;
	}
	public String getCld_sto_area() {
		return cld_sto_area;
	}
	public void setCld_sto_area(String cld_sto_area) {
		this.cld_sto_area = cld_sto_area;
	}
	public String getWeah_area() {
		return weah_area;
	}
	public void setWeah_area(String weah_area) {
		this.weah_area = weah_area;
	}
	public String getWeah_area_cap() {
		return weah_area_cap;
	}
	public void setWeah_area_cap(String weah_area_cap) {
		this.weah_area_cap = weah_area_cap;
	}
	public String getCld_sto_vol() {
		return cld_sto_vol;
	}
	public void setCld_sto_vol(String cld_sto_vol) {
		this.cld_sto_vol = cld_sto_vol;
	}
	public String getCld_sto_cap() {
		return cld_sto_cap;
	}
	public void setCld_sto_cap(String cld_sto_cap) {
		this.cld_sto_cap = cld_sto_cap;
	}
	public String getCld_mach_bily() {
		return cld_mach_bily;
	}
	public void setCld_mach_bily(String cld_mach_bily) {
		this.cld_mach_bily = cld_mach_bily;
	}
	public String getProd_type() {
		return prod_type;
	}
	public void setProd_type(String prod_type) {
		this.prod_type = prod_type;
	}
	public String getProd_name() {
		return prod_name;
	}
	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	public String getReg_tradmk() {
		return reg_tradmk;
	}
	public void setReg_tradmk(String reg_tradmk) {
		this.reg_tradmk = reg_tradmk;
	}
	public String getDsgn_prod_bily() {
		return dsgn_prod_bily;
	}
	public void setDsgn_prod_bily(String dsgn_prod_bily) {
		this.dsgn_prod_bily = dsgn_prod_bily;
	}
	public String getExp_to_country() {
		return exp_to_country;
	}
	public void setExp_to_country(String exp_to_country) {
		this.exp_to_country = exp_to_country;
	}
	public String getMana_psn_name() {
		return mana_psn_name;
	}
	public void setMana_psn_name(String mana_psn_name) {
		this.mana_psn_name = mana_psn_name;
	}
	public String getProd_psn() {
		return prod_psn;
	}
	public void setProd_psn(String prod_psn) {
		this.prod_psn = prod_psn;
	}
	public String getQua_mana_psn() {
		return qua_mana_psn;
	}
	public void setQua_mana_psn(String qua_mana_psn) {
		this.qua_mana_psn = qua_mana_psn;
	}
	public String getPsn_num() {
		return psn_num;
	}
	public void setPsn_num(String psn_num) {
		this.psn_num = psn_num;
	}
	public String getProd_psn_num() {
		return prod_psn_num;
	}
	public void setProd_psn_num(String prod_psn_num) {
		this.prod_psn_num = prod_psn_num;
	}
	public String getQua_psn_num() {
		return qua_psn_num;
	}
	public void setQua_psn_num(String qua_psn_num) {
		this.qua_psn_num = qua_psn_num;
	}
	public String getHaccp_date() {
		return haccp_date;
	}
	public void setHaccp_date(String haccp_date) {
		this.haccp_date = haccp_date;
	}
	public String getHaccp_psn() {
		return haccp_psn;
	}
	public void setHaccp_psn(String haccp_psn) {
		this.haccp_psn = haccp_psn;
	}
	public String getComp_audit_psn() {
		return comp_audit_psn;
	}
	public void setComp_audit_psn(String comp_audit_psn) {
		this.comp_audit_psn = comp_audit_psn;
	}
	public String getAuth_type() {
		return auth_type;
	}
	public void setAuth_type(String auth_type) {
		this.auth_type = auth_type;
	}
	public String getAuth_org() {
		return auth_org;
	}
	public void setAuth_org(String auth_org) {
		this.auth_org = auth_org;
	}
	public String getCert_no() {
		return cert_no;
	}
	public void setCert_no(String cert_no) {
		this.cert_no = cert_no;
	}
	public String getValid_term() {
		return valid_term;
	}
	public void setValid_term(String valid_term) {
		this.valid_term = valid_term;
	}
	public String getVedio_sys_situ() {
		return vedio_sys_situ;
	}
	public void setVedio_sys_situ(String vedio_sys_situ) {
		this.vedio_sys_situ = vedio_sys_situ;
	}
	public String getEqpm_name() {
		return eqpm_name;
	}
	public void setEqpm_name(String eqpm_name) {
		this.eqpm_name = eqpm_name;
	}
	public String getSpec_models() {
		return spec_models;
	}
	public void setSpec_models(String spec_models) {
		this.spec_models = spec_models;
	}
	public String getPuech_date() {
		return puech_date;
	}
	public void setPuech_date(String puech_date) {
		this.puech_date = puech_date;
	}
	public String getFunc_situ() {
		return func_situ;
	}
	public void setFunc_situ(String func_situ) {
		this.func_situ = func_situ;
	}
	public String getFunc_opr_psn() {
		return func_opr_psn;
	}
	public void setFunc_opr_psn(String func_opr_psn) {
		this.func_opr_psn = func_opr_psn;
	}
	public String getLabory_situ() {
		return labory_situ;
	}
	public void setLabory_situ(String labory_situ) {
		this.labory_situ = labory_situ;
	}
	public String getFaci_name() {
		return faci_name;
	}
	public void setFaci_name(String faci_name) {
		this.faci_name = faci_name;
	}
	public String getInsp_item() {
		return insp_item;
	}
	public void setInsp_item(String insp_item) {
		this.insp_item = insp_item;
	}
	public String getMeter_situ() {
		return meter_situ;
	}
	public void setMeter_situ(String meter_situ) {
		this.meter_situ = meter_situ;
	}
	public String getMeter_opr_psn() {
		return meter_opr_psn;
	}
	public void setMeter_opr_psn(String meter_opr_psn) {
		this.meter_opr_psn = meter_opr_psn;
	}
	public String getRmk() {
		return rmk;
	}
	public void setRmk(String rmk) {
		this.rmk = rmk;
	}
	public String getApprove_notice() {
		return approve_notice;
	}
	public void setApprove_notice(String approve_notice) {
		this.approve_notice = approve_notice;
	}
	public String getReceipt() {
		return receipt;
	}
	public void setReceipt(String receipt) {
		this.receipt = receipt;
	}
	public String getApprove_result() {
		return approve_result;
	}
	public void setApprove_result(String approve_result) {
		this.approve_result = approve_result;
	}
	public String getComp_name() {
		return comp_name;
	}
	public void setComp_name(String comp_name) {
		this.comp_name = comp_name;
	}
	public String getApply_no() {
		return apply_no;
	}
	public void setApply_no(String apply_no) {
		this.apply_no = apply_no;
	}
//	public String getPort_org() {
//		return port_org;
//	}
//	public void setPort_org(String port_org) {
//		this.port_org = port_org;
//	}
	public Date getApply_date() {
		return apply_date;
	}
	public void setApply_date(Date apply_date) {
		this.apply_date = apply_date;
	}
	public String getApply_type() {
		return apply_type;
	}
	public void setApply_type(String apply_type) {
		this.apply_type = apply_type;
	}
	public String getProc_type() {
		return proc_type;
	}
	public void setProc_type(String proc_type) {
		this.proc_type = proc_type;
	}
	public String getDeal_user() {
		return deal_user;
	}
	public void setDeal_user(String deal_user) {
		this.deal_user = deal_user;
	}
	public String getDeal_type() {
		return deal_type;
	}
	public void setDeal_type(String deal_type) {
		this.deal_type = deal_type;
	}
	
	private String status;
	private String des;
	private String rdm_id;

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDes() {
		return des;
	}
	public void setDes(String des) {
		this.des = des;
	}
	public String getRdm_id() {
		return rdm_id;
	}
	public void setRdm_id(String rdm_id) {
		this.rdm_id = rdm_id;
	}
	
	
	
	
}
