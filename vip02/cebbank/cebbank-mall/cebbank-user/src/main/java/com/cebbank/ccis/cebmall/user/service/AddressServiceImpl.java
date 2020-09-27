package com.cebbank.ccis.cebmall.user.service;

import com.cebbank.ccis.cebmall.user.dao.AddressDao;
import com.cebbank.ccis.cebmall.user.model.Address;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 */
@Service
@Slf4j
public class AddressServiceImpl implements AddressService {

	private final LoadingCache<Integer, List<Address>> children;

	private final LoadingCache<Integer, Address> self;

	private final AddressDao addressDao;

	private final List<Address> provinces;
	private final static Integer maxAddressLevel = 4;

	@Autowired
	public AddressServiceImpl(final AddressDao dao) {
		this.addressDao = dao;
		this.provinces = addressDao.findByLevel(1);
		this.children = CacheBuilder.newBuilder().build(new CacheLoader<Integer, List<Address>>() {
			@Override
			public List<Address> load(Integer id) throws Exception {
				return addressDao.findByParentId(id);
			}
		});
		this.self = CacheBuilder.newBuilder().build(new CacheLoader<Integer, Address>() {
			@Override
			public Address load(Integer id) throws Exception {
				return addressDao.findById(id);
			}
		});
	}

	@Override
	public Response<Address> findById(Integer id) {
		Response<Address> result = new Response<Address>();
		if (id == null) {
			log.error("address id can not be null");
			result.setError("params.not.null");
			return result;
		}
		try {
			Address address = self.getUnchecked(id);
			result.setResult(address);
			return result;
		} catch (Exception e) {
			log.error("find address fail address id={}, cause:{}", id, Throwables.getStackTraceAsString(e));
			result.setError("address.query.fail");
			return result;
		}
	}

	@Override
	public Response<List<Address>> provinces() {
		Response<List<Address>> result = new Response<List<Address>>();
		try {
			result.setResult(provinces);
			return result;
		} catch (Exception e) {
			log.error("find provinces fail, cause", e);
			result.setError("province.query.fail");
			return result;
		}
	}

	@Override
	public Response<List<Address>> citiesOf(Integer provinceId) {
		Response<List<Address>> result = new Response<List<Address>>();
		if (provinceId == null) {
			log.error("provinceId can not be null");
			result.setError("params.not.null");
			return result;
		}
		try {
			List<Address> addresses = children.getUnchecked(provinceId);
			result.setResult(addresses);
			return result;
		} catch (Exception e) {
			log.error("find cities of province fail,provinceId={} cause:{}", provinceId,
					Throwables.getStackTraceAsString(e));
			result.setError("city.query.fail");
			return result;
		}
	}

	@Override
	public Response<List<Address>> districtOf(Integer cityId) {
		Response<List<Address>> result = new Response<List<Address>>();
		if (cityId == null) {
			log.error("city id can not be null");
			result.setError("params.not.null");
			return result;
		}
		try {
			List<Address> addresses = children.getUnchecked(cityId);
			result.setResult(addresses);
			return result;
		} catch (Exception e) {
			log.error("find district of city fail,cityId={}, cause:{}", cityId, Throwables.getStackTraceAsString(e));
			result.setError("district.query.fail");
			return result;
		}
	}

	@Override
	public Response<List<Integer>> ancestorsOf(Integer anyId) {
		Response<List<Integer>> result = new Response<List<Integer>>();
		if (anyId == null) {
			log.error("id can not be null");
			result.setError("params.not.null");
			return result;
		}
		List<Address> addresses = Lists.newArrayListWithExpectedSize(3);
		try {
			Integer id = anyId;
			while (id > 0) {
				Address address = self.getUnchecked(id);
				addresses.add(address);
				id = address.getParentId();
			}
			List<Integer> addressIds = Lists.newArrayListWithCapacity(maxAddressLevel);
			for (Address address : addresses) {
				addressIds.add(address.getId());
			}
			// 默认添加全国
			addressIds.add(id);
			result.setResult(addressIds);
			return result;
		} catch (Exception e) {
			log.error("failed find ancestors of address(id={}), cause:{}", anyId,
					Throwables.getStackTraceAsString(e));
			result.setError("ancestor.query.fail");
			return result;
		}
	}

	@Override
	public Response<List<Address>> ancestorOfAddresses(Integer anyId) {
		Response<List<Address>> result = new Response<List<Address>>();
		if (anyId == null) {
			log.error("id can not be null");
			result.setError("params.not.null");
			return result;
		}
		List<Address> addresses = Lists.newArrayListWithExpectedSize(3);
		try {
			Integer id = anyId;
			while (id > 0) {
				Address address = self.getUnchecked(id);
				addresses.add(address);
				id = address.getParentId();
			}

			result.setResult(addresses);
			return result;
		} catch (Exception e) {
			log.error("failed find ancestors of address(id={}), cause:{}", anyId,
					Throwables.getStackTraceAsString(e));
			result.setError("ancestor.query.fail");
			return result;
		}
	}

	@Override
	public Response<List<Address>> getTreeOf(Integer parentId) {
		Response<List<Address>> result = new Response<List<Address>>();
		if (parentId == null || parentId < 0) {
			log.error("id cannot be null or negative");
			result.setError("params.not.null");
			return result;
		}

		try {
			List<Address> children = recursiveGetLeaves(this.children.getUnchecked(parentId));

			result.setResult(children);
			return result;
		} catch (Exception e) {
			log.error("`getTreeOf` invoke fail. exception detected trying get tree of parent id:{}, e:{}", parentId,
					e);
			result.setError("address.query.fail");
			return result;
		}
	}

	public List<Address> recursiveGetLeaves(List<Address> tree) {
		List<Address> leaves = Lists.newArrayList();
		leaves.addAll(tree);
		for (Address address : tree) {
			// 还有子节点
			if (address.getLevel() != 3) {
				leaves.addAll(recursiveGetLeaves(this.children.getUnchecked(address.getId())));
			}
		}
		return leaves;
	}
}
