package cn.rkylin.oms.system.dictionary.domain;


import cn.rkylin.oms.common.base.BaseEntity;

/**
 *<p>
 * 描述: 参数访问对象
 * </p>
 *
 */
public class OMS_DICT extends BaseEntity {

	//主键，32位UUID
	private String dictId;

	//内部编码：编程时使用的字典编号
	private String dictCode;
	
	//字典分组
	private String dictType;

	//名称
	private String dictName;

	//值数据类型：0文本，1日期，2HTML，3文件
	private String dictValueType;

	public String getDictValue() {
		return dictValue;
	}

	public void setDictValue(String dictValue) {
		this.dictValue = dictValue;
	}

	//描述
	private String remark;

	//值
	private String dictValue;

	//创建时间		
	private String createTime;

	//更改时间
	private String updateTime;

	//DEFAULT 'n',
	private String deleted;

	public String getDictId() {
		return dictId;
	}

	public void setDictId(String dictId) {
		this.dictId = dictId;
	}

	public String getDictCode() {
		return dictCode;
	}

	public void setDictCode(String dictCode) {
		this.dictCode = dictCode;
	}

	public String getDictType() {
		return dictType;
	}

	public void setDictType(String dictType) {
		this.dictType = dictType;
	}

	public String getDictName() {
		return dictName;
	}

	public void setDictName(String dictName) {
		this.dictName = dictName;
	}

	public String getDictValueType() {
		return dictValueType;
	}

	public void setDictValueType(String dictValueType) {
		this.dictValueType = dictValueType;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}



	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getDeleted() {
		return deleted;
	}

	public void setDeleted(String deleted) {
		this.deleted = deleted;
	}

	
	

	
}
