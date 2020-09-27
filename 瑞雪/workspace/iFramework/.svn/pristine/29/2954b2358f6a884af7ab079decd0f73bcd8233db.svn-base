package com.dhc.organization.common.data;

import java.io.Serializable;

public class BaseVO implements Serializable {
	private static final int DEFAULT_PAGE_SIZE = 10;
	/**
	 * 开始行数，用于分页查询
	 */
	private int startRow;

	/**
	 * 结束行数，用于分页查询
	 */
	private int endRow;

	/**
	 * 每页行数
	 */
	private int pageSize = DEFAULT_PAGE_SIZE;

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}
}
