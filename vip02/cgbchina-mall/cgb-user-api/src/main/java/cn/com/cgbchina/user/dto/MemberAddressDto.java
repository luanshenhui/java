package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.MemberAddressModel;

import java.io.Serializable;

/**
 * Created by niufw on 16-4-25.
 */
public class MemberAddressDto extends MemberAddressModel implements Serializable {
	private static final long serialVersionUID = 7189139425744626551L;
	/**
	 * 电话号码的区号、座机号、分机号
	 */
	private String areaCode;// 区号

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	private String telNumber;// 座机号

	public String getTelNumber() {
		return telNumber;
	}

	public void setTelNumber(String telNumber) {
		this.telNumber = telNumber;
	}

	private String extNumber;// 分机号

	public String getExtNumber() {
		return extNumber;
	}

	public void setExtNumber(String extNumber) {
		this.extNumber = extNumber;
	}

	private Integer count;// 该用户的有效收货地址（不包含删除的地址）总条数

	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}
}
