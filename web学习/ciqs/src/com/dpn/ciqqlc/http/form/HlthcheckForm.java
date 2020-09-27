package com.dpn.ciqqlc.http.form;

public class HlthcheckForm {
	
	private String dec_master_id;//业务主键
	
	private String page ;//页码
	
	private String hlth_check_type;//卫生监督类型（1：一般卫生监督:2：专项卫生监督）
	
	private String table_type;
	
	private String hun_name;

	public String getPage() {
		return page;
	}

	public void setPage(String page) {
		this.page = page;
	}

	public String getDec_master_id() {
		return dec_master_id;
	}

	public void setDec_master_id(String dec_master_id) {
		this.dec_master_id = dec_master_id;
	} 

	public String getHlth_check_type() {
		return hlth_check_type;
	}

	public void setHlth_check_type(String hlth_check_type) {
		this.hlth_check_type = hlth_check_type;
	}

	public String getTable_type() {
		return table_type;
	}

	public void setTable_type(String table_type) {
		this.table_type = table_type;
	}

	public String getHun_name() {
		return hun_name;
	}

	public void setHun_name(String hun_name) {
		this.hun_name = hun_name;
	}

}
