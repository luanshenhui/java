package centling.dto;

public class DeliveryTrackDto implements Comparable<DeliveryTrackDto>{
	/**
	 * 序号
	 */
	private String number;
	
	/**
	 * 操作时间
	 */
	private String operateTime;
	
	/**
	 * 操作信息
	 */
	private String operateInfo;

	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public String getOperateTime() {
		return operateTime;
	}

	public void setOperateTime(String operateTime) {
		this.operateTime = operateTime;
	}

	public String getOperateInfo() {
		return operateInfo;
	}

	public void setOperateInfo(String operateInfo) {
		this.operateInfo = operateInfo;
	}

	/**
	 * 设置排列顺序
	 */
	@Override
	public int compareTo(DeliveryTrackDto o) {
		return this.operateInfo.compareTo(o.operateTime);
	}
}