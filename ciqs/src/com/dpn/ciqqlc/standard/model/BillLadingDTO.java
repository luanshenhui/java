package com.dpn.ciqqlc.standard.model;

import java.util.Date;



public class BillLadingDTO{
	private String bill_id;
	private String bill_no	;
	private String ship_name_en	;
	private String ship_name_cn	;
	private String voyage_no	;
	private String terminal_code;	
	private String port_dept_code;	
	private String port_org_code;	
	private String ts_dept_code	;
	private String data_src;	
	private String ship_id	;
	private String loading_port	;
	private String main_g_name;	
	private String conta_status;
	private String flag_rf	;
	private String flag_woodwra	;
	private String flag_fv	;
	private String flag_waster	;
	private String flag_tran;
	private String flag_monitor	;
	private String flag_yi	;
	private String land_location;	
	private String flag_pin	;
	private String transport_article;	
	private int conta_num;	
	private String b_bill_id;	
	private String created_date	;
	private String insp_user;	
	private Date delivery_date;	
	private String book_no;	
	private String status;	
	private String op_code;	
	private Date op_date;	
	private String op_user;	
	private String call_sign;	//	船舶呼号
	private String sender;	//		发货人
	private String receiver;	//		收货人
	private String informer;	//		通知人
	private String yi_code;	//		疫情代码串
	private String insp_result;	//		检验结果
	private String approve_dept;	//		申报单审批科室
	private String approve_user;	//			申报单审批人
	private String approve_result;	//			申报单审批结果
	private String check_result;	//			查验结果备注
	private String pin_mark;	//	"提箱申请处理标识0：未提箱
	private String terminal_code_cur;	//		当前码头
	private String ts_terminal_code;	//		待疏港码头
	private Date approve_date;	//			申报单审批时间
	private String msg_sender;	//			报文发送方
	private String flag_dgod;	//	危险品标识0:否  1:是
	private String value_amount;	//		托运货物价值
	private String currency_type_code;	//			金额类型代码
	private String gross_volume;	//		货物体积
	private String packages_quantity;	//		货物总件数
	private String packages_type;	//			包装代码
	private String gross_weight;	//		货物总毛重
	private String previous_port;	//			上一港
	private String transport_means_code;	//			运输工具代码
	private String lock_status;	//		加锁状态  0未加锁   1已加锁  2已解锁
	private String lj_confirm_st;	//		辽检确认状态（冷藏舱单），0未确认，1已确认
	private String insp_user_f;	//			被派工人(辅检)
	private String xun_fee_status;	//	熏蒸收费状态（0：未收费；1：已收费）
	
	private String spacialFlag; // 特殊标识
	
	
	
	public String getSpacialFlag() {
		return spacialFlag;
	}
	public void setSpacialFlag(String spacialFlag) {
		this.spacialFlag = spacialFlag;
	}
	public String getBill_id() {
		return bill_id;
	}


