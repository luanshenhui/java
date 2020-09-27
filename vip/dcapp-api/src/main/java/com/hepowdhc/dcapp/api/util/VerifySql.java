package com.hepowdhc.dcapp.api.util;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.util.JdbcUtils;
import com.alibaba.druid.wall.WallConfig;
import com.alibaba.druid.wall.WallFilter;

import java.sql.SQLException;

/**
 * sql 验证
 */

//@Component
public abstract class VerifySql extends WallFilter {

    /**
     * <h1>
     * <a id="user-content-wallconfig详细说明" class="anchor" href="#wallconfig%E8%AF%A6%E7%BB%86%E8%AF%B4%E6%98%8E" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>WallConfig详细说明</h1>
     * <p>
     * <h2>
     * <a id="user-content-本身的配置" class="anchor" href="#%E6%9C%AC%E8%BA%AB%E7%9A%84%E9%85%8D%E7%BD%AE" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>本身的配置</h2>
     * <p>
     * <table>
     * <tbody><tr>
     * <th>配置项</th>
     * <th>缺省值</th>
     * </tr>
     * <tr>
     * <td>
     * dir
     * </td>
     * <td>
     * 按照dbType分别配置: <br>
     * mysql : META-INF/druid/wall/mysql  <br>
     * oracle : META-INF/druid/wall/oracle   <br>
     * sqlserver : META-INF/druid/wall/sqlserver  <br>
     * </td>
     * </tr>
     * </tbody></table>
     * <p>
     * <h2>
     * <a id="user-content-拦截配置语句" class="anchor" href="#%E6%8B%A6%E6%88%AA%E9%85%8D%E7%BD%AE%E8%AF%AD%E5%8F%A5" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>拦截配置－语句</h2>
     * <p>
     * <table>
     * <tbody><tr>
     * <th>配置项</th>
     * <th>缺省值</th>
     * <th>描述</th>
     * </tr>
     * <tr>
     * <td>selelctAllow</td>
     * <td>true</td>
     * <td>是否允许执行SELECT语句</td>
     * </tr>
     * <tr>
     * <td>selectAllColumnAllow</td>
     * <td>true</td>
     * <td>是否允许执行SELECT * FROM T这样的语句。如果设置为false，不允许执行select * from t，但select * from (select id, name from t) a。这个选项是防御程序通过调用select *获得数据表的结构信息。
     * </td>
     * </tr>
     * <tr>
     * <td>selectIntoAllow</td>
     * <td>true</td>
     * <td>SELECT查询中是否允许INTO字句</td>
     * </tr>
     * <tr>
     * <td>deleteAllow</td>
     * <td>true</td>
     * <td>是否允许执行DELETE语句</td>
     * </tr>
     * <tr>
     * <td>updateAllow</td>
     * <td>true</td>
     * <td>是否允许执行UPDATE语句</td>
     * </tr>
     * <tr>
     * <td>insertAllow</td>
     * <td>true</td>
     * <td>是否允许执行INSERT语句</td>
     * </tr>
     * <tr>
     * <td>replaceAllow</td>
     * <td>true</td>
     * <td>是否允许执行REPLACE语句</td>
     * </tr>
     * <tr>
     * <td>mergeAllow</td>
     * <td>true</td>
     * <td>是否允许执行MERGE语句，这个只在Oracle中有用</td>
     * </tr>
     * <tr>
     * <td>callAllow</td>
     * <td>true</td>
     * <td>是否允许通过jdbc的call语法调用存储过程</td>
     * </tr>
     * <tr>
     * <td>setAllow</td>
     * <td>true</td>
     * <td>是否允许使用SET语法</td>
     * </tr>
     * <tr>
     * <td>truncateAllow</td>
     * <td>true</td>
     * <td>truncate语句是危险，缺省打开，若需要自行关闭</td>
     * </tr>
     * <tr>
     * <td>createTableAllow</td>
     * <td>true</td>
     * <td>是否允许创建表</td>
     * </tr>
     * <tr>
     * <td>alterTableAllow</td>
     * <td>true</td>
     * <td>是否允许执行Alter Table语句</td>
     * </tr>
     * <tr>
     * <td>dropTableAllow</td>
     * <td>true</td>
     * <td>是否允许修改表</td>
     * </tr>
     * <tr>
     * <td>commentAllow</td>
     * <td>false</td>
     * <td>是否允许语句中存在注释，Oracle的用户不用担心，Wall能够识别hints和注释的区别</td>
     * </tr>
     * <tr>
     * <td>noneBaseStatementAllow</td>
     * <td>false</td>
     * <td>是否允许非以上基本语句的其他语句，缺省关闭，通过这个选项就能够屏蔽DDL。</td>
     * </tr>
     * <tr>
     * <td>multiStatementAllow</td>
     * <td>false</td>
     * <td>是否允许一次执行多条语句，缺省关闭</td>
     * </tr>
     * <tr>
     * <td>useAllow</td>
     * <td>true</td>
     * <td>是否允许执行mysql的use语句，缺省打开</td>
     * </tr>
     * <tr>
     * <td>describeAllow</td>
     * <td>true</td>
     * <td>是否允许执行mysql的describe语句，缺省打开</td>
     * </tr>
     * <tr>
     * <td>showAllow</td>
     * <td>true</td>
     * <td>是否允许执行mysql的show语句，缺省打开</td>
     * </tr>
     * <tr>
     * <td>commitAllow</td>
     * <td>true</td>
     * <td>是否允许执行commit操作</td>
     * </tr>
     * <tr>
     * <td>rollbackAllow</td>
     * <td>true</td>
     * <td>是否允许执行roll back操作</td>
     * </tr>
     * </tbody></table>
     * <p>
     * <p>如果把selectIntoAllow、deleteAllow、updateAllow、insertAllow、mergeAllow都设置为false，这就是一个只读数据源了。</p>
     * <p>
     * <h2>
     * <a id="user-content-拦截配置永真条件" class="anchor" href="#%E6%8B%A6%E6%88%AA%E9%85%8D%E7%BD%AE%E6%B0%B8%E7%9C%9F%E6%9D%A1%E4%BB%B6" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>拦截配置－永真条件</h2>
     * <p>
     * <table>
     * <tbody><tr>
     * <td>配置项</td>
     * <td>缺省值</td>
     * <td>描述</td>
     * </tr>
     * <tr>
     * <td>selectWhereAlwayTrueCheck</td>
     * <td>true</td>
     * <td>检查SELECT语句的WHERE子句是否是一个永真条件</td>
     * </tr>
     * <tr><td>selectHavingAlwayTrueCheck</td>
     * <td>true</td>
     * <td>检查SELECT语句的HAVING子句是否是一个永真条件</td>
     * <p>
     * </tr><tr>
     * <td>deleteWhereAlwayTrueCheck</td>
     * <td>true</td>
     * <td>检查DELETE语句的WHERE子句是否是一个永真条件</td>
     * </tr>
     * <tr>
     * <td>deleteWhereNoneCheck</td>
     * <td>false</td>
     * <td>检查DELETE语句是否无where条件，这是有风险的，但不是SQL注入类型的风险</td>
     * </tr>
     * <tr>
     * <td>updateWhereAlayTrueCheck</td>
     * <td>true</td>
     * <td>检查UPDATE语句的WHERE子句是否是一个永真条件</td>
     * </tr>
     * <tr>
     * <td>updateWhereNoneCheck</td>
     * <td>false</td>
     * <td>检查UPDATE语句是否无where条件，这是有风险的，但不是SQL注入类型的风险</td>
     * </tr>
     * <tr>
     * <td>conditionAndAlwayTrueAllow</td>
     * <td>false</td>
     * <td>检查查询条件(WHERE/HAVING子句)中是否包含AND永真条件</td>
     * </tr>
     * <tr>
     * <td>conditionAndAlwayFalseAllow</td>
     * <td>false</td>
     * <td>检查查询条件(WHERE/HAVING子句)中是否包含AND永假条件</td>
     * </tr>
     * <tr>
     * <td>conditionLikeTrueAllow</td>
     * <td>true</td>
     * <td>检查查询条件(WHERE/HAVING子句)中是否包含LIKE永真条件</td>
     * </tr>
     * <p>
     * </tbody></table>
     * <p>
     * <h2>
     * <a id="user-content-其他拦截配置" class="anchor" href="#%E5%85%B6%E4%BB%96%E6%8B%A6%E6%88%AA%E9%85%8D%E7%BD%AE" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>其他拦截配置</h2>
     * <p>
     * <table>
     * <tbody><tr>
     * <td>配置项</td>
     * <td>缺省值</td>
     * <td>描述</td>
     * </tr>
     * <tr>
     * <td>selectIntoOutfileAllow</td>
     * <td>false</td>
     * <td>SELECT ... INTO OUTFILE 是否允许，这个是mysql注入攻击的常见手段，缺省是禁止的</td>
     * </tr>
     * <tr>
     * <td>selectUnionCheck</td>
     * <td>true</td>
     * <td>检测SELECT UNION</td>
     * </tr>
     * <tr>
     * <td>selectMinusCheck</td>
     * <td>true</td>
     * <td>检测SELECT MINUS</td>
     * </tr>
     * <tr>
     * <td>selectExceptCheck</td>
     * <td>true</td>
     * <td>检测SELECT EXCEPT</td>
     * </tr>
     * <tr>
     * <td>selectIntersectCheck</td>
     * <td>true</td>
     * <td>检测SELECT INTERSECT</td>
     * </tr>
     * <tr>
     * <td>mustParameterized</td>
     * <td>false</td>
     * <td>是否必须参数化，如果为True，则不允许类似WHERE ID = 1这种不参数化的SQL</td>
     * </tr>
     * <tr>
     * <td>strictSyntaxCheck</td>
     * <td>true</td>
     * <td>是否进行严格的语法检测，Druid SQL Parser在某些场景不能覆盖所有的SQL语法，出现解析SQL出错，可以临时把这个选项设置为false，同时把SQL反馈给Druid的开发者。</td>
     * </tr>
     * <tr>
     * <td>conditionOpXorAllow</td>
     * <td>false</td>
     * <td>查询条件中是否允许有XOR条件。XOR不常用，很难判断永真或者永假，缺省不允许。</td>
     * </tr>
     * <tr>
     * <td>conditionOpBitwseAllow</td>
     * <td>true</td>
     * <td>查询条件中是否允许有"&amp;"、"~"、"|"、"^"运算符。</td>
     * </tr>
     * <tr>
     * <td>conditionDoubleConstAllow</td>
     * <td>false</td>
     * <td>查询条件中是否允许连续两个常量运算表达式</td>
     * </tr>
     * <tr>
     * <td>minusAllow</td>
     * <td>true</td>
     * <td>是否允许SELECT * FROM A MINUS SELECT * FROM B这样的语句</td>
     * </tr>
     * <tr>
     * <td>intersectAllow</td>
     * <td>true</td>
     * <td>是否允许SELECT * FROM A INTERSECT SELECT * FROM B这样的语句</td>
     * </tr>
     * <tr>
     * <td>constArithmeticAllow</td>
     * <td>true</td>
     * <td>拦截常量运算的条件，比如说WHERE FID = 3 - 1，其中"3 - 1"是常量运算表达式。</td>
     * </tr>
     * <tr>
     * <td>limitZeroAllow</td>
     * <td>false</td>
     * <td>是否允许limit 0这样的语句</td>
     * </tr>
     * </tbody></table>
     * <p>
     * <h2>
     * <a id="user-content-禁用对象检测配置" class="anchor" href="#%E7%A6%81%E7%94%A8%E5%AF%B9%E8%B1%A1%E6%A3%80%E6%B5%8B%E9%85%8D%E7%BD%AE" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>禁用对象检测配置</h2>
     * <p>
     * <table>
     * <tbody><tr>
     * <td>配置项</td>
     * <td>缺省值</td>
     * <td>描述</td>
     * </tr>
     * <tr>
     * <td>tableCheck</td>
     * <td>true</td>
     * <td>检测是否使用了禁用的表</td>
     * </tr>
     * <tr>
     * <td>schemaCheck</td>
     * <td>true</td>
     * <td>检测是否使用了禁用的Schema</td>
     * </tr>
     * <tr>
     * <td>functionCheck</td>
     * <td>true</td>
     * <td>检测是否使用了禁用的函数</td>
     * </tr>
     * <tr>
     * <td>objectCheck</td>
     * <td>true</td>
     * <td>检测是否使用了“禁用对对象”</td>
     * </tr>
     * <tr>
     * <td>variantCheck</td>
     * <td>true</td>
     * <td>检测是否使用了“禁用的变量”</td>
     * </tr>
     * <tr>
     * <td>readOnlyTables</td>
     * <td>空</td>
     * <td>指定的表只读，不能够在SELECT INTO、DELETE、UPDATE、INSERT、MERGE中作为"被修改表"出现&lt;</td>
     * </tr>
     * </tbody></table>
     * <p>
     * <h2>
     * <a id="user-content-jdbc相关配置" class="anchor" href="#jdbc%E7%9B%B8%E5%85%B3%E9%85%8D%E7%BD%AE" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Jdbc相关配置</h2>
     * <p>
     * <table>
     * <tbody><tr>
     * <td>配置项</td>
     * <td>缺省值</td>
     * <td>描述</td>
     * </tr>
     * <tr>
     * <td>metadataAllow</td>
     * <td>true</td>
     * <td>是否允许调用Connection.getMetadata方法，这个方法调用会暴露数据库的表信息</td>
     * </tr>
     * <tr>
     * <td>wrapAllow</td>
     * <td>true</td>
     * <td>是否允许调用Connection/Statement/ResultSet的isWrapFor和unwrap方法，这两个方法调用，使得有办法拿到原生驱动的对象，绕过WallFilter的检测直接执行SQL。</td>
     * </tr>
     * </tbody></table>
     * <p>
     * <h2>
     * <a id="user-content-wallfiler配置说明" class="anchor" href="#wallfiler%E9%85%8D%E7%BD%AE%E8%AF%B4%E6%98%8E" aria-hidden="true"><svg aria-hidden="true" class="octicon octicon-link" height="16" version="1.1" viewBox="0 0 16 16" width="16"><path d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>WallFiler配置说明</h2>
     * <p>
     * <table>
     * <tbody><tr>
     * <td>配置项</td>
     * <td>缺省值</td>
     * <td>描述</td>
     * </tr>
     * <tr>
     * <td>logViolation</td>
     * <td>false</td>
     * <td>对被认为是攻击的SQL进行LOG.error输出</td>
     * </tr>
     * <tr>
     * <td>throwException</td>
     * <td>true</td>
     * <td>对被认为是攻击的SQL抛出SQLExcepton</td>
     * </tr>
     * <tr>
     * <td>config</td>
     * <td></td>
     * <td></td>
     * </tr>
     * <tr>
     * <td>provider</td>
     * <td></td>
     * <td></td>
     * </tr>
     * </tbody></table>
     * <p>
     * <p>刚开始引入WallFilter的时候，把logViolation设置为true，而throwException设置为false。就可以观察是否存在违规的情况，同时不影响业务运行。</p>
     */
    private WallConfig config = new WallConfig();

//    @Resource
//    private DataSource dataSource;


    /**
     * 验证sql的合法性
     *
     * 用法 参考 com.hepowdhc.dcapp.common.model.sql.test.SqlCheckTest
     *
     * @see
     *
     * @param sql
     * @return
     */
    public Boolean verify(String sql) {

        try {

            setDbType(JdbcUtils.ORACLE);

            setLogViolation(true);

            setConfig(config);

            super.setConfig(config);

            DruidDataSource dataSource = new DruidDataSource();

            dataSource.setName(JdbcUtils.ORACLE);

            init(dataSource);

            super.check(sql);

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public abstract void setConfig(WallConfig config);
}
