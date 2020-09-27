package cn.com.cgbchina.rest.visit.model.user;

import cn.com.cgbchina.rest.visit.model.BaseResult;

import java.io.Serializable;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class CheckChannelPwdResult extends BaseResult implements Serializable {
	private static final long serialVersionUID = 2782219157184472903L;
	private Byte isCheckPass;

	public Byte getIsCheckPass() {
		return isCheckPass;
	}

	public void setIsCheckPass(Byte isCheckPass) {
		this.isCheckPass = isCheckPass;
	}

}
