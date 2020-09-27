/* 
 * File license
 */
package com.dpn.ciqqlc.standard.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dpn.ciqqlc.http.form.AuthoritiesForm;
import com.dpn.ciqqlc.http.form.ResourceForm;
import com.dpn.ciqqlc.standard.service.UserManageDbService;
import com.dpn.ciqqlc.standard.service.UserManageFlowService;

/**
 * UserManageFlow.
 * 
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 关键流程服务实现。
 ********************************************************************************
 * 变更履历
 * -> 
 ***************************************************************************** */
@Service("userManageFlowService")
public class UserManageFlow
        implements UserManageFlowService {
        
    /* **** fields ********************************************************** */
    
    /* external */
    
    /* internal */
    
    /**
     * dbServ.
     * 
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("userManageDbServ")
    private UserManageDbService dbServ = null; /* 数据库服务对象。 */
    
    @Transactional("blankTM")
	public void setRole(ResourceForm resourceform) throws Exception {
    	
    	dbServ.delResRole(resourceform.getResid());//先将RES_ROLE表中该资源ID对应的所有记录删除
		for(int i=0;i<resourceform.getRolesbox().length;i++){
			Map<String,String> map = new HashMap<String,String>();
			map.put("res_id", resourceform.getResid());
			map.put("role_id", resourceform.getRolesbox()[i]);
			map.put("creator", resourceform.getCreator());
			dbServ.setRole(map);
			map = null;
		}
	}
    
    @Transactional("blankTM")
    public void delUsers(String uid) throws Exception {
        Map<String, String> map = new HashMap<String, String>();
        map.put("userid", uid);
        dbServ.delUsers(uid);
        dbServ.delAuth(map);
    }

    @Transactional("blankTM")
	public void delAuth(AuthoritiesForm authForm) throws Exception {

    	Map<String,String> map = new HashMap<String,String>();
    	for (int i = 0; authForm.getIsBuy() != null
				&& i < authForm.getIsBuy().length; i++) {
			String id[] = authForm.getIsBuy()[i].split("-");
			map.put("userid", id[0]);
			map.put("rolesid", id[1]);
			this.dbServ.delAuth(map);
		}
		map = null;
	}
                                                
                                                
    /* **** static blocks *************************************************** */
    
    /* **** constructors **************************************************** */
    
    /* **** methods ********************************************************* */
    
    /* abstract */
    
    /* override */
    
    // UserManageFlowService.
    
    /* external */
    
    /* internal */
    
    /* **** inner classes *************************************************** */
    
}
