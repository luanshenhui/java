package com.dhc.base.menu.vo;

public class MenuTreeVO {

	private String menuCode;
	private String userID;
	private String menuName;
	private String menuLocation;
	private int favouriteOrder;

	/**
	 * @return the menuCode
	 */
	public String getMenuCode() {
		return menuCode;
	}

	/**
	 * @param menuCode
	 *            the menuCode to set
	 */
	public void setMenuCode(String menuCode) {
		this.menuCode = menuCode;
	}

	/**
	 * @return the userID
	 */
	public String getUserID() {
		return userID;
	}

	/**
	 * @param userID
	 *            the userID to set
	 */
	public void setUserID(String userID) {
		this.userID = userID;
	}

	/**
	 * @return the menuName
	 */
	public String getMenuName() {
		return menuName;
	}

	/**
	 * @param menuName
	 *            the menuName to set
	 */
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	/**
	 * @return the menuLocation
	 */
	public String getMenuLocation() {
		return menuLocation;
	}

	/**
	 * @param menuLocation
	 *            the menuLocation to set
	 */
	public void setMenuLocation(String menuLocation) {
		this.menuLocation = menuLocation;
	}

	/**
	 * @return the favouriteOrder
	 */
	public int getFavouriteOrder() {
		return favouriteOrder;
	}

	/**
	 * @param favouriteOrder
	 *            the favouriteOrder to set
	 */
	public void setFavouriteOrder(int favouriteOrder) {
		this.favouriteOrder = favouriteOrder;
	}
}
