/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/7/12.
 */


public class ItemStockDto implements Serializable {

    private static final long serialVersionUID = 6970104564685859372L;

    @Getter
    @Setter
    private String itemCode;
    @Getter
    @Setter
    private Long stock;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        ItemStockDto that = (ItemStockDto) o;

        return Objects.equal(this.itemCode, that.itemCode) &&
                Objects.equal(this.stock, that.stock);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(itemCode, stock);
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this)
                .add("itemCode", itemCode)
                .add("stock", stock)
                .toString();
    }
}

