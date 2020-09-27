package com.hepowdhc.dcapp.bean;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.LinkedCaseInsensitiveMap;

import java.sql.Clob;
import java.sql.NClob;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.MessageFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;
import java.util.Objects;

/**
 * Created by fzxs on 16-12-13.
 */
public final class MapperBean {

    private final Logger logger = LoggerFactory.getLogger(getClass());

    private Map<String, String> sqls;

    private Map<String, String> fields;

    public Map<String, String> getSqls() {
        return sqls;
    }

    public void setSqls(Map<String, String> sqls) {
        this.sqls = sqls;
    }

    public Map<String, String> getFields() {
        return fields;
    }

    public void setFields(Map<String, String> fields) {
        this.fields = fields;
    }

    public Map<String, Object> copy(ResultSet res) {

        Map<String, Object> map = new LinkedCaseInsensitiveMap<>();

        fields.forEach((k, v) -> {

            logger.debug(k + "=>" + v);

            String[] keys = k.split("::");

            try {

                logger.debug(MessageFormat.format("====>{0}", Arrays.asList(v, res.getObject(v))));

                switch (StringUtils.lowerCase(keys[1])) {

                    case "varchar": {

                        map.put(keys[0], res.getString(v));

                        break;

                    }

                    case "nvarchar": {

                        map.put(keys[0], res.getNString(v));

                        break;

                    }
                    case "clob": {

                        Clob obj = res.getClob(v);

                        if (Objects.nonNull(obj)) {

                            map.put(keys[0], IOUtils.toString(obj.getCharacterStream()));
                        }

                        break;
                    }

                    case "nclob": {

                        NClob obj = res.getNClob(v);

                        if (Objects.nonNull(obj)) {

                            map.put(keys[0], IOUtils.toString(obj.getCharacterStream()));

                        }

                        break;
                    }

                    case "int": {

                        map.put(keys[0], res.getInt(v));

                        break;
                    }
                    case "date": {

                        Timestamp obj = res.getTimestamp(v);

                        if (Objects.nonNull(obj)) {

                            map.put(keys[0], new Date(obj.getTime()));

                        }

                        break;

                    }

                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        });

        return map;

    }
}
