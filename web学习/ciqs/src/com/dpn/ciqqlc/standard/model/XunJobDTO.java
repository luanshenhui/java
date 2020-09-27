package com.dpn.ciqqlc.standard.model;

public class XunJobDTO {

	private String xun_id;//熏蒸ID
	private String conta_id;//集装箱ID
	private String bill_id;//提单编号
	private String bill_no;//提单号
	private String conta_no;//箱号
	private String ship_name_en;//船名
	private String voyage_no;//航次
	private String port_org_code;//申报口岸
	private String port_dept_code;//申报科室
	private String ciq_check_user;//ciq检疫人员
	private String ciq_check_user_nm;//ciq检疫人员名称
	private String create_time;//创建时间
	private String deal_rsn;//检疫处理原因
	private String deal_meth;//处理方法
	private String description;//处理方法详细描述
	private String deal_medic;//处理药剂代码
	private String deal_medic_cn;//处理药剂名称
	private String techno_rqst;//技术要求
	private String xun_time;//药效时间
	private String dosage;//剂量
	private String o_tmprtu;//外界温度
	private String spread_date;//散毒时间
	private String duration;//密闭/持续时间
	private String xun_check_time;//熏蒸检测时间
	private String deal_date;//作业时间
	private String xun_finish_date;//熏蒸完毕时间
	private String xun_check_rst;//熏蒸检测结果
	private String xun_user;//熏蒸作业人员
	private String xun_org;//熏蒸公司
	private String xun_user_nm;//熏蒸作业人员名称
	private String xun_org_nm;//熏蒸公司名称
	private String fee;//计费金额
	private String fee_clct;//收费人员
	private String status;//状态0：有计划；1：有反馈
	private String assign_date;//派工时间
	
	
	private String work_start;
	private String work_end;
	private String volumn;
	private String toal_medic;
	private String potency;
	
	private String remark;//备注
	
	
	private String receiver;
	private String connector;
	private String dec_ent_name;
	
	private String xun_audit_status;//熏蒸处理的审核状态
	private String xun_audit_person;//
	private String xun_audit_date;//
	
	//打印
	private String goods_volume;
	private String conta_model;
	private String book_no;
	private String dec_org_name;
	private String dec_user;
	private String origin_country_name;
	private String decl_no;
	private String telephone;
	private String goods_cname;
	private String weight;
	private String weight_unit_name;
	private String qty;
	private String qty_unit_name;
	private String pack_type_name;
	private String wood_count;
	private String land_area_code;
	private String land_place;
	private String conta_mode20;
	private String conta_mode40;
	private String operator;
	private String auditor;
	
	private String assign_status;
	private String fee_status;
	private String pay_status;
	private String xun_deal_person;
	
	//熏蒸计划报文（补充项）
	private String dec_user_name;
	private String dec_org;
	private String goods_values;
	private String ccy_name;
	
	private String pay_money;
	private String pay_mtd;
	private String pay_date;
	
	private String assign_person;//派工人员
	private String pay_clct;//收费人员
	private String xun_insp_person;
	
	private String insp_org_name;//ECIQ报检局
	
	private String consignee_cname;//收货人中文
	
	private String mobile_phone;//手机
	
	private String decl_date;//报检时间
	
	private String insp_dept_name;//报检科室
	
	
	private String hs_code;
	
	private String fb_deal_way       ;
	private String fb_deal_medic     ;
	private String fb_deal_medic_num ;
	private String fb_xun_time       ;
	private String fb_operator       ;
	private String fb_deal_place     ;
	private String fb_deal_start     ;
	private String fb_deal_end       ;
	private String fb_temp           ;
	private String fb_hubility       ;
	private String fb_wind           ;
	private String fb_chk_rst        ;
	private String fb_deal_dosage    ;
	private String fb_dilution       ;
	
