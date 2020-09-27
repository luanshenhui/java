using Dapper;
using Entity.Helper;
using Hainsi.Common;
using Hainsi.Common.Constants;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Linq;

namespace Hainsi.Entity
{
    /// <summary>
    /// 判定コメント文章情報データアクセスオブジェクト
    /// </summary>
    public class JudCmtStcDao : AbstractDao
    {
        /// <summary>
        /// 生活指導コメント
        /// </summary>
        private const int JUDCLASS_RECOGLEVEL = 50;

        /// <summary>
        /// コンストラクタ
        /// </summary>
        /// <param name="connection">コネクションオブジェクト</param>
        public JudCmtStcDao(IDbConnection connection) : base(connection)
        {
        }

        /// <summary>
        /// 検索条件を満たす判定コメントの一覧を取得する
        /// </summary>
        /// <param name="judClassCd">検索判定分類</param>
        /// <param name="keys">検索キーの集合</param>
        /// <param name="startPos">開始位置</param>
        /// <param name="getCount">取得件数</param>
        /// <param name="searchCode">検索用コード（省略可）</param>
        /// <param name="searchString">検索用文字列（省略可）</param>
        /// <param name="searchModeFlg">
        /// 検索条件（省略可）
        /// 0=判定分類の無いコメントも取得
        /// 1=判定分類の一致するコメントのみ
        /// </param>
        /// <param name="recogLevel">認識レベル</param>
        /// <param name="getHihyouji">非表示(0:非表示は取得しない　1:すべて取得)</param>
        /// <returns>判定コメント情報</returns>
        public PartialDataSet<dynamic> SelectJudCmtStcList(
            int? judClassCd = null,
            string[] keys = null,
            int? startPos = null,
            int? getCount = null,
            string searchCode = null,
            string searchString = null,
            int searchModeFlg = 0,
            int? recogLevel = null,
            int getHihyouji = 0
        )
        {
            // キー及び更新値の設定
            var param = new Dictionary<string, object>();

            if (judClassCd != null)
            {
                param.Add("judclasscd", judClassCd);
            }

            // SQL定義
            string sql = @"
                select
                    js.judcmtcd
                    , js.judcmtstc
                    , js.judclasscd
                    , jc.judclassname
                    , js.judcd
                    , jud.weight
                    , js.judcmtstc_e
                    , js.recoglevel1
                    , js.recoglevel2
                    , js.recoglevel3
                    , js.recoglevel4
                    , js.recoglevel5
                    , js.recoghihyouji
                    , js.outpriority
                    , count(*) over() totalcount
                from
                    judcmtstc js
                    , judclass jc
                    , jud
                where
                    1 = 1
            ";

            if ((keys != null) && (keys.Length > 0))
            {
                string condition = CreateConditionForJudCmtStcList(keys, ref param);
                if (!string.IsNullOrEmpty(condition))
                {
                    sql += @"
                        and " + condition;
                }
            }

            if (judClassCd != null)
            {
                // 判定分類の無いコメントを表示する場合としない場合を区別する
                if (searchModeFlg == 0)
                {
                    sql += @"
                        and (
                            js.judclasscd = :judclasscd
                            or js.judclasscd is null
                        )
                    ";
                }
                else
                {
                    sql += @"
                        and js.judclasscd = :judclasscd
                    ";
                }
            }

            sql += @"
                    and js.judclasscd = jc.judclasscd(+)
            ";

            sql += @"
                    and js.judcd = jud.judcd(+)
            ";

            // 検索用文字列の設定（マスタメンテ用？）
            if (!string.IsNullOrEmpty(searchCode) && !string.IsNullOrEmpty(searchCode.Trim()))
            {
                sql += @"
                    and js.judcmtcd like :searchcode
                ";

                param.Add("searchcode", $"%{searchCode.Trim()}%");
            }

            if (!string.IsNullOrEmpty(searchString) && !string.IsNullOrEmpty(searchString.Trim()))
            {
                sql += @"
                    and js.judcmtstc like :searchstring
                ";

                param.Add("searchstring", $"%{searchString.Trim()}%");
            }

            // 非表示フラグ処理
            if (getHihyouji == 0)
            {
                sql += @"
                    and js.recoghihyouji is null
                ";
            }

            // 生活指導コメントの表示分類
            if ((judClassCd == JUDCLASS_RECOGLEVEL) && (recogLevel != null))
            {
                switch (recogLevel)
                {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                        sql += $@"
                            and js.recoglevel{recogLevel} = 1
                        ";
                        break;
                }
            }

            sql += @"
                order by
                    js.judcmtcd
            ";

            if ((startPos != null) && (getCount != null))
            {
                sql += $@"
                    offset {startPos} rows fetch first {getCount} rows only
                ";
            }

            // SQL実行
            return DataSetConverter.ToPartialDataSet(connection.Query(sql, param));
        }

