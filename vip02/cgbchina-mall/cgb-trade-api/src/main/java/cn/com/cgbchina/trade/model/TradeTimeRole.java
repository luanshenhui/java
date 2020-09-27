package cn.com.cgbchina.trade.model;

import java.io.Serializable;

/**
 * Created by 11140721050130 on 2016/4/3.
 */
public class TradeTimeRole implements Serializable {

	private static final long serialVersionUID = 1990266652998529098L;

	private Long id;

	private Integer waitDay;

	private Integer waitAhead;

	private Integer payDay;

	@Override
	public String toString() {
		return "TradeTimeRole{" + "id=" + id + ", waitDay=" + waitDay + ", waitAhead=" + waitAhead + ", payDay="
				+ payDay + ", payDays=" + payDays + ", payAhead=" + payAhead + ", returnDay=" + returnDay
				+ ", returnAhead=" + returnAhead + '}';
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		TradeTimeRole that = (TradeTimeRole) o;

		if (!id.equals(that.id))
			return false;
		if (!payAhead.equals(that.payAhead))
			return false;
		if (!payDay.equals(that.payDay))
			return false;
		if (!payDays.equals(that.payDays))
			return false;
		if (!returnAhead.equals(that.returnAhead))
			return false;
		if (!returnDay.equals(that.returnDay))
			return false;
		if (!waitAhead.equals(that.waitAhead))
			return false;
		if (!waitDay.equals(that.waitDay))
			return false;

		return true;
	}

	@Override
	public int hashCode() {
		int result = id.hashCode();
		result = 31 * result + waitDay.hashCode();
		result = 31 * result + waitAhead.hashCode();
		result = 31 * result + payDay.hashCode();
		result = 31 * result + payDays.hashCode();
		result = 31 * result + payAhead.hashCode();
		result = 31 * result + returnDay.hashCode();
		result = 31 * result + returnAhead.hashCode();
		return result;
	}

	private Integer payDays;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Integer getWaitDay() {
		return waitDay;
	}

	public void setWaitDay(Integer waitDay) {
		this.waitDay = waitDay;
	}

	public Integer getWaitAhead() {
		return waitAhead;
	}

	public void setWaitAhead(Integer waitAhead) {
		this.waitAhead = waitAhead;
	}

	public Integer getPayDay() {
		return payDay;
	}

	public void setPayDay(Integer payDay) {
		this.payDay = payDay;
	}

	public Integer getPayDays() {
		return payDays;
	}

	public void setPayDays(Integer payDays) {
		this.payDays = payDays;
	}

	public Integer getPayAhead() {
		return payAhead;
	}

	public void setPayAhead(Integer payAhead) {
		this.payAhead = payAhead;
	}

	public Integer getReturnDay() {
		return returnDay;
	}

	public void setReturnDay(Integer returnDay) {
		this.returnDay = returnDay;
	}

	public Integer getReturnAhead() {
		return returnAhead;
	}

	public void setReturnAhead(Integer returnAhead) {
		this.returnAhead = returnAhead;
	}

	private Integer payAhead;

	private Integer returnDay;

	private Integer returnAhead;

}
