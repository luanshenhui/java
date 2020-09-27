package com.hepowdhc.dcapp.dao;

import com.hepowdhc.dcapp.bean.MapperBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by fzxs on 16-12-13.
 */
@Repository
public class TestDao extends BaseDao {


    @Autowired
    @Qualifier("dca_workflow")
    private MapperBean mapper;

    public List findBusinessData() throws Exception {


        System.out.println("+------------->" + mapper.getFields());


        String sql = mapper.getSqls().get("select");


        List<Map<String, Object>> mapList = query(sql, mapper);

        return mapList;

    }
}
