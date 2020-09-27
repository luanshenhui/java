package com.dpn.ciqqlc.standard.model;

public class VideoEventDTO {
	private String bill_id;
	private String conta_no	;//		箱号
	private String ref_id	;//			外联主键（木质包装等查验照片或视频）
	private String file_type	;//				文件类型  1：照片    2：视频       3：音频
	private String create_user;//			创建人
	private String create_date;//		sysdate		创建时间
	private String file_name;
	private String fileMonth;
	private String fileDate;
	
	public String getFileMonth() {
		return fileMonth;
	}
	public void setFileMonth(String fileMonth) {
		this.fileMonth = fileMonth;
	}
	public String getFileDate() {
		return fileDate;
	}
	public void setFileDate(String fileDate) {
		this.fileDate = fileDate;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getConta_no() {
		return conta_no;
	}
	public void setConta_no(String conta_no) {
		this.conta_no = conta_no;
	}
	public String getRef_id() {
		return ref_id;
	}
	public void setRef_id(String ref_id) {
		this.ref_id = ref_id;
	}
	public String getFile_type() {
		return file_type;
	}
	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}
	public String getCreate_user() {
		return create_user;
	}
	public void setCreate_user(String create_user) {
		this.create_user = create_user;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getFile_name() {
		return file_name;
	}
	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}

	

}
