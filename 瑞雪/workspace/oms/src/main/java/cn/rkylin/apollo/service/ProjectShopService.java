package cn.rkylin.apollo.service;

import cn.rkylin.apollo.enums.BusinessExceptionEnum;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.exception.BusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by Admin on 2016/7/2.
 */
@Service
public class ProjectShopService {

    @Autowired
    private IDataBaseFactory dao;

	public int modifyProjectShop(ApolloMap<String, Object> params) throws Exception {
		return dao.update("updateProjectShop", params);
	}

    public int addProjectShop(ApolloMap<String, Object> params) throws Exception{
        int r = dao.update("addProjectShop", params);
        if (r != 1) {
            throw new BusinessException(BusinessExceptionEnum.ADD_DATA.getC(), "新增店铺异常！");
        }
        return r;
    }



}
