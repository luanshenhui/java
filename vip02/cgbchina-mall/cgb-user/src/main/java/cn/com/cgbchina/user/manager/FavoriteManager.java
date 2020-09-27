package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.MemberGoodsFavoriteDao;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 11140721050130 on 2016/5/8.
 */
@Component
@Transactional
public class FavoriteManager {

    @Resource
    private MemberGoodsFavoriteDao memberGoodsFavoriteDao;

    public Boolean update(MemberGoodsFavoriteModel memberGoodsFavorite) {
        return memberGoodsFavoriteDao.update(memberGoodsFavorite) == 1;
    }

    /**
     * 删除用户收藏的商品(外部接口MAL303)
     * @param custId
     * @param ids
     */
    public void deletePhoneFavorite(String custId, List<String> ids) {
        MemberGoodsFavoriteModel memberGoodsFavoriteModel = null;
        for (String id : ids) {
            if (custId == null || "".equals(custId)) {        //根据收藏id删除
                memberGoodsFavoriteModel = new MemberGoodsFavoriteModel();
                memberGoodsFavoriteModel.setId(Long.valueOf(id));
            } else {                            //custId不为空，根据客户号custId和商品编码goodsId删除
                memberGoodsFavoriteModel = new MemberGoodsFavoriteModel();
                memberGoodsFavoriteModel.setCustId(custId);
                memberGoodsFavoriteModel.setItemCode(id);
            }
            memberGoodsFavoriteDao.deleteById(memberGoodsFavoriteModel);
        }
    }

    /**
     * 加入收藏(外部接口MAL301)
     * @param memberGoodsFavoriteModel
     */
    public void insertPhoneFavorite(MemberGoodsFavoriteModel memberGoodsFavoriteModel) {
        memberGoodsFavoriteDao.insert(memberGoodsFavoriteModel);
    }

    public void insert(MemberGoodsFavoriteModel memberGoodsFavoriteModel){
        memberGoodsFavoriteDao.insert(memberGoodsFavoriteModel);
    }

}
