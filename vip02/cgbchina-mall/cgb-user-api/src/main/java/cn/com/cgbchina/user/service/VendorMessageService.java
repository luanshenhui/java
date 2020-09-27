package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.VendorMessageModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by 111140821050151 on 2016/9/3.
 */
public interface VendorMessageService {

   public Response<Pager<VendorMessageModel>> findVendorMessage (@Param("pageNo") Integer pageNo,@Param("size") Integer size,@Param("User") User user, @Param("type") String type);

   /**
    * 全部标记为已读
    * @param typeId
    * @param user
    * @return
     */
   public Response<Boolean> readAll(String typeId,User user);


    /**
     * 标记为已读
     * @param id
     * @return
     */
   public Response<Boolean> readMessage(String id);
}
