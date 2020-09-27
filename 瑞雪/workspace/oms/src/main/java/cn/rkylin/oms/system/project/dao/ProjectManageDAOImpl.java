package cn.rkylin.oms.system.project.dao;

import cn.rkylin.core.IDataBaseFactory;
import cn.rkylin.oms.system.project.vo.ProjectVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 店铺数据访问层
 *
 * @author wangxiaoyi
 * @version 1.0
 * @created 13-1月-2017 09:11:13
 */
@Repository(value = "projectManageDAO")
public class ProjectManageDAOImpl implements IProjectManageDAO {
    // 常量定义
//    private static final String STMT_DELETE_PROJECT = "deleteByPrimaryKeyShop";
    private static final String STMT_UPDATE_PROJECT = "updatePrj";
    private static final String STMT_INSERT_PROJECT = "insertPrj";

    @Autowired
    protected IDataBaseFactory dao;

    /**
     * 构造函数
     */
    public ProjectManageDAOImpl() {

    }

    /**
     * 查询项目
     *
     * @param projectVO
     */
    public List<ProjectVO> findByWhere(ProjectVO projectVO) {
        return null;
    }

    /**
     * 创建项目
     *
     * @param project
     */
    public int insert(ProjectVO project) throws Exception {
        return dao.insert(STMT_INSERT_PROJECT, project);
    }

    /**
     * 修改项目
     *
     * @param project
     */
    public int update(ProjectVO project) throws Exception {
        return dao.update(STMT_UPDATE_PROJECT, project);
    }


}