package cn.com.cgbchina.user.model;

import com.google.common.base.Objects;
import com.spirit.user.User;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

public class VendorModel extends User implements Serializable {

	private static final long serialVersionUID = -7167086986961783587L;
	private String shopType;// 一次密码

	public String getShopType() {
		return shopType;
	}

	public void setShopType(String shopType) {
		this.shopType = shopType;
	}

	private String pwfirst;// 一次密码

	public String getPwfirst() {
		return pwfirst;
	}

	public void setPwfirst(String pwfirst) {
		this.pwfirst = pwfirst;
	}

	private String pwsecond;// 二次密码

	public String getPwsecond() {
		return pwsecond;
	}

	public void setPwsecond(String pwsecond) {
		this.pwsecond = pwsecond;
	}

	private String phone;// 电话

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	private String fax;// 传真

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPapersType() {
		return papersType;
	}

	public void setPapersType(String papersType) {
		this.papersType = papersType;
	}

	public String getPapersNum() {
		return papersNum;
	}

	public void setPapersNum(String papersNum) {
		this.papersNum = papersNum;
	}

	public String getIsFirst() {
		return isFirst;
	}

	public void setIsFirst(String isFirst) {
		this.isFirst = isFirst;
	}

	@Override
	public String getAddress() {
		return address;
	}

