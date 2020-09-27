package com.dpn.ciqqlc.standard.model;

import java.util.Date;

public class IntercepeModel {
	
	private String d_name;
	private String file_name1;
	private String file_name11;
	private String file_name12;
	private String file_name2;
	private String file_name21;
	private String file_name22;
	private String file_name3;
	private String file_name31;
	private String file_name32;
	private String file_name4;
	private String file_name41;
	private String file_name42;
	private String file_name5;
	private String file_name51;
	private String file_name52;
/*	video_file_event*/
	private String proc_main_id;
	/**
	 * 业务单号
	 */
	private String prod_main_id;
	/**
	 * 环节类型
	 */
	private String proc_type;
	/**
	 * 文件类型 1：照片    2：视频       3：音频
	 */
	private String file_type;
	/**
	 * 文件名称
	 */
	private String file_name;
	/**
	 * 当前监管科室代码
	 */
	private String port_dept_code;
	/**
	 * 直属局
	 */
	private String port_zs_org_code;
	/**
	 * 分支机构
	 */
	private String port_org_code;
	/**
	 * 创建人
	 */
	private String create_user;
	/**
	 * 创建时间
	 */
	private Date create_date;

	/*country*/	
	private String cnname;
	
/*qlc_eciq*/
	/**
	 * 业务单号
	 */
	private String qe_decl_no;
	
	/**
	 * 直属局
	 */
	private String port_org;
	/**
	 * 分支机构
	 */
	private String port_org_under;
	/**
	 * 物品类别
	 */
	private String goods_type;
	/**
	 * 品名（如果有多个则累加显示）
	 */
	private String goods_item_name;
	/**
	 * 物品编号
	 */
	private String goods_no;
	
	/**
	 * 截获日期
	 */
	private Date intercept_date;
	/**
	 * 寄件国/地区
	 */
	private String send_country;
	/**
	 * 物品数量
	 */
	private double goods_qty;
	/**
	 * 物品重量
	 */
	private double goods_wt;
	/**
	 * 处理状态
	 */
	private String deal_stu;
	/**
	 * 处理方式
	 */
	private String qe_deal_type;
	/**
	 * 入境口岸
	 */
	private String entry_port;
	/**
	 * 寄件人姓名
	 */
	private String sender_name;
	/**
	 * 寄件人电话
	 */
	private String send_tel;
	/**
	 * 寄件人地址
	 */
	private String sender_addr;
	/**
	 * 截获物来源地
	 */
    /*qcu*/
	/**
	 * 护照号码
	 */
	private String id;
	private String card_no;
	/**
	 * 姓名
	 */
	private String name;
	/**
	 * 性别
	 */
	private String sex;
	/**
	 * 出生日期
	 */
	private Date birth;
	/**
	 * 国家、地区
	 */
	private String nation;
	/**
	 * 地址
	 */
	private String live_plc;
	/**
	 * 证件照片
	 */
	private String card_pic;
	/**
	 * 检疫记录编号
	 */
	private String chk_rcd_no;
	/**
	 * 检疫官
	 */
	private String insp_opr;
	/**
	 * 交通工具号
	 */
	private String tra_tool_no;
	/**
	 * 登记日期
	 */
	private Date reg_date;
	/**
	 * 物品种类
	 */
	private String cag_type;
	/**
	 * 禁止进境物
	 */
	private String prhb_enter;
	/**
	 * 品名
	 */
	private String cag_name;
	/**
	 * 不合格原因
	 */
	private String unqf_rsn;
	/**
	 * 数量及单位
	 */
	private String num_unit;
	/**
	 * 重量及单位
	 */
	private String weight_unit;
	/**
	 * 是否送样
	 */
	private String is_samp;
	/**
	 * 收样部门
	 */
	private String rsv_samp_dpt;
	/**
	 * 检疫项目
	 */
	private String check_item;
	/**
	 * 来自地
	 */
	private String from_plc;
	/**
	 * 截获方式
	 */
	private String its_type;
	/**
	 * 物品照片
	 */
	private String cag_pic;
	/**
	 * 凭证编号
	 */
	private String voc_no;
	/**
	 * 处理说明
	 */
	private String deal_disc;
	/**
	 * 在华联系地址
	 */
	private String plc_cn;
	/**
	 * 在华联系电话
	 */
	private Integer plc_tel;
	/**
	 * 处置日期
	 */
	private String deal_date;
	/**
	 * 用途
	 */
	private String use_to;
	/**
	 * 截获流水号
	 */
	private String its_no;
	/**
	 * 处理方式
	 */
	private String deal_type;
	/**
	 * 备注
	 */
	private String rmk;
	
/*yiqing*/
	/**
	 * 业务单号
	 */
	private String decl_no;
	/**
	 * 分类
	 */
	private String type_kind;
	/**
	 * 状态
	 */
	private String status;
	/**
	 * 填报机构
	 */
	private String dec_org;
	/**
	 * ciq代码
	 */
	private String ciq_code;
	/**
	 * 货物名称
	 */
	private String yiqing_cag_name;
	/**
	 * 原产地
	 */
	private String ori_plc;
	/**
	 * 输出地
	 */
	private String exp_plc;
	/**
	 * 入境口岸
	 */
	private String enter_port;
	/**
	 * 入境日期
	 */
	private String enter_date;
	/**
	 * 填写日期
	 */
	private Date dec_date;
	/**
	 * 上报日期
	 */
	private String smt_date;
	/**
	 * 违规情况
	 */
	private String brk_law_cas;
	/**
	 * 处理措施
	 */
	private String deal_meth;
	/**
	 * 备注
	 */
	private String yiqing_rmk;
	
/*移动快检上传 video_file_event*/
	
