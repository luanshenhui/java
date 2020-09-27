/**
 * Copyright © 2016 广东发展银行 All right reserved
 */
package cn.com.cgbchina.item.dto;


import cn.com.cgbchina.item.model.SmspInfModel;

import java.io.Serializable;
import java.util.Date;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/6/30.
 */
public class SmspInfDto extends SmspInfModel implements Serializable {

	private static final long serialVersionUID = -1623570248218660445L;

	private Date newDate;// 当前日期
	private String userType;//角色类型

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public Date getNewDate() {
		return newDate;
	}

	public void setNewDate(Date newDate) {
		this.newDate = newDate;
	}

}
