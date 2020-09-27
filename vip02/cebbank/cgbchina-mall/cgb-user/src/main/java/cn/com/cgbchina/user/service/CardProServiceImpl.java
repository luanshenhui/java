package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.CardProDao;
import cn.com.cgbchina.user.dao.LocalCardRelateDao;
import cn.com.cgbchina.user.dao.LocalProcodeDao;
import cn.com.cgbchina.user.dto.CardProDto;
import cn.com.cgbchina.user.manager.CardProManager;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.model.LocalProcodeModel;
import com.google.common.base.Optional;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * Created by 王奇 on 16-6-2.
 */

@Service
@Slf4j
public class CardProServiceImpl implements CardProService {
    @Resource
    CardProManager cardProManager;
    @Resource
    private CardProDao cardProDao;
    @Autowired
    private LocalCardRelateDao localCardRelateDao;
    @Autowired
    private LocalProcodeDao localProcodeDao;
    // 本地缓存(单品信息)
    private final LoadingCache<Long, Optional<CardPro>> cacheCardPro;
    // 本地缓存(商品信息)

    // 构造函数
    public CardProServiceImpl() {
        cacheCardPro = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
                .build(new CacheLoader<Long, Optional<CardPro>>() {
                    public Optional<CardPro> load(Long id) throws Exception {
                        // 允许为空
                        return Optional.fromNullable(cardProDao.findById(id));
                    }
                });
    }

