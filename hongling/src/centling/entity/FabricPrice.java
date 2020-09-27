package centling.entity;

import java.io.Serializable;

/**
 * 面料价格表
 * @author Dirk
 *
 */
public class FabricPrice implements Serializable {
	private static final long serialVersionUID = 1L;

	/**
	 * 主键ID
	 */
	private String ID;
	
	/**
	 * 面料编号
	 */
	private String fabricCode;
	
	/**
	 * 区域编号
	 */
	private Integer areaId;
	
	/**
	 * 人民币价格
	 */
	private Double rmbPrice;
	
	/**
	 * 美元价格
	 */
	private Double dollarPrice;
	
	/**
	 * 区域名称
	 */
	private String areaName;

	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getFabricCode() {
		return fabricCode;
	}

	public void setFabricCode(String fabricCode) {
		this.fabricCode = fabricCode;
	}

	public Integer getAreaId() {
		return areaId;
	}

	public void setAreaId(Integer areaId) {
		this.areaId = areaId;
	}

	public Double getRmbPrice() {
		return rmbPrice;
	}

	public void setRmbPrice(Double rmbPrice) {
		this.rmbPrice = rmbPrice;
	}

	public Double getDollarPrice() {
		return dollarPrice;
	}

	public void setDollarPrice(Double dollarPrice) {
		this.dollarPrice = dollarPrice;
	}

	public String getAreaName() {
		return areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
}
