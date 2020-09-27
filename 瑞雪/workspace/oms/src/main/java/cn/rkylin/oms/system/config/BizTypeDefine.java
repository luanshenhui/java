package cn.rkylin.oms.system.config;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 业务类型
 */
public class BizTypeDefine implements Serializable {

	/**
	 * 业务类型：unit,station,user
	 */
	private String type;

	/**
	 * 业务类型存储时对应的表名
	 */
	private String table;
	// ElementDefine
	private ArrayList elementList;

	/**
	 * 构造函数
	 */
	public BizTypeDefine() {

	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTable() {
		return table;
	}

	public void setTable(String table) {
		this.table = table;
	}

	public ArrayList getElementList() {
		if (elementList == null)
			elementList = new ArrayList();
		return elementList;
	}

	public void setElementList(ArrayList elementList) {
		this.elementList = elementList;
	}

}
