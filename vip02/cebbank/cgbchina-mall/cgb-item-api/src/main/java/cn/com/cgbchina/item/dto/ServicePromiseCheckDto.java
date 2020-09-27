package cn.com.cgbchina.item.dto;

import java.io.Serializable;

/**
 * Created by yuxinxin on 16-6-8.
 */
public class ServicePromiseCheckDto implements Serializable {

	private static final long serialVersionUID = -7281821044590966296L;

	private boolean nameCheck;

	public boolean isNameCheck() {
		return nameCheck;
	}

	public void setNameCheck(boolean nameCheck) {
		this.nameCheck = nameCheck;
	}

	public boolean isSortCheck() {
		return sortCheck;
	}

	public void setSortCheck(boolean sortCheck) {
		this.sortCheck = sortCheck;
	}

	private boolean sortCheck;
}
