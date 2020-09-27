import axios from 'axios';


const followService = {
  // 指定予約番号の直前のフォロー情報を取得
  getFollowBefore: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/followups/before`;
    // 今日の受診者取得（コース別）の一覧を取得API呼び出し
    return axios
      .get(url, {
        params,
        // axios標準では404エラーも例外として扱われるため、500未満であれば正常となるよう変更
        // (アプリケーション規模が大きくなってきたら1ヶ所で定義するように変更したほうがよいかもしれない)
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data);
  },

  getFollowItem: () => {
    // フォロー対象検査項目取得
    const url = '/api/v1/followups/items';
    return axios
      .get(url)
      .then((res) => res.data);
  },

  getFollowHistory: (conditions) => {
    // 指定個人IDのフォロー情報の受診歴一覧取得
    const { perid } = conditions;
    const url = `/api/v1/people/${perid}/followups/histories`;
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  getTargetFollow: (conditions) => {
    // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得
    const { rsvno } = conditions;
    const url = `/api/v1/consultations/${rsvno}/followups/target`;
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => res.data);
  },

  // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録・変更
  insertFollowInfo: ({ data }) => {
    // 個人検査情報登録
    const method = 'POST';
    // urlの定義
    const url = '/api/v1/followups';
    return axios({
      method,
      url,
      data,
    })
      .then(() => ({
        data,
      }));
  },
  // 指定予約番号のフォロー状況管理情報を取得する
  getFollowInfo: (conditions) => {
    const { rsvno, judclasscd } = conditions;
    // 指定された条件のコメントを取得する
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/followups/${judclasscd}`;
    // 指定された条件のコメント取得API呼び出し
    return axios

      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data);
  },

  // 指定日付（受診日）範囲のフォローアップ対象者及び選択者を取得します。
  getTargetFollowList: (params) => {
    // urlの定義
    const url = '/api/v1/consultations/followups/target';

    // 指定日付（受診日）範囲のフォローアップ対象者及び選択者を取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },

  // 指定検索条件の変更履歴を取得する
  getFollowLogList: (params) => {
    // urlの定義
    const url = '/api/v1/followups/logs';

    // 指定検索条件の変更履歴を取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },

  // 指定検索条件の印刷履歴を取得する
  getFolReqHistory: (params) => {
    const { rsvno } = params;
    // urlの定義
    const url = `/api/v1/card/${rsvno}/history`;

    // 指定検索条件の印刷履歴を取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },

  // 結果情報の診断名を取得する
  getFollowRslList: (params) => {
    const { rsvno, judclasscd } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/followups/${judclasscd}/results`;

    // 結果情報の診断名を取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },

  // 二次検査結果情報別疾患（診断名）情報取得を取得する
  getFollowRslItemList: (params) => {
    const { rsvno, judclasscd } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/followups/${judclasscd}/diseases`;

    // 二次検査結果情報別疾患（診断名）情報取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },

  // フォローアップ情報更新処理
  updateFollowInfo: (params) => {
    const { rsvNo, judClassCd } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/followups/${judClassCd}`;

    // フォローアップ情報更新処理をAPI呼び出し
    return axios({
      method,
      url,
      data: params,
    });
  },

  // フォローアップ情報削除処理
  deleteFollowInfo: (params) => {
    const { rsvNo, judClassCd } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/followups/${judClassCd}`;

    // フォローアップ情報削除処理をAPI呼び出し
    return axios
      .delete(url);
  },

  // フォローアップ情報承認（又は承認解除）処理
  updatefollowInfoConfirm: (params) => {
    const { rsvNo, judClassCd } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvNo}/followups/${judClassCd}/approval`;

    // フォローアップ情報承認（又は承認解除）処理をAPI呼び出し
    return axios({
      method,
      url,
      params,
    });
  },

  // フォローアップ結果情報を取得する（受診者・判定分類別特定結果情報）処理
  getFollowRsl: (params) => {
    const { rsvno, judclasscd, seq } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/${judclasscd}/${seq}/followups`;

    // フォローアップ結果情報を取得する（受診者・判定分類別特定結果情報）取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },

  // 判定分類別フォローアップ情報削除処理
  deleteFollowRsl: (params) => {
    const { rsvno, judclasscd, seq } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/followups/${judclasscd}/${seq}`;

    // 判定分類別フォローアップ情報削除処理をAPI呼び出し
    return axios
      .delete(url);
  },

  // 判定分類別フォローアップ情報保存処理
  updateFollowRsl: (params) => {
    const { rsvno, judclasscd, seq } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/followups/${judclasscd}/${seq}/rsl`;

    // 判定分類別フォローアップ情報保存処理をAPI呼び出し
    return axios({
      method,
      url,
      data: params,
    });
  },

  // 受診者別検査項目別結果データ取得処理
  getResult: (params) => {
    const { rsvno, itemcd } = params;
    // urlの定義
    const url = `/api/v1/consultations/${rsvno}/followups/${itemcd}/result`;

    // 受診者別検査項目別結果データ取得をAPI呼び出し
    return axios({
      url,
      params,
    })
      .then((res) => res.data);
  },
};

export default followService;
