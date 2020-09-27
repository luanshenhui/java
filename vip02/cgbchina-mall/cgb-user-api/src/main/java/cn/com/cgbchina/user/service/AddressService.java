package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.Address;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * Date: 2013-03-14
 */
public interface AddressService {

	Response<List<Address>> provinces();

	Response<List<Address>> citiesOf(@Param("provinceId") Integer provinceId);

	Response<List<Address>> districtOf(@Param("cityId") Integer cityId);

	Response<Address> findById(@Param("id") Integer id);

	Response<List<Integer>> ancestorsOf(Integer anyId);

	Response<List<Address>> ancestorOfAddresses(Integer anyId);

	Response<List<Address>> getTreeOf(Integer parentId);

}