	/**
	 * 业务主键
	 */
	private String procmainid;
	/**
	 * 环节类型
	 */
	private String proctype;
	/**
	 * 文件类型 1：照片    2：视频       3：音频
	 */
	private String filetype;
	/**
	 * 文件名称
	 */
	private String filename;
	/**
	 * 当前监管科室代码
	 */
	private String portdeptcode;
	/**
	 * 监管口岸局代码
	 */
	private String portorgcode;
	/**
	 * 创建人
	 */
	private String fe_createuser;
	/**
	 * 创建时间
	 */
	private Date fe_createdate;
	
	private String yjw_status;
	
	private String bldw_status;
	
	public String getYjw_status() {
		return yjw_status;
	}
	public void setYjw_status(String yjw_status) {
		this.yjw_status = yjw_status;
	}
	public String getBldw_status() {
		return bldw_status;
	}
	public void setBldw_status(String bldw_status) {
		this.bldw_status = bldw_status;
	}
	public String getCnname() {
		return cnname;
	}
	public void setCnname(String cnname) {
		this.cnname = cnname;
	}
	public String getQe_decl_no() {
		return qe_decl_no;
	}
	public void setQe_decl_no(String qe_decl_no) {
		this.qe_decl_no = qe_decl_no;
	}
	public String getPort_org() {
		return port_org;
	}
	public void setPort_org(String port_org) {
		this.port_org = port_org;
	}
	public String getPort_org_under() {
		return port_org_under;
	}
	public void setPort_org_under(String port_org_under) {
		this.port_org_under = port_org_under;
	}
	public String getGoods_type() {
		return goods_type;
	}
	public void setGoods_type(String goods_type) {
		this.goods_type = goods_type;
	}
	public String getGoods_item_name() {
		return goods_item_name;
	}
	public void setGoods_item_name(String goods_item_name) {
		this.goods_item_name = goods_item_name;
	}
	public String getGoods_no() {
		return goods_no;
	}
	public void setGoods_no(String goods_no) {
		this.goods_no = goods_no;
	}
	public Date getIntercept_date() {
		return intercept_date;
	}
	public void setIntercept_date(Date intercept_date) {
		this.intercept_date = intercept_date;
	}
	public String getSend_country() {
		return send_country;
	}
	public void setSend_country(String send_country) {
		this.send_country = send_country;
	}
	public double getGoods_qty() {
		return goods_qty;
	}
	public void setGoods_qty(double goods_qty) {
		this.goods_qty = goods_qty;
	}
	public double getGoods_wt() {
		return goods_wt;
	}
	public void setGoods_wt(double goods_wt) {
		this.goods_wt = goods_wt;
	}
	public String getDeal_stu() {
		return deal_stu;
	}
	public void setDeal_stu(String deal_stu) {
		this.deal_stu = deal_stu;
	}
	public String getQe_deal_type() {
		return qe_deal_type;
	}
	public void setQe_deal_type(String qe_deal_type) {
		this.qe_deal_type = qe_deal_type;
	}
	public String getEntry_port() {
		return entry_port;
	}
	public void setEntry_port(String entry_port) {
		this.entry_port = entry_port;
	}
	public String getSender_name() {
		return sender_name;
	}
	public void setSender_name(String sender_name) {
		this.sender_name = sender_name;
	}
	public String getSend_tel() {
		return send_tel;
	}
	public void setSend_tel(String send_tel) {
		this.send_tel = send_tel;
	}
	public String getSender_addr() {
		return sender_addr;
	}
	public void setSender_addr(String sender_addr) {
		this.sender_addr = sender_addr;
	}

