package chinsoft.entity;

/**
 * Userdiscount entity. @author MyEclipse Persistence Tools
 */

public class Userdiscount implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Integer id;
	private String username;
	private Integer ordensize;
	private double discount;

	// Constructors

	/** default constructor */
	public Userdiscount() {
	}

	/** full constructor */
	public Userdiscount(String username, Integer ordensize,
			double discount) {
		this.username = username;
		this.ordensize = ordensize;
		this.discount = discount;
	}

	// Property accessors

	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getOrdensize() {
		return ordensize;
	}

	public void setOrdensize(Integer ordensize) {
		this.ordensize = ordensize;
	}

	public double getDiscount() {
		return discount;
	}

	public void setDiscount(double discount) {
		this.discount = discount;
	}


}