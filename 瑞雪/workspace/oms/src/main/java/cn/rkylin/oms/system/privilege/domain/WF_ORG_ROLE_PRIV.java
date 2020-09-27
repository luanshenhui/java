package cn.rkylin.oms.system.privilege.domain;

import cn.rkylin.oms.common.base.BaseEntity;

public class WF_ORG_ROLE_PRIV extends BaseEntity {

    /**
     * 
     */
    private static final long serialVersionUID = -975906047778842683L;
    private String rolePrivId;
    private String roleId;
    private String rolePrivType;
    private String privId;
    private String privName;
    public String getRolePrivId() {
        return rolePrivId;
    }
    public void setRolePrivId(String rolePrivId) {
        this.rolePrivId = rolePrivId;
    }
    public String getRoleId() {
        return roleId;
    }
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
    public String getRolePrivType() {
        return rolePrivType;
    }
    public void setRolePrivType(String rolePrivType) {
        this.rolePrivType = rolePrivType;
    }
    public String getPrivId() {
        return privId;
    }
    public void setPrivId(String privId) {
        this.privId = privId;
    }
    public String getPrivName() {
        return privName;
    }
    public void setPrivName(String privName) {
        this.privName = privName;
    }
    
    

}
