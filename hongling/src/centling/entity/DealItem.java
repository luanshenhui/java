package centling.entity;

import java.io.Serializable;

public class DealItem implements Serializable {
	private static final long serialVersionUID = 7388788654956669452L;
	private Integer ID;         // ID
	private String memo;        // 备注
	private String name;        // 交易项目名称
	private Integer ioFlag;     // 收入支出标志
	private String en;			// 英文名称
	
	public String getEn() {
		return en;
	}
	public void setEn(String en) {
		this.en = en;
	}
	public Integer getID() {
		return ID;
	}
	public void setID(Integer iD) {
		ID = iD;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getIoFlag() {
		return ioFlag;
	}
	public void setIoFlag(Integer ioFlag) {
		this.ioFlag = ioFlag;
	}
}
