package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.BackCategoryExportDto;
import cn.com.cgbchina.item.dto.BackCategoryImportDto;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by zhoupeng on 2016/6/29.
 */
public interface BackCategoriesImportService {
    /**
     * 类目--导入
     * @param details 导入数据
     * @param user    导入者
     * @return
     */
    Response<List<BackCategoryImportDto>> importBackCategoriesData(List<BackCategoryImportDto> details, User user);

    /**
     * 类目--导出
     * @return
     */
    Response<List<BackCategoryExportDto>> exportBackCategoriesData(User user);

}