	@Override
	public void setAddress(String address) {
		this.address = address;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDescript() {
		return descript;
	}

	public void setDescript(String descript) {
		this.descript = descript;
	}

	public String getRightCode() {
		return rightCode;
	}

	public void setRightCode(String rightCode) {
		this.rightCode = rightCode;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public Date getLoginTime() {
		return loginTime;
	}

	public void setLoginTime(Date loginTime) {
		this.loginTime = loginTime;
	}

	public Integer getLoginCount() {
		return loginCount;
	}

	public void setLoginCount(Integer loginCount) {
		this.loginCount = loginCount;
	}

	public Integer getErrorCount() {
		return errorCount;
	}

	public void setErrorCount(Integer errorCount) {
		this.errorCount = errorCount;
	}

	public String getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(String checkStatus) {
		this.checkStatus = checkStatus;
	}

	public String getRefuseDesc() {
		return refuseDesc;
	}

	public void setRefuseDesc(String refuseDesc) {
		this.refuseDesc = refuseDesc;
	}

	public String getCreateOper() {
		return createOper;
	}

	public void setCreateOper(String createOper) {
		this.createOper = createOper;
	}

	public String getModifyOper() {
		return modifyOper;
	}

	public void setModifyOper(String modifyOper) {
		this.modifyOper = modifyOper;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getModifyTime() {
		return modifyTime;
	}

	public void setModifyTime(Date modifyTime) {
		this.modifyTime = modifyTime;
	}

	public Date getEditPwTime() {
		return editPwTime;
	}

	public void setEditPwTime(Date editPwTime) {
		this.editPwTime = editPwTime;
	}

	public String getIsSub() {
		return isSub;
	}

	public void setIsSub(String isSub) {
		this.isSub = isSub;
	}

	public String getDelFlag() {
		return delFlag;
	}

	public void setDelFlag(String delFlag) {
		this.delFlag = delFlag;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	@Override
	public String getVendorId() {
		return vendorId;
	}

	@Override
	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}

	public String getSimpleName() {
		return simpleName;
	}

	public void setSimpleName(String simpleName) {
		this.simpleName = simpleName;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	private String password;// 用户密码

	private String papersType;// 用户证件
	private String papersNum;// 证件号码
	private String isFirst;// 是否第一次登陆 0第一次登陆1否
	private String address;// 地址（未用）
	private String status;// 当前状态0101未启用0102已启用
	private String descript;// 用户备注
	private String rightCode;// 权限位
	private String level;// 用户等级 0管理员1普通用户
	private java.util.Date loginTime;// 登录时间
	private Integer loginCount;// 登录个数
	private Integer errorCount;// 错误个数
	private String checkStatus;// 审核状态
	private String refuseDesc;// 拒绝原因
	private String createOper;// 创建者
	private String modifyOper;// 修改者
	private java.util.Date createTime;// 创建时间
	private java.util.Date modifyTime;// 修改时间
	private java.util.Date editPwTime;//
	private String isSub;// 0不是子账户1是
	private String delFlag;// 删除标志0-未删除1-删除
	private String parentId;// 父ID
	private String vendorId;// 供应商代码
	private String simpleName;// 供应商简称
	private String code;// 用户编码

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		VendorModel that = (VendorModel) o;

		if (shopType != null ? !shopType.equals(that.shopType) : that.shopType != null) return false;
		if (pwfirst != null ? !pwfirst.equals(that.pwfirst) : that.pwfirst != null) return false;
		if (pwsecond != null ? !pwsecond.equals(that.pwsecond) : that.pwsecond != null) return false;
		if (phone != null ? !phone.equals(that.phone) : that.phone != null) return false;
		if (fax != null ? !fax.equals(that.fax) : that.fax != null) return false;
		if (password != null ? !password.equals(that.password) : that.password != null) return false;
		if (papersType != null ? !papersType.equals(that.papersType) : that.papersType != null) return false;
		if (papersNum != null ? !papersNum.equals(that.papersNum) : that.papersNum != null) return false;
		if (isFirst != null ? !isFirst.equals(that.isFirst) : that.isFirst != null) return false;
		if (address != null ? !address.equals(that.address) : that.address != null) return false;
		if (status != null ? !status.equals(that.status) : that.status != null) return false;
		if (descript != null ? !descript.equals(that.descript) : that.descript != null) return false;
		if (rightCode != null ? !rightCode.equals(that.rightCode) : that.rightCode != null) return false;
		if (level != null ? !level.equals(that.level) : that.level != null) return false;
		if (loginTime != null ? !loginTime.equals(that.loginTime) : that.loginTime != null) return false;
		if (loginCount != null ? !loginCount.equals(that.loginCount) : that.loginCount != null) return false;
		if (errorCount != null ? !errorCount.equals(that.errorCount) : that.errorCount != null) return false;
		if (checkStatus != null ? !checkStatus.equals(that.checkStatus) : that.checkStatus != null) return false;
		if (refuseDesc != null ? !refuseDesc.equals(that.refuseDesc) : that.refuseDesc != null) return false;
		if (createOper != null ? !createOper.equals(that.createOper) : that.createOper != null) return false;
		if (modifyOper != null ? !modifyOper.equals(that.modifyOper) : that.modifyOper != null) return false;
		if (createTime != null ? !createTime.equals(that.createTime) : that.createTime != null) return false;
		if (modifyTime != null ? !modifyTime.equals(that.modifyTime) : that.modifyTime != null) return false;
		if (editPwTime != null ? !editPwTime.equals(that.editPwTime) : that.editPwTime != null) return false;
		if (isSub != null ? !isSub.equals(that.isSub) : that.isSub != null) return false;
		if (delFlag != null ? !delFlag.equals(that.delFlag) : that.delFlag != null) return false;
		if (parentId != null ? !parentId.equals(that.parentId) : that.parentId != null) return false;
		if (vendorId != null ? !vendorId.equals(that.vendorId) : that.vendorId != null) return false;
		if (simpleName != null ? !simpleName.equals(that.simpleName) : that.simpleName != null) return false;
		return !(code != null ? !code.equals(that.code) : that.code != null);

	}

	@Override
	public int hashCode() {
		int result = shopType != null ? shopType.hashCode() : 0;
		result = 31 * result + (pwfirst != null ? pwfirst.hashCode() : 0);
		result = 31 * result + (pwsecond != null ? pwsecond.hashCode() : 0);
		result = 31 * result + (phone != null ? phone.hashCode() : 0);
		result = 31 * result + (fax != null ? fax.hashCode() : 0);
		result = 31 * result + (password != null ? password.hashCode() : 0);
		result = 31 * result + (papersType != null ? papersType.hashCode() : 0);
		result = 31 * result + (papersNum != null ? papersNum.hashCode() : 0);
		result = 31 * result + (isFirst != null ? isFirst.hashCode() : 0);
		result = 31 * result + (address != null ? address.hashCode() : 0);
		result = 31 * result + (status != null ? status.hashCode() : 0);
		result = 31 * result + (descript != null ? descript.hashCode() : 0);
		result = 31 * result + (rightCode != null ? rightCode.hashCode() : 0);
		result = 31 * result + (level != null ? level.hashCode() : 0);
		result = 31 * result + (loginTime != null ? loginTime.hashCode() : 0);
		result = 31 * result + (loginCount != null ? loginCount.hashCode() : 0);
		result = 31 * result + (errorCount != null ? errorCount.hashCode() : 0);
		result = 31 * result + (checkStatus != null ? checkStatus.hashCode() : 0);
		result = 31 * result + (refuseDesc != null ? refuseDesc.hashCode() : 0);
		result = 31 * result + (createOper != null ? createOper.hashCode() : 0);
		result = 31 * result + (modifyOper != null ? modifyOper.hashCode() : 0);
		result = 31 * result + (createTime != null ? createTime.hashCode() : 0);
		result = 31 * result + (modifyTime != null ? modifyTime.hashCode() : 0);
		result = 31 * result + (editPwTime != null ? editPwTime.hashCode() : 0);
		result = 31 * result + (isSub != null ? isSub.hashCode() : 0);
		result = 31 * result + (delFlag != null ? delFlag.hashCode() : 0);
		result = 31 * result + (parentId != null ? parentId.hashCode() : 0);
		result = 31 * result + (vendorId != null ? vendorId.hashCode() : 0);
		result = 31 * result + (simpleName != null ? simpleName.hashCode() : 0);
		result = 31 * result + (code != null ? code.hashCode() : 0);
		return result;
	}
}

