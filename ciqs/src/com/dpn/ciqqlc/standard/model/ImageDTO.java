package com.dpn.ciqqlc.standard.model;

public class ImageDTO {
	private String id;//主键
	
	private String proc_main_id;//业务主键
	
	private String proc_type;//环节类型（详见环节代码表QLC_VIDEO_PROC_TYPE(各业务环节代码)）
	
	private String file_type;//文件类型  1：照片    2：视频       3：音频

	private String file_name;//文件名称，规则：箱号+时间精确到3位毫秒

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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

}
