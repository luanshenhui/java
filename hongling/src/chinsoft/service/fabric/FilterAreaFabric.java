package chinsoft.service.fabric;

import java.util.ArrayList;
import java.util.List;

import centling.business.FabricPriceManager;
import centling.entity.FabricPrice;
import chinsoft.entity.Fabric;

public class FilterAreaFabric {
	private FabricPriceManager fabricPriceManager = new FabricPriceManager();

	public FilterAreaFabric() {

	}

	/**
	 * 检验面料信息 是否是当前用户 所在经销商 所维护价格的面料
	 * 
	 * @param areaid
	 * @param fabric
	 * @return
	 */
	public boolean isOurFabric(int areaid, Fabric fabric) {
		boolean isOurFabric = false;

		try {
			List<FabricPrice> fabricPrices = fabricPriceManager
					.findFabricPriceByCode(fabric.getCode());
			for (FabricPrice fabricPrice : fabricPrices) {
				if (fabricPrice.getAreaId() == areaid) {
					isOurFabric = true;
					break;
				}
			}
			return isOurFabric;
		} catch (Exception e) {
			// System.out.println("当前登陆用户所在经销商没有维护 此默认面料的价格");
			return false;
		}
	}

	/**
	 * 检验面料信息 是否是当前用户 所在经销商 所维护价格的面料
	 * 
	 * @param areaid
	 * @param fabric
	 * @return
	 */
	public boolean isOurFabric(int areaid, String fabricCode) {
		boolean isOurFabric = false;

		try {
			List<FabricPrice> fabricPrices = fabricPriceManager
					.findFabricPriceByCode(fabricCode);
			for (FabricPrice fabricPrice : fabricPrices) {
				if (fabricPrice.getAreaId() == areaid) {
					isOurFabric = true;
					break;
				}
			}
			return isOurFabric;
		} catch (Exception e) {
			// System.out.println("当前登陆用户所在经销商没有维护 此默认面料的价格");
			return false;
		}
	}

	public boolean filterLeftOurFabrics(int areaid, List<Fabric> fabricList) {
		List<Fabric> targetList = new ArrayList<Fabric>();
		for (Fabric fabric : fabricList) {
			if (this.isOurFabric(areaid, fabric)) {
				targetList.add(fabric);
			}
		}

		return false;
	}
}
