import axios from 'axios';


const orgGrpService = {
  getOrgGrp_PList: () => {
    // urlの定義
    const url = '/api/v1/organizationgroup/p';
    // ユーザ情報取得API呼び出し
    return axios
      .get(url)
      .then((res) => (res.data));
  },
};

export default orgGrpService;
