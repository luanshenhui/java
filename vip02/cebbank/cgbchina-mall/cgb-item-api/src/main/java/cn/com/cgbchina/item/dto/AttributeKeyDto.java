package cn.com.cgbchina.item.dto;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 郝文佳 on 2016/4/22.
 */
public class AttributeKeyDto implements Serializable {

    private static final long serialVersionUID = -7320742602621564472L;
    @Setter
    @Getter
    private String id;
    @Setter
    @Getter
    private String name;

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;

        AttributeKeyDto that = (AttributeKeyDto) o;

        return Objects.equal(this.id, that.id) && Objects.equal(this.name, that.name);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id, name);
    }

    @Override
    public String toString() {
        return MoreObjects.toStringHelper(this).add("id", id).add("name", name).toString();
    }
}
