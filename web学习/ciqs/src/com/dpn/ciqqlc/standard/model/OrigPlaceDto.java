package com.dpn.ciqqlc.standard.model;

import java.util.Date;
import java.util.List;

public class OrigPlaceDto extends PageDto{
	
	private String id;//主键 UUID
	private String main_id;//业务主键
	private String dec_org_name;//企业名称
	private String dec_org_code;//企业组织机构代码
	private String org_reg_no;//企业备案号
	private String dest_country;//最终目的国/地区
	private String transfer_country;//中转国/地区
	private String trade_mode;//贸易方式
	private Date shipping_date;//出运日期
	private String cag_seq;//产品序号（商品列表，一个企业可对应多个商品）
	private String hs_code;//HS编码
	private String cag_name;//商品名称
	private String cag_imp_comp;//产品进口成份
	private String prod_comp;//生产企业/联系人/联系电话
	private String num_weight;//数/重量及单位
	private String fob_val;//FOB值(USD)
	private String consignee_cname;//收货人
	private String cert_no;//证书号
	private String 	receipt_no;//发票号
	private Date 	receipt_date;//发票日期
	private String 	mat_no;//唛头及包装号
	private String 	num_cag_disc;//数量及货物描述
	private String 	pric_item;//价格条款
	private String 	cag_pric;//货物单价及总值
	private String 	spec_item;//特殊条款
	private String 	exp_comp;//出口商
//	private String 	prodComp;//生产商
	private String 	trans_type;//运输方式和路线
	private String 	purpose_country;//目的国家
	private String 	pack_num;//包装数量及种类
	private String 	orig_place_std;//原产地标准
	private String 	m_weight;//毛重、数量等计量方式
	private String 	apply_fob_val;//申请书FOB金额
	private String 	exp_stat;//出口商声明
	private String 	visa_stat;//签证当局证明
	private String 	rmk;//备注
	private Date 	file_date;//归档时间
	private String 	fiel_psn;//归档人员
	private String 	cert_file;//证书查看
	private Date 	create_date;//数据同步时间
	
