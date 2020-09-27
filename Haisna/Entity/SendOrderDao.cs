using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System;
using System.Transactions;
using Hainsi.Entity.Model.SendKarteOrder;
using Hainsi.Entity.Model.OrderedDoc2;
using Hainsi.Entity.Model.OrderedItem2;

namespace Hainsi.Entity
{
    /// <summary>
    /// オーダ送信データアクセスオブジェクト
    /// </summary>
    public class SendOrderDao : AbstractDao
    {
        /// <summary>
        /// 送信区分（送信済み）
        /// </summary>
        private static readonly int SENDDIV_SENT = 1;

        /// <summary>
        /// 汎用分類コード（オーダ種別）
        /// </summary>
        private static readonly string FREECLASSCD_ORD = "ORD";

        /// <summary>
        /// 汎用分類コード（オーダ依頼情報）
        /// </summary>
        private const string FREECLASSCD_SEND = "ODR";

        /// <summary>
        /// 診コード
        /// </summary>
        private static readonly string SINCD = "VC";

        /// <summary>
        /// 検査項目コード（感染症区分）
        /// </summary>
        private static readonly string ITEMCD_KANSENSHO = "80017";

        /// <summary>
        /// サフィックス（感染症区分）
        /// </summary>
        private static readonly string SUFFIX_KANSENSHO = "00";

        /// <summary>
        /// オーダ種別
        /// </summary>
        private const string ORDERDIV_LAINS = "ORDDIV000001";        //検体検査
        private const string ORDERDIV_BLAD = "ORDDIV000002";         //輸血検査
        private const string ORDERDIV_LB = "ORDDIV000003";           //血型＋検体検査
        private const string ORDERDIV_KAKUTAN = "ORDDIV000004";      //喀痰
        private const string ORDERDIV_FUJINKA = "ORDDIV000005";      //婦人科
        private const string ORDERDIV_KYOBUXP = "ORDDIV000009";      //胸部Ｘ線

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public SendOrderDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 送信オーダ文書情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="ordDiv">オーダ区分</param>
        /// <returns>送信オーダ文書情報</returns>
        public List<dynamic> SelectOrderedDoc(int rsvNo, string ordDiv)
        {
            // SQL定義
            string sql = @"
                    select
                        ordereddoc.rsvno
                        , ordereddoc.orderdiv
                        , ordereddoc.orderdate
                        , ordereddoc.orderno
                        , ordereddoc.receno
                        , ordereddoc.senddiv
                        , ordereddoc.senddate
                        , ordereddoc.ipaddress
                        , ordereddoc.orderdoc
                        , free.freefield1
                        , person.perid
                        , person.lastname || '　' || person.firstname name_n
                        , person.lastkname || '　' || person.firstkname name_k
                        , person.romename
                        , person.gender
                        , to_char(person.birth, 'yyyymmdd') birthdate 
                    from
                        ordereddoc 
                        left join consult 
                            on ordereddoc.rsvno = consult.rsvno 
                        left join person 
                            on consult.perid = person.perid
                        , free 
                    where
                        ordereddoc.rsvno = :rsvno 
                        and ordereddoc.orderdiv = free.freecd 
                        and ordereddoc.senddiv = :senddiv 
                        and free.freeclasscd = :freeclasscd 
                        and free.freefield1 = :odrdiv 
                    order by
                        rsvno asc
                        , orderdiv asc
            ";

            // パラメータ
            var sqlParam = new
            {
                rsvno = rsvNo,
                senddiv = SENDDIV_SENT,
                freeclasscd = FREECLASSCD_ORD,
                odrdiv = ordDiv,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 送信電文の連番を取得する
        /// </summary>
        /// <returns>連番</returns>
        public int SelectSeqNo()
        {
            // SQL定義
            string sql = @"
                    select
                        sendno.nextval seqno 
                    from
                        dual
            ";

            // SQL実行
            dynamic result = connection.Query(sql).FirstOrDefault();

            // 戻り値設定
            return (result == null) ? 0 : (int)result.SEQNO;
        }

        /// <summary>
        /// オーダ送信テーブルのレコードを登録する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="odrDiv">オーダ区分</param>
        /// <param name="tskDiv">処理区分</param>
        /// <param name="orderDiv">旧オーダ区分</param>
        /// <param name="sendDiv">送信区分</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <returns></returns>
        public int InsertOrderTbl(int rsvNo, int odrDiv, int tskDiv, string orderDiv, int sendDiv, int orderNo)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                string sql = @"
                        insert 
                        into ordertbl( 
                            orderdate
                            , rsvno
                            , odrdiv
                            , tskdiv
                            , orderdiv
                            , senddiv
                            , orderno
                        ) 
                        values ( 
                            sysdate
                            , :rsvno
                            , :odrdiv
                            , :tskdiv
                            , :orderdiv
                            , :senddiv
                            , :orderno
                        ) 
                ";

                // パラメータ
                var sqlParam = new
                {
                    rsvno = rsvNo,
                    odrdiv = odrDiv,
                    tskdiv = tskDiv,
                    orderdiv = orderDiv,
                    senddiv = sendDiv,
                    orderno = orderNo,
                };

                // SQL実行
                var result = connection.Execute(sql, sqlParam);
                if (result == 0)
                {
                    return 0;
                }

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }

        /// <summary>
        /// 送信オーダ文書情報テーブルのオーダ送信情報を更新する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="orderDate">オーダ日付</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <param name="orderDoc">オーダ送信情報</param>
        /// <returns></returns>
        public int UpdateOrderedDoc(int rsvNo, string orderDiv, DateTime orderDate, int orderNo, string orderDoc)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                string sql = @"
                        update ordereddoc 
                        set
                            orderdoc = :orderdoc 
                        where
                            rsvno = :rsvno 
                            and orderdiv = :orderdiv 
                            and orderdate = :orderdate 
                            and orderno = :orderno
                ";

                // パラメータ
                var sqlParam = new
                {
                    rsvno = rsvNo,
                    orderdiv = orderDiv,
                    orderdate = orderDate,
                    orderno = orderNo,
                    orderdoc = orderDoc,
                };

                // SQL実行
                var result = connection.Execute(sql, sqlParam);
                if (result == 0)
                {
                    return 0;
                }

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }

