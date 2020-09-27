package cn.rkylin.oms.common.context;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cn.rkylin.oms.system.facade.ResourceBean;
import cn.rkylin.oms.system.role.domain.WF_ORG_ROLE;

/**
 * 用户
 * 
 * @todo 当前登录的用户
 * @author wangxiaoyi
 * @version 1.0
 * @create 2017年2月15日
 */
public class CurrentUser implements Serializable {
    /**
     * 序列号
     */
    private static final long serialVersionUID = -3562152949305285046L;

    /**
     * 主键
     */
    private String id;

    /**
     * 登录帐户名
     */
    private String account;

    /**
     * 全名
     */
    private String fullName;

    /**
     * 密码
     */
    private String password;

    /**
     * 描述
     */
    private String description;

    /**
     * 是否有效
     */
    private boolean enabled;

    /**
     * 是否锁定
     */
    private boolean locked;

    /**
     * 帐号创建日期
     */
    private Date createdDate;

    /**
     * 密码修改日期
     */
    private Date pwdChangeDate;

    /**
     * 角色列表WF_ORG_ROLE
     */
    private List roleList;

    /**
     * 组织单元列表WF_ORG_UNIT
     */
    private List unitList;

    /**
     * 岗位列表WF_ORG_STATION
     */
    private List stationList;
    
    /**
     * 用户拥有的项目Id集合
     */
    private List<String> projectIdList;
    
    public List<String> getProjectIdList() {
		return projectIdList;
	}

	public void setProjectIdList(List<String> projectIdList) {
		List<String> list = new ArrayList<String>();
		list.add("03CDC4C7E55244D484727782450265D1");
		list.add("01F034521CCB4FCA909C0B4D6DE1297F");
		list.add("081EF2E7A9F2434798EDA56E08D2FFF4");
		this.projectIdList = list;
//		this.projectIdList = projectIdList;
	}

	/**
     * 用户可用的菜单
     */
    private List<ResourceBean> availableMenus;
    

	public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Date getPwdChangeDate() {
        return pwdChangeDate;
    }

    public void setPwdChangeDate(Date pwdChangeDate) {
        this.pwdChangeDate = pwdChangeDate;
    }

    public List getRoleList() {
        return roleList;
    }

    public void setRoleList(List roleList) {
        this.roleList = roleList;
    }

    public List getUnitList() {
        return unitList;
    }

    public void setUnitList(List unitList) {
        this.unitList = unitList;
    }

    public List getStationList() {
        return stationList;
    }

    public void setStationList(List stationList) {
        this.stationList = stationList;
    }

    public String getDescription() {
        return description;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public boolean isLocked() {
        return locked;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public void setLocked(boolean locked) {
        this.locked = locked;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public List<ResourceBean> getAvailableMenus() {
        return availableMenus;
    }

    public void setAvailableMenus(List<ResourceBean> availableMenus) {
        this.availableMenus = availableMenus;
    }

    public boolean hasAdminRole() {
		boolean returnValue = false;
		if (this.roleList != null) {
			for (int i = 0; i < this.roleList.size(); i++) {
				WF_ORG_ROLE role = (WF_ORG_ROLE) roleList.get(i);
				if (role.getIsAdminrole() != null && role.getIsAdminrole().equals("是")) {
					returnValue = true;
					break;
				}
			}
		}
		return returnValue;
	}

	/**
	 * 获取user的adminRole(每个用户应该只能有1个adminRole)
	 * 
	 * @return user的管理角色
	 */
	public WF_ORG_ROLE getAdminRole() {
		WF_ORG_ROLE returnValue = null;
		if (this.roleList != null) {
			for (int i = 0; i < this.roleList.size(); i++) {
				WF_ORG_ROLE role = (WF_ORG_ROLE) roleList.get(i);
				if (role.getIsAdminrole() != null && role.getIsAdminrole().equals("是")) {
					returnValue = role;
					break;
				}
			}
		}
		return returnValue;
	}
}