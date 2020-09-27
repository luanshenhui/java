/**
 * @author：杨磊
 * @date：2013-6-20-下午4:42:32
 */
package rcmtm.entity;

public class OrdenBatch {
	
	private Integer ID;
	private String batchNo;// 批次号
	private String ordenIDs;// 订单号
	private String sysCodes;//系统单号
	private Integer status;//状态(-1 不提交,0 正常,1 提交)
	
	public Integer getID() {
		return ID;
	}
	public void setID(Integer ID) {
		this.ID = ID;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public String getOrdenIDs() {
		return ordenIDs;
	}
	public void setOrdenIDs(String ordenIDs) {
		this.ordenIDs = ordenIDs;
	}
	public String getSysCodes() {
		return sysCodes;
	}
	public void setSysCodes(String sysCodes) {
		this.sysCodes = sysCodes;
	}
}
