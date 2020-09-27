package hongling.entity;

import java.io.Serializable;
import java.util.Date;
import chinsoft.entity.Dict;
/**
 * 款式 设计组合表
 * 
 * @author Administrator
 * 
 */
public class Assemble implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -1692249380547966520L;
	/** ID */
	private Integer ID;
	/** 代码 */
	private String code;
	/** 中文 标题 */
	private String titleCn;
	/** 英文标题 */
	private String titleEn;
	/** 服装分类 */
	private Integer clothingID;
	/** 款式风格 */
	private Integer styleID;
	/** 款式工艺 */
	private String process;
	/** 类似品牌 */
	private String brands;
	/** 默认面料 */
	private String defaultFabric;
	/** 适用面料 */
	private String fabrics;
	/** 特殊工艺 */
	private String specialProcess;
	/** 状态 */
	private Integer status;
	/** 创建人 */
	private String createBy;
	/** 创建时间 */
	private Date createTime;
	/** 关闭人 */
	private String closeBy;
	/** 关闭时间 */
	private Date closeTime;

	// 临时字段 显示查询页面
	private Integer number;
	private String clothName;
	private String styleName;
	private String processDesc;
	//衬衣长短袖（长袖：5000，短袖：5001）
	private Integer shirt;

	public Integer getID() {
		return ID;
	}

	public void setID(Integer iD) {
		ID = iD;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Integer getClothingID() {
		return clothingID;
	}

	public void setClothingID(Integer clothingID) {
		this.clothingID = clothingID;
	}

	public String getTitleCn() {
		return titleCn;
	}

	public void setTitleCn(String titleCn) {
		this.titleCn = titleCn;
	}

	public String getTitleEn() {
		return titleEn;
	}

	public void setTitleEn(String titleEn) {
		this.titleEn = titleEn;
	}

	// public Integer getClothingStyle() {
	// return clothingStyle;
	// }
	//
	// public void setClothingStyle(Integer clothingStyle) {
	// this.clothingStyle = clothingStyle;
	// }

	public Integer getStyleID() {
		return styleID;
	}

	public void setStyleID(Integer styleID) {
		this.styleID = styleID;
	}

	public String getProcess() {
		return process;
	}

	public void setProcess(String process) {
		this.process = process;
	}

	public String getBrands() {
		return brands;
	}

	public void setBrands(String brands) {
		this.brands = brands;
	}

	public String getFabrics() {
		return fabrics;
	}

	public void setFabrics(String fabrics) {
		this.fabrics = fabrics;
	}

	public String getSpecialProcess() {
		return specialProcess;
	}

	public void setSpecialProcess(String specialProcess) {
		this.specialProcess = specialProcess;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getCreateBy() {
		return createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getCloseBy() {
		return closeBy;
	}

	public void setCloseBy(String closeBy) {
		this.closeBy = closeBy;
	}

	public Date getCloseTime() {
		return closeTime;
	}

	public void setCloseTime(Date closeTime) {
		this.closeTime = closeTime;
	}

	public String getDefaultFabric() {
		return defaultFabric;
	}

	public void setDefaultFabric(String defaultFabric) {
		this.defaultFabric = defaultFabric;
	}

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	public String getClothName() {
		return clothName;
	}

	public void setClothName(String clothName) {
		this.clothName = clothName;
	}

	public String getStyleName() {
		return styleName;
	}

	public void setStyleName(String styleName) {
		this.styleName = styleName;
	}

	public String getProcessDesc() {
		return processDesc;
	}

	public void setProcessDesc(String processDesc) {
		this.processDesc = processDesc;
	}
	
	private Dict dict;
	public Dict getDict() {
		return dict;
	}

	public void setDict(Dict dict) {
		this.dict = dict;
	}

	public Integer getShirt() {
		return shirt;
	}

	public void setShirt(Integer shirt) {
		this.shirt = shirt;
	}
}