    private String fb_duration       ;
    private String fb_auditor        ;
	
	
	
	
	public String getFb_duration() {
		return fb_duration;
	}
	public void setFb_duration(String fb_duration) {
		this.fb_duration = fb_duration;
	}
	public String getFb_auditor() {
		return fb_auditor;
	}
	public void setFb_auditor(String fb_auditor) {
		this.fb_auditor = fb_auditor;
	}
	public String getFb_deal_dosage() {
		return fb_deal_dosage;
	}
	public void setFb_deal_dosage(String fb_deal_dosage) {
		this.fb_deal_dosage = fb_deal_dosage;
	}
	public String getFb_dilution() {
		return fb_dilution;
	}
	public void setFb_dilution(String fb_dilution) {
		this.fb_dilution = fb_dilution;
	}
	public String getFb_deal_way() {
		return fb_deal_way;
	}
	public void setFb_deal_way(String fb_deal_way) {
		this.fb_deal_way = fb_deal_way;
	}
	public String getFb_deal_medic() {
		return fb_deal_medic;
	}
	public void setFb_deal_medic(String fb_deal_medic) {
		this.fb_deal_medic = fb_deal_medic;
	}
	public String getFb_deal_medic_num() {
		return fb_deal_medic_num;
	}
	public void setFb_deal_medic_num(String fb_deal_medic_num) {
		this.fb_deal_medic_num = fb_deal_medic_num;
	}
	public String getFb_xun_time() {
		return fb_xun_time;
	}
	public void setFb_xun_time(String fb_xun_time) {
		this.fb_xun_time = fb_xun_time;
	}
	public String getFb_operator() {
		return fb_operator;
	}
	public void setFb_operator(String fb_operator) {
		this.fb_operator = fb_operator;
	}
	public String getFb_deal_place() {
		return fb_deal_place;
	}
	public void setFb_deal_place(String fb_deal_place) {
		this.fb_deal_place = fb_deal_place;
	}
	public String getFb_deal_start() {
		return fb_deal_start;
	}
	public void setFb_deal_start(String fb_deal_start) {
		this.fb_deal_start = fb_deal_start;
	}
	public String getFb_deal_end() {
		return fb_deal_end;
	}
	public void setFb_deal_end(String fb_deal_end) {
		this.fb_deal_end = fb_deal_end;
	}
	public String getFb_temp() {
		return fb_temp;
	}
	public void setFb_temp(String fb_temp) {
		this.fb_temp = fb_temp;
	}
	public String getFb_hubility() {
		return fb_hubility;
	}
	public void setFb_hubility(String fb_hubility) {
		this.fb_hubility = fb_hubility;
	}
	public String getFb_wind() {
		return fb_wind;
	}
	public void setFb_wind(String fb_wind) {
		this.fb_wind = fb_wind;
	}
	public String getFb_chk_rst() {
		return fb_chk_rst;
	}
	public void setFb_chk_rst(String fb_chk_rst) {
		this.fb_chk_rst = fb_chk_rst;
	}
	public String getHs_code() {
		return hs_code;
	}
	public void setHs_code(String hs_code) {
		this.hs_code = hs_code;
	}
	public String getDecl_date() {
		return decl_date;
	}
	public void setDecl_date(String decl_date) {
		this.decl_date = decl_date;
	}
	public String getInsp_dept_name() {
		return insp_dept_name;
	}
	public void setInsp_dept_name(String insp_dept_name) {
		this.insp_dept_name = insp_dept_name;
	}
	public String getXun_audit_status() {
		return xun_audit_status;
	}
	public void setXun_audit_status(String xun_audit_status) {
		this.xun_audit_status = xun_audit_status;
	}
	public String getXun_audit_person() {
		return xun_audit_person;
	}
	public void setXun_audit_person(String xun_audit_person) {
		this.xun_audit_person = xun_audit_person;
	}
	public String getXun_audit_date() {
		return xun_audit_date;
	}
	public void setXun_audit_date(String xun_audit_date) {
		this.xun_audit_date = xun_audit_date;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getReceiver() {
		return receiver;
	}
	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	public String getConnector() {
		return connector;
	}
	public void setConnector(String connector) {
		this.connector = connector;
	}
	public String getDec_ent_name() {
		return dec_ent_name;
	}
	public void setDec_ent_name(String dec_ent_name) {
		this.dec_ent_name = dec_ent_name;
	}
	public String getWork_start() {
		return work_start;
	}
	public void setWork_start(String work_start) {
		this.work_start = work_start;
	}
	public String getWork_end() {
		return work_end;
	}
	public void setWork_end(String work_end) {
		this.work_end = work_end;
	}
	public String getVolumn() {
		return volumn;
	}
	public void setVolumn(String volumn) {
		this.volumn = volumn;
	}
	public String getToal_medic() {
		return toal_medic;
	}
	public void setToal_medic(String toal_medic) {
		this.toal_medic = toal_medic;
	}
	public String getPotency() {
		return potency;
	}
	public void setPotency(String potency) {
		this.potency = potency;
	}
	public String getMobile_phone() {
		return mobile_phone;
	}
	public void setMobile_phone(String mobile_phone) {
		this.mobile_phone = mobile_phone;
	}
	public String getConsignee_cname() {
		return consignee_cname;
	}
	public void setConsignee_cname(String consignee_cname) {
		this.consignee_cname = consignee_cname;
	}
	public String getInsp_org_name() {
		return insp_org_name;
	}
	public void setInsp_org_name(String insp_org_name) {
		this.insp_org_name = insp_org_name;
	}
	public String getXun_insp_person() {
		return xun_insp_person;
	}
	public void setXun_insp_person(String xun_insp_person) {
		this.xun_insp_person = xun_insp_person;
	}
	public String getPay_clct() {
		return pay_clct;
	}
	public void setPay_clct(String pay_clct) {
		this.pay_clct = pay_clct;
	}
	public String getPay_date() {
		return pay_date;
	}
	public void setPay_date(String pay_date) {
		this.pay_date = pay_date;
	}
	public String getAssign_person() {
		return assign_person;
	}
	public void setAssign_person(String assign_person) {
		this.assign_person = assign_person;
	}
	public String getAssign_date() {
		return assign_date;
	}
	public void setAssign_date(String assign_date) {
		this.assign_date = assign_date;
	}
	public String getPay_mtd() {
		return pay_mtd;
	}
	public void setPay_mtd(String pay_mtd) {
		this.pay_mtd = pay_mtd;
	}
	public String getPay_money() {
		return pay_money;
	}
	public void setPay_money(String pay_money) {
		this.pay_money = pay_money;
	}
	public String getAssign_status() {
		return assign_status;
	}
	public void setAssign_status(String assign_status) {
		this.assign_status = assign_status;
	}
	public String getFee_status() {
		return fee_status;
	}
	public void setFee_status(String fee_status) {
		this.fee_status = fee_status;
	}
	public String getPay_status() {
		return pay_status;
	}
	public void setPay_status(String pay_status) {
		this.pay_status = pay_status;
	}
	public String getXun_deal_person() {
		return xun_deal_person;
	}
	public void setXun_deal_person(String xun_deal_person) {
		this.xun_deal_person = xun_deal_person;
	}
	public String getConta_mode20() {
		return conta_mode20;
	}
	public void setConta_mode20(String conta_mode20) {
		this.conta_mode20 = conta_mode20;
	}
	public String getConta_mode40() {
		return conta_mode40;
	}
	public void setConta_mode40(String conta_mode40) {
		this.conta_mode40 = conta_mode40;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getBill_no() {
		return bill_no;
	}
	public void setBill_no(String bill_no) {
		this.bill_no = bill_no;
	}
	
	public String getCiq_check_user() {
		return ciq_check_user;
	}
	public void setCiq_check_user(String ciq_check_user) {
		this.ciq_check_user = ciq_check_user;
	}
	public String getConta_id() {
		return conta_id;
	}
	public void setConta_id(String conta_id) {
		this.conta_id = conta_id;
	}
	public String getCreate_time() {
		return create_time;
	}
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}
	public String getDeal_medic() {
		return deal_medic;
	}
	public void setDeal_medic(String deal_medic) {
		this.deal_medic = deal_medic;
	}
	public String getDeal_meth() {
		return deal_meth;
	}
	public void setDeal_meth(String deal_meth) {
		this.deal_meth = deal_meth;
	}
	public String getDeal_rsn() {
		return deal_rsn;
	}
	public void setDeal_rsn(String deal_rsn) {
		this.deal_rsn = deal_rsn;
	}
	public String getDosage() {
		return dosage;
	}
	public void setDosage(String dosage) {
		this.dosage = dosage;
	}
	public String getDuration() {
		return duration;
	}
	public void setDuration(String duration) {
		this.duration = duration;
	}
	public String getFee() {
		return fee;
	}
	public void setFee(String fee) {
		this.fee = fee;
	}
	public String getFee_clct() {
		return fee_clct;
	}
	public void setFee_clct(String fee_clct) {
		this.fee_clct = fee_clct;
	}
	public String getO_tmprtu() {
		return o_tmprtu;
	}
	public void setO_tmprtu(String o_tmprtu) {
		this.o_tmprtu = o_tmprtu;
	}
	public String getPort_dept_code() {
		return port_dept_code;
	}
	public void setPort_dept_code(String port_dept_code) {
		this.port_dept_code = port_dept_code;
	}
	public String getPort_org_code() {
		return port_org_code;
	}
	public void setPort_org_code(String port_org_code) {
		this.port_org_code = port_org_code;
	}
	public String getShip_name_en() {
		return ship_name_en;
	}
	public void setShip_name_en(String ship_name_en) {
		this.ship_name_en = ship_name_en;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getTechno_rqst() {
		return techno_rqst;
	}
	public void setTechno_rqst(String techno_rqst) {
		this.techno_rqst = techno_rqst;
	}
	public String getVoyage_no() {
		return voyage_no;
	}
	public void setVoyage_no(String voyage_no) {
		this.voyage_no = voyage_no;
	}
	public String getXun_check_rst() {
		return xun_check_rst;
	}
	public void setXun_check_rst(String xun_check_rst) {
		this.xun_check_rst = xun_check_rst;
	}
	public String getXun_check_time() {
		return xun_check_time;
	}
	public void setXun_check_time(String xun_check_time) {
		this.xun_check_time = xun_check_time;
	}
	public String getXun_id() {
		return xun_id;
	}
	public void setXun_id(String xun_id) {
		this.xun_id = xun_id;
	}
	public String getXun_org() {
		return xun_org;
	}
	public void setXun_org(String xun_org) {
		this.xun_org = xun_org;
	}
	public String getXun_user() {
		return xun_user;
	}
	public void setXun_user(String xun_user) {
		this.xun_user = xun_user;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getConta_no() {
		return conta_no;
	}
	public void setConta_no(String conta_no) {
		this.conta_no = conta_no;
	}
	public String getXun_time() {
		return xun_time;
	}
	public void setXun_time(String xun_time) {
		this.xun_time = xun_time;
	}
	public String getCiq_check_user_nm() {
		return ciq_check_user_nm;
	}
	public void setCiq_check_user_nm(String ciq_check_user_nm) {
		this.ciq_check_user_nm = ciq_check_user_nm;
	}
	public String getDeal_medic_cn() {
		return deal_medic_cn;
	}
	public void setDeal_medic_cn(String deal_medic_cn) {
		this.deal_medic_cn = deal_medic_cn;
	}
	public String getXun_org_nm() {
		return xun_org_nm;
	}
	public void setXun_org_nm(String xun_org_nm) {
		this.xun_org_nm = xun_org_nm;
	}
	public String getXun_user_nm() {
		return xun_user_nm;
	}
	public void setXun_user_nm(String xun_user_nm) {
		this.xun_user_nm = xun_user_nm;
	}
	public String getDeal_date() {
		return deal_date;
	}
	public void setDeal_date(String deal_date) {
		this.deal_date = deal_date;
	}
	public String getXun_finish_date() {
		return xun_finish_date;
	}
	public void setXun_finish_date(String xun_finish_date) {
		this.xun_finish_date = xun_finish_date;
	}
	public String getSpread_date() {
		return spread_date;
	}
	public void setSpread_date(String spread_date) {
		this.spread_date = spread_date;
	}
	public String getBook_no() {
		return book_no;
	}
	public void setBook_no(String book_no) {
		this.book_no = book_no;
	}
	public String getDec_org_name() {
		return dec_org_name;
	}
	public void setDec_org_name(String dec_org_name) {
		this.dec_org_name = dec_org_name;
	}
	public String getDec_user() {
		return dec_user;
	}
	public void setDec_user(String dec_user) {
		this.dec_user = dec_user;
	}
	public String getDecl_no() {
		return decl_no;
	}
	public void setDecl_no(String decl_no) {
		this.decl_no = decl_no;
	}
	public String getGoods_cname() {
		return goods_cname;
	}
	public void setGoods_cname(String goods_cname) {
		this.goods_cname = goods_cname;
	}
	public String getLand_area_code() {
		return land_area_code;
	}
	public void setLand_area_code(String land_area_code) {
		this.land_area_code = land_area_code;
	}
	public String getLand_place() {
		return land_place;
	}
	public void setLand_place(String land_place) {
		this.land_place = land_place;
	}
	public String getOrigin_country_name() {
		return origin_country_name;
	}
	public void setOrigin_country_name(String origin_country_name) {
		this.origin_country_name = origin_country_name;
	}
	public String getQty() {
		return qty;
	}
	public void setQty(String qty) {
		this.qty = qty;
	}
	public String getQty_unit_name() {
		return qty_unit_name;
	}
	public void setQty_unit_name(String qty_unit_name) {
		this.qty_unit_name = qty_unit_name;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getWeight() {
		return weight;
	}
	public void setWeight(String weight) {
		this.weight = weight;
	}
	public String getWeight_unit_name() {
		return weight_unit_name;
	}
	public void setWeight_unit_name(String weight_unit_name) {
		this.weight_unit_name = weight_unit_name;
	}
	public String getWood_count() {
		return wood_count;
	}
	public void setWood_count(String wood_count) {
		this.wood_count = wood_count;
	}
	public String getConta_model() {
		return conta_model;
	}
	public void setConta_model(String conta_model) {
		this.conta_model = conta_model;
	}
	public String getGoods_volume() {
		return goods_volume;
	}
	public void setGoods_volume(String goods_volume) {
		this.goods_volume = goods_volume;
	}
	public String getPack_type_name() {
		return pack_type_name;
	}
	public void setPack_type_name(String pack_type_name) {
		this.pack_type_name = pack_type_name;
	}
	public String getCcy_name() {
		return ccy_name;
	}
	public void setCcy_name(String ccy_name) {
		this.ccy_name = ccy_name;
	}
	public String getDec_org() {
		return dec_org;
	}
	public void setDec_org(String dec_org) {
		this.dec_org = dec_org;
	}
	public String getDec_user_name() {
		return dec_user_name;
	}
	public void setDec_user_name(String dec_user_name) {
		this.dec_user_name = dec_user_name;
	}
	public String getGoods_values() {
		return goods_values;
	}
	public void setGoods_values(String goods_values) {
		this.goods_values = goods_values;
	}
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public String getAuditor() {
		return auditor;
	}
	public void setAuditor(String auditor) {
		this.auditor = auditor;
	}
}
