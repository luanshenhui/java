package centling.entity;

import java.io.Serializable;


/**
 * 面料促销活动明细表
 * @author Dirk
 *
 */
public class FabricDiscountDetail implements Serializable {
	private static final long serialVersionUID = 1L;

	/**
	 * 主键
	 */
	private String ID;
	
	/**
	 * 促销活动ID
	 */
	private String fabricDiscountId;
	
	/**
	 * 用户ID
	 */
	private String memberId;

	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getFabricDiscountId() {
		return fabricDiscountId;
	}

	public void setFabricDiscountId(String fabricDiscountId) {
		this.fabricDiscountId = fabricDiscountId;
	}

	public String getMemberId() {
		return memberId;
	}

	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
}