package cn.rkylin.oms.system.config;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 页面元素扩展
 */
public class BizElementExt implements Serializable {
	// BizTypeDefine
	private ArrayList bizTypeList;

	public BizElementExt() {

	}

	public void setBizTypeList(ArrayList bizTypeList) {
		this.bizTypeList = bizTypeList;
	}

	public ArrayList getBizTypeList() {
		if (bizTypeList == null)
			bizTypeList = new ArrayList();
		return bizTypeList;
	}
}