	private String op_str_date;
	public String getOp_str_date() {
		return op_str_date;
	}
	public void setOp_str_date(String op_str_date) {
		this.op_str_date = op_str_date;
	}
	public String getBill_no() {
		return bill_no;
	}
	public void setBill_no(String bill_no) {
		this.bill_no = bill_no;
	}
	public String getPort_dept_code() {
		return port_dept_code;
	}
	public void setPort_dept_code(String port_dept_code) {
		this.port_dept_code = port_dept_code;
	}
	public String getOp_user() {
		return op_user;
	}
	public void setOp_user(String op_user) {
		this.op_user = op_user;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getBook_no() {
		return book_no;
	}
	public void setBook_no(String book_no) {
		this.book_no = book_no;
	}
	public Date getOp_date() {
		return op_date;
	}
	public void setOp_date(Date op_date) {
		this.op_date = op_date;
	}
	public String getShip_name_en() {
		return ship_name_en;
	}
	public void setShip_name_en(String ship_name_en) {
		this.ship_name_en = ship_name_en;
	}
	public String getShip_name_cn() {
		return ship_name_cn;
	}
	public void setShip_name_cn(String ship_name_cn) {
		this.ship_name_cn = ship_name_cn;
	}
	public String getVoyage_no() {
		return voyage_no;
	}
	public void setVoyage_no(String voyage_no) {
		this.voyage_no = voyage_no;
	}
	public String getTerminal_code() {
		return terminal_code;
	}
	public void setTerminal_code(String terminal_code) {
		this.terminal_code = terminal_code;
	}
	public String getPort_org_code() {
		return port_org_code;
	}
	public void setPort_org_code(String port_org_code) {
		this.port_org_code = port_org_code;
	}
	public String getTs_dept_code() {
		return ts_dept_code;
	}
	public void setTs_dept_code(String ts_dept_code) {
		this.ts_dept_code = ts_dept_code;
	}
	public String getData_src() {
		return data_src;
	}
	public void setData_src(String data_src) {
		this.data_src = data_src;
	}
	public String getShip_id() {
		return ship_id;
	}
	public void setShip_id(String ship_id) {
		this.ship_id = ship_id;
	}
	public String getLoading_port() {
		return loading_port;
	}
	public void setLoading_port(String loading_port) {
		this.loading_port = loading_port;
	}
	public String getMain_g_name() {
		return main_g_name;
	}
	public void setMain_g_name(String main_g_name) {
		this.main_g_name = main_g_name;
	}
	public String getConta_status() {
		return conta_status;
	}
	public void setConta_status(String conta_status) {
		this.conta_status = conta_status;
	}
	public String getFlag_rf() {
		return flag_rf;
	}
	public void setFlag_rf(String flag_rf) {
		this.flag_rf = flag_rf;
	}
	public String getFlag_woodwra() {
		return flag_woodwra;
	}
	public void setFlag_woodwra(String flag_woodwra) {
		this.flag_woodwra = flag_woodwra;
	}
	public String getFlag_fv() {
		return flag_fv;
	}
	public void setFlag_fv(String flag_fv) {
		this.flag_fv = flag_fv;
	}
	public String getFlag_waster() {
		return flag_waster;
	}
	public void setFlag_waster(String flag_waster) {
		this.flag_waster = flag_waster;
	}
	public String getFlag_tran() {
		return flag_tran;
	}
	public void setFlag_tran(String flag_tran) {
		this.flag_tran = flag_tran;
	}
	public String getFlag_monitor() {
		return flag_monitor;
	}
	public void setFlag_monitor(String flag_monitor) {
		this.flag_monitor = flag_monitor;
	}
	public String getFlag_yi() {
		return flag_yi;
	}
	public void setFlag_yi(String flag_yi) {
		this.flag_yi = flag_yi;
	}
	public String getLand_location() {
		return land_location;
	}
	public void setLand_location(String land_location) {
		this.land_location = land_location;
	}
	public String getFlag_pin() {
		return flag_pin;
	}
	public void setFlag_pin(String flag_pin) {
		this.flag_pin = flag_pin;
	}
	public String getTransport_article() {
		return transport_article;
	}
	public void setTransport_article(String transport_article) {
		this.transport_article = transport_article;
	}
	public int getConta_num() {
		return conta_num;
	}
	public void setConta_num(int conta_num) {
		this.conta_num = conta_num;
	}
	public String getB_bill_id() {
		return b_bill_id;
	}
	public void setB_bill_id(String b_bill_id) {
		this.b_bill_id = b_bill_id;
	}
	public String getCreated_date() {
		return created_date;
	}
	public void setCreated_date(String created_date) {
		this.created_date = created_date;
	}
	public String getInsp_user() {
		return insp_user;
	}
	public void setInsp_user(String insp_user) {
		this.insp_user = insp_user;
	}
	public Date getDelivery_date() {
		return delivery_date;
	}
	public void setDelivery_date(Date delivery_date) {
		this.delivery_date = delivery_date;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getOp_code() {
		return op_code;
	}
	public void setOp_code(String op_code) {
		this.op_code = op_code;
	}
	public String getCall_sign() {
		return call_sign;
	}
	public void setCall_sign(String call_sign) {
		this.call_sign = call_sign;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getReceiver() {
		return receiver;
	}
	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	public String getInformer() {
		return informer;
	}
	public void setInformer(String informer) {
		this.informer = informer;
	}
	public String getYi_code() {
		return yi_code;
	}
	public void setYi_code(String yi_code) {
		this.yi_code = yi_code;
	}
	public String getInsp_result() {
		return insp_result;
	}
	public void setInsp_result(String insp_result) {
		this.insp_result = insp_result;
	}
	public String getApprove_dept() {
		return approve_dept;
	}
	public void setApprove_dept(String approve_dept) {
		this.approve_dept = approve_dept;
	}
	public String getApprove_user() {
		return approve_user;
	}
	public void setApprove_user(String approve_user) {
		this.approve_user = approve_user;
	}
	public String getApprove_result() {
		return approve_result;
	}
	public void setApprove_result(String approve_result) {
		this.approve_result = approve_result;
	}
	public String getCheck_result() {
		return check_result;
	}
	public void setCheck_result(String check_result) {
		this.check_result = check_result;
	}
	public String getPin_mark() {
		return pin_mark;
	}
	public void setPin_mark(String pin_mark) {
		this.pin_mark = pin_mark;
	}
	public String getTerminal_code_cur() {
		return terminal_code_cur;
	}
	public void setTerminal_code_cur(String terminal_code_cur) {
		this.terminal_code_cur = terminal_code_cur;
	}
	public String getTs_terminal_code() {
		return ts_terminal_code;
	}
	public void setTs_terminal_code(String ts_terminal_code) {
		this.ts_terminal_code = ts_terminal_code;
	}
	public Date getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(Date approve_date) {
		this.approve_date = approve_date;
	}
	public String getMsg_sender() {
		return msg_sender;
	}
	public void setMsg_sender(String msg_sender) {
		this.msg_sender = msg_sender;
	}
	public String getFlag_dgod() {
		return flag_dgod;
	}
	public void setFlag_dgod(String flag_dgod) {
		this.flag_dgod = flag_dgod;
	}
	public String getValue_amount() {
		return value_amount;
	}
	public void setValue_amount(String value_amount) {
		this.value_amount = value_amount;
	}
	public String getCurrency_type_code() {
		return currency_type_code;
	}
	public void setCurrency_type_code(String currency_type_code) {
		this.currency_type_code = currency_type_code;
	}
	public String getGross_volume() {
		return gross_volume;
	}
	public void setGross_volume(String gross_volume) {
		this.gross_volume = gross_volume;
	}
	public String getPackages_quantity() {
		return packages_quantity;
	}
	public void setPackages_quantity(String packages_quantity) {
		this.packages_quantity = packages_quantity;
	}
	public String getPackages_type() {
		return packages_type;
	}
	public void setPackages_type(String packages_type) {
		this.packages_type = packages_type;
	}
	public String getGross_weight() {
		return gross_weight;
	}
	public void setGross_weight(String gross_weight) {
		this.gross_weight = gross_weight;
	}
	public String getPrevious_port() {
		return previous_port;
	}
	public void setPrevious_port(String previous_port) {
		this.previous_port = previous_port;
	}
	public String getTransport_means_code() {
		return transport_means_code;
	}
	public void setTransport_means_code(String transport_means_code) {
		this.transport_means_code = transport_means_code;
	}
	public String getLock_status() {
		return lock_status;
	}
	public void setLock_status(String lock_status) {
		this.lock_status = lock_status;
	}
	public String getLj_confirm_st() {
		return lj_confirm_st;
	}
	public void setLj_confirm_st(String lj_confirm_st) {
		this.lj_confirm_st = lj_confirm_st;
	}
	public String getInsp_user_f() {
		return insp_user_f;
	}
	public void setInsp_user_f(String insp_user_f) {
		this.insp_user_f = insp_user_f;
	}
	public String getXun_fee_status() {
		return xun_fee_status;
	}
	public void setXun_fee_status(String xun_fee_status) {
		this.xun_fee_status = xun_fee_status;
	}
	

}