	public String getCard_no() {
		return card_no;
	}
	public void setCard_no(String card_no) {
		this.card_no = card_no;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	public Date getBirth() {
		return birth;
	}
	public void setBirth(Date birth) {
		this.birth = birth;
	}
	public String getNation() {
		return nation;
	}
	public void setNation(String nation) {
		this.nation = nation;
	}
	public String getLive_plc() {
		return live_plc;
	}
	public void setLive_plc(String live_plc) {
		this.live_plc = live_plc;
	}
	public String getCard_pic() {
		return card_pic;
	}
	public void setCard_pic(String card_pic) {
		this.card_pic = card_pic;
	}
	public String getChk_rcd_no() {
		return chk_rcd_no;
	}
	public void setChk_rcd_no(String chk_rcd_no) {
		this.chk_rcd_no = chk_rcd_no;
	}
	public String getInsp_opr() {
		return insp_opr;
	}
	public void setInsp_opr(String insp_opr) {
		this.insp_opr = insp_opr;
	}
	public String getTra_tool_no() {
		return tra_tool_no;
	}
	public void setTra_tool_no(String tra_tool_no) {
		this.tra_tool_no = tra_tool_no;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}
	public String getCag_type() {
		return cag_type;
	}
	public void setCag_type(String cag_type) {
		this.cag_type = cag_type;
	}
	public String getPrhb_enter() {
		return prhb_enter;
	}
	public void setPrhb_enter(String prhb_enter) {
		this.prhb_enter = prhb_enter;
	}
	public String getCag_name() {
		return cag_name;
	}
	public void setCag_name(String cag_name) {
		this.cag_name = cag_name;
	}
	public String getUnqf_rsn() {
		return unqf_rsn;
	}
	public void setUnqf_rsn(String unqf_rsn) {
		this.unqf_rsn = unqf_rsn;
	}
	public String getNum_unit() {
		return num_unit;
	}
	public void setNum_unit(String num_unit) {
		this.num_unit = num_unit;
	}
	public String getWeight_unit() {
		return weight_unit;
	}
	public void setWeight_unit(String weight_unit) {
		this.weight_unit = weight_unit;
	}
	public String getIs_samp() {
		return is_samp;
	}
	public void setIs_samp(String is_samp) {
		this.is_samp = is_samp;
	}
	public String getRsv_samp_dpt() {
		return rsv_samp_dpt;
	}
	public void setRsv_samp_dpt(String rsv_samp_dpt) {
		this.rsv_samp_dpt = rsv_samp_dpt;
	}
	public String getCheck_item() {
		return check_item;
	}
	public void setCheck_item(String check_item) {
		this.check_item = check_item;
	}
	public String getFrom_plc() {
		return from_plc;
	}
	public void setFrom_plc(String from_plc) {
		this.from_plc = from_plc;
	}
	public String getIts_type() {
		return its_type;
	}
	public void setIts_type(String its_type) {
		this.its_type = its_type;
	}
	public String getCag_pic() {
		return cag_pic;
	}
	public void setCag_pic(String cag_pic) {
		this.cag_pic = cag_pic;
	}
	public String getVoc_no() {
		return voc_no;
	}
	public void setVoc_no(String voc_no) {
		this.voc_no = voc_no;
	}
	public String getDeal_disc() {
		return deal_disc;
	}
	public void setDeal_disc(String deal_disc) {
		this.deal_disc = deal_disc;
	}
	public String getPlc_cn() {
		return plc_cn;
	}
	public void setPlc_cn(String plc_cn) {
		this.plc_cn = plc_cn;
	}
	public String getDeal_date() {
		return deal_date;
	}
	public void setDeal_date(String deal_date) {
		this.deal_date = deal_date;
	}
	public String getUse_to() {
		return use_to;
	}
	public void setUse_to(String use_to) {
		this.use_to = use_to;
	}
	public String getIts_no() {
		return its_no;
	}
	public void setIts_no(String its_no) {
		this.its_no = its_no;
	}
	public String getDeal_type() {
		return deal_type;
	}
	public void setDeal_type(String deal_type) {
		this.deal_type = deal_type;
	}
	public String getRmk() {
		return rmk;
	}
	public void setRmk(String rmk) {
		this.rmk = rmk;
	}
	public String getDecl_no() {
		return decl_no;
	}
	public void setDecl_no(String decl_no) {
		this.decl_no = decl_no;
	}
	public String getType_kind() {
		return type_kind;
	}
	public void setType_kind(String type_kind) {
		this.type_kind = type_kind;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDec_org() {
		return dec_org;
	}
	public void setDec_org(String dec_org) {
		this.dec_org = dec_org;
	}
	public void setSmt_date(String smt_date) {
		this.smt_date = smt_date;
	}
	public String getCiq_code() {
		return ciq_code;
	}
	public void setCiq_code(String ciq_code) {
		this.ciq_code = ciq_code;
	}
	public String getYiqing_cag_name() {
		return yiqing_cag_name;
	}
	public void setYiqing_cag_name(String yiqing_cag_name) {
		this.yiqing_cag_name = yiqing_cag_name;
	}
	public String getOri_plc() {
		return ori_plc;
	}
	public void setOri_plc(String ori_plc) {
		this.ori_plc = ori_plc;
	}
	public String getExp_plc() {
		return exp_plc;
	}
	public void setExp_plc(String exp_plc) {
		this.exp_plc = exp_plc;
	}
	public String getEnter_port() {
		return enter_port;
	}
	public void setEnter_port(String enter_port) {
		this.enter_port = enter_port;
	}
	public String getEnter_date() {
		return enter_date;
	}
	public void setEnter_date(String enter_date) {
		this.enter_date = enter_date;
	}
	public Date getDec_date() {
		return dec_date;
	}
	public void setDec_date(Date dec_date) {
		this.dec_date = dec_date;
	}
	public String getBrk_law_cas() {
		return brk_law_cas;
	}
	public void setBrk_law_cas(String brk_law_cas) {
		this.brk_law_cas = brk_law_cas;
	}
	public String getDeal_meth() {
		return deal_meth;
	}
	public void setDeal_meth(String deal_meth) {
		this.deal_meth = deal_meth;
	}
	public String getYiqing_rmk() {
		return yiqing_rmk;
	}
	public void setYiqing_rmk(String yiqing_rmk) {
		this.yiqing_rmk = yiqing_rmk;
	}
	public String getProcmainid() {
		return procmainid;
	}
	public void setProcmainid(String procmainid) {
		this.procmainid = procmainid;
	}
	public String getProctype() {
		return proctype;
	}
	public void setProctype(String proctype) {
		this.proctype = proctype;
	}
	public String getFiletype() {
		return filetype;
	}
	public void setFiletype(String filetype) {
		this.filetype = filetype;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getPortdeptcode() {
		return portdeptcode;
	}
	public void setPortdeptcode(String portdeptcode) {
		this.portdeptcode = portdeptcode;
	}
	public String getPortorgcode() {
		return portorgcode;
	}
	public void setPortorgcode(String portorgcode) {
		this.portorgcode = portorgcode;
	}
	public String getFe_createuser() {
		return fe_createuser;
	}
	public void setFe_createuser(String fe_createuser) {
		this.fe_createuser = fe_createuser;
	}
	public Date getFe_createdate() {
		return fe_createdate;
	}
	public void setFe_createdate(Date fe_createdate) {
		this.fe_createdate = fe_createdate;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getD_name() {
		return d_name;
	}
	public void setD_name(String d_name) {
		this.d_name = d_name;
	}
	public String getSmt_date() {
		return smt_date;
	}
	public Integer getPlc_tel() {
		return plc_tel;
	}
	public void setPlc_tel(Integer plc_tel) {
		this.plc_tel = plc_tel;
	}
	public String getProc_main_id() {
		return proc_main_id;
	}
	public void setProc_main_id(String proc_main_id) {
		this.proc_main_id = proc_main_id;
	}
	public String getProc_type() {
		return proc_type;
	}
	public void setProc_type(String proc_type) {
		this.proc_type = proc_type;
	}
	public String getFile_type() {
		return file_type;
	}
	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
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
	public String getCreate_user() {
		return create_user;
	}
	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public String getFile_name1() {
		return file_name1;
	}
	public void setFile_name1(String file_name1) {
		this.file_name1 = file_name1;
	}
	public String getFile_name11() {
		return file_name11;
	}
	public void setFile_name11(String file_name11) {
		this.file_name11 = file_name11;
	}
	public String getFile_name12() {
		return file_name12;
	}
	public void setFile_name12(String file_name12) {
		this.file_name12 = file_name12;
	}
	public String getFile_name2() {
		return file_name2;
	}
	public void setFile_name2(String file_name2) {
		this.file_name2 = file_name2;
	}
	public String getFile_name21() {
		return file_name21;
	}
	public void setFile_name21(String file_name21) {
		this.file_name21 = file_name21;
	}
	public String getFile_name22() {
		return file_name22;
	}
	public void setFile_name22(String file_name22) {
		this.file_name22 = file_name22;
	}
	public String getFile_name3() {
		return file_name3;
	}
	public void setFile_name3(String file_name3) {
		this.file_name3 = file_name3;
	}
	public String getFile_name31() {
		return file_name31;
	}
	public void setFile_name31(String file_name31) {
		this.file_name31 = file_name31;
	}
	public String getFile_name32() {
		return file_name32;
	}
	public void setFile_name32(String file_name32) {
		this.file_name32 = file_name32;
	}
	public String getFile_name4() {
		return file_name4;
	}
	public void setFile_name4(String file_name4) {
		this.file_name4 = file_name4;
	}
	public String getFile_name41() {
		return file_name41;
	}
	public void setFile_name41(String file_name41) {
		this.file_name41 = file_name41;
	}
	public String getFile_name42() {
		return file_name42;
	}
	public void setFile_name42(String file_name42) {
		this.file_name42 = file_name42;
	}
	public String getFile_name5() {
		return file_name5;
	}
	public void setFile_name5(String file_name5) {
		this.file_name5 = file_name5;
	}
	public String getFile_name51() {
		return file_name51;
	}
	public void setFile_name51(String file_name51) {
		this.file_name51 = file_name51;
	}
	public String getFile_name52() {
		return file_name52;
	}
	public void setFile_name52(String file_name52) {
		this.file_name52 = file_name52;
	}	
	private String key;

	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getPort_zs_org_code() {
		return port_zs_org_code;
	}
	public void setPort_zs_org_code(String port_zs_org_code) {
		this.port_zs_org_code = port_zs_org_code;
	}
	public String getProd_main_id() {
		return prod_main_id;
	}
	public void setProd_main_id(String prod_main_id) {
		this.prod_main_id = prod_main_id;
	}
	
}
