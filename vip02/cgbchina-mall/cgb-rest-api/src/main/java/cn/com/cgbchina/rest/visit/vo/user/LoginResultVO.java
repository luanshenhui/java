package cn.com.cgbchina.rest.visit.vo.user;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import cn.com.cgbchina.rest.visit.vo.BaseResultVo;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
public class LoginResultVO extends BaseResultVo implements Serializable {
	// 00000000 У��ͨ��
	// 00000001 ע��ɹ�
	// 00000002 �û�������
	// PA020100 �˺Ż��������
	// PA020101 �û�����ʱ����
	// PA020102 �û������ö��ᣬ��ȥ��̨�ⶳ
	// PA020103 �û���ע��
	// PA020104 �Բ��������õĵ�¼��ʽ����ĵ�¼��һ��
	// PA020105 �˺Ż��������
	// PA020106 �Բ������Ѿ�ע��������ʹ��ע��������˺ź������¼������е�¼��
	// PA020107 �Բ��������õĵ�¼�����Ѵ��ڣ�
	// PA020108 �Բ����������֤�����˺����󣬻���֤����Ϣ���˺Ų���
	// PA020109 �Բ����������˽�ܴ𰸲���ȷ��
	// PA020110 �Բ�����δ����˽�����⣬��ȥ��̨�����������룡
	// PA020111 �Բ�����Ŀͻ�״̬����
	// PA020112 �Բ������ѿ�ͨ����������
	// PA020113 �Բ������ѿ�ͨ�ֻ�����������
	// PA020114 �Բ��������õ��ֻ�����Ѵ��ڣ�
	// PA020115 ��ѡ��ͨ������
	private String hostReturnCode;// hostReturnCode
	private String hostErrorMessage;// ��Ӧ��Ϣ

	public String getHostReturnCode() {
		return hostReturnCode;
	}

	public void setHostReturnCode(String hostReturnCode) {
		this.hostReturnCode = hostReturnCode;
	}

	public String getHostErrorMessage() {
		return hostErrorMessage;
	}

	public void setHostErrorMessage(String hostErrorMessage) {
		this.hostErrorMessage = hostErrorMessage;
	}

	@NotNull
	private String customerId;
	@NotNull
	private String customerName;
	@NotNull
	private String customerSex;
	@NotNull
	private String certType;
	@NotNull
	private String certNo;
	@NotNull
	private String address;
	@NotNull
	private String zipCode;
	@NotNull
	private String phoneNo;
	@NotNull
	private String mobileNo;
	@NotNull
	private String email;
	@NotNull
	private String isCheckPassword;
	@NotNull
	private String checkChannelState;
	private List<LoginCardInfoVO> loginCardInfos;

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerSex() {
		return customerSex;
	}

	public void setCustomerSex(String customerSex) {
		this.customerSex = customerSex;
	}

	public String getCertType() {
		return certType;
	}

	public void setCertType(String certType) {
		this.certType = certType;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getIsCheckPassword() {
		return isCheckPassword;
	}

	public void setIsCheckPassword(String isCheckPassword) {
		this.isCheckPassword = isCheckPassword;
	}

	public String getCheckChannelState() {
		return checkChannelState;
	}

	public void setCheckChannelState(String checkChannelState) {
		this.checkChannelState = checkChannelState;
	}

	public List<LoginCardInfoVO> getLoginCardInfos() {
		return loginCardInfos;
	}

	public void setLoginCardInfos(List<LoginCardInfoVO> loginCardInfos) {
		this.loginCardInfos = loginCardInfos;
	}
}
