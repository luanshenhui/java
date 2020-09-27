package com.dpn.ciqqlc.standard.model;

import java.util.Date;

/**
 * 申请信息表
 * @author Administrator
 *
 */
public class EfpeApplyDTO {
	
	private String applyid;//申请ID
	
	private String internalauditor;//企业内审员
	
	private Date startdate;//申请时间
	
	private String factoryname;//本次备案厂区及库间简称
	
	private String fullname;//生产企业地址
	
	private String accpetorgname;//备案受理机构
	
	private String headName;//法人或授权负责人
	
	private String email;//email
	
	private String zipcode;//邮编
	
	private String contactname;//联系人
	
	private String movetel;//联系人电话
	
	private String blno;//营业执照编号
	
	private Date bldate;//营业执照成立日期
	
	private String orgcode;//组织机构代码
	
	private Number factoryarea;//厂区面积
	
	private Date cfdate;//建厂时间
	
	private Date lccfdate;//最后改扩建时间
	
	private String lccfcontent;//最后改扩建内容
	
	private Number wsarea;//加工车间总面积
	
	private Number awsarea;//本次申请品种的车间面积
	
	private Number coldarea;//冷藏库面积平方米
	
	private Number coldcap;//冷藏库容量 吨
	
	private Number warehosearea;//仓库面积平方米
	
	private Number warehosecap;//仓库容量吨
	
	private Number frozenarea;//速冻库容积平方米
	
	private Number frozencap;//速冻库容量吨
	
	private Number frozenabi;//速冻机能力吨 / 时
	
	private String mahead;//总负责人
	
	private String prohead;//生产负责人
	
	private String quahead;//质量管理负责人
	
	private Number mano;//总人数
	
	private Number prono;//生产人员数
	
	private Number quano;//质量管理人员数
	
	private Date haccpdate;//HACCP实施时间
	
	private String haccptemnames;//HACCP小组成员
	
	private String foodsafetysit;//食品安全卫生控制体系运行状况
	
	private String aptitudesit;//企业实验室获得资质认定的情况
	
	private String recordcode;//备案号
	
	private String applytype;//申请类型
	
	private String orgname;//机构名称
	
	/*************** 监管表字段 begin ***************/
	private String subid;//监管ID
	
	private String subname;//监管人员
	
	private String plantype;//监管类型

	private String plansupdate;//计划监管时间
	
	private String pesponsible;//监管负责人
	
	private Date actualdate;//实际监管时间
	
	private String practicename;//实际监管人
	
	private String liveresult;//现场检查结果
	/*************** 监管表字段   end  ***************/
	
	/*************** 流程表字段 begin ***************/
	private String applycode;
	/*************** 流程表字段 begin ***************/
	
	
	/**************  temp begin **********************/
	private String is_break_law;
	private String monitor_type;
	private String addr;
	private String moni_man_por;
	private String moni_psn;
	private String act_monit_por;
	private String attach_file;
	private String prod_comp;
	private String reg_comp_plc;
	private String comp_plc;
	private String enter_accp;
	private String legal_psn;
	private String e_mail;
	private String post_no;
	private String con_name;
	private String con_tel;
	private String buness_licen;
	/**************  temp end **********************/
	
	public String getSubid() {
		return subid;
	}

	public void setSubid(String subid) {
		this.subid = subid;
	}

	public String getSubname() {
		return subname;
	}

	public void setSubname(String subname) {
		this.subname = subname;
	}

	public String getPlantype() {
		return plantype;
	}

	public void setPlantype(String plantype) {
		this.plantype = plantype;
	}

	public String getPlansupdate() {
		return plansupdate;
	}

	public void setPlansupdate(String plansupdate) {
		this.plansupdate = plansupdate;
	}

	public String getPesponsible() {
		return pesponsible;
	}

	public void setPesponsible(String pesponsible) {
		this.pesponsible = pesponsible;
	}

	public Date getActualdate() {
		return actualdate;
	}

	public void setActualdate(Date actualdate) {
		this.actualdate = actualdate;
	}

	public String getPracticename() {
		return practicename;
	}

	public void setPracticename(String practicename) {
		this.practicename = practicename;
	}

	public String getLiveresult() {
		return liveresult;
	}

	public void setLiveresult(String liveresult) {
		this.liveresult = liveresult;
	}

	public String getApplyid() {
		return applyid;
	}

	public void setApplyid(String applyid) {
		this.applyid = applyid;
	}

	public String getInternalauditor() {
		return internalauditor;
	}

	public void setInternalauditor(String internalauditor) {
		this.internalauditor = internalauditor;
	}

	public Date getStartdate() {
		return startdate;
	}

	public void setStartdate(Date startdate) {
		this.startdate = startdate;
	}

	public String getFactoryname() {
		return factoryname;
	}

	public void setFactoryname(String factoryname) {
		this.factoryname = factoryname;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}

	public String getAccpetorgname() {
		return accpetorgname;
	}

	public void setAccpetorgname(String accpetorgname) {
		this.accpetorgname = accpetorgname;
	}

	public String getHeadName() {
		return headName;
	}

	public void setHeadName(String headName) {
		this.headName = headName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getZipcode() {
		return zipcode;
	}

	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}

	public String getContactname() {
		return contactname;
	}

	public void setContactname(String contactname) {
		this.contactname = contactname;
	}

	public String getMovetel() {
		return movetel;
	}

	public void setMovetel(String movetel) {
		this.movetel = movetel;
	}

	public String getBlno() {
		return blno;
	}

