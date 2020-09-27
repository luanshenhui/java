/* 
 * File license
 */
package com.dpn.ciqqlc.standard.service;

import com.dpn.ciqqlc.http.form.AuthoritiesForm;
import com.dpn.ciqqlc.http.form.ResourceForm;

/**
 * UserManageFlowService.
 * 
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 关键流程服务接口。
********************************************************************************
 * 变更履历
 * -> 
***************************************************************************** */
public interface UserManageFlowService {
    public void delUsers(String uid) throws Exception;//删除用户
    void setRole(ResourceForm resourceform) throws Exception;
	void delAuth(AuthoritiesForm authForm) throws Exception;
}