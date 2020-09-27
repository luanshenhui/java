package cn.rkylin.oms.system.user.vo;

import cn.rkylin.oms.system.user.domain.WF_ORG_USER;

/**
 * sdfasdfasdfasdf
 * 
 * @author Administrator
 *
 */
public class UserVO extends WF_ORG_USER {
    private static final String STATUS_CHK = "<input id=\"chkItem\" name=\"chkItem\" type=\"checkbox\" userid=\"%s\" /></input>";
    /**
     * 序列
     */
    private static final long serialVersionUID = 7261100665980740680L;
    /**
     * orderBy子句
     */
    private String orderBy;
    /**
     * 搜索条件
     */
    private String searchCondition;
    /**
     * checkbox
     */
    private String chk;
    /**
     * USER_ACCOUNT_LOCKED 别名
     */
    private String locked;

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    public String getSearchCondition() {
        return searchCondition;
    }

    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }

    public String getChk() {
        return this.chk;
    }

    public void setChk(String chk) {
        this.chk = String.format(STATUS_CHK, this.getUserId()).toString();
    }

    public String getLocked() {
        return locked;
    }

    public void setLocked(String locked) {
        this.locked = locked;
    }

}