	public void setBlno(String blno) {
		this.blno = blno;
	}

	public Date getBldate() {
		return bldate;
	}

	public void setBldate(Date bldate) {
		this.bldate = bldate;
	}

	public String getOrgcode() {
		return orgcode;
	}

	public void setOrgcode(String orgcode) {
		this.orgcode = orgcode;
	}

	public Number getFactoryarea() {
		return factoryarea;
	}

	public void setFactoryarea(Number factoryarea) {
		this.factoryarea = factoryarea;
	}

	public Date getCfdate() {
		return cfdate;
	}

	public void setCfdate(Date cfdate) {
		this.cfdate = cfdate;
	}

	public Date getLccfdate() {
		return lccfdate;
	}

	public void setLccfdate(Date lccfdate) {
		this.lccfdate = lccfdate;
	}

	public String getLccfcontent() {
		return lccfcontent;
	}

	public void setLccfcontent(String lccfcontent) {
		this.lccfcontent = lccfcontent;
	}

	public Number getWsarea() {
		return wsarea;
	}

	public void setWsarea(Number wsarea) {
		this.wsarea = wsarea;
	}

	public Number getAwsarea() {
		return awsarea;
	}

	public void setAwsarea(Number awsarea) {
		this.awsarea = awsarea;
	}

	public Number getColdarea() {
		return coldarea;
	}

	public void setColdarea(Number coldarea) {
		this.coldarea = coldarea;
	}

	public Number getColdcap() {
		return coldcap;
	}

	public void setColdcap(Number coldcap) {
		this.coldcap = coldcap;
	}

	public Number getWarehosearea() {
		return warehosearea;
	}

	public void setWarehosearea(Number warehosearea) {
		this.warehosearea = warehosearea;
	}

	public Number getWarehosecap() {
		return warehosecap;
	}

	public void setWarehosecap(Number warehosecap) {
		this.warehosecap = warehosecap;
	}

	public Number getFrozenarea() {
		return frozenarea;
	}

	public void setFrozenarea(Number frozenarea) {
		this.frozenarea = frozenarea;
	}

	public Number getFrozencap() {
		return frozencap;
	}

	public void setFrozencap(Number frozencap) {
		this.frozencap = frozencap;
	}

	public Number getFrozenabi() {
		return frozenabi;
	}

	public void setFrozenabi(Number frozenabi) {
		this.frozenabi = frozenabi;
	}

	public String getMahead() {
		return mahead;
	}

	public void setMahead(String mahead) {
		this.mahead = mahead;
	}

	public String getProhead() {
		return prohead;
	}

	public void setProhead(String prohead) {
		this.prohead = prohead;
	}

	public String getQuahead() {
		return quahead;
	}

	public void setQuahead(String quahead) {
		this.quahead = quahead;
	}

	public Number getMano() {
		return mano;
	}

	public void setMano(Number mano) {
		this.mano = mano;
	}

	public Number getProno() {
		return prono;
	}

	public void setProno(Number prono) {
		this.prono = prono;
	}

	public Number getQuano() {
		return quano;
	}

	public void setQuano(Number quano) {
		this.quano = quano;
	}

	public Date getHaccpdate() {
		return haccpdate;
	}

	public void setHaccpdate(Date haccpdate) {
		this.haccpdate = haccpdate;
	}

	public String getHaccptemnames() {
		return haccptemnames;
	}

	public void setHaccptemnames(String haccptemnames) {
		this.haccptemnames = haccptemnames;
	}

	public String getFoodsafetysit() {
		return foodsafetysit;
	}

	public void setFoodsafetysit(String foodsafetysit) {
		this.foodsafetysit = foodsafetysit;
	}

	public String getAptitudesit() {
		return aptitudesit;
	}

	public void setAptitudesit(String aptitudesit) {
		this.aptitudesit = aptitudesit;
	}

	public String getRecordcode() {
		return recordcode;
	}

	public void setRecordcode(String recordcode) {
		this.recordcode = recordcode;
	}

	public String getApplytype() {
		return applytype;
	}

	public void setApplytype(String applytype) {
		this.applytype = applytype;
	}

	public String getOrgname() {
		return orgname;
	}

	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}

	public String getApplycode() {
		return applycode;
	}

	public void setApplycode(String applycode) {
		this.applycode = applycode;
	}

	public String getIs_break_law() {
		return is_break_law;
	}

	public void setIs_break_law(String is_break_law) {
		this.is_break_law = is_break_law;
	}

	public String getMonitor_type() {
		return monitor_type;
	}

	public void setMonitor_type(String monitor_type) {
		this.monitor_type = monitor_type;
	}

	public String getAddr() {
		return addr;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public String getMoni_man_por() {
		return moni_man_por;
	}

	public void setMoni_man_por(String moni_man_por) {
		this.moni_man_por = moni_man_por;
	}

	public String getMoni_psn() {
		return moni_psn;
	}

	public void setMoni_psn(String moni_psn) {
		this.moni_psn = moni_psn;
	}

	public String getAct_monit_por() {
		return act_monit_por;
	}

	public void setAct_monit_por(String act_monit_por) {
		this.act_monit_por = act_monit_por;
	}

	public String getAttach_file() {
		return attach_file;
	}

	public void setAttach_file(String attach_file) {
		this.attach_file = attach_file;
	}

	public String getProd_comp() {
		return prod_comp;
	}

	public void setProd_comp(String prod_comp) {
		this.prod_comp = prod_comp;
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

}
