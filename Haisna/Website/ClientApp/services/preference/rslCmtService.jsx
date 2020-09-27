import axios from 'axios';


const rslCmtService = {
  getRslCmtListForChangeSet: (conditions) => {
    // 指定汎用コード内グループの結果コメントを取得
    const { rsvno } = conditions;
    // URLの定義
    const url = `/api/v1/consultations/${rsvno}/groups/resultcomments`;
    return axios
      .get(url, {
        params: conditions,
        validateStatus: (status) => (status < 500),
      })
      .then((res) => res.data);
  },
};

export default rslCmtService;
