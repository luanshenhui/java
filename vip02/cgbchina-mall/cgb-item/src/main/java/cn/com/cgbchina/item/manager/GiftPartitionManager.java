package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.EspAreaInfDao;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * Created by tongxueying on 16-6-23.
 */
@Component
@Transactional
public class GiftPartitionManager {
    @Resource
    private EspAreaInfDao espAreaInfDao;

    public boolean createPartition(EspAreaInfModel espAreaInfModel) {
        return espAreaInfDao.insert(espAreaInfModel) == 1;
    }
    public boolean update(EspAreaInfModel espAreaInfModel) {

        return espAreaInfDao.update(espAreaInfModel) == 1;
    }
    public boolean delete(EspAreaInfModel espAreaInfModel) {
        return espAreaInfDao.delete(espAreaInfModel) == 1;
    }
}
