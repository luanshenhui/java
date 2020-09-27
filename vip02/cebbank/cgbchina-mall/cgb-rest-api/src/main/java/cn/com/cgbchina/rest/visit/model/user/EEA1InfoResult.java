package cn.com.cgbchina.rest.visit.model.user;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.model.BaseResult;

public class EEA1InfoResult extends BaseResult implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9013672345952353520L;
	@NotNull
	private String pinBlock;

	public String getPinBlock() {
		return pinBlock;
	}

	public void setPinBlock(String pinBlock) {
		this.pinBlock = pinBlock;
	}

}
