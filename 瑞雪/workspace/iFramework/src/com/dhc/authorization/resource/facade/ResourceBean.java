package com.dhc.authorization.resource.facade;

import java.io.Serializable;

/**
 * 资源Bean（资源可以是菜单项，也可以是页面元素）
 * 
 * @author
 * @version
 */
public class ResourceBean implements Serializable {
	/**
	 * 资源主键 This field corresponds to the database column WF_ORG_MENU.MENU_CODE
	 */
	private String resourceID;

	/**
	 * 父ID This field corresponds to the database column
	 * WF_ORG_MENU.PARENT_MENU_CODE
	 */
	private String parentResourceID;

	/**
	 * 资源名称 This field corresponds to the database column WF_ORG_MENU.MENU_NAME
	 */
	private String resourceName;

	/**
	 * 资源被显示的区域名称 This field corresponds to the database column
	 * WF_ORG_MENU.MENU_AREA
	 */
	private String resourceArea;

	/**
	 * 资源的URL路径（仅限于MenuItem） This field corresponds to the database column
	 * WF_ORG_MENU.MENU_LOCATION
	 */
	private String resourceLocation;

	/**
	 * 资源的Image路径 This field corresponds to the database column
	 * WF_ORG_MENU.MENU_IMG_LOCATION
	 */
	private String resourceImgLocation;

	/**
	 * 资源描述 This field corresponds to the database column WF_ORG_MENU.MENU_DESC
	 */
	private String resourceDesc;

	/**
	 * 资源的排序 This field corresponds to the database column
	 * WF_ORG_MENU.MENU_ORDER
	 */
	private int resourceOrder;

	/**
	 * 页面元素在页面上的id（仅页面元素） This field corresponds to the database column
	 * WF_ORG_MENU.MENU_ELEMENT_ID
	 */
	private String resourceElementId;

	/**
	 * 页面元素的类型
	 */
	private String resourceElementType;

	/**
	 * 资源类型（menu,element） This field corresponds to the database column
	 * WF_ORG_MENU.MENU_TYPE
	 */
	private String resourceType;

	/**
	 * 是否是缺省菜单项，即默认显示的菜单项
	 */
	private String resourceIsDefault;

	/**
	 * MenuItem的显示级别
	 */
	private int resourceLevel;

	public String getResourceID() {
		return resourceID;
	}

	public void setResourceID(String resourceID) {
		this.resourceID = resourceID;
	}

	public String getParentResourceID() {
		return parentResourceID;
	}

	public void setParentResourceID(String parentResourceID) {
		this.parentResourceID = parentResourceID;
	}

	public String getResourceName() {
		return resourceName;
	}

	public void setResourceName(String resourceName) {
		this.resourceName = resourceName;
	}

	public String getResourceArea() {
		return resourceArea;
	}

	public void setResourceArea(String resourceArea) {
		this.resourceArea = resourceArea;
	}

	public String getResourceLocation() {
		return resourceLocation;
	}

	public void setResourceLocation(String resourceLocation) {
		this.resourceLocation = resourceLocation;
	}

	public String getResourceImgLocation() {
		return resourceImgLocation;
	}

	public void setResourceImgLocation(String resourceImgLocation) {
		this.resourceImgLocation = resourceImgLocation;
	}

	public String getResourceDesc() {
		return resourceDesc;
	}

	public void setResourceDesc(String resourceDesc) {
		this.resourceDesc = resourceDesc;
	}

	public int getResourceOrder() {
		return resourceOrder;
	}

	public void setResourceOrder(int resourceOrder) {
		this.resourceOrder = resourceOrder;
	}

	public String getResourceElementId() {
		return resourceElementId;
	}

	public void setResourceElementId(String resourceElementId) {
		this.resourceElementId = resourceElementId;
	}

	public String getResourceElementType() {
		return resourceElementType;
	}

	public void setResourceElementType(String resourceElementType) {
		this.resourceElementType = resourceElementType;
	}

	public String getResourceType() {
		return resourceType;
	}

	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}

	public String getResourceIsDefault() {
		return resourceIsDefault;
	}

	public void setResourceIsDefault(String resourceIsDefault) {
		this.resourceIsDefault = resourceIsDefault;
	}

	public int getResourceLevel() {
		return resourceLevel;
	}

	public void setResourceLevel(int resourceLevel) {
		this.resourceLevel = resourceLevel;
	}

}
