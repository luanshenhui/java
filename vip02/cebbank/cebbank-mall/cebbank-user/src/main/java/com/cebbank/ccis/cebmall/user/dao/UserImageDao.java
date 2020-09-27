package com.cebbank.ccis.cebmall.user.dao;

import com.cebbank.ccis.cebmall.user.model.UserImage;
import com.google.common.base.MoreObjects;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@Repository
public class UserImageDao extends SqlSessionDaoSupport {
    public UserImage findById(Long id) {
        return getSqlSession().selectOne("UserImage.findById", id);
    }

    public Integer totalCountOf(String userId) {
        return getSqlSession().selectOne("UserImage.totalCountOf", userId);
    }

    public Pager<UserImage> findByUserIdAndCategory(String userId, String category, Integer offset, Integer pageSize) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("userId", userId);
        params.put("category", category);
        params.put("offset", offset);
        params.put("limit", pageSize);
        Integer count = getSqlSession().selectOne("UserImage.countByUserIdAndCategory", params);
        if (count == 0) {
            return new Pager<UserImage>(0L, Collections.<UserImage>emptyList());
        }
        List<UserImage> userImages = getSqlSession().selectList("UserImage.findByUserIdAndCategory", params);
        return new Pager<UserImage>(count.longValue(), userImages);
    }


    public void create(UserImage userImage) {
        getSqlSession().insert("UserImage.create", userImage);
    }

    public void delete(Long id) {
        getSqlSession().delete("UserImage.delete", id);
    }

    public void deleteByUserId(String userId) {
        getSqlSession().delete("UserImage.deleteByUserId", userId);
    }

    public long totalSizeByUserId(String userId) {
        Long total = getSqlSession().selectOne("UserImage.totalSize", userId);
        return MoreObjects.firstNonNull(total, 0L);
    }
}