        /// <summary>
        /// 判定コメントテーブル検索用条件節作成
        /// </summary>
        /// <param name="keys">検索キーの集合</param>
        /// <param name="param"></param>
        /// <returns>判定コメントテーブル検索用の条件節</returns>
        /// <remarks>
        /// 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
        /// 検索キーに半角カナ文字が存在する場合は全角変換が行われる
        /// </remarks>
        string CreateConditionForJudCmtStcList(string[] keys, ref Dictionary<string, object> param)
        {
            // 引数未設定時は何もしない
            if (keys == null)
            {
                return null;
            }

            // 検索キー数分の条件節を追加
            var conditions = new List<string>();
            var index = 0;
            foreach (var key in keys)
            {
                if (string.IsNullOrEmpty(key) || string.IsNullOrEmpty(key.Trim()))
                {
                    continue;
                }

                // 検索キー中の半角カナを全角カナに変換する
                string value = WebHains.StrConvKanaWide(key.Trim());

                // 判定コメント文章のパラメーター定義
                string paramJudCmtStc = $"judcmtstc{++index}";
                param.Add(paramJudCmtStc, $"%{value}%");

                // キーワード値が８文字以内の場合
                if (key.Length <= 8)
                {
                    // 判定コメントコードのパラメーター定義
                    string paramJudCmtCd = $"judcmtcd{index}";
                    param.Add(paramJudCmtCd, $"{value}%");

                    // 判定コメントコードでの検索条件を追加（前方一致）
                    conditions.Add($"(js.judcmtstc like :{paramJudCmtStc} or js.judcmtcd like :{paramJudCmtCd})");
                }
                else
                {
                    conditions.Add($"js.judcmtstc like :{paramJudCmtStc}");
                }
            }

            if (conditions.Count == 0)
            {
                return null;
            }

            return string.Join(" and ", conditions);
        }

        /// <summary>
        /// 判定コメントデータを取得する
        /// </summary>
        /// <param name="judCmtCd">判定コメントコード</param>
        /// <param name="getguidance"></param>
        /// <returns>
        /// judcmtstc 判定コメント文章
        /// vntjudclasscd 判定分類コード
        /// vntguidancecd 指導内容コード
        /// vntguidancestc 指導内容
        /// vntjudcd 判定コード
        /// vntjudsname 判定略称
        /// vnthihyouji 非表示
        /// vntrecoglevel1 認識レベル１
        /// vntrecoglevel2 認識レベル２
        /// vntrecoglevel3 認識レベル３
        /// vntrecoglevel4 認識レベル４
        /// vntrecoglevel5 認識レベル５
        /// vntoutpriority 出力順区分
        /// </returns>
        public dynamic SelectJudCmtStcnew(string judCmtCd, bool getguidance = false)
        {
            string sql;

            // キー値の設定
            var sqlParam = new
            {
                judcmtcd = judCmtCd
            };

            sql = @"
                    select
                        judcmtstc
                        , judcmtstc_e
                        , judclasscd
                        , recoghihyouji
                        , recoglevel1
                        , recoglevel2
                        , recoglevel3
                        , recoglevel4
                        , recoglevel5
                        , outpriority
                    from
                        judcmtstc
                    where
                        judcmtcd = :judcmtcd
                ";

            // 指導内容、判定も検索する場合のSQLステートメント
            // (設定如何によっては複数レコード検索されるが、設定が正しいとの前提で１件のみ取得する)
            if (getguidance)
            {
                sql = @"
                        select
                            judcmtstc.judcmtstc
                            , judcmtstc.judcmtstc_e
                            , judcmtstc.judclasscd
                            , judcmtstc.recoghihyouji
                            , judcmtstc.recoglevel1
                            , judcmtstc.recoglevel2
                            , judcmtstc.recoglevel3
                            , judcmtstc.recoglevel4
                            , judcmtstc.recoglevel5
                            , guidance.guidancecd
                            , guidance.guidancestc
                            , jud.judcd
                            , jud.judrname
                            , judcmtstc.outpriority
                        from
                            jud
                            , guidance
                            , (
                                select
                                    freefield1 judcmtcd
                                    , freefield2 guidancecd
                                    , freefield3 judcd
                                from
                                    free
                                where
                                    freecd like 'SCRJUDPTN%'
                            ) judcmtptn
                            , judcmtstc
                        where
                            judcmtstc.judcmtcd = :judcmtcd
                            and judcmtstc.judcmtcd = judcmtptn.judcmtcd(+)
                            and judcmtptn.guidancecd = guidance.guidancecd(+)
                            and judcmtptn.judcd = jud.judcd(+)
                    ";
            }

            // SQL実行
            return connection.Query(sql, sqlParam).FirstOrDefault();
        }

