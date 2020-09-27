package cn.com.cgbchina.item.dto;

import com.spirit.Annotation.Param;
import com.spirit.search.Pair;
import com.spirit.search.SearchFacet;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

/**
 * Created by 11140721050130 on 2016/9/9.
 */
@EqualsAndHashCode
@ToString
public class BrandPair extends SearchFacet {

    @Getter
    private String initial;

    public BrandPair(Long id, Long count) {
        super(id, count);
    }

    public BrandPair(Long id, Long count, String name) {
        super(id, count, name);
    }
    public BrandPair(Long id, Long count, String name,String initial) {
        super(id, count, name);
        this.initial = initial;
    }
}