    /**
     * 分页取得卡类卡板列表
     *
     * @param pageNo
     * @param size
     * @return
     */
    public Response<Pager<CardPro>> findAllCardPro(Integer pageNo, Integer size, User user) {
        Response<Pager<CardPro>> result = new Response<Pager<CardPro>>();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Map<String, Object> param = Maps.newHashMap();
        try {
            param.put("delFlag", Contants.DEL_FLAG_0);
            Pager<CardPro> pager = cardProDao.findAllCardPro(param, pageInfo.getOffset(), pageInfo.getLimit());
            if (pager == null) {
                result.setResult(new Pager<CardPro>(0L, Collections.<CardPro>emptyList()));
                return result;
            }
            result.setResult(pager);
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            log.error("CardProService.findByPager.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("CardProService.findByPager.fail");
            return result;
        }
    }

    /**
     * 新增/修改卡类卡板信息
     *
     * @param cardPro
     * @param user
     * @return
     */
    public Response<Map<String, Boolean>> changeCardPro(CardPro cardPro, User user) {
        // 实例化返回GoodsDetailDto的list
        Response<Map<String, Boolean>> response = new Response<Map<String, Boolean>>();
        try {
            if (cardPro == null) {
                response.setError("CardProService.add.fail");
                return response;
            }
            if (cardPro.getId() == null) {
                // 创建时间
                cardPro.setCreateTime(new Date());
                // 创建者
                cardPro.setCreateOper(user.getId());
            }
            // 修改者
            cardPro.setModifyOper(user.getId());
            // 修改时间
            cardPro.setModifyTime(new Date());
            if (cardPro.getId() == null) {
                cardProDao.insert(cardPro);
            } else {
                cardProDao.update(cardPro);
            }
            Map<String, Boolean> result = new HashMap<String, Boolean>();
            result.put("result", true);
            response.setResult(result);
            response.setSuccess(true);
        } catch (Exception e) {
            log.error("add.CardProService.error", Throwables.getStackTraceAsString(e));
        }
        // 返回执行结果
        return response;
    }

    /**
     * 根据ID取得卡类卡板信息
     *
     * @param id
     * @return
     */
    public Response<CardPro> findCardProById(String id) {
        Response<CardPro> result = new Response<CardPro>();
        Map<String, Object> param = Maps.newHashMap();
        try {
            if ("".equals(id)) {
                result.setError("CardProService.findCardProById.fail");
                return result;
            }
            Optional<CardPro> cardProModel = this.cacheCardPro.getUnchecked(Long.valueOf(id));
            if (cardProModel.isPresent()) {
                result.setResult(cardProModel.get());
            }
            return result;
        } catch (Exception e) {
            log.error("CardProService.findCardProById.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("CardProService.findCardProById.fail");
            return result;
        }
    }

    /**
     * 根据ID删除卡类卡板信息
     *
     * @param cardIds
     * @return
     */
    public Response<Map<String, Boolean>> delete(String cardIds) {
        List<String> parts = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(cardIds);
        Response<Map<String, Boolean>> response = new Response<Map<String, Boolean>>();
        Map<String, Object> param = Maps.newHashMap();
        try {
            for (String id : parts) {
                Optional<CardPro> cardProModel = this.cacheCardPro.getUnchecked(Long.valueOf(id));
                if (cardProModel.isPresent()) {
                    CardPro paramCardPro = cardProModel.get();
                    // 逻辑删除标示0未删除1已删除
                    paramCardPro.setDelFlag(Contants.DEL_FLAG_1);
                    cardProDao.update(paramCardPro);
                }
            }
            response.setSuccess(true);
            Map<String, Boolean> result = new HashMap<String, Boolean>();
            result.put("result", true);
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("CardProService.delete.fail,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("CardProService.delete.fail");
            return response;
        }
    }

    /**
     * 白金卡等级更新绑定状态
     *
     * @param cardPro
     * @return
     */
    @Override
    public Response<Boolean> updateIsBinding(CardPro cardPro) {
        Response<Boolean> response = new Response<Boolean>();
        if (StringUtils.isEmpty(cardPro.getFormatId())) {
            response.setError("not.empty");
            return response;
        }
        try {
            // 获取ID
            Boolean result = cardProManager.updateIsBinding(cardPro);
            if (!result) {
                response.setError("update.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("update.IsBinding.error", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
            return response;
        }

    }

    /**
     * 白金卡等级更新绑定状态 解绑使用
     *
     * @param formatId
     * @return
     */
    @Override
    public Response<Boolean> updateUnBinding(String formatId) {
        Response<Boolean> response = new Response<Boolean>();
        if (StringUtils.isEmpty(formatId)) {
            response.setError("not.empty");
            return response;
        }
        try {
            // 获取ID
            Boolean result = cardProManager.updateUnBinding(formatId);
            if (!result) {
                response.setError("update.error");
                return response;
            }
            response.setResult(result);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("update.IsBinding.error", Throwables.getStackTraceAsString(e));
            response.setError("update.error");
            return response;
        }

    }

    /**
     * 根据proCode取得已绑定的卡信息
     *
     * @param pageNo
     * @param size
     * @return
     */
    public Response<Pager<CardProDto>> findCardProCode(Integer pageNo, Integer size, String proCode) {
        Response<Pager<CardProDto>> result = new Response<Pager<CardProDto>>();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Map<String, Object> param = Maps.newHashMap();
        try {
            Pager<CardPro> pager = null;
            Pager<CardProDto> pagerDto = new Pager<CardProDto>();

            // 从绑定关系表中取得formatId
            List<LocalCardRelateModel> cardRelateAll = localCardRelateDao.findFormatIdAll(proCode);
            if (cardRelateAll!= null && cardRelateAll.size() == 0) {
                result.setSuccess(true);
                return result;
            }
            List<String> formats = new ArrayList<>();

            // 循环取出formatId 然后去卡类卡版表中获取对应的卡数据以供页面展示
            for (LocalCardRelateModel localCardRelateModel : cardRelateAll) {
                formats.add(localCardRelateModel.getFormatId());
            }
            param.put("formatId", formats);
            // 取出卡类卡板信息放到Dto中方便使用
            pager = cardProDao.findCardProProCode(param, pageInfo.getOffset(), pageInfo.getLimit());
            if (pager == null) {
                result.setResult(new Pager<CardProDto>(0L, Collections.<CardProDto>emptyList()));
                return result;
            }
            // 通过proCode查询proNm
            LocalProcodeModel localProcodeModel = localProcodeDao.findByProCode(proCode);
            String proName = "";
            if (localProcodeModel != null) {
                proName = localProcodeModel.getProNm();// 参数名称
            }
            // 循环插入到Dto中
            List<CardProDto> CardProDtos = new ArrayList<>();
            for (int i = 0; i < pager.getData().size(); i++) {
                CardProDto cardProDto = new CardProDto();
                cardProDto.setCardPro(pager.getData().get(i));// 绑定卡板和品类卡板名称
                cardProDto.setProNm(proName);// 参数名称
                CardProDtos.add(cardProDto);
            }

            pagerDto.setData(CardProDtos);
            pagerDto.setTotal(pager.getTotal());
            result.setResult(pagerDto);
            result.setSuccess(true);
            return result;
        } catch (Exception e) {
            log.error("CardProService.findCardProProCode.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("CardProService.findCardProProCode.fail");
            return result;
        }
    }

}