	private String  fob_sum;
	private String dec_org_ename;
	private String 	lc_number;//	N	VARCHAR2(50)	Y			信用证号
	private String 	contract_number;//	N	VARCHAR2(50)	Y			合同号
	private String 	contact_person;//	N	VARCHAR2(50)	Y			联系人
	private String 	from_country;//	N	VARCHAR2(50)	Y			来源地及来源方式
	private String 	purpose_address	;//N	VARCHAR2(50)	Y			目的地地址

	
	public String getDec_org_ename() {
		return dec_org_ename;
	}
	public void setDec_org_ename(String dec_org_ename) {
		this.dec_org_ename = dec_org_ename;
	}
	public String getLc_number() {
		return lc_number;
	}
	public void setLc_number(String lc_number) {
		this.lc_number = lc_number;
	}
	public String getContract_number() {
		return contract_number;
	}
	public void setContract_number(String contract_number) {
		this.contract_number = contract_number;
	}
	public String getContact_person() {
		return contact_person;
	}
	public void setContact_person(String contact_person) {
		this.contact_person = contact_person;
	}
	public String getFrom_country() {
		return from_country;
	}
	public void setFrom_country(String from_country) {
		this.from_country = from_country;
	}
	public String getPurpose_address() {
		return purpose_address;
	}
	public void setPurpose_address(String purpose_address) {
		this.purpose_address = purpose_address;
	}
	public String getFob_sum() {
		return fob_sum;
	}
	public void setFob_sum(String fob_sum) {
		this.fob_sum = fob_sum;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMain_id() {
		return main_id;
	}
	public void setMain_id(String main_id) {
		this.main_id = main_id;
	}
	public String getDec_org_name() {
		return dec_org_name;
	}
	public void setDec_org_name(String dec_org_name) {
		this.dec_org_name = dec_org_name;
	}
	public String getDec_org_code() {
		return dec_org_code;
	}
	public void setDec_org_code(String dec_org_code) {
		this.dec_org_code = dec_org_code;
	}
	public String getOrg_reg_no() {
		return org_reg_no;
	}
	public void setOrg_reg_no(String org_reg_no) {
		this.org_reg_no = org_reg_no;
	}
	public String getDest_country() {
		return dest_country;
	}
	public void setDest_country(String dest_country) {
		this.dest_country = dest_country;
	}
	public String getTransfer_country() {
		return transfer_country;
	}
	public void setTransfer_country(String transfer_country) {
		this.transfer_country = transfer_country;
	}
	public String getTrade_mode() {
		return trade_mode;
	}
	public void setTrade_mode(String trade_mode) {
		this.trade_mode = trade_mode;
	}
	public Date getShipping_date() {
		return shipping_date;
	}
	public void setShipping_date(Date shipping_date) {
		this.shipping_date = shipping_date;
	}
	public String getCag_seq() {
		return cag_seq;
	}
	public void setCag_seq(String cag_seq) {
		this.cag_seq = cag_seq;
	}
	public String getHs_code() {
		return hs_code;
	}
	public void setHs_code(String hs_code) {
		this.hs_code = hs_code;
	}
	public String getCag_name() {
		return cag_name;
	}
	public void setCag_name(String cag_name) {
		this.cag_name = cag_name;
	}
	public String getCag_imp_comp() {
		return cag_imp_comp;
	}
	public void setCag_imp_comp(String cag_imp_comp) {
		this.cag_imp_comp = cag_imp_comp;
	}
	public String getProd_comp() {
		return prod_comp;
	}
	public void setProd_comp(String prod_comp) {
		this.prod_comp = prod_comp;
	}
	public String getNum_weight() {
		return num_weight;
	}
	public void setNum_weight(String num_weight) {
		this.num_weight = num_weight;
	}
	public String getFob_val() {
		return fob_val;
	}
	public void setFob_val(String fob_val) {
		this.fob_val = fob_val;
	}
	public String getConsignee_cname() {
		return consignee_cname;
	}
	public void setConsignee_cname(String consignee_cname) {
		this.consignee_cname = consignee_cname;
	}
	public String getCert_no() {
		return cert_no;
	}
	public void setCert_no(String cert_no) {
		this.cert_no = cert_no;
	}
	public String getReceipt_no() {
		return receipt_no;
	}
	public void setReceipt_no(String receipt_no) {
		this.receipt_no = receipt_no;
	}
	public Date getReceipt_date() {
		return receipt_date;
	}
	public void setReceipt_date(Date receipt_date) {
		this.receipt_date = receipt_date;
	}
	public String getMat_no() {
		return mat_no;
	}
	public void setMat_no(String mat_no) {
		this.mat_no = mat_no;
	}
	public String getNum_cag_disc() {
		return num_cag_disc;
	}
	public void setNum_cag_disc(String num_cag_disc) {
		this.num_cag_disc = num_cag_disc;
	}
	public String getPric_item() {
		return pric_item;
	}
	public void setPric_item(String pric_item) {
		this.pric_item = pric_item;
	}
	public String getCag_pric() {
		return cag_pric;
	}
	public void setCag_pric(String cag_pric) {
		this.cag_pric = cag_pric;
	}
	public String getSpec_item() {
		return spec_item;
	}
	public void setSpec_item(String spec_item) {
		this.spec_item = spec_item;
	}
	public String getExp_comp() {
		return exp_comp;
	}
	public void setExp_comp(String exp_comp) {
		this.exp_comp = exp_comp;
	}
	public String getTrans_type() {
		return trans_type;
	}
	public void setTrans_type(String trans_type) {
		this.trans_type = trans_type;
	}
	public String getPurpose_country() {
		return purpose_country;
	}
	public void setPurpose_country(String purpose_country) {
		this.purpose_country = purpose_country;
	}
	public String getPack_num() {
		return pack_num;
	}
	public void setPack_num(String pack_num) {
		this.pack_num = pack_num;
	}
	public String getOrig_place_std() {
		return orig_place_std;
	}
	public void setOrig_place_std(String orig_place_std) {
		this.orig_place_std = orig_place_std;
	}
	public String getM_weight() {
		return m_weight;
	}
	public void setM_weight(String m_weight) {
		this.m_weight = m_weight;
	}
	public String getApply_fob_val() {
		return apply_fob_val;
	}
	public void setApply_fob_val(String apply_fob_val) {
		this.apply_fob_val = apply_fob_val;
	}
	public String getExp_stat() {
		return exp_stat;
	}
	public void setExp_stat(String exp_stat) {
		this.exp_stat = exp_stat;
	}
	public String getVisa_stat() {
		return visa_stat;
	}
	public void setVisa_stat(String visa_stat) {
		this.visa_stat = visa_stat;
	}
	public String getRmk() {
		return rmk;
	}
	public void setRmk(String rmk) {
		this.rmk = rmk;
	}
	public Date getFile_date() {
		return file_date;
	}
	public void setFile_date(Date file_date) {
		this.file_date = file_date;
	}
	public String getFiel_psn() {
		return fiel_psn;
	}
	public void setFiel_psn(String fiel_psn) {
		this.fiel_psn = fiel_psn;
	}
	public String getCert_file() {
		return cert_file;
	}
	public void setCert_file(String cert_file) {
		this.cert_file = cert_file;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}

	private String dept_code;//分支机构
	private String org_code;//直属局
	private String cert_type;//证书种类
	private String main_operation;//主要加工工序
	private String orig_store;//原材料和零配件的存放情况
	private String goods;//成品
	private String orig_store_code;//原材料和零配件的存放情况,外包装上品名及生产企业名称,进口报关单及采购发票
	private String import_num;//进口报关单及采购发票
	private String old_place_check;//原产地业务实地调查记录单
	private String order_file;//其他材料
	private Date apply_date;//申请日期
	private Date qianfa_date; //签发时间
	private String qianfa_person;//签发人员
	private String qianfa_cert;//签发证书
	private String down_org;//分支机构
	private Date check_date;//调查时间
	private String check_person;//调查人员
	private String check_cert;//书面调查
	private String check_place;//实地调查
	public String getCert_type() {
		return cert_type;
	}
	public void setCert_type(String cert_type) {
		this.cert_type = cert_type;
	}
	public String getMain_operation() {
		return main_operation;
	}
	public void setMain_operation(String main_operation) {
		this.main_operation = main_operation;
	}
	public String getOrig_store() {
		return orig_store;
	}
	public void setOrig_store(String orig_store) {
		this.orig_store = orig_store;
	}
	public String getGoods() {
		return goods;
	}
	public void setGoods(String goods) {
		this.goods = goods;
	}
	public String getOrig_store_code() {
		return orig_store_code;
	}
	public void setOrig_store_code(String orig_store_code) {
		this.orig_store_code = orig_store_code;
	}
	public String getImport_num() {
		return import_num;
	}
	public void setImport_num(String import_num) {
		this.import_num = import_num;
	}
	public String getOld_place_check() {
		return old_place_check;
	}
	public void setOld_place_check(String old_place_check) {
		this.old_place_check = old_place_check;
	}
	public String getOrder_file() {
		return order_file;
	}
	public void setOrder_file(String order_file) {
		this.order_file = order_file;
	}
	public Date getQianfa_date() {
		return qianfa_date;
	}
	public void setQianfa_date(Date qianfa_date) {
		this.qianfa_date = qianfa_date;
	}
	public String getQianfa_person() {
		return qianfa_person;
	}
	public void setQianfa_person(String qianfa_person) {
		this.qianfa_person = qianfa_person;
	}
	public String getQianfa_cert() {
		return qianfa_cert;
	}
	public void setQianfa_cert(String qianfa_cert) {
		this.qianfa_cert = qianfa_cert;
	}
	public Date getCheck_date() {
		return check_date;
	}
	public void setCheck_date(Date check_date) {
		this.check_date = check_date;
	}
	public String getCheck_person() {
		return check_person;
	}
	public void setCheck_person(String check_person) {
		this.check_person = check_person;
	}
	public String getCheck_cert() {
		return check_cert;
	}
	public void setCheck_cert(String check_cert) {
		this.check_cert = check_cert;
	}
	public String getCheck_place() {
		return check_place;
	}
	public void setCheck_place(String check_place) {
		this.check_place = check_place;
	}
	public Date getApply_date() {
		return apply_date;
	}
	public void setApply_date(Date apply_date) {
		this.apply_date = apply_date;
	}
	public String getDown_org() {
		return down_org;
	}
	public void setDown_org(String down_org) {
		this.down_org = down_org;
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

	private String apply_date_begin;
	private String apply_date_over;
	private List<VideoEventModel> qvAllList;
	private List<VideoEventModel> qvMainList;
	private List<VideoEventModel> qvGoodList;
	private List<VideoEventModel> qvMatList;
	private List<VideoEventModel> qvQianfaList;
	private List<VideoEventModel> qvOrderList;
	private List<VideoEventModel> qvVideoList;
	private List<VideoEventModel> qvCheckCertList;
	public String getApply_date_begin() {
		return apply_date_begin;
	}
	public void setApply_date_begin(String apply_date_begin) {
		this.apply_date_begin = apply_date_begin;
	}
	public String getApply_date_over() {
		return apply_date_over;
	}
	public void setApply_date_over(String apply_date_over) {
		this.apply_date_over = apply_date_over;
	}
	public List<VideoEventModel> getQvAllList() {
		return qvAllList;
	}
	public void setQvAllList(List<VideoEventModel> qvAllList) {
		this.qvAllList = qvAllList;
	}
	public List<VideoEventModel> getQvMainList() {
		return qvMainList;
	}
	public void setQvMainList(List<VideoEventModel> qvMainList) {
		this.qvMainList = qvMainList;
	}
	public List<VideoEventModel> getQvGoodList() {
		return qvGoodList;
	}
	public void setQvGoodList(List<VideoEventModel> qvGoodList) {
		this.qvGoodList = qvGoodList;
	}
	public List<VideoEventModel> getQvMatList() {
		return qvMatList;
	}
	public void setQvMatList(List<VideoEventModel> qvMatList) {
		this.qvMatList = qvMatList;
	}
	public List<VideoEventModel> getQvQianfaList() {
		return qvQianfaList;
	}
	public void setQvQianfaList(List<VideoEventModel> qvQianfaList) {
		this.qvQianfaList = qvQianfaList;
	}
	public List<VideoEventModel> getQvOrderList() {
		return qvOrderList;
	}
	public void setQvOrderList(List<VideoEventModel> qvOrderList) {
		this.qvOrderList = qvOrderList;
	}
	public List<VideoEventModel> getQvVideoList() {
		return qvVideoList;
	}
	public void setQvVideoList(List<VideoEventModel> qvVideoList) {
		this.qvVideoList = qvVideoList;
	}
	public List<VideoEventModel> getQvCheckCertList() {
		return qvCheckCertList;
	}
	public void setQvCheckCertList(List<VideoEventModel> qvCheckCertList) {
		this.qvCheckCertList = qvCheckCertList;
	}

	
	
}
