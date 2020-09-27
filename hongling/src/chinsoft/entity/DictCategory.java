package chinsoft.entity;


/**
 * Dictcategory entity. @author MyEclipse Persistence Tools
 */

public class DictCategory implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 8976729804680015200L;
	private Integer ID;
	private String name;
	private Integer readonly;
	private Integer levels;
	private String constDefine;

	// Constructors

	/** default constructor */
	public DictCategory() {
	}

	/** minimal constructor */
	public DictCategory(Integer ID, String name, String constDefine) {
		this.ID = ID;
		this.name = name;
		this.constDefine = constDefine;
	}

	/** full constructor */
	public DictCategory(Integer ID, String name, Integer readonly,Integer levels, String constDefine) {
		this.ID = ID;
		this.name = name;
		this.readonly = readonly;
		this.levels = levels;
		this.constDefine = constDefine;
	}

	// Property accessors

	public Integer getID() {
		return this.ID;
	}

	public void setID(Integer ID) {
		this.ID = ID;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getReadonly() {
		return this.readonly;
	}

	public void setReadonly(Integer readonly) {
		this.readonly = readonly;
	}

	public Integer getLevels() {
		return this.levels;
	}

	public void setLevels(Integer levels) {
		this.levels = levels;
	}

	public String getConstDefine() {
		return this.constDefine;
	}

	public void setConstDefine(String constDefine) {
		this.constDefine = constDefine;
	}

}