        /// <summary>
        /// 病理ラベル情報を取得する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <param name="seq">SEQ</param>
        /// <returns>病理ラベル情報</returns>
        public List<dynamic> SelectByoriLabelInfo(int rsvNo, string orderDiv, int orderNo, int seq)
        {
            // SQL定義
            string sql = @"
                    select
                        odr.rsvno
                        , odr.orderdiv
                        , odr.orderno
                        , odr.buncd
                        , odr.zaicd
                        , odr.saisyucd
                        , odr.hosokucd
                        , odr.shouhoucd
                        , odr.gethdate
                        , odr.contcnt
                        , odr.cnt
                        , zai.zainame
                        , zai.odrflg
                        , zai.kensa
                        , sai.saisyuname
                        , hsk.hosokuname
                        , hsk.bumncd
                        , hsk.bumnname
                        , shh.shouhouname
                        , person.perid
                        , rtrim(person.lastname || '　' || person.firstname) name_n
                        , perresult.result kansen_result 
                    from
                        orderinfo odr
                        , orderzairyo zai
                        , ordersaisyu sai
                        , orderhosoku hsk
                        , ordershouhou shh
                        , consult
                        , person
                        , perresult 
                    where
                        :sincd = zai.sincd(+) 
                        and odr.buncd = zai.buncd(+) 
                        and odr.zaicd = zai.zaicd(+) 
                        and :sincd = sai.sincd(+) 
                        and odr.buncd = sai.buncd(+) 
                        and odr.zaicd = sai.zaicd(+) 
                        and odr.saisyucd = sai.saisyucd(+) 
                        and :sincd = hsk.sincd(+) 
                        and odr.buncd = hsk.buncd(+) 
                        and odr.zaicd = hsk.zaicd(+) 
                        and odr.saisyucd = hsk.saisyucd(+) 
                        and odr.hosokucd = hsk.hosokucd(+) 
                        and :sincd = shh.sincd(+) 
                        and odr.shouhoucd = shh.shouhoucd(+) 
                        and odr.rsvno = :rsvno 
                        and odr.orderdiv = :orderdiv 
                        and odr.orderno = :orderno 
                        and odr.seq = :seq 
                        and odr.rsvno = consult.rsvno(+) 
                        and consult.perid = person.perid(+) 
                        and consult.perid = perresult.perid(+) 
                        and :itemcd = perresult.itemcd(+) 
                        and :suffix = perresult.suffix(+) 
                    order by
                        odr.rsvno
                        , odr.orderdiv
                        , odr.orderno
                        , odr.seq
            ";

            // パラメータ
            var sqlParam = new
            {
                rsvno = rsvNo,
                orderdiv = orderDiv,
                orderno = orderNo,
                seq = seq,
                sincd = SINCD,
                itemcd = ITEMCD_KANSENSHO,
                suffix = SUFFIX_KANSENSHO,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// オーダ送信ジャーナルのレコードを登録する
        /// </summary>
        /// <param name="rsvNo">予約番号</param>
        /// <param name="odrDiv">オーダ区分</param>
        /// <param name="tskDiv">処理区分</param>
        /// <param name="sendDiv">送信区分</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <returns></returns>
        public int InsertOrderJnl(int rsvNo, int odrDiv, int tskDiv, int sendDiv, int orderNo)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                string sql = @"
                        insert 
                        into order_jnl( 
                            tskdate
                            , rsvno
                            , odrdiv
                            , tskdiv
                            , senddiv
                            , orderno
                        ) 
                        values ( 
                            sysdate
                            , :rsvno
                            , :odrdiv
                            , :tskdiv
                            , :senddiv
                            , :orderno
                        ) 
                ";

                // パラメータ
                var sqlParam = new
                {
                    rsvno = rsvNo,
                    odrdiv = odrDiv,
                    tskdiv = tskDiv,
                    senddiv = sendDiv,
                    orderno = orderNo,
                };

                // SQL実行
                var result = connection.Execute(sql, sqlParam);
                if (result == 0)
                {
                    return 0;
                }

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }

        /// <summary>
        /// 送信オーダ依頼情報を取得する
        /// </summary>
        /// <returns>送信オーダ情報</returns>
        public List<dynamic> SelectSendOrderList()
        {
            // SQL定義
            string sql = @"
                select
                    main.rsvno
                    , main.orderdate
                    , main.odrdiv
                    , main.tskdiv
                    , main.orderdiv
                    , main.senddiv
                    , main.orderno
                    , main.csldate
                    , main.perid
                    , main.lastname
                    , main.firstname
                    , main.dayid
                    , main.odrname
                    , main.targetitem1
                    , main.targetitem2
                    , main.pername
                    , main.orderdiv_conv
                    , substr(orderinfo.freecd, 4, 4) doccode
                    , substr(orderinfo.freecd, 8, 2) docseq
                    , orderinfo.freename docname
                    , orderinfo.freefield1 doctitle
                    , orderinfo.freefield2 roottag
                    , orderinfo.freefield3 csltime 
                from
                    ( 
                        select
                            ordertbl.rsvno
                            , ordertbl.orderdate
                            , ordertbl.odrdiv
                            , ordertbl.tskdiv
                            , ordertbl.orderdiv
                            , ordertbl.senddiv
                            , ordertbl.orderno
                            , consult.csldate
                            , consult.perid
                            , person.lastname
                            , person.firstname
                            , nvl(receipt.dayid, 0) dayid
                            , free.freename odrname
                            , free.freefield2 targetitem1
                            , free.freefield3 targetitem2
                            , nvl2( 
                                person.firstname
                                , ( 
                                    person.lastname || nvl2(person.lastname, '　', '') || person.firstname
                                ) 
                                , person.lastname
                            ) pername
                           --血液型・検体の場合は検体で読む
                           , case 
                                when ordertbl.orderdiv = :orderdiv_lb 
                                    then :orderdiv_lains 
                                else ordertbl.orderdiv 
                                end orderdiv_conv 
                        from
                            ordertbl
                            , consult
                            , person
                            , receipt
                            , free 
                        where
                            consult.rsvno(+) = ordertbl.rsvno 
                            and person.perid(+) = consult.perid 
                            and receipt.rsvno(+) = consult.rsvno 
                            and free.freecd(+) = ordertbl.orderdiv
                    ) main 
                    left join (select * from free where freeclasscd = :freeclasscd) orderinfo 
                        on main.orderdiv_conv = orderinfo.FREEFIELD6 
                order by
                    main.orderdate
                    , main.rsvno
                    , substr(orderinfo.freecd, 4, 4)
                    , substr(orderinfo.freecd, 8, 2)
            ";
            // パラメータ
            var sqlParam = new
            {
                freeclasscd = FREECLASSCD_SEND,
                orderdiv_lb = ORDERDIV_LB,
                orderdiv_lains = ORDERDIV_LAINS,
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 電子チャートのオーダ依頼送信情報を削除する
        /// </summary>
        /// <param name="updData">更新オーダテーブル情報</param>
        /// <returns></returns>
        public int DeleteSendOrderList(UpdateOrderTbl updData)
        {
            using (var ts = new TransactionScope())
            {
                string sql = "";

                // SQL定義
                sql = @"
                    delete 
                    from
                        ordertbl 
                    where
                        orderdate = :orderdate 
                        and rsvno = :rsvno 
                        and orderdiv = :orderdiv
                ";

                // パラメータ
                var sqlParam = new Dictionary<string, object>()
                {
                    {"rsvno", updData.RsvNo},
                    {"orderdate", updData.OrderDate},
                    {"orderdiv", updData.OrderDiv},
                };

                // SQL実行
                connection.Execute(sql, sqlParam);

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }

        /// <summary>
        /// 電子チャートのオーダ依頼対象データの受診情報を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <returns>依頼オーダ受診情報</returns>
        public List<dynamic> SelectOrderConsult(int rsvno)
        {
            // SQL定義
            string sql = @"
                select
                    consult.rsvno
                    , consult.csldate
                    , consult.perid
                    , consult.age
                    , consult.cscd
                    , person.perid per_perid
                    , person.lastname
                    , person.firstname
                    , person.birth
                    , person.gender 
                    , nvl2( 
                        person.firstname
                        , ( 
                            person.lastname || nvl2(person.lastname, '　', '') || person.firstname
                        ) 
                        , person.lastname
                    ) pername
                from
                    consult 
                    left join person 
                        on consult.perid = person.perid 
                where
                    consult.rsvno = :rsvno
            ";

            // パラメータ
            var sqlParam = new Dictionary<string, object>()
            {
                {"rsvno", rsvno},
            };
            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 電子チャートのオーダ依頼対象データの項目情報を取得する
        /// </summary>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="rsvno">予約番号</param>
        /// <param name="docCode">文書コード</param>
        /// <param name="docSeq">文書SEQ</param>
        /// <returns>オーダ項目情報</returns>
        public List<dynamic> SelectSendOrderItem(string orderDiv, int rsvno, string docCode, string docSeq)
        {
            // SQL定義
            string sql = "";

            switch (orderDiv)
            {
                default:
                    //オーダ種別で処理を分ける場合はcaseを増やす
                    sql = @"
                        select
                            itemorderdetail.icode
                            , itemorderdetail.iattr
                            , itemorderdetail.iname
                            , itemorderdetail.num
                            , itemorderdetail.kflg
                            , itemorderdetail.uslct
                            , itemorderdetail.ucode
                            , itemorderdetail.unit
                            , itemorderdetail.conv
                            , itemorderdetail.tagindex
                            , itemorderdetail.tagname
                            , itemorderdetail.tool2
                            , itemorderdetail.setflg
                            , itemorderdetail.setgrpcd
                            , itemorderdetail.editinfo 
                        from
                            orderditem2
                            , itemorderdetail 
                        where
                            orderditem2.rsvno = :rsvno 
                            and orderditem2.doccode = :doccode 
                            and orderditem2.docseq = :docseq 
                            and itemorderdetail.doccode = orderditem2.doccode 
                            and itemorderdetail.docseq = orderditem2.docseq 
                            and itemorderdetail.itemcd = orderditem2.itemcd 
                            and itemorderdetail.suffix = orderditem2.suffix 
                        order by
                            itemorderdetail.outorder

                    ";
                    break;
            }

            // パラメータ
            var sqlParam = new Dictionary<string, object>()
            {
                {"rsvno", rsvno},
                {"docCode", docCode},
                {"docSeq", docSeq},
            };
            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 電子チャートのオーダ依頼項目情報を更新する
        /// </summary>
        /// <param name="orderItem">送信オーダ項目情報</param>
        /// <param name="InsertFlg">レコード挿入フラグ</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="targetItemCd1">オーダ情報取得用項目コード１</param>
        /// <param name="targetItemCd2">オーダ情報取得用項目コード２</param>
        /// <param name="kyobuItemCode">胸部Ｘ線撮影方法判定用コード</param>
        /// <returns>0 or 1</returns>
        public int UpdateSendOrderItem(OrderedItem2 orderItem, bool InsertFlg
                                        , string orderDiv, string targetItemCd1, string targetItemCd2
                                        , string kyobuItemCode)
        {
            using (var ts = new TransactionScope())
            {
                // SQL定義
                string sql = @"
                    delete 
                    from
                        orderditem2 
                    where
                        rsvno = :rsvno 
                        and doccode = :doccode 
                        and docseq = :docseq
                ";

                // パラメータ
                var sqlParam = new Dictionary<string, object>()
                {
                    {"rsvno", orderItem.Rsvno},
                    {"doccode", orderItem.DocCode},
                    {"docseq", orderItem.DocSeq},
                };

                // SQL実行
                connection.Execute(sql, sqlParam);

                if (InsertFlg)
                {
                    string targetItemCd = "";

                    string sqlIns = "";
                    var sqlParamIns = new Dictionary<string, object>();

                    switch (orderDiv)
                    {
                        //検体検査
                        //血型＋検体検査
                        case ORDERDIV_LAINS:
                        case ORDERDIV_LB:
                            //通常の検索
                            sqlIns = @"
                                insert 
                                into orderditem2(rsvno, doccode, docseq, itemcd, suffix)( 
                                    select distinct
                                        receipt.rsvno
                                        , itemorderdetail.doccode
                                        , itemorderdetail.docseq
                                        , rsl.itemcd
                                        , rsl.suffix 
                                    from
                                        receipt
                                        , rsl
                                        , itemorderdetail 
                                    where
                                        receipt.rsvno = :rsvno 
                                        and rsl.rsvno = receipt.rsvno 
                                        and rsl.itemcd = itemorderdetail.itemcd 
                                        and rsl.suffix = itemorderdetail.suffix 
                                        and rsl.stopflg is null 
                                        and itemorderdetail.doccode = :doccode 
                                        and itemorderdetail.docseq = :docseq
                                ) 
                            ";

                            // パラメータ
                            sqlParamIns = new Dictionary<string, object>()
                            {
                                {"rsvno", orderItem.Rsvno},
                                {"doccode", orderItem.DocCode},
                                {"docseq", orderItem.DocSeq},
                            };

                            // SQL実行
                            connection.Execute(sqlIns, sqlParamIns);
                            break;

                        //BLAD（血液型）（輸血検査）
                        //喀痰細胞診
                        //病理婦人科（細胞診）
                        case ORDERDIV_BLAD:
                        case ORDERDIV_KAKUTAN:
                        case ORDERDIV_FUJINKA:
                            targetItemCd = targetItemCd2;

                            //指定のコードを歴展開はみない
                            sqlIns = @"
                                insert 
                                into orderditem2(rsvno, doccode, docseq, itemcd, suffix) 
                                values ( 
                                    :rsvno
                                    , :doccode
                                    , :docseq
                                    , :itemcd
                                    , :suffix
                                ) 
                            ";

                            // パラメータ
                            sqlParamIns = new Dictionary<string, object>()
                            {
                                {"rsvno", orderItem.Rsvno},
                                {"doccode", orderItem.DocCode},
                                {"docseq", orderItem.DocSeq},
                                {"itemcd", targetItemCd.Substring(0, 5)},
                                {"suffix", targetItemCd.Substring(5, 2)},
                            };

                            // SQL実行
                            connection.Execute(sqlIns, sqlParamIns);
                            break;


                        default:
                            //その他

                            if (!string.IsNullOrEmpty(targetItemCd1))
                            {
                                //指定項目が歴展開されているかで検索
                                targetItemCd = targetItemCd1;

                                switch (orderDiv)
                                {
                                    case ORDERDIV_KYOBUXP:
                                        //胸部Ｘ線の場合は１方向、２方向を判断
                                        if (GetKyobuSatuei(orderItem.Rsvno, kyobuItemCode) == 1)
                                        {
                                            //２方向の場合はコード変更
                                            targetItemCd = targetItemCd2;
                                        }
                                        break;
                                }

                                sqlIns = @"
                                    insert 
                                    into orderditem2(rsvno, doccode, docseq, itemcd, suffix)( 
                                        select distinct
                                            receipt.rsvno
                                            , itemorderdetail.doccode
                                            , itemorderdetail.docseq
                                            , rsl.itemcd
                                            , rsl.suffix 
                                        from
                                            receipt
                                            , rsl
                                            , itemorderdetail 
                                        where
                                            receipt.rsvno = :rsvno 
                                            and rsl.rsvno = receipt.rsvno 
                                            and rsl.itemcd = itemorderdetail.itemcd 
                                            and rsl.suffix = itemorderdetail.suffix 
                                            and itemorderdetail.doccode = :doccode 
                                            and itemorderdetail.docseq = :docseq 
                                            and itemorderdetail.itemcd = :itemcd 
                                            and itemorderdetail.suffix = :suffix
                                    ) 
                                ";

                                // パラメータ
                                sqlParamIns = new Dictionary<string, object>()
                                {
                                    {"rsvno", orderItem.Rsvno},
                                    {"doccode", orderItem.DocCode},
                                    {"docseq", orderItem.DocSeq},
                                    {"itemcd", targetItemCd.Substring(0, 5)},
                                    {"suffix", targetItemCd.Substring(5, 2)},
                                };

                                // SQL実行
                                connection.Execute(sqlIns, sqlParamIns);
                                break;

                            }
                            break;
                    }

                }

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }

        /// <summary>
        /// 胸部Ｘ線撮影方法の判断（１方向 or ２方向）
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="kyobuItemCode">胸部Ｘ線撮影方法判定用コード</param>
        /// <returns>1:２方向</returns>
        public int GetKyobuSatuei(int rsvno, string kyobuItemCode)
        {
            int ret = 0;

            // SQL定義
            string sql = @"
                select
                    itemcd 
                from
                    rsl 
                where
                    rsvno = :rsvno 
                    and itemcd = :itemcd
            ";

            // パラメータ
            var sqlParam = new Dictionary<string, object>()
            {
                {"rsvno", rsvno},
                {"itemcd", kyobuItemCode},
            };

            // SQL実行
            List<dynamic> result = connection.Query(sql, sqlParam).ToList();

            if (result.Count > 0)
            {
                //レコードがあれば1を返す
                ret = 1;
            }
            return ret;
        }

        /// <summary>
        /// 電子チャートの依頼時に使用する検査結果を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="itemcd">検査項目コード</param>
        /// <param name="suffix">サフィックス</param>
        /// <returns>検査結果情報</returns>
        public List<dynamic> SelectItemResult(int rsvno, string itemcd, string suffix)
        {
            // SQL定義
            string sql = @"
                select
                    rsvno
                    , itemcd
                    , suffix
                    , result 
                from
                    rsl 
                where
                    rsvno = :rsvno 
                    and itemcd = :itemcd 
                    and suffix = :suffix
            ";

            // パラメータ
            var sqlParam = new Dictionary<string, object>()
            {
                {"rsvno", rsvno},
                {"itemcd", itemcd},
                {"suffix", suffix},
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 電子チャートの依頼時に使用する検査結果を取得する（一括）
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="itemdata">検査項目情報</param>
        /// <returns>検査結果情報</returns>
        public List<dynamic> SelectItemResults(int rsvno, string itemdata)
        {

            List<dynamic> result = null;
            List<dynamic> returnData = new List<dynamic>();

            //パラメタ変換
            string[] item_para = itemdata.Split(Convert.ToChar("|"));

            //SQL定義
            string sql = @"
                select
                    rsvno
                    , itemcd
                    , suffix
                    , result 
                from
                    rsl 
                where
                    rsvno = :rsvno 
                    and itemcd = :itemcd 
                    and suffix = :suffix
            ";

            //指定された項目順に結果を取得
            foreach (string item in item_para)
            {
                //パラメータ設定
                string itemcd = "";
                string suffix = "";

                if (item.Length > 5)
                {
                    itemcd = item.Substring(0, 5);
                    suffix = item.Substring(5, 2);
                }
                if (string.IsNullOrEmpty(itemcd) && string.IsNullOrEmpty(suffix)) { continue; }

                // パラメータ
                var sqlParam = new Dictionary<string, object>()
                {
                    {"rsvno", rsvno},
                    {"itemcd", itemcd},
                    {"suffix", suffix},
                };

                // SQL実行
                result = connection.Query(sql, sqlParam).ToList();

                //取得したデータを戻り値に設定
                if (result.Count > 0)
                {
                    returnData.Add(Convert.ToString(result[0].RESULT) ?? "");
                }
                else
                {
                    //データがない場合は空設定
                    returnData.Add("");
                }
            }

            return returnData;
        }

        /// <summary>
        /// 誘導システムで発行した婦人科オーダ情報を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="orderDiv">オーダ種別</param>
        /// <param name="orderNo">オーダ番号</param>
        /// <returns>婦人科オーダ情報</returns>
        public List<dynamic> SelectYudoOrderInfo(int rsvno, string orderDiv, int orderNo)
        {
            // SQL定義
            string sql = @"
                select
                    rsvno
                    , orderdiv
                    , orderno
                    , seq
                    , buncd
                    , zaicd
                    , saisyucd
                    , hosokucd
                    , shouhoucd
                    , contcnt
                    , cnt 
                from
                    orderinfo 
                where
                    rsvno = :rsvno 
                    and orderdiv = :orderdiv 
                    and orderno = :orderno 
                order by
                    seq desc
            ";

            // パラメータ
            var sqlParam = new Dictionary<string, object>()
            {
                {"rsvno", rsvno},
                {"orderdiv", orderDiv},
                {"orderno", orderNo},
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 送信済オーダ文書２情報を取得する
        /// </summary>
        /// <param name="rsvno">予約番号</param>
        /// <param name="orderno">オーダ番号</param>
        /// <returns>送信済オーダ文書２情報</returns>
        public List<dynamic> SelectByRsvOrderNo(int rsvno, int orderno)
        {

            // SQLステートメント定義
            string sql = @"
                select
                    rsvno
                    , doccode
                    , docseq
                    , orderno
                    , createdate
                    , orderseq
                    , perid
                    , csldate
                    , age
                    , dayid
                    , senddate 
                from
                    orderddoc2 
                where
                    rsvno = :rsvno 
                    and orderno = :orderno
                ";

            // パラメータ値の設定
            var sqlParam = new Dictionary<string, object>()
            {
                {"rsvno", rsvno},
                {"orderno", orderno},
            };

            // SQL実行
            return connection.Query(sql, sqlParam).ToList();
        }

        /// <summary>
        /// 送信済オーダ文書２情報テーブルのオーダ送信情報を更新する
        /// </summary>
        /// <param name="orderedDoc2">送信済オーダ文書２情報</param>
        /// <param name="orderType">オーダ種別</param>
        /// <returns></returns>
        public int UpdateOrderedDoc2(OrderedDoc2 orderedDoc2, int orderType)
        {
            using (var ts = new TransactionScope())
            {
                string sql = "";

                // SQL定義
                switch (orderType)
                {
                    case 1:
                        //新規オーダ
                        sql = @"
                            insert 
                            into orderddoc2( 
                                rsvno
                                , doccode
                                , docseq
                                , orderno
                                , createdate
                                , orderseq
                                , perid
                                , csldate
                                , age
                                , dayid
                                , senddate
                            ) 
                            values ( 
                                :rsvno
                                , :doccode
                                , :docseq
                                , :orderno
                                , :createdate
                                , :orderseq
                                , :perid
                                , :csldate
                                , :age
                                , :dayid
                                , sysdate
                            ) 
                        ";
                        break;

                    case 2:
                        //修正オーダ
                        sql = @"
                            update orderddoc2 
                            set
                                orderseq = :orderseq
                                , senddate = sysdate 
                            where
                                rsvno = :rsvno 
                                and doccode = :doccode 
                                and docseq = :docseq
                        ";
                        break;

                    case 3:
                        //削除オーダ
                        sql = @"
                            delete 
                            from
                                orderddoc2 
                            where
                                rsvno = :rsvno 
                                and doccode = :doccode 
                                and docseq = :docseq
                        ";
                        break;

                }

                // パラメータ
                var sqlParam = new Dictionary<string, object>()
                {
                    {"rsvno",      orderedDoc2.Rsvno},
                    {"doccode",    orderedDoc2.DocCode},
                    {"docseq",     orderedDoc2.DocSeq},
                    {"orderno",    orderedDoc2.OrderNo},
                    {"createdate", orderedDoc2.CreateDate},
                    {"orderseq",   orderedDoc2.OrderSeq},
                    {"perid",      orderedDoc2.PerId},
                    {"csldate",    orderedDoc2.CslDate},
                    {"age",        orderedDoc2.Age},
                    {"dayid",      orderedDoc2.DayId}
                };

                // SQL実行
                connection.Execute(sql, sqlParam);

                // トランザクションをコミット
                ts.Complete();

                return 1;
            }
        }
    }
}
