
package centling.entity;

import java.io.Serializable;

public class ExpressCom implements Serializable {
	private static final long serialVersionUID = -2382458883637221798L;
	private String ID;           // ID
	private String name;         // 快递公司名
	private String addr;         // 地址
	private String tel;          // 电话
	private String mobile;       // 手机
	private String linkMan;      // 联系人
	private String shortname;    // 简称
	private String memo;         // 备注
	private Integer seq;         // 显示顺序
	private Integer number;      // 序号
	private Integer statusID;    // 是否禁用
	
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getShortname() {
		return shortname;
	}
	public void setShortname(String shortname) {
		this.shortname = shortname;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getLinkMan() {
		return linkMan;
	}
	public void setLinkMan(String linkMan) {
		this.linkMan = linkMan;
	}
	public Integer getSeq() {
		return seq;
	}
	public void setSeq(Integer seq) {
		this.seq = seq;
	}
	public Integer getNumber() {
		return number;
	}
	public void setNumber(Integer number) {
		this.number = number;
	}
	public Integer getStatusID() {
		return statusID;
	}
	public void setStatusID(Integer statusID) {
		this.statusID = statusID;
	}
}