        /// <summary>
        /// 判定コメントテーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">グループ情報</param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistJudCmtStc1(string mode, JToken data)
        {
            string sql;

            Insert ret = Insert.Error;

            // キー及び更新値の設定
            var sqlParam = new
            {
                judcmtcd = Convert.ToString(data["judcmtcd"]).Trim(),
                judcmtstc = Convert.ToString(data["judcmtstc"]).Trim(),
                judcmtstc_e = Convert.ToString(data["judcmtstc_e"]).Trim(),
                judclasscd = Convert.ToString(data["judclasscd"]).Trim(),
                recoghihyouji = Convert.ToString(data["recoghihyouji"]).Trim(),
                recoglevel1 = Convert.ToString(data["recoglevel1"]).Trim(),
                recoglevel2 = Convert.ToString(data["recoglevel2"]).Trim(),
                recoglevel3 = Convert.ToString(data["recoglevel3"]).Trim(),
                recoglevel4 = Convert.ToString(data["recoglevel4"]).Trim(),
                recoglevel5 = Convert.ToString(data["recoglevel5"]).Trim(),
                outpriority = Convert.ToString(data["outpriority"]).Trim(),
            };

            while (true)
            {
                // 判定コメントテーブルレコードの更新
                if (mode == "UPD")
                {
                    sql = @"
                        update judcmtstc
                        set
                            judcmtstc = :judcmtstc
                            , judcmtstc_e = :judcmtstc_e
                            , judclasscd = :judclasscd
                            , recoghihyouji = :recoghihyouji
                            , recoglevel1 = :recoglevel1
                            , recoglevel2 = :recoglevel2
                            , recoglevel3 = :recoglevel3
                            , recoglevel4 = :recoglevel4
                            , recoglevel5 = :recoglevel5
                            , outpriority = :outpriority
                        where
                            judcmtcd = :judcmtcd
                    ";

                    int count = connection.Execute(sql, sqlParam);

                    if (count > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす判定コメントテーブルのレコードを取得
                sql = "select judcmtcd from judcmtstc where judcmtcd = :judcmtcd";

                dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

                if (result != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                    insert
                    into judcmtstc(
                        judcmtcd
                        , judcmtstc
                        , judcmtstc_e
                        , judclasscd
                        , recoghihyouji
                        , recoglevel1
                        , recoglevel2
                        , recoglevel3
                        , recoglevel4
                        , recoglevel5
                        , outpriority
                    )
                    values (
                        :judcmtcd
                        , :judcmtstc
                        , :judcmtstc_e
                        , :judclasscd
                        , :recoghihyouji
                        , :recoglevel1
                        , :recoglevel2
                        , :recoglevel3
                        , :recoglevel4
                        , :recoglevel5
                        , :outpriority
                    )
                ";

                // SQL実行
                connection.Execute(sql, sqlParam);

                ret = Insert.Normal;

                break;
            }

            return ret;

        }

        /// <summary>
        /// 判定コメントテーブルレコードを削除する
        /// </summary>
        /// <param name="judCmtCd">判定コメントコード</param>
        /// <returns>
        /// True 正常終了
        /// False 異常終了
        /// </returns>
        public bool DeleteJudCmtStc(string judCmtCd)
        {
            string sql;

            // キー及び更新値の設定
            var sqlParam = new
            {
                judcmtcd = judCmtCd.Trim(),
            };

            // 検査実施日分類テーブルレコードの削除
            sql = @"
                delete judcmtstc
                where
                    judcmtcd = :judcmtcd
                ";

            // SQL実行
            connection.Execute(sql, sqlParam);

            return true;
        }

        /// <summary>
        ///
        /// </summary>
        /// <param name="judCmtStc"></param>
        public void SelectJudCmtStc(string judCmtStc)
        {
            // #ToDo Select結果を受け取る変数が用意されているかどうかでSelect文が変わっている
            // C#にする場合これをどう表現するのか
            /*
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objJudCmtStc    As OraField         '判定コメント文章
    Dim objJudClassCd   As OraField         '判定分類コード
'## 2003.02.14 Add 6Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    Dim objGuidanceCd   As OraField         '指導内容コード
    Dim objGuidanceStc  As OraField         '指導内容
    Dim objJudCd        As OraField         '判定コード
    Dim objJudSName     As OraField         '判定略称

    Dim blnGetGuidance  As Boolean          'Trueならば指導内容、判定も取得
'## 2003.02.14 Add End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

'## 2003.02.14 Add 23Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    '初期処理
    vntJudCmtStc = Empty
    vntJudClassCd = Empty

    If Not IsMissing(vntGuidanceCd) Then
        vntGuidanceCd = Empty
        blnGetGuidance = True
    End If

    If Not IsMissing(vntGuidanceStc) Then
        vntGuidanceStc = Empty
        blnGetGuidance = True
    End If

    If Not IsMissing(vntJudCd) Then
        vntJudCd = Empty
        blnGetGuidance = True
    End If

    If Not IsMissing(vntJudSName) Then
        vntJudSName = Empty
        blnGetGuidance = True
    End If
'## 2003.02.14 Add End

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCMTCD", Trim(strJudCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす判定コメントテーブルのレコードを取得
    strStmt = "SELECT JUDCMTSTC, JUDCLASSCD FROM JUDCMTSTC WHERE JUDCMTCD = :JUDCMTCD"

'## 2003.02.14 Add 18Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    '指導内容、判定も検索する場合のSQLステートメント
    '(設定如何によっては複数レコード検索されるが、設定が正しいとの前提で１件のみ取得する)
    If blnGetGuidance Then
        strStmt = "SELECT JUDCMTSTC.JUDCMTSTC, JUDCMTSTC.JUDCLASSCD,    " & vbLf & _
                  "       GUIDANCE.GUIDANCECD, GUIDANCE.GUIDANCESTC,    " & vbLf & _
                  "       JUD.JUDCD,           JUD.JUDRNAME             " & vbLf & _
                  "  FROM JUD, GUIDANCE,                                " & vbLf & _
                  "       ( SELECT FREEFIELD1 JUDCMTCD,                 " & vbLf & _
                  "                FREEFIELD2 GUIDANCECD,               " & vbLf & _
                  "                FREEFIELD3 JUDCD                     " & vbLf & _
                  "           FROM FREE                                 " & vbLf & _
                  "          WHERE FREECD LIKE 'SCRJUDPTN%'             " & vbLf & _
                  "       ) JUDCMTPTN,                                  " & vbLf & _
                  "       JUDCMTSTC                                     " & vbLf & _
                  " WHERE JUDCMTSTC.JUDCMTCD   = :JUDCMTCD              " & vbLf & _
                  "   AND JUDCMTSTC.JUDCMTCD   = JUDCMTPTN.JUDCMTCD(+)  " & vbLf & _
                  "   AND JUDCMTPTN.GUIDANCECD = GUIDANCE.GUIDANCECD(+) " & vbLf & _
                  "   AND JUDCMTPTN.JUDCD      = JUD.JUDCD(+)           "
    End If
'## 2003.02.14 Add End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCmtStc = objFields("JUDCMTSTC")
        Set objJudClassCd = objFields("JUDCLASSCD")

'## 2003.02.14 Add 6Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
        If blnGetGuidance Then
            Set objGuidanceCd = objFields("GUIDANCECD")
            Set objGuidanceStc = objFields("GUIDANCESTC")
            Set objJudCd = objFields("JUDCD")
            Set objJudSName = objFields("JUDRNAME")
        End If
'## 2003.02.14 Add End

        '戻り値の設定
        vntJudCmtStc = objJudCmtStc.Value & ""
        vntJudClassCd = objJudClassCd.Value & ""

'## 2003.02.14 Add 19Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
        If blnGetGuidance Then

            If Not IsMissing(vntGuidanceCd) Then
                vntGuidanceCd = objGuidanceCd.Value & ""
            End If

            If Not IsMissing(vntGuidanceStc) Then
                vntGuidanceStc = objGuidanceStc.Value & ""
            End If

            If Not IsMissing(vntJudCd) Then
                vntJudCd = objJudCd.Value & ""
            End If

            If Not IsMissing(vntJudSName) Then
                vntJudSName = objJudSName.Value & ""
            End If

        End If
'## 2003.02.14 Add End

        SelectJudCmtStc = True

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudCmtStc.SelectJudCmtStc"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

             */
        }

        /// <summary>
        /// 判定コメントテーブルレコードを登録する
        /// </summary>
        /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        /// <param name="data">
        /// judcmtstc 判定コメントコード
        /// judclasscd 判定コメント名
        /// judcmtcd 判定分類コード
        /// </param>
        /// <returns>
        ///	Insert.Normal 正常終了
        ///	Insert.Duplicate 同一キーのレコード存在
        ///	Insert.Error 異常終了
        /// </returns>
        public Insert RegistJudCmtStc(string mode, JToken data)
        {
            // キー及び更新値の設定
            var sqlParam = new
            {
                judcmtstc = Convert.ToString(data["judcmtstc"]),
                judclasscd = Convert.ToString(data["judclasscd"]),
                judcmtcd = Convert.ToString(data["judcmtcd"])
            };

            string sql;

            Insert ret = Insert.Error;

            while (true)
            {
                // 判定コメントテーブルレコードの更新
                if (mode == "UPD")
                {
                    sql = @"
                            update judcmtstc
                            set
                                judcmtstc = :judcmtstc
                                , judclasscd = :judclasscd
                            where
                                judcmtcd = :judcmtcd
                            ";

                    int ret2 = connection.Execute(sql, sqlParam);

                    if (ret2 > 0)
                    {
                        ret = Insert.Normal;
                        break;
                    }
                }

                // 検索条件を満たす判定コメントテーブルのレコードを取得
                sql = @"
                    select
                        judcmtcd
                    from
                        judcmtstc
                    where
                        judcmtcd = :judcmtcd
                    ";

                dynamic result = connection.Query(sql, sqlParam).FirstOrDefault();

                if (result != null)
                {
                    ret = Insert.Duplicate;
                    break;
                }

                // 更新モードでない場合、または更新レコードがない場合は挿入を行う
                sql = @"
                    insert
                    into judcmtstc(judcmtcd, judcmtstc, judclasscd)
                    values (:judcmtcd, :judcmtstc, :judclasscd)
                    ";

                connection.Execute(sql, sqlParam);

                ret = Insert.Normal;

                break;
            }

            return ret;
        }

        #region 新設メソッド

        //      /// <summary>
        //      /// 判定コメントテーブル検索用条件節作成
        //      /// </summary>
        //      /// <param name="key">検索キーの集合</param>
        //      /// <returns>判定コメントテーブル検索用の条件節</returns>
        //      /// <remarks>
        //      /// 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
        //      /// 検索キーに半角カナ文字が存在する場合は全角変換が行われる
        //      /// </remarks>
        //      private string CreateConditionForJudCmtStcList(string[] key)
        //      {
        //          string sql; //SQLステートメント

        //          int i; // インデックス

        //          // 引数未設定時は何もしない
        //          if (key == null)
        //          {
        //              return "";
        //          }

        //          // 最初はWHERE句から開始
        //          sql = "where ";

        //          // 検索キー数分の条件節を追加
        //          for (i = 0; i < key.Length; i++)
        //          {
        //              // 2番目以降の条件節はANDで連結
        //              if (i >= 1)
        //              {
        //                  sql += "and ";
        //              }

        //              // 検索キー中の半角カナを全角カナに変換する
        //              // 共通メソッドを作る必要あり、保留

        //              if (Util.ConvertToBytes(key[i]).Length <= 8)
        //              {
        //                  sql += @"
        //                          ( js.judcmtstc like '%" + key[i] + @"%'
        //			        or js.judcmtcd  like '" + key[i] + @"%' )
        //                      ";
        //              }
        //              else
        //              {
        //                  sql += " js.judcmtstc like '%" + key[i] + "%' ";
        //              }
        //          }

        //          return sql;
        //      }

        //      /// <summary>
        //      /// 判定コメントデータを取得する
        //      /// </summary>
        //      /// <param name="judCmtCd">判定コメントコード</param>
        //      /// <returns>判定コメントデータ</returns>
        //      public dynamic SelectJudCmtStcnew(string judCmtCd, UrlQueryReader qp)
        //      {
        //          string getguidance = qp["getguidance"]; // Trueならば指導内容、判定も取得

        //          string sql;

        //          // キー値の設定
        //          var sqlParam = new
        //          {
        //              judcmtcd = judCmtCd
        //          };

        //          sql = @"
        //                  select
        //                      judcmtstc
        //                      , judcmtstc_e
        //                      , judclasscd
        //                      , recoghihyouji
        //                      , recoglevel1
        //                      , recoglevel2
        //                      , recoglevel3
        //                      , recoglevel4
        //                      , recoglevel5
        //                      , outpriority
        //                  from
        //                      judcmtstc
        //                  where
        //                      judcmtcd = :judcmtcd
        //              ";

        //          // 指導内容、判定も検索する場合のSQLステートメント
        //          // (設定如何によっては複数レコード検索されるが、設定が正しいとの前提で１件のみ取得する)
        //          if (getguidance == "1")
        //          {
        //              sql = @"
        //                      select
        //                          judcmtstc.judcmtstc
        //                          , judcmtstc.judcmtstc_e
        //                          , judcmtstc.judclasscd
        //                          , judcmtstc.recoghihyouji
        //                          , judcmtstc.recoglevel1
        //                          , judcmtstc.recoglevel2
        //                          , judcmtstc.recoglevel3
        //                          , judcmtstc.recoglevel4
        //                          , judcmtstc.recoglevel5
        //                          , guidance.guidancecd
        //                          , guidance.guidancestc
        //                          , jud.judcd
        //                          , jud.judrname
        //                          , judcmtstc.outpriority
        //                      from
        //                          jud
        //                          , guidance
        //                          , (
        //                              select
        //                                  freefield1 judcmtcd
        //                                  , freefield2 guidancecd
        //                                  , freefield3 judcd
        //                              from
        //                                  free
        //                              where
        //                                  freecd like 'SCRJUDPTN%'
        //                          ) judcmtptn
        //                          , judcmtstc
        //                      where
        //                          judcmtstc.judcmtcd = :judcmtcd
        //                          and judcmtstc.judcmtcd = judcmtptn.judcmtcd(+)
        //                          and judcmtptn.guidancecd = guidance.guidancecd(+)
        //                          and judcmtptn.judcd = jud.judcd(+)
        //                  ";
        //          }

        //          // SQL実行
        //          return connection.Query(sql, sqlParam).FirstOrDefault();
        //      }

        //      /// <summary>
        //      /// 判定コメントテーブルレコードを登録する
        //      /// </summary>
        //      /// <param name="mode">登録モード("INS":挿入、"UPD":更新)</param>
        //      /// <param name="data">グループ情報</param>
        //      /// <returns></returns>
        //      public int RegistJudCmtStc1(string mode, JToken data)
        //      {
        //          string sql;
        //          int count;

        //          // キー及び更新値の設定
        //          var sqlParam = new
        //          {
        //              judcmtcd = Convert.ToString(data["judcmtcd"]).Trim(),
        //              judcmtstc = Convert.ToString(data["judcmtstc"]).Trim(),
        //              judcmtstc_e = Convert.ToString(data["judcmtstc_e"]).Trim(),
        //              judclasscd = Convert.ToString(data["judclasscd"]).Trim(),
        //              recoghihyouji = Convert.ToString(data["recoghihyouji"]).Trim(),
        //              recoglevel1 = Convert.ToString(data["recoglevel1"]).Trim(),
        //              recoglevel2 = Convert.ToString(data["recoglevel2"]).Trim(),
        //              recoglevel3 = Convert.ToString(data["recoglevel3"]).Trim(),
        //              recoglevel4 = Convert.ToString(data["recoglevel4"]).Trim(),
        //              recoglevel5 = Convert.ToString(data["recoglevel5"]).Trim(),
        //              outpriority = Convert.ToString(data["outpriority"]).Trim(),
        //          };

        //          // 判定コメントテーブルレコードの更新
        //          if (mode == "UPD")
        //          {
        //              sql = @"
        //                      update judcmtstc
        //                      set
        //                          judcmtstc = :judcmtstc
        //                          , judcmtstc_e = :judcmtstc_e
        //                          , judclasscd = :judclasscd
        //                          , recoghihyouji = :recoghihyouji
        //                          , recoglevel1 = :recoglevel1
        //                          , recoglevel2 = :recoglevel2
        //                          , recoglevel3 = :recoglevel3
        //                          , recoglevel4 = :recoglevel4
        //                          , recoglevel5 = :recoglevel5
        //                          , outpriority = :outpriority
        //                      where
        //                          judcmtcd = :judcmtcd
        //                  ";

        //              count = connection.Execute(sql, sqlParam);

        //              if (count > 0)
        //              {
        //                  return count;
        //              }
        //          }

        //          // 検索条件を満たす判定コメントテーブルのレコードを取得
        //          sql = "select judcmtcd from judcmtstc where judcmtcd = :judcmtcd";

        //          dynamic result = Query(sql, sqlParam).FirstOrDefault();

        //          if (result != null)
        //          {
        //              return 0;
        //          }

        //          // 更新モードでない場合、または更新レコードがない場合は挿入を行う
        //          sql = @"
        //                  insert
        //                  into judcmtstc(
        //                      judcmtcd
        //                      , judcmtstc
        //                      , judcmtstc_e
        //                      , judclasscd
        //                      , recoghihyouji
        //                      , recoglevel1
        //                      , recoglevel2
        //                      , recoglevel3
        //                      , recoglevel4
        //                      , recoglevel5
        //                      , outpriority
        //                  )
        //                  values (
        //                      :judcmtcd
        //                      , :judcmtstc
        //                      , :judcmtstc_e
        //                      , :judclasscd
        //                      , :recoghihyouji
        //                      , :recoglevel1
        //                      , :recoglevel2
        //                      , :recoglevel3
        //                      , :recoglevel4
        //                      , :recoglevel5
        //                      , :outpriority
        //                  )
        //              ";

        //          // SQL実行
        //          count = connection.Execute(sql, sqlParam);

        //          return count;
        //      }

        //      /// <summary>
        //      /// 判定コメントテーブルレコードを削除する
        //      /// </summary>
        //      /// <param name="judCmtCd">判定コメントコード</param>
        //      /// <returns></returns>
        //      public int DeleteJudCmtStc(string judCmtCd)
        //      {
        //          string sql;

        //          // キー及び更新値の設定
        //          var sqlParam = new
        //          {
        //              judcmtcd = judCmtCd.Trim(),
        //          };

        //          // 検査実施日分類テーブルレコードの削除
        //          sql = "delete judcmtstc where judcmtcd = :judcmtcd";

        //          // SQL実行
        //          return connection.Execute(sql, sqlParam);
        //      }

        #endregion
    }
}
