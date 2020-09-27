package cn.com.cgbchina.item.service;

import com.spirit.common.model.Response;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/5.
 */
public interface ItemIndexService {

    /**
     * 重建索引
     */
    public void fullItemIndex();

    /**
     * 删除所有索引
     */
    public Response<Boolean>  deleteAllIndex();

    /**
     * 按时间戳增量更新索引
     *
     * @param interval
     */
    public Response<Boolean> deltaDump(Integer interval);

    /**
     * 实时增量更新索引
     */
    public void deltaItemIndex(String itemId);

    /**
     * 实时删除索引
     *
     * @param itemId
     * @return
     */
    public void deleteItemIndex(String itemId);
}
