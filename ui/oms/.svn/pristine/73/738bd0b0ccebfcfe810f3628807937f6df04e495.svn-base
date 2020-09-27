package cn.rkylin.oms.system.project.service;

import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.ApolloRet;
import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.project.vo.ProjectVO;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class ProjectManagerService extends ApolloService {
    @Autowired
    private IDataBaseFactory dao;

    public PageInfo<ProjectVO> findSplitProjects(int page, int rows, ProjectVO prjVO) throws Exception {
        PageInfo<ProjectVO> prjVOList = findPage(page, rows, "pageSelectSplitProject", prjVO);
        return prjVOList;
    }
    
    public PageInfo<ProjectVO> findByWhere(int page, int rows, ProjectVO prjVO) throws Exception {
        PageInfo<ProjectVO> prjVOList = findPage(page, rows, "pageSelectProject", prjVO);
        return prjVOList;
    }

    public int insertProject(ApolloMap<String, Object> params) throws Exception {
        int r = dao.insert("insertPrj", params);
        return r;
    }

    public int updateProject(ApolloMap<String, Object> params) throws Exception {
        int r = dao.update("updatePrj", params);
        return r;
    }

    public int updatePrjEnable(ApolloMap<String, Object> params) throws Exception {
        int r = dao.update("updatePrjEnable", params);
        return r;
    }

    public int updatePrjDisable(ApolloMap<String, Object> params) throws Exception {
        int r = dao.update("updatePrjDisable", params);
        return r;
    }

    public int updatePrjShopDisable(ApolloMap<String, Object> params) throws Exception {
        int r = dao.update("updatePrjShopDisable", params);
        return r;
    }

    public int deleteProject(ApolloMap<String, Object> params) throws Exception {
        int r = dao.update("deletePrj", params);
        return r;
    }

    public int deleteProjectShop(ApolloMap<String, Object> params) throws Exception {
        int r = dao.update("deletePrjShop", params);
        return r;
    }

    public int getProjectInfoByName(Map params) throws Exception {
        Map<String, Object> retMap = new HashMap<String, Object>();
        PageInfo<ApolloRet> list = dao.findByPage(1, 1, "getProjectInfoByName", params);
        if (list.getSize() > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    public int getProjectInfoByNameAndId(Map params) throws Exception {
        Map<String, Object> retMap = new HashMap<String, Object>();
        PageInfo<ApolloRet> list = dao.findByPage(1, 1, "getProjectInfoByNameAndId", params);
        if (list.getSize() > 0) {
            return 1;
        } else {
            return 0;
        }
    }

    public int getEnableShop(Map params) throws Exception {
        Map<String, Object> retMap = new HashMap<String, Object>();
        PageInfo<ApolloRet> list = dao.findByPage(1, 1, "getEnableShop", params);
        if (list.getSize() > 0) {
            return 1;
        } else {
            return 0;
        }
    }
}
