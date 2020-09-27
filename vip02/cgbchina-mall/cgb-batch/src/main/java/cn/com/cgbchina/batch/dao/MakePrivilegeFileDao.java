package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.MakePrivilegeFileModel;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by w2001316 on 2016/7/28.
 */
@Repository
public class MakePrivilegeFileDao extends BaseDao {

    public List<MakePrivilegeFileModel> getTblOrderCheckList() {
        return getSqlSession().selectList("MakePrivilegeFile.findTblOrderCheckList");
    }

    public Integer updateTblOrderCheck() {
        return getSqlSession().update("MakePrivilegeFile.updateTblOrderCheck");
    }

    public Integer insertTblMkfileInf() {
        return getSqlSession().insert("MakePrivilegeFile.insertTblMkfileInf");
    }

    public Integer getTblMkFileInfocount(String date) {
        return getSqlSession().selectOne("MakePrivilegeFile.countTblMkFileInfo", date);
    }
}
