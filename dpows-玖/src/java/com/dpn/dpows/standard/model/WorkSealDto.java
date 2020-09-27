package com.dpn.dpows.standard.model;

import java.util.Date;

/**
* WorkSealDto.
*
* @author zhaoqian@dpn.com.cn
* @since 1.0.0 zhaoqian@dpn.com.cn
* @version 1.0.0 zhaoqian@dpn.com.cn
* Created by liuchao on 2017-9-12 16:27:26
**/
public class WorkSealDto {
	
				// 字段                                  字段类型                                 是否可为空                               字段名
	private String id;	        //VARCHAR2(32)	    N			企业/管理部门ID
	private String name;	    //VARCHAR2(32)	    Y			名称
	private String path;	    //VARCHAR2(128)	    Y			专用章文件路径
	private String opt_user_id;	//VARCHAR2(32)	    Y			上传人用户ID
	private Date gmt_created;	//DATE	            Y			上传时间
	private Date gmt_modified;//DATE	            Y		             修改时间
	
	public WorkSealDto(){}
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getOpt_user_id() {
		return opt_user_id;
	}
	public void setOpt_user_id(String opt_user_id) {
		this.opt_user_id = opt_user_id;
	}


	public Date getGmt_created() {
		return gmt_created;
	}


	public void setGmt_created(Date gmt_created) {
		this.gmt_created = gmt_created;
	}


	public Date getGmt_modified() {
		return gmt_modified;
	}


	public void setGmt_modified(Date gmt_modified) {
		this.gmt_modified = gmt_modified;
	}
	
 
}
