package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsRegionModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsRegionDao extends SqlSessionDaoSupport {

    public Integer update(GoodsRegionModel goodsRegion) {
        return getSqlSession().update("GoodsRegionModel.update", goodsRegion);
    }


    public Integer insert(GoodsRegionModel goodsRegion) {
        return getSqlSession().insert("GoodsRegionModel.insert", goodsRegion);
    }


    public List<GoodsRegionModel> findAll() {
        return getSqlSession().selectList("GoodsRegionModel.findAll");
    }


    public GoodsRegionModel findById(Long id) {
        return getSqlSession().selectOne("GoodsRegionModel.findById", id);
    }


    public Pager<GoodsRegionModel> findByPage(Map<String, Object> params, int offset, int limit) {
        Long total = getSqlSession().selectOne("GoodsRegionModel.pageCount", params);
        if (total == 0) {
            return Pager.empty(GoodsRegionModel.class);
        }
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!params.isEmpty()) {
            paramMap.putAll(params);
        }
        paramMap.put("offset", offset);
        paramMap.put("limit", limit);
        List<GoodsRegionModel> data = getSqlSession().selectList("GoodsRegionModel.pager", paramMap);
        return new Pager<GoodsRegionModel>(total, data);
    }


    public Integer delete(GoodsRegionModel goodsRegion) {
        return getSqlSession().delete("GoodsRegionModel.delete", goodsRegion);
    }

    /**
     * 检验分区名称是否存在
     *
     * @param name
     * @return
     */
    public Long checkGiftpartition(String name) {
        Long total = getSqlSession().selectOne("GoodsRegionModel.checkGiftPartition", name);
        return total;
    }

    /**
     * 检验分区code是否存在
     *
     * @param code
     * @return
     */
    public Long checkpartitionCode(String code) {
        Long total = getSqlSession().selectOne("GoodsRegionModel.checkPartitionCode", code);
        return total;
    }

    /**
     * 顺序重复校验
     *
     * @param sort
     * @return
     */
    public Long checkpartitionSort(Integer sort) {
        Long total = getSqlSession().selectOne("GoodsRegionModel.checkPartitionSort", sort);
        return total;
    }
}