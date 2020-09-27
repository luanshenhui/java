import axios from 'axios';


const perResultService = {
  // 個人検査結果情報取得
  getPerResultList: (conditions) => {
    const { perid } = conditions;
    // urlの定義
    const url = `/api/v1/people/${perid}/results`;

    // 個人検査結果情報取得API呼び出し
    return axios
      .get(url, {
        params: conditions,
      })
      .then((res) => {
        // 成功時は個人検査結果情報取得成功アクションを呼び出す
        const { allcount, perresultitem } = res.data;
        return { count: allcount, perResultGrp: perresultitem };
      });
  },

  // 個人検査結果テーブルを更新する
  updatePerResult: ({ params, data }) => {
    // 個人検査情報登録
    const { perid } = params;
    const method = 'PUT';
    // urlの定義
    const url = `/api/v1/people/${perid}/results`;

    return axios({
      method,
      url,
      data,
    })
      .then(() => ({
        data,
      }));
  },
  // 個人検査結果テーブルを更新する
  mergePerResult: ({ data }) => {
    const { perId, perresult } = data;
    const method = 'POST';
    // urlの定義
    const url = `/api/v1/people/${perId}/results`;

    return axios({
      method,
      url,
      data: perresult,
    });
  },

  // 個人検査結果テーブルを削除する
  deletePerResult: (params) => {
    const { perId } = params;
    const method = 'DELETE';
    // urlの定義
    const url = `/api/v1/people/${perId}/results`;

    return axios({
      method,
      url,
      params: { ...params, itemCd: JSON.stringify(params.itemCd), suffix: JSON.stringify(params.suffix) },
    });
  },
};

export default perResultService;
