package hongling.entity;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Logistics entity. @author MyEclipse Persistence Tools
 */

public class Logistics implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private String sendto;
	private String sendend;
	private String sendmode;
	private Integer sendcount;
	private double MT_Price;
	private double MXF_Price;
	private double MXK_Price;
	private double MDY_Price;
	private double MMJ_Price;
	private double MXQ_Price;
	private double MCY_Price;
	private double MPO_Price;
	private String company;
	private String createby;
	private Date createtime;
	private String closeby;
	private Timestamp closetime;
	private String remark;
	private Integer status;
	private LogisticsCompany logisticsCompany;
	
	// Constructors

	public LogisticsCompany getLogisticsCompany() {
		return logisticsCompany;
	}

	public void setLogisticsCompany(LogisticsCompany logisticsCompany) {
		this.logisticsCompany = logisticsCompany;
	}

	/** default constructor */
	public Logistics() {
	}

	public Logistics(Integer id, String sendto, String sendend,
			String sendmode, Integer sendcount, double t_Price,
			double mXF_Price, double mXK_Price, double mDY_Price,
			double mMJ_Price, double mXQ_Price, double mCY_Price,
			double mPO_Price, String company, String createby,
			Date createtime, String closeby, Timestamp closetime, String remark,
			Integer status) {
		super();
		this.id = id;
		this.sendto = sendto;
		this.sendend = sendend;
		this.sendmode = sendmode;
		this.sendcount = sendcount;
		MT_Price = t_Price;
		MXF_Price = mXF_Price;
		MXK_Price = mXK_Price;
		MDY_Price = mDY_Price;
		MMJ_Price = mMJ_Price;
		MXQ_Price = mXQ_Price;
		MCY_Price = mCY_Price;
		MPO_Price = mPO_Price;
		this.company = company;
		this.createby = createby;
		this.createtime = createtime;
		this.closeby = closeby;
		this.closetime = closetime;
		this.remark = remark;
		this.status = status;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getSendto() {
		return this.sendto;
	}

	public void setSendto(String sendto) {
		this.sendto = sendto;
	}

	public String getSendend() {
		return this.sendend;
	}

	public void setSendend(String sendend) {
		this.sendend = sendend;
	}

	public String getSendmode() {
		return this.sendmode;
	}

	public void setSendmode(String sendmode) {
		this.sendmode = sendmode;
	}

	public Integer getSendcount() {
		return this.sendcount;
	}

	public void setSendcount(Integer sendcount) {
		this.sendcount = sendcount;
	}

	

	public String getCompany() {
		return this.company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public String getCreateby() {
		return this.createby;
	}

	public void setCreateby(String createby) {
		this.createby = createby;
	}

	public Date getCreatetime() {
		return this.createtime;
	}

	public void setCreatetime(Date createtime) {
		this.createtime = createtime;
	}

	public String getCloseby() {
		return this.closeby;
	}

	public void setCloseby(String closeby) {
		this.closeby = closeby;
	}

	public Timestamp getClosetime() {
		return this.closetime;
	}

	public void setClosetime(Timestamp closetime) {
		this.closetime = closetime;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	

	public double getMT_Price() {
		return MT_Price;
	}

	public void setMT_Price(double mT_Price) {
		MT_Price = mT_Price;
	}

	public double getMXF_Price() {
		return MXF_Price;
	}

	public void setMXF_Price(double mXF_Price) {
		MXF_Price = mXF_Price;
	}

	public double getMXK_Price() {
		return MXK_Price;
	}

	public void setMXK_Price(double mXK_Price) {
		MXK_Price = mXK_Price;
	}

	public double getMDY_Price() {
		return MDY_Price;
	}

	public void setMDY_Price(double mDY_Price) {
		MDY_Price = mDY_Price;
	}

	public double getMMJ_Price() {
		return MMJ_Price;
	}

	public void setMMJ_Price(double mMJ_Price) {
		MMJ_Price = mMJ_Price;
	}

	public double getMXQ_Price() {
		return MXQ_Price;
	}

	public void setMXQ_Price(double mXQ_Price) {
		MXQ_Price = mXQ_Price;
	}

	public double getMCY_Price() {
		return MCY_Price;
	}

	public void setMCY_Price(double mCY_Price) {
		MCY_Price = mCY_Price;
	}

	public double getMPO_Price() {
		return MPO_Price;
	}

	public void setMPO_Price(double mPO_Price) {
		MPO_Price = mPO_Price;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	
	

}